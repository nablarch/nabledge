# デフォルト設定値からの設定変更方法

**公式ドキュメント**: [デフォルト設定値からの設定変更方法](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/setting_guide/CustomizingConfigurations/index.html)

## 設定ファイルの構成

Nablarchの設定は、デフォルトコンフィグレーション内の設定ファイルと、PJ成果物内の設定ファイルで構成される。

**デフォルトコンフィギュレーション（jar）**

`nablarch-main-default-configuration-XXXX.jar` や `nablarch-testing-default-configuration-XXXX.jar` などjar形式でパッケージされ、Mavenのアーティファクトとして配布される。デフォルトコンフィギュレーションに含まれる設定項目は以下の3種類に分類される:

1. **プレースホルダーに対する設定値が設定されている項目**
2. **プレースホルダーのみが定義されている項目**
3. **変更頻度の極めて低い項目** — プレースホルダー化されておらず直接値が設定されている

**PJ成果物**

Nablarchが提供するアーキタイプを使用した場合、デフォルトコンフィギュレーション（jar）への依存関係があらかじめ設定される。PJ成果物のコンポーネント設定ファイルには、アーキタイプから生成した直後の状態で、初期値が設定された状態で提供されている。

<details>
<summary>keywords</summary>

設定ファイル構成, デフォルトコンフィギュレーション, nablarch-main-default-configuration, nablarch-testing-default-configuration, Mavenアーティファクト, プレースホルダー, PJ成果物, アーキタイプ

</details>

## カスタマイズのパターン

PJ成果物の設定ファイルのカスタマイズには以下の4パターンがある。

1. 環境設定値の書き換え
2. 環境設定値の上書き
3. コンポーネント定義の上書き
4. ハンドラ構成のカスタマイズ

<details>
<summary>keywords</summary>

設定変更パターン, カスタマイズ方法, 環境設定値書き換え, コンポーネント定義上書き, ハンドラ構成カスタマイズ

</details>

## 環境設定値の書き換え

PJで変更頻度が高い環境設定値はブランクプロジェクトの環境設定ファイルに設定されている。設定項目名の命名ルールは `config_key_naming` を参照。

**TODOコメントがある設定項目の修正**: DBの接続設定等、プロジェクト毎にほぼ確実に修正する箇所には環境設定ファイル（propertiesファイル）にTODOコメントが埋め込まれているため、設定値を修正する。

**デフォルト値でPJ要件を満たせない場合**: デフォルト設定一覧を確認の上、デフォルト値でPJ要件を満たせない箇所は環境設定ファイル（configファイル）を修正する。

<details>
<summary>keywords</summary>

環境設定値, propertiesファイル, configファイル, TODOコメント, デフォルト設定一覧, config_key_naming

</details>

## 環境設定値の上書き

デフォルトコンフィグレーションの環境設定ファイル（config）で設定されている環境設定値を上書きする場合は、同名のプレースホルダーで再定義する。

デフォルト設定一覧でデフォルトコンフィグレーションで設定されている内容が確認できる。

<details>
<summary>keywords</summary>

環境設定値上書き, プレースホルダー再定義, デフォルトコンフィグレーション, 設定値上書き

</details>

## コンポーネント定義の上書き

以下のいずれかの場合、PJ成果物のコンポーネント設定ファイルに同名のコンポーネントを再定義する:
- 変更したいコンポーネントのプロパティがプレースホルダー化されていない場合
- コンポーネント自体をプロジェクトでカスタマイズした別のクラスに変更したい場合

デフォルト設定一覧でプレースホルダーが使われていない設定を確認できる。

> **補足**: 同名のコンポーネント定義が複数存在する場合は、後に記述した設定が優先される。このNablarchの仕様を利用してコンポーネントを再定義する。

**手順1: 同名のコンポーネントを定義する**

デフォルトコンフィグレーションのコンポーネント定義（XML）から変更対象のコンポーネントを特定し、コンポーネント名を取得する。

例: デフォルトコンフィグレーションに以下のコンポーネントがある場合、コンポーネント名は `idGenerator` とわかる。

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

例: `idGenerator` コンポーネントを `OracleSequenceIdGenerator` に差し替える場合:

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

**手順2（コンポーネント設定ファイルを作成した場合）: 作成したコンポーネント設定ファイルを読み込む**

デフォルトのコンポーネント定義をimportした後に、PJのコンポーネント定義をimportすることで上書きできる:

```xml
<!-- 採番機能 -->
<import file="nablarch/common/idgenerator.xml" />

<!-- PJのコンポーネント定義を読み込み、デフォルトのコンポーネント定義を上書きする -->
<import file="pj_component.xml"/>
```

<details>
<summary>keywords</summary>

コンポーネント定義上書き, 同名コンポーネント再定義, idGenerator, import, コンポーネント設定ファイル, TableIdGenerator, nablarch.common.idgenerator.TableIdGenerator, OracleSequenceIdGenerator

</details>

## ハンドラ構成のカスタマイズ

Mavenアーキタイプによって生成されたコンポーネント設定ファイル（`XXX_component_configuration.xml`）に、当該処理方式における最小ハンドラ構成があらかじめ定義されている。ハンドラ構成を変更する場合はこのファイルを編集する。

カスタマイズ例:
- フィーチャフォン対応を実現するため、専用のハンドラを追加する
- PJで使用しない機能のハンドラを除外する

<details>
<summary>keywords</summary>

ハンドラ構成, ハンドラキュー, XXX_component_configuration.xml, 最小ハンドラ構成, ハンドラ追加除外

</details>
