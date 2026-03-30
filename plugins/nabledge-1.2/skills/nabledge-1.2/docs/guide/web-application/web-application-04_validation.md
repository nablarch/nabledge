# 入力内容の精査

## 本項で説明する内容

| 名称 | ステレオタイプ | 処理内容 |
|---|---|---|
| [UsersEntity.java](../../../knowledge/guide/web-application/assets/web-application-04_validation/UsersEntity.java) など | Form | テーブルに対応したクラス。精査ロジックを保持する。 |
| [W11AC02Form.java](../../../knowledge/guide/web-application/assets/web-application-04_validation/W11AC02Form.java) | Form | 画面/取引に対応したクラス。外部入力値の精査を実行するクラス。 |
| [W11AC02Action.java](../../../knowledge/guide/web-application/assets/web-application-04_validation/W11AC02Action.java) | Action | バリデーションの実行、画面入力値が設定されたオブジェクトの取得、例外処理を行う。 |
| [W11AC0201.jsp](../../../knowledge/guide/web-application/assets/web-application-04_validation/W11AC0201.jsp) | View | ユーザ情報登録画面でエラーメッセージを表示する。 |

バリデーション実装には以下の2つが必要:
1. setterにアノテーションを付与する
2. バリデーションメソッドを実装する

## アノテーションの付与

setterへのアノテーション付与例:

```java
@PropertyName("パスワード")                    // エラー発生時に表示される項目名
@Required                                      // 必須入力チェック
@SystemChar(charsetDef="asciiCharset")         // ASCII文字チェック
@Length(max = 20)                              // 最大20文字チェック
public void setConfirmPassword(String confirmPassword) {
    this.confirmPassword = confirmPassword;
}
```

バリデータの詳細は[基本バリデータ・コンバータ](../../../fw/reference/core_library/validation_basic_validators.html)および[拡張バリデータ](../../../fw/reference/core_library/validation_advanced_validators.html)を参照。

> **注意**: Integer、Long、BigDecimalといった数値型プロパティには`@Digits`アノテーションを設定する。Webアプリケーションでは外部入力は文字列のみのため、数値型プロパティへの値設定にはデータ型変換が必要。`@Digits`を設定することで数値精査とデータ型変換が実行される。

数値型プロパティのバリデーション例(SystemAccountEntity):

```java
@PropertyName("認証失敗回数")
@Required
@Digits(integer = 1, fraction = 0)  // 整数部桁数・小数部桁数を指定
@NumberRange(min = 0, max = 9)      // 桁数以外に最大値・最小値を指定
public void setFailedCount(Integer failedCount) {
    this.failedCount = failedCount;
}
```

## バリデーションメソッドの実装

`@ValidateFor`アノテーションを付与したバリデーションメソッドをFormに追加する。このアノテーションの値はバリデーション実施時に使用する（[04_action](#) 参照）。

処理に応じて精査対象プロパティを切り替えたい場合は、処理ごとにバリデーションメソッドを用意すること（詳細は [multiple_validation_method](#) 参照）。

| 用意する配列 | 呼び出すメソッド |
|---|---|
| バリデーション対象プロパティ名の配列 | `ValidationUtil#validate` |
| バリデーション対象外プロパティ名の配列 | `ValidationUtil#validateWithout` |

呼び出し後、`ValidationContext#isValid`（エラーなしの場合true）でバリデーション結果を確認する。

バリデーション対象プロパティ配列を使用した例:

```java
private static final String[] REGISTER_USER_VALIDATE_PROPS = new String[]{"ugroupId"};

@ValidateFor("registerUser")
public static void validateForRegisterUser(
        ValidationContext<UgroupSystemAccountEntity> context) {
    ValidationUtil.validate(context, REGISTER_USER_VALIDATE_PROPS);
}
```

バリデーション対象外プロパティ配列を使用した例:

```java
private static final String[] REGISTER_USER_SKIP_PROPS = new String[]{"userId", "insertUserId",
        "insertDate", "updatedUserId", "updatedDate"};

@ValidateFor("registerUser")
public static void validateForRegisterUser(ValidationContext<UsersEntity> context) {
    ValidationUtil.validateWithout(context, REGISTER_USER_SKIP_PROPS);
}
```

EntityクラスをプロパティとしてもつFormも同様に精査対象を指定できる。この場合、Formクラスの精査メソッドに`@ValidateFor`で指定した名称と同じ名称の精査メソッドが各Entityクラスで呼び出される。

EntityクラスをプロパティとしてもつFormの例（W11AC02Form）:

```java
@ValidateFor("registerUser")
public static void validateForRegister(ValidationContext<W11AC02Form> context) {
    /* Form内のプロパティは全て精査対象。
       "newPassword"、"confirmPassword"はsetterに直接設定したバリデーションを行う。
       それ以外の項目は、各Entityクラスの精査メソッドが呼び出される。
       呼び出される精査メソッドは、各Entity内で@ValidateFor("registerUser")が指定されている精査メソッドである。 */
    ValidationUtil.validateWithout(context, new String[0]);

    if (!context.isValid()) {
        return;
    }
    // 後略
}
```

処理ごとに異なる精査が必要な場合（登録処理と更新処理で精査内容が異なる場合など）、処理に応じた精査メソッドを追加する。各メソッドの`@ValidateFor`アノテーションの値は互いに異なる値にし、バリデーション実行時（[04_action](#)参照）に呼び分ける。

**アノテーション**: `@ValidateFor`

更新用精査メソッドの追加例：

```java
@ValidateFor("updateUser")
public static void validateForUpdate(ValidationContext<SearchCondition> context) {
    // ...
}
```

> **注意**: テーブルの項目に対応するプロパティが一つもないBeanも、Formと同様な作りにすることでバリデーション等のフレームワーク機能を使用できる。その場合、`ListSearchInfo`（:ref:`ページングを使用した一覧表示<custom_tag_paging_paging>`参照）を継承する。

複数の`@ValidateFor`メソッドを持つFormの実装例（`W11AC01SearchForm extends ListSearchInfo`）：

```java
public class W11AC01SearchForm extends ListSearchInfo {
    private String loginId;
    private String kanjiName;
    private String kanaName;
    private String ugroupId;
    private String userIdLocked;
    private SystemAccountEntity systemAccount;

    @PropertyName("ログインID")
    @Length(max = 20)
    @SystemChar(charsetDef="asciiCharset")
    public void setLoginId(String loginId) { this.loginId = loginId; }

    @PropertyName("漢字氏名")
    @Length(max = 50)
    @SystemChar(charsetDef="zenkakuCharset")
    public void setKanjiName(String kanjiName) { this.kanjiName = kanjiName; }

    @PropertyName("カナ氏名")
    @Length(max = 50)
    @SystemChar(charsetDef="zenkakuKatakanaCharset")
    public void setKanaName(String kanaName) { this.kanaName = kanaName; }

    @PropertyName("グループID")
    @Length(min = 10, max = 10)
    @SystemChar(charsetDef="numericCharset")
    public void setUgroupId(String ugroupId) { this.ugroupId = ugroupId; }

    @PropertyName("ユーザIDロック")
    @CodeValue(codeId = "C0000001")
    public void setUserIdLocked(String userIdLocked) { this.userIdLocked = userIdLocked; }

    @PropertyName("開始ページ")
    @Required
    @NumberRange(max = 10, min = 1)
    @Digits(integer = 2)
    public void setPageNumber(Integer pageNumber) { super.setPageNumber(pageNumber); }

    @PropertyName("ソートID")
    @Required
    public void setSortId(String sortId) { super.setSortId(sortId); }

    @ValidationTarget
    public void setSystemAccount(SystemAccountEntity systemAccount) { this.systemAccount = systemAccount; }

    private static final String[] SEARCH_COND_PROPS =
        new String[] {"loginId", "kanjiName", "kanaName", "ugroupId", "userIdLocked", "pageNumber", "sortId"};

    @ValidateFor("search")
    public static void validateForSearch(ValidationContext<W11AC01SearchForm> context) {
        ValidationUtil.validate(context, SEARCH_COND_PROPS);
        if (!context.isValid()) return;
        // 項目間精査: getConvertedValueで変換済み値を取得して確認
        String loginId = (String) context.getConvertedValue("loginId");
        String kanjiName = (String) context.getConvertedValue("kanjiName");
        String kanaName = (String) context.getConvertedValue("kanaName");
        String ugroupId = (String) context.getConvertedValue("ugroupId");
        String userIdLocked = (String) context.getConvertedValue("userIdLocked");
        // 検索条件のうち少なくとも1つが指定されているか確認
        if (!isValidSearchCondition(loginId, kanjiName, kanaName, ugroupId, userIdLocked)) {
            context.addMessage("MSG00006");
        }
    }

    // 検索条件のうち少なくとも1つが指定されているかを確認する
    private static boolean isValidSearchCondition(String loginId, String kanjiName,
            String kanaName, String ugroupId, String userIdLocked) {
        return loginId.length() > 0 || kanjiName.length() > 0 || kanaName.length() > 0
                || ugroupId.length() > 0 || userIdLocked.length() > 0;
    }

    @ValidateFor("selectUserInfo")
    public static void validateForSelectUser(ValidationContext<W11AC01SearchForm> context) {
        ValidationUtil.validate(context, new String[]{"systemAccount"});
    }
}
```

**アノテーション**: `@OnError`, `@ValidateFor`
**クラス**: `ValidationUtil`, `ValidationContext`, `ApplicationException`, `W11AC02Form`, `SystemAccountEntity`, `CM311AC1Component`, `MessageUtil`, `MessageLevel`

`@OnError`アノテーションで`ApplicationException`発生時の遷移先を指定する。`type`に例外クラス、`path`に遷移先（HttpResponseの引数と同じ記述方法）を指定する。

```java
@OnError(
    type = ApplicationException.class,
    path = "forward://RW11AC0201"
)
public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
    validate(req);
    // ...
}

private W11AC02Form validate(HttpRequest req) {
    // 第4引数"registerUser"はW11AC02Formの@ValidateFor("registerUser")アノテーションで
    // 指定しているメソッドを実行する（グループ名でバリデーション対象メソッドを特定する）
    ValidationContext<W11AC02Form> context = ValidationUtil.validateAndConvertRequest(
        "W11AC02", W11AC02Form.class, req, "registerUser");

    if (!context.isValid()) {
        throw new ApplicationException(context.getMessages());
    }

    W11AC02Form form = context.createObject();
    SystemAccountEntity systemAccount = form.getSystemAccount();
    CM311AC1Component function = new CM311AC1Component();

    // ログインIDのチェック
    checkLoginId(systemAccount.getLoginId());

    // グループIDのチェック（null guardなし）
    if (!function.existGroupId(form.getUgroupSystemAccount())) {
        throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR,
                "MSG00002", MessageUtil.getStringResource("S0020001")));
    }

    // 認可単位IDのチェック（null guardあり）
    if (systemAccount.getPermissionUnit() != null
            && !function.existPermissionUnitId(systemAccount)) {
        throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR,
                "MSG00002", MessageUtil.getStringResource("S0030001")));
    }

    return form;
}
```

バリデーション処理の流れ:
1. `ValidationUtil.validateAndConvertRequest()`でバリデーション（プレフィックス名、Formクラス、リクエスト、グループ名を引数に指定）
   - 第4引数のグループ名（例: `"registerUser"`）は、Formクラスのメソッドに付与した`@ValidateFor("registerUser")`アノテーションと対応する
2. `context.isValid()`でエラー有無を確認
3. バリデーションエラーがある場合は`context.getMessages()`を引数に`ApplicationException`をthrow
4. エラーがない場合は`context.createObject()`で画面入力値が設定されたフォームオブジェクトを生成
5. ビジネスロジックのエラーチェックでは`MessageUtil.createMessage(MessageLevel.ERROR, messageId, MessageUtil.getStringResource(resourceId))`でメッセージを生成し、`ApplicationException`をthrow
   - null guardなしのパターン: `existGroupId`のように直接チェックする
   - null guardありのパターン: `getPermissionUnit() != null`を先に確認してからチェックする（`existPermissionUnitId`の例）

> **注意**: バリデーション処理をプライベートメソッドに切り出すことは必須ではない。

> **注意**: `@OnError`の`path`の記述方法はHttpResponseの引数と同じ。詳細は:ref:`画面初期表示のActionの作成<makeActionClass>`参照。

<details>
<summary>keywords</summary>

W11AC02Form, W11AC02Action, UsersEntity, SystemAccountEntity, UgroupSystemAccountEntity, バリデーション, 入力値精査, Formクラス, Actionクラス, @PropertyName, @Required, @SystemChar, @Length, @Digits, @NumberRange, @ValidateFor, ValidationUtil, ValidationContext, バリデーション実装, アノテーション付与, 数値型バリデーション, バリデーションメソッド, @ValidationTarget, ListSearchInfo, W11AC01SearchForm, @CodeValue, 複数バリデーションメソッド, 処理ごとのバリデーション, 検索条件フォーム, @OnError, ApplicationException, validateAndConvertRequest, isValid, createObject, getMessages, MessageUtil, MessageLevel, getStringResource, CM311AC1Component, バリデーション実施, エラーハンドリング

</details>

## 作成手順

Formクラスを新規に作成する。Formクラスには、画面から入力する値や取引で必要となる精査処理（単項目精査や項目間精査）を実装する。

独自精査（項目間精査）もバリデーションメソッド内で実装する。精査エラーの場合はValidationContextにエラーメッセージを格納し処理を終了する。エラーがない場合は特に何もしない。

| メソッド | 用途 |
|---|---|
| `addResultMessage(String propertyName, String messageId, Object... params)` | 特定項目に対する精査エラー（例: 新パスワードと確認用パスワードが異なる場合） |
| `addMessage(String messageId, Object... params)` | 全体に跨るエラー（例: 検索条件が1つも指定されなかった場合。詳細は :ref:`入力内容を保持するBean(検索条件など)<validation_searchCondition>` 参照） |

項目間精査の実装例（新パスワードと確認用パスワードの一致チェック）:

```java
@ValidateFor("registerUser")
public static void validateForRegister(ValidationContext<W11AC02Form> context) {
    ValidationUtil.validateWithout(context, new String[0]);

    // 単項目精査でエラーの場合はここで戻る
    if (!context.isValid()) {
        return;
    }

    W11AC02Form form = context.createObject();
    // 新パスワードと確認用パスワードのチェック
    if (!form.newPassword.equals(form.confirmPassword)) {
        context.addResultMessage("newPassword", "MSG00003");
    }
}
```

> **警告**: 独自精査処理内で`ValidationUtil#validate`または`ValidationUtil#validateWithout`を呼び出さないと、フレームワークが提供するバリデータによる精査は行われない。

Formのプロパティの表示名を変更したい場合（例：継承元Entityの"ユーザ名"を"氏名"として表示）、Formで対応するプロパティのsetterをオーバーライドし、`@PropertyName`アノテーションに変更後の表示名を指定する。バリデーションは継承元の指定がそのまま引き継がれる。

**アノテーション**: `@PropertyName`

```java
public class UserRegisterForm extends UserEntity {
    @PropertyName("氏名")
    // setterをオーバーライドして@PropertyNameで表示名を変更。バリデーションは継承元のものが継承される
    public void setName(String name) {
        super.setName(name);
    }
}
```

継承元クラス（`UserEntity`）：

```java
public class UserEntity {
    @PropertyName("ID")
    @Required
    @Length(min=6, max=10)
    public void setId(String id) { this.id = id; }

    @PropertyName("ユーザ名")  // 元の表示名
    @Required
    @Length(min=6, max=10)
    public void setName(String name) { this.name = name; }

    @PropertyName("備考")
    @Length(max=100)
    public void setRemarks(String remarks) { this.remarks = remarks; }
}
```

**タグ**: `n:errors`, `n:error`

- `n:errors`: 複数のエラーメッセージを一覧表示（各入力項目以外のエラーを画面上部に一覧表示する場合などに使用）
- `n:error`: 各入力項目のエラーメッセージを表示（入力項目の下に表示する場合などに使用）

> **注意**: `n:errors`タグの記述を外出しにすることは必須ではない。

入力項目のカスタムタグのname属性（リクエストパラメータ名）の形式:

- Formに追加したEntityのプロパティを指定する場合: `<バリデーションで指定するプレフィックス名>.<FormでのEntityのプロパティ名>.<Entityでのプロパティ名>`
- Formに直接追加したプロパティを指定する場合: `<バリデーションで指定するプレフィックス名>.<プロパティ名>`

ユーザ情報登録ではFormに対して`W11AC02`というプレフィックスを使用。

<details>
<summary>keywords</summary>

Formの生成, 単項目精査, 項目間精査, Formクラス作成, バリデーション, ValidationContext, addResultMessage, addMessage, カスタムバリデーション, 精査エラー設定, @ValidateFor, ValidationUtil, W11AC02Form, @PropertyName, UserRegisterForm, UserEntity, プロパティ表示名カスタマイズ, setterオーバーライド, 表示名変更, n:errors, n:error, name属性, エラーメッセージ表示, JSP, カスタムタグ, プレフィックス, W11AC0201

</details>

## プロパティの追加

- テーブルの項目に対応するプロパティ → そのテーブルに対応するEntityクラスをFormクラスのプロパティとして追加する
- テーブルの項目に対応しないプロパティ → 直接Formクラスに追加する

> **注意**: テーブルと1対1に対応付けられたFormをEntityと呼ぶ。

1. Formにプロパティ（メンバ変数、setter、getter）を追加する。
2. FormのMapを引数にとるコンストラクタに、追加したプロパティの値を設定する処理を追加する。

setterには精査用のアノテーションを付加する。Entityクラスのプロパティのsetterには `@ValidationTarget` を指定し、Entityクラス内で実装された精査処理の呼び出し対象であることを示す。

```java
public class W11AC02Form {

    private UsersEntity users;
    private SystemAccountEntity systemAccount;
    private UgroupSystemAccountEntity ugroupSystemAccount;
    private String newPassword;
    private String confirmPassword;

    public W11AC02Form(Map<String, Object> params) {
        users = (UsersEntity) params.get("users");
        systemAccount = (SystemAccountEntity) params.get("systemAccount");
        ugroupSystemAccount = (UgroupSystemAccountEntity) params.get("ugroupSystemAccount");
        newPassword = (String) params.get("newPassword");
        confirmPassword = (String) params.get("confirmPassword");
    }

    @PropertyName("パスワード")
    @Required
    @SystemChar(charsetDef="asciiCharset")
    @Length(max = 20)
    public void setNewPassword(String newPassword) { this.newPassword = newPassword; }

    @PropertyName("パスワード")
    @Required
    @SystemChar(charsetDef="asciiCharset")
    @Length(max = 20)
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }

    @ValidationTarget
    public void setUsers(UsersEntity users) { this.users = users; }

    @ValidationTarget
    public void setSystemAccount(SystemAccountEntity systemAccount) { this.systemAccount = systemAccount; }

    @ValidationTarget
    public void setUgroupSystemAccount(UgroupSystemAccountEntity ugroupSystemAccountEntity) {
        this.ugroupSystemAccount = ugroupSystemAccountEntity;
    }
}
```

バリデーション実行と画面入力値が設定されたオブジェクトの取得手順：

a. `ValidationUtil#validateAndConvertRequest`を使用してバリデーションを実行する。独自実装のバリデーションメソッドを実行するには、「バリデーション対象メソッド」引数付きの`validateAndConvertRequest`を使用する。この引数の値を`@ValidateFor`アノテーションで設定した値と一致させることで、対応する独自バリデーションメソッドが実行される。
b. `ValidationContext#isValid`でバリデーションエラーの発生を確認し、エラーがあった場合はエラーメッセージが設定されたアプリケーション例外をthrowする。
c. `ValidationContext#createObject`を使用して画面入力値が設定されたオブジェクトを取得する。取得できるクラスは`validateAndConvertRequest`の第2引数に設定したクラスとなる。

使用するメソッドシグネチャ：
`validateAndConvertRequest(String prefix, Class<T> targetClass, Validatable<?> request, String validateFor)`

具体例は:ref:`04_actionClassCreate`を参照。

- [バリデーションとEntityの生成を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/01_Core/08_Validation.html)
- [例外処理を詳しく知りたい時](../../../fw/reference/handler/HttpMethodBinding.html)
- [カスタムタグの使用方法を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07_WebView.html)

<details>
<summary>keywords</summary>

W11AC02Form, UsersEntity, SystemAccountEntity, UgroupSystemAccountEntity, @ValidationTarget, @PropertyName, @Required, @SystemChar, @Length, プロパティ追加, Entityクラス, バリデーション, ValidationUtil, ValidationContext, validateAndConvertRequest, isValid, createObject, バリデーション実行, 画面入力値取得, @ValidateFor, Entityの生成, 例外処理, カスタムタグ, HttpMethodBinding, WebView

</details>

## 例外発生時の処理

ComponentやActionで例外が発生した場合、デフォルトではHTTPステータス500のレスポンスがブラウザに返される。この応答を変更する場合は、例外処理が必要なメソッドに`@OnError`アノテーションを付与し、例外発生時の遷移先を指定する。

**アノテーション**: `@OnError`

具体例は:ref:`04_actionClassCreate`を参照。

<details>
<summary>keywords</summary>

@OnError, 例外処理, HTTP 500, 例外発生時の遷移先

</details>
