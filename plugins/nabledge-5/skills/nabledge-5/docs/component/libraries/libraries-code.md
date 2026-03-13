# コード管理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/code.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/BasicCodeManager.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/cache/BasicStaticDataCache.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/schema/CodePatternSchema.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/CodeUtil.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/schema/CodeNameSchema.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/validator/ee/CodeValue.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/validator/CodeValue.html)

## 機能概要

値と名称（略称）のマッピング情報を管理する機能。

> **重要**: 静的なコード情報（値と名称のマッピング）のみ管理対象。「商品コード」「企業コード」のような動的に変化する情報は管理対象外。動的情報はアプリケーション側でマスタテーブルを作成して対処すること。

> **重要**: この機能を使用すると、コードの名称を持つテーブルとコード値を持つテーブルにRDBMSの参照整合性制約を設定できない。この制約のチェックには [code-validation](#) を使用すること。

> **補足**: 静的コード情報にはenumの使用を推奨。DBを使ったコード定義はメンテナンスコストが高く、Java上のコード値定数との二重メンテナンスが発生する。ただし、NablarchにはenumとDB値の相互変換機能がない。enumをDBに登録するには [doma_adaptor](../adapters/adapters-doma_adaptor.md) を参照して設定すること。

**国際化対応**: 言語ごとに名称を管理できる。

**テーブル管理**: 値と名称の情報をDB上で管理する。事前にDBにテーブルを作成し、静的なコード情報を登録しておくこと。

## コード管理機能を使用する為の初期設定

コードパターンテーブルとコード名称テーブルの2テーブルを使用する。

| カラム | 用途 |
|---|---|
| ID | コード情報を一意に識別するID（性別区分・住所区分ごとに一意） |
| VALUE | コード情報内の名称を識別する値（例: male, female） |
| PATTERN | 値を使用するか否かのフラグ（0 or 1）。不要な場合省略可能 |
| LANG | 言語（日本語のみの場合 `ja`） |
| SORT_ORDER | ソート順（昇順で返される） |
| NAME | 名称 |
| SHORT_NAME | 略称 |
| OPTIONAL_NAME | オプション名称（カラム名・数は必要数定義可） |

設定のポイント:
- `BasicCodeManager` のコンポーネント名は **codeManager** とすること
- `BasicStaticDataCache` の `loadOnStartup` 設定は [static_data_cache-cache_timing](libraries-static_data_cache.md) 参照
- `BasicStaticDataCache` は初期化が必要なため初期化対象リストに設定すること

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

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="codeCache"/>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

コード管理, 値と名称のマッピング, 国際化対応, コードテーブル, 参照整合性制約, DomaAdaptor, 静的コード情報, enum推奨, BasicCodeLoader, BasicCodeManager, BasicStaticDataCache, BasicApplicationInitializer, CodePatternSchema, CodeNameSchema, codeManager, codeDefinitionCache, loadOnStartup, コード管理初期設定, コードパターンテーブル, コード名称テーブル

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

## 機能毎に使用するコード情報を切り替える

コードパターンテーブルのパターンカラムで機能ごとに表示・非表示を切り替える。パターン名は設定ファイルで設定したカラム名と**厳密に一致**させる必要がある。

パターン列は `CodePatternSchema.patternColumnNames` に設定することで使用可能（設定方法は [code-setup_table](#) 参照）。

```java
// PATTERN1のリスト（OTHERを含む）を取得
List<String> pattern1 = CodeUtil.getValues("GENDER", "PATTERN1");
// PATTERN2のリスト（OTHERを非表示）を取得
List<String> pattern2 = CodeUtil.getValues("GENDER", "PATTERN2");
```

JSPでのパターン指定（`pattern`属性）:
```jsp
<n:codeSelect name="form.gender" codeId="GENDER" pattern="PATTERN2" cssClass="form-control" />
```

<details>
<summary>keywords</summary>

nablarch-common-code, nablarch-common-code-jdbc, Maven依存関係, モジュール, CodeUtil, CodePatternSchema, patternColumnNames, PATTERN, codeSelect, コードパターン切り替え, getValues

</details>

## 名称の多言語化対応

## 名称の多言語化対応

コード名称テーブルにサポートする言語ごとのデータを準備する（LANG列に言語コードを設定）。

```java
CodeUtil.getName("GENDER", "MALE", Locale.JAPANESE);       // -> 男性
CodeUtil.getName("GENDER", "MALE", Locale.ENGLISH);        // -> Male
CodeUtil.getShortName("GENDER", "MALE", Locale.JAPANESE);  // -> 男
CodeUtil.getShortName("GENDER", "MALE", Locale.ENGLISH);   // -> M
```

> **重要**: JSPカスタムタグライブラリでは言語指定による値の取得はできない。詳細は :ref:`tag-code_input_output` を参照。

<details>
<summary>keywords</summary>

CodeUtil, getName, getShortName, Locale, LANG, 多言語化対応

</details>

## 画面などで表示する名称のソート順を定義する

## 画面などで表示する名称のソート順を定義する

ソート順はコード名称テーブルのSORT_ORDERカラムに設定する（昇順で返される）。国ごとに異なる可能性があるため、言語ごとに設定可能。

カスタムタグライブラリの `codeSelect` を使用した場合は、SORT_ORDERの昇順（例: `MALE(男性)` → `FEMALE(女性)` → `OTHER(その他)`）で表示される。

<details>
<summary>keywords</summary>

SORT_ORDER, ソート順定義, codeSelect

</details>

## 名称、略称以外の名称を定義する

## 名称、略称以外の名称を定義する

コード名称テーブルにオプション名称カラムを定義し、 `CodePatternSchema.patternColumnNames` に設定することで使用可能（設定方法は [code-setup_table](#) 参照）。オプション名称取得時は設定ファイルで設定したカラム名と**厳密に一致**させる必要がある。

```java
CodeUtil.getOptionalName("GENDER", "MALE", "KANA_NAME");                    // -> おとこ
CodeUtil.getOptionalName("GENDER", "FEMALE", "FORM_NAME", Locale.JAPANESE); // -> Female
```

JSPでのオプショナル名称表示（`optionColumnName`と`labelPattern="$OPTIONALNAME$"`を指定）:
```jsp
<n:codeSelect name="form.gender" codeId="GENDER" optionColumnName="KANA_NAME" cssClass="form-control" labelPattern="$OPTIONALNAME$"/>
```

<details>
<summary>keywords</summary>

CodeUtil, getOptionalName, OPTIONAL_NAME, optionColumnName, labelPattern, OPTIONALNAME, オプション名称, CodePatternSchema, patternColumnNames

</details>

## 入力値が有効なコード値かチェックする

## 入力値が有効なコード値かチェックする

バリデーションアノテーションのみでコードの有効範囲内かをチェックできる。

**[bean_validation](libraries-bean_validation.md) を使用する場合** — **アノテーション**: `nablarch.common.code.validator.ee.CodeValue`

```java
@CodeValue(codeId = "GENDER")
private String gender;
```

**[nablarch_validation](libraries-nablarch_validation.md) を使用する場合** — **アノテーション**: `nablarch.common.code.validator.CodeValue`

```java
@CodeValue(codeId = "GENDER")
public void setGender(String gender) { this.gender = gender; }
```

`pattern`属性でパターン内の有効値かをチェック可能:
```java
@CodeValue(codeId = "GENDER", pattern = "PATTERN2")
private String gender;
```

> **補足**: [ドメインバリデーション](libraries-bean_validation.md) では1ドメインに1パターンのみ指定可能。複数パターンに対応する場合は、パターンごとにドメインを定義すること（バリデーションで必要なもののみ定義すれば良い）。
>
> ```java
> public class SampleDomainBean {
>
>   // PATTERN1用のドメイン
>   @CodeValue(codeId = "FLOW_STATUS", pattern = "PATTERN1")
>   String flowStatusGeneral;
>
>   // PATTERN2用のドメイン
>   @CodeValue(codeId = "FLOW_STATUS", pattern = "PATTERN2")
>   String flowStatusGuest;
>
> }
> ```

<details>
<summary>keywords</summary>

@CodeValue, bean_validation, nablarch_validation, CodeValue, pattern, コードバリデーション, ドメインバリデーション, SampleDomainBean, FLOW_STATUS

</details>
