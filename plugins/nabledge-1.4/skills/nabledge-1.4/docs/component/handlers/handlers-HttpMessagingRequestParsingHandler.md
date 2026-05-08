## HTTPメッセージングリクエスト変換ハンドラ

**クラス名:** `nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler`

-----

-----

### 概要

往路処理において、HTTPリクエストオブジェクト(HttpRequest) を要求電文オブジェクト(RequestMessage) に変換するハンドラ。
HTTPメッセージング実行制御基盤にてHTTPリクエストを処理する場合に使用する。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| Webフロントコントローラ (サーブレットフィルタ) | nablarch.fw.web.servlet.WebFrontController | ServletRequest/Response | - | HttpServletRequest/HttpServletResponseからHTTPリクエストオブジェクトを作成し、ハンドラキューに処理を委譲する。 | (Webコンテナ側に制御を戻す。) | このハンドラでは例外およびエラーの捕捉は行なわず、そのまま送出する。 | - |
| HTTPアクセスログハンドラ | nablarch.common.web.handler.HttpAccessLogHandler | HttpRequest | HttpResponse | HTTPリクエストの内容についてログに出力する。 | 送信するHTTPレスポンスの内容についてログに出力する。 | 送信するHTTPレスポンスの内容についてログに出力する。 | - |
| HTTPメッセージングリクエスト変換ハンドラ | nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler | HttpRequest | Object | HTTPリクエストデータを解析し、後続ハンドラの引数（RequestMessage）のレコードとして設定する。 | - | - | - |
| 再送電文制御ハンドラ | nablarch.fw.messaging.handler.MessageResendHandler | RequestMessage | ResponseMessage | 再送要求に対し、以前応答した電文が保存されていれば、その内容をリターンする。(後続ハンドラは実行しない) | 業務トランザクションが正常終了(コミット)された場合のみ電文を保存する | - | - |
| 同期応答電文処理用業務アクションハンドラ | nablarch.fw.action.MessagingAction | RequestMessage | ResponseMessage | 要求電文の内容をもとに業務処理を実行する。 | 業務処理の結果と要求電文の内容から応答電文の内容を作成して返却する。 | - | トランザクションロールバック時にエラー応答電文を作成する。 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [HTTPアクセスログハンドラ](../../component/handlers/handlers-HttpAccessLogHandler.md) | [HTTPアクセスログハンドラ](../../component/handlers/handlers-HttpAccessLogHandler.md) のようなHTTPリクエストオブジェクトに直接依存するハンドラ は本ハンドラよりも上位に配置すること。 |
| [再送電文制御ハンドラ](../../component/handlers/handlers-MessageResendHandler.md) | [再送電文制御ハンドラ](../../component/handlers/handlers-MessageResendHandler.md) や [同期応答電文送信処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-MessagingAction.md) のような要求電文オブジェクトに 直接依存するハンドラは本ハンドラの後続に配置すること。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (リクエストボディの解析)**

HTTPリクエストオブジェクトのメッセージボディを読み込み、リクエストデータの解析を行う。
解析結果を格納した [RequestMessage](../../javadoc/nablarch/fw/messaging/RequestMessage.html) を作成する。

**2. (後続ハンドラに対する処理委譲)**

**1.** で作成した [RequestMessage](../../javadoc/nablarch/fw/messaging/RequestMessage.html) および実行コンテキストを引数として後続のハンドラに処理を委譲し、
その結果を取得する。

**[復路処理]**

**3. (正常終了)**

2.で取得した処理結果をリターンし終了する。

**[例外処理]**

**1a. (リクエストの不備による要求電文構築時のエラー)**

**1.** の処理時に MessagingException および InvalidDataFormatException が発生した場合は、
リクエスト内容の不備が原因とみなし、INFOレベルのログを出力後、
元例外をネストしたHTTPエラーレスポンス(ステータスコード400) を送出して終了する。

**1b. (要求電文構築時のエラー)**

**1.** の処理中に上記以外の例外が発生した場合、本ハンドラではなにもせずにそのまま送出して終了する。

**2a. (後続ハンドラでのエラー)**

**2.** の処理中に例外が送出された場合、本ハンドラではなにもせずにそのまま再送出して終了する。

### 設定項目・拡張ポイント

本ハンドラの設定値は、以下の通りである。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| リクエストボディサイズ上限 | bodyLengthLimit | int | 任意設定。(単位:バイト) リクエストのボディストリームから読み込む最大容量 デフォルトは無制限。 |

**基本設定**

以下は基本的な設定ファイルの記述例である。

```xml
<!-- HTTPメッセージングリクエスト変換ハンドラ -->
<component class="nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler">
     <property name="bodyLengthLimit" value="${bodyLengthLimit}" />
</component>
```

デフォルトでは読み込んだデータを構造化データとして取り扱うが、フレームワーク制御ヘッダに対する
各項目の読み取りおよび設定は行わない。

フレームワーク制御ヘッダに対する各項目を設定する場合、StructuredFwHeaderDefinitionコンポーネントを登録し、
プロパティ"FwHeaderKeys"に電文よりヘッダ情報を取得する際のキー情報を定義する。

```xml
<!-- HTTPメッセージングリクエスト変換ハンドラ -->
<component class="nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler">
  <property name="fwHeaderDefinition" ref="fwHeaderDefinition"/>
</component>

<component name = "fwHeaderDefinition"
  class = "nablarch.fw.messaging.reader.StructuredFwHeaderDefinition">
  <property name = "FwHeaderKeys">
    <map>
      <entry key="userId"     value="_nbctlhdr.userId"/>
      <entry key="resendFlag" value="_nbctlhdr.resendFlag"/>
      <entry key="statusCode" value="_nbctlhdr.statusCode"/>
    </map>
  </property>
</component>
```

ヘッダ情報として以下の情報を、フィールド名をkey、電文上の位置をvalueとして指定する。
電文上の位置は構造化データをMapに変換した後のキー情報を記述する。
構造化データからMapに変換される際のキー情報については  [汎用データフォーマット機能](../../component/libraries/libraries-record-format.md) を参照。

| フレームワーク制御ヘッダ | フィールド名 |
|---|---|
| ユーザID | userId |
| 再送要求フラグ | resendFlag |
| ステータスコード | statusCode |

また、固定長データや可変長データを取り扱う場合は標準フレームワーク制御ヘッダ定義を指定する。

```xml
<component
  name = "fwHeaderDefinition"
  class = "nablarch.fw.messaging.StandardFwHeaderDefinition">
</component>
```
