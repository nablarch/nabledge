## HTTPエラー制御ハンドラ

**クラス名:** `nablarch.fw.handler.HttpErrorHandler`

-----

-----

### 概要

本ハンドラでは、後続ハンドラの処理中に送出された例外を捕捉し、
障害ログを出力した後、HTTPエラーレスポンスオブジェクトを作成して返す。

また、後続ハンドラの処理が正常終了し、その処理結果に遷移先画面か応答内容のどちらもも設定されていない場合は、
既定のエラー画面を遷移先として指定する。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| HTTPレスポンスハンドラ | nablarch.fw.web.handler.HttpResponseHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容に沿ってレスポンス処理かサーブレットフォーワードのいずれかを行う。 | 既定のエラー画面をレスポンス後、例外を再送出する。ただしサーブレットフォーワード処理中にエラーが発生した場合はログ出力のみを行なう。 |
| HTTPエラー制御ハンドラ | nablarch.fw.web.handler.HttpErrorHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容が設定されていない場合は、ステータスコードに応じたデフォルトページを遷移先に設定する。 | 送出されたエラーに応じた遷移先のHTTPレスポンスオブジェクトを返却する。送出されたエラーはリクエストスコープに設定される。 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) | 本ハンドラでは捕捉した例外に対するHTTPレスポンスオブジェクトを作成するものの、 レスポンス処理自体は [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) 側で行われるため、 このハンドラを本ハンドラの上位に配置する必要がある。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (後続ハンドラへの処理委譲)**

往路では本ハンドラは特段の処理を行なわない。
引数をそのまま後続ハンドラに渡して処理を委譲し、その結果としてHTTPレスポンスオブジェクトを取得する。

**[復路処理]**

**2. (レスポンスボディ内容の確認)**

HTTPレスポンスオブジェクトにレスポンスボディとして出力する内容が設定されているかどうかを確認する。
以下の条件のいずれかが満たされていれば、 HTTPレスポンスオブジェクトを返却し、処理を終了する。

1. コンテンツパスが設定されている。
2. `HttpResponse#setInputStream()` により、レスポンスボディとして出力する内容が `InputStream` で与えられている。
3. `HttpResponse#write()` により、レスポンスボディとして出力する内容がHTTPレスポンスオブジェクト内にバッファリングされている。

**2a. (ステータスコード毎のデフォルトページを設定)**

HTTPレスポンスオブジェクトにレスポンスボディとして出力する内容が設定されていなかった場合は、
`HttpResponse#getStatusCode()` の値に合致するデフォルトページへのコンテンツパスを設定してリターンする。
デフォルトページは本ハンドラの設定で任意のコンテンツパスを指定することができる。
設定を行なっていない場合のデフォルトページは次のようになる。

| ステータスコード | コンテンツパス |
|---|---|
| 404 | servlet:///jsp/notFound.jsp |
| 401 | servlet:///jsp/unauthorized.jsp |
| 3.. (300～399のいずれか) | servlet:///jsp/redirecting.jsp |
| 4.. (400～499 ただし 401/404を除く) | servlet:///jsp/userError.jsp |
| 5.. (500～599のいずれか) | servlet:///jsp/systemError.jsp |

**[例外処理]**

**1.a (後続ハンドラ処理中のエラー)**

後続ハンドラ実行中に例外が送出された場合、その型に従って以下のように処理する。
なお、いずれの場合でも、送出された例外をリクエストコンテキストにキー名 **nablarch_error** で設定する。

| 捕捉した例外クラス | ログ出力 | 処理内容 |
|---|---|---|
| nablarch.fw.NoMoreHandlerException | Info | ハンドラキューが空の状態で、後続ハンドラに処理委譲を行なった場合に送出される。 ステータスコード404のデフォルトページを設定したHTTPレスポンスオブジェクトを返却する。 |
| nablarch.fw.web.HttpErrorResponse | なし | エラーレスポンス内容を指定し、エラー終了する際に送出するエラー。 この例外に指定されているHTTPレスポンスオブジェクトを返却する。 |
| nablarch.fw.Result.Error | なし | 例外オブジェクトのステータスコードに対応するデフォルトページを遷移先とする HTTPレスポンスオブジェクトを返却する。  > **Note:** > writeFailureLogPatternプロパティで指定された正規表現にマッチするステータスコードを > もつErrorオブジェクトの場合には、障害ログを出力する。 |
| java.lang.StackOverflowError | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスオブジェクトを返却する。 |
| java.lang.ThreadDeath | なし | 本ハンドラでは何もせずに捕捉した例外を再送出する。 (ログ出力は [グローバルエラーハンドラ](../../component/handlers/handlers-GlobalErrorHandler.md) で行われる。) |
| java.lang.VirtualMachineError (StackOverFlowErrorを除く) | なし | 本ハンドラでは何もせずに捕捉した例外を再送出する。 (ログ出力は [グローバルエラーハンドラ](../../component/handlers/handlers-GlobalErrorHandler.md) で行われる。) |
| (上記以外の実行時例外、エラー) | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスオブジェクトを返却する。 |

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| ステータスコード毎のデフォルト遷移先 | defaultPages | Map<String, String> | 任意指定 (デフォルト設定はハンドラ処理フロー参照) |
| Result.Error発生時の障害通知ログ出力対象のステータスコード | writeFailureLogPattern | String | 任意指定  指定する場合は、正規表現で指定する。 例えば、全てのステータスコードで障害通知ログを 出力する場合には、 *「.*」* と指定する。  設定を省略した場合は、500～599(503(サービス閉塞中) を除く)が、障害通知ログの出力対象となる。 |

**標準設定**

以下は標準設定におけるDI設定の例である。

```xml
<!-- HTTPレスポンスハンドラ -->
<component class="nablarch.fw.web.handler.HttpResponseHandler" />
```

**ステータスコード毎のデフォルト遷移先を設定する場合**

以下のように設定することで、デフォルトの遷移先を変更することができる。
対象となるステータスコードに **"."** を含めることで、ワイルドカード指定することができる。
ただし、1つのステータスコードに対して複数の遷移先がマッチする場合は、
ワイルドカードの使用桁がより少ない遷移先を優先する。

たとえば、以下の例では、ステータスコード404に対応するデフォルト遷移先は、
`"/USER_ERROR.jsp"` ではなく、 `"/NOT_FOUND.jsp"` となる。

```xml
<!-- エラーハンドラ -->
<component class="nablarch.fw.web.handler.HttpErrorHandler">
    <!-- ステータスコード毎のデフォルト遷移先JSPを設定する。-->
    <property name="defaultPages">
        <map>
        <entry key="4.." value="/USER_ERROR.jsp" />
        <entry key="404" value="/NOT_FOUND.jsp" />
        <entry key="5.." value="/ERROR.jsp" />
        <entry key="503" value="/NOT_IN_SERVICE.jsp" />
        </map>
    </property>
</component>
```

**Result.Error発生時に障害通知ログを出力するステータスコード値を変更する場合**

以下のように設定することで、障害通知ログを出力するステータスコード値を変更することができる。

```xml
<!-- エラーハンドラ -->
<component class="nablarch.fw.web.handler.HttpErrorHandler">
    <!-- 500～599のステータスコードは全て障害通知ログを出力する場合 -->
    <property name="writeFailureLogPattern" value="5[0-9][0-9]" />
</component>
```
