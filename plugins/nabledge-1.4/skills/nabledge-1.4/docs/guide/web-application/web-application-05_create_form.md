# Formクラスの実装

## Formクラスの作成

## Formクラスの作成

**クラス**: `W11AC02Form`（`W11AC02FormBase`を継承）

格納フォルダ: `main/java/nablarch/sample/ss11AC`

```java
public class W11AC02Form extends W11AC02FormBase {
    public W11AC02Form() {}

    public W11AC02Form(Map<String, Object> data) {
        super(data);
    }
}
```

<details>
<summary>keywords</summary>

W11AC02Form, W11AC02FormBase, Formクラス作成, FormBase継承, デフォルトコンストラクタ, Mapコンストラクタ

</details>

## Formクラスの精査処理実装

## Formクラスの精査処理実装

### 単体テスト

精査処理の単体テストでは以下を検証する:
- 精査対象プロパティに対して精査が行われていること
- 精査対象外プロパティに対して精査が行われていないこと

**テストデータ**:

| データシート格納フォルダ | データシートファイル名 | シート名 |
|---|---|---|
| `test/java/nablarch/sample/ss11AC` | `W11AC02FormTest.xlsx` | `testValidateForRegister` |

テストクラス: `W11AC02FormTest`（`SampleEntityTestSupport`を継承）、テストメソッド: `testValidateForRegister`

```java
@Test
public void testValidateForRegister() {
    testValidateAndConvert(W11AC02Form.class, "testValidateForRegister", "register");
}
```

前画面や別取引からの引継ぎ項目がある場合は、それらプロパティの単項目精査テストも必要（:ref:`entityUnitTest` 参照）。

### Formクラスの単体テストを実行（初回）

精査メソッドを実装する前に単体テストを実行し、テストが失敗することを確認する（精査メソッドを実装していない為）。

### validateForRegisterの実装

**メソッド**: `W11AC02Form#validateForRegister`（`@ValidateFor("register")`付き）

単項目精査対象プロパティを指定して `ValidationUtil#validate` を呼び出す:

```java
@ValidateFor("register")
public static void validateForRegister(ValidationContext<W11AC02Form> context) {
    ValidationUtil.validate(context, new String[] {"kanjiName", "kanaName"});
}
```

精査対象外プロパティを指定する `ValidationUtil#validateWithout` も利用可能。空配列を渡すと全プロパティが精査対象になる:

```java
ValidationUtil.validateWithout(context, new String[0]);
```

### Formクラスの単体テストを実行（最終確認）

Form単体テストを実行し、精査対象とするプロパティの精査が行われていることを確認する。

<details>
<summary>keywords</summary>

W11AC02Form, W11AC02FormTest, ValidationUtil, @ValidateFor, validateForRegister, validateWithout, ValidationUtil#validateWithout, SampleEntityTestSupport, 単項目精査, 精査処理実装, バリデーション

</details>

## 精査処理とFormの生成を行うメソッドの実装

## 精査処理とFormの生成を行うメソッドの実装

Formクラスにstaticな `validate` メソッドを実装することで、Actionの実装を簡略化できる。

```java
public static W11AC02Form validate(HttpRequest req, String validationName) {
    ValidationContext<W11AC02Form> context = ValidationUtil.validateAndConvertRequest(
            "W11AC02", W11AC02Form.class, req, validationName);
    context.abortIfInvalid();   // 精査エラー時はApplicationExceptionをスロー
    return context.createObject();  // 精査成功時はFormオブジェクトを生成して返す
}
```

<details>
<summary>keywords</summary>

W11AC02Form, ValidationUtil, ValidationContext, ApplicationException, validateAndConvertRequest, abortIfInvalid, createObject, HttpRequest, 精査処理, フォーム生成, Formバリデーション

</details>
