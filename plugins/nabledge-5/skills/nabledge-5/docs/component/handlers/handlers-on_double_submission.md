# OnDoubleSubmissionインターセプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web_interceptor/on_double_submission.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/OnDoubleSubmission.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/BasicDoubleSubmissionHandler.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/DoubleSubmissionHandler.html)

## インターセプタクラス名

**クラス**: `nablarch.common.web.token.OnDoubleSubmission`

:ref:`tag-double_submission_server_side` (二重サブミットチェック) を行うインターセプタ。使用するには、:ref:`tag-double_submission_token_setting` (JSPのformタグによるトークン設定) または [use_token_interceptor](handlers-use_token.md) (UseTokenインターセプタによるトークン設定) が必要。

<details>
<summary>keywords</summary>

OnDoubleSubmission, nablarch.common.web.token.OnDoubleSubmission, 二重サブミットチェック, インターセプタ, トークン設定が必要

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-tag</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web-tag, com.nablarch.framework, モジュール依存関係

</details>

## OnDoubleSubmissionを使用する

**アノテーション**: `@OnDoubleSubmission`

アクションのメソッドに `@OnDoubleSubmission` アノテーションを設定する。`path` 属性に二重サブミット判定時の遷移先を指定する。

```java
@OnDoubleSubmission(path = "/WEB-INF/view/error/userError.jsp")
public HttpResponse register(HttpRequest req, ExecutionContext ctx) {
    // 省略。
}
```

<details>
<summary>keywords</summary>

@OnDoubleSubmission, OnDoubleSubmission, 二重サブミット防止, アノテーション設定, path属性

</details>

## OnDoubleSubmissionのデフォルト値を指定する

アプリケーション全体のデフォルト値を設定する場合は、`BasicDoubleSubmissionHandler` をコンポーネント定義に `doubleSubmissionHandler` という名前で追加する。アノテーション属性が未指定の場合、コンポーネントのプロパティ値（リソースパス、メッセージID、ステータスコード）が使用される。

```xml
<component name="doubleSubmissionHandler"
           class="nablarch.common.web.token.BasicDoubleSubmissionHandler">
  <property name="path" value="/WEB-INF/view/error/userError.jsp" />
  <property name="messageId" value="DOUBLE_SUBMISSION_ERROR" />
  <property name="statusCode" value="200" />
</component>
```

| プロパティ名 | 説明 |
|---|---|
| path | 二重サブミット判定時の遷移先リソースパス |
| messageId | エラーメッセージに使用するメッセージID |
| statusCode | レスポンスステータス（デフォルト: 400） |

> **重要**: `OnDoubleSubmission` と `BasicDoubleSubmissionHandler` のどちらも `path` が未指定の場合、二重サブミット判定時に遷移先が不明となりシステムエラーになる。:ref:`tag-double_submission_server_side` を使用するアプリケーションでは必ずどちらかの `path` を指定すること。

<details>
<summary>keywords</summary>

BasicDoubleSubmissionHandler, nablarch.common.web.token.BasicDoubleSubmissionHandler, doubleSubmissionHandler, path, messageId, statusCode, デフォルト値設定, コンポーネント定義

</details>

## OnDoubleSubmissionの振る舞いを変更する

`@OnDoubleSubmission` の振る舞いを変更するには、`DoubleSubmissionHandler` インタフェースを実装し、コンポーネント定義に `doubleSubmissionHandler` という名前で追加する。

<details>
<summary>keywords</summary>

DoubleSubmissionHandler, nablarch.common.web.token.DoubleSubmissionHandler, 振る舞い変更, インタフェース実装, doubleSubmissionHandler

</details>
