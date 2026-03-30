# 同期応答メッセージ送信処理

## フォーマット定義ファイル

フォーマット定義ファイルの配置場所と拡張子は `FilePathSetting` クラスのコンポーネント定義により設定される。通常はアーキテクトが設定するため、アプリケーションプログラマは設定不要。

**クラス**: `nablarch.core.util.FilePathSetting`

```xml
<component name="filePathSetting"
         class="nablarch.core.util.FilePathSetting" autowireType="None">
  <property name="basePathSettings">
    <map>
      <entry key="format" value="classpath:web/format" />
    </map>
  </property>
  <property name="fileExtensions">
    <map>
      <entry key="format" value="fmt" />
    </map>
  </property>
</property>
```

フォーマット定義ファイルの命名規約:
- 要求電文: リクエストID + `_SEND`（例: `RM11AC0201_SEND.fmt`）
- 応答電文: リクエストID + `_RECEIVE`（例: `RM11AC0201_RECEIVE.fmt`）

> **警告**: 同期応答送信処理に使用するフォーマット定義ファイル（`～_SEND.fmt`）のレコードタイプ名は `data` 固定である。

### 要求電文フォーマット定義ファイル例

ファイルパス: `web/format/RM11AC0201_SEND.fmt`

```
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    420
record-separator: "\r\n"

[data]
1   dataKbn                     X(1)  "2"   # レコード区分(固定)
2   loginId                     X(20)       # ログインID
22  kanjiName                   N(100)      # 漢字氏名
122 kanaName                    N(100)      # カナ氏名
222 ?filler1                    X(50)       # 空白領域
272 mailAddress                 X(100)      # メールアドレス
372 extensionNumberBuilding     X(2)        # 内線番号（ビル番号）
374 extensionNumberPersonal     X(4)        # 内線番号（個人番号）
378 mobilePhoneNumberAreaCode   X(3)        # 携帯番号（市外）
381 mobilePhoneNumberCityCode   X(4)        # 携帯電話番号(市内)
385 mobilePhoneNumberSbscrCode  X(4)        # 携帯電話番号(加入)
389 ?filler2                    X(32)       # 空白領域
```

### 応答電文フォーマット定義ファイル例

ファイルパス: `web/format/RM11AC0201_RECEIVE.fmt`

```
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    420
record-separator: "\r\n"

[data]
1   dataKbn                     X(1)  "0"   # データ区分(固定)
2   userId                      X(10)       # 採番したユーザID
12  failureCode                 X(20)       # 障害事由コード
32  userInfoId                  X(20)       # 問い合わせID
52  ?filler                     X(369)      # 空白領域
```

<details>
<summary>keywords</summary>

FilePathSetting, フォーマット定義ファイル, 命名規約, _SEND, _RECEIVE, 同期応答メッセージ送信処理, レコードタイプ名, RM11AC0201_SEND.fmt, RM11AC0201_RECEIVE.fmt

</details>

## 同期応答メッセージ送信処理を行うActionクラス

同期応答メッセージ送信処理の実装手順:
1. リクエストを精査しEntityへ変換する
2. EntityからSyncMessageオブジェクトを生成する
3. MessageSenderでメッセージを送信する
4. 応答電文のSyncMessageオブジェクトからデータを取得する

**クラス**: `SyncMessage`, `MessageSender`
**アノテーション**: `@OnError`, `@OnDoubleSubmission`

```java
@OnError(type = ApplicationException.class, path = "forward://RW11AC0201")
@OnDoubleSubmission(path = "forward://RW11AC0201")
public HttpResponse doRW11AC0205(HttpRequest req, ExecutionContext ctx) {

    // 要求電文データレコード作成
    Map<String, Object> dataRecord = new HashMap<String, Object>();
    dataRecord.put("dataKbn", REQUEST_MESSAGE_DATA_KBN);
    dataRecord.put("loginId", systemAccount.getLoginId());
    dataRecord.put("kanjiName", users.getKanjiName());
    dataRecord.put("kanaName", users.getKanaName());
    dataRecord.put("mailAddress", users.getMailAddress());
    dataRecord.put("extensionNumberBuilding", users.getExtensionNumberBuilding());
    dataRecord.put("extensionNumberPersonal", users.getExtensionNumberPersonal());
    dataRecord.put("mobilePhoneNumberAreaCode", users.getMobilePhoneNumberAreaCode());
    dataRecord.put("mobilePhoneNumberCityCode", users.getMobilePhoneNumberCityCode());
    dataRecord.put("mobilePhoneNumberSbscrCode", users.getMobilePhoneNumberSbscrCode());

    // メッセージ送信
    SyncMessage responseMessage
        = MessageSender.sendSync(new SyncMessage("RM11AC0201").addDataRecord(dataRecord));

    // 応答電文からデータ取得
    String userId = (String) responseMessage.getDataRecord().get("userId");
    systemAccount.setUserId(userId);

    return new HttpResponse("/ss11AC/W11AC0203.jsp");
}
```

タイムアウト時は `MessageSendSyncTimeoutException` 例外がスローされるため、必要に応じてキャッチしエラー画面への遷移を行うこと。

<details>
<summary>keywords</summary>

SyncMessage, MessageSender, sendSync, @OnError, @OnDoubleSubmission, MessageSendSyncTimeoutException, 同期応答メッセージ送信, addDataRecord, getDataRecord

</details>
