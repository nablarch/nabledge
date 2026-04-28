## HTTPリライトハンドラ

**クラス名:** `nablarch.fw.web.handler.HttpRewriteHandler`

-----

-----

### 概要

このハンドラでは、HTTPリクエストオブジェクトおよび、HTTPレスポンスオブジェクトの内容を、
事前に設定されたルール(リライトルール)に従って動的に書き換える機能を提供する。

また、書換えが行われた際に、リクエストパスの部分文字列や、リクエストパラメータ、
HTTPヘッダーのなどの内容を各スコープ上の変数として設定することができる。

> **Note:**
> 本ハンドラは個別プロジェクトでの特殊要件に柔軟に対応する目的で作成されており、
> 標準ハンドラ構成には含まれない。

#### リライトルール

本ハンドラの動作は、本節で解説する [リライトルール](../../component/handlers/handlers-HttpRewriteHandler.md#rewrite-rule) 呼ばれる設定項目によって定義され、
その内容に従って様々な処理を行うことができる。

1つのリライトルールに関する情報は、 [RewriteRule](../../javadoc/nablarch/fw/handler/RewriteRule.html) オブジェクトのプロパティとして保持される。

本ハンドラでは、 HTTPリクエストオブジェクトのリクエストパスおよび、HTTPレスポンスオブジェクトの
[コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) に対する書換えを行うことができる。
設定は、それぞれ [RewriteRule](../../javadoc/nablarch/fw/handler/RewriteRule.html) のサブクラスである  [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) および [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) を用いて行うが、
書換えの対象が異なるだけで、設定項目の内容は同じである。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| 処理対象パターン | pattern | String | 必須指定 書き換え処理が行われるパスのパターンを 正規表現で指定する。 |
| 置換先パス | rewriteTo | String | 任意指定 パスの書き換え処理の内容を表す文字列を 指定する。 省略した場合は置換処理は行わず、現在のパスを そのまま使用する。 |
| 適用条件リスト | conditions | List<String> | 任意指定(デフォルトは空のList) 書き換え処理が行われるための追加条件を指定する。 |
| 変数定義リスト | exports | List<String> | 任意指定(デフォルトは空のList) 書き換え処理が行われた際に、各種スコープ上 (リクエスト、セッション、スレッドコンテキスト等) に定義する変数名とのその内容を指定する。 |

以下では、このリライトルールについて具体例を挙げて解説する。

**例1) 単純置換**

この設定例では、サーブレットコンテキストルートに対するアクセスに対してログインJSP画面を表示させている。

```xml
<!-- サーブレットコンテキストルートへのアクセスに対して、ログインJSPを表示 -->
<component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
  <property name="pattern"   value="^/$" />
  <property name="rewriteTo" value="servlet:///login.jsp" />
</component>
```

処理対象パターンは上記例のようにサーブレットコンテキストを起点とする相対パスへの正規表現として指定する。
( [リクエストハンドラエントリ](../../component/handlers/handlers-RequestHandlerEntry.md) のようなGlob式によるパターン指定とは異なるので注意すること。)

また、置換先パスが **"servlet://** もしくは **redirect://** で始まる場合は、それぞれサーブレットフォーワード、
HTTPリダイレクトによるレスポンスが返されるので、後続のハンドラに処理は移譲されない。

一方、ログイン画面の表示処理が単純なJSPへのフォーワードでは無く、業務アクションでの処理を要する場合は、
以下の様に指定する。

```xml
<!-- サーブレットコンテキストルートへのアクセスに対して、ログインJSPを表示 -->
<component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
  <property name="pattern"   value="^/$" />
  <property name="rewriteTo" value="/action/LoginAction/authenticate" />
</component>
```

この場合は、リクエストパスを、 **"/"** から **/action/LoginAction/authenticate** に書き換えた上で
後続のハンドラに処理を移譲する。

**例2) 適用条件の追加**

書き換えを行う条件は、リクエストパスのパターン以外の方法で判定することができる。
以下の設定例では、セッションスコープ上にユーザIDが設定されていれば、ログイン画面ではなく、
メニュー画面に直接遷移させている。

```xml
<!-- サーブレットコンテキストルートへのアクセスに対して、既にログインが成立していればメニュー画面へ遷移させる。 -->
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

上記例のように、条件の指定は以下の書式で行う。

```bash
%{(変数種別名):(変数名)} (パターン)
```

各リライトルールで使用可能な変数種別は以下の通り。

| 変数種別 | 書式 | 対象 |
|---|---|---|
| セッションスコープ | %{session:(変数名)} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) / [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) |
| リクエストスコープ | %{request:(変数名)} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) / [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) |
| スレッドコンテキスト | %{thread:(変数名)} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) / [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) |
| リクエストパラメータ | %{param:(変数名)} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) |
| HTTPヘッダ | %{header:(ヘッダー名)} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) / [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) |
| HTTPリクエストメソッド | %{httpMethod} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) |
| HTTPバージョン | %{httpVersion} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) |
| 全リクエストパラメータ名 | %{paramNames} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) |
| ステータスコード | %{statusCode} | [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) |

**例3) 変数の設定**

パスの書き換えと同時に、各種スコープ上に変数を定義し、後続のハンドラやJSPから参照することが可能である。
以下の設定例では、HTTPリファラヘッダの値をリクエストスコープ変数 **prevUrl** に設定している。

```xml
<!--リファラヘッダが送信された場合は、リクエストスコープにその値を設定する。-->
<component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
  <!-- 全リクエストを対象とする。 -->
  <property name="pattern" value=".*" />
  <!-- リファラヘッダが定義されていた場合のみ適用する。-->
  <property name="conditions">
    <list>
      <value>%{header:Referer} ^\S+$</value>
    </list>
  </property>
  <!-- リクエストスコープ上の変数 prevUrl に、リファラヘッダの値を設定する。-->
  <property name="exports">
    <list>
      <value>%{request:prevUrl} ${header:Referer}</value>
    </list>
  </property>
</component>
```

HTTPリクエストの書き換えでは、以下のスコープ上に変数を設定することができる。

| 変数スコープ | 書式 | 対象 |
|---|---|---|
| セッションスコープ | %{session:(変数名)} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) / [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) |
| リクエストスコープ | %{request:(変数名)} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) / [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) |
| スレッドコンテキスト | %{thread:(変数名)} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) / [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) |
| ウィンドウスコープ | %{param:(変数名)} | [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) |

また、 **rewriteTo** 属性で指定される置換先パス、および、 **exports** 属性で指定される変数値には、
以下の書式で埋め込みパラメータを使用することができる。

| 書式 | 意味 |
|---|---|
| ${(バックトラック番号)} | pattern属性に指定されたリクエストパス に対する部分マッチ(キャプチャ)の内容。  **${0}** : マッチ内容全体 **${1}** : 第1キャプチャの内容 **${n}** : 第nキャプチャの内容 |
| ${(変数種別名):(変数名)} | 各変数の内容  **${session:user.id}** : セッションスコープ上のuser.id変数の値 **${httpMethod}** : HTTPリクエストメソッド名(GET/POST/PUT...) |
| ${(変数種別名):(変数名):バックトラック番号} | condition属性で指定された適用条件に対する部分マッチ (キャプチャ)の内容。  **${header:Referer:1}** : リファラヘッダに対する第1キャプチャの内容 |

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| HTTPレスポンスハンドラ | nablarch.fw.web.handler.HttpResponseHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容に沿ってレスポンス処理かサーブレットフォーワードのいずれかを行う。 | 既定のエラー画面をレスポンス後、例外を再送出する。ただしサーブレットフォーワード処理中にエラーが発生した場合はログ出力のみを行なう。 |
| HTTPリライトハンドラ | nablarch.fw.web.handler.HttpRewriteHandler | HttpRequest | HttpResponse | HTTPリクエストパスの内容を指定した条件に従って書き換える。 | HTTPレスポンスのコンテンツパスの内容を、指定した条件に従って書き換える。 | - |
| スレッドコンテキスト変数設定ハンドラ(リクエストスレッド) | nablarch.common.handler.threadcontext.ThreadContextHandler_request | Object | Object | 前のループで設定されたスレッドコンテキスト変数をクリアするためここで再初期化する。 | - | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) | 本ハンドラで [HttpResponse](../../javadoc/nablarch/fw/web/HttpResponse.html) 内のコンテンツパスの書き換えを行う場合は、 [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) を本ハンドラの上位に配置しないと、書き換え後のパスが レスポンスに反映されない。 |
| [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) | 本ハンドラで書換えたリクエストパスや各種スコープ変数の内容もとに、 [スレッドコンテキスト](../../component/libraries/libraries-thread-context.md) 上の属性を導出している 場合は、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) を本ハンドラの後続に配置し、本ハンドラで 書換えた内容を反映させる必要がある。 特に、リクエストパスから導出されるリクエストIDは後続ハンドラへの影響が 大きいので留意すること。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (リクエストパスに対する書き換え処理)**

本ハンドラの **requestPathRewriteRules** に設定された [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) の先頭要素から順に
条件が合致するかどうかを確認する。
合致したものがあれば、その内容に従ってリクエストパスの書き換えとスコープに対する変数定義を行う。
どれか1つでも条件に合致すれば、それ以降のルールについては評価されない。

**1a. (サーブレットフォワード)**

**1.** での処理の結果、書き換え先のパスが "servlet://" で開始されるリライトルールが適合した場合、
当該のコンテンツパスによるHTTPレスポンスオブジェクトを生成し、リターンして終了する。
(後続ハンドラに対する処理の移譲は行われない。)

**1b. (リダイレクト)**

**1.** での処理の結果、書き換え先のパスが "redirect://" で開始されるリライトルールが適合した場合、
当該のコンテンツパスによるHTTPレスポンスオブジェクトを生成し、リターンして終了する。
(後続ハンドラに対する処理の移譲は行われない。)

**2. (後続ハンドラへの処理移譲)**

**1.** で書き換え処理を行ったHTTPリクエストオブジェクトを
後続ハンドラに渡して処理を委譲し、その結果となるHTTPレスポンスオブジェクトを取得する。

**[復路での処理]**

**3. (コンテンツパスに対する書き換え処理)**

**2.** で取得したHTTPレスポンスオブジェクトに設定されたコンテンツパスに対して
本ハンドラに設定された [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) を順次適用し、
コンテンツパスの書き換えおよび、変数定義を行う。
リクエストパスの書き換えと同様、どれか1つでも条件に合致すれば、それ以降のルールについては評価されない。

**4. (正常終了)**

**3.** で書き換えを行ったHTTPレスポンスオブジェクトをリターンし、終了する。

**[例外処理]**

**2a. (後続ハンドラ処理中のエラー)**

後続ハンドラの処理中にエラーが発生した場合は、そのまま再送出して終了する。

### 設定項目・拡張ポイント

本ハンドラの挙動は、HTTPリクエストに対する書き換え処理を定義する [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html)
および、HTTPレスポンスに使用するコンテンツパスの書き換え処理を定義する [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) によって
決定される。

本ハンドラにはそれらのリストを設定する。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| リクエストリライト定義 | requestPathRewriteRules | List <HttpRequestRewriteRule> | 任意指定(デフォルトは空のリスト) HTTPリクエストパスに対する書き換え 処理定義のリストを設定する。 |
| コンテンツパスリライト定義 | contentsPathRewriteRules | List <ContentPathRewriteRule> | 任意設定(デフォルトは空のリスト) HTTPレスポンスのコンテンツパスに 対する書き換え処理定義のリストを 設定する。 |

以下は設定例である。
( [HttpRequestRewriteRule](../../javadoc/nablarch/fw/web/handler/HttpRequestRewriteRule.html) と、 [ContentPathRewriteRule](../../javadoc/nablarch/fw/web/handler/ContentPathRewriteRule.html) の設定内容については [リライトルール](../../component/handlers/handlers-HttpRewriteHandler.md#rewrite-rule) を参照すること。)

```xml
<component class="nablarch.fw.web.handler.HttpRewriteHandler">
  <!-- リクエストパスに対するリライトルール -->
  <property name="requestPathRewriteRules">
    <list>
      <!-- サーブレットコンテキストルートへのアクセスに対して、
           既にログインが成立していればメニュー画面へ遷移させる。 -->
      <component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
        <property name="pattern" value="^/$" />
        <property name="conditions">
        <list>
          <value>%{session:user.id} ^\S+$</value>
        </list>
        </property>
        <property name="rewriteTo" value="/action/MenuAction/show" />
      </component>

      <!-- ログインが成立していない場合はログイン画面へ遷移させる。 -->
      <component class="nablarch.fw.web.handler.HttpRequestRewriteRule">
        <property name="pattern"   value="^/$" />
        <property name="rewriteTo" value="/action/LoginAction/authenticate" />
      </component>
    </list>
  </property>

  <!-- レスポンスのコンテンツパスに対するリライトルール -->
  <property name="contentPathRewriteRules">
    <list>

      <!-- ステータスコードが401であった場合はログイン画面に遷移させる -->
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
