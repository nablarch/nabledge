# 受信電文リーダ

## 受信電文リーダ

**クラス名**: `nablarch.fw.messaging.reader.MessageReader`

**読み込むデータの型**: `nablarch.fw.messaging.ReceivedMessage`

指定されたメッセージキューを監視し、受信した電文オブジェクトを返すデータリーダ。`read()`メソッド呼び出し時、各リクエストスレッドにバインドされているメッセージングコンテキストを使用して受信電文を監視する。

- キューが空の場合、電文受信またはタイムアウト時間経過までブロックする
- タイムアウト、またはリーダが既に閉じられていた場合は`null`を返す
- `hasNext()`は常に`true`（明示的に`close()`を呼び出さない限り終端しない）
- 受信電文読み込み時にエラーが発生した場合、エラー応答電文オブジェクトを実行時例外として送出する

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| receiveQueueName | String | ○ | | 受信キュー論理名 |
| readTimeout | long | | 5000 | 受信待機タイムアウト時間(ミリ秒)。0以下の値を設定した場合はメッセージを受信するまで待機し続ける |
| formatFileName | String | | | 受信メッセージのフォーマット定義ファイル名（デフォルトフォーマットを設定したい場合のみ使用） |
| formatFileDirName | String | | | 受信メッセージのフォーマット定義ファイルディレクトリ論理名（受信メッセージにデフォルトフォーマットを設定したい場合のみ使用） |

**使用例（Java）**:
```java
long readTimeout = 15 * 1000; // 15sec

DataReader<ReceivedMessage> reader = new MessageReader()
                                    .setReceiveQueueName("LOCAL.RECEIVE")
                                    .setReadTimeout(readTimeout);
```

**使用例（XML）**:
```xml
<component
  class = "nablarch.fw.messaging.reader.MessageReader"
  name  = "dataReader">
  <property
    name  = "receiveQueueName"
    value = "LOCAL.RECEIVE"
  />
  <property
    name  = "readTimeout"
    value = "${readTimeout}"
  />
</component>
```

<details>
<summary>keywords</summary>

MessageReader, nablarch.fw.messaging.reader.MessageReader, ReceivedMessage, nablarch.fw.messaging.ReceivedMessage, receiveQueueName, readTimeout, formatFileName, formatFileDirName, 受信電文リーダ, メッセージキュー監視, 受信電文, タイムアウト制御

</details>
