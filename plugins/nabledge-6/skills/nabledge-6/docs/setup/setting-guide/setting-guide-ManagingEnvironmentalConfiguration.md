# 処理方式、環境に依存する設定の管理方法

## アプリケーション設定の整理

アプリケーション設定を以下の2つの観点で整理することを推奨。

| 観点 | 具体例 | 説明 |
|---|---|---|
| 処理方式 | オンライン、バッチ | 処理方式が異なると、コンポーネント定義およびその環境設定値が異なる。 |
| 環境 | 開発環境、本番環境 | コンポーネント定義の一部を変更する必要がある(モック化など)。 |

![処理方式と環境の設定差異](../../knowledge/setup/setting-guide/assets/setting-guide-ManagingEnvironmentalConfiguration/method_and_staging.png)

## アプリケーション設定ファイル切り替えの前提

アプリケーション設定ファイルは、処理方式と環境の組み合わせで最小限必要になるものを用意する。

アーキタイプから生成した直後のディレクトリ構造:

```text
web/batch
|
\---src
    +---env
    |   +---dev                    … 開発環境
    |   |   \---env.properties     … 開発環境用の環境設定ファイル(properties)
    |   \---prod                   … 本番環境
    |       \---env.properties     … 本番環境用の環境設定ファイル(properties)
    +---main
    |   \---resources              … 環境毎に差異が存在しないリソース
    |       \---common.properties  … 環境非依存の環境設定ファイル(properties)
    \---test
        \---resources              … ユニットテスト環境
```

> **補足**: 環境非依存の環境設定ファイル(common.properties)は全ての環境で使用する。環境が不足している場合は :ref:`how_to_add_profile` を参照して環境を追加する。実行基盤のプロジェクトから参照される共通プロジェクトを使用している場合、共通プロジェクト単体の環境毎のアプリケーション設定ファイルは不要である。

## アプリケーション設定切り替えの仕組み

Apache Mavenのプロファイル機能でアプリケーション設定ファイルの切り替えを行う。プロファイルは、アーキタイプから生成したプロジェクトに初期状態で定義されている。定義されているプロファイルについては :ref:`mavenModuleStructuresProfilesList` を参照。

**ローカルでのAPサーバ起動時及び成果物生成時(war/jar生成時)**:

```bat
mvn -P prod package -DskipTests=true
```

- `-P`: プロファイル指定
- `-DskipTests=true`: ユニットテストのスキップ

![Mavenによるアプリケーション設定切り替えの動作](../../knowledge/setup/setting-guide/assets/setting-guide-ManagingEnvironmentalConfiguration/switch_application_settings.png)

> **重要**: `src/main/resources`と各環境毎のディレクトリでファイル名が重複した場合は、各環境毎のディレクトリのファイルが優先される。

> **補足**: resources以下のファイルは全てコピーされる（コンポーネント設定ファイル(xml)と環境設定値の定義ファイル(properties)に限らない）。

> **補足**: `META-INF/MANIFEST.MF`に対象環境のエントリ（`Target-Environment`）を追記する設定がある。本番環境を指定してビルドした場合の例:

```none
Manifest-Version: 1.0
Target-Environment:本番環境
```

**ユニットテスト実行時**: 指定したプロファイル及び`src/test/resources`のリソースが使用される。明示的にプロファイルを指定しない場合はデフォルトでdevプロファイルが使用される。

```bat
mvn test
```

## コンポーネント設定ファイル(xmlファイル)の作成方法

コンポーネント設定ファイル(xmlファイル)を切り替えることで、環境ごとのコンポーネント切り替え（モック化など）を実現する。

1. Nablarchが提供するデフォルト設定値をベースに、各処理方式毎に本番用コンポーネント定義を作成する。
2. それらのコンポーネント定義に対して、環境毎に本番からの差分としてコンポーネント定義を作成する。
3. 作成したコンポーネント設定ファイルを環境毎のディレクトリに配置し、ビルド時に差し替える。

## 環境ごとに環境設定値を切り替える方法

環境毎に配置した環境設定ファイル(env.properties)を切り替えることによって実現する。

> **補足**: アーキタイプから生成した直後は、環境毎に変更する可能性が低い設定項目については、common.propertiesに記載されている。common.propertiesに記載されている値を環境毎に変えたい場合は、項目をenv.propertiesに移動(カット＆ペースト)する。

## プロファイルの定義

処理方式毎のプロジェクト(Web、バッチ等)のpom.xmlのprofiles内にプロファイル定義を追加する。

```xml
<profiles>
  <!-- 結合試験環境A -->
  <profile>
    <id>integration-test-a</id>
    <properties>
      <env.name>結合試験環境A</env.name>
      <env.dir>ita</env.dir>
      <env.classifier>ita</env.classifier>
      <webxml.path>src/main/webapp/WEB-INF/web.xml</webxml.path>
    </properties>
  </profile>
</profiles>
```

| 項目 | 説明 |
|---|---|
| id | mavenコマンドを実行する際に指定するプロファイルのID。他のプロファイルと重複しないものを指定する。 |
| env.name | war及びjarファイルのマニフェストに含める環境名。任意の名前をつける。 |
| env.dir | リソースを格納するディレクトリ。 |
| env.classifier | warファイル名、jarファイル名の末尾につける識別子（半角英数）。maven-war-plugin及びmaven-jar-pluginのclassifierプロパティに値を設定することで実現。 |
| webxml.path | 使用するweb.xmlを指定する。JNDIの設定はweb.xmlにも記載が必要で環境差異が発生する可能性があるため設定可能にしている。本番と同一で問題なければ`src/main/webapp/WEB-INF/web.xml`を設定する。 |

## ディレクトリの追加

プロファイルの定義で指定した`env.dir`のディレクトリを`src/env/{env.dir}/resources/`として追加する。例えば`env.dir=ita`（結合試験環境A）のプロファイルを追加した場合は、`src/env/ita/resources/`を作成する。

## アプリケーション設定ファイルの作成及び修正

新規環境のアプリケーション設定ファイルは、類似しているプロファイルのアプリケーション設定ファイルをコピーし、修正して作成する。
