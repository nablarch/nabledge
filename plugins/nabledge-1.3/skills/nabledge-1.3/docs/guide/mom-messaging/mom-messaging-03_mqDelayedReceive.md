# 応答不要メッセージ受信処理

## アプリケーション開発者が実装する成果物

電文を受信するアクションはNablarchが提供するため（:ref:`messageDelayedReceiveDesign`参照）、アプリケーション開発者が実装する成果物は以下のみ:

- フォーマット定義ファイル（電文のレイアウト定義）
- 電文を登録する一時テーブルの定義
- データベースへ電文を登録するFormクラス
- 電文を登録するINSERT文を記述したSQLファイル

<details>
<summary>keywords</summary>

応答不要メッセージ受信, メッセージ受信処理, フォーマット定義ファイル, 一時テーブル, Formクラス, SQLファイル, AsyncMessageReceiveAction

</details>

## フォーマット定義ファイル

フォーマット定義ファイルは外部インタフェース設計書を入力として、フォーマット定義ファイル自動生成ツールにより生成する。

サンプル（ユーザ登録情報電文のレイアウト）:

```
text-encoding:    "MS932"
record-length:    420
file-type:        "Fixed"

[userData]
1   loginId                     X(20)
21  kanjiName                   N(100)
121 kanaName                    N(100)
221 ?filler1                    X(50)
271 mailAddress                 X(100)
371 extensionNumberBuilding     X(2)
373 extensionNumberPersonal     X(4)
377 mobilePhoneNumberAreaCode   X(3)
380 mobilePhoneNumberCityCode   X(4)
384 mobilePhoneNumberSbscrCode  X(4)
388 ?filler2                    X(33)
```

<details>
<summary>keywords</summary>

フォーマット定義ファイル, 電文レイアウト, MS932, Fixed, userData, record-length, text-encoding

</details>

## 一時テーブルの定義

一時テーブルの定義ルール:

- 主キー: 電文を一意に識別するIDカラム。値はNablarchフレームワークで採番する。桁数はプロジェクトの方式設計に従う。
- 受信した電文の各項目に対応するカラムを属性情報に定義する。
- プロジェクト方式に合わせて共通項目（登録ユーザID、登録日時など）を定義する。

主キー:

| カラム論理名 | 定義 |
|---|---|
| 受信電文連番 | CHAR(10) |

属性項目:

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

共通項目:

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

一時テーブル, 受信電文連番, 電文保存テーブル, message-save-table, テーブル定義, CHAR, VARCHAR2, NVARCHAR2

</details>

## Formクラス

Formクラス作成ルール:

- クラス名: 受信電文のリクエストID + "Form"
- コンストラクタ: `(String receivedMessageSequence, nablarch.fw.messaging.RequestMessage message)` の2引数コンストラクタを定義すること
  - `String`: 受信電文連番
  - `RequestMessage`: 受信電文
- 配置パッケージ: `AsyncMessageReceiveActionSettings` の `formClassPackage` プロパティに設定されたパッケージ

```xml
<component name="asyncMessageReceiveActionSettings"
           class="nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings">
  <property name="formClassPackage" value="nablarch.sample.messaging.form" />
</component>
```

コンストラクタ実装例（電文ボディの取得）:

```java
public RM11AC0201Form(String receivedMessageSequence, RequestMessage message) {
    this.receivedMessageSequence = receivedMessageSequence;
    // 電文のボディ部はRequestMessage#getRecordOf(<レコード名>)で取得
    // レコード名はフォーマット定義ファイルで設定したレコード名称を指定する
    DataRecord data = message.getRecordOf("userData");
    loginId = data.getString("loginId");
    kanjiName = data.getString("kanjiName");
    kanaName = data.getString("kanaName");
    mailAddress = data.getString("mailAddress");
    extensionNumberBuilding = data.getString("extensionNumberBuilding");
    // 以下、各フィールドに設定
}
```

<details>
<summary>keywords</summary>

Formクラス, AsyncMessageReceiveActionSettings, formClassPackage, RequestMessage, DataRecord, getRecordOf, RM11AC0201Form, 受信電文連番

</details>

## SQLファイル

SQLファイル作成ルール:

- ファイル名: 受信電文のリクエストID + ".sql"
- SQL_ID: `INSERT_MESSAGE`
- 配置ディレクトリ: `AsyncMessageReceiveActionSettings` の `sqlFilePackage` プロパティに設定されたディレクトリ

```xml
<component name="asyncMessageReceiveActionSettings"
    class="nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings">
  <property name="sqlFilePackage" value="nablarch.sample.messaging.sql" />
</component>
```

SQL例（[一時テーブル](#s2)へのINSERT）:

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

SQLファイル, INSERT_MESSAGE, sqlFilePackage, AsyncMessageReceiveActionSettings, INSERT文, 受信電文登録

</details>
