# セキュアハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/secure_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/SecureHandler.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/FrameOptionsHeader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/XssProtectionHeader.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/ContentTypeOptionsHeader.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/ReferrerPolicyHeader.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/CacheControlHeader.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/SecureResponseHeader.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/SecureResponseHeaderSupport.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/ContentSecurityPolicyHeader.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.SecureHandler`

デフォルトで設定されるレスポンスヘッダ:
- X-Frame-Options: SAMEORIGIN
- X-XSS-Protection: 1; mode=block
- X-Content-Type-Options: nosniff
- Referrer-Policy: strict-origin-when-cross-origin
- Cache-Control: no-store

処理内容:
1. Content-Security-Policyのnonceの生成
2. セキュリティ関連のレスポンスヘッダの設定

<details>
<summary>keywords</summary>

SecureHandler, nablarch.fw.web.handler.SecureHandler, セキュアハンドラ, セキュリティヘッダ設定, X-Frame-Options, X-XSS-Protection, X-Content-Type-Options, Cache-Control, Referrer-Policy, CSP nonce生成, HttpResponse, nablarch.fw.web.HttpResponse

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

nablarch-fw-web, com.nablarch.framework, モジュール依存関係

</details>

## 制約

:ref:`http_response_handler` より後ろに設定すること。本ハンドラで設定したレスポンスヘッダを :ref:`http_response_handler` がServlet APIのレスポンスオブジェクトに設定するため。

<details>
<summary>keywords</summary>

http_response_handler, ハンドラ設定順序, 制約, Servlet APIレスポンス

</details>

## デフォルトで適用されるヘッダの値を変更したい

デフォルトのセキュリティ関連ヘッダの値を変更する場合、コンポーネント設定ファイルで明示的に設定する。

例（X-Frame-OptionsをDENYに変更）:
```xml
<component class="nablarch.fw.web.handler.SecureHandler">
  <property name="secureResponseHeaderList">
    <list>
      <component class="nablarch.fw.web.handler.secure.FrameOptionsHeader">
        <property name="option" value="DENY" />
      </component>
      <component class="nablarch.fw.web.handler.secure.XssProtectionHeader" />
      <component class="nablarch.fw.web.handler.secure.ContentTypeOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.ReferrerPolicyHeader" />
      <component class="nablarch.fw.web.handler.secure.CacheControlHeader" />
    </list>
  </property>
</component>
```

> **補足**: 値変更用プロパティの詳細は各クラスを参照: `FrameOptionsHeader`, `ContentTypeOptionsHeader`, `XssProtectionHeader`, `ReferrerPolicyHeader`, `CacheControlHeader`

<details>
<summary>keywords</summary>

FrameOptionsHeader, XssProtectionHeader, ContentTypeOptionsHeader, ReferrerPolicyHeader, CacheControlHeader, nablarch.fw.web.handler.secure.FrameOptionsHeader, secureResponseHeaderList, セキュリティヘッダカスタマイズ, X-Frame-Options変更

</details>

## デフォルト以外のレスポンスヘッダを設定する

デフォルト以外のセキュリティ関連レスポンスヘッダを追加する手順:

1. `SecureResponseHeader` インタフェースの実装クラスで、レスポンスヘッダのフィールド名と値を指定する。
   > **補足**: ロジックを含まない単純なレスポンスヘッダを作成する場合は `SecureResponseHeaderSupport` を継承する。
2. `SecureHandler` に作成したクラスを設定する。

> **重要**: `SecureResponseHeader` 実装クラスを設定する際は、デフォルトで適用されていたコンポーネントも設定すること。

```xml
<component class="nablarch.fw.web.handler.SecureHandler">
  <property name="secureResponseHeaderList">
    <list>
      <component class="nablarch.fw.web.handler.secure.FrameOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.XssProtectionHeader" />
      <component class="nablarch.fw.web.handler.secure.ContentTypeOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.ReferrerPolicyHeader" />
      <component class="nablarch.fw.web.handler.secure.CacheControlHeader" />
      <!-- 追加で作成したコンポーネント -->
      <component class="nablarch.fw.web.handler.secure.SampleSecurityHeader" />
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

SecureResponseHeader, SecureResponseHeaderSupport, nablarch.fw.web.handler.secure.SecureResponseHeader, nablarch.fw.web.handler.secure.SecureResponseHeaderSupport, カスタムセキュリティヘッダ追加, secureResponseHeaderList

</details>

## Content Security Policy(CSP)に対応する

本ハンドラの設定と `ContentSecurityPolicyHeader`、および :ref:`Jakarta Server PagesカスタムタグのCSP対応 <tag-content_security_policy>` を組み合わせることでCSPに関する機能を有効にできる。

> **補足**: Content Security Policy(CSP)は、クロスサイトスクリプティングなどのコンテンツへのインジェクションに関する攻撃を検知し影響を軽減するために追加できる仕組みである。

:ref:`tag` を使用している場合は一部のカスタムタグでJavaScriptを出力するため、本ハンドラの機能でnonceを生成しレスポンスヘッダやscript要素などに埋め込むことで対応する。`Content-Security-Policy` ヘッダの出力には `ContentSecurityPolicyHeader` (`nablarch.fw.web.handler.secure.ContentSecurityPolicyHeader`) を使用することで本ハンドラで生成したnonceを埋め込める。

<details>
<summary>keywords</summary>

ContentSecurityPolicyHeader, nablarch.fw.web.handler.secure.ContentSecurityPolicyHeader, CSP, Content-Security-Policy, クロスサイトスクリプティング対策, tag-content_security_policy, Jakarta Server Pages CSP対応

</details>

## 固定のContent-Security-Policyヘッダを設定する

固定のContent-Security-Policyヘッダを設定する手順:

1. `SecureHandler` に `ContentSecurityPolicyHeader` を設定する。
2. `ContentSecurityPolicyHeader` に `policy` を設定する。

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

この場合、`Content-Security-Policy: default-src 'self'` といったレスポンスヘッダが書き出される。

<details>
<summary>keywords</summary>

ContentSecurityPolicyHeader, nablarch.fw.web.handler.secure.ContentSecurityPolicyHeader, policy, 固定CSPヘッダ, Content-Security-Policy設定

</details>

## nonceを生成してContent-Security-Policyヘッダに設定する

nonceを生成してContent-Security-Policyヘッダに設定する手順:

1. `SecureHandler` の `generateCspNonce` プロパティを `true` に設定する。
2. `ContentSecurityPolicyHeader` を設定する。
3. `ContentSecurityPolicyHeader` の `policy` にプレースホルダー `$cspNonceSource$` を含める。

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

`$cspNonceSource$` は `nonce-[本ハンドラで生成されたnonce]` に置換される（例: `Content-Security-Policy: default-src 'self' 'nonce-DhcnhD3khTMePgXwdayK9BsMqXjhguVV'`）。

nonceはリクエストの都度生成され、リクエストスコープに格納される。:ref:`tag` の動作が以下のように変更される:
- script要素を生成するカスタムタグは、生成したnonceを自動でnonce属性に設定する。
- onclick属性にサブミット用の関数呼び出しを設定するカスタムタグは、その内容をscript要素に出力するように変更する。
- 任意の要素にnonceを設定できるカスタムタグも有効になる。

詳細は :ref:`Jakarta Server PagesカスタムタグのCSP対応 <tag-content_security_policy>` を参照。

<details>
<summary>keywords</summary>

generateCspNonce, nonce, $cspNonceSource$, ContentSecurityPolicyHeader, nablarch.fw.web.handler.secure.ContentSecurityPolicyHeader, CSP nonce, Content-Security-Policy nonce

</details>

## report-onlyモードで動作させる

report-onlyモードで動作させる場合は `ContentSecurityPolicyHeader` の `reportOnly` を `true` に設定する。

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

この場合、`Content-Security-Policy-Report-Only: default-src 'src'; report-uri http://example.com/report` といったレスポンスヘッダが書き出される。

<details>
<summary>keywords</summary>

reportOnly, report-onlyモード, Content-Security-Policy-Report-Only, ContentSecurityPolicyHeader, nablarch.fw.web.handler.secure.ContentSecurityPolicyHeader, CSP report-only

</details>
