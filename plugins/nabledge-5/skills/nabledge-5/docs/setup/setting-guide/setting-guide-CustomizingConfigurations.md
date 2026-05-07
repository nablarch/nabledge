# デフォルト設定値からの設定変更方法

**目次**

* 設定ファイルの構成
* カスタマイズ方法

  * カスタマイズのパターン
* カスタマイズ作業手順

  * 環境設定値の書き換え
  * 環境設定値の上書き
  * コンポーネント定義の上書き
  * ハンドラ構成のカスタマイズ
* 設定変更例

## 設定ファイルの構成

Nablarchの設定は、デフォルトコンフィグレーション内の設定ファイルと、PJ成果物内の設定ファイルで構成される。

以下に設定ファイルの構成を示す。

![abstract.png](../../../knowledge/assets/setting-guide-CustomizingConfigurations/abstract.png)

| モジュール | 説明 |
|---|---|
| デフォルトコンフィギュレーション(jar) | nablarch-main-default-configuration-XXXX.jarやnablarch-testing-default-configuration-XXXX.jarなどjar形式でパッケージされ、Mavenのアーティファクトとして配布される。  プレースホルダーに対する設定値が設定されている項目と、プレースホルダーのみが定義されている項目が存在する。  また、変更頻度の極めて低い項目については、プレースホルダー化されておらず直接値が設定されている。 |
| PJ成果物 | Nablarchが提供するアーキタイプを使用した場合、デフォルトコンフィギュレーション(jar)への依存関係があらかじめ設定される。  PJ成果物のコンポーネント設定ファイルには、アーキタイプから生成した直後の状態で、初期値が設定された状態で提供されている。 |

## カスタマイズ方法

### カスタマイズのパターン

PJ成果物の設定ファイルのカスタマイズ方法には、以下のパターンが存在する。

* [環境設定値の書き換え](../../setup/setting-guide/setting-guide-CustomizingConfigurations.md#環境設定値の書き換え)
* [環境設定値の上書き](../../setup/setting-guide/setting-guide-CustomizingConfigurations.md#環境設定値の上書き)
* [コンポーネント定義の上書き](../../setup/setting-guide/setting-guide-CustomizingConfigurations.md#コンポーネント定義の上書き)
* [ハンドラ構成のカスタマイズ](../../setup/setting-guide/setting-guide-CustomizingConfigurations.md#ハンドラ構成のカスタマイズ)

詳細は以降に記載する。

## カスタマイズ作業手順

### 環境設定値の書き換え

PJで変更する頻度が高い環境設定値については、アーキタイプで生成したブランクプロジェクトの環境設定ファイルに設定されている。

設定項目名の命名ルールについては、 [環境設定値の項目名ルール](../../setup/setting-guide/setting-guide-config-key-naming.md) を参照。

* [環境設定値の項目名ルール](../../setup/setting-guide/setting-guide-config-key-naming.md)

#### TODOコメントの埋め込まれている設定項目を修正する

DBの接続設定等、プロジェクト毎にほぼ確実に修正する箇所には、環境設定ファイル(propertiesファイル)にTODOコメントが埋め込まれているため、設定値を修正する。

#### デフォルト値でPJ要件を満たせない場合は、デフォルト値を変更する

[デフォルト設定一覧](../../../knowledge/assets/setting-guide-CustomizingConfigurations/デフォルト設定一覧.xlsx) を確認の上、デフォルト値でPJ要件を満たせない箇所については、環境設定ファイル(configファイル)を修正する。

### 環境設定値の上書き

デフォルトコンフィグレーションの環境設定ファイル(config)で設定されている環境設定値を上書きしたい場合は、同名のプレースホルダーで再定義する。

 [デフォルト設定一覧](../../../knowledge/assets/setting-guide-CustomizingConfigurations/デフォルト設定一覧.xlsx) でデフォルトコンフィグレーションで設定されている内容が確認できる。

### コンポーネント定義の上書き

変更したいデフォルトコンフィグレーションのコンポーネント設定ファイルのコンポーネントのプロパティがプレースホルダー化されていない場合、
もしくはコンポーネント自体をプロジェクトでカスタマイズした別のクラスに変更したい場合、
PJ成果物のコンポーネント設定ファイルにコンポーネント定義ごと再定義する。

 [デフォルト設定一覧](../../../knowledge/assets/setting-guide-CustomizingConfigurations/デフォルト設定一覧.xlsx) でデフォルトコンフィグレーションで、プレースホルダーが使われていない設定を確認できる。

デフォルト設定からコンポーネント定義を変更する必要がある場合、以下の手順に従って
コンポーネントを再定義する。

#### 同名のコンポーネントを定義する

デフォルトコンフィグレーションのコンポーネント定義(xml)から、変更対象となるコンポーネントを特定し、そのコンポーネント名を取得する。

例えば、以下のコンポーネントを差し替える場合、コンポーネント名は `idGenerator` であるとわかる。

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

任意のコンポーネント設定ファイルに、差し替えたいコンポーネントと同名のコンポーネントを定義する。

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

> **Tip:**
> 同名のコンポーネント定義が複数存在する場合は、後に記述した設定が優先される。

> このNablarchの仕様を使用して、コンポーネントを再定義する。

#### (コンポーネント設定ファイルを作成した場合)作成したコンポーネント設定ファイルの読み込み

コンポーネント設定ファイルの記述例を以下に示す。

```xml
  <!-- 前略 -->
  <!-- 採番機能 -->
  <import file="nablarch/common/idgenerator.xml" />

  <!-- PJのコンポーネント定義を読み込み、デフォルトのコンポーネント定義を上書きする -->
  <import file="pj_component.xml"/>

  </component>
</component-configuration>
```

### ハンドラ構成のカスタマイズ

生成されたコンポーネントのハンドラ構成をもとに、PJに必要なハンドラ構成を検討する。

以下にカスタマイズ例を挙げる。

* フィーチャフォン対応を実現するため、専用のハンドラを追加する。
* PJで使用しない機能のハンドラを除外する。

Mavenアーキタイプによって生成されたコンポーネント設定ファイル
( `XXX_component_configuration.xml` )に
当該処理方式における最小ハンドラ構成が予め定義されている。
PJでハンドラ構成を変更する場合、このファイルを編集する。

## 設定変更例

コンポーネント設定ファイルや環境設定ファイル(propertiesファイル)の設定変更の具体例は以下を参照のこと。

* [メッセージID及びメッセージ内容の変更手順](../../setup/setting-guide/setting-guide-CustomizeMessageIDAndMessage.md)
* [使用可能文字の追加手順](../../setup/setting-guide/setting-guide-CustomizeAvailableCharacters.md)
* [Nablarchフレームワークが使用するテーブル名の変更手順](../../setup/setting-guide/setting-guide-CustomizeSystemTableName.md)

* [メッセージID及びメッセージ内容の変更手順](../../setup/setting-guide/setting-guide-CustomizeMessageIDAndMessage.md)
* [使用可能文字の追加手順](../../setup/setting-guide/setting-guide-CustomizeAvailableCharacters.md)
* [Nablarchフレームワークが使用するテーブル名の変更手順](../../setup/setting-guide/setting-guide-CustomizeSystemTableName.md)
