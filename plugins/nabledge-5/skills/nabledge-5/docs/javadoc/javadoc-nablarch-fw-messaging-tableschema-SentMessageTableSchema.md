# class SentMessageTableSchema

**パッケージ:** nablarch.fw.messaging.tableschema

---

```java
public class SentMessageTableSchema
```

再送電文管理テーブルスキーマ定義クラス。
<p/>
以下のようなテーブル構造を想定している。
<pre>
=====================================
メッセージID   VARCHAR PK
リクエストID   VARCHAR PK
応答宛先キュー VARCHAR
処理結果コード VARCHAR
電文データ部   BLOB
=====================================
</pre>
以下にデフォルト設定でのテーブル名、カラム名に沿ったテーブルスキーマの
サンプルを示す。

<pre>
CREATE TABLE SENT_MESSAGE (
    MESSAGE_ID  VARCHAR(64)
  , REQUEST_ID  VARCHAR(64)
  , REPLY_QUEUE VARCHAR(64)
  , STATUS_CODE CHAR(4)
  , BODY_DATA   BLOB
  , CONSTRAINT pk_SENT_MESSAGE
      PRIMARY KEY(MESSAGE_ID, REQUEST_ID)
);
</pre>

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### tableName

```java
private String tableName
```

再送電文管理テーブルのテーブル名

---

### messageIdColumn

```java
private String messageIdColumn
```

メッセージIDを保持するカラムの名称

---

### requestIdColumn

```java
private String requestIdColumn
```

要求電文のリクエストIDを保持するカラムの名称

---

### replyQueueColumn

```java
private String replyQueueColumn
```

応答電文の宛先キューの論理名を保持するカラムの名称

---

### statusCodeColumn

```java
private String statusCodeColumn
```

処理結果のステータスコードを保持するカラムの名称

---

### bodyDataColumn

```java
private String bodyDataColumn
```

メッセージボディデータの内容をバイト配列で保持するカラムの名称

---

## メソッドの詳細

### setTableName

```java
public SentMessageTableSchema setTableName(String tableName)
```

再送電文管理テーブルの名称を設定する。

**パラメータ:**
- `tableName` - テーブル名

**戻り値:**
このオブジェクト自体

---

### getTableName

```java
public String getTableName()
```

再送電文管理テーブルの名称を返す。

**戻り値:**
テーブルの名称

---

### setReplyQueueColumnName

```java
public SentMessageTableSchema setReplyQueueColumnName(String columnName)
```

応答電文の宛先キューの論理名を保持するカラムの名称を設定する。
(デフォルトは"REPLY_QUEUE")

**パラメータ:**
- `columnName` - カラムの名称

**戻り値:**
このオブジェクト自体

---

### getReplyQueueColumnName

```java
public String getReplyQueueColumnName()
```

応答電文の宛先キューの論理名を保持するカラムの名称を返す。

**戻り値:**
カラムの名称

---

### setMessageIdColumnName

```java
public SentMessageTableSchema setMessageIdColumnName(String columnName)
```

メッセージIDを保持するカラムの名称を設定する。
(デフォルトは"MESSAGE_ID")

**パラメータ:**
- `columnName` - カラムの名称

**戻り値:**
このオブジェクト自体

---

### getMessageIdColumnName

```java
public String getMessageIdColumnName()
```

メッセージIDを保持するカラムの名称をを返す。

**戻り値:**
カラムの名称

---

### setBodyDataColumnName

```java
public SentMessageTableSchema setBodyDataColumnName(String columnName)
```

メッセージボディデータの内容をバイト配列で保持するカラムの名称を設定する。
(デフォルトは"BODY_DATA")

**パラメータ:**
- `columnName` - カラムの名称

**戻り値:**
このオブジェクト自体

---

### getBodyDataColumnName

```java
public String getBodyDataColumnName()
```

メッセージボディデータの内容をバイト配列で保持するカラムの名称をを返す。

**戻り値:**
カラムの名称

---

### setRequestIdColumnName

```java
public SentMessageTableSchema setRequestIdColumnName(String columnName)
```

要求電文のリクエストIDを保持するカラムの名称を設定する。
(デフォルトは"REQUEST_ID")

**パラメータ:**
- `columnName` - カラムの名称

**戻り値:**
このオブジェクト自体

---

### getRequestIdColumnName

```java
public String getRequestIdColumnName()
```

要求電文のリクエストIDを保持するカラムの名称をを返す。

**戻り値:**
カラムの名称

---

### setStatusCodeColumnName

```java
public SentMessageTableSchema setStatusCodeColumnName(String columnName)
```

要求電文のユーザIDを保持するカラムの名称を設定する。
(デフォルトは"USER_ID")

**パラメータ:**
- `columnName` - カラムの名称

**戻り値:**
このオブジェクト自体

---

### getStatusCodeColumnName

```java
public String getStatusCodeColumnName()
```

要求電文のユーザIDを保持するカラムの名称をを返す。

**戻り値:**
カラムの名称

---
