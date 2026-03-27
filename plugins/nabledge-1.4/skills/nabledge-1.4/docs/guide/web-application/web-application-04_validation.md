# 入力内容の精査

**公式ドキュメント**: [入力内容の精査]()

## 説明内容

本ガイドで説明する内容:

- データベースアクセスを伴わない単項目精査および項目間精査
- 画面より入力された情報を持ったオブジェクトの取得
- エラー(例外)発生時の処理

複数の精査メソッドが必要な場合（例: 登録用・更新用）、各メソッドに付与する `@ValidateFor` アノテーションの値をそれぞれ異なるものにしておき、バリデーション実施時に呼び分ける（[04_action](#) 参照）。

**アノテーション**: `@ValidateFor`

```java
// アノテーションの値を他の精査メソッドと別のものにしておく
@ValidateFor("updateUser")
public static void validateForUpdate(ValidationContext<SearchCondition> context) {
    // 中略
}
```

<details>
<summary>keywords</summary>

単項目精査, 項目間精査, バリデーション, エラー処理, 入力精査, @ValidateFor, ValidationContext, バリデーションメソッド複数定義, 登録更新で異なる精査

</details>

## 本項で説明する内容

![画面遷移図](../../../knowledge/guide/web-application/assets/web-application-04_validation/screenTransition.png)

本取引で作成・編集するファイル一覧:

| 名称 | ステレオタイプ | 処理内容 |
|---|---|---|
| W11AC02FormBase.java | Form | 画面/取引に対応したクラス。取引において画面で入力されたデータを保持。 |
| W11AC02Form.java | Form | FormBaseクラスを継承し、外部入力値の精査を実行。アプリケーションで使用する追加データ（画面で入力された項目以外）を保持。 |
| W11AC02Action.java | Action | 画面入力値が設定されたオブジェクトの取得、例外処理。結果をリクエストスコープに格納してJSPへ遷移。 |
| W11AC0201.jsp | View | ユーザ情報登録画面の入力に誤りがあった場合のエラーメッセージ表示。 |

ステレオタイプについては :ref:`stereoType` 参照。

プロパティの表示名を変更するには、FormのsetterをオーバーライドしてPropertyNameアノテーションを付与する。バリデーションは元の指定がそのまま継承される。

**アノテーション**: `@PropertyName`

```java
public class W11AC02FormSample extends W11AC02FormBase {
    @PropertyName("氏名")
    // setterをオーバーライドし、@PropertyNameアノテーションで変更したい表示名を指定する
    // バリデーションは元のものがそのまま継承される
    public void setKanjiName(String kanjiName) {
        super.setKanjiName(kanjiName);
    }
}
```

> **注意**: サンプルアプリケーションでは本機能は用いていない。このため、記載したコード例はサンプルアプリケーションには含まれない。

<details>
<summary>keywords</summary>

W11AC02FormBase, W11AC02Form, W11AC02Action, W11AC0201, Form, Action, View, ステレオタイプ, @PropertyName, プロパティ表示名カスタマイズ, setterオーバーライド, W11AC02FormSample

</details>

## Formの生成

画面/取引に対応したFormクラスを新規に作成する。Formクラスには、画面から入力する値や取引で必要となる精査処理（単項目精査や項目間精査）を実装する。

> **注意**: テーブルと1対1に対応付けられたFormをEntityと呼ぶ。

バリデーションの実行と入力値オブジェクトの生成をFormクラスのstaticメソッドとして実装する。

1. `ValidationUtil#validateAndConvertRequest` を呼び出す。独自の精査メソッドを実行するには、「バリデーション対象メソッド」引数（`validateFor`）を持つシグネチャを使用し、その値に `@ValidateFor` アノテーションの値を指定する。  
   シグネチャ: `validateAndConvertRequest(String prefix, Class<T> targetClass, Validatable<?> request, String validateFor)`
2. `ValidationContext#abortIfInvalid` を呼び出し、バリデーションエラーが存在する場合は `ApplicationException` をthrowする。
3. `ValidationContext#createObject` で画面入力値が設定されたオブジェクトを取得する。取得されるクラスは `validateAndConvertRequest` の第2引数に設定したクラス。

**クラス**: `ValidationUtil`, `ValidationContext`
**例外**: `ApplicationException`

```java
public static W11AC02Form validate(HttpRequest req, String validationName) {
    ValidationContext<W11AC02Form> context = ValidationUtil.validateAndConvertRequest(
            "W11AC02", W11AC02Form.class, req, validationName);
    context.abortIfInvalid();
    return context.createObject();
}
```

<details>
<summary>keywords</summary>

FormBase, Form, Entity, Formクラス, 単項目精査, 項目間精査, ValidationUtil, ValidationContext, ApplicationException, validateAndConvertRequest, abortIfInvalid, createObject, バリデーション実行, 入力値オブジェクト取得

</details>

## 作成手順

プロパティの配置ルール:

- 取引内の画面からの入力値に対応するプロパティ → FormBaseクラスに追加する
- 上記に該当しないプロパティ → Formクラスに追加する

プロパティ追加手順:

1. Form（およびFormBase）にプロパティ（メンバ変数、setter、getter）を追加する。
2. FormのMapを引数にとるコンストラクタに、追加したプロパティの値を設定する処理を追加する。

ComponentやActionで例外が発生した場合、デフォルトではHTTPステータス500のレスポンスが返される。例外発生時の処理（遷移先など）を変更するには、メソッドに `@OnError` アノテーションを付与する。

**アノテーション**: `@OnError`

具体例は :ref:`04_actionClassCreate` 参照。

<details>
<summary>keywords</summary>

FormBase, Form, プロパティ追加, Mapコンストラクタ, setter, getter, @OnError, ApplicationException, 例外処理, HTTPステータス500

</details>

## プロパティの追加

**クラス**: `W11AC02FormBase`

**アノテーション**: `@PropertyName`, `@Required`, `@Length`, `@SystemChar`

setterにバリデーション用アノテーションを付与する。`@PropertyName` はエラー発生時に表示される項目名に使用される。

```java
public abstract class W11AC02FormBase {
    private String loginId;
    // （他プロパティ省略）

    public W11AC02FormBase(Map<String, Object> params) {
        loginId = (String) params.get("loginId");
        // （他プロパティ省略）
    }

    protected Map<String, Object> toMap() {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("loginId", loginId);
        // （省略）
        return result;
    }

    @PropertyName("ログインID")
    @Required
    @Length(max = 20)
    @SystemChar(charsetDef = "asciiCharset", allowLineSeparator = false)
    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }
}
```

[04_validation](#) と :ref:`04_errHandling` に従い、Actionクラスのメソッドに以下の処理を実装する:

a. `@OnError` アノテーションで `ApplicationException` 発生時の遷移先を記述
b. 画面入力値が設定されたオブジェクトの取得
c. データベースアクセスを伴う精査
d. ビジネスロジックの実行

**アノテーション**: `@OnError`
**例外**: `ApplicationException`

```java
@OnError(
    type = ApplicationException.class,
    path = "forward://RW11AC0201"
)
public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
    validate(req);
    // ～中略～
}

private W11AC02Form validate(HttpRequest req) {
    W11AC02Form form = W11AC02Form.validate(req, "insert");
    SystemAccountEntity systemAccount = form.getSystemAccount();
    CM311AC1Component component = new CM311AC1Component();
    checkLoginId(systemAccount.getLoginId());
    if (!function.existGroupId(form.getUgroupSystemAccount())) {
        throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR,
                "MSG00002", MessageUtil.getStringResource("S0020001")));
    }
    if (systemAccount.getPermissionUnit() != null
            && !function.existPermissionUnitId(systemAccount)) {
        throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR,
                "MSG00002", MessageUtil.getStringResource("S0030001")));
    }
    return form;
}
```

> **注意**: バリデーション処理をプライベートメソッドに切り出すことは必須ではない。

> **注意**: `@OnError` の `path` の記述方法は `HttpResponse` の引数と同じ。詳細は :ref:`makeActionClass` 参照。

<details>
<summary>keywords</summary>

W11AC02FormBase, @PropertyName, @Required, @Length, @SystemChar, プロパティ追加, setLoginId, @OnError, ApplicationException, データベース精査, Actionメソッド実装, HttpResponse, ExecutionContext, MessageUtil

</details>

## バリデーションの実装

バリデーション実装には以下が必要:
1. FormBaseおよびFormのsetterにアノテーションを付与する
2. Formにバリデーションメソッドを実装する（`@ValidateFor` アノテーション付与）

**アノテーション**: `@PropertyName`, `@Required`, `@Length`, `@SystemChar`, `@Digits`, `@NumberRange`

> **注意**: Integer、Long、BigDecimalなど数値型プロパティには `@Digits` アノテーションを設定する。Webアプリケーションでは外部入力は文字列のみのため、`@Digits` による数値精査とデータ型変換が必要。

```java
// 数値型プロパティの例
@PropertyName("認証失敗回数")
@Required
@Digits(integer = 1, fraction = 0)  // 整数部桁数・小数部桁数
@NumberRange(min = 0, max = 9)      // 数値範囲チェック
public void setFailedCount(Integer failedCount) {
    this.failedCount = failedCount;
}
```

バリデーションメソッドの実装（`@ValidateFor("処理名")`）:

処理ごとに精査対象プロパティが異なる場合は、処理ごとにバリデーションメソッドを用意する（[multiple_validation_method](#s7) 参照）。

| 配列の種類 | 呼び出すメソッド |
|---|---|
| バリデーション対象としたいプロパティ名の配列を用意した場合 | `ValidationUtil#validate` |
| バリデーション対象外としたいプロパティ名の配列を用意した場合 | `ValidationUtil#validateWithout` |

`ValidationContext#isValid()` でバリデーション結果確認（エラーなし=true）。

```java
// バリデーション対象プロパティを指定する例（W11AC03Form）
@ValidateFor("find")
public static void validateForSelectUser(ValidationContext<W11AC03Form> context) {
    ValidationUtil.validate(context, new String[] {"userId"});
}

// バリデーション対象外プロパティを指定する例（全プロパティをバリデーション）
@ValidateFor("insert")
public static void validate(ValidationContext<W11AC02Form> context) {
    ValidationUtil.validateWithout(context, new String[0]);
}
```

参照: [基本バリデータ・コンバータ](../../../fw/reference/core_library/validation_basic_validators.html)、[拡張バリデータ](../../../fw/reference/core_library/validation_advanced_validators.html)

JSPのエラーメッセージ表示には `n:errors` タグと `n:error` タグを使用する:
- `n:errors` タグ: 複数エラーメッセージの一覧表示（入力項目以外のエラーを画面上部に表示）
- `n:error` タグ: 各入力項目のエラーメッセージ表示（入力項目の下に表示）

入力項目カスタムタグの `name` 属性（リクエストパラメータ名）の形式:

Formに追加したEntityのプロパティを指定する場合:
```
<バリデーションで指定するプレフィックス名>.<FormでのEntityのプロパティ名>.<Entityでのプロパティ名>
```

Formに直接追加したプロパティを指定する場合:
```
<バリデーションで指定するプレフィックス名>.<プロパティ名>
```

（ユーザ情報登録では `W11AC02` をプレフィックスとして使用）

<details>
<summary>keywords</summary>

@ValidateFor, ValidationUtil, ValidationContext, @Digits, @NumberRange, バリデーションメソッド, validate, validateWithout, isValid, W11AC02Form, W11AC03Form, n:errors, n:error, JSP作成, エラーメッセージ表示, name属性形式, バリデーションプレフィックス

</details>

## 独自の精査処理(項目間精査)を行いたい場合

項目間精査もバリデーションメソッド内で実装する。精査エラー時はValidationContextにエラーメッセージを格納する。

| メソッド | 用途 | 例 |
|---|---|---|
| `addResultMessage(String propertyName, String messageId, Object... params)` | 特定の項目に対する精査エラー | 新パスワードと確認用パスワードが異なる場合 |
| `addMessage(String messageId, Object... params)` | 全体に跨るエラー | 検索条件が1つも指定されなかった場合 |

> **警告**: 独自の精査処理を実装して使用する場合、バリデーションメソッド内で `ValidationUtil#validate` または `ValidationUtil#validateWithout` を呼び出さないと、フレームワーク提供のバリデータによる精査は行われない。

```java
@ValidateFor("insert")
public static void validate(ValidationContext<W11AC02Form> context) {
    ValidationUtil.validateWithout(context, new String[0]);

    if (!context.isValid()) {
        return;
    }

    W11AC02Form form = context.createObject();
    // 新パスワードと確認用パスワードのチェック
    if (!form.matchConfirmPassword()) {
        context.addResultMessage("newPassword", "MSG00003");
    }
    // 携帯電話番号が全項目入力またはひとつも入力されていないことのチェック
    if (!form.isValidateMobilePhoneNumbers()) {
        context.addResultMessage("mobilePhoneNumber", "MSG00004");
    }
}
```

- [バリデーションとEntityの生成を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/01_Core/08_Validation.html)
- [例外処理を詳しく知りたい時](../../../fw/reference/handler/HttpMethodBinding.html)
- [カスタムタグの使用方法を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07_WebView.html)

<details>
<summary>keywords</summary>

addResultMessage, addMessage, ValidationContext, 項目間精査, ValidationUtil, context.createObject, W11AC02Form, バリデーション詳細参照, 例外処理詳細参照, カスタムタグ参照

</details>
