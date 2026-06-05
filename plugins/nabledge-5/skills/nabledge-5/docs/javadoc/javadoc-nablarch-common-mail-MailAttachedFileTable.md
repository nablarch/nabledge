# class MailAttachedFileTable

**パッケージ:** nablarch.common.mail

**実装されたインタフェース:**
- Initializable

---

```java
public class MailAttachedFileTable
implements Initializable
```

添付ファイル管理テーブルのスキーマ情報を保持するデータオブジェクト。

**作成者:** Shinsuke Yoshio  

---

## フィールドの詳細

### tableName

```java
private String tableName
```

テーブル名

---

### mailRequestIdColumnName

```java
private String mailRequestIdColumnName
```

メールリクエストIDのカラム名

---

### serialNumberColumnName

```java
private String serialNumberColumnName
```

連番のカラム名

---

### fileNameColumnName

```java
private String fileNameColumnName
```

ファイル名のカラム名

---

### contentTypeColumnName

```java
private String contentTypeColumnName
```

Content-Typeのカラム名

---

### fileColumnName

```java
private String fileColumnName
```

ファイルデータのカラム名

---

### insertSql

```java
private String insertSql
```

添付ファイルを登録するSQL

---

### findSql

```java
private String findSql
```

添付ファイルを取得するSQL

---

## メソッドの詳細

### setTableName

```java
public void setTableName(String tableName)
```

添付ファイル管理テーブルの名前を設定する。

**パラメータ:**
- `tableName` - 添付ファイル管理テーブルの名前

---

### setMailRequestIdColumnName

```java
public void setMailRequestIdColumnName(String mailRequestIdColumnName)
```

添付ファイル管理テーブルの要求IDカラムの名前を設定する。

**パラメータ:**
- `mailRequestIdColumnName` - 添付ファイル管理テーブルの要求IDカラムの名前

---

### setSerialNumberColumnName

```java
public void setSerialNumberColumnName(String serialNumberColumnName)
```

添付ファイル管理テーブルの連番カラムの名前を設定する。

**パラメータ:**
- `serialNumberColumnName` - 添付ファイル管理テーブルの連番カラムの名前

---

### setFileNameColumnName

```java
public void setFileNameColumnName(String fileNameColumnName)
```

添付ファイル管理テーブルの添付ファイル名カラムの名前を設定する。

**パラメータ:**
- `fileNameColumnName` - 添付ファイル管理テーブルの添付ファイル名カラムの名前

---

### setContentTypeColumnName

```java
public void setContentTypeColumnName(String contentTypeColumnName)
```

添付ファイル管理テーブルのContent-Typeカラムの名前を設定する。

**パラメータ:**
- `contentTypeColumnName` - 添付ファイル管理テーブルのContent-Typeカラムの名前

---

### setFileColumnName

```java
public void setFileColumnName(String fileColumnName)
```

添付ファイル管理テーブルの添付ファイルカラムの名前を設定する。

**パラメータ:**
- `fileColumnName` - 添付ファイル管理テーブルの添付ファイルカラムの名前

---

### insert

```java
public void insert(String mailRequestId, MailContext context)
```

添付ファイル管理テーブルに添付ファイルの情報を登録する。

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `context` - 添付ファイルの情報

---

### insert

```java
public void insert(String mailRequestId, MailContext context, String transactionName)
```

指定されたトランザクション名を用いて添付ファイル管理テーブルに添付ファイルの情報を登録する。

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `context` - 添付ファイルの情報
- `transactionName` - トランザクション名

---

### executeInsertSQL

```java
private void executeInsertSQL(String mailRequestId, MailContext context, AppDbConnection connection)
```

添付ファイル管理テーブルに添付ファイルの情報を登録する。

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `context` - 添付ファイルの情報
- `connection` - コネクション

---

### find

```java
public List<MailAttachedFileTable.MailAttachedFile> find(String mailRequestId)
```

添付ファイルデータを取得する。

**パラメータ:**
- `mailRequestId` - メールリクエストID

**戻り値:**
取得した添付ファイルデータ

---

### initialize

```java
public void initialize()
```

{@inheritDoc}
<p/>
本クラスで使用するSQL文を各セッターで設定されたテーブル名及びカラム名から構築する。
<p/>
構築するSQL文は、以下の2種類
<ul>
<li>添付ファイル管理へレコードを追加するINSERT文</li>
<li>添付ファイル管理からメールリクエストIDを元にレコードを取得するSELECT文(連番の昇順でソート)</li>
</ul>

---
