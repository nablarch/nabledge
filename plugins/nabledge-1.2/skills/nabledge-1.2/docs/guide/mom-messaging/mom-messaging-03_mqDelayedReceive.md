# 応答不要メッセージ受信処理

## アプリケーション開発者が実装する成果物

電文を受信するアクションはNablarchが提供するため（:ref:`messageDelayedReceiveDesign` 参照）、アプリケーション開発者が作成する成果物は以下のみ。

- フォーマット定義ファイル（電文の業務電文部のレイアウト定義）
- 一時テーブル定義（受信電文を保存する専用テーブル）
- Formクラス（電文をDBへ登録する際に使用）
- SQLファイル（一時テーブルへのINSERT文）

<details>
<summary>keywords</summary>

応答不要メッセージ受信処理, 非同期メッセージ受信, MOM, フォーマット定義ファイル, 一時テーブル, Formクラス, SQLファイル, messageDelayedReceive

</details>

## フォーマット定義ファイル

フォーマット定義ファイルは外部インタフェース設計書を入力として自動生成ツールで生成する。

```
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    420     # 各レコードの長さ
file-type:        "Fixed" # 固定長

[userData] # レコード名称
1   loginId                     X(20)       # ログインID
21  kanjiName                   N(100)      # 漢字氏名
121 kanaName                    N(100)      # カナ氏名
221 ?filler1                    X(50)       # 空白領域
271 mailAddress                 X(100)      # メールアドレス
371 extensionNumberBuilding     X(2)        # 内線番号（ビル番号）
373 extensionNumberPersonal     X(4)        # 内線番号（個人番号）
377 mobilePhoneNumberAreaCode   X(3)        # 携帯番号（市外）
380 mobilePhoneNumberCityCode   X(4)        # 携帯電話番号(市内)
384 mobilePhoneNumberSbscrCode  X(4)        # 携帯電話番号(加入)
388 ?filler2                    X(33)       # 空白領域
```

<details>
<summary>keywords</summary>

フォーマット定義ファイル, 固定長, text-encoding, record-length, file-type, 電文レイアウト定義, MS932

</details>

## 一時テーブルの定義

受信電文は電文の種類毎に専用の一時テーブルに保存する。一時テーブル定義ルール:

- 主キーはNablarchフレームワークが採番する電文一意識別IDを格納するカラム（桁数はプロジェクト方式設計に従う）
- 電文の各項目に対応するカラムを定義
- プロジェクト方式に合わせた共通項目（登録ユーザIDや登録日時など）を定義

**テーブル定義例（主キー）**:

| カラム論理名 | 定義 |
|---|---|
| 受信電文連番 | CHAR(10) |

**属性項目（電文項目に対応）**:

| カラム論理名 | 定義 |
|---|---|
| ログインID | VARCHAR2(20) |
| 漢字名称 | NVARCHAR2(100) |
| カナ名称 | NVARCHAR2(100) |
| メールアドレス | VARCHAR2(100) |
| 内線番号(ビル番号) | VARCHAR2(2) |
| 内線番号(個人番号) | VARCHAR2(4) |
| 携帯電話番号(市外) | VARCHAR2(3) |
| 携帯電話番号(市内) | VARCHAR2(4) |
| 携帯電話番号(加入) | VARCHAR2(4) |

**共通項目**:

| カラム論理名 | 定義 |
|---|---|
| 登録ユーザID | CHAR(10) |
| 登録日時 | TIMESTAMP |
| 更新ユーザID | CHAR(10) |
| 更新日時 | TIMESTAMP |
| 登録リクエストID | CHAR(10) |
| 登録実行時ID | CHAR(29) |

<details>
<summary>keywords</summary>

一時テーブル, 電文保存テーブル, 受信電文連番, 主キー採番, テーブル定義, message-save-table

</details>

## Formクラス

Formクラス定義ルール:

- クラス名: 受信電文のリクエストID + `"Form"`
- `(String receivedMessageSequence, nablarch.fw.messaging.RequestMessage message)` の2引数コンストラクタを定義
  - `String`: 受信電文連番
  - `nablarch.fw.messaging.RequestMessage`: 受信電文
- 配置パッケージ: `AsyncMessageReceiveActionSettings` の `formClassPackage` プロパティに設定されたパッケージ（アーキテクトが設定）

```xml
<component name="asyncMessageReceiveActionSettings"
           class="nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings">
  <property name="formClassPackage" value="nablarch.sample.messaging.form" />
</component>
```

コンストラクタ内では `RequestMessage#getRecordOf(<レコード名>)` で電文ボディのレコードを取得し、各フィールドに設定する。レコード名はフォーマット定義ファイルで設定したレコード名称を指定する。

```java
public class RM11AC0201Form {
    public RM11AC0201Form(String receivedMessageSequence, RequestMessage message) {
        this.receivedMessageSequence = receivedMessageSequence;
        DataRecord data = message.getRecordOf("userData");
        loginId = data.getString("loginId");
        kanjiName = data.getString("kanjiName");
        kanaName = data.getString("kanaName");
        mailAddress = data.getString("mailAddress");
        extensionNumberBuilding = data.getString("extensionNumberBuilding");
        extensionNumberPersonal = data.getString("extensionNumberPersonal");
        mobilePhoneNumberAreaCode = data.getString("mobilePhoneNumberAreaCode");
        mobilePhoneNumberCityCode = data.getString("mobilePhoneNumberCityCode");
        mobilePhoneNumberSbscrCode = data.getString("mobilePhoneNumberSbscrCode");
    }
}
```

DBへの保存機能の詳細は [db-object-save-samole](../web-application/web-application-01_DbAccessSpec_Example.md) を参照。

<details>
<summary>keywords</summary>

AsyncMessageReceiveActionSettings, formClassPackage, RequestMessage, RM11AC0201Form, Formクラス, 受信電文連番, getRecordOf, DataRecord

</details>

## SQLファイル

SQLファイル定義ルール:

- ファイル名: 受信電文のリクエストID + `".sql"`
- SQL_ID: `INSERT_MESSAGE`
- 配置ディレクトリ: `AsyncMessageReceiveActionSettings` の `sqlFilePackage` プロパティに設定されたディレクトリ（アーキテクトが設定）

```xml
<component name="asyncMessageReceiveActionSettings"
    class="nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings">
  <property name="sqlFilePackage" value="nablarch.sample.messaging.sql" />
</component>
```

```sql
INSERT_MESSAGE =
INSERT INTO USER_INFO_RECEIVE_MESSAGE (
    RECEIVED_MESSAGE_SEQUENCE,
    LOGIN_ID,
    KANJI_NAME,
    KANA_NAME,
    MAIL_ADDRESS,
    EXTENSION_NUMBER_BUILDING,
    EXTENSION_NUMBER_PERSONAL,
    MOBILE_PHONE_NUMBER_AREA_CODE,
    MOBILE_PHONE_NUMBER_CITY_CODE,
    MOBILE_PHONE_NUMBER_SBSCR_CODE,
    STATUS,
    INSERT_USER_ID,
    INSERT_DATE,
    INSERT_REQUEST_ID,
    INSERT_EXECUTION_ID,
    UPDATED_USER_ID,
    UPDATED_DATE
    )
    VALUES
    (
    :receivedMessageSequence,
    :loginId,
    :kanjiName,
    :kanaName,
    :mailAddress,
    :extensionNumberBuilding,
    :extensionNumberPersonal,
    :mobilePhoneNumberAreaCode,
    :mobilePhoneNumberCityCode,
    :mobilePhoneNumberSbscrCode,
    '0',
    :insertUserId,
    :insertDate,
    :insertRequestId,
    :updatedUserId,
    :updatedDate
    )
```

<details>
<summary>keywords</summary>

AsyncMessageReceiveActionSettings, sqlFilePackage, INSERT_MESSAGE, SQLファイル, 一時テーブルINSERT

</details>
