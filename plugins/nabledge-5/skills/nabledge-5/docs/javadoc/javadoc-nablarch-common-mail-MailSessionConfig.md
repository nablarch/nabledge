# class MailSessionConfig

**パッケージ:** nablarch.common.mail

---

```java
public class MailSessionConfig
```

メール送信用設定値を保持するデータオブジェクト。

**作成者:** Shinsuke Yoshio  

---

## フィールドの詳細

### mailSmtpHost

```java
private String mailSmtpHost
```

接続先SMTPサーバー

---

### mailHost

```java
private String mailHost
```

ホスト名。 Message-IDヘッダ生成時に、ドメイン名として使用される。

---

### mailSmtpPort

```java
private String mailSmtpPort
```

SMTPポート

---

### mailSmtpConnectionTimeout

```java
private String mailSmtpConnectionTimeout
```

接続タイムアウト値

---

### mailSmtpTimeout

```java
private String mailSmtpTimeout
```

送信タイムアウト値

---

### option

```java
private Map<String,String> option
```

その他javax.mail.Sessionのオプション

---

## メソッドの詳細

### getMailSmtpHost

```java
public String getMailSmtpHost()
```

SMTPサーバー名を取得する。

**戻り値:**
SMTPサーバー名

---

### setMailSmtpHost

```java
public void setMailSmtpHost(String mailSmtpHost)
```

SMTPサーバー名を設定する。

**パラメータ:**
- `mailSmtpHost` - SMTPサーバー名

---

### getMailHost

```java
public String getMailHost()
```

接続ホスト名を取得する。

**戻り値:**
接続ホスト名

---

### setMailHost

```java
public void setMailHost(String mailHost)
```

接続ホスト名を設定する。

**パラメータ:**
- `mailHost` - 接続ホスト名

---

### getMailSmtpPort

```java
public String getMailSmtpPort()
```

SMTPポートを取得する。

**戻り値:**
SMTPポート

---

### setMailSmtpPort

```java
public void setMailSmtpPort(String mailSmtpPort)
```

SMTPポートを設定する。

**パラメータ:**
- `mailSmtpPort` - SMTPポート

---

### getMailSmtpConnectionTimeout

```java
public String getMailSmtpConnectionTimeout()
```

接続タイムアウト値を取得する。

**戻り値:**
接続タイムアウト値

---

### setMailSmtpConnectionTimeout

```java
public void setMailSmtpConnectionTimeout(String mailSmtpConnectionTimeout)
```

接続タイムアウト値を設定する。

**パラメータ:**
- `mailSmtpConnectionTimeout` - 接続タイムアウト値

---

### getMailSmtpTimeout

```java
public String getMailSmtpTimeout()
```

送信タイムアウト値を取得する。

**戻り値:**
送信タイムアウト値

---

### setMailSmtpTimeout

```java
public void setMailSmtpTimeout(String mailSmtpTimeout)
```

送信タイムアウト値を設定する。

**パラメータ:**
- `mailSmtpTimeout` - 送信タイムアウト値

---

### getOption

```java
public Map<String,String> getOption()
```

javax.mail.Sessionのオプションを取得する。

**戻り値:**
javax.mail.Sessionのオプション

---

### setOption

```java
public void setOption(Map<String,String> option)
```

その他のjavax.mail.Sessionのオプションを設定する。

**パラメータ:**
- `option` - オプション名と値のMap

---
