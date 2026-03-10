# Bean Validationに対応したForm/Entityのクラス単体テスト

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/01_ClassUnitTest/01_entityUnitTest/01_entityUnitTestWithBeanValidation.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/validation/constraints/AssertTrue.html)

## Bean Validationに対応したForm/Entityのクラス単体テスト

Bean ValidationによるForm/Entity単体テストの書き方を説明する。Form単体テストとEntity単体テストはほぼ同じ方法で行え、共通内容はForm単体テストをベースに説明する。

<details>
<summary>keywords</summary>

Bean Validation, Form単体テスト, Entity単体テスト, 単体テスト, EntityTestSupport

</details>

## Form/Entity単体テストの書き方

## テストデータの作成

テストデータExcelファイルはテストソースコードと同じディレクトリに同じ名前（拡張子のみ.xlsx）で格納する。

精査テストケース用シートと、setter/getterテストケース用シートでそれぞれ1シートを使用する前提。

メッセージデータ・コードマスタ等の静的マスタデータはプロジェクト管理データが事前投入済みの前提（個別テストデータとして作成しない）。

サンプルファイル（右クリック→保存でダウンロード）:
- :download:`テストクラス(UserRegistrationFormTest.java)<../_download/UserRegistrationFormTest.java>`
- :download:`テストデータ(UserRegistrationFormTest.xlsx)<../_download/UserRegistrationFormTest.xlsx>`
- :download:`テスト対象クラス(UserRegistrationForm.java)<../_download/UserRegistrationForm.java>`

## テストクラスの作成

テストクラス作成ルール:
1. テスト対象のForm/Entityと同一パッケージ
2. クラス名は `{Form/Entity名}Test`
3. `nablarch.test.core.db.EntityTestSupport` を継承

```java
package com.nablarch.example.app.web.form;
import nablarch.test.core.db.EntityTestSupport;
public class UserRegistrationFormTest extends EntityTestSupport {
```

## 文字種と文字列長の単項目精査テストケース

文字種・文字列長の単項目精査テスト専用テスト方法を提供する（単項目精査テストケース作成が容易になり、保守性の高いテストデータが作成できる）。

> **補足**: プロパティとして別のFormを保持するForm（`<親Form>.<子Form>.<子フォームのプロパティ名>` 形式でアクセスする親Form）には使用不可。その場合は独自に精査処理のテストを実装すること。

## その他の単項目精査テストケース

文字種・文字列長テスト方法でカバーできない精査（例：日付入力項目のフォーマット精査）に対して使用する。各プロパティに1つの入力値と期待するメッセージIDのペアを記述することで任意の値で単項目精査テストができる。

> **補足**: プロパティとして別のFormを保持するForm（`<親Form>.<子Form>.<子フォームのプロパティ名>` 形式でアクセスする親Form）には使用不可。その場合は独自に精査処理のテストを実装すること。

<details>
<summary>keywords</summary>

EntityTestSupport, nablarch.test.core.db.EntityTestSupport, テストデータExcel, テストクラス作成, Form単体テスト, Entity単体テスト, 単項目精査テスト

</details>

## テストケース表の作成方法（文字種・文字列長）

テストケース表で用意するカラム:

| カラム名 | 記載内容 |
|---|---|
| propertyName | テスト対象のプロパティ名 |
| allowEmpty | そのプロパティが未入力を許容するか |
| group | Bean Validationのグループ（省略可）。FQCNで指定。内部クラスは `$` で区切る。 |
| min | 入力値として許容する最小文字列長（省略可） |
| max | 入力値として許容する最大文字列長（省略可） |
| messageIdWhenEmptyInput | 未入力時に期待するメッセージ（省略可）。省略時は :ref:`entityUnitTest_EntityTestConfiguration_BeanValidation` のemptyInputMessageIdを使用。 |
| messageIdWhenInvalidLength | 文字列長不適合時に期待するメッセージ（省略可）。省略時は :ref:`entityUnitTest_EntityTestConfiguration_BeanValidation` で設定したデフォルト値が使用される。省略時にどのデフォルト値が使用されるかはmax欄・min欄の記載により決まる（下表参照）。 |
| messageIdWhenNotApplicable | 文字種不適合時に期待するメッセージ |
| interpolateKey_n | 埋め込み文字のキー名（nは1からの連番、省略可） |
| interpolateValue_n | 埋め込み文字の値（nは1からの連番、省略可） |
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

文字種許容カラムの設定値: `o`（許容する、半角英小文字のオー）、`x`（許容しない、半角英小文字のエックス）

messageIdWhenInvalidLength省略時のデフォルト値:

| max欄 | min欄 | maxとminの比較 | 使用されるデフォルト値 |
|---|---|---|---|
| あり | なし | — | maxMessageId |
| あり | あり | max > min | maxAndMinMessageId（超過時）、underLimitMessageId（不足時） |
| あり | あり | max = min | fixLengthMessageId |
| なし | あり | — | minMessageId |

メッセージ指定方法:
- メッセージをそのまま記載: `入力必須です。`
- 埋め込み文字あり: `{min}文字以上{max}文字以下で入力してください。`
- メッセージIDとして記載（メッセージ全体を `{}` で囲む）: `{nablarch.core.validation.ee.SystemChar.message}`
- `{}` で囲まれた部分は :ref:`message-format-spec` の埋め込み文字として扱われる

![文字種・文字列長テストケース例](../../knowledge/development-tools/testing-framework/assets/testing-framework-01_entityUnitTestWithBeanValidation/entityUnitTest_CharsetAndLengthExample_BeanValidation.png)

<details>
<summary>keywords</summary>

propertyName, allowEmpty, group, min, max, messageIdWhenEmptyInput, messageIdWhenInvalidLength, messageIdWhenNotApplicable, interpolateKey_n, interpolateValue_n, 文字種テスト, 文字列長テスト, 単項目精査

</details>

## テストメソッドの作成方法

**クラス**: `nablarch.test.core.db.EntityTestSupport`

スーパークラスの以下のメソッドを使用する:

```java
void testValidateCharsetAndLength(Class entityClass, String sheetName, String id)
```

```java
@Test
public void testCharsetAndLength() {
    String sheetName = "testCharsetAndLength";
    String id = "charsetAndLength";
    testValidateCharsetAndLength(TARGET_CLASS, sheetName, id);
}
```

このメソッドを実行すると、テストデータの各行ごとに以下の観点でテストが実行される:

| 観点 | 入力値 | 備考 |
|---|---|---|
| 文字種 | 各文字種（半角英字〜外字） | max欄記載の長さの文字列で構成。max省略時はmin欄の長さ、両方省略時は長さ1 |
| 未入力 | 空文字（長さ0） | — |
| 最小文字列 | 最小文字列長の文字列 | 入力値はo印を付けた文字種で構成される。max省略時は最長文字列・文字列長超過のテストは実行されない。min省略時は文字列長不足のテストは実行されない。 |
| 最長文字列 | 最大文字列長の文字列 | 入力値はo印を付けた文字種で構成される。max省略時は本テストは実行されない。 |
| 文字列長不足 | 最小文字列長－1の文字列 | 入力値はo印を付けた文字種で構成される。min省略時は本テストは実行されない。 |
| 文字列長超過 | 最大文字列長＋1の文字列 | 入力値はo印を付けた文字種で構成される。max省略時は本テストは実行されない。 |

<details>
<summary>keywords</summary>

testValidateCharsetAndLength, EntityTestSupport, 文字種テスト実行, 文字列長テスト実行, 単項目精査テスト

</details>

## テストケース表の作成方法（その他の単項目精査）

テストケース表で用意するカラム:

| カラム名 | 記載内容 |
|---|---|
| propertyName | テスト対象のプロパティ名 |
| case | テストケースの簡単な説明 |
| group | Bean Validationのグループ（省略可）。指定方法は文字種・文字列長テストと同じ。 |
| input1 | 入力値。複数パラメータがある場合はinput2, input3とカラムを増やす。:ref:`special_notation_in_cell` の記法使用可。 |
| messageId | 上記入力値で単項目精査した場合に期待するメッセージ。精査エラーにならないことを期待する場合は空欄。指定方法は文字種・文字列長テストと同じ。 |
| interpolateKey_n | 埋め込み文字のキー名（nは1からの連番、省略可） |
| interpolateValue_n | 埋め込み文字の値（nは1からの連番、省略可） |

![その他単項目精査テストデータ例](../../knowledge/development-tools/testing-framework/assets/testing-framework-01_entityUnitTestWithBeanValidation/entityUnitTest_singleValidationDataExample_BeanValidation.png)

<details>
<summary>keywords</summary>

propertyName, case, group, messageId, その他単項目精査, 日付フォーマット精査, input1, interpolateKey_n, interpolateValue_n, special_notation_in_cell

</details>

## テストメソッドの作成方法（単項目精査）

単項目精査のテストを実行するには、スーパクラス（`EntityTestSupport`）の以下のメソッドを呼び出す。

```java
void testSingleValidation(Class entityClass, String sheetName, String id)
```

**コード例**:

```java
public class UserRegistrationFormTest extends EntityTestSupport {

    /**
     * テスト対象Formクラス。
     */
    private static final Class<?> TARGET_CLASS = UserRegistrationForm.class;

    /**
     * 単項目精査のテストケース（上記以外）
     */
    @Test
    public void testSingleValidation() {

        // テストデータを記載したシート名
        String sheetName = "testSingleValidation";

        // テストデータのID
        String id = "singleValidation";

        // テスト実行
        testSingleValidation(TARGET_CLASS, sheetName, id);
    }
}
```

<details>
<summary>keywords</summary>

testSingleValidation, EntityTestSupport, 単項目精査, UserRegistrationFormTest, TARGET_CLASS, sheetName, id

</details>

## テストケース表の作成（項目間精査）

単項目精査でテストできない `@AssertTrue` を指定した項目間精査などは、別途テストを作成する必要がある。

**テストケース表**（ID: `testShots` 固定）:

| カラム名 | 記載内容 |
|---|---|
| title | テストケースのタイトル |
| description | テストケースの簡単な説明 |
| group | Bean Validationのグループ（省略可） |
| expectedMessageId[n] | 期待するメッセージ（nは1からの連番） |
| propertyName[n] | 期待するプロパティ（nは1からの連番） |
| interpolateKey[n]_[k] | 埋め込み文字のキー名（nはexpectedMessageIdのnに対応、kは1からの連番。省略可） |
| interpolateValue[n]_[k] | 埋め込み文字の値（nはexpectedMessageIdのnに対応、kは1からの連番。省略可） |

精査エラーが発生するプロパティ名とエラーメッセージのみ記載する（精査エラーが発生しないプロパティは記載しない）。複数メッセージを期待する場合は`expectedMessageId2`, `propertyName2`のように連番を増やす。複数メッセージの埋め込み文字は`interpolateKey2_1`, `interpolateValue2_1`のように連番を増やす。

**入力パラメータ表**（ID: `params` 固定）:
- テストケース表に対応する入力パラメータを1行ずつ記載する
- 項目間精査で検証するプロパティの値を記載する。入力必須のプロパティが他に存在する場合も記載が必要

> **補足**: :ref:`special_notation_in_cell` の記法を使用することで、効率的に入力値を作成できる。

> **補足**: Form単体テストで別のFormのプロパティを指定する場合の記法:
> - `sampleForm.systemUser.userId`（Formのプロパティを指定する場合）
> - `sampleForm.userTelArray[0].telNoArea`（Form配列の先頭要素のプロパティを指定する場合）

![項目間精査テストデータ例](../../knowledge/development-tools/testing-framework/assets/testing-framework-01_entityUnitTestWithBeanValidation/entityUnitTest_validationTestData_BeanValidation.png)

<details>
<summary>keywords</summary>

AssertTrue, testShots, params, 項目間精査, テストケース表, 入力パラメータ表, 埋め込み文字, special_notation_in_cell, interpolateKey, interpolateValue, expectedMessageId, propertyName

</details>

## テストメソッドの作成方法（項目間精査）

項目間精査のテストを実行するには、スーパクラス（`EntityTestSupport`）の以下のメソッドを呼び出す。

```java
void testBeanValidation(Class entityClass, String sheetName)
```

**コード例**:

```java
public class UserRegistrationFormTest extends EntityTestSupport {

    /**
     * テスト対象Formクラス。
     */
    private static final Class<?> TARGET_CLASS = UserRegistrationForm.class;

    /**
     * 項目間精査のテストケース
     */
    @Test
    public void testWholeFormValidation() {
        // テストデータを記載したシート名
        String sheetName = "testWholeFormValidation";

        // テスト実行
        testBeanValidation(TARGET_CLASS, sheetName);
    }
}
```

<details>
<summary>keywords</summary>

testBeanValidation, testWholeFormValidation, EntityTestSupport, 項目間精査, UserRegistrationFormTest, TARGET_CLASS, sheetName

</details>

## Excelへの定義（setter/getter）

setter、getterテストの対象は**Formに定義されている全プロパティ**。setterで設定した値とgetterで取得した値が期待通りであることを確認する。

> **補足**: Entityは自動生成されるため、アプリケーションで使用されないsetter/getterが生成される可能性がある。そのため、Entity単体テストでsetter/getterのテストを**必ず行うこと**。一般的なFormはリクエスト単体テストでsetter/getterのテストができるため、クラス単体テストでのテストは不要。

![setter/getter Excelデータ定義](../../knowledge/development-tools/testing-framework/assets/testing-framework-01_entityUnitTestWithBeanValidation/entityUnitTest_SetterAndGetter.png)

**テストメソッド**: `testSetterAndGetter(Class entityClass, String sheetName, String id)` を呼び出す。

```java
public class UserRegistrationFormTest extends EntityTestSupport {
    private static final Class<?> TARGET_CLASS = UserRegistrationForm.class;

    @Test
    public void testSetterAndGetter() {
        String sheetName = "testSetterAndGetter";
        String id = "setterAndGetter";
        testSetterAndGetter(TARGET_CLASS, sheetName, id);
    }
}
```

> **補足**: `testSetterAndGetter`でテスト可能な型には制限がある。対象外の型は個別にsetterとgetterを呼び出してテストする必要がある。テスト可能な型:
> - `String`およびその配列
> - `BigDecimal`およびその配列
> - `java.util.Date`およびその配列（Excelへはyyyy-MM-dd形式またはyyyy-MM-dd HH:mm:ss形式で記述）
> - `valueOf(String)`メソッドを持つクラスおよびその配列（例: `Integer`, `Long`, `java.sql.Date`, `java.sql.Timestamp`）
>
> 非対応型（例: `List<String>`）は`getParamMap(sheetName, id)`でテストデータを取得し、個別にsetter/getterを呼び出してテストする（複数プロパティの場合は`getListParamMap`を使用）。

![非対応型のExcelデータ定義例](../../knowledge/development-tools/testing-framework/assets/testing-framework-01_entityUnitTestWithBeanValidation/entityUnitTest_SetterAndGetterOther.png)

```java
// 非対応型(List<String>)の個別テスト例
Map<String, String[]> data = getParamMap(sheetName, "setterAndGetterOther");
List<String> users = Arrays.asList(data.get("set"));
UserRegistrationForm form = new UserRegistrationForm();
form.setUsers(users);
assertEquals(form.getUsers(), Arrays.asList(data.get("get")));
```

> **補足**: setterやgetterにロジックを記述した場合（例: setterは郵便番号上3桁と下4桁で受け取り、getterはまとめて7桁で返す）は、そのロジックを確認するテストケースを作成すること。

![setter/getterロジックのExcelデータ定義例](../../knowledge/development-tools/testing-framework/assets/testing-framework-01_entityUnitTestWithBeanValidation/entityUnitTest_SetterAndGetter_PostNo.png)

<details>
<summary>keywords</summary>

testSetterAndGetter, getParamMap, getListParamMap, EntityTestSupport, setter/getterテスト, Entity単体テスト, 型制限, BigDecimal, java.util.Date, valueOf, Integer, Long, java.sql.Date, java.sql.Timestamp

</details>

## 設定項目一覧

**クラス**: `nablarch.test.core.entity.EntityTestConfiguration`

コンポーネント設定ファイルで以下の値を設定する:

| 設定項目名 | 説明 |
|---|---|
| maxMessageId | 最大文字列長超過時のメッセージのデフォルト値 |
| maxAndMinMessageId | 最長最小文字列長範囲外のメッセージのデフォルト値（可変長、超過時） |
| underLimitMessageId | 最長最小文字列長範囲外のメッセージのデフォルト値（可変長、不足時） |
| fixLengthMessageId | 最長最小文字列長範囲外のメッセージのデフォルト値（固定長） |
| minMessageId | 文字列長不足時のメッセージのデフォルト値（maxを省略したテストケースを作成する場合は**必須**） |
| emptyInputMessageId | 未入力時のメッセージのデフォルト値 |
| characterGenerator | 文字列生成クラス（`nablarch.test.core.util.generator.CharacterGenerator`の実装クラスを指定。通常は`nablarch.test.core.util.generator.BasicJapaneseCharacterGenerator`を使用） |
| validationTestStrategy | テスト用バリデーションストラテジ（Bean Validationを使用する場合は`nablarch.test.core.entity.BeanValidationTestStrategy`を**固定で指定**） |

<details>
<summary>keywords</summary>

EntityTestConfiguration, BasicJapaneseCharacterGenerator, BeanValidationTestStrategy, CharacterGenerator, maxMessageId, maxAndMinMessageId, underLimitMessageId, fixLengthMessageId, minMessageId, emptyInputMessageId, validationTestStrategy, characterGenerator

</details>

## コンポーネント設定ファイルの記述例

```xml
<component name="entityTestConfiguration" class="nablarch.test.core.entity.EntityTestConfiguration">
  <property name="maxMessageId"        value="{nablarch.core.validation.ee.Length.max.message}"/>
  <property name="maxAndMinMessageId"  value="{nablarch.core.validation.ee.Length.min.max.message}"/>
  <property name="fixLengthMessageId"  value="{nablarch.core.validation.ee.Length.fixed.message}"/>
  <property name="underLimitMessageId" value="{nablarch.core.validation.ee.Length.min.max.message}"/>
  <property name="minMessageId"        value="{nablarch.core.validation.ee.Length.min.message}"/>
  <property name="emptyInputMessageId" value="{nablarch.core.validation.ee.Required.message}"/>
  <property name="characterGenerator">
    <component name="characterGenerator"
               class="nablarch.test.core.util.generator.BasicJapaneseCharacterGenerator"/>
  </property>
  <property name="validationTestStrategy">
    <component class="nablarch.test.core.entity.BeanValidationTestStrategy"/>
  </property>
</component>
```

<details>
<summary>keywords</summary>

EntityTestConfiguration, BasicJapaneseCharacterGenerator, BeanValidationTestStrategy, nablarch.test.core.entity.EntityTestConfiguration, XML設定例

</details>
