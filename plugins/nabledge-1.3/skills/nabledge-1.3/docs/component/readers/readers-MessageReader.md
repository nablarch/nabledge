# 受信電文リーダ

## 受信電文リーダ

**クラス名**: `nablarch.fw.messaging.reader.MessageReader`

**読み込むデータの型**: `nablarch.fw.messaging.ReceivedMessage`

`read()` 呼び出し時、監視対象キューの受信電文を待機する。キューが空の場合は電文受信またはタイムアウト時間経過までブロックする。タイムアウトまたはリーダが閉じられている場合は `null` を返す。

> **重要**: `hasNext()` は常に `true` を返す。明示的に `close()` を呼び出さない限り終端しない。

受信電文読み込み時にエラーが発生した場合は、エラー応答電文オブジェクトを実行時例外として送出する。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| receiveQueueName | String | ○ | | 受信キュー論理名 |
| readTimeout | long | | 5000 | 受信待機タイムアウト時間(ミリ秒)。0以下を設定した場合はメッセージ受信まで待機し続ける |
| formatFileName | String | | | 受信メッセージのフォーマット定義ファイル名（デフォルトフォーマットを設定したい場合のみ使用） |
| formatFileDirName | String | | | 受信メッセージのフォーマット定義ファイルディレクトリ論理名 |

Java例:
```java
long readTimeout = 15 * 1000; // 15sec

DataReader<ReceivedMessage> reader = new MessageReader()
                                    .setReceiveQueueName("LOCAL.RECEIVE")
                                    .setReadTimeout(readTimeout);
```

XML例:
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

MessageReader, nablarch.fw.messaging.reader.MessageReader, ReceivedMessage, nablarch.fw.messaging.ReceivedMessage, receiveQueueName, readTimeout, formatFileName, formatFileDirName, 受信電文リーダ, メッセージキュー監視, 受信待機タイムアウト, DIリポジトリ登録

</details>
