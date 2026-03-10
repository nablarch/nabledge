# コード管理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/code.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/BasicCodeManager.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/cache/BasicStaticDataCache.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/BasicCodeLoader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/schema/CodePatternSchema.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/CodeUtil.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/validator/ee/CodeValue.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/validator/CodeValue.html)

## 機能概要

アプリケーションで使用する**値と名称**とのマッピングを管理する機能を提供する。

例：

| 値 | 名称 | 略称 |
|---|---|---|
| male | 男性 | 男 |
| female | 女性 | 女 |

> **重要**: この機能では静的なコード情報（値と名称のマッピング）を管理する。「商品コード」「企業コード」のように値に紐づく情報が動的に変化するものは管理対象外。そのような情報はアプリケーションでマスタテーブルを作成して対処すること。

> **重要**: この機能を使用すると、コードの名称を持つテーブルとコード値を持つテーブルにRDBMSの参照整合性制約を設定できない。制約チェックには :ref:`code-validation` を使用すること。

> **補足**: 静的なコード情報はenumで表現した方が良い。理由：(1) DBを使用したコード定義は大掛かりでメンテナンスコストが高い (2) Javaでコード値を扱うための数値型定数定義と二重メンテナンスが発生する。NablarchはenumとDBの相互変換機能を持っていないが、Domaを使用することでenumの値をDB登録できる。設定は :ref:`doma_adaptor` を参照。

**国際化対応**: 言語ごとに名称を管理可能。詳細は :ref:`code-use_multilingualization` を参照。

**テーブル管理**: 値および名称の情報をDBで管理する。事前にテーブルを作成し、静的なコード情報を登録しておく必要がある。詳細は :ref:`code-setup_table` を参照。

<details>
<summary>keywords</summary>

コード管理, コード値名称マッピング, 値, 名称, 略称, 国際化対応, 多言語化, 参照整合性制約, code-validation, doma_adaptor, テーブル管理

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-code</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-code-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-common-code, nablarch-common-code-jdbc, モジュール依存関係, Maven

</details>

## コード管理機能を使用する為の初期設定

## コード管理機能を使用する為の初期設定

コード情報は `コードパターンテーブル` と `コード名称テーブル` の2テーブルで管理する。

各カラムの用途:

| カラム | 説明 |
|---|---|
| ID | コード情報を一意に識別するID（性別区分・住所区分等ごとに一意のIDを設定） |
| VALUE | コード内の名称を識別する値（例: `male`, `female`） |
| PATTERN | 値を使用するか否かのフラグ（`0`または`1`）。有効な値の切り替えに使用。省略可能。 |
| LANG | 言語。多言語化対応時に`Locale#getLanguage()`の値を格納。日本語のみの場合は`ja`を設定。 |
| SORT_ORDER | ソート順。IDに紐づく一覧取得時にSORT_ORDER昇順で返される。 |
| NAME | VALUEに対応した名称 |
| SHORT_NAME | VALUEに対応した略称 |
| OPTIONAL_NAME | 名称・略称だけでは管理しきれない場合に使用するオプション名称。カラム名・数は必要数定義可能。 |

**設定ポイント**:
- `BasicCodeManager` のコンポーネント名は **codeManager** とすること
- `BasicStaticDataCache` の `loadOnStartup` 設定は :ref:`static_data_cache-cache_timing` を参照すること
- `BasicCodeLoader` および `BasicStaticDataCache` は初期化が必要なため初期化リストに設定すること

```xml
<component name="codeLoader" class="nablarch.common.code.BasicCodeLoader">
  <property name="codePatternSchema">
    <component class="nablarch.common.code.schema.CodePatternSchema">
      <!-- CodePatternSchemaのプロパティにテーブル名及びカラム名を設定する。 -->
    </component>
  </property>
  <property name="codeNameSchema">
    <component class="nablarch.common.code.schema.CodeNameSchema">
      <!-- CodeNameSchemaのプロパティにテーブル名及びカラム名を設定する。 -->
    </component>
  </property>
</component>

<component name="codeCache" class="nablarch.core.cache.BasicStaticDataCache">
  <property name="loader" ref="codeLoader"/>
  <property name="loadOnStartup" value="false"/>
</component>

<component name="codeManager" class="nablarch.common.code.BasicCodeManager">
  <property name="codeDefinitionCache" ref="codeCache"/>
</component>

<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="codeLoader"/>
      <component-ref name="codeCache"/>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

BasicCodeManager, BasicStaticDataCache, BasicCodeLoader, CodePatternSchema, CodeNameSchema, BasicApplicationInitializer, コード管理機能設定, コードパターンテーブル, コード名称テーブル, 初期設定, codeManager, loadOnStartup

</details>

## 機能毎に使用するコード情報を切り替える

## 機能毎に使用するコード情報を切り替える

コードパターンテーブルにパターン列を定義し、パターンを切り替えることで機能ごとに表示・非表示を切り替えられる。

パターン列は `CodePatternSchema.patternColumnNames` に設定する（設定方法は :ref:`code-setup_table` を参照）。

パターン指定でコード情報を取得（Java）:

```java
// PATTERN1のリストを取得: [MALE, FEMALE, OTHER]
List<String> pattern1 = CodeUtil.getValues("GENDER", "PATTERN1");

// PATTERN2のリストを取得: [MALE, FEMALE]
List<String> pattern2 = CodeUtil.getValues("GENDER", "PATTERN2");
```

パターン名は設定ファイルで設定したカラム名と**厳密に一致**させること。

画面（JSP）でパターンを指定する場合は `pattern` 属性に指定する:

```jsp
<n:codeSelect name="form.gender" codeId="GENDER" pattern="PATTERN2" cssClass="form-control" />
```

カスタムタグライブラリの詳細は :ref:`tag-code_input_output` を参照。

<details>
<summary>keywords</summary>

CodeUtil, パターン切り替え, CodePatternSchema, patternColumnNames, getValues, codeSelect, pattern属性, PATTERN1, PATTERN2

</details>

## 名称の多言語化対応

## 名称の多言語化対応

コード名称テーブルにサポートする言語ごとのデータを準備する（LANGカラムに言語を設定）。

```java
// 名称
CodeUtil.getName("GENDER", "MALE", Locale.JAPANESE);    // -> 男性
CodeUtil.getName("GENDER", "MALE", Locale.ENGLISH);     // -> Male

// 略称
CodeUtil.getShortName("GENDER", "MALE", Locale.JAPANESE); // -> 男
CodeUtil.getShortName("GENDER", "MALE", Locale.ENGLISH);  // -> M
```

> **重要**: JSP用カスタムタグライブラリでは言語指定による値の取得はできない。カスタムタグライブラリが使用する言語情報の詳細は :ref:`tag-code_input_output` を参照。

<details>
<summary>keywords</summary>

CodeUtil, 多言語化対応, getName, getShortName, Locale, LANG, 言語指定

</details>

## 画面などで表示する名称のソート順を定義する

## 画面などで表示する名称のソート順を定義する

ソート順はコード名称テーブルのSORT_ORDERカラムに設定する。言語ごとに設定可能（国によってソート順が異なる場合に対応）。IDに紐づく一覧取得時にSORT_ORDER昇順で返される。

<details>
<summary>keywords</summary>

SORT_ORDER, ソート順定義, コード名称テーブル, codeSelect

</details>

## 名称、略称以外の名称を定義する

## 名称、略称以外の名称を定義する

オプション名称カラムをコード名称テーブルに追加して対応する。オプション名称カラム名は `CodePatternSchema.patternColumnNames` に設定する（設定方法は :ref:`code-setup_table` を参照）。

```java
CodeUtil.getOptionalName("GENDER", "MALE", "KANA_NAME"); // -> おとこ
CodeUtil.getOptionalName("GENDER", "FEMALE", "FORM_NAME", Locale.JAPANESE); // -> Female
```

JSPで表示する場合は `optionColumnName` にカラム名、`labelPattern` に **$OPTIONALNAME$** を指定する:

```jsp
<n:codeSelect name="form.gender" codeId="GENDER" optionColumnName="KANA_NAME" cssClass="form-control" labelPattern="$OPTIONALNAME$"/>
```

<details>
<summary>keywords</summary>

CodeUtil, getOptionalName, オプション名称, OPTIONAL_NAME, optionColumnName, labelPattern, FORM_NAME, KANA_NAME, CodePatternSchema, patternColumnNames

</details>

## 入力値が有効なコード値かチェックする

## 入力値が有効なコード値かチェックする

**アノテーション**: `nablarch.common.code.validator.ee.CodeValue`（Bean Validation用）、`nablarch.common.code.validator.CodeValue`（Nablarch Validation用）

Bean Validation（:ref:`bean_validation`）:

```java
@CodeValue(codeId = "GENDER")
private String gender;
```

Nablarch Validation（:ref:`nablarch_validation`）:

```java
@CodeValue(codeId = "GENDER")
public void setGender(String gender) {
  this.gender = gender;
}
```

パターンを使用して選択値を制限した場合、バリデーション時も同パターン内の有効値かチェックする必要がある。`pattern` 属性にパターン名を指定する:

```java
@CodeValue(codeId = "GENDER", pattern = "PATTERN2")
private String gender;
```

> **補足**: :ref:`ドメインバリデーション <bean_validation-domain_validation>` を使用した場合、1つのドメインに対して1つのパターンしか指定できない。複数パターンに対応するには、パターンごとにドメインを定義する必要がある（バリデーションで必要なドメインのみ定義すればよい）。

```java
public class SampleDomainBean {
  @CodeValue(codeId = "FLOW_STATUS", pattern = "PATTERN1")
  String flowStatusGeneral;

  @CodeValue(codeId = "FLOW_STATUS", pattern = "PATTERN2")
  String flowStatusGuest;
}
```

<details>
<summary>keywords</summary>

@CodeValue, バリデーション, CodeValue, bean_validation, nablarch_validation, pattern属性, SampleDomainBean, ドメインバリデーション

</details>
