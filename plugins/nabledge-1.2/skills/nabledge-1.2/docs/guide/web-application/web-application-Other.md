# その他実装例集

## 本ページの構成

本ページでは以下の使用例を説明する。

* [ログの出力方法](../../guide/web-application/web-application-Other.md#ログの出力方法)
* [設定値の取得方法](../../guide/web-application/web-application-Other.md#設定値の取得方法)
* [メッセージの取得方法](../../guide/web-application/web-application-Other.md#メッセージの取得方法)
* [エラーメッセージの通知方法](../../guide/web-application/web-application-Other.md#エラーメッセージの通知方法)
* [データベースアクセスを伴う精査を行う方法](../../guide/web-application/web-application-Other.md#データベースアクセスを伴う精査を行う方法)
* [エラーメッセージを任意の個所に表示する方法](../../guide/web-application/web-application-Other.md#エラーメッセージを任意の個所に表示する方法)
* [コード名称と値の取得方法](../../guide/web-application/web-application-Other.md#コード名称と値の取得方法)
* [コード値のバリデーション方法](../../guide/web-application/web-application-Other.md#コード値のバリデーション方法)
* [正常な画面遷移においてメッセージを表示する方法](../../guide/web-application/web-application-Other.md#正常な画面遷移においてメッセージを表示する方法)

## ログの出力方法

開発時にデバッグ目的で出力するログの出力方法を示す。
ログ出力の設定方法については、 [ログ出力の設定方法とログの見方(画面オンライン処理編)](../../guide/web-application/web-application-Web-Log.md#ログ出力の設定方法とログの見方画面オンライン処理編) を参照。

* 実装例

  ```java
  /* 【説明】
      ログ出力を行うためのロガーの取得方法。
  
      クラス変数にロガーを設定する。
      LoggerManagerのgetメソッドを使用してLoggerを取得する。
      getメソッドの引数には自身のクラスを指定する。 */
  
  /* 【説明】CM311AC1ComponentクラスのJavaDocは省略。 */
  public class CM311AC1Component {
  
      /** ロガー */
      private static final Logger LOGGER = LoggerManager.get(CM311AC1Component.class);
  }
  ```

  ```java
  /* 【説明】
      ログの出力方法。
  
      LoggerのlogDebugメソッドを使用してログを出力する。
      メッセージの組み立て処理が必要な場合は事前に出力有無をチェックする。
      ログの出力を行わない場合に不必要なログ組み立て処理が実行されることによる
      性能劣化を防ぐためである。*/
  if (LOGGER.isDebugEnabled()) {
      String message = String.format("user was not found. userId = [%s], name = [%s]",
                                     user.getUserId(), user.getName());
      LOGGER.logDebug(message);
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## 設定値の取得方法

リポジトリ機能を用いた設定値の取得方法を示す。

環境設定ファイルは下記のとおり配置されているものとして実装例を示す。
実際の開発ではプロジェクトで規定された環境設定ファイルに設定値を指定すること。

* 環境設定ファイルの配置例

  ```bash
  # 【説明】
  #  コンポーネント設定ファイルはフレームワークにより読み込まれる。
  #  ここでは画面オンライン用のコンポーネント設定ファイルを想定している。
  resources
    +-application
    |   +-system.config(環境設定ファイル)
    |
    +-web-component-configuration.xml(コンポーネント設定ファイル)
  ```
* コンポーネント設定ファイル(web-component-configuration.xml)の設定例

  ```xml
  <!-- 【説明】
        リポジトリに環境設定ファイルを読み込ませるために
        コンポーネント設定ファイルにconfig-fileタグを定義する。 -->
  <!-- 設定値項目 -->
  <config-file file="application/system.config" />
  ```
* 環境設定ファイル(system.config)の設定例

  ```bash
  #エラーメッセージID
  notPermissionMessage=MSG00001
  
  #登録可能フラグ
  registerUserPermission=false
  
  #ユーザの有効期限を現在日付から何ヶ月後にするか
  userEffectiveDateTo=12
  ```

  > **Note:**
> 環境設定ファイルの記述ルールの詳細については、 [環境設定ファイルの記述ルール](../../../../fw/reference/02_FunctionDemandSpecifications/01_Core/02/02_01_Repository_config.html#repository-config-loader-setting) を参照。
* 実装例

  ```java
  /* 【説明】
      文字列の取得方法。
      SystemRepositoryのgetStringメソッドを使用する。 */
  String messageId = SystemRepository.getString("notPermissionMessage");
  
  /* 【説明】
      真偽値の取得方法。
      SystemRepositoryのgetBooleanメソッドを使用する。 */
  boolean registerFlg = SystemRepository.getBoolean("registerUserPermission");
  
  /* 【説明】
      文字列または真偽値以外の取得方法。
      SystemRepositoryのgetStringメソッドで取得後に変換処理を行う。 */
  int effectiveDateTo = Integer.parseInt(
                            SystemRepository.getString("userEffectiveDateTo"));
  ```

> **Warning:**
> 環境設定値を取得する際に指定するキー値には、ユーザ入力値やデータベースから取得した値を使用しないこと。
> この様なキー値を使用した場合、環境設定値が取得できないことにより、障害が発生する可能性が高くなる。
> また、設定値が取得せずに障害が発生した場合も、キー値が可変であることが原因で障害解析が非常に困難となる。

> キー値を常に固定値としていた場合、仮に設定値が取得出来なかった場合でも障害発生箇所を元に、
> キー値を割り出すことが容易であるため、上記のような問題は発生しない。

> 以下に良くない例を示す。

> ```java
> /* 【説明】
>     Entityから取得した値をキー値の一部として使用しているため、良くない実装 */
> String message = SystemRepository.getString("user" + userEntity.getUserId() + ".message");
> 
> /* 【説明】
>     データベースから取得した値をキー値の一部として使用しているため、良くない実装 */
> String message = SystemRepository.getString("user" + row.getString("userId") + ".message");
> ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## メッセージの取得方法

メッセージ管理機能を用いたメッセージの取得方法を示す。

メッセージテーブルは下記のとおりデータが設定されているものとして実装例を示す。

* メッセージテーブルのデータ例

  | メッセージID | 言語 | メッセージ |
  |---|---|---|
  | MSG0001 | en | User id is already registered. |
  | MSG0001 | ja | そのユーザIDは既に登録されています。 |
  | MSG0002 | en | value of {0} is not valid. |
  | MSG0002 | ja | {0}の値が不正です。 |
  | PRP0002 | en | name |
  | PRP0002 | ja | 名前 |
* 実装例

  ```java
  /* 【説明】
      メッセージの取得方法。
  
      MessageUtilのcreateMessageメソッドを使用する。
      messageStr変数はThreadContextに保持した言語に合わせたメッセージとなる。
  
      ThreadContextに保持した言語 -> messageStr変数に設定されるメッセージ
      en -> "User id is already registered."
      ja -> "そのユーザIDは既に登録されています。" */
  Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");
  String messageStr = message.formatMessage();
  ```

  ```java
  /* 【説明】
      メッセージのフォーマット方法。
  
      MessageUtilのcreateMessageメソッドにオプション引数を指定する。
      国際化を行う場合はオプション引数にStringResourceまたはMessageを指定する。
      国際化を行わない場合はオプション引数に直接文字列を指定してもよい。
  
      ThreadContextに保持した言語 -> messageStr変数に設定されるメッセージ
      en -> "value of name is not valid."
      ja -> "名前の値が不正です。" */
  StringResource nameResource = MessageUtil.getStringResource("PRP0002");
  Message message = MessageUtil.createMessage(
                        MessageLevel.ERROR, "MSG0002", nameResource);
  String messageStr = message.formatMessage();
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## エラーメッセージの通知方法

業務的なエラーが発生した際は、エラー内容を使用者に伝えるためにメッセージの出力が必要になる。
ApplicationExceptionクラス(またはApplicationExceptionクラスのサブクラス)を使用することで、
フレームワークが提供する例外処理機構を使用してエラー内容を使用者に伝えることができる。

* 実装例

  ```java
  /* 【説明】
      メッセージの通知方法。
      メッセージを指定したApplicationExceptionを送出する。 */
  Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");
  throw new ApplicationException(message);
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## データベースアクセスを伴う精査を行う方法

アプリケーションにおいて、データベースアクセスを伴う精査は
単体項目、複合項目を問わず Entity ではなく Action に実装する。

精査エラーは、 [エラーメッセージの通知方法](../../guide/web-application/web-application-Other.md#エラーメッセージの通知方法) に示した ApplicationException
クラスを使用する方法で使用者にメッセージを通知する。

以下にユーザ登録時に行うログインIDの重複チェックを行う実装例を示す。

* 実装例

  ```java
  /* 【説明】
      データベースアクセスを伴う精査の実装例。
      Entityではなく Action (業務共通コンポーネントを含む) に精査の実装を行う。 */
  // form 生成
  W11AC02Form form = context.createObject();
  
  // form から entity 取得
  SystemAccountEntity systemAccount = form.getSystemAccount();
  
  // entityからログインIDの取得
  String loginId = systemAccount.getLoginId();
  
  // ログインIDが登録済みか、DBを検索する
  SqlPStatement statement = getSqlPStatement("SELECT_SYSTEM_ACCOUNT");
  statement.setString(1, loginId);
  if (!statement.retrieve().isEmpty()) {
      // ログインIDが登録済みの場合、 ApplicationException を送出
      throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00001"));
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## エラーメッセージを任意の個所に表示する方法

[データベースアクセスを伴う精査を行う方法](../../guide/web-application/web-application-Other.md#データベースアクセスを伴う精査を行う方法) で示した例のような、データベースアクセスを伴う精査など、
Action 内で実装した精査でも、通常のバリデーション結果同様にエラーを発生させた入力値と同じ場所に表示させたいことがある。

このような場合、 MessageUtil.createMessage メソッドではなく、
ValidationUtil.createMessageForProperty メソッドを使用してエラーメッセージを作成することで、
エラーメッセージを任意の箇所に出力できる。

以下に [データベースアクセスを伴う精査を行う方法](../../guide/web-application/web-application-Other.md#データベースアクセスを伴う精査を行う方法) と同じログインIDの重複チェックを行う実装例でエラーメッセージをログインIDの近くに表示する方法を示す。

* 実装例

  ```java
  /* 【説明】
      プロパティに紐付くエラーメッセージを設定する例。
      */
  
  // form 生成
  W11AC02Form form = context.createObject();
  
  // form から entity 取得
  SystemAccountEntity systemAccount = form.getSystemAccount();
  
  // entityからログインIDの取得
  String loginId = systemAccount.getLoginId();
  
  // ログインIDが登録済みか、DBの状態をチェック
  SqlPStatement statement = getSqlPStatement("SELECT_SYSTEM_ACCOUNT");
  statement.setString(1, loginId);
  if (!statement.retrieve().isEmpty()) {
      // ログインIDが登録済みの場合、 ApplicationException を送出
      // ValidationUtil.createMessageForProperty メソッドでメッセージを作成する。
      // 第1引数には n:error タグの name 属性で指定した名称を渡す。
      throw new ApplicationException(ValidationUtil.createMessageForProperty(
              "W11AC02.systemAccount.loginId", "MSG00001"));
  }
  ```

  ```jsp
  <%--
    【説明】
    エラーメッセージを表示させるJSPの例。
  --%>
  <th>
      ログインID <n:forInputPage><span class="essential">*</span></n:forInputPage>
  </th>
  <td>
      <n:text name="W11AC02.systemAccount.loginId"
              size="50" maxlength="20"/>
      <n:forInputPage>
          (半角英数記号20文字以内)
      </n:forInputPage>
      <%--
        【説明】
        エラーメッセージを表示させる個所の書き方は、通常のバリデーション結果のエラー表示と同様。
      --%>
      <n:error name="W11AC02.systemAccount.loginId"/>
  </td>
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## コード名称と値の取得方法

コード管理機能を用いたコード名称と値の取得方法を示す。

コードパターンテーブルとコード名称テーブルは、下記のとおりデータ設定されているものとして実装例を示す。

* コードパターンテーブルのデータ例

  | ID | VALUE | PATTERN1 | PATTERN2 | PATTERN3 |
  |---|---|---|---|---|
  | 0001 | 1 | 1 | 0 | 0 |
  | 0001 | 2 | 1 | 0 | 0 |
  | 0001 | 9 | 0 | 0 | 0 |
* コード名称テーブルのデータ例

  | ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | NAME_WITH_VALUE |
  |---|---|---|---|---|---|---|
  | 0001 | 1 | 1 | ja | 男性 | 男 | 1:男性 |
  | 0001 | 2 | 2 | ja | 女性 | 女 | 2:女性 |
  | 0001 | 9 | 3 | ja | 不明 | 不 | 9:不明 |
  | 0001 | 1 | 2 | en | Male | M | 1:Male |
  | 0001 | 2 | 1 | en | Female | F | 2:Female |
  | 0001 | 9 | 3 | en | Unknown | U | 9:Unknown |
* 実装例

  ```java
  /* 【説明】
      コード名称の取得方法。
  
      CodeUtilのgetNameメソッドを使用する。
      name変数はThreadContextに保持した言語に合わせた名称となる。
  
      ThreadContextに保持した言語 -> name変数に設定される名称
      en -> "Male"
      ja -> "男性" */
  String name = CodeUtil.getName("0001", "1");
  ```

  ```java
  /* 【説明】
      コード略称の取得方法。
  
      CodeUtilのgetShortNameメソッドを使用する。
      name変数はThreadContextに保持した言語に合わせた略称となる。
  
      ThreadContextに保持した言語 -> name変数に設定される略称
      en -> "男"
      ja -> "M" */
  String name = CodeUtil.getShortName("0001", "1");
  ```

  ```java
  /* 【説明】
      オプション名称の取得方法。
  
      コード名称テーブルのNAME_WITH_VALUEカラムは、
      任意のカラム名を指定したオプション名称用のカラムである。
  
      CodeUtilのgetOptionalNameメソッドを使用し、オプション名称用カラムの名前を指定する。
      name変数はThreadContextに保持した言語に合わせたオプション名称となる。
  
      ThreadContextに保持した言語 -> name変数に設定されるオプション名称
      en -> "1:Male"
      ja -> "1:男性" */
  String name = CodeUtil.getOptionalName("0001", "1", "NAME_WITH_VALUE");
  ```

  ```java
  /* 【説明】
      コード値の取得方法。
  
      CodeUtilのgetValuesメソッドを使用する。
      value変数はThreadContextに保持した言語に合わせた値となる。
  
      ThreadContextに保持した言語 -> values変数に設定される値
      en -> {"2", "1", "9"}
      ja -> {"1", "2", "9" }
      コードパターンテーブルのSORT_ORDERカラムの昇順にソートされた順序で
      コード値が取得される。
      */
  List<String> values = CodeUtil.getValues("0001");
  ```

  ```java
  /* 【説明】
      パターンごとのコード値の取得方法。
  
      コードパターンテーブルのPATTERN1からPATTERN3カラムは、
      任意のカラム名を指定したパターン用のカラムである。
      各カラムが表すパターンに含める行には"1"を指定する。
  
      CodeUtilのgetValuesメソッドを使用し、パターン用カラムの名前を指定する。
      value変数はThreadContextに保持した言語に合わせた値となる。
  
      ThreadContextに保持した言語 -> values変数に設定される値
      en -> {"2" , "1"}
      ja -> {"1" , "2"}
      コードパターンテーブルのSORT_ORDERカラムの昇順にソートされた順序で
      コード値が取得される。
      */
  List<String> values = CodeUtil.getValues("0001", "PATTERN1");
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## コード値のバリデーション方法

コード値のバリデーション方法を示す。
ここでは、 [コード名称と値の取得方法](../../guide/web-application/web-application-Other.md#コード名称と値の取得方法) に示したコード管理用のデータがデータベースに設定されているものとする。

* 実装例

  ```java
  /* 【説明】CustomerEntityクラスのJavaDocは省略。 */
  public class CustomerEntity {
  
      /* 【説明】その他のプロパティおよびメソッドは省略。 */
  
      /** 性別 */
      private String gender;
  
      /* 【説明】
          コード値のバリデーションはCodeValueバリデータを使用する。
          genderプロパティに対する値が"1"、"2"以外の場合は、
          バリデーション結果がエラーとなる。
          pattern属性には、使用するパターンのカラム名を指定する。*/
      @PropertyName("性別")
      @CodeValue(codeId="0001", pattern="PATTERN1")
      public String setGender(String gender) {
          this.gender = gender;
      }
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## 正常な画面遷移においてメッセージを表示する方法

ここでは正常な画面遷移においてメッセージを表示する方法を示す。

精査エラーの場合と異なり、何らかの業務仕様上のチェックを行い、チェック結果によって警告メッセージを次画面に表示したい場合がある。
このように正常な画面遷移においてメッセージを表示したい場合は、ActionでWebUtilのnotifyMessagesメソッドを使用してメッセージを設定し、
n:errorsタグを使用して画面表示を行う。
ユーザ情報更新確認画面に警告メッセージ(MSG00022)を表示する実装例を示す。

* 実装例

  ```java
  /* 【説明】Actionのメソッド実装例。
             JavaDocは省略。*/
  public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
  
      /* 【説明】入力精査および業務処理は省略。 */
  
      /* 【説明】
          Actionでメッセージを設定する。
          WebUtilのnotifyMessagesメソッドを使用してメッセージを設定する。
          指定したメッセージは n:errors タグを使用して出力する。 */
      Message message = MessageUtil.createMessage(MessageLevel.WARN, "MSG00022");
      WebUtil.notifyMessages(ctx, message);
  
      return new HttpResponse("/ss11AC/W11AC0302.jsp");
  }
  ```

  ```jsp
  <%-- 【説明】JSPの実装例。
        WebUtilのnotifyMessagesメソッドで設定したメッセージを出力する。 --%>
  <n:errors />
  ```

  ```css
  /* 【説明】CSSの実装例。
      CSS定義により警告メッセージを装飾する。
      n:errors タグはメッセージレベル(MessageLevel)に応じたCSSクラス名が出力される。
      デフォルトでは下記の対応でクラス名が出力される。
  
          情報レベル(MessageLevel.INFO): "nablarch_info"
          警告レベル(MessageLevel.WARN): "nablarch_warn"
          エラーレベル(MessageLevel.ERROR): "nablarch_error"
  */
  li.nablarch_warn {
      color: #0000FF;
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)
