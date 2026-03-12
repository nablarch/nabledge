# Nablarch Validationに対応したForm/Entityのクラス単体テスト

**公式ドキュメント**: [Nablarch Validationに対応したForm/Entityのクラス単体テスト](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/01_ClassUnitTest/01_entityUnitTest/02_entityUnitTestWithNablarchValidation.html)

## Form/Entity単体テストの書き方

## テストデータの作成

テストデータのExcelファイルはテストソースコードと同じディレクトリに同じ名前で格納する（拡張子のみ異なる）。精査のテストケース・コンストラクタのテストケース・setter/getterのテストケースがそれぞれ1シートを使用する。

メッセージデータやコードマスタ等のDBに格納する静的マスタデータは、プロジェクトで管理されたデータがあらかじめ投入されている前提（個別のテストデータとして作成しない）。

サンプルファイル:
- :download:`テストクラス(SystemAccountEntityTest.java)<../_download/SystemAccountEntityTest.java>`
- :download:`テストデータ(SystemAccountEntityTest.xlsx)<../_download/SystemAccountEntityTest.xlsx>`
- :download:`テスト対象クラス(SystemAccountEntity.java)<../_download/SystemAccountEntity.java>`

## テストクラスの作成

テストクラス作成ルール:
1. テスト対象のForm/Entityと同一パッケージ
2. クラス名: `{Form/Entityクラス名}Test`
3. **クラス**: `nablarch.test.core.db.EntityTestSupport` を継承

```java
public class SystemAccountEntityTest extends EntityTestSupport {
```

テストケース表（ID: `testShots` 固定）:

| カラム名 | 記載内容 |
|---|---|
| title | テストケースのタイトル |
| description | テストケースの簡単な説明 |
| expectedMessageId*n* | 期待するメッセージID（*n*は1からの連番） |
| propertyName*n* | 期待するプロパティ（*n*は1からの連番） |

複数メッセージを期待する場合、`expectedMessageId2`, `propertyName2` のように連番を増やして右側に追加する。

入力パラメータ表（ID: `params` 固定）: テストケース表に対応する入力パラメータを1行ずつ記載。:ref:`special_notation_in_cell` の記法で効率的に入力値を作成できる。

![テストデータ例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_validationTestData.png)

<details>
<summary>keywords</summary>

nablarch.test.core.db.EntityTestSupport, EntityTestSupport, SystemAccountEntityTest, テストデータExcel作成, Formクラス単体テスト, Entityクラス単体テスト, testShots, params, expectedMessageId, propertyName, テストケース表作成, バリデーションテストデータ, 入力パラメータ表

</details>

## 文字種と文字列長の単項目精査テストケース

文字種・文字列長に関する単項目精査専用のテスト方法。ケース数が多くなりがちな単項目精査のテストケース作成・メンテナンスを容易にする。

> **補足**: 本テスト方法は、プロパティとして別のFormを保持するForm（`<親Form>.<子Form>.<子フォームのプロパティ名>` 形式でプロパティにアクセスする親Form）に対しては使用できない。その場合、独自に精査処理のテストを実装すること。

### 精査対象確認

[nablarch_validation](../../component/libraries/libraries-nablarch_validation.md) で精査対象プロパティを指定した場合、その指定の正しさを確認するケースを作成する。

全プロパティに対して単項目精査でエラーとなるデータを用意する。テストケース表には全精査対象プロパティのプロパティ名と単項目精査エラーメッセージIDを記載する。

> **補足**: 精査対象プロパティが誤って漏れていた場合、期待メッセージが出力されずメッセージIDのアサートが失敗する。精査対象でないプロパティが誤って精査対象となった場合は、予期しないメッセージが出力される。これにより精査対象の誤りを検知できる。

![精査対象テストケース表](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_ValidationPropTestCases.png)

![精査対象入力パラメータ表](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_ValidationPropParams.png)

> **補足**: Formが保持する別Formのプロパティ指定方法。以下の `SampleForm` クラスを例にすると:
>
> ```java
> public class SampleForm {
>     /** システムユーザ */
>     private SystemUserEntity systemUser;
>
>     /** 電話番号配列 */
>     private UserTelEntity[] userTelArray;
> }
> ```
>
> - ネストFormのプロパティ（`SystemUserEntity.userId` を指定する場合）: `sampleForm.systemUser.userId`
> - Form配列の要素プロパティ（`UserTelEntity` 配列の先頭要素のプロパティを指定する場合）: `sampleForm.userTelArray[0].telNoArea`

### 項目間精査など

:ref:`entityUnitTest_ValidationMethodSpecifyNormal` で行った精査対象指定以外の動作確認（項目間精査など）を行うケースを作成する。

![項目間精査テストケース](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_RelationalValidation.png)

<details>
<summary>keywords</summary>

EntityTestSupport, 文字種単項目精査テスト, 文字列長単項目精査テスト, 別のFormを保持するForm, testValidateCharsetAndLength, 単項目精査テスト方法, 精査対象確認, 項目間精査, nablarch_validation, バリデーション対象プロパティ, 単項目精査, ネストFormプロパティ指定

</details>

## テストケース表の作成方法（文字種・文字列長）

Excelシートに以下のカラムを用意する:

| カラム名 | 記載内容 |
|---|---|
| propertyName | テスト対象のプロパティ名 |
| allowEmpty | そのプロパティが未入力を許容するか |
| min | 最小文字列長（省略可） |
| max | 最大文字列長 |
| messageIdWhenEmptyInput | 未入力時に期待するメッセージID（省略可） |
| messageIdWhenInvalidLength | 文字列長不適合時に期待するメッセージID（省略可） |
| messageIdWhenNotApplicable | 文字種不適合時に期待するメッセージID |
| 半角英字〜外字（11種） | 各文字種を許容するか（`o`: 許容、`x`: 不許容） |

文字種カラムは 半角英字、半角数字、半角記号、半角カナ、全角英字、全角数字、全角ひらがな、全角カタカナ、全角漢字、全角記号その他、外字 の11種。

messageIdWhenEmptyInput省略時: :ref:`entityUnitTest_EntityTestConfiguration` のemptyInputMessageIdが使用される。

messageIdWhenInvalidLength省略時のデフォルト値:

| min欄の記載 | maxとminの比較 | 使用されるデフォルト値 |
|---|---|---|
| なし | (該当なし) | maxMessageId |
| あり | max > min | maxAndMinMessageId（超過時）、underLimitMessageId（不足時） |
| あり | max = min | fixLengthMessageId |

文字種カラムの設定値: `o`（半角英小文字のオー: 許容）/ `x`（半角英小文字のエックス: 不許容）

![テストケース表の例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_CharsetAndLengthExample.png)

これまでに作成したテストケース、データを使用するテストメソッドを以下に示す。下記コードの変数内容を変更するだけで、異なるEntityの精査のテストに対応できる。

```java
// ～前略～

/** テスト対象エンティティクラス */
private static final Class<SystemAccountEntity> ENTITY_CLASS = SystemAccountEntity.class;

// ～中略～
/**
 * {@link SystemAccountEntity#validateForRegisterUser(nablarch.core.validation.ValidationContext)} のテスト。
 */
@Test
public void testValidateForRegisterUser() {
    // 精査実行
    String sheetName = "testValidateForRegisterUser";
    String validateFor = "registerUser";
    testValidateAndConvert(ENTITY_CLASS, sheetName, validateFor);
}

// ～後略～
```

<details>
<summary>keywords</summary>

propertyName, allowEmpty, messageIdWhenEmptyInput, messageIdWhenInvalidLength, messageIdWhenNotApplicable, entityUnitTest_EntityTestConfiguration, maxMessageId, fixLengthMessageId, maxAndMinMessageId, underLimitMessageId, 文字種テストケース表, testValidateAndConvert, testValidateForRegisterUser, ENTITY_CLASS, validateFor, sheetName, テストメソッド作成

</details>

## テストメソッドの作成方法（文字種・文字列長）

スーパークラスの以下のメソッドを呼び出す:

```java
void testValidateCharsetAndLength(Class entityClass, String sheetName, String id)
```

使用例:

```java
testValidateCharsetAndLength(ENTITY_CLASS, sheetName, id);
```

メソッドを実行すると、テストデータの各行に対して以下のテストが実行される:

| 観点 | 入力値 | 備考 |
|---|---|---|
| 文字種（各12種） | 各文字種でmax長の文字列 | 許容/不許容の設定に従い精査成功/失敗を検証 |
| 未入力 | 空文字（長さ0） | — |
| 最小文字列長 | min長の文字列 | 入力値は、o印を付けた文字種で構成される。min欄が省略された場合は文字列長不足のテストは実行されない。 |
| 最長文字列長 | max長の文字列 | 入力値は、o印を付けた文字種で構成される。 |
| 文字列長不足 | min-1長の文字列 | — |
| 文字列長超過 | max+1長の文字列 | — |

Nablarch Validationで入力値チェックを実施しているEntityには `Map<String, Object>` を引数にとるコンストラクタが実装されており（[nablarch_validation-execute](../../component/libraries/libraries-nablarch_validation.md) 参照）、このコンストラクタに対するテストを作成する必要がある。対象プロパティはEntityに定義されている全プロパティ。テストデータにはプロパティ名・設定値・期待値（getterで取得した値）を用意する。

> **補足**: Entityは自動生成されるため、アプリケーションで使用されないコンストラクタが生成される可能性がある。その場合リクエスト単体テストではテストできないため、Entity単体テストで必ずコンストラクタのテストを行うこと。一般的なFormについてはクラス単体テストでコンストラクタのテストを行う必要はない。

### Excelへの定義

![コンストラクタテストのExcel定義](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_Constructor.png)

| プロパティ | コンストラクタに設定する値 | 期待値（getterから取得される値） |
|---|---|---|
| userId | userid | userid |
| loginId | loginid | loginid |
| password | password | password |

`testConstructorAndGetter(entityClass, sheetName, id)` を使用してテストを実施する。

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

> **補足**: `testConstructorAndGetter` でテスト可能なプロパティ型には制限がある。以下の型以外は個別にコンストラクタとgetterを呼び出してテストする必要がある:
> - `String` およびその配列
> - `BigDecimal` およびその配列
> - `java.util.Date` およびその配列（Excelへは `yyyy-MM-dd` または `yyyy-MM-dd HH:mm:ss` 形式で記述）
> - `valueOf(String)` メソッドを持つクラスおよびその配列（`Integer`、`Long`、`java.sql.Date`、`java.sql.Timestamp` など）

サポート外の型（例: `List<String>`）の個別テストコード例:

![コンストラクタテスト（個別型）のExcel定義](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_ConstructorOther.png)

```java
@Test
public void testConstructor() {
    testConstructorAndGetter(entityClass, sheetName, id);

    // テスト対象のプロパティが複数ある場合は、getListParamMapを使用する。
    Map<String, String[]> data = getParamMap(sheetName, "testConstructorOther");
    Map<String, Object> params = new HashMap<String, Object>();
    params.put("users", Arrays.asList(data.get("set")));
    SystemAccountEntity entity = new SystemAccountEntity(params);
    assertEquals(entity.getUsers(), Arrays.asList(data.get("get")));
}
```

<details>
<summary>keywords</summary>

testValidateCharsetAndLength, EntityTestSupport, 文字種テストメソッド, 文字列長テスト, CharsetAndLength, testConstructorAndGetter, コンストラクタテスト, getParamMap, getListParamMap, Map<String, Object>コンストラクタ, testConstructorOther, SystemAccountEntityTest

</details>

## テストケース表の作成方法（その他の単項目精査）

文字種・文字列長のテストでカバーできない精査（例: 数値の範囲精査）向けのテスト方法。各プロパティについて入力値と期待するメッセージIDのペアを記述することで任意の値で単項目精査のテストができる。

> **補足**: 本テスト方法は、プロパティとして別のFormを保持するForm（`<親Form>.<子Form>.<子フォームのプロパティ名>` 形式でプロパティにアクセスする親Form）に対しては使用できない。その場合、独自に精査処理のテストを実装すること。

Excelシートに以下のカラムを用意する:

| カラム名 | 記載内容 |
|---|---|
| propertyName | テスト対象のプロパティ名 |
| case | テストケースの簡単な説明 |
| input1 | 入力値（:ref:`special_notation_in_cell` の記法を使用することで効率的に入力値を作成できる） |
| messageId | 期待するメッセージID（精査エラーにならない場合は空欄） |

1つのキーに対して複数パラメータを指定する場合は、input2、input3 というようにカラムを追加する。

![テストケース表の例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_entityUnitTestWithNablarchValidation/entityUnitTest_singleValidationDataExample.png)

**クラス**: `nablarch.test.core.entity.EntityTestConfiguration`

コンポーネント設定ファイルで以下の値を設定する（全項目必須）:

| 設定項目名 | 説明 |
|---|---|
| maxMessageId | 最大文字列長超過時のメッセージID |
| maxAndMinMessageId | 最長最小文字列長範囲外のメッセージID（可変長） |
| fixLengthMessageId | 最長最小文字列長範囲外のメッセージID（固定長） |
| underLimitMessageId | 文字列長不足時のメッセージID |
| emptyInputMessageId | 未入力時のメッセージID |
| characterGenerator | 文字列生成クラス（`nablarch.test.core.util.generator.CharacterGenerator` の実装クラス） |

`characterGenerator` には通常 `nablarch.test.core.util.generator.BasicJapaneseCharacterGenerator` を使用する。設定するメッセージIDはバリデータの設定値と合致させる。

<details>
<summary>keywords</summary>

testSingleValidation, propertyName, case, input1, messageId, 範囲精査テスト, 単項目精査テストケース表, EntityTestConfiguration, maxMessageId, maxAndMinMessageId, fixLengthMessageId, underLimitMessageId, emptyInputMessageId, characterGenerator, BasicJapaneseCharacterGenerator, CharacterGenerator

</details>

## テストメソッドの作成方法（その他の単項目精査）

スーパークラスの以下のメソッドを呼び出す:

```java
void testSingleValidation(Class entityClass, String sheetName, String id)
```

使用例:

```java
testSingleValidation(ENTITY_CLASS, sheetName, id);
```

**精査クラスのコンポーネント設定ファイル:**

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
  </list>
</property>
```

**テストのコンポーネント設定ファイル:**

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

testSingleValidation, EntityTestSupport, 単項目精査テストメソッド, EntityTestConfiguration, RequiredValidator, LengthValidator, BasicJapaneseCharacterGenerator, コンポーネント設定ファイル記述例

</details>

## バリデーションメソッドのテストケース

上記の単項目精査テストでは、エンティティのセッターメソッドに付与されたアノテーションのみが検証され、**アノテーション**: `@ValidateFor` を付与したstaticバリデーションメソッドは実行されない。独自のバリデーションメソッドをエンティティに実装した場合は、別途テストを作成する必要がある。

<details>
<summary>keywords</summary>

@ValidateFor, ValidateFor, バリデーションメソッドテスト, staticバリデーションメソッド

</details>
