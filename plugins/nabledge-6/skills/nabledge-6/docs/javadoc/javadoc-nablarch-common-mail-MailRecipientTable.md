# class MailRecipientTable

**パッケージ:** nablarch.common.mail

**実装されたインタフェース:**
- Initializable

---

```java
public class MailRecipientTable
implements Initializable
```

メール送信先管理テーブルのスキーマ情報を保持するデータオブジェクト。

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

メールリクエストIDカラム名

---

### serialNumberColumnName

```java
private String serialNumberColumnName
```

シリアル番号カラム名

---

### recipientTypeColumnName

```java
private String recipientTypeColumnName
```

送信先区分カラム名

---

### mailAddressColumnName

```java
private String mailAddressColumnName
```

送信先メールアドレスのカラム名

---

### insertSql

```java
private String insertSql
```

メール送信先を登録するSQL

---

### findSql

```java
private String findSql
```

送信先を取得するSQL

---

## メソッドの詳細

### setTableName

```java
public void setTableName(String tableName)
```

メール送信先テーブルの名前を設定する。

**パラメータ:**
- `tableName` - メール送信先テーブルの名前

---

### getTableName

```java
public String getTableName()
```

メール送信先テーブルの名前を取得する。

**戻り値:**
メール送信先テーブルの名前

---

### setMailRequestIdColumnName

```java
public void setMailRequestIdColumnName(String mailRequestIdColumnName)
```

メール送信先テーブルの要求IDカラムの名前を設定する。

**パラメータ:**
- `mailRequestIdColumnName` - メール送信先テーブルの要求IDカラムの名前

---

### setSerialNumberColumnName

```java
public void setSerialNumberColumnName(String serialNumberColumnName)
```

メール送信先テーブルの連番カラムの名前を設定する。

**パラメータ:**
- `serialNumberColumnName` - メール送信先テーブルの連番カラムの名前

---

### setRecipientTypeColumnName

```java
public void setRecipientTypeColumnName(String recipientTypeColumnName)
```

メール送信先テーブルの送信先区分カラムの名前を設定する。

**パラメータ:**
- `recipientTypeColumnName` - メール送信先テーブルの送信先区分カラムの名前

---

### setMailAddressColumnName

```java
public void setMailAddressColumnName(String mailAddressColumnName)
```

メール送信先テーブルの送信先メールアドレスカラムの名前を設定する。

**パラメータ:**
- `mailAddressColumnName` - メール送信先テーブルの送信先メールアドレスカラムの名前

---

### insert

```java
public void insert(String mailRequestId, MailContext context, MailConfig mailConfig)
```

送信先テーブルに送信先情報のデータを追加する。

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `context` - メール送信先情報を持つオブジェクト
- `mailConfig` - メールの設定情報を持つオブジェクト

---

### insert

```java
public void insert(String mailRequestId, MailContext context, MailConfig mailConfig, String transactionName)
```

指定されたトランザクション名を用いて送信先テーブルに送信先情報のデータを追加する

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `context` - メール送信先情報を持つオブジェクト
- `mailConfig` - メールの設定情報を持つオブジェクト
- `transactionName` - トランザクション名

---

### executeInsertSQL

```java
private void executeInsertSQL(String mailRequestId, MailContext context, MailConfig mailConfig, AppDbConnection connection)
```

送信先テーブルに送信先情報のデータを追加する

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `context` - メール送信先情報を持つオブジェクト
- `mailConfig` - メールの設定情報を持つオブジェクト
- `connection` - コネクション

---

### find

```java
public List<MailRecipientTable.MailRecipient> find(String mailRequestId, String recipientType)
```

送信先情報を取得する。
<p/>
指定されたメールリクエストIDと宛先区分に紐付く送信先の情報を取得する。

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `recipientType` - 宛先区分

**戻り値:**
取得した送信先情報

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
<li>メール送信先へレコードを追加するINSERT文</li>
<li>メール送信先からメールリクエストIDを元にレコードを取得するSELECT文(連番の昇順でソート)</li>
</ul>

---
