# class MailConfig

**パッケージ:** nablarch.common.mail

---

```java
public class MailConfig
```

出力ライブラリ(メール送信)のコード値を保持するデータオブジェクト。

**作成者:** Shinsuke Yoshio  

---

## フィールドの詳細

### mailRequestSbnId

```java
private String mailRequestSbnId
```

メール送信要求IDの採番対象識別ID

---

### recipientTypeTO

```java
private String recipientTypeTO
```

メール送信区分(TO)

---

### recipientTypeCC

```java
private String recipientTypeCC
```

メール送信区分(CC)

---

### recipientTypeBCC

```java
private String recipientTypeBCC
```

メール送信区分(BCC)

---

### statusUnsent

```java
private String statusUnsent
```

メール送信ステータス（未送信）

---

### statusSent

```java
private String statusSent
```

メール送信ステータス（送信済）

---

### statusFailure

```java
private String statusFailure
```

メール送信ステータス（送信失敗）

---

### mailRequestCountMessageId

```java
private String mailRequestCountMessageId
```

メール送信要求件数出力時のメッセージID

---

### sendSuccessMessageId

```java
private String sendSuccessMessageId
```

メール送信成功時のメッセージID

---

### sendFailureCode

```java
private String sendFailureCode
```

メール送信失敗時の障害コード

---

### abnormalEndExitCode

```java
private int abnormalEndExitCode
```

異常終了時のリターンコード

---

## メソッドの詳細

### getMailRequestSbnId

```java
public String getMailRequestSbnId()
```

メール送信要求IDの採番対象識別IDを取得する。

**戻り値:**
メール送信要求IDの採番対象識別ID

---

### setMailRequestSbnId

```java
public void setMailRequestSbnId(String mailRequestSbnId)
```

メール送信要求IDの採番対象識別IDを設定する。

**パラメータ:**
- `mailRequestSbnId` - メール送信要求IDの採番対象識別ID

---

### getRecipientTypeTO

```java
public String getRecipientTypeTO()
```

メール送信区分(TO)のコード値を取得する。

**戻り値:**
メール送信区分(TO)のコード値

---

### setRecipientTypeTO

```java
public void setRecipientTypeTO(String recipientTypeTO)
```

メール送信区分(TO)のコード値を設定する。

**パラメータ:**
- `recipientTypeTO` - メール送信区分(TO)のコード値

---

### getRecipientTypeCC

```java
public String getRecipientTypeCC()
```

メール送信区分(CC)のコード値を取得する。

**戻り値:**
メール送信区分(CC)のコード値

---

### setRecipientTypeCC

```java
public void setRecipientTypeCC(String recipientTypeCC)
```

メール送信区分(CC)のコード値を設定する。

**パラメータ:**
- `recipientTypeCC` - メール送信区分(CC)のコード値

---

### getRecipientTypeBCC

```java
public String getRecipientTypeBCC()
```

メール送信区分(BCC)のコード値を取得する。

**戻り値:**
メール送信区分(BCC)のコード値

---

### setRecipientTypeBCC

```java
public void setRecipientTypeBCC(String recipientTypeBCC)
```

メール送信区分(BCC)のコード値を設定する。

**パラメータ:**
- `recipientTypeBCC` - メール送信区分(BCC)のコード値

---

### getStatusUnsent

```java
public String getStatusUnsent()
```

メール送信ステータス（未送信）のコード値を取得する。

**戻り値:**
メール送信ステータス（未送信）

---

### setStatusUnsent

```java
public void setStatusUnsent(String statusUnsent)
```

メール送信ステータス（未送信）のコード値を設定する。

**パラメータ:**
- `statusUnsent` - メール送信ステータス（未送信）のコード値

---

### getStatusSent

```java
public String getStatusSent()
```

メール送信ステータス（送信済）のコード値を取得する。

**戻り値:**
メール送信ステータス（送信済）のコード値

---

### setStatusSent

```java
public void setStatusSent(String statusSent)
```

メール送信ステータス（送信済）のコード値を設定する。

**パラメータ:**
- `statusSent` - メール送信ステータス（送信済）のコード値

---

### getStatusFailure

```java
public String getStatusFailure()
```

メール送信ステータス（送信失敗）のコード値を取得する。

**戻り値:**
メール送信ステータス（送信失敗）のコード値

---

### setStatusFailure

```java
public void setStatusFailure(String statusFailure)
```

メール送信ステータス（送信失敗）のコード値を設定する。

**パラメータ:**
- `statusFailure` - メール送信ステータス（送信失敗）のコード値

---

### getSendFailureCode

```java
public String getSendFailureCode()
```

送信失敗時の障害コードを取得する。

**戻り値:**
送信失敗時の障害コード

---

### getSendSuccessMessageId

```java
public String getSendSuccessMessageId()
```

メール送信成功時のメッセージIDを取得する。

**戻り値:**
メール送信成功時のメッセージID

---

### setSendSuccessMessageId

```java
public void setSendSuccessMessageId(String sendSuccessMessageId)
```

メール送信成功時のメッセージIDを設定する。

<pre>
ログ出力時に、メール送信要求IDが渡されるため、
メッセージテーブルにこのメッセージIDに対応する以下のようなメッセージを登録すれば、
メール送信要求IDをログに含めることが出来る。

メッセージ例）”メールを送信しました。 mailRequestId=[{0}]”
</pre>

**パラメータ:**
- `sendSuccessMessageId` - メール送信成功時のメッセージID

---

### getMailRequestCountMessageId

```java
public String getMailRequestCountMessageId()
```

メール送信要求件数出力時のメッセージIDを取得する。

**戻り値:**
メール送信要求件数出力時のメッセージID

---

### setMailRequestCountMessageId

```java
public void setMailRequestCountMessageId(String mailRequestCountMessageId)
```

メール送信要求件数出力時のメッセージIDを設定する。 *

<pre>
ログ出力時に、メール送信要求の件数が渡されるため、
メッセージテーブルにこのメッセージIDに対応する以下のようなメッセージを登録すれば、
メール送信要求の件数をログに含めることが出来る。

メッセージ例）”メール送信要求が {0} 件あります。”
</pre>

**パラメータ:**
- `mailRequestCountMessageId` - メール送信要求件数出力時のメッセージID

---

### setSendFailureCode

```java
public void setSendFailureCode(String sendFailureCode)
```

送信失敗時の障害コードを設定する。

<pre>
ログ出力時に、メール送信要求IDが渡されるため、
メッセージテーブルにこの障害コードに対応する以下のようなメッセージを登録すれば、
メール送信要求IDをログに含めることが出来る。

メッセージ例）”メール送信に失敗しました。 mailRequestId=[{0}]”
</pre>

**パラメータ:**
- `sendFailureCode` - 送信失敗時の障害コード

---

### getAbnormalEndExitCode

```java
public int getAbnormalEndExitCode()
```

送信失敗時の終了コードを取得する。

**戻り値:**
送信失敗時の終了コード

---

### setAbnormalEndExitCode

```java
public void setAbnormalEndExitCode(int abnormalEndExitCode)
```

送信失敗時の終了コードを設定する。

**パラメータ:**
- `abnormalEndExitCode` - 送信失敗時の終了コード

---
