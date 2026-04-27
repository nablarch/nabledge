# 同期応答メッセージ送信処理

[ユーザ情報登録サービス](../../guide/mom-messaging/mom-messaging-01-userSendSyncMessageSpec.md) を例に、同期応答メッセージ送信処理の実装方法を説明する。

![userSendSyncMessage.png](../../../knowledge/assets/mom-messaging-03-userSendSyncMessageAction/userSendSyncMessage.png)

## アプリケーションプログラマが実装する成果物

アプリケーションプログラマが作成する成果物は以下のとおりである。

* 要求電文および応答電文のフォーマット定義ファイル
* 同期応答メッセージ送信処理を行うActionクラス

## フォーマット定義ファイル

フォーマット定義ファイルの配置場所と拡張子は、下記設定例のように、FilePathSettingクラスのコンポーネント定義により設定される。
通常、この設定値はアーキテクトが設定するものでありアプリケーションプログラマが設定する必要はない。

```xml
<component name="filePathSetting"
         class="nablarch.core.util.FilePathSetting" autowireType="None">
   <property name="basePathSettings">
     <map>
       <!-- 実際のサンプルでは、以下のvalue属性の部分はプレースホルダになっているが、
                                  ここでは説明を分かりやすくするため、直接パスをvalue属性に記載する。-->
       <entry key="format" value="classpath:web/format" />
     </map>
   </property>
   <property name="fileExtensions">
     <map>
       <!-- 拡張子を設定する -->
       <entry key="format" value="fmt" />
     </map>
   </property>
</property>
```

フォーマット定義ファイルの名前は以下の命名規約に従うこと。

* 要求電文: リクエストID + “_SEND”
* 応答電文: リクエストID + “_RECEIVE”

参考として、サンプルで使用している要求電文と応答電文のフォーマット定義ファイルを以下に示す。

### 要求電文のフォーマット定義ファイル

ファイルパス： web/format/RM11AC0201_SEND.fmt

```bash
#-------------------------------------------------------------------------------
# ユーザ情報登録電文の業務データ部レイアウト定義
#-------------------------------------------------------------------------------
file-type:        "Fixed" # 固定長
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    420     # 各レコードの長さ
record-separator: "\r\n"  # 改行コード

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

> **Warning:**
> 同期応答送信処理に使用するフォーマット定義ファイル(～_SEND.fmt)の
> レコードタイプ名は" `data` "固定である。

### 応答電文のフォーマット定義ファイル

ファイルパス： web/format/RM11AC0201_RECEIVE.fmt

```bash
#-------------------------------------------------------------------------------
# ユーザ情報登録応答電文の業務データ部フォーマット定義
#-------------------------------------------------------------------------------
file-type:        "Fixed" # 固定長
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    420     # 各レコードの長さ
record-separator: "\r\n"  # 改行コード

[data]
1   dataKbn                     X(1)  "0"   # データ区分(固定)
2   userId                      X(10)       # 採番したユーザID
12  failureCode                 X(20)       # 障害事由コード
32  userInfoId                  X(20)       # 問い合わせID
52  ?filler                     X(369)      # 空白領域
```

## 同期応答メッセージ送信処理を行うActionクラス

サンプルでは、同期応答メッセージ送信時に以下の処理を行う。

① リクエストを精査しEntityへ変換する。
② Entityの内容からSyncMessageオブジェクトを生成する。
③ MessageSenderでメッセージを送信する。
④ 応答電文のSyncMessageオブジェクトからデータを取得する。

```java
/**
 * ユーザ情報登録確認画面の「メッセージ送信」イベントの処理を行う。
 *
 * @param req リクエストコンテキスト
 * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
 * @return HTTPレスポンス
 */
@OnError(type = ApplicationException.class, path = "forward://RW11AC0201")
@OnDoubleSubmission(path = "forward://RW11AC0201")
public HttpResponse doRW11AC0205(HttpRequest req, ExecutionContext ctx) {

    // ①精査とエンティティ生成
    W11AC02Form form = validateForSendUser(req);

    // エンティティ取得
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

タイムアウト時は、MessageSendSyncTimeoutException例外がスローされるので、
必要に応じて例外をキャッチし、エラー画面への遷移を行うこと。
