# デフォルト設定値からの設定変更方法

**公式ドキュメント**: [デフォルト設定値からの設定変更方法](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/setting_guide/CustomizingConfigurations/index.html)

## 設定ファイルの構成とカスタマイズのパターン

## 設定ファイルの構成

- **デフォルトコンフィグレーション(jar)**: `nablarch-main-default-configuration-XXXX.jar`、`nablarch-testing-default-configuration-XXXX.jar` などjar形式でMavenアーティファクトとして配布される。プレースホルダーに設定値がある項目、プレースホルダーのみ定義されている項目、変更頻度が極めて低いためプレースホルダー化されず直接値が設定されている項目が存在する。
- **PJ成果物**: アーキタイプ使用時にデフォルトコンフィギュレーション(jar)への依存関係があらかじめ設定される。コンポーネント設定ファイルには初期値が設定された状態で提供される。

## カスタマイズのパターン

設定ファイルのカスタマイズ方法には以下の4パターンがある：

1. [how_to_customize_config_files](#) — 環境設定値の書き換え
2. [how_to_customize_overwite_config_files](#s2) — 環境設定値の上書き
3. [how_to_customize_overwite_componet_file](#s3) — コンポーネント定義の上書き
4. [how_to_customize_handler_queue](#s4) — ハンドラ構成のカスタマイズ

<details>
<summary>keywords</summary>

設定ファイルの構成, デフォルトコンフィグレーション, カスタマイズパターン, プレースホルダー, how_to_customize_config_files, how_to_customize_overwite_config_files, how_to_customize_overwite_componet_file, how_to_customize_handler_queue

</details>

## 環境設定値の書き換え

PJで変更する頻度が高い環境設定値は、ブランクプロジェクトの環境設定ファイルに設定されている。

1. **TODOコメントのある設定項目を修正**: DBの接続設定等、プロジェクト毎にほぼ確実に修正する箇所には、環境設定ファイル(propertiesファイル)にTODOコメントが埋め込まれているため、設定値を修正する。
2. **デフォルト値でPJ要件を満たせない場合**: :download:`デフォルト設定一覧 <../../configuration/デフォルト設定一覧.xlsx>` を確認し、環境設定ファイル(configファイル)を修正する。

設定項目名の命名ルールは [config_key_naming](setting-guide-config_key_naming.md) を参照。

<details>
<summary>keywords</summary>

環境設定値の書き換え, TODOコメント, propertiesファイル, configファイル, デフォルト設定一覧, config_key_naming

</details>

## 環境設定値の上書き

デフォルトコンフィグレーションの環境設定ファイル(config)で設定されている環境設定値を上書きするには、同名のプレースホルダーで再定義する。

:download:`デフォルト設定一覧 <../../configuration/デフォルト設定一覧.xlsx>` でデフォルトコンフィグレーションで設定されている内容が確認できる。

<details>
<summary>keywords</summary>

環境設定値の上書き, プレースホルダー再定義, デフォルト設定一覧

</details>

## コンポーネント定義の上書き

以下の場合にPJ成果物のコンポーネント設定ファイルにコンポーネント定義ごと再定義する：
- 変更したいコンポーネントのプロパティがプレースホルダー化されていない場合
- コンポーネント自体をプロジェクトでカスタマイズした別のクラスに変更したい場合

:download:`デフォルト設定一覧 <../../configuration/デフォルト設定一覧.xlsx>` でプレースホルダーが使われていない設定を確認できる。

### 手順1: 同名のコンポーネントを定義する

デフォルトコンフィグレーションのコンポーネント定義(xml)から変更対象コンポーネントを特定し、そのコンポーネント名で再定義する。

例として、以下のコンポーネントを差し替える場合、コンポーネント名は `idGenerator` であるとわかる：

```xml
<!-- 採番モジュールの設定 -->
<component name="idGenerator"
    class="nablarch.common.idgenerator.TableIdGenerator">
  <!-- 採番テーブルの定義 -->
  <property name="tableName" value="ID_GENERATE" />
  <property name="idColumnName" value="ID" />
  <property name="noColumnName" value="NO" />
</component>
```

任意のコンポーネント設定ファイルに、差し替えたいコンポーネントと同名のコンポーネントを定義する：

**【再定義ファイルの中身】**

```xml
<!-- 採番モジュールの設定(oracle sequenceを使用する) -->
<component name="idGenerator"
           class="com.example.common.idgenerator.OracleSequenceIdGenerator">
  <property name="idTable">
    <map>
      <entry key="1101" value="USER_ID_SEQ"/>
    </map>
  </property>
</component>
```

> **補足**: 同名のコンポーネント定義が複数存在する場合は、後に記述した設定が優先される。この仕様を使用してコンポーネントを再定義する。

### 手順2: 作成したコンポーネント設定ファイルの読み込み

PJのコンポーネント設定ファイルで `<import>` を使い、デフォルト定義の後に配置してデフォルトを上書きする：

```xml
<!-- 採番機能 -->
<import file="nablarch/common/idgenerator.xml" />

<!-- PJのコンポーネント定義を読み込み、デフォルトのコンポーネント定義を上書きする -->
<import file="pj_component.xml"/>
```

<details>
<summary>keywords</summary>

コンポーネント定義の上書き, コンポーネントの再定義, idGenerator, TableIdGenerator, OracleSequenceIdGenerator, importファイル, 同名コンポーネント優先

</details>

## ハンドラ構成のカスタマイズ

生成されたコンポーネントのハンドラ構成をもとに、PJに必要なハンドラ構成を検討する。

カスタマイズ例：
- フィーチャフォン対応のための専用ハンドラの追加
- PJで使用しない機能のハンドラの除外

Mavenアーキタイプで生成されたコンポーネント設定ファイル (`XXX_component_configuration.xml`) に最小ハンドラ構成が定義されている。PJでハンドラ構成を変更する場合、このファイルを編集する。

<details>
<summary>keywords</summary>

ハンドラ構成のカスタマイズ, XXX_component_configuration.xml, 最小ハンドラ構成, ハンドラ追加, ハンドラ除外

</details>
