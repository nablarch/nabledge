# HTTPリライトハンドラ

## 概要

HTTPのリクエストおよびレスポンスに対して、リクエストパスとコンテンツパス、および変数を書き換える機能を提供するハンドラ。「未ログイン状態の際は強制的にログイン画面に遷移させる」といった、特殊な遷移が必要になった際に使用する。

主な処理:
- リクエストパスを書き換える
- コンテンツパスを書き換える

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.HttpRewriteHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

- :ref:`http_response_handler` より後ろに配置すること。書き換えたコンテンツパスはレスポンスハンドラにより使用されるため。
- :ref:`thread_context_handler` より前に配置すること。スレッドコンテキストに入れられるリクエストパスを書き換えるため。

## 書き換えの設定

`requestPathRewriteRules`（リクエストパス書き換え）または `contentPathRewriteRules`（コンテンツパス書き換え）プロパティに `HttpRequestRewriteRule` または `ContentPathRewriteRule` を設定する。

プロパティ（スーパークラス `RewriteRule` に定義）:

| プロパティ名 | 説明 |
|---|---|
| pattern | 適用する対象のパスのパターン |
| rewriteTo | 書き換え後の文字列 |
| conditions | パス以外の追加の適用条件 |
| exports | 変数の書き換え設定 |

conditions で使用できる変数:

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
        <property name="pattern" value="^/$" />
        <property name="rewriteTo" value="/action/LoginAction/authenticate" />
      </component>
    </list>
  </property>
  <property name="contentPathRewriteRules">
    <list>
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

## 変数に値を設定

`HttpRequestRewriteRule` または `ContentPathRewriteRule` の `exports` プロパティで、リクエストスコープ・セッションスコープ・スレッドコンテキスト・ウィンドウスコープへ変数を設定できる。設定形式: `%{スコープ:変数名} ${値の参照}` をリストで指定。

exports で設定できる変数スコープ:

| 変数スコープ | 書式 | 対象 |
|---|---|---|
| セッションスコープ | %{session:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| リクエストスコープ | %{request:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| スレッドコンテキスト | %{thread:(変数名)} | HttpRequestRewriteRule / ContentPathRewriteRule |
| ウィンドウスコープ | %{param:(変数名)} | HttpRequestRewriteRule |

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
