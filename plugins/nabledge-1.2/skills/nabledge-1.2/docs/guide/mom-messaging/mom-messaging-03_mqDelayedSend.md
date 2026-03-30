# 応答不要メッセージ送信処理

## アプリケーション開発者が実装する成果物

電文を送信するアクションはNablarchの一部として提供される（:ref:`messageDelayedSendDesign` 参照）。アプリケーション開発者が作成する必要がある成果物は以下のみ。

- **一時テーブル**: 送信電文データを保持するテーブル（電文の種類ごとに専用テーブル）
- **フォーマット定義ファイル**: 電文のレイアウトを定義したファイル
- **SQLファイル**: 以下3種類のSQL文を含むファイル
  - 電文送信テーブルからステータスが未送信のデータを取得するSELECT文（条件に未送信ステータスを含めること）
  - 電文送信後にステータスを処理済みに更新するUPDATE文
  - 電文送信失敗時にステータスを送信失敗（エラー）に更新するUPDATE文
- **Formクラス**: 一時テーブルの処理ステータスを更新するクラス

> **注意**: Formクラスは各アプリケーションプログラマが作成する必要はない（:ref:`Formクラスの実装例<sendFormSample>` 参照）。

<details>
<summary>keywords</summary>

応答不要メッセージ送信, 一時テーブル, フォーマット定義ファイル, SQLファイル, Formクラス, AsyncMessageSendActionSettings, messageDelayedSendDesign

</details>

## フォーマット定義ファイル

電文の業務電文部のレイアウトを表すフォーマット定義ファイルを作成する。外部インタフェース設計書を入力元として、フォーマット定義ファイル自動生成ツールを使用して作成する。

**ファイル名ルール**: 「送信電文のリクエストID + `_SEND.fmt`」

```bash
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    270     # 各レコードの長さ
file-type:        "Fixed" # 固定長

[userData] # データレコード
1   userId                      X(10)       # ユーザID
11  ?filler1                    X(10)       # 空白領域
21  kanjiName                   N(100)      # 漢字氏名
121 kanaName                    N(100)      # カナ氏名
221 ?filler1                    X(50)       # 空白領域
```

<details>
<summary>keywords</summary>

フォーマット定義ファイル, _SEND.fmt, text-encoding, record-length, file-type, 電文レイアウト定義

</details>

## 一時テーブル

電文の種類ごとに専用の一時テーブルから送信データを取得する。一時テーブルは以下のルールに従い定義すること。

- **主キー**: 電文を一意に識別するID（採番機能などで採番した一意の値）を格納するカラム。格納する値および桁数はプロジェクトの方式設計に従うこと
- **属性情報**: 送信する電文の各項目に対応するカラムを定義すること
- **共通項目**: プロジェクトの方式に合わせて（登録ユーザIDや登録日時など）定義すること

**テーブル定義例（サンプルアプリケーション）**

主キー:

| カラム論理名 | 定義 |
|---|---|
| 送信電文連番 | CHAR(10) |

属性項目（電文の項目に対応）:

| カラム論理名 | 定義 |
|---|---|
| ユーザID | CHAR(10) |
| 漢字名称 | NVARCHAR2(100) |
| カナ名称 | NVARCHAR2(100) |
| ステータス | CHAR(1) |

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

一時テーブル, 電文送信テーブル, DELETE_USER_SEND_MESSAGE, ステータス管理, SEND_MESSAGE_SEQUENCE, テーブル定義

</details>

## Formクラス

Formクラスは一時テーブルのステータスを更新するために使用する。ステータス更新専用クラスのため、一時テーブルの全属性を保持する必要はない。

一時テーブルの主キーとデータ更新時に値を更新する共通項目のカラム名をプロジェクトで統一することで、単一のFormクラスで全ての電文送信処理のステータス更新が可能になる。

Formクラスは **クラス**: `nablarch.fw.messaging.action.AsyncMessageSendActionSettings` の `formClassName` プロパティに指定する（アーキテクトなどが設定する値であり、個々の開発者が設定する必要はない）。

```xml
<component name="asyncMessageSendActionSettings"
    class="nablarch.fw.messaging.action.AsyncMessageSendActionSettings">
  <property name="formClassName"
      value="nablarch.sample.messaging.form.SendMessagingForm" />
</component>
```

**クラス**: `nablarch.sample.messaging.form.SendMessagingForm`

```java
import java.sql.Timestamp;
import java.util.Map;

import nablarch.core.db.statement.autoproperty.CurrentDateTime;
import nablarch.core.db.statement.autoproperty.UserId;

public class SendMessagingForm {

    /** 送信電文連番 */
    private String sendMessageSequence;

    /** 更新ユーザID */
    @UserId
    private String updatedUserId;

    /** 更新日時 */
    @CurrentDateTime
    private Timestamp updatedDate;

    public SendMessagingForm(Map<String, ?> data) {
        sendMessageSequence = (String) data.get("sendMessageSequence");
        updatedUserId = (String) data.get("updatedUserId");
        updatedDate = (Timestamp) data.get("updatedDate");
    }
}
```

<details>
<summary>keywords</summary>

SendMessagingForm, formClassName, AsyncMessageSendActionSettings, @UserId, @CurrentDateTime, ステータス更新, nablarch.fw.messaging.action.AsyncMessageSendActionSettings

</details>

## SQLファイル

[一時テーブル](#s2) を操作するための以下3種類のSQL文を定義すること。

**SQLファイル命名ルール**:
- ファイル名: 「送信電文のリクエストID + `.sql`」
- SQL_IDは以下の固定値を使用すること:

| SQLの種類 | SQL_ID |
|---|---|
| 未送信データ取得のSELECT文 | `SELECT_SEND_DATA` |
| ステータスを処理済みに更新するUPDATE文 | `UPDATE_NORMAL_END` |
| ステータスをエラーに更新するUPDATE文 | `UPDATE_ABNORMAL_END` |

- SQLファイルの配置ディレクトリは `AsyncMessageSendActionSettings` の `sqlFilePackage` プロパティに設定されたディレクトリとすること（アーキテクトが設定する値、個々の開発者が設定する必要はない）

```xml
<component name="asyncMessageSendActionSettings"
    class="nablarch.fw.messaging.action.AsyncMessageSendActionSettings">
  <property name="sqlFilePackage" value="nablarch.sample.messaging.sql" />
</component>
```

```sql
SELECT_SEND_DATA =
SELECT
    SEND_MESSAGE_SEQUENCE,
    USER_ID,
    KANJI_NAME,
    KANA_NAME,
    STATUS,
    INSERT_USER_ID,
    INSERT_DATE,
    INSERT_REQUEST_ID,
    INSERT_EXECUTION_ID,
    UPDATED_USER_ID,
    UPDATED_DATE
FROM
    DELETE_USER_SEND_MESSAGE
WHERE
    STATUS = '0'
ORDER BY
    SEND_MESSAGE_SEQUENCE

UPDATE_NORMAL_END =
UPDATE
    DELETE_USER_SEND_MESSAGE
SET
    STATUS = '1',
    UPDATED_USER_ID = :updatedUserId,
    UPDATED_DATE = :updatedDate
WHERE
    SEND_MESSAGE_SEQUENCE = :sendMessageSequence

UPDATE_ABNORMAL_END =
UPDATE
    DELETE_USER_SEND_MESSAGE
SET
    STATUS = '9',
    UPDATED_USER_ID = :updatedUserId,
    UPDATED_DATE = :updatedDate
WHERE
    SEND_MESSAGE_SEQUENCE = :sendMessageSequence
```

<details>
<summary>keywords</summary>

SELECT_SEND_DATA, UPDATE_NORMAL_END, UPDATE_ABNORMAL_END, sqlFilePackage, AsyncMessageSendActionSettings, SQLファイル命名規則, STATUS

</details>
