# class MailRequester

**パッケージ:** nablarch.common.mail

---

```java
public class MailRequester
```

メール送信要求を行うクラス。
<p/>
本クラスのメール送信要求メソッドを呼び出すことで、メール送信要求を管理用テーブル群にINSERTできる。
<p/>
メール送信要求の種類について<br>
メール送信要求は以下の二種類がある。
<ul>
    <li>定型メール送信({@link TemplateMailContext})。
        予めデータベースに登録されたテンプレートを元にメールを作成・送信する。</li>
    <li>非定型メール送信({@link FreeTextMailContext})。任意の件名・本文でメールを作成・送信する。</li>
</ul>
メールの送信単位<br>
メール送信要求はメール送信要求APIの呼び出し毎に一つ作成さる。一つのメール送信要求につき一通のメールが送信される。

**作成者:** Shinsuke Yoshio  
**関連項目:** MailUtil#getMailRequester()  

---

## フィールドの詳細

### mailRequestConfig

```java
private MailRequestConfig mailRequestConfig
```

メール共通設定を保持するデータオブジェクト

---

### mailConfig

```java
private MailConfig mailConfig
```

メール関連のコード値を保持するデータオブジェクト

---

### mailRequestIdGenerator

```java
private IdGenerator mailRequestIdGenerator
```

メール送信要求IDジェネレータ

---

### mailRequestTable

```java
private MailRequestTable mailRequestTable
```

メール要求管理テーブルのスキーマ情報

---

### mailRecipientTable

```java
private MailRecipientTable mailRecipientTable
```

メール送信先管理テーブルのスキーマ情報

---

### mailAttachedFileTable

```java
private MailAttachedFileTable mailAttachedFileTable
```

添付ファイル管理テーブルのスキーマ情報

---

### mailTransactionManager

```java
private SimpleDbTransactionManager mailTransactionManager
```

メール送信時のDB登録に利用するトランザクションマネージャ

---

### templateEngineMailProcessor

```java
private TemplateEngineMailProcessor templateEngineMailProcessor
```

定型メールの件名と本文を構築するテンプレートエンジン処理クラス

---

### templateEngineContextPreparer

```java
private final TemplateEngineContextPreparer templateEngineContextPreparer
```

テンプレートエンジンを使用して件名と本文の準備をするクラス

---

## メソッドの詳細

### requestToSend

```java
public String requestToSend(FreeTextMailContext ctx)
                     throws AttachedFileSizeOverException, RecipientCountException
```

非定型メールの送信要求を行う。

**パラメータ:**
- `ctx` - 非定型メール送信要求

**戻り値:**
メール送信要求ID

**例外:**
- `AttachedFileSizeOverException` - 添付ファイルのサイズが上限値を超えた場合
- `RecipientCountException` - 宛先数が上限値を超えた場合

---

### requestToSend

```java
public String requestToSend(TemplateMailContext ctx)
                     throws AttachedFileSizeOverException, RecipientCountException
```

定型メールの送信要求を行う。

**パラメータ:**
- `ctx` - 定型メール送信要求

**戻り値:**
メール送信要求ID

**例外:**
- `AttachedFileSizeOverException` - 添付ファイルのサイズが上限値を超えた場合
- `RecipientCountException` - 宛先数が上限値を超えた場合

---

### sendMail

```java
private String sendMail(MailContext ctx)
```

メール送信要求処理

**パラメータ:**
- `ctx` - メール送信要求

**戻り値:**
メール送信要求ID

---

### setupMailWithTransactionName

```java
private String setupMailWithTransactionName(MailContext ctx, String transactionName)
```

メール送信要求IDの採番、送信DBへの登録処理

**パラメータ:**
- `ctx` - メール送信要求
- `transactionName` - トランザクション名

**戻り値:**
メール送信要求ID

---

### setupMail

```java
private String setupMail(MailContext ctx)
```

メール送信要求IDの採番、送信DBへの登録処理

**パラメータ:**
- `ctx` - メール送信要求

**戻り値:**
メール送信要求ID

---

### setMailRequestConfig

```java
public void setMailRequestConfig(MailRequestConfig mailRequestConfig)
```

メール送信要求共通設定を保持するデータオブジェクトを設定する。

**パラメータ:**
- `mailRequestConfig` - メール送信要求共通設定を保持するデータオブジェクト

---

### setMailConfig

```java
public void setMailConfig(MailConfig mailConfig)
```

メール関連のコード値を保持するデータオブジェクトを設定する。

**パラメータ:**
- `mailConfig` - メール関連のコード値を保持するデータオブジェクト

---

### setMailRequestIdGenerator

```java
public void setMailRequestIdGenerator(IdGenerator mailRequestIdGenerator)
```

メール送信要求IDジェネレータを設定する。

**パラメータ:**
- `mailRequestIdGenerator` - メール送信要求IDジェネレータ

---

### setMailRequestTable

```java
public void setMailRequestTable(MailRequestTable mailRequestTable)
```

mailSendRequestTable メール送信要求管理テーブルのスキーマ情報を設定する。

**パラメータ:**
- `mailRequestTable` - メール送信要求管理テーブルのスキーマ。

---

### setMailRecipientTable

```java
public void setMailRecipientTable(MailRecipientTable mailRecipientTable)
```

メール送信先管理テーブルのスキーマ情報を設定する。

**パラメータ:**
- `mailRecipientTable` - メール送信先管理テーブルのスキーマ情報

---

### setMailAttachedFileTable

```java
public void setMailAttachedFileTable(MailAttachedFileTable mailAttachedFileTable)
```

添付ファイル管理テーブルのスキーマ情報を設定する。

**パラメータ:**
- `mailAttachedFileTable` - 添付ファイル管理テーブルのスキーマ情報

---

### setMailTransactionManager

```java
public void setMailTransactionManager(SimpleDbTransactionManager mailTransactionManager)
```

メール送信時に利用するトランザクションマネージャを設定する。

**パラメータ:**
- `mailTransactionManager` - トランザクションマネージャ

---

### setTemplateEngineMailProcessor

```java
public void setTemplateEngineMailProcessor(TemplateEngineMailProcessor templateEngineMailProcessor)
```

定型メールの件名と本文を構築するテンプレートエンジン処理クラスを設定する。

**パラメータ:**
- `templateEngineMailProcessor` - 定型メールの件名と本文を構築するテンプレートエンジン処理クラス

---
