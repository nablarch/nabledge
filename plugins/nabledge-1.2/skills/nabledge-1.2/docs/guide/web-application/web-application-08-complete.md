# 完了画面の実装

更新完了画面は、以下のステップで実装する。

[1) 更新完了画面の表示](../../guide/web-application/web-application-08-complete.md#update-complete)

[1)-1 Actionクラスの実装](../../guide/web-application/web-application-08-complete.md#update-complete-action)

[1)-2 JSPの実装](../../guide/web-application/web-application-08-complete.md#update-complete-jsp)

[2) DB更新処理実装](../../guide/web-application/web-application-08-complete.md#update-db)

[2)-1 Componentクラスの実装](../../guide/web-application/web-application-08-complete.md#update-db-service)

[2)-2 Actionクラスの実装](../../guide/web-application/web-application-08-complete.md#update-db-action)

**1) 更新完了画面の表示**

1)-1 Actionクラスの実装

a) リクエスト単体テストコードの追加

更新画面初期表示の実装-1) 更新画面の表示- [1)-1 Actionクラスの作成](../../guide/web-application/web-application-06-initial-view.md#update-view-action) で作成した以下のテストクラスに対して完了画面表示リクエストのテスト実行メソッドを追加する。

**テストクラス名**

W11ACXXActionRequestTest

**メソッド名**

void testRW11ACXX04()

```java
// ～前略～

@Test
public void testRW11ACXX04() {
    execute("testRW11ACXX04");
}

// ～後略～
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

b) リクエスト単体テストデータシートの作成

更新画面初期表示の実装-1) 更新画面の表示- [1)-1 Actionクラスの作成](../../guide/web-application/web-application-06-initial-view.md#update-view-action) で作成したリクエスト単体テストデータシート(Excelファイル)に完了画面表示リクエスト用のシートを追加する。

**ブック名**

W11ACXXActionRequestTest.xls

**シート名**

testRW11ACXX04

![action_test_complete.png](../../../knowledge/assets/web-application-08-complete/action_test_complete.png)

c) リクエスト単体テスト実施

リクエスト単体テストを実施し、テストが失敗することを確認する。（Actionクラスにメソッドを追加していない為）

d) Actionクラスの修正

更新画面初期表示の実装-1) 更新画面の表示- [1)-1 Actionクラスの作成](../../guide/web-application/web-application-06-initial-view.md#update-view-action) で作成したActionクラスに完了画面表示のメソッドを追加する。

**Actionクラス名**

W11ACXXAction

**メソッド名**

"do" ＋ RW11ACXX04（完了画面表示のリクエストID）

```java
// ～前略～

/**
 * ユーザ情報更新完了画面の表示
 *
 * @param req リクエストコンテキスト
 * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
 * @return HTTPレスポンス
 */
public HttpResponse doRW11ACXX04(HttpRequest req, ExecutionContext ctx) {

    // 【説明】最初は単純にJSPを返却する処理のみ実装
    // ユーザ情報更新完了画面へ遷移
    return new HttpResponse("/ss11AC/W11ACXX03.jsp");
}

// ～後略～
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

e) リクエスト単体テスト実施

リクエスト単体テストを実施し、Actionクラスまで処理が到達していることを確認する。

コンソールログに以下の内容が出力されれば良い。

* Actionクラスまで処理到達

ログ中の「@@@@ DISPATCHING CLASS @@@@」の次に「BEFORE ACTION」が出力されていれば、Actionまで処理が到達している。

＜出力内容＞

```none
2011-09-29 10:14:50.755 -INFO- root [201109291014507230001] boot_proc = [] proc_sys = [] req_id = [RW11ACXX04] usr_id = [0000000001] @@@@ DISPATCHING CLASS @@@@ class = [nablarch.sample.ss11AC.W11ACXXAction]
2011-09-29 10:14:50.755 -DEBUG- root [201109291014507230001] boot_proc = [] proc_sys = [] req_id = [RW11ACXX04] usr_id = [0000000001] **** BEFORE ACTION ****
  request_parameter = [{
      W11ACXX.users.kanjiName = [奈武羅三郎],
      W11ACXX.users.userId = [0000000002],
      W11ACXX.users.kanaName = [ナブラサブロウ]}]
  request_scope = [{
      org.mortbay.jetty.newSessionId = [1euandylq3rih1lrp5iycoehci]}]
  session_scope = [{
      user.id = [0000000001],
      commonHeaderLoginDate = [20100914],
      commonHeaderLoginUserName = [リクエスト単体テストユーザ]}]
2011-09-29 10:14:50.755 -DEBUG- root [201109291014507230001] boot_proc = [] proc_sys = [] req_id = [RW11ACXX04] usr_id = [0000000001] **** DISPATCHING METHOD **** method = [nablarch.sample.ss11AC.W11ACXXAction#dorw11acxx04]
```

* JSPファイルNOT FOUND

＜出力内容＞

```none
ERROR: PWC6117: File "C:\tisdev\workspace\Nablarch_sample\main\web\ss11AC\W11ACXX03.jsp" not found
```

1)-2 JSPの実装

a) JSPの作成

JSPの自動生成、JSPの修正については、更新画面初期表示の実装時と同じ手順のため、 [1)-2 JSPの実装](../../guide/web-application/web-application-06-initial-view.md#update-view-jsp) を参照して行う。

**更新完了画面のHTML**

 [ユーザ情報更新完了画面.html](../../../knowledge/assets/web-application-08-complete/ユーザ情報更新完了画面.html)

**更新完了画面のJSP**

W11ACXX03.jsp

＜修正後JSP＞

```./_download/W11ACXX03.jsp

```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

b) 更新完了画面の表示確認

リクエスト単体テストを実行し、更新完了画面が出力されることを確認する。

ただし、この時点では更新処理を実装していない為、DBの更新は行われていない。

c) JSP静的チェックツールの実行

[JSP静的解析ツール](../../development-tools/java-static-analysis/java-static-analysis-01-JspStaticAnalysis.md#jsp-static-analysis-tool) を実行し、該当ファイルに静的チェックエラーがないことを確認する。

**2) DB更新処理実装**

2)-1 Componentクラスの実装

a) リクエスト単体テストデータシートの作成

1. 更新完了画面の表示 [1)-1 Actionクラスの実装](../../guide/web-application/web-application-08-complete.md#update-complete-action) で作成した以下のテストデータシートに対して、更新結果のデータを追加する。

**ブック名**

W11ACXXActionRequestTest.xls

**シート名**

testRW11ACXX04

![action_test_complete_update.png](../../../knowledge/assets/web-application-08-complete/action_test_complete_update.png)

※追加部分は画像の赤枠部分。

> **Note:**
> 更新結果の期待値では、漢字氏名、カナ氏名以外にも、更新ユーザID(UPDATE_USER_ID)と更新日付(UPDATE_DATE)も
> 更新対象としている。

> **更新ユーザID**

> 事前準備データのUSER_ID欄に記載したユーザIDで更新される。

> **更新日付**

> コンポーネント設定ファイルに記載された固定の業務日付で更新される（実行タイミングによって日付が変わると検証ができない為、固定値を使用）。

b) リクエスト単体テスト実施

リクエスト単体テストを実施し、テストが失敗することを確認する。（Componentクラスに更新処理を実装していない為）

c) 更新処理の実装

更新確認画面に表示した内容のUsersテーブルに対する更新処理をComponentクラスに実装する。

実装のポイントは以下の通り。

①ユーザテーブル更新用のSQL文の追加

更新画面初期表示の実装-2)更新画面表示内容の検索処理実装 [2)-1 Componentクラスの実装](../../guide/web-application/web-application-06-initial-view.md#update-select-component) で作成したSQLファイルに更新SQL文を追加する。

**SQLファイル名**

CM311ACXComponent.sql

＜更新SQL文＞

```sql
-- ユーザテーブル更新SQL
UPDATE_USERS=
UPDATE USERS SET
     KANJI_NAME = :kanjiName,
     KANA_NAME = :kanaName,
     UPDATED_USER_ID = :updatedUserId,
     UPDATED_DATE = :updatedDate
WHERE
     USER_ID = :userId
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

②更新画面初期表示の実装-2)更新画面表示内容の検索処理実装 [2)-1 Componentクラスの実装](../../guide/web-application/web-application-06-initial-view.md#update-select-component)
で作成したクラスに更新処理実行メソッドを実装する。また、必要なimport文を追加する。

追加するメソッド名は以下の通り。

**メソッド名**

void updateUsers(UsersEntity usersEntity)

```java
// ～前略～

// 【説明】②ユーザテーブルの更新処理メソッド
/**
 * ユーザテーブルに対して更新を行う。<br/>
 *
 * @param users 更新する情報を保持した{@link UsersEntity}
 */
public void updateUsers(UsersEntity users) {
    ParameterizedSqlPStatement updateUsers =
        super.getParameterizedSqlStatement("UPDATE_USERS");
    updateUsers.executeUpdateByObject(users);
}

// ～後略～
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

2)-2 Actionクラスの実装

a) 更新処理の呼び出し実装

Actionクラスに2)-1で実装した更新処理の呼び出しを実装する。

更新画面初期表示の実装-1) 更新画面の表示- [1)-1 Actionクラスの作成](../../guide/web-application/web-application-06-initial-view.md#update-view-action) で作成したActionクラスのメソッドに以下の処理を追加する。また、必要なimport文を追加する。

**Actionクラス名**

W11ACXXAction

**メソッド名**

"do" ＋ RW11ACXX04（完了画面表示のリクエストID）

①前画面より渡されるパラメータ(ユーザID、漢字氏名、カナ氏名）の単項目精査

②①のパラメータを保持するFormの生成

③更新処理の呼び出し

```java
// ～前略～

/**
 * ユーザ情報更新完了画面の表示
 *
 * @param req リクエストコンテキスト
 * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
 * @return HTTPレスポンス
 */
@OnError(type = ApplicationException.class, path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102")
@OnDoubleSubmission(path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102")
public HttpResponse doRW11ACXX04(HttpRequest req, ExecutionContext ctx) {

    // 【説明】①精査処理の呼び出し実装
    ValidationContext<W11ACXXForm> formCtx =
        ValidationUtil.validateAndConvertRequest("W11ACXX",
                W11ACXXForm.class, req, "simpleUpdate");
    if (!formCtx.isValid()) {
        throw new ApplicationException(formCtx.getMessages());
    }

    // 【説明】②更新パラメータを持つFormを生成
    W11ACXXForm form = formCtx.createObject();

    // 【説明】③更新実行
    CM311ACXComponent component = new CM311ACXComponent();
    component.updateUsers(form.getUsers());

    return new HttpResponse("/ss11AC/W11ACXX03.jsp");
}

// ～後略～
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> @OnDoubleSubmissionを指定することで、
>  [二重サブミット](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_SubmitTag.html#prevent-double-submission)  を防ぐことができる。

b) リクエスト単体テスト実施

リクエスト単体テストを実行し、更新結果のアサートが成功することを確認する。
