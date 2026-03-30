# HTTPリライトハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.HttpRewriteHandler`

HTTPリクエスト・レスポンスオブジェクトの内容をリライトルール（事前設定）に従って動的に書き換える。書換え時に、リクエストパスの部分文字列・リクエストパラメータ・HTTPヘッダーなどを各スコープ上の変数として設定可能。

> **注意**: 本ハンドラは個別プロジェクトの特殊要件対応を目的として作成されており、標準ハンドラ構成には含まれない。

<details>
<summary>keywords</summary>

HttpRewriteHandler, nablarch.fw.web.handler.HttpRewriteHandler, HTTPリライト, HTTPリクエスト書き換え, HTTPレスポンス書き換え, 標準ハンドラ構成外

</details>

## リライトルール

リライトルールは `RewriteRule` のサブクラスである `HttpRequestRewriteRule`（リクエストパス対象）および `ContentPathRewriteRule`（コンテンツパス対象）を用いて設定する。書換え対象が異なるだけで設定項目の内容は同じ。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| pattern | String | ○ | | 書き換え処理が行われるパスのパターン（正規表現）。サーブレットコンテキストを起点とする相対パスへの正規表現で指定する（[RequestHandlerEntry](handlers-RequestHandlerEntry.md) のGlob式とは異なる）。 |
| rewriteTo | String | | | パスの書き換え先文字列。省略時は現在のパスをそのまま使用。`servlet://`で始まる場合はサーブレットフォワード、`redirect://`で始まる場合はHTTPリダイレクトでレスポンスを返し後続ハンドラへの移譲は行わない。 |
| conditions | List\<String\> | | 空のList | 書き換えを行うための追加条件。書式: `%{(変数種別名):(変数名)} (パターン)` |
| exports | List\<String\> | | 空のList | 書き換え時に各スコープ上に定義する変数名とその内容。 |

**conditionsで使用可能な変数種別**:

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

**exportsで使用可能な変数スコープ**:

| 変数スコープ | 書式 | 対象 |
|---|---|---|
| セッションスコープ | %{session:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| リクエストスコープ | %{request:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| スレッドコンテキスト | %{thread:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| ウィンドウスコープ | %{param:(変数名)} | HttpRequestRewriteRule |

**rewriteTo・exports内で使用可能な埋め込みパラメータ書式**:

| 書式 | 意味 |
|---|---|
| ${(バックトラック番号)} | patternに指定されたリクエストパスへの部分マッチ（キャプチャ）の内容。${0}=マッチ全体、${1}=第1キャプチャ、${n}=第nキャプチャ |
| ${(変数種別名):(変数名)} | 各変数の内容。例: ${session:user.id}、${httpMethod} |
| ${(変数種別名):(変数名):バックトラック番号} | conditionの適用条件に対する部分マッチ（キャプチャ）の内容。例: ${header:Referer:1} |

**設定例（単純置換 - servlet://でサーブレットフォワード）**:
```xml
<component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
  <property name="pattern"   value="^/$" />
  <property name="rewriteTo" value="servlet:///login.jsp" />
</component>
```

**設定例（適用条件の追加 - セッション変数による条件判定）**:
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

**設定例（変数の設定 - リファラヘッダをリクエストスコープ変数に設定）**:
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

HttpRequestRewriteRule, ContentPathRewriteRule, RewriteRule, pattern, rewriteTo, conditions, exports, リライトルール, リクエストパス書き換え, 変数スコープ設定, servlet://, redirect://, 埋め込みパラメータ, バックトラック番号

</details>

## ハンドラ処理フロー

**関連するハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | コンテンツパスの書き換えを行う場合は、HttpResponseHandlerを本ハンドラの上位に配置すること。未配置の場合、書き換え後のパスがレスポンスに反映されない。 |
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 書換えたリクエストパスや各種スコープ変数をもとにスレッドコンテキスト上の属性を導出している場合は、ThreadContextHandlerを本ハンドラの後続に配置すること。特に、リクエストパスから導出されるリクエストIDは後続ハンドラへの影響が大きい。 |

**[往路処理]**

1. requestPathRewriteRulesに設定されたHttpRequestRewriteRuleを先頭から順に評価し、条件合致時にリクエストパスの書き換えとスコープ変数定義を行う。1つでも合致すれば以降のルールは評価しない。
   - 書き換え先が`servlet://`で始まる場合: HTTPレスポンスオブジェクトを生成してリターン（後続ハンドラへの移譲なし）
   - 書き換え先が`redirect://`で始まる場合: HTTPレスポンスオブジェクトを生成してリターン（後続ハンドラへの移譲なし）
2. 書き換えたHTTPリクエストオブジェクトを後続ハンドラに渡して処理を委譲し、HTTPレスポンスオブジェクトを取得する。

**[復路処理]**

3. 取得したHTTPレスポンスオブジェクトのコンテンツパスにContentPathRewriteRuleを順次適用し、コンテンツパスの書き換えと変数定義を行う。1つでも合致すれば以降のルールは評価しない。
4. 書き換えたHTTPレスポンスオブジェクトをリターンして終了。

**[例外処理]**

2a. 後続ハンドラ処理中にエラーが発生した場合はそのまま再送出して終了する。

<details>
<summary>keywords</summary>

HttpResponseHandler, ThreadContextHandler, ハンドラ処理フロー, 往路処理, 復路処理, コンテンツパス書き換え, サーブレットフォワード, リダイレクト

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| requestPathRewriteRules | List\<HttpRequestRewriteRule\> | | 空のリスト | HTTPリクエストパスに対する書き換え処理定義のリスト |
| contentsPathRewriteRules | List\<ContentPathRewriteRule\> | | 空のリスト | HTTPレスポンスのコンテンツパスに対する書き換え処理定義のリスト |

HttpRequestRewriteRule・ContentPathRewriteRuleの設定内容は [rewrite_rule](#s1) 参照。

```xml
<component class="nablarch.fw.web.handler.HttpRewriteHandler">
  <property name="requestPathRewriteRules">
    <list>
      <!-- ログイン済みならメニュー画面へ -->
      <component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
        <property name="pattern" value="^/$" />
        <property name="conditions">
          <list>
            <value>%{session:user.id} ^\S+$</value>
          </list>
        </property>
        <property name="rewriteTo" value="/action/MenuAction/show" />
      </component>
      <!-- 未ログインならログイン画面へ -->
      <component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
        <property name="pattern"   value="^/$" />
        <property name="rewriteTo" value="/action/LoginAction/authenticate" />
      </component>
    </list>
  </property>
  <property name="contentPathRewriteRules">
    <list>
      <!-- ステータスコード401の場合はログイン画面へリダイレクト -->
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

requestPathRewriteRules, contentsPathRewriteRules, contentPathRewriteRules, HttpRequestRewriteRule, ContentPathRewriteRule, 設定項目, ハンドラ設定例

</details>
