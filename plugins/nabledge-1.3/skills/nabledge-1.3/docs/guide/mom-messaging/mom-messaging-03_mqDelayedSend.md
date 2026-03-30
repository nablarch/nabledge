# 応答不要メッセージ送信処理

## アプリケーション開発者が実装する成果物

:ref:`messageDelayedSendDesign` より、電文送信アクションはNablarchが提供するため、アプリケーション開発者が実装する成果物は以下のみ。

- 送信電文データを保持する一時テーブル
- 電文のレイアウトを定義したフォーマット定義ファイル
- 以下3種類のSQL文が記述されたSQLファイル
  - 未送信データ取得のSELECT文（条件に未送信であることを含める必要あり）
  - ステータスを処理済みに更新するUPDATE文
  - ステータスをエラーに更新するUPDATE文
- 一時テーブルのステータスを更新するFormクラス

> **注意**: Formクラスは各アプリケーションプログラマが個別に作成する必要はない。詳細は :ref:`Formクラスの実装例<sendFormSample>` 参照。

<details>
<summary>keywords</summary>

応答不要メッセージ送信, 一時テーブル, フォーマット定義ファイル, SQLファイル, Formクラス, 電文送信成果物, AsyncMessageSendActionSettings

</details>

## フォーマット定義ファイル

電文の業務電文部レイアウトを定義するファイル。

- ファイル名: 「送信電文のリクエストID + "_SEND.fmt"」
- 外部インタフェース設計書を入力元として、フォーマット定義ファイル自動生成ツールで作成する。

サンプル:
```
text-encoding:    "MS932"  # 文字列型フィールドの文字エンコーディング
record-length:    270      # 各レコードの長さ
file-type:        "Fixed"  # 固定長

[userData]
1   userId                      X(10)   # ユーザID
11  ?filler1                    X(10)   # 空白領域
21  kanjiName                   N(100)  # 漢字氏名
121 kanaName                    N(100)  # カナ氏名
221 ?filler1                    X(50)   # 空白領域
```

<details>
<summary>keywords</summary>

フォーマット定義ファイル, 電文レイアウト, _SEND.fmt, 固定長, メッセージ送信フォーマット

</details>

## 一時テーブル

電文種別ごとに専用の一時テーブルを定義する。以下のルールに従うこと。

- 主キー: 電文を一意に識別するID（採番機能等で採番した一意の値）。格納する値・桁数はプロジェクトの方式設計に従う。
- 属性項目: 送信する電文の各項目に対応するカラムを定義する。
- 共通項目: 各プロジェクトの方式に合わせた共通項目（登録ユーザIDや登録日時など）を定義する。

サンプルテーブル定義:

主キー:
| カラム論理名 | 定義 |
|---|---|
| 送信電文連番 | CHAR(10) |

属性項目:
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

一時テーブル, 電文送信テーブル, SEND_MESSAGE_SEQUENCE, テーブル定義, メッセージ送信

</details>

## Formクラス

Formクラスはステータス更新専用。一時テーブルの全属性を保持する必要はない。一時テーブルの主キーおよびデータ更新時の共通項目カラム名をプロジェクトで統一することで、単一のFormクラスで全電文送信処理のステータス更新が可能になる。

`AsyncMessageSendActionSettings`の`formClassName`プロパティに設定する（アーキテクトが設定。個々の開発者が設定不要）。

```xml
<component name="asyncMessageSendActionSettings"
    class="nablarch.fw.messaging.action.AsyncMessageSendActionSettings">
  <property name="formClassName"
      value="nablarch.sample.messaging.form.SendMessagingForm" />
</component>
```

**クラス**: `nablarch.sample.messaging.form.SendMessagingForm`

```java
public class SendMessagingForm {
    private String sendMessageSequence;

    @UserId
    private String updatedUserId;

    @CurrentDateTime
    private Timestamp updatedDate;

    public SendMessagingForm(Map<String, ?> data) {
        sendMessageSequence = (String) data.get("sendMessageSequence");
        updatedUserId = (String) data.get("updatedUserId");
        updatedDate = (Timestamp) data.get("updatedDate");
    }
}
```

> **注意**: サンプルでは以下のルールで統一することで単一Formクラスを実現している。主キー: SEND_MESSAGE_SEQUENCE、データ更新時に更新するカラム: UPDATED_USER_ID、UPDATED_DATE。

<details>
<summary>keywords</summary>

SendMessagingForm, AsyncMessageSendActionSettings, formClassName, UserId, CurrentDateTime, ステータス更新, Formクラス

</details>

## SQLファイル

一時テーブルを操作するSQL文を定義する。

**ルール:**
- ファイル名: 「送信電文のリクエストID + ".sql"」
- SQL_ID:

| SQLの種類 | SQL_ID |
|---|---|
| 未送信データ取得SELECT文 | SELECT_SEND_DATA |
| ステータスを処理済みに更新するUPDATE文 | UPDATE_NORMAL_END |
| ステータスをエラーに更新するUPDATE文 | UPDATE_ABNORMAL_END |

- SQLファイルの配置ディレクトリは`AsyncMessageSendActionSettings`の`sqlFilePackage`プロパティで設定（アーキテクトが設定。個々の開発者が設定不要）。

```xml
<component name="asyncMessageSendActionSettings"
    class="nablarch.fw.messaging.action.AsyncMessageSendActionSettings">
  <property name="sqlFilePackage" value="nablarch.sample.messaging.sql" />
</component>
```

サンプルSQL:
```sql
SELECT_SEND_DATA =
SELECT
    SEND_MESSAGE_SEQUENCE, USER_ID, KANJI_NAME, KANA_NAME, STATUS,
    INSERT_USER_ID, INSERT_DATE, INSERT_REQUEST_ID, INSERT_EXECUTION_ID,
    UPDATED_USER_ID, UPDATED_DATE
FROM DELETE_USER_SEND_MESSAGE
WHERE STATUS = '0'
ORDER BY SEND_MESSAGE_SEQUENCE

UPDATE_NORMAL_END =
UPDATE DELETE_USER_SEND_MESSAGE
SET STATUS = '1',
    UPDATED_USER_ID = :updatedUserId,
    UPDATED_DATE = :updatedDate
WHERE SEND_MESSAGE_SEQUENCE = :sendMessageSequence

UPDATE_ABNORMAL_END =
UPDATE DELETE_USER_SEND_MESSAGE
SET STATUS = '9',
    UPDATED_USER_ID = :updatedUserId,
    UPDATED_DATE = :updatedDate
WHERE SEND_MESSAGE_SEQUENCE = :sendMessageSequence
```

<details>
<summary>keywords</summary>

SELECT_SEND_DATA, UPDATE_NORMAL_END, UPDATE_ABNORMAL_END, sqlFilePackage, AsyncMessageSendActionSettings, SQLファイル, 未送信データ取得

</details>
