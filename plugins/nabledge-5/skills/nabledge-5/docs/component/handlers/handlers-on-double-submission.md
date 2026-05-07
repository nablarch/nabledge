# OnDoubleSubmissionインターセプタ

**目次**

* インターセプタクラス名
* モジュール一覧
* OnDoubleSubmissionを使用する
* OnDoubleSubmissionのデフォルト値を指定する
* OnDoubleSubmissionの振る舞いを変更する

[二重サブミット(同一リクエストの二重送信)のチェック](../../component/libraries/libraries-tag.md#デフォルトは-true-) を行うインターセプタ。

このインターセプタを使用するためには、
[jspでのformタグによるトークン設定](../../component/libraries/libraries-tag.md#デフォルトは-true-)
または
[UseTokenインターセプタによるトークン設定](../../component/handlers/handlers-use-token.md#usetokenインターセプタ)
が必要である。

## インターセプタクラス名

* nablarch.common.web.token.OnDoubleSubmission

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-tag</artifactId>
</dependency>
```

## OnDoubleSubmissionを使用する

OnDoubleSubmission アノテーションを、
アクションのメソッドに対して設定する。

```java
// 二重サブミットと判定した場合の遷移先をpath属性に指定する。
@OnDoubleSubmission(path = "/WEB-INF/view/error/userError.jsp")
public HttpResponse register(HttpRequest req, ExecutionContext ctx) {
    // 省略。
}
```

## OnDoubleSubmissionのデフォルト値を指定する

アプリケーション全体で使用する
OnDoubleSubmission アノテーションのデフォルト値を設定する場合は、
BasicDoubleSubmissionHandler
をコンポーネント定義に `doubleSubmissionHandler` という名前で追加する。

BasicDoubleSubmissionHandler
では、アノテーションの属性が指定されなかった場合に、自身のプロパティに設定されたリソースパス、メッセージID、ステータスコードを使用する。

設定例

```xml
<component name="doubleSubmissionHandler"
           class="nablarch.common.web.token.BasicDoubleSubmissionHandler">
  <!-- 二重サブミットと判定した場合の遷移先のリソースパス -->
  <property name="path" value="/WEB-INF/view/error/userError.jsp" />
  <!-- 二重サブミットと判定した場合の遷移先画面に表示するエラーメッセージに使用するメッセージID -->
  <property name="messageId" value="DOUBLE_SUBMISSION_ERROR" />
  <!-- 二重サブミットと判定した場合のレスポンスステータス。デフォルトは400 -->
  <property name="statusCode" value="200" />
</component>
```

> **Important:**
> OnDoubleSubmission
> と BasicDoubleSubmissionHandler の
> どちらもpathの指定がない場合は、二重サブミットと判定した場合に遷移先が不明なため、システムエラーとなる。

> このため、 [トークンを使用した二重サブミットの防止](../../component/libraries/libraries-tag.md#デフォルトは-true-)
> を使用するアプリケーションでは、必ずどちらかのpathを指定すること。

## OnDoubleSubmissionの振る舞いを変更する

OnDoubleSubmission アノテーションの振る舞いは、
DoubleSubmissionHandler
インタフェースを実装することで変更できる。実装したクラスをコンポーネント定義に `doubleSubmissionHandler` という名前で追加する。
