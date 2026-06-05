# class MailSender

**パッケージ:** nablarch.common.mail

**継承階層:**
```
java.lang.Object
  └─ BatchAction<SqlRow>
      └─ nablarch.common.mail.MailSender
```

---

```java
public class MailSender
extends BatchAction<SqlRow>
```

メール送信要求管理テーブル上の各レコードごとにメール送信を行うバッチアクション。

**作成者:** Shinsuke Yoshio  

---

## フィールドの詳細

### SYSTEM_REPOSITORY_KEY_MAIL_CONFIG

```java
private static final String SYSTEM_REPOSITORY_KEY_MAIL_CONFIG
```

システムリポジトリ用のキー定数

---

### SYSTEM_REPOSITORY_KEY_MAIL_SESSION_CONFIG

```java
private static final String SYSTEM_REPOSITORY_KEY_MAIL_SESSION_CONFIG
```

システムリポジトリ用のキー定数

---

### SYSTEM_REPOSITORY_KEY_MAIL_ATTACHED_FILE_TABLE

```java
private static final String SYSTEM_REPOSITORY_KEY_MAIL_ATTACHED_FILE_TABLE
```

システムリポジトリ用のキー定数

---

### SYSTEM_REPOSITORY_KEY_MAIL_RECIPIENT_TABLE

```java
private static final String SYSTEM_REPOSITORY_KEY_MAIL_RECIPIENT_TABLE
```

システムリポジトリ用のキー定数

---

### SYSTEM_REPOSITORY_KEY_MAIL_REQUEST_TABLE

```java
private static final String SYSTEM_REPOSITORY_KEY_MAIL_REQUEST_TABLE
```

システムリポジトリ用のキー定数

---

### processId

```java
private final String processId
```

メール送信バッチを識別するプロセスID

---

### LOGGER

```java
private final Logger LOGGER
```

ロガー

---

## コンストラクタの詳細

### MailSender

```java
public MailSender()
```

コンストラクタ。

---

## メソッドの詳細

### handle

```java
public Result handle(SqlRow data, ExecutionContext context)
```

メール送信要求を元にメールを送信する。

**パラメータ:**
- `data` - 入力データ（メール送信要求のレコード）
- `context` - 実行コンテキスト

**戻り値:**
処理結果

---

### handleException

```java
protected Result handleException(SqlRow data, ExecutionContext context, MailRequestTable.MailRequest mailRequest, MailConfig mailConfig, Exception e)
```

メール送信時の例外のハンドル処理を行う。
<p/>
本クラスでは、障害ログを出力し、送信ステータスを送信失敗にしてリトライを行う。
本メソッドでは、すべての例外をリトライ対象として{@link SendMailRetryableException}を送出している。
独自の処理を実施したい場合は本メソッドをオーバーライドすることで行うことができる。

**パラメータ:**
- `data` - 入力データ（メール送信要求のレコード）
- `context` - 実行コンテキスト
- `mailRequest` - メール送信要求
- `mailConfig` - メール設定
- `e` - メール送信時の例外

**戻り値:**
{@link #handle(SqlRow, ExecutionContext)} が返す処理結果

---

### writeSendMailFailedLog

```java
protected void writeSendMailFailedLog(SqlRow data, MailRequestTable.MailRequest mailRequest, MailConfig mailConfig, SendFailedException e)
```

メール送信失敗時の{@link SendFailedException}例外の障害検知ログに出力する。
<p/>
メール送信失敗時に、独自の処理を実施したい場合は本メソッドをオーバーライドすることで行うことができる。

**パラメータ:**
- `data` - 入力データ（メール送信要求のレコード）
- `mailRequest` - メール送信要求
- `mailConfig` - メール設定
- `e` - メール送信失敗時の{@link SendFailedException}例外

---

### createStringFromAddresses

```java
private static String createStringFromAddresses(Address[] addresses)
```

メールアドレスの配列を文字列にする。

**パラメータ:**
- `addresses` - メールアドレスの配列

**戻り値:**
メールアドレスをカンマで連結した文字列

---

### writeCreateMailFailedLog

```java
protected void writeCreateMailFailedLog(SqlRow data, MailRequestTable.MailRequest mailRequest, MailConfig mailConfig, MessagingException e)
```

メール作成が失敗した場合に、障害検知ログに出力する。
<p/>
メール作成が失敗した時に、独自の処理を実施したい場合は本メソッドをオーバーライドすることで行うことができる。

**パラメータ:**
- `data` - 入力データ（メール送信要求のレコード）
- `mailRequest` - メール送信要求
- `mailConfig` - メール設定
- `e` - {@link MessagingException}

---

### createTransactionAbnormalEnd

```java
private TransactionAbnormalEnd createTransactionAbnormalEnd(MailRequestTable.MailRequest mailRequest, MailConfig mailConfig, MessagingException e)
```

メール送信時に送信失敗を表す{@link MessagingException}が発生した場合のトランザクションの異常終了例外を生成して返す。

**パラメータ:**
- `mailRequest` - メール送信要求
- `mailConfig` - メール設定
- `e` - メール送信時のMessagingException

**戻り値:**
業務トランザクションの異常終了例外

---

### createMimeMessage

```java
protected MimeMessage createMimeMessage(SqlRow data, String mailRequestId, MailRequestTable.MailRequest mailRequest, Session session, MailRecipientTable mailRecipientTable)
                              throws MessagingException
```

メールデータを作成する。

**パラメータ:**
- `data` - 入力データ（メール送信要求のレコード）
- `mailRequestId` - メール送信要求ID
- `mailRequest` - メール送信先情報
- `session` - メールセッション
- `mailRecipientTable` - メール送信先管理テーブルのスキーマ

**戻り値:**
メールデータ

**例外:**
- `MessagingException` - メールメッセージの生成に失敗した場合

---

### addBodyContent

```java
protected void addBodyContent(MimeMessage mimeMessage, MailRequestTable.MailRequest mailRequest, List<? extends MailAttachedFileTable.MailAttachedFile> attachedFiles, ExecutionContext context)
                    throws MessagingException
```

指定された{@link MimeMessage}にメールメッセージ本文（添付ファイル含む）を追加する。
<p/>
メッセージ本文を暗号化する場合や、電子署名を付加する場合には本メソッドをオーバライドし処理を本文の追加処理を変更すること。

**パラメータ:**
- `mimeMessage` - {@link MimeMessage}
- `mailRequest` - メール送信要求管理の情報
- `attachedFiles` - 添付ファイルの情報
- `context` - 実行コンテキスト

**例外:**
- `MessagingException` - メールメッセージの生成に失敗した場合

---

### createMailSession

```java
private Session createMailSession(String returnPath, MailSessionConfig mailSenderConfig)
```

java.mail.Sessionオブジェクトを取得する。<br />
メールヘッダのReturn-Pathに設定される mail.smtp.from のみ引数として指定する。<br />
それ以外は、設定ファイルから読み込む。

**パラメータ:**
- `returnPath` - 差し戻し先メールアドレス。
- `mailSenderConfig` - メール送信用設定値

**戻り値:**
メールセッション

---

### getAddresses

```java
private InternetAddress[] getAddresses(MailRequestTable.MailRequest mailRequest, String recipientType, MailRecipientTable mailRecipientTable, List<String> errorAddresses)
```

指定したメール送信要求IDと送信先区分に紐付くメールアドレスの配列を取得する。

**パラメータ:**
- `mailRequest` - メール送信要求
- `recipientType` - 宛先区分
- `mailRecipientTable` - 宛先メールアドレスの配列
- `errorAddresses` - 生成に失敗したアドレスのリスト

**戻り値:**
メールアドレスの配列

---

### createInternetAddress

```java
private InternetAddress createInternetAddress(String address, MailRequestTable.MailRequest mailRequest)
```

メールアドレスを生成する。{@link AddressException}が発生した場合は、ログを出力しnullを返す。

**パラメータ:**
- `address` - メールアドレスの元となる文字列
- `mailRequest` - メール送信要求

**戻り値:**
生成したメールアドレス

---

### containsInvalidCharacter

```java
protected void containsInvalidCharacter(String target, String mailRequestId)
                              throws InvalidCharacterException
```

メールヘッダ・インジェクションチェック<br />
チェック対象文字列に\rもしくは\nを含んでいるかのチェック。
<p/>
チェック内容を変更する場合や、チェック結果の振る舞いを変更する場合には本メソッドをオーバライドし処理をチェック処理を変更すること。

**パラメータ:**
- `target` - チェック対象文字列
- `mailRequestId` - メール送信要求ID

**例外:**
- `InvalidCharacterException` - チェック対象文字列に\rもしくは\nを含んでいた場合

---

### createReader

```java
public DataReader<SqlRow> createReader(ExecutionContext ctx)
```

{@inheritDoc} メール送信要求を読み込む{@link DatabaseRecordReader}を生成する。

---

### updateToFailed

```java
protected void updateToFailed(SqlRow data, ExecutionContext context)
```

処理ステータスを異常終了に更新する。
<p/>
更新時に例外が発生した場合は、{@link ProcessAbnormalEnd}を送出する。

**パラメータ:**
- `data` - 送信対象データ
- `context` - 実行コンテキスト

---

### updateToSuccess

```java
protected void updateToSuccess(SqlRow data, ExecutionContext context)
```

処理ステータスを正常終了に更新する。

**パラメータ:**
- `data` - 送信対象データ
- `context` - 実行コンテキスト

---
