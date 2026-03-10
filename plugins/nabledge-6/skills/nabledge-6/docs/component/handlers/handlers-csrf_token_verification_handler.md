# CSRFトークン検証ハンドラ

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.CsrfTokenVerificationHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

**必須要件**: 本ハンドラはCSRFトークンをセッションストアに格納するため、本ハンドラを使用する場合は :ref:`session_store` の使用が必須となる。

- :ref:`session_store_handler` より後ろに配置すること（CSRFトークンをセッションストアに格納するため）
- :ref:`tag` を使用する場合は :ref:`nablarch_tag_handler` より後ろに配置すること（:ref:`tag-hidden_encryption` を使用してCSRFトークンを出力するため）

> **補足**: :ref:`multipart_handler` を使ったファイルアップロード時にファイルの保存前にCSRFトークンの検証を行いたい場合は、:ref:`multipart_handler` の前に本ハンドラおよび :ref:`session_store_handler` を配置すること。

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

## CSRFトークンを再生成する

ログイン時にCSRFトークンを再生成しないと、悪意のある人物がCSRFトークンとセッションIDを利用者に送り込み、ログイン後に攻撃リクエストを送信させることが可能になる。

- アクション等のリクエスト処理で `CsrfTokenUtil.regenerateCsrfToken` を呼び出すと、ハンドラの戻り処理でCSRFトークンが再生成される
- ログイン時にセッションストアを破棄して再生成する実装であれば、このメソッドは不要（セッションストア破棄時にCSRFトークンも破棄され、次のページ表示時に新しいトークンが生成されるため）
- ログイン時にセッションIDの再生成のみ行う実装の場合は、このメソッドを使用してCSRFトークンも再生成すること
