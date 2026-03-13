# HTTPリライトハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/http_rewrite_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpRewriteHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/RewriteRule.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.HttpRewriteHandler`

**使用場面**: 「未ログイン状態の際は強制的にログイン画面に遷移させる」といった、特殊な遷移が必要になった際に使用する。

<details>
<summary>keywords</summary>

HttpRewriteHandler, nablarch.fw.web.handler.HttpRewriteHandler, HTTPリライトハンドラ, ハンドラクラス名, 未ログイン, 特殊な遷移, ログイン画面, いつ使うか, 使用場面

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

- [http_response_handler](handlers-http_response_handler.md) より後ろに配置すること: 書き換えたコンテンツパスはレスポンスハンドラが使用するため、[http_response_handler](handlers-http_response_handler.md) の後ろに配置する必要がある。
- [thread_context_handler](handlers-thread_context_handler.md) より前に配置すること: スレッドコンテキストに入れられるリクエストパスを書き換えるため、[thread_context_handler](handlers-thread_context_handler.md) より前に配置する必要がある。

<details>
<summary>keywords</summary>

http_response_handler, thread_context_handler, 配置順序, ハンドラ配置制約

</details>

## 書き換えの設定

`HttpRewriteHandler` のプロパティ `requestPathRewriteRules`（リクエストパス書き換え）または `contentPathRewriteRules`（コンテンツパス書き換え）に設定する。リクエストパス書き換えには `HttpRequestRewriteRule`、コンテンツパス書き換えには `ContentPathRewriteRule` を使用する。

プロパティ（スーパークラス `RewriteRule` に定義）:

| プロパティ名 | 説明 |
|---|---|
| pattern | 適用する対象のパスのパターン |
| rewriteTo | 書き換え後の文字列 |
| conditions | パス以外の追加の適用条件 |
| exports | 変数の書き換え設定 |

`conditions` で使用可能な変数:

| 変数種別 | 書式 | 適用可能なクラス |
|---|---|---|
| セッションスコープ | %{session:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| リクエストスコープ | %{request:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| スレッドコンテキスト | %{thread:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| リクエストパラメータ | %{param:(変数名)} | HttpRequestRewriteRule |
| HTTPヘッダ | %{header:(ヘッダ名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| HTTPリクエストメソッド | %{httpMethod} | HttpRequestRewriteRule |
| HTTPバージョン | %{httpVersion} | HttpRequestRewriteRule |
| 全リクエストパラメータ名 | %{paramNames} | HttpRequestRewriteRule |
| ステータスコード | %{statusCode} | ContentPathRewriteRule |

```xml
<component class="nablarch.fw.web.handler.HttpRewriteHandler">
  <!-- リクエストパスに対するリライトルール -->
  <property name="requestPathRewriteRules">
    <list>
      <!-- 既にログインが成立していればメニュー画面へ遷移 -->
      <component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
        <property name="pattern" value="^/$" />
        <property name="conditions">
          <list>
            <value>%{session:user.id} ^\S+$</value>
          </list>
        </property>
        <property name="rewriteTo" value="/action/MenuAction/show" />
      </component>
      <!-- ログインが成立していない場合はログイン画面へ遷移 -->
      <component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
        <property name="pattern" value="^/$" />
        <property name="rewriteTo" value="/action/LoginAction/authenticate" />
      </component>
    </list>
  </property>
  <!-- レスポンスのコンテンツパスに対するリライトルール -->
  <property name="contentPathRewriteRules">
    <list>
      <!-- ステータスコードが401の場合はログイン画面に遷移 -->
      <component class="nablarch.fw.web.handler.ContentPathRewriteRule">
        <property name="pattern" value="^.*" />
        <property name="rewriteTo" value="redirect:///action/LoginAction/authenticate" />
        <property name="conditions">
          <list>
            <value>%{statusCode} ^401$</value>
          </list>
        </property>
      </component>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

HttpRequestRewriteRule, ContentPathRewriteRule, RewriteRule, nablarch.fw.web.handler.HttpRequestRewriteRule, nablarch.fw.web.handler.ContentPathRewriteRule, nablarch.fw.handler.RewriteRule, requestPathRewriteRules, contentPathRewriteRules, pattern, rewriteTo, conditions, exports, リクエストパス書き換え, コンテンツパス書き換え, conditions変数

</details>

## 変数に値を設定

`HttpRequestRewriteRule` または `ContentPathRewriteRule` の `exports` プロパティに、「設定する変数名」と「設定する値」のペアをリストで設定することで、リクエストスコープ・セッションスコープ・スレッドコンテキスト・ウィンドウスコープへ変数を設定できる。

`exports` で設定できる変数スコープ:

| 変数スコープ | 書式 | 対象 |
|---|---|---|
| セッションスコープ | %{session:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| リクエストスコープ | %{request:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| スレッドコンテキスト | %{thread:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| ウィンドウスコープ | %{param:(変数名)} | HttpRequestRewriteRule |

```xml
<!-- リファラヘッダが送信された場合、リクエストスコープにその値を設定する例 -->
<component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
  <property name="pattern" value=".*" />
  <property name="conditions">
    <list>
      <value>%{header:Referer} ^\S+$</value>
    </list>
  </property>
  <property name="exports">
    <list>
      <value>%{request:prevUrl} ${header:Referer}</value>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

HttpRequestRewriteRule, ContentPathRewriteRule, exports, セッションスコープ, リクエストスコープ, スレッドコンテキスト, ウィンドウスコープ, 変数設定, スコープへの変数設定

</details>
