# class MailRequestTable

**パッケージ:** nablarch.common.mail

**実装されたインタフェース:**
- Initializable

---

```java
public class MailRequestTable
implements Initializable
```

メール送信要求管理テーブルのスキーマを保持するデータオブジェクト。

**作成者:** Shinsuke Yoshio  

---

## フィールドの詳細

### SELECT

```java
private static final String SELECT
```

SQLリテラル

---

### FROM

```java
private static final String FROM
```

SQLリテラル

---

### WHERE

```java
private static final String WHERE
```

SQLリテラル

---

### AND

```java
private static final String AND
```

SQLリテラル

---

### UPDATE

```java
private static final String UPDATE
```

SQLリテラル

---

### SET

```java
private static final String SET
```

SQLリテラル

---

### ORDER_BY

```java
private static final String ORDER_BY
```

SQLリテラル

---

### BIND_PARAMETER

```java
private static final String BIND_PARAMETER
```

SQLリテラル

---

### INSERT_INTO

```java
private static final String INSERT_INTO
```

SQLリテラル

---

### VALUES

```java
private static final String VALUES
```

SQLリテラル

---

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

### subjectColumnName

```java
private String subjectColumnName
```

件名のカラム名

---

### fromColumnName

```java
private String fromColumnName
```

送信者アドレスのカラム名

---

### replyColumnName

```java
private String replyColumnName
```

返信先アドレスのカラム名

---

### returnPathColumnName

```java
private String returnPathColumnName
```

差し戻し先アドレスのカラム名

---

### mailBodyColumnName

```java
private String mailBodyColumnName
```

メール本文のカラム名

---

### charsetColumnName

```java
private String charsetColumnName
```

charsetのカラム名

---

### statusColumnName

```java
private String statusColumnName
```

ステータスのカラム名

---

### requestDateTimeColumnName

```java
private String requestDateTimeColumnName
```

リクエスト要求日時のカラム名

---

### sendDateTimeColumnName

```java
private String sendDateTimeColumnName
```

送信日時のカラム名

---

### mailSendPatternIdColumnName

```java
private String mailSendPatternIdColumnName
```

メール送信パターンIDカラム名

---

### sendProcessIdColumnName

```java
private String sendProcessIdColumnName
```

メール送信バッチのプロセスIDのカラム名

---

### insertSql

```java
private String insertSql
```

メール送信要求を登録するSQL

---

### countUnsentSql

```java
private String countUnsentSql
```

未送信のメール送信要求の件数を取得するSQL

---

### selectUnsentSql

```java
private String selectUnsentSql
```

未送信のメール送信要求を取得するSQL

---

### updateStatusSql

```java
private String updateStatusSql
```

メール送信要求のステータスを更新するSQL

---

### updateFailureStatusSql

```java
private String updateFailureStatusSql
```

メール送信失敗時のステータスを更新するSQL

---

### updateSendProcessIdSql

```java
private String updateSendProcessIdSql
```

メール送信バッチのプロセスIDを更新するSQL

---

### mailConfig

```java
private MailConfig mailConfig
```

メール関連のコード値を保持するデータオブジェクト

---

## メソッドの詳細

### setTableName

```java
public void setTableName(String tableName)
```

メール送信要求管理テーブルの名前を設定する。

**パラメータ:**
- `tableName` - メール送信要求管理テーブルの名前

---

### setMailRequestIdColumnName

```java
public void setMailRequestIdColumnName(String mailRequestIdColumnName)
```

メール送信要求管理テーブルの要求IDカラムの名前を設定する。

**パラメータ:**
- `mailRequestIdColumnName` - メール送信要求管理テーブルの要求IDカラムの名前

---

### setSubjectColumnName

```java
public void setSubjectColumnName(String subjectColumnName)
```

メール送信要求管理テーブルの件名カラムの名前を設定する。

**パラメータ:**
- `subjectColumnName` - メール送信要求管理テーブルの件名カラムの名前

---

### setFromColumnName

```java
public void setFromColumnName(String fromColumnName)
```

メール送信要求管理テーブルの送信者メールアドレスカラムの名前を設定する。

**パラメータ:**
- `fromColumnName` - メール送信要求管理テーブルの送信者メールアドレスカラムの名前

---

### setReplyToColumnName

```java
public void setReplyToColumnName(String replyColumnName)
```

メール送信要求管理テーブルの返信先メールアドレスカラムの名前を設定する。

**パラメータ:**
- `replyColumnName` - メール送信要求管理テーブルの返信先メールアドレスカラムの名前

---

### setReturnPathColumnName

```java
public void setReturnPathColumnName(String returnPathColumnName)
```

メール送信要求管理テーブルの差し戻し先メールアドレスカラムの名前を設定する。

**パラメータ:**
- `returnPathColumnName` - メール送信要求管理テーブルの差し戻し先メールアドレスカラムの名前

---

### setMailBodyColumnName

```java
public void setMailBodyColumnName(String mailBodyColumnName)
```

メール送信要求管理テーブルの本文カラムの名前を設定する。

**パラメータ:**
- `mailBodyColumnName` - メール送信要求管理テーブルの本文カラムの名前

---

### setCharsetColumnName

```java
public void setCharsetColumnName(String charsetColumnName)
```

メール送信要求管理テーブルの文字セットカラムの名前を設定する。

**パラメータ:**
- `charsetColumnName` - メール送信要求管理テーブルの文字セットカラムの名前

---

### setStatusColumnName

```java
public void setStatusColumnName(String statusColumnName)
```

メール送信要求管理テーブルのステータスカラムの名前を設定する。

**パラメータ:**
- `statusColumnName` - メール送信要求管理テーブルのステータスカラムの名前

---

### setRequestDateTimeColumnName

```java
public void setRequestDateTimeColumnName(String requestDateTimeColumnName)
```

メール送信要求管理テーブルの要求日時カラムの名前を設定する。

**パラメータ:**
- `requestDateTimeColumnName` - メール送信要求管理テーブルの要求日時カラムの名前

---

### setSendDateTimeColumnName

```java
public void setSendDateTimeColumnName(String sendDateTimeColumnName)
```

メール送信要求管理テーブルの送信日時カラムの名前を設定する。

**パラメータ:**
- `sendDateTimeColumnName` - メール送信要求管理テーブルの送信日時カラムの名前

---

### setMailSendPatternIdColumnName

```java
public void setMailSendPatternIdColumnName(String mailSendPatternIdColumnName)
```

メール送信要求管理テーブルのメール送信パターンIDをのカラム名を設定する。

**パラメータ:**
- `mailSendPatternIdColumnName` - メール送信要求管理テーブルのメール送信パターンIDのカラム名

---

### setSendProcessIdColumnName

```java
public void setSendProcessIdColumnName(String sendProcessIdColumnName)
```

送信するバッチのプロセスIDのカラム名を設定する。

**パラメータ:**
- `sendProcessIdColumnName` - 送信するバッチのプロセスIDのカラム名

---

### setMailConfig

```java
public void setMailConfig(MailConfig mailConfig)
```

メール関連のコード値を保持するデータオブジェクトを設定する。

**パラメータ:**
- `mailConfig` - メール関連のコード値を保持するデータオブジェクト

---

### insert

```java
public void insert(String mailRequestId, MailContext context)
```

メール送信要求管理テーブルにレコードを登録する。

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `context` - メール送信要求情報

---

### insert

```java
public void insert(String mailRequestId, MailContext context, String transactionName)
```

指定されたトランザクション名を用いてメール送信要求管理テーブルにレコードを登録する。

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `context` - メール送信要求情報
- `transactionName` - トランザクション名

---

### executeInsertSQL

```java
private void executeInsertSQL(String mailRequestId, MailContext context, MailConfig mailConfig, AppDbConnection connection)
```

メール送信要求管理テーブルにレコードを登録する。

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `context` - メール送信先情報を持つオブジェクト
- `mailConfig` - メールの設定情報を持つオブジェクト
- `connection` - コネクション

---

### getTargetCount

```java
public int getTargetCount(String mailRequestPatternId)
```

処理対象件数を取得する。
<p/>
本クラスのスキーマ設定にメール送信パターンIDを設定した場合には、
処理対象のメール送信パターンIDの設定が必須となる。
スキーマ定義にメール送信パターンIDが設定されているのに、
処理対象のメール送信パターンIDが設定されていない場合にはSQL実行時エラーとなる。

**パラメータ:**
- `mailRequestPatternId` - 処理対象のメール送信パターンID

**戻り値:**
処理対象件数

---

### createReaderStatement

```java
public SqlPStatement createReaderStatement(String mailSendPatternId)
```

処理対象データを取得する{@link SqlPStatement}を生成する。

**パラメータ:**
- `mailSendPatternId` - メール送信パターンID

**戻り値:**
処理対象データを取得するステートメント

---

### createReaderStatement

```java
public SqlPStatement createReaderStatement(String mailSendPatternId, String sendProcessId)
```

処理対象データを取得する{@link SqlPStatement}を生成する。

**パラメータ:**
- `mailSendPatternId` - メール送信パターンID
- `sendProcessId` - メール送信バッチのプロセスID

**戻り値:**
処理対象データを取得するステートメント

---

### updateStatus

```java
public void updateStatus(String mailRequestId, String status)
```

ステータスを更新する。
<p/>
指定されたメールリクエストIDに紐付くレコードのステータスを指定された値に更新する。

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `status` - ステータス

---

### updateFailureStatus

```java
public void updateFailureStatus(String mailRequestId, String status)
```

ステータスを更新する。
<p/>
指定されたメールリクエストIDに紐付くレコードのステータスを指定された値に更新する。

**パラメータ:**
- `mailRequestId` - メールリクエストID
- `status` - ステータス

---

### updateSendProcessId

```java
public void updateSendProcessId(String mailSendPatternId, String sendProcessId)
```

メール送信バッチのプロセスIDを更新する。<p/>
マルチプロセス用の設定がされている場合のみ更新し、
別トランザクションで実行する。

**パラメータ:**
- `mailSendPatternId` - メール送信パターンID
- `sendProcessId` - 更新するメール送信バッチのプロセスID

---

### getMailRequest

```java
public MailRequestTable.MailRequest getMailRequest(SqlRow data)
```

SQLの取得結果の1レコードをMailRequestTable.MailRequestに変換する。

**パラメータ:**
- `data` - メール送信要求1レコード

**戻り値:**
メール送信要求

---

### initialize

```java
public void initialize()
```

SQLを初期化する。

---

### createSelectUnsentSql

```java
private String createSelectUnsentSql()
```

未処理データを取得するためのSELECT文を生成する。

**戻り値:**
未処理データを取得するためのSQL文

---

### createCountUnsentSql

```java
private String createCountUnsentSql()
```

未処理の件数を取得するためのSELECT文を取得する。

**戻り値:**
生成したSELECT文

---

### createUpdateStatus

```java
private String createUpdateStatus()
```

ステータスと送信日時を更新するSQL文を生成する。

**戻り値:**
ステータスと送信日時を更新するSQL文

---

### createUpdateFailureStatusSql

```java
private String createUpdateFailureStatusSql()
```

ステータスのみを更新するSQL文を生成する。
<p/>
障害などで、ステータスを送信失敗に更新する用途で使用する。

**戻り値:**
ステータスを更新する（障害用）SQL文

---

### createInsertSql

```java
private String createInsertSql()
```

レコードを登録するためのINSERT文を生成する。

**戻り値:**
生成したINSERT文

---

### createUpdateSendProcessIdSql

```java
private String createUpdateSendProcessIdSql()
```

未処理データのメール送信バッチのプロセスIDを更新するSQLを生成する。

**戻り値:**
未処理データのメール送信バッチのプロセスIDを更新するSQL

---
