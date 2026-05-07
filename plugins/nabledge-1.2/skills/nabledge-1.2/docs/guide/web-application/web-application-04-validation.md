# 入力内容の精査

## 本項で説明する内容

### 説明内容

本項では、以下の内容を説明する。

* データベースアクセスを伴わない単項目精査や項目間精査
* 画面より入力された情報を持ったオブジェクトの取得
* エラー(例外)発生時の処理

### 作成内容

本項で作成するのは、下記画面遷移図の赤丸の部分である。ただし"戻る"遷移は対象外(戻る遷移については [画面遷移処理](../../guide/web-application/web-application-05-screenTransition.md#画面遷移処理) 参照のこと)。

![screenTransition.png](../../../knowledge/assets/web-application-04-validation/screenTransition.png)

編集するソースコードは以下のとおり。

| 名称(右クリック->保存でダウンロード) | ステレオタイプ | 処理内容 |
|---|---|---|
| [UsersEntity.java](../../../knowledge/assets/web-application-04-validation/UsersEntity.java) など | Form | データベースのテーブルに対応したクラス。データベースに設定する情報を保持する。 また、自クラスに設定したプロパティに関して業務処理に必要となる精査ロジックを保持する。 |
| [W11AC02Form.java](../../../knowledge/assets/web-application-04-validation/W11AC02Form.java) | Form | 画面/取引に対応したクラス。取引においてアプリケーションで使用するデータを保持する。 また、外部入力値の精査を実行するクラス。 |
| [W11AC02Action.java](../../../knowledge/assets/web-application-04-validation/W11AC02Action.java) | Action | バリデーションの実行、画面入力値が設定されたオブジェクトの取得、例外処理を行う。 上記Formクラスのメソッドを呼び出し、結果をリクエストスコープに格納、JSPに遷移させる。 |
| [W11AC0201.jsp](../../../knowledge/assets/web-application-04-validation/W11AC0201.jsp) | View | ユーザ情報登録画面の入力に誤りがあった場合、エラーメッセージを表示する。 |

ステレオタイプについては [業務コンポーネントの責務配置](../../about/about-nablarch/about-nablarch-01-NablarchOutline.md#業務コンポーネントの責務配置) を参照。

## 作成手順

### Formの生成

画面/取引に対応したFormクラスを新規に作成する。
Formクラスには、画面から入力する値や取引で必要となる精査処理（単項目精査や項目間精査）を実装する。

#### プロパティの追加

Formクラスには、画面からの入力値や取引で必要な値に対応するプロパティが必要である。
これらの値に対応するプロパティは、以下の指針に従ってFormクラスに追加する。

* プロパティがテーブルの項目に対応する場合、そのテーブルに対応するEntityクラスをFormクラスのプロパティとして追加する。
* プロパティがテーブルの項目に対応しない場合、そのプロパティを直接Formクラスに追加する。

> **Note:**
> テーブルと1対1に対応付けられたFormをEntityと呼ぶ。

前者の例を挙げると、本サンプルで画面から入力する、"内線番号"はユーザテーブルの"内線番号（ビル番号）"と"内線番号（個人番号）"に対応している。
この場合、これらのプロパティは、UsersEntityクラスをFormクラスのプロパティとして追加する。

後者の例を挙げると、本サンプルで画面から入力する、"新(変更後)パスワード"と"パスワード(確認用)"は2つが平文で入力されるが、
システムアカウントテーブルには暗号化されたパスワードを格納するカラムだけがある。
この場合、これらのプロパティは、直接Formクラスのプロパティとして追加する。

プロパティを追加する手順は以下のようになる。

Formにプロパティ(メンバ変数、setter、getter)を追加する。

FormのMapを引数にとるコンストラクタに、追加したプロパティの値を設定する処理を追加する。

W11AC02Formにプロパティを追加した例を以下に示す。

```java
/**
 * ユーザ情報入力フォーム（登録機能）。
 *
 * @author Koichi Asano
 * @since 1.1
 */
public class W11AC02Form {

    // 【説明】
    //  以下3項目は、テーブルに対応したプロパティを保持
    /**
     * ユーザテーブルの情報。
     */
    private UsersEntity users;
    /**
     * システムアカウントテーブルの情報。
     */
    private SystemAccountEntity systemAccount;
    /**
     * グループシステムアカウントテーブルの情報。
     */
    private UgroupSystemAccountEntity ugroupSystemAccount;

    // 【説明】
    //  以下2項目は、テーブルに対応しないプロパティを保持
    /** 新しいパスワード */
    private String newPassword;

    /** 確認用パスワード */
    private String confirmPassword;

    /**
     * コンストラクタ。
     */
    public W11AC02Form() {
    }

    /**
     * Mapを引数にとるコンストラクタ。
     *
     * @param params 項目名をキーとし、項目値を値とするMap
     */
    public W11AC02Form(Map<String, Object> params) {
        // 【説明】
        //  プロパティの値を設定する処理
        users = (UsersEntity) params.get("users");
        systemAccount = (SystemAccountEntity) params.get("systemAccount");
        ugroupSystemAccount = (UgroupSystemAccountEntity) params.get("ugroupSystemAccount");
        newPassword = (String) params.get("newPassword");
        confirmPassword = (String) params.get("confirmPassword");
    }

    // 【説明】
    //  プロパティに対するアクセスメソッド
    //  setterには、精査用のアノテーションを付加する。
    /**
     * 新(変更後)パスワードを取得する。
     *
     * @return 新(変更後)パスワード
     */
    public String getNewPassword() {
        return newPassword;
    }

    /**
     * 新(変更後)パスワードを設定する。
     *
     * @param newPassword 設定する新(変更後)パスワード
     */
    @PropertyName("パスワード")
    @Required
    @SystemChar(charsetDef="asciiCharset")
    @Length(max = 20)
    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    /**
     * 確認用パスワードを取得する。
     *
     * @return 確認用パスワード
     */
    public String getConfirmPassword() {
        return confirmPassword;
    }

    /**
     * 確認用パスワードを設定する。
     *
     * @param confirmPassword 設定する確認用パスワード
     */
    @PropertyName("パスワード")
    @Required
    @SystemChar(charsetDef="asciiCharset")
    @Length(max = 20)
    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

    /**
     * ユーザテーブルの情報を取得する。
     * @return ユーザテーブルの情報
     */
    public UsersEntity getUsers() {
        return users;
    }

    // 【説明】
    //  @ValidationTargetを指定して、Entityクラスのプロパティが精査対象であることを示す。
    //  精査時には、Entityクラス内で実装された精査処理を呼び出す。
    /**
     * ユーザテーブルの情報を設定する。
     * @param users ユーザテーブルの情報
     */
    @ValidationTarget
    public void setUsers(UsersEntity users) {
        this.users = users;
    }

    /**
     * システムアカウントテーブルの情報を取得する。
     *
     * @return システムアカウントテーブルの情報
     */
    public SystemAccountEntity getSystemAccount() {
        return systemAccount;
    }

    /**
     * システムアカウントテーブルの情報を設定する。。
     *
     * @param systemAccount システムアカウントテーブルの情報
     */
    @ValidationTarget
    public void setSystemAccount(SystemAccountEntity systemAccount) {
        this.systemAccount = systemAccount;
    }

    /**
     * グループシステムアカウントテーブルの情報を取得する。
     *
     * @return グループシステムアカウントテーブルの情報
     */
    public UgroupSystemAccountEntity getUgroupSystemAccount() {
        return ugroupSystemAccount;
    }

    /**
     * グループシステムアカウントテーブルの情報を設定する。
     *
     * @param ugroupSystemAccountEntity グループシステムアカウントテーブルの情報
     */
    @ValidationTarget
    public void setUgroupSystemAccount(
            UgroupSystemAccountEntity ugroupSystemAccountEntity) {
        this.ugroupSystemAccount = ugroupSystemAccountEntity;
    }

    // ～後略～
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

#### バリデーションの実装

各プロパティに対するバリデーションを行う場合、下記の実装が必要となる。

* setterにアノテーションを付与する。
* バリデーションメソッドを実装する。

##### アノテーションの付与

W11AC02Formの確認用パスワードのsetterに対してアノテーションを付与する場合の実装例を以下に示す。

```java
/**
 * 確認用パスワードを設定する。
 *
 * @param confirmPassword 設定する確認用パスワード
 */
@PropertyName("パスワード")                                  // 【説明】プロパティ名称の指定(エラー発生時に表示される項目名に使われる)
@Required                                                    // 【説明】必須入力チェック
@SystemChar(charsetDef="asciiCharset")                       // 【説明】ASCII文字のみからなる文字列であるかをチェック
@Length(max = 20)                                            // 【説明】文字列長チェック(最大20文字)
public void setConfirmPassword(String confirmPassword) {
    this.confirmPassword = confirmPassword;
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

アプリケーションフレームワークが提供しているバリデータについては、 [基本バリデータ・コンバータ](../../../fw/reference/core_library/validation_basic_validators.html) および [拡張バリデータ](../../../fw/reference/core_library/validation_advanced_validators.html) を参照。

> **Note:**
> Integer、Long、BigDecimal といった数値型のプロパティには、@Digits アノテーションを設定する。

> Webアプリケーションでは、システム外部からの入力は基本的に文字列のみからなるため、数値型のプロパティに値を設定するためにはデータ型を変換する必要がある。
> 数値型のプロパティに @Digits アノテーションを設定することで、数値精査とデータ型の変換が実行される。

> 数値型のプロパティに対するバリデーションの設定例(SystemAccountEntity)を以下に示す。

> ```java
> /**
>  * 認証失敗回数を設定する。
>  *
>  * @param failedCount 設定する認証失敗回数。
>  */
> @PropertyName("認証失敗回数")
> @Required
> @Digits(integer = 1, fraction = 0)  // 【説明】数値フォーマット指定を表す。integerには整数部桁数、fractionには小数部桁数を設定する。
> @NumberRange(min = 0, max = 9)      // 【説明】数値範囲チェック。桁数以外に最大値や最小値を指定したい場合に使用する。
> public void setFailedCount(Integer failedCount) {
>     this.failedCount = failedCount;
> }
> ```

> ( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

##### バリデーションメソッドの実装

Formにバリデーションメソッドを追加し、`@ValidateFor` アノテーションを付与する。このアノテーションの値はバリデーションを実施する際に使用する( [Actionの作成](../../guide/web-application/web-application-04-validation.md#actionの作成) 参照)。

処理に応じて精査対象のプロパティを切り替えたい場合は、処理ごとにバリデーションメソッドを用意すること。
例えばパスワードは、登録時は自動で値を設定するため精査は不要だが、パスワード更新機能では画面から入力するため精査が必要なので、
登録処理用のバリデーションメソッドと、更新処理用のバリデーションメソッドを実装する必要がある。
詳細は  [バリデーションメソッドを複数作成したい場合](../../guide/web-application/web-application-04-validation.md#バリデーションメソッドを複数作成したい場合) を参照すること。

具体的な実装としては、バリデーション対象としたいプロパティ名の配列、もしくは、バリデーション対象 **外** としたいプロパティ名の配列を用意し、
追加したバリデーションメソッド内でValidationUtilクラスのメソッドを呼び出す。

どちらの場合にどのメソッドを呼び出すかは以下のとおり。

| 用意する配列 | 呼び出すメソッド |
|---|---|
| バリデーション対象としたいプロパティ名の配列を用意した場合 | ValidationUtil#validate |
| バリデーション対象外としたいプロパティ名の配列を用意した場合 | ValidationUtil#validateWithout |

呼び出し後、ValidationContext#isValidメソッド(エラーなしの場合true)を使用してバリデーションの結果を確認し、エラー有無に応じた処理を行う。

バリデーション対象としたいプロパティ名の配列を用意した場合の例(UgroupSystemAccountEntity)を以下に示す。

```java
 // 【説明】バリデーション対象としたいプロパティの配列
 /** ユーザ登録時にバリデーションを行うプロパティ。 */
 private static final String[] REGISTER_USER_VALIDATE_PROPS = new String[]{
     "ugroupId"};

/**
 * ユーザ登録時に実施するバリデーション。
 *
 * @param context バリデーションの実行に必要なコンテキスト
 */
@ValidateFor("registerUser")
public static void validateForRegisterUser(
        ValidationContext<UgroupSystemAccountEntity> context) {
    // ugroupIdのみバリデーションを実行
    ValidationUtil.validate(context, REGISTER_USER_VALIDATE_PROPS);  /* 【説明】
                                                                         バリデーション対象としたいプロパティ
                                                                         名の配列を用意したので、
                                                                         ValidationUtil#validateを呼び出し */
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

バリデーション対象外としたいプロパティ名の配列を用意した場合の例(UsersEntity)を以下に示す。

```java
/**
 * ユーザ登録時にバリデーションを省略するプロパティ。
 */
private static final String[] REGISTER_USER_SKIP_PROPS = new String[]{"userId", "insertUserId",
        "insertDate", "updatedUserId", "updatedDate"}; // 【説明】バリデーション対象外としたいプロパティの配列

/**
 * ユーザ登録時に実施するバリデーション。
 *
 * @param context バリデーションの実行に必要なコンテキスト
 */
@ValidateFor("registerUser")
public static void validateForRegisterUser(ValidationContext<UsersEntity> context) {

    // userIdを無視してバリデーションを実行
    ValidationUtil.validateWithout(context, REGISTER_USER_SKIP_PROPS);  /* 【説明】
                                                                            バリデーション対象外としたい
                                                                            プロパティ名の配列を用意したので、
                                                                            ValidationUtil#validateWithoutを
                                                                            呼び出し */
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

上で示した例は、両方ともクラス内に直接プロパティを保持しているFormの例である。
Entityクラスをプロパティとして持つ場合のFormも同様にして精査対象を指定できる。
この場合、Formクラスの精査メソッドに@ValidateForで指定した名称と同じ名称の精査メソッドが呼び出される。

この場合の例(W11AC02Form)を以下に示す。

```java
/**
 * ユーザ登録時に実施するバリデーション
 *
 * @param context バリデーションの実行に必要なコンテキスト
 */
@ValidateFor("registerUser")
public static void validateForRegister(ValidationContext<W11AC02Form> context) {

    /* 【説明】
        Form内のプロパティは全て精査対象
        "newPassword"、"confirmPassword"はsetterに直接設定したバリデーションを行う。
        それ以外の項目は、各Entityクラスの精査メソッドが呼び出される。
        呼び出される精査メソッドは、各Entity内で@ValidateFor("registerUser")が指定されている精査メソッドである。
        例えばUsersEntityの場合、validateForRegisterUserが呼び出される。 */
    ValidationUtil.validateWithout(context, new String[0]);

    if (!context.isValid()) {
        return;
    }

    // 後略
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

#### 独自の精査処理(項目間精査)を行いたい場合

独自の精査処理(項目間精査)を行いたい場合も、バリデーションメソッド内で実装を行う。

精査エラーの場合、ValidationContextにエラーメッセージを格納し処理を終了する。使用するメソッドは下表を参照。エラーがなかった場合は特に何もしない。

| メソッド | 用途 | 例 |
|---|---|---|
| addResultMessage(String propertyName, String messageId, Object... params) | 特定の項目に対する 精査エラー | 新パスワードと確認用パスワードが 異なる場合 |
| addMessage(String messageId, Object... params) [1] | 全体に跨るエラー | 検索条件が１つ以上必要な場合に、 １つも条件指定がされなかった場合 |

脚注

具体的な使用例については、 [入力内容を保持するBean(検索条件など)](../../guide/web-application/web-application-04-validation.md#バリデーションメソッドを複数作成したい場合) を参照

W11AC02Formの例を以下に示す(後半部分が項目間精査処理)。ここでは、入力した新パスワードと、確認のために入力した確認用パスワードが一致するかどうか(一致しなければ
エラー)を精査している。

```java
/**
 * ユーザ登録時に実施するバリデーション
 *
 * @param context バリデーションの実行に必要なコンテキスト
 */
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
        // 【説明】精査エラーが発生した場合は、エラーメッセージを設定して処理を終わる
        context.addResultMessage("newPassword", "MSG00003");
    }
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

> **Warning:**
> 独自の精査処理を実装し使用する場合、その処理内でValidationUtil#validateやValidationUtil#validateWithoutを呼び出さないと、アプリケーションフレームワークが提供するバリデータによる
> 精査は行われないので、注意すること。

#### バリデーションメソッドを複数作成したい場合

登録処理時と更新処理時で精査内容が異なる場合など、独自の精査処理が複数必要になる場合がある。
この場合、それぞれ処理に応じた精査メソッドを追加する。
各メソッドに付与する `@ValidateFor` アノテーションの値は異なるものにしておき、
バリデーションを実施する際( [Actionの作成](../../guide/web-application/web-application-04-validation.md#actionの作成) 参照)に呼び分ける。

例えば、更新用に精査メソッドを追加する場合は以下のようになる。

```java
// 【説明】アノテーションの値を他の精査メソッドと別のものにしておく
@ValidateFor("updateUser")
public static void validateForUpdate(ValidationContext<SearchCondition> context) {
   // 中略
}
```

> **Note:**
> 本項で説明したFormはテーブルの項目に対応したプロパティがあったので、FormのプロパティとしてEntityを追加した。
> しかし、テーブルの項目に対応するプロパティが一つもない場合がある。
> 例えば検索画面で、入力された検索条件を保持するBeanを作成することがある。このとき、このBeanが保持する入力値に対するバリデーションや画面入力値の取得処理を記述しなければ
> ならない。ここで、このBeanをFormと同様な作りとすれば、バリデーションなどのアプリケーションフレームワーク提供機能を使用することができ、個別に処理を記述する必要はなくなる。
> このようなBeanの例を以下に示す。

> 下記クラスが継承しているListSearchInfoについては、 [ページングを使用した一覧表示](../../guide/web-application/web-application-function.md#ページングを使用した一覧表示) を参照。

> ```java
> public class W11AC01SearchForm extends ListSearchInfo {
> 
>     /** ログインID */
>     private String loginId;
> 
>     /** 漢字氏名 */
>     private String kanjiName;
> 
>     /** カナ氏名 */
>     private String kanaName;
> 
>     /** グループID */
>     private String ugroupId;
> 
>     /** ユーザIDロック */
>     private String userIdLocked;
> 
>     /** システムアカウントテーブルの情報 */
>     private SystemAccountEntity systemAccount;
> 
>     /**
>      * コンストラクタ
>      * @param params パラメータ
>      */
>     public W11AC01SearchForm(Map<String, Object> params) {
>         loginId = (String) params.get("loginId");
>         kanjiName = (String) params.get("kanjiName");
>         kanaName = (String) params.get("kanaName");
>         ugroupId = (String) params.get("ugroupId");
>         userIdLocked = (String) params.get("userIdLocked");
>         setPageNumber((Integer) params.get("pageNumber"));
>         setSortId((String) params.get("sortId"));
>         systemAccount = (SystemAccountEntity) params.get("systemAccount");
>     }
> 
>     /**
>      * デフォルトコンストラクタ
>      */
>     public W11AC01SearchForm() {
> 
>     }
> 
>     /**
>      * ログインIDを取得する。
>      * @return ログインID
>      */
>     public String getLoginId() {
>         return loginId;
>     }
> 
>     /**
>      * ログインIDを設定する。
>      * @param loginId ログインID
>      */
>     @PropertyName("ログインID")
>     @Length(max = 20)
>     @SystemChar(charsetDef="asciiCharset")
>     public void setLoginId(String loginId) {
>         this.loginId = loginId;
>     }
> 
>     /**
>      * 漢字氏名を取得する。
>      * @return 漢字氏名
>      */
>     public String getKanjiName() {
>         return kanjiName;
>     }
> 
>     /**
>      * 漢字氏名を設定する。
>      * @param kanjiName 漢字氏名
>      */
>     @PropertyName("漢字氏名")
>     @Length(max = 50)
>     @SystemChar(charsetDef="zenkakuCharset")
>     public void setKanjiName(String kanjiName) {
>         this.kanjiName = kanjiName;
>     }
> 
>     /**
>      * カナ氏名を取得する。
>      * @return カナ氏名
>      */
>     public String getKanaName() {
>         return kanaName;
>     }
> 
>     /**
>      * カナ氏名を設定する。
>      * @param kanaName カナ氏名
>      */
>     @PropertyName("カナ氏名")
>     @Length(max = 50)
>     @SystemChar(charsetDef="zenkakuKatakanaCharset")
>     public void setKanaName(String kanaName) {
>         this.kanaName = kanaName;
>     }
> 
>     /**
>      * グループIDを取得する。
>      * @return グループID
>      */
>     public String getUgroupId() {
>         return ugroupId;
>     }
> 
>     /**
>      * グループIDを設定する。
>      * @param ugroupId グループID
>      */
>     @PropertyName("グループID")
>     @Length(min = 10, max = 10)
>     @SystemChar(charsetDef="numericCharset")
>     public void setUgroupId(String ugroupId) {
>         this.ugroupId = ugroupId;
>     }
> 
>     /**
>      * ユーザIDロックを取得する。
>      * @return ユーザIDロック
>      */
>     public String getUserIdLocked() {
>         return userIdLocked;
>     }
> 
>     /**
>      * ユーザIDロックを設定する。
>      * @param userIdLocked ユーザIDロック
>      */
>     @PropertyName("ユーザIDロック")
>     @CodeValue(codeId = "C0000001")
>     public void setUserIdLocked(String userIdLocked) {
>         this.userIdLocked = userIdLocked;
>     }
> 
>     /**
>      * ページ番号を設定する。
>      * @param pageNumber ページ番号
>      */
>     @PropertyName("開始ページ")
>     @Required
>     @NumberRange(max = 10, min = 1)
>     @Digits(integer = 2)
>     public void setPageNumber(Integer pageNumber) {
>         super.setPageNumber(pageNumber);
>     }
> 
>     /**
>      * ソートIDを設定する。
>      * @param sortId ソートID
>      */
>     @PropertyName("ソートID")
>     @Required
>     public void setSortId(String sortId) {
>         super.setSortId(sortId);
>     }
> 
>     /**
>      * システムアカウントテーブルの情報を取得する。
>      *
>      * @return システムアカウントテーブルの情報
>      */
>     public SystemAccountEntity getSystemAccount() {
>         return systemAccount;
>     }
> 
>     /**
>      * システムアカウントテーブルの情報を設定する。
>      *
>      * @param systemAccount システムアカウントテーブルの情報
>      */
>     @ValidationTarget
>     public void setSystemAccount(SystemAccountEntity systemAccount) {
>         this.systemAccount = systemAccount;
>     }
> 
>     /** 精査対象プロパティ */
>     private static final String[] SEARCH_COND_PROPS =
>         new String[] {"loginId", "kanjiName", "kanaName", "ugroupId", "userIdLocked", "pageNumber", "sortId"};
> 
>     /**
>      * 検索条件の精査対象プロパティを返す。
>      * @return 検索条件の精査対象プロパティ
>      */
>     public String[] getSearchConditionProps() {
>         return SEARCH_COND_PROPS;
>     }
> 
>     /**
>      * 検索条件を精査する。
>      * @param context ValidationContext
>      */
>     @ValidateFor("search")
>     public static void validateForSearch(ValidationContext<W11AC01SearchForm> context) {
>         // 単項目精査
>         ValidationUtil.validate(context, SEARCH_COND_PROPS);
>         if (!context.isValid()) {
>             return;
>         }
> 
>         // 項目間精査
>         String loginId = (String) context.getConvertedValue("loginId");        // ログインID
>         String kanjiName = (String) context.getConvertedValue("kanjiName");    // 漢字氏名
>         String kanaName = (String) context.getConvertedValue("kanaName");      // カナ氏名
>         String ugroupId = (String) context.getConvertedValue("ugroupId");      // グループID
>         String userIdLocked = (String) context.getConvertedValue("userIdLocked");   // ユーザIDロック
>         if (!isValidSearchCondition(loginId, kanjiName, kanaName, ugroupId, userIdLocked)) {
>             context.addMessage("MSG00006");
>         }
>     }
> 
>     /** ユーザ選択時の精査対象プロパティ */
>     private static final String[] SELECT_USER_PROPS =
>         new String[] {"systemAccount"};
> 
>     /**
>      * ユーザ選択時のパラメータを精査する。
>      * @param context ValidationContext
>      */
>     @ValidateFor("selectUserInfo")
>     public static void validateForSelectUser(ValidationContext<W11AC01SearchForm> context) {
>         // 単項目精査
>         ValidationUtil.validate(context, SELECT_USER_PROPS);
>     }
> 
>     /**
>      * 検索条件が妥当かどうか確認する。<br/>
>      * 検索条件のうち、少なくとも１つは指定されていることを確認する。
>      *
>      * @param loginId ログインID
>      * @param kanjiName 漢字氏名
>      * @param kanaName カナ氏名
>      * @param ugroupId グループID
>      * @param userIdLocked ユーザIDロック
>      * @return 妥当な場合は真、そうでない場合は偽
>      */
>     private static boolean isValidSearchCondition(String loginId, String kanjiName,
>             String kanaName, String ugroupId, String userIdLocked) {
>         return loginId.length() > 0 || kanjiName.length() > 0 || kanaName.length() > 0
>                 || ugroupId.length() > 0 || userIdLocked.length() > 0;
>     }
> }
> ```

> ( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

#### プロパティの表示名をカスタマイズしたい場合

例えば、"ユーザ名"(バリデーションエラー時などで画面に出力される表示名も"ユーザ名")というプロパティの表示名を"氏名"としたい場合は、Formの対応するプロパティのsetterをオーバーライドし、
@PropertyNameアノテーションを付与すればよい。このとき、バリデーションは元の指定(△△△.javaで指定されているもの)が、そのまま継承される。

下記の例では、Nameプロパティの表示名(元は(UserEntityの@PropertyNameアノテーションの値)は"ユーザ名")を"氏名"に変更している。

```java
public class UserRegisterForm extends UserEntity {
    @PropertyName("氏名")  /* 【説明】
                               setterをオーバーライドし、@PropertyNameアノテーションで変更したい表示名を指定する。
                               バリデーションは元のものがそのまま継承される */
    public void setName(String name) {
        super.setName(name);
    }
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

* 継承元のクラス

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
      public void setId(String id) {
          this.id = id;
      }
  
      @PropertyName("ユーザ名")  // 【説明】元の表示名は"ユーザ名"
      @Required
      @Length(min=6, max=10)
      public void setName(String name) {
          this.name = name;
      }
  
      @PropertyName("備考")
      @Length(max=100)
      public void setRemarks(String remarks) {
          this.remarks = remarks;
      }
  
      // 【説明】getterは省略
  }
  ```

  ( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

> **Note:**
> サンプルアプリケーションでは本機能は用いていない。このため、記載したコード例はサンプルアプリケーションには含まれない。

### Actionの作成

#### バリデーションの実行と画面入力値が設定されたオブジェクトの取得

バリデーションの実行と、画面入力値が設定されたオブジェクトの取得方法は次のとおり。

ValidationUtil#validateAndConvertRequestを使用してバリデーションを実行する。独自に実装したバリデーション用のメソッドを実行するには、引数に「バリデーション対象メソッド」を用意したvalidateAndConvertRequestメソッドを使用する [2] 。この引数の値に `@ValidateFor` アノテーションを付与する際に設定した値とすることで、独自に実装したバリデーション用のメソッドが実行される。

ValidationContext#isValidメソッドにてバリデーションでエラーが発生したか確認し、エラーがあった場合には、エラーメッセージが設定されたアプリケーション例外をthrowする。

ValidationContext#createObjectメソッドを使用して、画面入力値が設定されたオブジェクトを取得する。このとき取得できるクラスはValidationUtil#validateAndConvertRequestの第2引数に設定したクラスとなる。

具体例は [メソッドの実装](../../guide/web-application/web-application-04-validation.md#メソッドの実装) を参照。

ここでは以下のシグネチャのメソッドを使用している。
`validateAndConvertRequest(String prefix, Class<T> targetClass, Validatable<?> request, String validateFor)`

#### 例外発生時の処理

ComponentやActionで例外が発生した場合、デフォルトではHTTPステータス500のレスポンスがブラウザに返される。この応答を変更したい場合は、例外処理が必要なメソッドに、
@OnErrorアノテーションを付与し、例外発生時の処理(例外発生時の遷移先の指定)を行う。

具体例は [メソッドの実装](../../guide/web-application/web-application-04-validation.md#メソッドの実装) を参照。

#### メソッドの実装

[バリデーションの実行と画面入力値が設定されたオブジェクトの取得](../../guide/web-application/web-application-04-validation.md#バリデーションの実行と画面入力値が設定されたオブジェクトの取得) と [例外発生時の処理](../../guide/web-application/web-application-04-validation.md#例外発生時の処理) に従い *W11AC02Actionクラス* を作成し以下のメソッドを追加する。このメソッドでは、次の処理を行っている。

@OnErrorアノテーションを使用して、ApplicationException例外発生時の処理を記述。

バリデーションの実施。

バリデーション結果の確認。エラーが発生している場合は、エラーメッセージが設定されたApplicationExceptionをthrow。

画面入力値が設定されているオブジェクトの取得。

ビジネスロジックの実行

```java
/**
 * ユーザ情報登録画面の「確認」イベントの処理を行う。
 *
 * @param req リクエストコンテキスト
 * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
 * @return HTTPレスポンス
 */
@OnError(                              // 【説明】例外処理用アノテーション
    type = ApplicationException.class, // 【説明】例外処理の対象とする例外クラス

    /* 【説明】
        例外発生時の処理。ここではリクエストID"RW11AC0201"の処理を行うよう(doRW11AC0201メソッドを実行するよう)
        指定している。 */
    path = "forward://RW11AC0201"
)
public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {

    // 精査
    validate(req);

    // ～中略～

}

/**
 * 入力データの精査と生成を行う。<br>
 * <br>
 * 精査エラーの場合はApplicationExceptionを送出する。
 *
 * @param req リクエスト
 * @return 精査済みの入力データから生成したエンティティ
 */
private W11AC02Form validate(HttpRequest req) {

    // 精査
    // 【説明】W11AC02Formの@ValidateForアノテーションで"registerUser"を指定しているメソッドを実行する
    ValidationContext<W11AC02Form> context = ValidationUtil.validateAndConvertRequest(
        "W11AC02", W11AC02Form.class, req, "registerUser");

    // 【説明】バリデーション結果の確認
    if (!context.isValid()) {
        // 【説明】エラーがあった場合
        throw new ApplicationException(context.getMessages()); // 【説明】ApplicationExceptionにエラーメッセージを設定してthrowする
    }

    // 生成
    // 【説明】画面入力値が設定されたオブジェクトの生成
    W11AC02Form form = context.createObject();
    SystemAccountEntity systemAccount = form.getSystemAccount();
    CM311AC1Component function = new CM311AC1Component();

    // ログインIDのチェック
    checkLoginId(systemAccount.getLoginId());

    // グループIDのチェック
    if (!function.existGroupId(form.getUgroupSystemAccount())) {
        throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR,
                "MSG00002", MessageUtil.getStringResource("S0020001")));
    }

    // 認可単位IDのチェック
    if (systemAccount.getPermissionUnit() != null
            && !function.existPermissionUnitId(systemAccount)) {
        throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR,
                "MSG00002", MessageUtil.getStringResource("S0030001")));
    }

    return form;
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

サンプルアプリケーションでは、バリデーションの処理をプライベートメソッドに切り出しているが、必ずプライベートメソッドに切り出す必要は **ない** 。

> **Note:**
> doRW11AC0201メソッドは、ユーザ情報登録画面を表示する処理。

> **Note:**
> @OnErrorのpathの記述方法はHttpResponseの引数と同じである。詳細は [画面初期表示のActionの作成](../../guide/web-application/web-application-02-basic.md#actionの作成) 参照。

### View(JSP)の作成

以下の内容で *W11AC0201.jsp* を作成する。

エラーメッセージを表示する場所に、アプリケーションフレームワーク提供のn:errorsタグとn:errorタグを記述する。
n:errorsタグは複数のエラーメッセージの一覧表示、n:errorタグは各入力項目のエラーメッセージ表示に使用する。
サンプルでは、各入力項目以外のエラーメッセージを画面上部に一覧表示するためにn:errorsタグを使用し、
各入力項目に関するエラーメッセージを入力項目の下に表示するためにn:errorタグを使用する。

* app_error.jsp

```./_source/04/app_error.jsp

```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

* W11AC0201.jsp(一覧表示)

```./_source/04/W11AC0201_errors.jsp

```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

* W11AC0201.jsp(ログインIDの入力項目を抜粋)

```./_source/04/W11AC0201_error.jsp

```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

> **Note:**
> サンプルプログラムでは同じ記述を複数のソースファイルで使用するため、n:errorsタグの記述を外出しにしているが、外出しが必須では **ない** 。

画面の入力項目には、フレームワーク提供のカスタムタグを使用する。
入力項目のカスタムタグは、リクエストパラメータの名前となるname属性を、以下の形式で指定する。

* Formに追加したEntityのプロパティを指定する場合、 **<バリデーションで指定するプレフィックス名>.<FormでのEntityのプロパティ名>.<Entityでのプロパティ名>**
* Formに直接追加したプロパティを指定する場合、 **<バリデーションで指定するプレフィックス名>.<プロパティ名>**

ユーザ情報登録では、Formに対してW11AC02というプレフィックスを使用している。

* W11AC0201.jsp(入力フォーム)

```./_source/04/W11AC0201_form.jsp

```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## 次に読むもの

* [バリデーションとEntityの生成を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/01_Core/08_Validation.html)
* [例外処理を詳しく知りたい時](../../../fw/reference/handler/HttpMethodBinding.html)
* [カスタムタグの使用方法を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07_WebView.html)
