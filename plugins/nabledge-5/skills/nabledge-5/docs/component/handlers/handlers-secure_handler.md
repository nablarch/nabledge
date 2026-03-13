# セキュアハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/secure_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/SecureHandler.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/FrameOptionsHeader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/ContentTypeOptionsHeader.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/XssProtectionHeader.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/ReferrerPolicyHeader.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/CacheControlHeader.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/SecureResponseHeader.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/SecureResponseHeaderSupport.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/secure/ContentSecurityPolicyHeader.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.SecureHandler`

<details>
<summary>keywords</summary>

SecureHandler, nablarch.fw.web.handler.SecureHandler, セキュアハンドラ, Webセキュリティハンドラ

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

[http_response_handler](handlers-http_response_handler.md) よりも後ろに設定すること。本ハンドラで設定したレスポンスヘッダを、[http_response_handler](handlers-http_response_handler.md) がServlet APIのレスポンスオブジェクトに設定するため。

<details>
<summary>keywords</summary>

http_response_handler, ハンドラ順序, 配置制約, レスポンスヘッダ設定順序

</details>

## デフォルトで適用されるヘッダの値を変更したい

デフォルトで設定されるレスポンスヘッダ:

- X-Frame-Options: SAMEORIGIN
- X-XSS-Protection: 1; mode=block
- X-Content-Type-Options: nosniff
- Referrer-Policy: strict-origin-when-cross-origin
- Cache-Control: no-store

デフォルト値を変更する場合は、コンポーネント設定ファイルに明示的に設定する。例として `X-Frame-Options` を `DENY` に変更する場合:

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

> **補足**: 値を変更するためのプロパティの詳細は以下のクラスを参照: `FrameOptionsHeader`, `ContentTypeOptionsHeader`, `XssProtectionHeader`, `ReferrerPolicyHeader`, `CacheControlHeader`

<details>
<summary>keywords</summary>

X-Frame-Options, X-XSS-Protection, X-Content-Type-Options, Referrer-Policy, Cache-Control, FrameOptionsHeader, XssProtectionHeader, ContentTypeOptionsHeader, ReferrerPolicyHeader, CacheControlHeader, nablarch.fw.web.handler.secure.FrameOptionsHeader, nablarch.fw.web.handler.secure.XssProtectionHeader, nablarch.fw.web.handler.secure.ContentTypeOptionsHeader, nablarch.fw.web.handler.secure.ReferrerPolicyHeader, nablarch.fw.web.handler.secure.CacheControlHeader, デフォルトヘッダ変更, セキュリティヘッダカスタマイズ

</details>

## デフォルト以外のレスポンスヘッダを設定する

1. `SecureResponseHeader` インタフェースを実装し、レスポンスヘッダのフィールド名と値を指定する。ロジックを含まない単純なヘッダは `SecureResponseHeaderSupport` を継承して作成する。
2. `SecureHandler` の `secureResponseHeaderList` に作成したクラスを設定する。

> **重要**: `SecureResponseHeader` 実装クラスを設定する際は、デフォルトで適用されていたコンポーネントも合わせて設定すること。

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

SecureResponseHeader, SecureResponseHeaderSupport, nablarch.fw.web.handler.secure.SecureResponseHeader, nablarch.fw.web.handler.secure.SecureResponseHeaderSupport, secureResponseHeaderList, カスタムレスポンスヘッダ追加, 独自セキュリティヘッダ

</details>

## Content Security Policy(CSP)に対応する

本ハンドラの設定と `ContentSecurityPolicyHeader`、および [JSPカスタムタグのCSP対応](../libraries/libraries-tag.md) を組み合わせることでCSPを有効にできる。:ref:`tag` を使用している場合、一部カスタムタグがJavaScriptを出力するため、nonceを生成してレスポンスヘッダやscript要素に埋め込む。

> **重要**: Internet Explorer 11はCSPに対応していないため、対象環境にIE11が含まれるか確認したうえで使用すること。

### 固定のContent-Security-Policyヘッダを設定する

1. `SecureHandler` に `ContentSecurityPolicyHeader` を設定する。
2. `ContentSecurityPolicyHeader` の `policy` を設定する。

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
        <property name="policy" value="default-src 'self'" />
      </component>
    </list>
  </property>
</component>
```

`Content-Security-Policy: default-src 'self'` というレスポンスヘッダが書き出される。

### nonceを生成してContent-Security-Policyヘッダに設定する

1. `SecureHandler` の `generateCspNonce` プロパティを `true` に設定する。
2. `ContentSecurityPolicyHeader` を設定する。
3. `policy` にプレースホルダー `$cspNonceSource$` を含める。

```xml
<component class="nablarch.fw.web.handler.SecureHandler">
  <property name="generateCspNonce" value="true" />
  <property name="secureResponseHeaderList">
    <list>
      <component class="nablarch.fw.web.handler.secure.FrameOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.XssProtectionHeader" />
      <component class="nablarch.fw.web.handler.secure.ContentTypeOptionsHeader" />
      <component class="nablarch.fw.web.handler.secure.ReferrerPolicyHeader" />
      <component class="nablarch.fw.web.handler.secure.CacheControlHeader" />
      <component class="nablarch.fw.web.handler.secure.ContentSecurityPolicyHeader">
        <property name="policy" value="default-src 'self' '$cspNonceSource$'" />
      </component>
    </list>
  </property>
</component>
```

`$cspNonceSource$` は `nonce-[生成されたnonce]` に置換される（例: `Content-Security-Policy: default-src 'self' 'nonce-DhcnhD3khTMePgXwdayK9BsMqXjhguVV'`）。nonceはリクエストごとに生成されリクエストスコープに格納される。:ref:`tag` の動作変更:

- script要素を生成するカスタムタグ: 生成したnonceがnonce属性に自動設定される
- onclick属性にサブミット用関数呼び出しを設定するカスタムタグ: 内容をscript要素に出力するよう変更される

任意の要素にnonceを設定するカスタムタグも利用可能。詳しくは [JSPカスタムタグのCSP対応](../libraries/libraries-tag.md) を参照。

### report-only モードで動作させる

`ContentSecurityPolicyHeader` の `reportOnly` プロパティを `true` に設定する。

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
        <property name="reportOnly" value="true" />
      </component>
    </list>
  </property>
</component>
```

`Content-Security-Policy-Report-Only: default-src 'src'; report-uri http://example.com/report` というレスポンスヘッダが書き出される。

<details>
<summary>keywords</summary>

ContentSecurityPolicyHeader, nablarch.fw.web.handler.secure.ContentSecurityPolicyHeader, generateCspNonce, CSP, Content-Security-Policy, nonce, $cspNonceSource$, reportOnly, Content-Security-Policy-Report-Only, クロスサイトスクリプティング対策, CSP nonce生成, report-onlyモード, tag-content_security_policy

</details>
