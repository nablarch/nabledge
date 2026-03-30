# 要求電文(FWヘッダ)リーダ

## 要求電文(FWヘッダ)リーダ

**クラス名**: `nablarch.fw.messaging.reader.FwHeaderReader`

**読み込むデータの型**: `nablarch.fw.messaging.RequestMessage`

受信電文の [フレームワーク制御ヘッダ](../libraries/libraries-enterprise_messaging.md) を解析し、後続ハンドラ動作に必要な情報を取得するデータリーダ。以下の処理を行う:

1. フレームワーク制御ヘッダの解析: MessageReaderが読み込んだ受信電文のメッセージボディからFW制御ヘッダ部を読み込み、`nablarch.fw.Request` インターフェースを実装した `nablarch.fw.messaging.RequestMessage` オブジェクトを生成して返す。
2. スレッドコンテキスト変数の設定: `requestId` ヘッダと `userId` ヘッダの値を対応するスレッドコンテキスト属性に設定する。
3. 業務データ部フォーマット定義の決定: リクエストIDをもとに決定。デフォルトは受信電文: `(requestId)_RECEIVE.fmt`、応答電文: `(requestId)_SEND.fmt`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| messageReader | DataReader<ReceivedMessage> | ○ | | メッセージリーダ |
| fwHeaderDefinition | FwHeaderDefinition | | StandardFwHeaderDefinition | フレームワーク制御ヘッダ定義 |
| formatFileDir | String | | "format" | 電文フォーマットファイル配置先ディレクトリ論理名 |
| messageFormatFileNamePattern | String | | "%s_RECEIVE" | 要求電文フォーマット定義ファイル名パターン |
| replyMessageFormatFileNamePattern | String | | "%s_SEND" | 応答電文フォーマット定義ファイル名パターン |

Java設定例:
```java
long readTimeout = 15 * 1000; // 15sec

DataReader<RequestMessage> reader = new FwHeaderReader()
                                   .setMessageReader(
                                        new MessageReader()
                                           .setReceiveQueueName("LOCAL.RECEIVE")
                                           .setReadTimeout(readTimeout)
                                    );
```

XML設定例:
```xml
<component
  name  = "dataReader"
  class = "nablarch.fw.messaging.reader.FwHeaderReader">
  <property name = "messageReader">
    <component
      class = "nablarch.fw.messaging.reader.MessageReader">
      <property
        name  = "receiveQueueName"
        value = "LOCAL.RECEIVE"
      />
      <property
        name  = "readTimeout"
        value = "${readTimeout}"
      />
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

FwHeaderReader, nablarch.fw.messaging.reader.FwHeaderReader, RequestMessage, nablarch.fw.messaging.RequestMessage, nablarch.fw.Request, MessageReader, messageReader, fwHeaderDefinition, formatFileDir, messageFormatFileNamePattern, replyMessageFormatFileNamePattern, フレームワーク制御ヘッダ解析, スレッドコンテキスト変数設定, 要求電文フォーマット, メッセージング, requestId, userId, ReceivedMessage, DataReader, FwHeaderDefinition, StandardFwHeaderDefinition

</details>
