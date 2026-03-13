# CSRFトークン検証ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/csrf/CsrfTokenUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/CsrfTokenGenerator.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/UUIDv4CsrfTokenGenerator.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/VerificationTargetMatcher.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/HttpMethodVerificationTargetMatcher.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/VerificationFailureHandler.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/csrf/BadRequestVerificationFailureHandler.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/NopHandler.html)

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

nablarch-fw-web, com.nablarch.framework, モジュール依存関係, Maven設定

</details>

## 制約

- [session_store_handler](handlers-SessionStoreHandler.md) より後ろに配置すること（CSRFトークンをセッションストアに格納するため）
- :ref:`tag` を使用する場合は [nablarch_tag_handler](handlers-nablarch_tag_handler.md) より後ろに配置すること（:ref:`tag-hidden_encryption` を使用してCSRFトークンを画面に出力するため）

<details>
<summary>keywords</summary>

配置制約, ハンドラ順序, session_store_handler, nablarch_tag_handler, tag-hidden_encryption, セッションストアハンドラより後

</details>

## CSRFトークンの生成と検証

:ref:`session_store` の使用が必須（CSRFトークンをセッションストアに格納するため）。

**RESTfulウェブサービスでのCSRF対策**:
ハンドラはリクエストヘッダまたはリクエストパラメータからCSRFトークンを取得するため、:ref:`RESTfulウェブサービス<restful_web_service>` のCSRF対策にも対応している。生成されたCSRFトークンを取得するためのユーティリティクラス `CsrfTokenUtil` が提供されており、プロジェクトのアーキテクチャに合わせてクライアントにCSRFトークンを送る仕組みを実装できる。

**処理フロー**:
1. セッションストアからCSRFトークンを取得する
2. 取得できなかった場合はCSRFトークンを生成してセッションストアへ保存する
3. HTTPリクエストが検証対象か否かを判定する
4. 検証対象の場合はHTTPリクエストからCSRFトークンを取得して検証する
5. 検証に失敗した場合はBadRequest(400)のレスポンスを返す
6. 検証に成功した場合は次のハンドラへ処理を移す

**設定例**（:ref:`tag` 使用時）:
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

**デフォルト動作**:

| 項目 | デフォルト |
|---|---|
| セッションストア格納名 | `nablarch_csrf-token` |
| トークン生成クラス | `UUIDv4CsrfTokenGenerator`（UUID v4使用） |
| 使用セッションストア | デフォルトのセッションストア（名前指定なし） |
| 検証対象判定クラス | `HttpMethodVerificationTargetMatcher`：GET/HEAD/TRACE/OPTIONSは検証対象外、それ以外（POST/PUT等）は検証対象 |
| リクエストヘッダ名 | `X-CSRF-TOKEN` |
| リクエストパラメータ名 | `csrf-token` |
| 検証失敗時処理 | `BadRequestVerificationFailureHandler`：BadRequest(400)を返す |

**カスタマイズ設定例**:
```xml
<component class="nablarch.fw.web.handler.CsrfTokenVerificationHandler">
  <property name="csrfTokenGenerator">
    <component class="com.sample.CustomCsrfTokenGenerator" />
  </property>
  <property name="verificationTargetMatcher">
    <component class="com.sample.CustomVerificationTargetMatcher" />
  </property>
  <property name="verificationFailureHandler" />
    <component class="com.sample.CustomVerificationFailureHandler" />
  </property>
</component>
<component name="webConfig" class="nablarch.common.web.WebConfig">
  <property name="csrfTokenHeaderName" value="X-CUSTOM-CSRF-TOKEN" />
  <property name="csrfTokenParameterName" value="custom-csrf-token" />
  <property name="csrfTokenSessionStoredVarName" value="custom-csrf-token" />
  <property name="csrfTokenSavedStoreName" value="customStore" />
</component>
```

> **重要**: テスティングフレームワークを使用したリクエスト単体テストでは、正しい画面遷移を経由しないためCSRFトークン検証が失敗する。テスト設定でコンポーネントを `NopHandler` に差し替えてCSRF対策を無効化すること。
>
> ```xml
> <!-- コンポーネント名を合わせることで上書き -->
> <component name="csrfTokenVerificationHandler" class="nablarch.test.NopHandler" />
> ```

<details>
<summary>keywords</summary>

CSRFトークン生成, CSRFトークン検証, UUIDv4CsrfTokenGenerator, HttpMethodVerificationTargetMatcher, BadRequestVerificationFailureHandler, CsrfTokenGenerator, VerificationTargetMatcher, VerificationFailureHandler, NopHandler, nablarch_csrf-token, X-CSRF-TOKEN, csrf-token, csrfTokenHeaderName, csrfTokenParameterName, csrfTokenSessionStoredVarName, csrfTokenSavedStoreName, WebConfig, テスト時無効化, 処理フロー, CsrfTokenUtil, RESTfulウェブサービス, クライアントへのCSRFトークン送信

</details>

## CSRFトークンを再生成する

ログイン後もCSRFトークンが再生成されていない場合、悪意のある人がCSRFトークンとセッションIDを利用者に送り込み、ログイン後に罠ページから利用者の意図しない攻撃リクエストを送信させることができる。ログイン時にCSRFトークンを再生成すること。

アクション等のリクエスト処理で `CsrfTokenUtil.regenerateCsrfToken` を呼び出すと、ハンドラの戻り処理でCSRFトークンが再生成される。

- ログイン時にセッションストアを破棄して再生成する実装: このメソッドは不要（セッションストア破棄と共にCSRFトークンも破棄され、次ページ表示時に新トークンが生成される）
- ログイン時にセッションIDの再生成のみの実装: このメソッドを使用してCSRFトークンも再生成すること

<details>
<summary>keywords</summary>

CSRFトークン再生成, CsrfTokenUtil, regenerateCsrfToken, ログイン時のCSRF対策, セッションID再生成, セッションストア破棄

</details>
