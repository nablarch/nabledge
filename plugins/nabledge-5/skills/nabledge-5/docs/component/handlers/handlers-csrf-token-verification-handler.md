# CSRFトークン検証ハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* CSRFトークンの生成と検証
* CSRFトークンを再生成する

本ハンドラは、トークンを使った一般的なCSRF(クロスサイトリクエストフォージェリ)対策を行うための機能を提供する。
本ハンドラを使用して、 [Webアプリケーション](../../processing-pattern/web-application/web-application-web.md#web-application) と [RESTfulウェブサービス](../../processing-pattern/restful-web-service/restful-web-service-rest.md#restful-web-service)
のCSRF対策を実現できる。

本ハンドラをハンドラ構成に含めると、リクエスト処理でCSRFトークンの生成と検証が行われ、 [JSPカスタムタグ](../../component/libraries/libraries-tag.md#tag) を使用している場合は
CSRFトークンが画面に自動で出力される。
そのため、アプリケーションプログラマが実装することなく、 [Webアプリケーション](../../processing-pattern/web-application/web-application-web.md#web-application)
のCSRF対策を漏れなく行うことができる。

[RESTfulウェブサービス](../../processing-pattern/restful-web-service/restful-web-service-rest.md#restful-web-service) においてCSRF対策を実現できるように、
本ハンドラはリクエストヘッダまたはリクエストパラメータからCSRFトークンを取得する。
生成されたCSRFトークンを取得するためのユーティリティクラス(
CsrfTokenUtil )を提供しているので、
プロジェクトのアーキテクチャに合わせてクライアントにCSRFトークンを送る仕組みを実装できる。

本ハンドラはCSRFトークンをセッションストアに格納するため、本ハンドラを使用する場合は [セッションストア](../../component/libraries/libraries-session-store.md#session-store) の使用が必須となる。

本ハンドラでは、以下の処理を行う。

* セッションストアからCSRFトークンを取得する。
* 取得できなかった場合はCSRFトークンを生成してセッションストアへ保存する。
* HTTPリクエストが検証対象か否かを判定する。
* 検証対象の場合はHTTPリクエストからCSRFトークンを取得して検証する。
* 検証に失敗した場合はBadRequest(400)のレスポンスを返す。
* 検証に成功した場合は次のハンドラへ処理を移す。

処理の流れは以下のとおり。

![flow.png](../../../knowledge/assets/handlers-csrf-token-verification-handler/flow.png)

## ハンドラクラス名

* nablarch.fw.web.handler.CsrfTokenVerificationHandler

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

[セッション変数保存ハンドラ](../../component/handlers/handlers-SessionStoreHandler.md#session-store-handler) より後ろに配置すること

CSRFトークンをセッションストアに格納するため、
本ハンドラは [セッション変数保存ハンドラ](../../component/handlers/handlers-SessionStoreHandler.md#session-store-handler) より後ろに配置する必要がある。

[JSPカスタムタグ](../../component/libraries/libraries-tag.md#tag) を使用する場合は [Nablarchカスタムタグ制御ハンドラ](../../component/handlers/handlers-nablarch-tag-handler.md#nablarch-tag-handler) より後ろに配置すること

[JSPカスタムタグ](../../component/libraries/libraries-tag.md#tag) を使用する場合は [クライアントに保持するデータを暗号化する(hidden暗号化)](../../component/libraries/libraries-tag.md#tag-hidden-encryption) を使用して画面にCSRFトークンを出力しているため、
本ハンドラは [Nablarchカスタムタグ制御ハンドラ](../../component/handlers/handlers-nablarch-tag-handler.md#nablarch-tag-handler) より後ろに配置する必要がある。

## CSRFトークンの生成と検証

本ハンドラをハンドラ構成に追加するとCSRFトークンの生成と検証を行う。
[JSPカスタムタグ](../../component/libraries/libraries-tag.md#tag) を使用する場合の設定例を以下に示す。

```xml
<!-- ハンドラ構成 -->
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <!-- 他のハンドラは省略 -->

      <!-- セッションストアハンドラ -->
      <component-ref name="sessionStoreHandler" />

      <!-- Nablarchカスタムタグ制御ハンドラ -->
      <component-ref name="nablarchTagHandler"/>

      <!-- CSRFトークン検証ハンドラ -->
      <component-ref name="csrfTokenVerificationHandler"/>
    </list>
  </property>
</component>

<component name="csrfTokenVerificationHandler"
           class="nablarch.fw.web.handler.CsrfTokenVerificationHandler" />
```

デフォルトでは以下の処理を行う。

セッションストアからCSRFトークンを取得する

* CSRFトークンをセッションストアに格納する際に使用する名前は `nablarch_csrf-token` となる。

取得できなかった場合はCSRFトークンを生成してセッションストアへ保存する

* CSRFトークンの生成は CsrfTokenGenerator が行う。
  デフォルトではバージョン4のUUIDを使用してCSRFトークンを生成する UUIDv4CsrfTokenGenerator を使用する。
* CSRFトークンの格納先となるセッションストアはデフォルトのセッションストアとなる。（セッションストアの名前を指定しないでCSRFトークンを格納する）

HTTPリクエストが検証対象か否かを判定する

* 検証対象か否かの判定は VerificationTargetMatcher が行う。
  デフォルトではHTTPメソッドからHTTPリクエストが検証対象か否かを判定する HttpMethodVerificationTargetMatcher を使用する。
* HttpMethodVerificationTargetMatcher は、HTTPメソッドの `GET` `HEAD` `TRACE` `OPTIONS` をCSRFトークンの検証対象 **外** と判定する（つまりPOSTやPUT等は検査対象となる）。

検証対象の場合はHTTPリクエストからCSRFトークンを取得して検証する

* CSRFトークンをHTTPリクエストに格納する際に使用する名前は以下となる。

  HTTPリクエストヘッダ `X-CSRF-TOKEN`
  HTTPリクエストパラメータ `csrf-token`

検証に成功した場合は次のハンドラへ処理を移し、検証に失敗した場合はBadRequest(400)のレスポンスを返す

* 検証失敗時の処理は VerificationFailureHandler が行う。
  デフォルトではBadRequest(400)のレスポンスを生成する BadRequestVerificationFailureHandler を使用する。

設定を変えることでデフォルトの動作を変更できる。設定例を以下に示す。

```xml
<component class="nablarch.fw.web.handler.CsrfTokenVerificationHandler">
  <!-- CSRFトークンの生成を行うインターフェース -->
  <property name="csrfTokenGenerator">
    <component class="com.sample.CustomCsrfTokenGenerator" />
  </property>
  <!-- HTTPリクエストがCSRFトークンの検証対象か否かの判定を行うインターフェース -->
  <property name="verificationTargetMatcher">
    <component class="com.sample.CustomVerificationTargetMatcher" />
  </property>
  <!-- CSRFトークンの検証失敗時の処理を行うインタフェース -->
  <property name="verificationFailureHandler" />
    <component class="com.sample.CustomVerificationFailureHandler" />
  </property>
</component>

<component name="webConfig" class="nablarch.common.web.WebConfig">
  <!-- CSRFトークンをHTTPリクエストヘッダから取得する際に使用する名前 -->
  <property name="csrfTokenHeaderName" value="X-CUSTOM-CSRF-TOKEN" />
  <!-- CSRFトークンをHTTPリクエストパラメータから取得する際に使用する名前 -->
  <property name="csrfTokenParameterName" value="custom-csrf-token" />
  <!-- CSRFトークンをセッションスストアに格納する際に使用する名前 -->
  <property name="csrfTokenSessionStoredVarName" value="custom-csrf-token" />
  <!-- CSRFトークンを保存するセッションストアの名前 -->
  <property name="csrfTokenSavedStoreName" value="customStore" />
</component>
```

> **Important:**
> 本ハンドラを使用したアプリケーションに対して、テスティングフレームワークを使用してリクエスト単体テストを実施すると、
> 正しい画面遷移を経由したリクエストとならないためCSRFトークンの検証に失敗する。
> CSRF対策はアプリケーションプログラマが実装して作り込む部分ではないため、
> リクエスト単体テストではCSRF対策を無効化してテストを行えばよい。
> テスト実行時の設定において本ハンドラを何も処理しないハンドラに差し替えることでCSRF対策を無効化できる。
> 以下に設定例を示す。以下ではテスティングフレームワークが提供する何も処理しないハンドラである NopHandler を使用している。

> ```xml
> <!-- テストの設定で本ハンドラのコンポーネント定義を上書く。
>      コンポーネント名を合わせることで上書きを行う。 -->
> 
> <!-- CSRF対策の無効化 -->
> <component name="csrfTokenVerificationHandler" class="nablarch.test.NopHandler" />
> ```

## CSRFトークンを再生成する

悪意のある人がCSRFトークンとそれを保持しているセッションストアのセッションIDを何らかの方法で利用者に送り込み、
利用者がこれに気づかずにログインをしたとする。
このときCSRFトークンが再生成されていないと、悪意のあるウェブサイトにCSRFトークンを仕込んだ罠ページを用意し、
利用者にリンクのクリックなどの操作をさせることで利用者の意図しない攻撃リクエストを送信させることができてしまう。
これを防ぐためにはログイン時にCSRFトークンを再生成しなくてはならない。

CSRFトークンの再生成は、アクション等のリクエスト処理の中で
CsrfTokenUtil.regenerateCsrfToken
メソッドを呼び出すと、本ハンドラの戻りの処理でCSRFトークンの再生成が行われる。

ログイン時にセッションストアを破棄して再生成する実装であればこのメソッドを使用する必要はない。
セッションストアの破棄と共にCSRFトークンも破棄され、その後のページ表示時に新しいCSRFトークンが生成されるためである。
ログイン時にセッションストアそのものの破棄ではなくセッションIDの再生成にとどめる実装の場合は、
このメソッドを使用してCSRFトークンも再生成すること。
