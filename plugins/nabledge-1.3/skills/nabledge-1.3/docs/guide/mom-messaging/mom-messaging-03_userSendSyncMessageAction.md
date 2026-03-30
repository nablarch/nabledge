# 同期応答メッセージ送信処理

## アプリケーションプログラマが実装する成果物

アプリケーションプログラマが作成する成果物:

- 要求電文および応答電文のフォーマット定義ファイル
- 同期応答メッセージ送信処理を行うActionクラス

<details>
<summary>keywords</summary>

成果物, フォーマット定義ファイル, Actionクラス, 同期応答メッセージ送信処理

</details>

## フォーマット定義ファイル

フォーマット定義ファイルの配置場所と拡張子は `FilePathSetting` クラスのコンポーネント定義により設定される（通常はアーキテクトが設定）。

**命名規約**:
- 要求電文: リクエストID + `_SEND`（例: `RM11AC0201_SEND.fmt`）
- 応答電文: リクエストID + `_RECEIVE`（例: `RM11AC0201_RECEIVE.fmt`）

**クラス**: `nablarch.core.util.FilePathSetting`

```xml
<component name="filePathSetting" class="nablarch.core.util.FilePathSetting" autowireType="None">
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

> **警告**: 同期応答送信処理に使用するフォーマット定義ファイル（`～_SEND.fmt`）のレコードタイプ名は `data` 固定である。

**要求電文フォーマット定義ファイル例** (`RM11AC0201_SEND.fmt`):
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

**応答電文フォーマット定義ファイル例** (`RM11AC0201_RECEIVE.fmt`):
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

FilePathSetting, フォーマット定義ファイル命名規約, _SEND, _RECEIVE, レコードタイプ名 data 固定, 固定長フォーマット, RM11AC0201_SEND.fmt, RM11AC0201_RECEIVE.fmt

</details>

## 同期応答メッセージ送信処理を行うActionクラス

同期応答メッセージ送信処理の実装手順:

1. リクエストを精査しEntityへ変換する
2. EntityからSyncMessageオブジェクトを生成する
3. `MessageSender.sendSync()` でメッセージを送信する
4. 応答電文の `SyncMessage` オブジェクトからデータを取得する

**クラス**: `SyncMessage`, `MessageSender`
**アノテーション**: `@OnError`, `@OnDoubleSubmission`

```java
@OnError(type = ApplicationException.class, path = "forward://RW11AC0201")
@OnDoubleSubmission(path = "forward://RW11AC0201")
public HttpResponse doRW11AC0205(HttpRequest req, ExecutionContext ctx) {

    // ①精査とエンティティ生成
    W11AC02Form form = validateForSendUser(req);
    SystemAccountEntity systemAccount = form.getSystemAccount();
    UsersEntity users = form.getUsers();

    // ②要求電文のデータレコードの作成
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

    // ③要求電文の送信
    SyncMessage responseMessage
        = MessageSender.sendSync(new SyncMessage("RM11AC0201").addDataRecord(dataRecord));

    // ④応答電文からデータ取得
    String userId = (String) responseMessage.getDataRecord().get("userId");
    systemAccount.setUserId(userId); // 採番されたユーザIDの設定

    // 引き継ぎ項目を格納
    W11AC01SearchForm successionForm = new W11AC01SearchForm();
    successionForm.setSystemAccount(systemAccount);
    ctx.setRequestScopedVar("11AC_W11AC01", successionForm);

    return new HttpResponse("/ss11AC/W11AC0203.jsp");
}
```

タイムアウト時は `MessageSendSyncTimeoutException` がスローされるので、必要に応じてキャッチしてエラー画面へ遷移させること。

<details>
<summary>keywords</summary>

SyncMessage, MessageSender, sendSync, MessageSendSyncTimeoutException, @OnError, @OnDoubleSubmission, 同期応答メッセージ送信, タイムアウト, setRequestScopedVar, ExecutionContext, 引き継ぎ項目

</details>
