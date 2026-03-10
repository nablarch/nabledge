# OnDoubleSubmissionインターセプタ

## インターセプタクラス名

**クラス**: `nablarch.common.web.token.OnDoubleSubmission`

このインターセプタを使用するには、:ref:`tag-double_submission_token_setting` または :ref:`use_token_interceptor` によるトークン設定が必要。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-tag</artifactId>
</dependency>
```

## OnDoubleSubmissionを使用する

アクションのメソッドに `OnDoubleSubmission` アノテーションを設定する。`path`属性に二重サブミット判定時の遷移先を指定する。

```java
@OnDoubleSubmission(path = "/WEB-INF/view/error/userError.jsp")
public HttpResponse register(HttpRequest req, ExecutionContext ctx) {
    // 省略。
}
```

## OnDoubleSubmissionのデフォルト値を指定する

アプリケーション全体の `OnDoubleSubmission` のデフォルト値を設定するには、`BasicDoubleSubmissionHandler` を `doubleSubmissionHandler` という名前でコンポーネント定義に追加する。アノテーションの属性が未指定の場合、このクラスのプロパティ（リソースパス、メッセージID、ステータスコード）が使用される。

- `path`: 二重サブミット判定時の遷移先リソースパス
- `messageId`: エラーメッセージのメッセージID
- `statusCode`: レスポンスステータスコード（デフォルトは400）

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

> **重要**: `OnDoubleSubmission` と `BasicDoubleSubmissionHandler` の両方で`path`が未指定の場合、二重サブミット判定時に遷移先が不明となりシステムエラーとなる。:ref:`tag-double_submission_server_side` を使用するアプリケーションでは、必ずどちらかに`path`を指定すること。

## OnDoubleSubmissionの振る舞いを変更する

`DoubleSubmissionHandler` インタフェースを実装し、`doubleSubmissionHandler` という名前でコンポーネント定義に追加することで、`OnDoubleSubmission` の振る舞いを変更できる。
