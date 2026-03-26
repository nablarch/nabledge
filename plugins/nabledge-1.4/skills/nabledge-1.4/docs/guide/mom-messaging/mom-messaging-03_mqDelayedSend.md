# 応答不要メッセージ送信処理

## アプリケーション開発者が実装する成果物

電文を送信するアクションはNablarchの一部として提供されるため、アプリケーション開発者が作成する成果物は以下のみ:

- 送信電文を作成するためのデータを保持するテーブル（一時テーブル）
- 電文のレイアウトを定義したフォーマット定義ファイル
- 下記3種類のSQL文が記述されたSQLファイル
  - 電文送信テーブルからステータスが未送信のデータを取得するSELECT文（条件に未送信であることを含める必要がある）
  - 電文送信後にステータスを処理済みに更新するUPDATE文
  - 電文送信失敗時にステータスを送信失敗（エラー）に更新するUPDATE文
- 一時テーブルの処理ステータスを更新するためのFormクラス

> **注意**: Formクラスは各アプリケーション開発者が個別に作成する必要はない。詳細は :ref:`Formクラスの実装例<sendFormSample>` を参照。

<details>
<summary>keywords</summary>

応答不要メッセージ送信, 一時テーブル, フォーマット定義ファイル, SQLファイル, Formクラス, AsyncMessageSendAction

</details>

## フォーマット定義ファイル

フォーマット定義ファイル作成ルール:

- ファイル名は「送信電文のリクエストID + "_SEND.fmt"」
- 外部インタフェース設計書を入力元として、フォーマット定義ファイル自動生成ツールを使用して作成

```
#-------------------------------------------------------------------------------
# ユーザ削除情報電文のフォーマット
#-------------------------------------------------------------------------------
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

フォーマット定義ファイル, _SEND.fmt, 電文フォーマット, 固定長, text-encoding, record-length

</details>

## 一時テーブル

電文の種類ごとに専用の一時テーブルからデータを取得する。テーブル定義ルール:

- 主キーは電文を一意に識別するためのID（採番機能などで採番した一意の値）を格納するカラム。格納する値および桁数は各プロジェクトの方式設計に従い定義する
- テーブル属性情報には送信する電文の各項目に対応するカラムを定義する
- 各プロジェクトの方式に合わせて共通項目（登録ユーザIDや登録日時など）を定義する

**テーブル定義例（主キー）**:

| カラム論理名 | 定義 |
|---|---|
| 送信電文連番 | CHAR(10) |

**テーブル定義例（属性項目）**:

| カラム論理名 | 定義 |
|---|---|
| ユーザID | CHAR(10) |
| 漢字名称 | NVARCHAR2(100) |
| カナ名称 | NVARCHAR2(100) |
| ステータス | CHAR(1) |

**テーブル定義例（共通項目）**:

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

一時テーブル, 電文送信テーブル, 主キー, ステータス, 送信電文連番

</details>

## Formクラス

Formクラスは一時テーブルのステータス更新専用のクラスであるため、一時テーブルの全属性を保持する必要はない。一時テーブルの主キーおよびデータ更新時に値を更新する共通項目のカラム名をプロジェクトで統一することで、単一のFormクラスで全ての電文送信処理のステータス更新が行える。

Formクラスは `AsyncMessageSendActionSettings` の `formClassName` プロパティに指定する（アーキテクトが設定するものであり、個々の開発者が設定する必要はない）:

```xml
<component name="asyncMessageSendActionSettings"
    class="nablarch.fw.messaging.action.AsyncMessageSendActionSettings">
  <property name="formClassName"
      value="nablarch.sample.messaging.form.SendMessagingForm" />
</component>
```

```java
package nablarch.sample.messaging.form;
 
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

SendMessagingForm, AsyncMessageSendActionSettings, formClassName, @UserId, @CurrentDateTime, Formクラス, ステータス更新

</details>

## SQLファイル

一時テーブルを操作するための3種類のSQL文を定義する。

**SQLファイル命名・配置ルール**:

- SQLファイル名は「送信電文のリクエストID + ".sql"」
- SQL_IDは以下の通り固定:

| SQLの種類 | SQL_ID |
|---|---|
| 未送信のデータを取得するSELECT文 | SELECT_SEND_DATA |
| ステータスを処理済みに更新するUPDATE文 | UPDATE_NORMAL_END |
| ステータスをエラーに更新するUPDATE文 | UPDATE_ABNORMAL_END |

- SQLファイルの配置ディレクトリは `AsyncMessageSendActionSettings` の `sqlFilePackage` プロパティで設定する（アーキテクトが設定するものであり、個々の開発者が設定する必要はない）:

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

SELECT_SEND_DATA, UPDATE_NORMAL_END, UPDATE_ABNORMAL_END, sqlFilePackage, SQLファイル, AsyncMessageSendActionSettings

</details>
