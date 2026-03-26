# 要求電文(FWヘッダ)リーダ

## 要求電文(FWヘッダ)リーダ

**クラス名**: `nablarch.fw.messaging.reader.FwHeaderReader`

**読み込むデータの型**: `nablarch.fw.messaging.RequestMessage`

受信電文の [フレームワーク制御ヘッダ](../libraries/libraries-enterprise_messaging_mom.md) を解析し、後続ハンドラの動作に必要な情報を取得するデータリーダ。以下の処理を行う:

1. [message_model](../libraries/libraries-enterprise_messaging_mom.md) を解析し、`nablarch.fw.messaging.RequestMessage` オブジェクトを生成して返す
2. `requestId` ヘッダと `userId` ヘッダの値をスレッドコンテキスト属性に設定する
3. リクエストIDをもとに業務データ部のフォーマット定義を決定する（デフォルト: `{requestId}_RECEIVE.fmt` / `{requestId}_SEND.fmt`）

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| messageReader | DataReader<ReceivedMessage> | ○ | | メッセージリーダ |
| fwHeaderDefinition | FwHeaderDefinition | | StandardFwHeaderDefinition | フレームワーク制御ヘッダ定義 |
| formatFileDir | String | | "format" | 電文フォーマットファイル配置先ディレクトリ論理名 |
| messageFormatFileNamePattern | String | | "%s_RECEIVE" | 要求電文フォーマット定義ファイル名パターン |
| replyMessageFormatFileNamePattern | String | | "%s_SEND" | 応答電文フォーマット定義ファイル名パターン |

**使用例 (Java)**:
```java
long readTimeout = 15 * 1000; // 15sec

DataReader<RequestMessage> reader = new FwHeaderReader()
                                   .setMessageReader(
                                        new MessageReader()
                                           .setReceiveQueueName("LOCAL.RECEIVE")
                                           .setReadTimeout(readTimeout)
                                    );
```

**使用例 (XML)**:
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

FwHeaderReader, nablarch.fw.messaging.reader.FwHeaderReader, RequestMessage, nablarch.fw.messaging.RequestMessage, MessageReader, messageReader, fwHeaderDefinition, formatFileDir, messageFormatFileNamePattern, replyMessageFormatFileNamePattern, フレームワーク制御ヘッダ解析, 要求電文リーダ, スレッドコンテキスト変数設定, 受信電文フォーマット, FwHeaderDefinition, StandardFwHeaderDefinition, ReceivedMessage, DataReader

</details>
