# 受信電文リーダ

指定されたメッセージキューを監視し、受信した電文オブジェクトを返すデータリーダ。

このデータリーダのread()メソッドが呼ばれると、各リクエストスレッドにバインドされている
メッセージングコンテキストを使用して監視対象キュー上の受信電文を監視し、受信電文オブジェクトを返す。
キューが空であった場合は、電文を受信するか、このリーダに設定されたタイムアウト時間が経過するまでブロックする。
タイムアウト、もしくはこのリーダが既に閉じられていた場合はnullを返す。

このデータリーダは通常のデータリーダとは異なり、明示的に `close()` メソッドを呼び出さない限り終端しない。
(`hasNext()` の結果は常に `true` となる。)

受信電文読み込み時にエラーが発生した場合は、エラー応答電文オブジェクトを実行時例外として送出する。

**クラス名**
nablarch.fw.messaging.reader.MessageReader
**読み込むデータの型**
nablarch.fw.messaging.ReceivedMessage

**設定項目一覧**

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| 受信キュー論理名 | receiveQueueName | String | 必須設定 |
| 受信待機タイムアウト時間(ミリ秒) | readTimeout | long | 任意設定 (デフォルト値: 5000msec) 0以下の値を設定した場合は、メッセージを受信するまで 待機し続ける。 |
| 受信メッセージのフォーマット 定義ファイル名 | formatFileName | String | 任意設定 (受信メッセージにデフォルトフォーマット を設定したい場合のみ使用) |
| 受信メッセージのフォーマット 定義ファイルディレクトリ論理名 | formatFileDirName | String |  |

**使用例**

* データリーダファクトリ内でデータリーダを作成する例

  ```java
  long readTimeout = 15 * 1000; // 15sec
  
  DataReader<ReceivedMessage> reader = new MessageReader()
                                      .setReceiveQueueName("LOCAL.RECEIVE")
                                      .setReadTimeout(readTimeout);
  ```
* DIリポジトリに登録して使用する例

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
