# 入力内容の精査

## 

本項で説明する内容：

- データベースアクセスを伴わない単項目精査・項目間精査
- 画面より入力された情報を持ったオブジェクトの取得
- エラー（例外）発生時の処理

## アノテーションの付与

**アノテーション**: `@PropertyName`, `@Required`, `@SystemChar`, `@Length`, `@Digits`, `@NumberRange`

setterにアノテーションを付与してバリデーションを設定する。

```java
@PropertyName("パスワード")
@Required
@SystemChar(charsetDef="asciiCharset")
@Length(max = 20)
public void setConfirmPassword(String confirmPassword) {
    this.confirmPassword = confirmPassword;
}
```

> **注意**: Integer、Long、BigDecimal などの数値型プロパティには `@Digits` アノテーションを設定すること。Webアプリケーションでは外部入力は文字列のため、`@Digits` を設定することで数値精査とデータ型変換が実行される。`integer` に整数部桁数、`fraction` に小数部桁数を指定する。

数値型プロパティの例（`SystemAccountEntity`）:

```java
@PropertyName("認証失敗回数")
@Required
@Digits(integer = 1, fraction = 0)
@NumberRange(min = 0, max = 9)
public void setFailedCount(Integer failedCount) {
    this.failedCount = failedCount;
}
```

登録処理時と更新処理時で精査内容が異なる場合など、複数の精査メソッドが必要な場合は、処理に応じた精査メソッドを追加する。各メソッドの`@ValidateFor`アノテーションの値は異なるものにし、バリデーション実施時（[04_action](#) 参照）に呼び分ける。

```java
@ValidateFor("updateUser")
public static void validateForUpdate(ValidationContext<SearchCondition> context) {
    // 中略
}
```

> **注意**: テーブルの項目に対応するプロパティが一つもない場合（例: 検索条件を保持するBean）も、FormとしてBeanを作成すれば、バリデーション等のアプリケーションフレームワーク提供機能を使用できる。

`ListSearchInfo`を継承した検索条件Formの実装例（`W11AC01SearchForm`、:ref:`ページングを使用した一覧表示<custom_tag_paging_paging>` 参照）:

```java
public class W11AC01SearchForm extends ListSearchInfo {
    private String loginId;
    private String kanjiName;
    private String kanaName;
    private String ugroupId;
    private String userIdLocked;
    private SystemAccountEntity systemAccount;

    public W11AC01SearchForm(Map<String, Object> params) {
        loginId = (String) params.get("loginId");
        kanjiName = (String) params.get("kanjiName");
        kanaName = (String) params.get("kanaName");
        ugroupId = (String) params.get("ugroupId");
        userIdLocked = (String) params.get("userIdLocked");
        setPageNumber((Integer) params.get("pageNumber"));
        setSortId((String) params.get("sortId"));
        systemAccount = (SystemAccountEntity) params.get("systemAccount");
    }

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

    public String[] getSearchConditionProps() { return SEARCH_COND_PROPS; }

    @ValidateFor("search")
    public static void validateForSearch(ValidationContext<W11AC01SearchForm> context) {
        ValidationUtil.validate(context, SEARCH_COND_PROPS);
        if (!context.isValid()) return;
        String loginId = (String) context.getConvertedValue("loginId");
        String kanjiName = (String) context.getConvertedValue("kanjiName");
        String kanaName = (String) context.getConvertedValue("kanaName");
        String ugroupId = (String) context.getConvertedValue("ugroupId");
        String userIdLocked = (String) context.getConvertedValue("userIdLocked");
        if (!isValidSearchCondition(loginId, kanjiName, kanaName, ugroupId, userIdLocked)) {
            context.addMessage("MSG00006");
        }
    }

    private static final String[] SELECT_USER_PROPS = new String[] {"systemAccount"};

    @ValidateFor("selectUserInfo")
    public static void validateForSelectUser(ValidationContext<W11AC01SearchForm> context) {
        ValidationUtil.validate(context, SELECT_USER_PROPS);
    }

    private static boolean isValidSearchCondition(String loginId, String kanjiName,
            String kanaName, String ugroupId, String userIdLocked) {
        return loginId.length() > 0 || kanjiName.length() > 0 || kanaName.length() > 0
                || ugroupId.length() > 0 || userIdLocked.length() > 0;
    }
}
```

[04_validation](#) と :ref:`04_errHandling` に従い `W11AC02Action` クラスに以下のメソッドを実装する。

**処理フロー**:
1. `@OnError`アノテーションで`ApplicationException`発生時のフォワード先を指定（`path`で指定）
2. `ValidationUtil.validateAndConvertRequest()`でバリデーションと変換を実施
3. `context.abortIfInvalid()`でエラー項目が存在する場合のみ`ApplicationException`をthrow
4. `context.createObject()`で画面入力値オブジェクトを生成
5. ビジネスロジックを実行

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
    // W11AC02Formの@ValidateForアノテーションで"registerUser"を指定したメソッドを実行
    ValidationContext<W11AC02Form> context = ValidationUtil.validateAndConvertRequest(
        "W11AC02", W11AC02Form.class, req, "registerUser");
    context.abortIfInvalid(); // エラー項目存在時のみApplicationExceptionをthrow
    W11AC02Form form = context.createObject();
    SystemAccountEntity systemAccount = form.getSystemAccount();
    CM311AC1Component function = new CM311AC1Component();
    // ログインID・グループID・認可単位IDのチェック
    // エラー時: throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, ...));
    return form;
}
```

バリデーション処理をプライベートメソッドに切り出す必要は**ない**。

> **注意**: `doRW11AC0201`メソッドは、ユーザ情報登録画面を表示する処理。`@OnError`の`path="forward://RW11AC0201"`はエラー発生時にこのメソッドを実行することを意味する。

> **注意**: `@OnError`の`path`の記述方法は`HttpResponse`の引数と同じ。詳細は :ref:`画面初期表示のActionの作成<makeActionClass>` 参照。

<details>
<summary>keywords</summary>

バリデーション, 単項目精査, 項目間精査, 入力値取得, エラー処理, 入力内容の精査, @PropertyName, @Required, @SystemChar, @Length, @Digits, @NumberRange, 数値型プロパティ, バリデーション実装, アノテーション, SystemAccountEntity, W11AC02Form, @ValidateFor, ValidationContext, ValidationUtil, W11AC01SearchForm, ListSearchInfo, @CodeValue, @ValidationTarget, SearchCondition, 複数バリデーションメソッド, 検索条件Form, バリデーション呼び分け, W11AC02Action, ApplicationException, @OnError, validateAndConvertRequest, abortIfInvalid, createObject, CM311AC1Component, MessageUtil, MessageLevel, HttpResponse, HttpRequest, ExecutionContext, エラーハンドリング, 入力精査, アクションクラス

</details>

## 作成内容

| ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| [UsersEntity.java](../../../knowledge/guide/web-application/assets/web-application-04_validation/UsersEntity.java) など | Form | DBテーブルに対応したクラス。テーブルへ設定する情報を保持し、業務処理に必要な精査ロジックを保持する。 |
| [W11AC02Form.java](../../../knowledge/guide/web-application/assets/web-application-04_validation/W11AC02Form.java) | Form | 画面/取引に対応したクラス。取引で使用するデータを保持し、外部入力値の精査を実行する。 |
| [W11AC02Action.java](../../../knowledge/guide/web-application/assets/web-application-04_validation/W11AC02Action.java) | Action | バリデーション実行・入力値オブジェクト取得・例外処理を担当。Formクラスのメソッドを呼び出し、結果をリクエストスコープに格納してJSPへ遷移する。 |
| [W11AC0201.jsp](../../../knowledge/guide/web-application/assets/web-application-04_validation/W11AC0201.jsp) | View | ユーザ情報登録画面で入力誤りがあった場合にエラーメッセージを表示する。 |

ステレオタイプについては :ref:`stereoType` 参照。

## バリデーションメソッドの実装

**アノテーション**: `@ValidateFor`

**クラス**: `ValidationUtil`, `ValidationContext`

Formにstaticメソッドとしてバリデーションメソッドを追加し、`@ValidateFor` アノテーションを付与する。処理に応じて精査対象プロパティを切り替えたい場合は、処理ごとにメソッドを用意する（例: 登録処理用と更新処理用を別々に実装）。

バリデーション対象の指定方法と呼び出しメソッドの対応:

| 用意する配列 | 呼び出すメソッド |
|---|---|
| バリデーション対象としたいプロパティ名の配列 | `ValidationUtil#validate` |
| バリデーション対象外としたいプロパティ名の配列 | `ValidationUtil#validateWithout` |

バリデーション後、`ValidationContext#isValid()` でエラー有無を確認する（エラーなし = true）。

バリデーション対象プロパティを指定する場合（`UgroupSystemAccountEntity`）:

```java
private static final String[] REGISTER_USER_VALIDATE_PROPS = new String[]{"ugroupId"};

@ValidateFor("registerUser")
public static void validateForRegisterUser(ValidationContext<UgroupSystemAccountEntity> context) {
    ValidationUtil.validate(context, REGISTER_USER_VALIDATE_PROPS);
}
```

バリデーション対象外プロパティを指定する場合（`UsersEntity`）:

```java
private static final String[] REGISTER_USER_SKIP_PROPS = new String[]{"userId", "insertUserId",
        "insertDate", "updatedUserId", "updatedDate"};

@ValidateFor("registerUser")
public static void validateForRegisterUser(ValidationContext<UsersEntity> context) {
    ValidationUtil.validateWithout(context, REGISTER_USER_SKIP_PROPS);
}
```

Entityクラスをプロパティとして持つFormの場合、`@ValidateFor` で指定した名称と同じ名称の精査メソッドが各Entityクラスで呼び出される（`W11AC02Form` の例）:

```java
@ValidateFor("registerUser")
public static void validateForRegister(ValidationContext<W11AC02Form> context) {
    // Form内プロパティは全て精査対象
    // Entity内の @ValidateFor("registerUser") が指定された精査メソッドが呼び出される
    ValidationUtil.validateWithout(context, new String[0]);

    if (!context.isValid()) {
        return;
    }
    // 後略
}
```

Formのプロパティ表示名（バリデーションエラー時に画面に出力される名前）を変更するには、対応するsetterをオーバーライドして`@PropertyName`アノテーションを付与する。バリデーションは継承元の指定がそのまま引き継がれる。

```java
public class UserRegisterForm extends UserEntity {
    @PropertyName("氏名")  // 元のUserEntityでは"ユーザ名"
    public void setName(String name) {
        super.setName(name);
    }
}
```

継承元クラス（`UserEntity`）:

```java
public class UserEntity {
    private String id;
    private String name;
    private String remarks;

    public User(Map<String, Object> params) {
        id = (String) params.get("id");
        name = (String) params.get("name");
        remarks = (String) params.get("remarks");
    }

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

エラーメッセージ表示には以下のタグを使用する:

- **`n:errors`タグ**: 複数のエラーメッセージを一覧表示（各入力項目以外のエラーを画面上部に表示）
- **`n:error`タグ**: 各入力項目のエラーメッセージ表示（入力項目の下に表示）

入力項目カスタムタグの`name`属性の形式:

- Formに追加したEntityのプロパティを指定する場合:
  ```
  <バリデーションで指定するプレフィックス名>.<FormでのEntityのプロパティ名>.<Entityでのプロパティ名>
  ```
- Formに直接追加したプロパティを指定する場合:
  ```
  <バリデーションで指定するプレフィックス名>.<プロパティ名>
  ```

ユーザ情報登録では、Formに対して`W11AC02`というプレフィックスを使用している。

<details>
<summary>keywords</summary>

W11AC02Form, W11AC02Action, W11AC0201.jsp, UsersEntity, Form, Action, View, ステレオタイプ, ValidationUtil, ValidationContext, @ValidateFor, バリデーションメソッド, validate, validateWithout, isValid, UgroupSystemAccountEntity, @PropertyName, UserRegisterForm, UserEntity, @Required, @Length, プロパティ表示名カスタマイズ, 表示名オーバーライド, バリデーション継承, n:errors, n:error, JSP作成, エラーメッセージ表示, カスタムタグ, name属性, バリデーションエラー表示, View(JSP)の作成

</details>

## 

画面/取引に対応したFormクラスを新規作成する。Formクラスには、画面入力値と取引に必要な精査処理（単項目精査・項目間精査）を実装する。

## 独自の精査処理(項目間精査)を行いたい場合

独自の精査処理（項目間精査）はバリデーションメソッド内で実装する。

精査エラー時は `ValidationContext` にエラーメッセージを格納して処理を終了する。エラーがなかった場合は何もしない。

| メソッド | 用途 | 例 |
|---|---|---|
| `addResultMessage(String propertyName, String messageId, Object... params)` | 特定の項目に対する精査エラー | 新パスワードと確認用パスワードが異なる場合 |
| `addMessage(String messageId, Object... params)` | 全体に跨るエラー | 検索条件が１つ以上必要な場合に、１つも条件指定がされなかった場合 |

項目間精査の実装例（新パスワードと確認用パスワードの一致チェック）:

```java
@ValidateFor("registerUser")
public static void validateForRegister(ValidationContext<W11AC02Form> context) {
    ValidationUtil.validateWithout(context, new String[0]);

    if (!context.isValid()) {
        return;
    }

    W11AC02Form form = context.createObject();
    if (!form.newPassword.equals(form.confirmPassword)) {
        context.addResultMessage("newPassword", "MSG00003");
    }
}
```

> **警告**: 独自の精査処理内で `ValidationUtil#validate` または `ValidationUtil#validateWithout` を呼び出さないと、フレームワーク提供バリデータによる精査が行われない。

バリデーションの実行と画面入力値取得の手順:

1. `ValidationUtil#validateAndConvertRequest`でバリデーションを実行する。独自実装のバリデーションメソッドを実行するには、「バリデーション対象メソッド」引数を持つオーバーロード版を使用する。この引数に`@ValidateFor`アノテーションに設定した値を指定することで、対応するメソッドが実行される。
   シグネチャ: `validateAndConvertRequest(String prefix, Class<T> targetClass, Validatable<?> request, String validateFor)`
2. `ValidationContext#abortIfInvalid`メソッドで`ApplicationException`をthrowする。
3. `ValidationContext#createObject`メソッドで画面入力値が設定されたオブジェクトを取得する。取得できるクラスは`validateAndConvertRequest`の第2引数に設定したクラス。

具体例は :ref:`04_actionClassCreate` 参照。

- [バリデーションとEntityの生成を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/01_Core/08_Validation.html)
- [例外処理を詳しく知りたい時](../../../fw/reference/handler/HttpMethodBinding.html)
- [カスタムタグの使用方法を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07_WebView.html)

<details>
<summary>keywords</summary>

Formクラス生成, Formの生成, 精査処理, 単項目精査, 項目間精査, ValidationContext, @ValidateFor, ValidationUtil, addResultMessage, addMessage, W11AC02Form, ApplicationException, validateAndConvertRequest, abortIfInvalid, createObject, Validatable, バリデーション実行, 画面入力値取得, バリデーション参考資料, 例外処理参考, カスタムタグ参考, 次に読むもの, 関連ドキュメント

</details>

## プロパティの追加

## プロパティ追加ルール

- テーブル対応プロパティ: そのテーブルに対応するEntityクラスをFormクラスのプロパティとして追加する
- テーブル非対応プロパティ: そのプロパティを直接Formクラスに追加する

> **注意**: テーブルと1対1に対応付けられたFormをEntityと呼ぶ。

## 判断基準の具体例

**テーブル対応の例**: 画面から入力する「内線番号」はユーザテーブルの「内線番号（ビル番号）」「内線番号（個人番号）」に対応している。この場合、UsersEntityクラスをFormクラスのプロパティとして追加する。

**テーブル非対応の例**: 画面から入力する「新(変更後)パスワード」と「パスワード(確認用)」は平文で入力されるが、システムアカウントテーブルには暗号化されたパスワードを格納するカラムだけがある。このため、これらのプロパティはEntityに対応付けられず、直接Formクラスのプロパティとして追加する。

## 追加手順

a. Formにプロパティ（メンバ変数・setter・getter）を追加する
b. FormのMapを引数にとるコンストラクタに、追加したプロパティの値設定処理を追加する

ComponentやActionで例外が発生した場合、デフォルトではHTTPステータス500のレスポンスが返される。応答を変更するには、対象メソッドに`@OnError`アノテーションを付与し、例外発生時の遷移先を指定する。

具体例は :ref:`04_actionClassCreate` 参照。

<details>
<summary>keywords</summary>

プロパティ追加, Entityクラス, テーブル対応プロパティ, テーブル非対応プロパティ, Mapコンストラクタ, プロパティ追加手順, @OnError, 例外発生時処理, HTTPステータス変更, 遷移先指定

</details>

## プロパティの追加

`@ValidationTarget` をEntityプロパティのsetterに指定することで、Entityクラスのプロパティが精査対象であることを示す。精査時にはEntityクラス内の精査処理が呼び出される。テーブル非対応プロパティのsetterには `@Required`、`@SystemChar`、`@Length` 等の精査アノテーションを直接付与する。

**アノテーション**: `@PropertyName`, `@Required`, `@SystemChar`, `@Length`, `@ValidationTarget`

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
    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    @PropertyName("パスワード")
    @Required
    @SystemChar(charsetDef="asciiCharset")
    @Length(max = 20)
    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

    @ValidationTarget
    public void setUsers(UsersEntity users) {
        this.users = users;
    }

    @ValidationTarget
    public void setSystemAccount(SystemAccountEntity systemAccount) {
        this.systemAccount = systemAccount;
    }

    @ValidationTarget
    public void setUgroupSystemAccount(UgroupSystemAccountEntity ugroupSystemAccountEntity) {
        this.ugroupSystemAccount = ugroupSystemAccountEntity;
    }
}
```

(:ref:`記載しているサンプルプログラムソースコードの注意事項 <sourceCode>` 参照)

<details>
<summary>keywords</summary>

@Required, @ValidationTarget, @PropertyName, @SystemChar, @Length, W11AC02Form, UsersEntity, setterアノテーション, Map引数コンストラクタ, SystemAccountEntity, UgroupSystemAccountEntity

</details>
