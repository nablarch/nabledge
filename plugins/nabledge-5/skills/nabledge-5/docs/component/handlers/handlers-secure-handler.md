# セキュアハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* デフォルトで適用されるヘッダの値を変更したい
* デフォルト以外のレスポンスヘッダを設定する
* Content Security Policy(CSP)に対応する

  * 固定のContent-Security-Policyヘッダを設定する
  * nonceを生成してContent-Security-Policyヘッダに設定する
  * report-only モードで動作させる

本ハンドラでは、Webアプリケーションのセキュリティに関する処理やヘッダ設定を行う。

デフォルトでは、レスポンスオブジェクト(HttpResponse)に対して以下のレスポンスヘッダを設定する。

* X-Frame-Options: SAMEORIGIN
* X-XSS-Protection: 1; mode=block
* X-Content-Type-Options: nosniff
* Referrer-Policy: strict-origin-when-cross-origin
* Cache-Control: no-store

本ハンドラでは、以下の処理を行う。

* Content-Security-Policyのnonceの生成
* セキュリティ関連のレスポンスヘッダの設定処理

処理の流れは以下のとおり。

![flow.png](../../../knowledge/assets/handlers-secure-handler/flow.png)

## ハンドラクラス名

* nablarch.fw.web.handler.SecureHandler

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

[HTTPレスポンスハンドラ](../../component/handlers/handlers-http-response-handler.md#http-response-handler) よりも後ろに設定すること

本ハンドラで設定したレスポンスヘッダを、 [HTTPレスポンスハンドラ](../../component/handlers/handlers-http-response-handler.md#http-response-handler) がServlet APIのレスポンスオブジェクトに設定するため。

## デフォルトで適用されるヘッダの値を変更したい

要件により、デフォルトで適用されるセキュリティ関連のヘッダの値を変更したい場合がある。

例えば、フレーム内の表示を全て許可しない場合には、 `X-Frame-Options` ヘッダの値を `DENY` に変更する必要がある。
このような場合は、コンポーネント設定ファイルに明示的に設定することで対応する。

以下に例を示す。

```xml
<component class="nablarch.fw.web.handler.SecureHandler">
  <property name="secureResponseHeaderList">
    <list>
      <!-- X-Frame-Optionsの値を明示的に指定 -->
      <component class="nablarch.fw.web.handler.secure.FrameOptionsHeader">
        <property name="option" value="DENY" />
      </component>

      <!-- 上記以外のヘッダはデフォルトのまま -->
      <component class="nablarch.fw.web.handler.secure.XssProtectionHeader" />
      <component class="nablarch.fw.web.handler.secure.ContentTypeOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.ReferrerPolicyHeader" />
      <component class="nablarch.fw.web.handler.secure.CacheControlHeader" />
    </list>
  </property>
</component>
```

> **Tip:**
> 値を変更するためのプロパティの詳細は、以下のクラスを参照。

> * >   FrameOptionsHeader
> * >   ContentTypeOptionsHeader
> * >   XssProtectionHeader
> * >   ReferrerPolicyHeader
> * >   CacheControlHeader

## デフォルト以外のレスポンスヘッダを設定する

デフォルト以外のセキュリティ関連のレスポンスヘッダを設定する手順を以下に示す。

1. SecureResponseHeader インタフェースの実装クラスで、
  レスポンスヘッダに設定するフィールド名と値を指定する。

> **Tip:**
> ロジックを含まない単純なレスポンスヘッダを作成する場合は、
> SecureResponseHeaderSupport
> を継承して作成すればよい。

1. 本ハンドラ(SecureHandler)に、`No1` で作成したクラスを設定する。

> **Important:**
> SecureResponseHeader 実装クラスを設定する際は、
> デフォルトで適用されていたコンポーネントも設定すること。

> 以下に設定ファイルの例を示す。

> ```xml
> <component class="nablarch.fw.web.handler.SecureHandler">
>   <property name="secureResponseHeaderList">
>     <list>
>       <component class="nablarch.fw.web.handler.secure.FrameOptionsHeader" />
>       <component class="nablarch.fw.web.handler.secure.XssProtectionHeader" />
>       <component class="nablarch.fw.web.handler.secure.ContentTypeOptionsHeader" />
>       <component class="nablarch.fw.web.handler.secure.ReferrerPolicyHeader" />
>       <component class="nablarch.fw.web.handler.secure.CacheControlHeader" />
> 
>       <!-- 追加で作成したコンポーネント -->
>       <component class="nablarch.fw.web.handler.secure.SampleSecurityHeader" />
>     </list>
>   </property>
> </component>
> ```

## Content Security Policy(CSP)に対応する

本ハンドラの設定と `ContentSecurityPolicyHeader` 、そして [JSPカスタムタグのCSP対応](../../component/libraries/libraries-tag.md#tag-content-security-policy) を組み合わせることでCSPに関する機能を有効にできる。

> **Tip:**
> Content Security Policy(CSP)は、クロスサイトスクリプティングなどのコンテンツへのインジェクションに関する攻撃を検知し影響を
> 軽減するために追加できる仕組みのことである。CSPそのものについては、 [Content Security Policy Level 3(外部サイト、英語)](https://www.w3.org/TR/CSP3/) や
> [Content Security Policy Level 2(外部サイト、英語)](https://www.w3.org/TR/CSP2/) を参照すること。

[JSPカスタムタグ](../../component/libraries/libraries-tag.md#tag) を使用している場合は一部のカスタムタグでJavaScriptを出力するため、本ハンドラの機能でnonceを生成しレスポンスヘッダやscript要素などに埋め込むことで対応する。

Content-Security-Policyヘッダの出力には、 `ContentSecurityPolicyHeader` を使用することで本ハンドラで生成したnonceを
埋め込むことができる。

### 固定のContent-Security-Policyヘッダを設定する

固定のContent-Security-Policyヘッダを設定する手順を以下に示す。

1. 本ハンドラ(SecureHandler)に、 `ContentSecurityPolicyHeader` を設定する。
2. `ContentSecurityPolicyHeader` に `policy` を設定する。

以下に例を示す。

```xml
<component class="nablarch.fw.web.handler.SecureHandler">
  <property name="secureResponseHeaderList">
    <list>
      <component class="nablarch.fw.web.handler.secure.FrameOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.XssProtectionHeader" />
      <component class="nablarch.fw.web.handler.secure.ContentTypeOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.ReferrerPolicyHeader" />
      <component class="nablarch.fw.web.handler.secure.CacheControlHeader" />

      <!-- Content-Security-Policyを付与するコンポーネント -->
      <component class="nablarch.fw.web.handler.secure.ContentSecurityPolicyHeader">
        <!-- ポリシーを設定する -->
        <property name="policy" value="default-src 'self'" />
      </component>
    </list>
  </property>
</component>
```

この場合、 `Content-Security-Policy: default-src 'self'` といったレスポンスヘッダが書き出される。

### nonceを生成してContent-Security-Policyヘッダに設定する

nonceを生成してContent-Security-Policyヘッダに設定する手順を以下に示す。

1. 本ハンドラ(SecureHandler)の `generateCspNonce` プロパティを `true` に設定する。
2. 本ハンドラに、`ContentSecurityPolicyHeader` を設定する。
3. `ContentSecurityPolicyHeader` に `policy` を設定し、プレースホルダー `$cspNonceSource$` を含める。

以下に例を示す。

```xml
<component class="nablarch.fw.web.handler.SecureHandler">
  <!-- nonceを生成するように設定する -->
  <property name="generateCspNonce" value="true" />
  <property name="secureResponseHeaderList">
    <list>
      <component class="nablarch.fw.web.handler.secure.FrameOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.XssProtectionHeader" />
      <component class="nablarch.fw.web.handler.secure.ContentTypeOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.ReferrerPolicyHeader" />
      <component class="nablarch.fw.web.handler.secure.CacheControlHeader" />

      <!-- Content-Security-Policyを付与するコンポーネント -->
      <component class="nablarch.fw.web.handler.secure.ContentSecurityPolicyHeader">
        <!-- nonceを含んだポリシーを設定する -->
        <property name="policy" value="default-src 'self' '$cspNonceSource$'" />
      </component>
    </list>
  </property>
</component>
```

この場合プレースホルダー `$cspNonceSource$` は `nonce-[本ハンドラで生成されたnonce]` に置換され、たとえば `Content-Security-Policy: default-src 'self' 'nonce-DhcnhD3khTMePgXwdayK9BsMqXjhguVV'` のようなレスポンスヘッダとして書き出される。

本ハンドラではnonceをリクエストの都度生成する。
生成したnonceはリクエストスコープに格納され、 [JSPカスタムタグ](../../component/libraries/libraries-tag.md#tag) の動作を以下のように変更する。

* script要素を生成するカスタムタグの場合、生成したnonceを自動でnonce属性に設定する。
* onclick属性にサブミット用の関数呼び出しを設定するカスタムタグは、その内容をscript要素に出力するように変更する。

また任意の要素にnonceを設定したい場合に使えるカスタムタグも有効になる。

詳しくは [JSPカスタムタグのCSP対応](../../component/libraries/libraries-tag.md#tag-content-security-policy) を参照すること。

> **Important:**
> Internet Explorer 11はCSPに対応していないため、開発するアプリケーションの動作対象環境にInternet Explorer 11が含まれているかどうかを確認したうえで
> NablarchのCSPに関する機能を利用すること。

### report-only モードで動作させる

report-only モードで動作させる場合は `reportOnly` を `true` に設定する。

以下に例を示す。

```xml
<component class="nablarch.fw.web.handler.SecureHandler">
  <property name="secureResponseHeaderList">
    <list>
      <component class="nablarch.fw.web.handler.secure.FrameOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.XssProtectionHeader" />
      <component class="nablarch.fw.web.handler.secure.ContentTypeOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.ReferrerPolicyHeader" />
      <component class="nablarch.fw.web.handler.secure.CacheControlHeader" />

      <component class="nablarch.fw.web.handler.secure.ContentSecurityPolicyHeader">
        <property name="policy" value="default-src 'self'; report-uri http://example.com/report" />
        <!-- report-onlyモードで動作させる -->
        <property name="reportOnly" value="true" />
      </component>
    </list>
  </property>
</component>
```

この場合、 `Content-Security-Policy-Report-Only: default-src 'src'; report-uri http://example.com/report` といったレスポンスヘッダが書き出される。
