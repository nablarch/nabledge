# HTTPリライトハンドラ

## 

**クラス名**: `nablarch.fw.web.handler.HttpRewriteHandler`

<details>
<summary>keywords</summary>

HttpRewriteHandler, nablarch.fw.web.handler.HttpRewriteHandler, HTTPリライトハンドラ

</details>

## 概要

HTTPリクエストオブジェクトおよびHTTPレスポンスオブジェクトの内容を、事前設定のリライトルールに従って動的に書き換える。書換え時にリクエストパスの部分文字列・リクエストパラメータ・HTTPヘッダーの内容を各スコープ上の変数として設定できる。

> **注意**: 本ハンドラは個別プロジェクトの特殊要件対応用で、標準ハンドラ構成には含まれない。

<details>
<summary>keywords</summary>

HTTPリライトハンドラ概要, リクエスト書き換え, レスポンス書き換え, 動的書き換え, スコープ変数設定, 標準ハンドラ構成外

</details>

## リライトルール

リライトルールの設定項目（`HttpRequestRewriteRule` / `ContentPathRewriteRule` 共通）:

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| pattern | String | ○ | | 書き換え対象パスの正規表現パターン（サーブレットコンテキスト起点の相対パス） |
| rewriteTo | String | | | 置換先パス。省略時はパス変更なし |
| conditions | List\<String\> | | 空のList | 書き換え追加条件リスト |
| exports | List\<String\> | | 空のList | 書き換え時にスコープに定義する変数リスト |

- `rewriteTo`が`servlet://`で始まる場合: サーブレットフォワードを返し、**後続ハンドラへ移譲しない**
- `rewriteTo`が`redirect://`で始まる場合: HTTPリダイレクトを返し、**後続ハンドラへ移譲しない**
- それ以外: リクエストパスを書き換えて後続ハンドラに移譲

> **注意**: `pattern`はGlob式ではなく正規表現。[RequestHandlerEntry](handlers-RequestHandlerEntry.md) のGlob式とは異なる。

**設定例（単純置換）**:
```xml
<component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
  <property name="pattern"   value="^/$" />
  <property name="rewriteTo" value="servlet:///login.jsp" />
</component>
```

**適用条件の書式**:
```
%{(変数種別名):(変数名)} (パターン)
```

使用可能な変数種別:

| 変数種別 | 書式 | 対象 |
|---|---|---|
| セッションスコープ | %{session:(変数名)} | `HttpRequestRewriteRule` / `ContentPathRewriteRule` |
| リクエストスコープ | %{request:(変数名)} | `HttpRequestRewriteRule` / `ContentPathRewriteRule` |
| スレッドコンテキスト | %{thread:(変数名)} | `HttpRequestRewriteRule` / `ContentPathRewriteRule` |
| リクエストパラメータ | %{param:(変数名)} | `HttpRequestRewriteRule` |
| HTTPヘッダ | %{header:(ヘッダー名)} | `HttpRequestRewriteRule` / `ContentPathRewriteRule` |
| HTTPリクエストメソッド | %{httpMethod} | `HttpRequestRewriteRule` |
| HTTPバージョン | %{httpVersion} | `HttpRequestRewriteRule` |
| 全リクエストパラメータ名 | %{paramNames} | `HttpRequestRewriteRule` |
| ステータスコード | %{statusCode} | `ContentPathRewriteRule` |

**変数の設定スコープ（exportsで使用）**:

| 変数スコープ | 書式 | 対象 |
|---|---|---|
| セッションスコープ | %{session:(変数名)} | `HttpRequestRewriteRule` / `ContentPathRewriteRule` |
| リクエストスコープ | %{request:(変数名)} | `HttpRequestRewriteRule` / `ContentPathRewriteRule` |
| スレッドコンテキスト | %{thread:(変数名)} | `HttpRequestRewriteRule` / `ContentPathRewriteRule` |
| ウィンドウスコープ | %{param:(変数名)} | `HttpRequestRewriteRule` |

**設定例（変数の設定）**:
```xml
<property name="exports">
  <list>
    <value>%{request:prevUrl} ${header:Referer}</value>
  </list>
</property>
```
（HTTPリファラヘッダの値をリクエストスコープ変数 `prevUrl` に設定）

**埋め込みパラメータ書式**（`rewriteTo`および`exports`の値に使用可能）:

| 書式 | 意味 |
|---|---|
| ${(バックトラック番号)} | patternの部分マッチ内容。`${0}`:全体、`${n}`:第nキャプチャ |
| ${(変数種別名):(変数名)} | 各変数の値。例: `${session:user.id}`, `${httpMethod}` |
| ${(変数種別名):(変数名):バックトラック番号} | conditionの適用条件に対する部分マッチ内容。例: `${header:Referer:1}` |

**設定例（適用条件付き）**:
```xml
<component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
  <property name="pattern" value="^/$" />
  <property name="conditions">
    <list>
      <value>%{session:user.id} ^\w+$</value>
    </list>
  </property>
  <property name="rewriteTo" value="/action/MenuAction/show" />
</component>
```

<details>
<summary>keywords</summary>

RewriteRule, HttpRequestRewriteRule, ContentPathRewriteRule, pattern, rewriteTo, conditions, exports, 変数種別, 埋め込みパラメータ, サーブレットフォワード, リダイレクト, 適用条件, リライトルール設定

</details>

## 

**ハンドラキュー内の位置**:
HttpResponseHandler → HttpRewriteHandler → ThreadContextHandler_request

**関連するハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | `HttpResponse`内のコンテンツパスの書き換えを行う場合、本ハンドラの**上位**に配置する必要がある。未配置の場合、書き換え後のパスがレスポンスに反映されない。 |
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 書き換えたリクエストパスや各種スコープ変数をもとに:ref:`スレッドコンテキスト<thread_context>`上の属性を導出する場合、本ハンドラの**後続**に配置する必要がある。特にリクエストパスから導出されるリクエストIDは後続ハンドラへの影響が大きい。 |

<details>
<summary>keywords</summary>

HttpResponseHandler, ThreadContextHandler, ハンドラキュー, 関連ハンドラ, コンテンツパス書き換え, ハンドラ配置順

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **リクエストパスに対する書き換え処理**: `requestPathRewriteRules`の`HttpRequestRewriteRule`を先頭から順に評価。条件合致した最初のルールでリクエストパスの書き換えとスコープ変数定義を行う（以降のルールは評価しない）。
2. **1a. サーブレットフォワード**: 書き換え先が`servlet://`で始まる場合、HTTPレスポンスオブジェクトを生成してリターン（後続ハンドラへ移譲しない）。
3. **1b. リダイレクト**: 書き換え先が`redirect://`で始まる場合、HTTPレスポンスオブジェクトを生成してリターン（後続ハンドラへ移譲しない）。
4. **後続ハンドラへの処理移譲**: 書き換え後のHTTPリクエストオブジェクトを後続ハンドラに渡し、HTTPレスポンスオブジェクトを取得する。

**[復路処理]**

5. **コンテンツパスに対する書き換え処理**: 取得したHTTPレスポンスのコンテンツパスに`ContentPathRewriteRule`を順次適用。条件合致した最初のルールでコンテンツパスの書き換えと変数定義を行う（以降のルールは評価しない）。
6. **正常終了**: 書き換え後のHTTPレスポンスオブジェクトをリターン。

**[例外処理]**

- **後続ハンドラ処理中のエラー**: エラーをそのまま再送出して終了。

<details>
<summary>keywords</summary>

ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, requestPathRewriteRules, ContentPathRewriteRule, サーブレットフォワード, リダイレクト

</details>

## 設定項目・拡張ポイント

本ハンドラの設定項目:

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| requestPathRewriteRules | List\<HttpRequestRewriteRule\> | | 空のリスト | HTTPリクエストパスに対する書き換え処理定義リスト |
| contentsPathRewriteRules | List\<ContentPathRewriteRule\> | | 空のリスト | HTTPレスポンスのコンテンツパスに対する書き換え処理定義リスト |

設定例（`HttpRequestRewriteRule`と`ContentPathRewriteRule`の設定内容については[rewrite_rule](#s2)を参照）:

```xml
<component class="nablarch.fw.web.handler.HttpRewriteHandler">
  <property name="requestPathRewriteRules">
    <list>
      <component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
        <property name="pattern" value="^/$" />
        <property name="conditions">
          <list>
            <value>%{session:user.id} ^\S+$</value>
          </list>
        </property>
        <property name="rewriteTo" value="/action/MenuAction/show" />
      </component>
      <component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
        <property name="pattern"   value="^/$" />
        <property name="rewriteTo" value="/action/LoginAction/authenticate" />
      </component>
    </list>
  </property>
  <property name="contentPathRewriteRules">
    <list>
      <component class="nablarch.fw.web.handler.ContentPathRewriteRule">
        <property name="pattern"   value="^.*" />
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

requestPathRewriteRules, contentsPathRewriteRules, HttpRequestRewriteRule, ContentPathRewriteRule, 設定項目, リライト定義

</details>
