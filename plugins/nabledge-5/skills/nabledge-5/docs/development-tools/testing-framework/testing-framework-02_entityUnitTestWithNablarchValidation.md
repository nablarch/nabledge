# Nablarch Validationに対応したForm/Entityのクラス単体テスト

**公式ドキュメント**: [Nablarch Validationに対応したForm/Entityのクラス単体テスト](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/01_ClassUnitTest/01_entityUnitTest/02_entityUnitTestWithNablarchValidation.html)

## Nablarch Validationに対応したForm/Entityのクラス単体テスト（概要）

NablarchValidationを使用したForm/Entityクラスの単体テスト方法。FormとEntityはほぼ同じ方法でテスト可能。

> **補足**: Form、Entityの責務については各処理方式の責務配置を参照。例: :ref:`application_design`、[nablarch_batch-application_design](../../processing-pattern/nablarch-batch/nablarch-batch-application_design.md)

テストケース表のID: `testShots`（固定）

| カラム名 | 記載内容 |
|---|---|
| title | テストケースのタイトル |
| description | テストケースの簡単な説明 |
| expectedMessageId*n* | 期待するメッセージ（*n*は1からの連番） |
| propertyName*n* | 期待するプロパティ（*n*は1からの連番） |

複数のメッセージを期待する場合、`expectedMessageId2`, `propertyName2` のように数値を増やして右側に追加する。

入力パラメータ表のID: `params`（固定）。テストケース表に対応する入力パラメータを1行ずつ記載する。:ref:`special_notation_in_cell` の記法を使用することで効率的に入力値を作成できる。

![入力パラメータ表の例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_validationTestData.png)

<details>
<summary>keywords</summary>

NablarchValidation, Form単体テスト, Entity単体テスト, nablarch_validation, クラス単体テスト, testShots, params, expectedMessageId, propertyName, テストケース表作成, バリデーションテスト, 入力パラメータ表, special_notation_in_cell

</details>

## Form/Entity単体テストの書き方

## テストデータの作成

- テストデータExcelファイルはテストソースコードと同じディレクトリに同じ名前で格納（拡張子のみ異なる）
- 以下の3シートを使用（各1シート）:
  - 精査テストケース（:ref:`entityUnitTest_ValidationCase`）
  - コンストラクタテストケース（:ref:`entityUnitTest_ConstructorCase`）
  - setter/getterテストケース（:ref:`entityUnitTest_SetterGetterCase`）
- 静的マスタデータ（メッセージデータ、コードマスタ等）はプロジェクト管理データが事前投入済みの前提（個別テストデータとして作成不要）

テストデータ記述方法の詳細: [../../../06_TestFWGuide/01_Abstract](testing-framework-01_Abstract.md)、[../../../06_TestFWGuide/02_DbAccessTest](testing-framework-02_DbAccessTest.md)

## テストクラスの作成

テストクラス作成ルール:
1. パッケージはテスト対象のForm/Entityと同じ
2. クラス名は`{Form/Entityクラス名}Test`
3. `nablarch.test.core.db.EntityTestSupport`を継承

**クラス**: `nablarch.test.core.db.EntityTestSupport`

## 精査対象確認

[nablarch_validation](../../component/libraries/libraries-nablarch_validation.md) で精査対象のプロパティを指定した場合、その指定が正しいかを確認するケースを作成する。

全プロパティに対して単項目精査エラーとなるデータを用意する。テストケース表には全精査対象プロパティ名と各プロパティ単項目精査エラー時のメッセージIDを記載する。

> **補足**: 精査対象プロパティが誤って漏れていた場合、期待したメッセージが出力されないためメッセージIDのアサートが失敗する。精査対象でないプロパティが誤って精査対象となっていた場合は、不正入力による単項目精査エラーが発生し予期しないメッセージが出力される。これにより精査対象の誤りを検知できる。

![テストケース表（精査対象確認）](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_ValidationPropTestCases.png)

入力パラメータ表には全プロパティに対して単項目精査エラーとなる値を記載する。

![入力パラメータ表](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_ValidationPropParams.png)

> **補足**: Form単体テストで別のFormのプロパティを指定する記法:
> - ネストしたFormのプロパティ（例: `SystemUserEntity.userId`）: `sampleForm.systemUser.userId`
> - Form配列の先頭要素のプロパティ（例: `UserTelEntity[]`の先頭）: `sampleForm.userTelArray[0].telNoArea`

## 項目間精査など

:ref:`entityUnitTest_ValidationMethodSpecifyNormal` で行った精査対象指定以外の動作確認（項目間精査など）ケースを作成する。

![項目間精査の正常系ケース例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_RelationalValidation.png)

<details>
<summary>keywords</summary>

EntityTestSupport, nablarch.test.core.db.EntityTestSupport, テストクラス作成ルール, テストデータExcel, SystemAccountEntity, クラス命名規則, 精査対象確認, 単項目精査, 項目間精査, バリデーションテストデータ, ネストFormプロパティ指定, SystemUserEntity, UserTelEntity, entityUnitTest_ValidationMethodSpecifyNormal

</details>

## 文字種と文字列長の単項目精査テストケース表の作成方法

> **補足**: プロパティとして別のFormを保持するFormには使用不可。その場合は独自に精査処理のテストを実装すること。別のFormを保持するFormとは、`<親Form>.<子Form>.<子フォームのプロパティ名>`の形式でプロパティにアクセスする親Formのこと。

テストケース表のカラム:

| カラム名 | 記載内容 |
|---|---|
| propertyName | テスト対象のプロパティ名 |
| allowEmpty | そのプロパティが未入力を許容するか |
| min | 許容する最小文字列長（省略可） |
| max | 許容する最大文字列長 |
| messageIdWhenEmptyInput | 未入力時に期待するメッセージID（省略可） |
| messageIdWhenInvalidLength | 文字列長不適合時に期待するメッセージID（省略可） |
| messageIdWhenNotApplicable | 文字種不適合時に期待するメッセージID |
| 半角英字 | 半角英字を許容するか |
| 半角数字 | 半角数字を許容するか |
| 半角記号 | 半角記号を許容するか |
| 半角カナ | 半角カナを許容するか |
| 全角英字 | 全角英字を許容するか |
| 全角数字 | 全角数字を許容するか |
| 全角ひらがな | 全角ひらがなを許容するか |
| 全角カタカナ | 全角カタカナを許容するか |
| 全角漢字 | 全角漢字を許容するか |
| 全角記号その他 | 全角記号その他を許容するか |
| 外字 | 外字を許容するか |

文字種許容値: `o`（半角英小文字のオー＝許容）、`x`（半角英小文字のエックス＝不許容）

messageIdWhenEmptyInput省略時: :ref:`entityUnitTest_EntityTestConfiguration` で設定したemptyInputMessageIdの値を使用。

messageIdWhenInvalidLength省略時のデフォルト値:

| min欄の記載 | maxとminの比較 | 省略時に使用されるデフォルト値 |
|---|---|---|
| なし | (該当なし) | maxMessageId |
| あり | max > min | maxAndMinMessageId（超過時）、underLimitMessageId（不足時） |
| あり | max = min | fixLengthMessageId |

テストケース表の例: ![テストケース表の例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_CharsetAndLengthExample.png)

テスト対象エンティティクラスと呼び出しパラメータを変数として定義し、`testValidateAndConvert` を呼び出す。変数内容を変更するだけで異なるEntityの精査テストに対応できる。

```java
private static final Class<SystemAccountEntity> ENTITY_CLASS = SystemAccountEntity.class;

@Test
public void testValidateForRegisterUser() {
    String sheetName = "testValidateForRegisterUser";
    String validateFor = "registerUser";
    testValidateAndConvert(ENTITY_CLASS, sheetName, validateFor);
}
```

<details>
<summary>keywords</summary>

propertyName, allowEmpty, messageIdWhenEmptyInput, messageIdWhenInvalidLength, messageIdWhenNotApplicable, 文字種精査, 文字列長精査, entityUnitTest_EntityTestConfiguration, maxMessageId, fixLengthMessageId, maxAndMinMessageId, underLimitMessageId, testValidateAndConvert, SystemAccountEntity, EntityTestSupport, テストメソッド作成, validateFor, sheetName

</details>

## 文字種と文字列長の単項目精査テストメソッドの作成方法

**クラス**: `nablarch.test.core.db.EntityTestSupport`

メソッドシグネチャ:

```java
void testValidateCharsetAndLength(Class entityClass, String sheetName, String id)
```

使用例:

```java
@Test
public void testCharsetAndLength() {
    String sheetName = "testCharsetAndLength";
    String id = "charsetAndLength";
    testValidateCharsetAndLength(ENTITY_CLASS, sheetName, id);
}
```

テストデータの各行に対して実行される観点:

| 観点 | 入力値 | 備考 |
|---|---|---|
| 文字種（半角英字〜外字の各種） | max長の各文字種で構成された文字列 | |
| 未入力 | 空文字（長さ0） | |
| 最小文字列 | 最小文字列長の文字列 | o印の文字種で構成。min省略時は文字列長不足テストを実行しない |
| 最長文字列 | 最大文字列長の文字列 | o印の文字種で構成 |
| 文字列長不足 | 最小文字列長−1の文字列 | |
| 文字列長超過 | 最大文字列長+1の文字列 | |

[nablarch_validation-execute](../../component/libraries/libraries-nablarch_validation.md) に記載のとおり、Nablarch ValidationのEntityには `Map<String, Object>` を引数にとるコンストラクタが実装されており、このコンストラクタに対するテストを作成する必要がある。対象プロパティはEntityに定義されている全プロパティ。

> **補足**: Entityは自動生成されるため、アプリケーションで使用されないコンストラクタが生成される可能性がある。その場合リクエスト単体テストではテストできないため、Entity単体テストでコンストラクタのテストを必ず行うこと。一般的なFormはリクエスト単体テストでコンストラクタテスト可能なため、クラス単体テストでのコンストラクタテストは不要。

テストデータにはプロパティ名、コンストラクタに設定する値、期待値（getterから取得される値）を用意する。

| プロパティ | コンストラクタに設定する値 | 期待値（getterから取得される値） |
|---|---|---|
| userId | userid | userid |
| loginId | loginid | loginid |
| password | password | password |

![ExcelへのConstructor定義例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_Constructor.png)

テストコード: `testConstructorAndGetter(entityClass, sheetName, id)` を呼び出す。

```java
public class SystemAccountEntityTest extends EntityTestSupport {
    @Test
    public void testConstructor() {
        Class<?> entityClass = SystemAccountEntity.class;
        String sheetName = "testAccessor";
        String id = "testConstructor";
        testConstructorAndGetter(entityClass, sheetName, id);
    }
}
```

> **補足**: `testConstructorAndGetter` でテスト可能なプロパティの型:
> - `String` およびその配列
> - `BigDecimal` およびその配列
> - `java.util.Date` およびその配列（Excel記述: `yyyy-MM-dd` または `yyyy-MM-dd HH:mm:ss` 形式）
> - `valueOf(String)` メソッドを持つクラスおよびその配列（`Integer`、`Long`、`java.sql.Date`、`java.sql.Timestamp` など）
>
> 上記以外の型（例: `List<String>`）は、各テストクラスでコンストラクタとgetterを明示的に呼び出してテストする必要がある。

`List<String>` 型プロパティの個別テスト例（`getParamMap` でテストデータ取得。テスト対象のプロパティが複数ある場合は `getListParamMap` を使用する）:

```java
Map<String, String[]> data = getParamMap(sheetName, "testConstructorOther");
Map<String, Object> params = new HashMap<String, Object>();
params.put("users", Arrays.asList(data.get("set")));
SystemAccountEntity entity = new SystemAccountEntity(params);
assertEquals(entity.getUsers(), Arrays.asList(data.get("get")));
```

![ConstructorOtherのExcel例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_ConstructorOther.png)

<details>
<summary>keywords</summary>

testValidateCharsetAndLength, EntityTestSupport, 文字種テスト実行, 文字列長テスト, testCharsetAndLength, testConstructorAndGetter, SystemAccountEntity, SystemAccountEntityTest, getParamMap, getListParamMap, コンストラクタテスト, Map<String, Object>引数コンストラクタ, testConstructorAndGetter対応型

</details>

## その他の単項目精査テストケース表の作成方法

数値入力項目の範囲精査など文字種・文字列長以外の単項目精査に対して、入力値と期待メッセージIDのペアを記述することで任意の値でテストできる。

> **補足**: プロパティとして別のFormを保持するFormには使用不可。その場合は独自に精査処理のテストを実装すること。別のFormを保持するFormとは、`<親Form>.<子Form>.<子フォームのプロパティ名>`の形式でプロパティにアクセスする親Formのこと。

テストケース表のカラム:

| カラム名 | 記載内容 |
|---|---|
| propertyName | テスト対象のプロパティ名 |
| case | テストケースの簡単な説明 |
| input1（input2, input3...） | 入力値（ひとつのキーに複数パラメータを指定する場合はinput2, input3とカラムを増やす） |
| messageId | 単項目精査した場合に発生すると期待するメッセージID（精査エラーにならない場合は空欄） |

入力値には :ref:`special_notation_in_cell` の記法を使用可能。

テストケース表の例: ![テストケース表の例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_singleValidationDataExample.png)

**クラス**: `nablarch.test.core.entity.EntityTestConfiguration`

:ref:`entityUnitTest_ValidationCase` 実施に必要な初期値設定。コンポーネント設定ファイルで設定する（全項目必須）。設定するメッセージIDはバリデータの設定値と合致させること。

| 設定項目名 | 説明 |
|---|---|
| maxMessageId | 最大文字列長超過時のメッセージID |
| maxAndMinMessageId | 最長最小文字列長範囲外のメッセージID（可変長） |
| fixLengthMessageId | 最長最小文字列長範囲外のメッセージID（固定長） |
| underLimitMessageId | 文字列長不足時のメッセージID |
| emptyInputMessageId | 未入力時のメッセージID |
| characterGenerator | 文字列生成クラス（`nablarch.test.core.util.generator.CharacterGenerator` の実装クラスを指定。通常は `nablarch.test.core.util.generator.BasicJapaneseCharacterGenerator` を使用） |

<details>
<summary>keywords</summary>

propertyName, messageId, input1, testSingleValidation, 数値範囲精査, 単項目精査, special_notation_in_cell, EntityTestConfiguration, maxMessageId, maxAndMinMessageId, fixLengthMessageId, underLimitMessageId, emptyInputMessageId, characterGenerator, CharacterGenerator, BasicJapaneseCharacterGenerator, バリデーション設定

</details>

## その他の単項目精査テストメソッドの作成方法とバリデーションメソッドのテスト

**クラス**: `nablarch.test.core.db.EntityTestSupport`

メソッドシグネチャ:

```java
void testSingleValidation(Class entityClass, String sheetName, String id)
```

使用例:

```java
@Test
public void testSingleValidation() {
    String sheetName = "testSingleValidation";
    String id = "singleValidation";
    testSingleValidation(ENTITY_CLASS, sheetName, id);
}
```

## バリデーションメソッドのテストケース

上記の単項目精査テストではエンティティのセッターメソッドに付与されたアノテーションのみがテストされ、エンティティに実装した`@ValidateFor`アノテーション付きstaticバリデーションメソッドはテストされない。独自のバリデーションメソッドを実装した場合は別途テストを作成する必要がある。

**アノテーション**: `@ValidateFor`

精査クラスのコンポーネント設定ファイル例:

```xml
<property name="validators">
  <list>
    <component class="nablarch.core.validation.validator.RequiredValidator">
      <property name="messageId" value="MSG00010"/>
    </component>
    <component class="nablarch.core.validation.validator.LengthValidator">
      <property name="maxMessageId" value="MSG00011"/>
      <property name="maxAndMinMessageId" value="MSG00011"/>
      <property name="fixLengthMessageId" value="MSG00023"/>
    </component>
    <!-- 中略 -->
  </list>
</property>
```

テストのコンポーネント設定ファイル例（EntityTestConfiguration設定）:

```xml
<component name="entityTestConfiguration" class="nablarch.test.core.entity.EntityTestConfiguration">
  <property name="maxMessageId"        value="MSG00011"/>
  <property name="maxAndMinMessageId"  value="MSG00011"/>
  <property name="fixLengthMessageId"  value="MSG00023"/>
  <property name="underLimitMessageId" value="MSG00011"/>
  <property name="emptyInputMessageId" value="MSG00010"/>
  <property name="characterGenerator">
    <component name="characterGenerator"
               class="nablarch.test.core.util.generator.BasicJapaneseCharacterGenerator"/>
  </property>
</component>
```

<details>
<summary>keywords</summary>

testSingleValidation, @ValidateFor, ValidateFor, バリデーションメソッドテスト, EntityTestSupport, EntityTestConfiguration, RequiredValidator, LengthValidator, BasicJapaneseCharacterGenerator, コンポーネント設定ファイル, entityTestConfiguration, MSG00010, MSG00011, MSG00023

</details>
