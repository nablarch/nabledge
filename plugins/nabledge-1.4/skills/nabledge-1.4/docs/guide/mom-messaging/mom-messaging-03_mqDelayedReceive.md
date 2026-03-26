# 応答不要メッセージ受信処理

## アプリケーション開発者が実装する成果物

電文受信アクションはNablarchの一部として提供されるため、アプリケーション開発者が作成するのは以下の成果物のみ。

- 電文のレイアウトを定義したフォーマット定義ファイル
- 電文を登録するテーブル（一時テーブル）の定義
- データベースへ電文を登録する際に使用するFormクラス
- データベースへ電文を登録するためのINSERT文が記述されたSQLファイル

<details>
<summary>keywords</summary>

応答不要メッセージ受信処理, MOM電文受信, アプリケーション開発者の成果物, フォーマット定義ファイル, 一時テーブル, Formクラス, SQLファイル

</details>

## フォーマット定義ファイル

電文の業務電文部のレイアウトを定義するフォーマット定義ファイルを作成する。外部インタフェース設計書を入力元として、フォーマット定義ファイル自動生成ツールにより生成する。

```bash
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

フォーマット定義ファイル, 電文レイアウト, 固定長, text-encoding, record-length, file-type, 自動生成ツール

</details>

## 一時テーブルの定義

受信した電文は電文の種類毎に専用の一時テーブルに保存する。テーブル定義ルール:

- 主キー: 電文を一意に識別するIDカラム。格納値はNablarchフレームワークで採番。桁数はプロジェクト方式設計に従う
- 属性情報: 受信した電文の各項目に対応するカラムを定義
- 共通項目（登録ユーザIDや登録日時など）をプロジェクト方式に合わせて定義

**主キー例:**

| カラム論理名 | 定義 |
|---|---|
| 受信電文連番 | CHAR(10) |

**属性項目例（電文の項目に対応）:**

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

**共通項目例:**

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

一時テーブル, 受信電文保存, テーブル定義, 主キー, Nablarchフレームワーク採番, 共通項目

</details>

## Formクラス

Formクラスは一時テーブルへの電文登録時に使用する。NablarchのDB機能でオブジェクトのフィールド値をDBへ保存するために必要。詳細は [db-object-save-samole](../web-application/web-application-01_DbAccessSpec_Example.md) 参照。

**Formクラスルール:**
- クラス名: 受信電文のリクエストID + `"Form"`
- コンストラクタ: `String`（受信電文連番）と `nablarch.fw.messaging.RequestMessage`（受信電文）の2引数を持つコンストラクタを定義
- 配置パッケージ: `AsyncMessageReceiveActionSettings` の `formClassPackage` プロパティに設定されたパッケージ名（この設定値はアーキテクトなどが設定するものであり、個々の開発者が設定する必要はない）

```xml
<component name="asyncMessageReceiveActionSettings"
           class="nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings">
  <property name="formClassPackage" value="nablarch.sample.messaging.form" />
</component>
```

```java
public class RM11AC0201Form {
    private String receivedMessageSequence;

    public RM11AC0201Form(String receivedMessageSequence, RequestMessage message) {
        this.receivedMessageSequence = receivedMessageSequence;
        // 電文のボディ部はRequestMessage#getRecordOf(<レコード名>)で取得
        // レコード名はフォーマット定義ファイルのレコード名称を指定
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

<details>
<summary>keywords</summary>

Formクラス, AsyncMessageReceiveActionSettings, formClassPackage, RequestMessage, DataRecord, 受信電文連番

</details>

## SQLファイル

[一時テーブル](#s2) に受信電文を保存するSQLファイルを用意する。

**SQLファイルルール:**
- ファイル名: 受信電文のリクエストID + `".sql"`
- SQL_ID: `INSERT_MESSAGE`
- 配置ディレクトリ: `AsyncMessageReceiveActionSettings` の `sqlFilePackage` プロパティに設定されたディレクトリ（この設定値はアーキテクトなどが設定するものであり、個々の開発者が設定する必要はない）

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
    VALUES (
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

SQLファイル, INSERT_MESSAGE, sqlFilePackage, AsyncMessageReceiveActionSettings, 受信電文INSERT

</details>
