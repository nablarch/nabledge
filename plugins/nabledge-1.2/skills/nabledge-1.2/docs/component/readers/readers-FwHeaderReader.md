# 要求電文(FWヘッダ)リーダ

受信電文の [フレームワーク制御ヘッダ](../../component/libraries/libraries-enterprise-messaging.md#message-model) の解析を行い、後続のハンドラの動作に必要となる情報を取得するデータリーダ。
具体的には、以下の処理を行なう。

1. フレームワーク制御ヘッダの解析

  MessageReaderが読み込んだ受信電文のメッセージボディからフレームワーク制御ヘッダ部を読み込み、
  `nablarch.fw.Request` インターフェースを実装した `nablarch.fw.messaging.RequestMessage` オブジェクトを生成して返す。
2. スレッドコンテキスト変数の設定

  フレームワークヘッダの値のうち以下のヘッダの値を、対応するスレッドコンテキスト属性の値として設定する。

  * requestId ヘッダ
  * userId ヘッダ
3. 業務データ部のフォーマット定義を決定

  リクエストIDをもとに、業務データ部のフォーマット定義を決定する。
  デフォルトでは以下のフォーマット定義ファイルを使用する。

  受信電文フォーマット:

  ```
  (requestIdヘッダ値) + "_RECEIVE.fmt"
  ```

  応答電文フォーマット:

  ```
  (requestIdヘッダ値) + "_SEND.fmt"
  ```

**クラス名**

nablarch.fw.messaging.reader.FwHeaderReader

**読み込むデータの型**

nablarch.fw.messaging.RequestMessage

**設定項目一覧**

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| メッセージリーダ | messageReader | DataReader<ReceivedMessage> | 必須設定 |
| フレームワーク制御ヘッダ定義 | fwHeaderDefinition | FwHeaderDefinition | 任意設定 (デフォルトは StandardFwHeaderDefinition) |
| 電文フォーマットファイル配置先 ディレクトリ論理名 | formatFileDir | String | 任意設定 (デフォルトは "format") |
| 要求電文フォーマット定義ファイル名 パターン | messageFormatFileNamePattern | String | 任意設定 (デフォルトは "%s_RECEIVE") |
| 応答電文フォーマット定義ファイル名 パターン | replyMessageFormatFileNamePattern | String | 任意設定 (デフォルトは "%s_SEND") |

**使用例**

* データリーダファクトリ内でデータリーダを作成する例

  ```java
  long readTimeout = 15 * 1000; // 15sec
  
  DataReader<RequestMessage> reader = new FwHeaderReader()
                                     .setMessageReader(
                                          new MessageReader()
                                             .setReceiveQueueName("LOCAL.RECEIVE")
                                             .setReadTimeout(readTimeout)
                                      );
  ```
* DIリポジトリに登録して使用する例

  ```xml
  <component
    name  = "dataReader"
    class = "nablarch.fw.messaging.reader.FwHeaderReader">
    <!-- メッセージリーダ定義 -->
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
