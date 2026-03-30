# HTTPリライトハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.HttpRewriteHandler`

HTTPリクエストオブジェクトおよびHTTPレスポンスオブジェクトの内容を、事前に設定されたルール(リライトルール)に従って動的に書き換える機能を提供する。書換えが行われた際に、リクエストパスの部分文字列、リクエストパラメータ、HTTPヘッダーの内容を各スコープ上の変数として設定できる。

> **注意**: 本ハンドラは個別プロジェクトでの特殊要件に対応する目的で作成されており、標準ハンドラ構成には含まれない。

<details>
<summary>keywords</summary>

HttpRewriteHandler, nablarch.fw.web.handler.HttpRewriteHandler, HTTPリクエスト書き換え, HTTPレスポンス書き換え, リライトルール, スコープ変数設定, 標準ハンドラ構成外

</details>

## リライトルール

`HttpRequestRewriteRule`（リクエストパスの書き換え）と `ContentPathRewriteRule`（コンテンツパスの書き換え）で設定する。両クラスとも設定項目の内容は同じ。

## RewriteRule 設定項目

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| pattern | String | ○ | | 書き換え処理が行われるパスのパターン（正規表現）。サーブレットコンテキストを起点とする相対パスへの正規表現で指定（Glob式ではない） |
| rewriteTo | String | | | パスの書き換え内容。省略時は置換なし、現在のパスをそのまま使用 |
| conditions | List<String> | | 空のList | 書き換え処理の追加条件 |
| exports | List<String> | | 空のList | 書き換え処理が行われた際に各種スコープ上に定義する変数名と内容 |

> **重要**: rewriteTo が `servlet://` で始まる場合はサーブレットフォワード、`redirect://` で始まる場合はHTTPリダイレクトによるレスポンスが返され、後続ハンドラへの処理移譲は行われない。

## 適用条件(conditions)の書式

```
%{(変数種別名):(変数名)} (パターン)
```

使用可能な変数種別:

| 変数種別 | 書式 | 対象 |
|---|---|---|
| セッションスコープ | %{session:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| リクエストスコープ | %{request:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| スレッドコンテキスト | %{thread:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| リクエストパラメータ | %{param:(変数名)} | HttpRequestRewriteRule |
| HTTPヘッダ | %{header:(ヘッダー名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| HTTPリクエストメソッド | %{httpMethod} | HttpRequestRewriteRule |
| HTTPバージョン | %{httpVersion} | HttpRequestRewriteRule |
| 全リクエストパラメータ名 | %{paramNames} | HttpRequestRewriteRule |
| ステータスコード | %{statusCode} | ContentPathRewriteRule |

## 変数定義(exports)のスコープ

| 変数スコープ | 書式 | 対象 |
|---|---|---|
| セッションスコープ | %{session:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| リクエストスコープ | %{request:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| スレッドコンテキスト | %{thread:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| ウィンドウスコープ | %{param:(変数名)} | HttpRequestRewriteRule |

## 埋め込みパラメータ(rewriteTo、exports で使用可)

| 書式 | 意味 |
|---|---|
| ${(バックトラック番号)} | patternに対する部分マッチ内容。${0}=マッチ全体、${1}=第1キャプチャ、${n}=第nキャプチャ |
| ${(変数種別名):(変数名)} | 各変数の内容（例：${session:user.id}、${httpMethod}） |
| ${(変数種別名):(変数名):バックトラック番号} | conditionに対する部分マッチ内容（例：${header:Referer:1}） |

## 設定例

**例1) 単純置換（サーブレットフォワード）**

```xml
<component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
  <property name="pattern"   value="^/$" />
  <property name="rewriteTo" value="servlet:///login.jsp" />
</component>
```

**例2) 適用条件の追加（セッション変数によるルート切り替え）**

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

**例3) 変数の設定（HTTPリファラヘッダをリクエストスコープに設定）**

```xml
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

HttpRequestRewriteRule, ContentPathRewriteRule, RewriteRule, pattern, rewriteTo, conditions, exports, servlet://, redirect://, サーブレットフォワード, HTTPリダイレクト, 適用条件, 変数定義, 埋め込みパラメータ, キャプチャ, セッションスコープ, リクエストスコープ, スレッドコンテキスト, ステータスコード, httpMethod, statusCode, paramNames, httpVersion

</details>

## ハンドラ処理フロー

## 関連するハンドラ

- [HttpResponseHandler](handlers-HttpResponseHandler.md): `HttpResponse` のコンテンツパスの書き換えを行う場合は、本ハンドラの上位に配置する必要がある。配置しないと書き換え後のパスがレスポンスに反映されない。
- [ThreadContextHandler](handlers-ThreadContextHandler.md): 書換えたリクエストパスや各種スコープ変数を元に [スレッドコンテキスト](../libraries/libraries-thread_context.md) 上の属性を導出する場合は、本ハンドラの後続に配置する必要がある。特に、リクエストパスから導出されるリクエストIDは後続ハンドラへの影響が大きいので留意すること。

## 処理フロー

**[往路処理]**

1. リクエストパスに対する書き換え処理: `requestPathRewriteRules` に設定された `HttpRequestRewriteRule` を先頭から順に評価。条件に合致したものがあれば書き換えを実行し、以降のルールは評価しない。
   - 1a. 書き換え先パスが `servlet://` で始まる場合: サーブレットフォワードによるHTTPレスポンスを生成してリターン（後続ハンドラ不実行）。
   - 1b. 書き換え先パスが `redirect://` で始まる場合: HTTPリダイレクトによるHTTPレスポンスを生成してリターン（後続ハンドラ不実行）。
2. 後続ハンドラへの処理移譲: 書き換えを行ったHTTPリクエストオブジェクトを後続ハンドラに渡し、HTTPレスポンスオブジェクトを取得する。

**[復路処理]**

3. コンテンツパスに対する書き換え処理: 取得したHTTPレスポンスオブジェクトのコンテンツパスに対して `ContentPathRewriteRule` を順次適用。条件に合致したものがあれば書き換えを実行し、以降のルールは評価しない。
4. 書き換えを行ったHTTPレスポンスオブジェクトをリターン。

**[例外処理]**

- 後続ハンドラ処理中にエラーが発生した場合はそのまま再送出して終了。

<details>
<summary>keywords</summary>

HttpResponseHandler, ThreadContextHandler, 往路処理, 復路処理, 例外処理, リクエストパス書き換え, コンテンツパス書き換え, ハンドラ配置順序, リクエストID, requestPathRewriteRules, ContentPathRewriteRule

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| requestPathRewriteRules | List<HttpRequestRewriteRule> | | 空のリスト | HTTPリクエストパスに対する書き換え処理定義のリスト |
| contentsPathRewriteRules | List<ContentPathRewriteRule> | | 空のリスト | HTTPレスポンスのコンテンツパスに対する書き換え処理定義のリスト |

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

requestPathRewriteRules, contentsPathRewriteRules, contentPathRewriteRules, HttpRequestRewriteRule, ContentPathRewriteRule, リクエストリライト定義, コンテンツパスリライト定義, nablarch.fw.web.handler.HttpRewriteHandler

</details>
