# CSRFトークン検証ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/CsrfTokenVerificationHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/csrf/CsrfTokenUtil.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/CsrfTokenGenerator.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/UUIDv4CsrfTokenGenerator.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/VerificationTargetMatcher.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/HttpMethodVerificationTargetMatcher.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/VerificationFailureHandler.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/BadRequestVerificationFailureHandler.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/NopHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.CsrfTokenVerificationHandler`

<details>
<summary>keywords</summary>

CsrfTokenVerificationHandler, nablarch.fw.web.handler.CsrfTokenVerificationHandler, CSRFトークン検証ハンドラ, ハンドラクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, com.nablarch.framework, モジュール, Maven依存関係

</details>

## 制約

**必須要件**: 本ハンドラはCSRFトークンをセッションストアに格納するため、本ハンドラを使用する場合は :ref:`session_store` の使用が必須となる。

- [session_store_handler](handlers-SessionStoreHandler.md) より後ろに配置すること（CSRFトークンをセッションストアに格納するため）
- :ref:`tag` を使用する場合は [nablarch_tag_handler](handlers-nablarch_tag_handler.md) より後ろに配置すること（:ref:`tag-hidden_encryption` を使用してCSRFトークンを出力するため）

> **補足**: [multipart_handler](handlers-multipart_handler.md) を使ったファイルアップロード時にファイルの保存前にCSRFトークンの検証を行いたい場合は、[multipart_handler](handlers-multipart_handler.md) の前に本ハンドラおよび [session_store_handler](handlers-SessionStoreHandler.md) を配置すること。

<details>
<summary>keywords</summary>

session_store_handler, nablarch_tag_handler, multipart_handler, tag-hidden_encryption, session_store, セッションストア必須, ハンドラ配置順, CSRFトークン制約

</details>

## CSRFトークンの生成と検証

**デフォルト動作**:

- セッションストア格納名: `nablarch_csrf-token`
- トークン生成: `UUIDv4CsrfTokenGenerator` (UUID v4使用)
- 格納先: デフォルトのセッションストア（ストア名を指定しない）
- 検証対象判定: `HttpMethodVerificationTargetMatcher` — `GET`/`HEAD`/`TRACE`/`OPTIONS` は検証対象外、`POST`/`PUT` 等は検証対象
- CSRFトークンのリクエスト取得名: HTTPヘッダ `X-CSRF-TOKEN`、HTTPパラメータ `csrf-token`
- 検証失敗時: `BadRequestVerificationFailureHandler` でBadRequest(400)を返す

**設定例** (:ref:`tag` 使用時):

```xml
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component-ref name="sessionStoreHandler" />
      <component-ref name="nablarchTagHandler"/>
      <component-ref name="csrfTokenVerificationHandler"/>
    </list>
  </property>
</component>

<component name="csrfTokenVerificationHandler"
           class="nablarch.fw.web.handler.CsrfTokenVerificationHandler" />
```

**RESTfulウェブサービスでのCSRF対策**: `CsrfTokenUtil` を使用すると、生成されたCSRFトークンを取得できる。プロジェクトのアーキテクチャに合わせてクライアントにCSRFトークンを送る仕組みを実装することで、:ref:`RESTfulウェブサービス<restful_web_service>` のCSRF対策を実現できる。

**カスタマイズ可能なコンポーネント** (`CsrfTokenVerificationHandler` プロパティ):

| プロパティ名 | インターフェース | 説明 |
|---|---|---|
| csrfTokenGenerator | `CsrfTokenGenerator` | CSRFトークンの生成 |
| verificationTargetMatcher | `VerificationTargetMatcher` | 検証対象か否かの判定 |
| verificationFailureHandler | `VerificationFailureHandler` | 検証失敗時の処理 |

**`nablarch.common.web.WebConfig` で変更可能なプロパティ**:

| プロパティ名 | 説明 |
|---|---|
| csrfTokenHeaderName | HTTPリクエストヘッダからCSRFトークンを取得する際の名前（デフォルト: `X-CSRF-TOKEN`） |
| csrfTokenParameterName | HTTPリクエストパラメータからCSRFトークンを取得する際の名前（デフォルト: `csrf-token`） |
| csrfTokenSessionStoredVarName | セッションストアに格納する際の名前（デフォルト: `nablarch_csrf-token`） |
| csrfTokenSavedStoreName | CSRFトークンを保存するセッションストアの名前 |

> **重要**: テスティングフレームワークを使用してリクエスト単体テストを実施すると、正しい画面遷移を経由しないためCSRFトークンの検証に失敗する。テスト実行時の設定でCSRF対策を無効化すること。本ハンドラのコンポーネントを `NopHandler` に差し替えることで無効化できる。

```xml
<component name="csrfTokenVerificationHandler" class="nablarch.test.NopHandler" />
```

<details>
<summary>keywords</summary>

CsrfTokenGenerator, UUIDv4CsrfTokenGenerator, VerificationTargetMatcher, HttpMethodVerificationTargetMatcher, VerificationFailureHandler, BadRequestVerificationFailureHandler, NopHandler, csrfTokenGenerator, verificationTargetMatcher, verificationFailureHandler, csrfTokenHeaderName, csrfTokenParameterName, csrfTokenSessionStoredVarName, csrfTokenSavedStoreName, X-CSRF-TOKEN, csrf-token, nablarch_csrf-token, WebConfig, nablarch.common.web.WebConfig, CsrfTokenUtil, RESTfulウェブサービス, CSRFトークン生成, CSRFトークン検証, テスト無効化, BadRequest 400

</details>

## CSRFトークンを再生成する

ログイン時にCSRFトークンを再生成しないと、悪意のある人物がCSRFトークンとセッションIDを利用者に送り込み、ログイン後に攻撃リクエストを送信させることが可能になる。

- アクション等のリクエスト処理で `CsrfTokenUtil.regenerateCsrfToken` を呼び出すと、ハンドラの戻り処理でCSRFトークンが再生成される
- ログイン時にセッションストアを破棄して再生成する実装であれば、このメソッドは不要（セッションストア破棄時にCSRFトークンも破棄され、次のページ表示時に新しいトークンが生成されるため）
- ログイン時にセッションIDの再生成のみ行う実装の場合は、このメソッドを使用してCSRFトークンも再生成すること

<details>
<summary>keywords</summary>

CsrfTokenUtil, regenerateCsrfToken, nablarch.common.web.csrf.CsrfTokenUtil, CSRFトークン再生成, ログイン, セッションID再生成, セッションストア破棄

</details>
