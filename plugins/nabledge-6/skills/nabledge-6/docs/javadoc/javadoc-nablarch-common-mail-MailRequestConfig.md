# class MailRequestConfig

**パッケージ:** nablarch.common.mail

---

```java
public class MailRequestConfig
```

メールのデフォルト設定を保持するデータオブジェクト。

**作成者:** Shinsuke Yoshio  

---

## フィールドの詳細

### defaultReplyTo

```java
private String defaultReplyTo
```

デフォルトの返信先メールアドレス

---

### defaultReturnPath

```java
private String defaultReturnPath
```

デフォルトの差し戻し先メールアドレス

---

### defaultCharset

```java
private String defaultCharset
```

デフォルトの文字セット

---

### maxRecipientCount

```java
private int maxRecipientCount
```

最大宛先数

---

### maxAttachedFileSize

```java
private int maxAttachedFileSize
```

最大添付ファイルサイズ

---

## メソッドの詳細

### getDefaultReplyTo

```java
public String getDefaultReplyTo()
```

デフォルトの返信先メールアドレスを取得する。

**戻り値:**
デフォルトの返信先メールアドレス

---

### setDefaultReplyTo

```java
public void setDefaultReplyTo(String defaultReplyTo)
```

デフォルトの返信先メールアドレスを設定する。

**パラメータ:**
- `defaultReplyTo` - デフォルトの返信先メールアドレス

---

### getDefaultReturnPath

```java
public String getDefaultReturnPath()
```

デフォルトの差し戻し先メールアドレスを取得する。

**戻り値:**
デフォルトの差し戻し先メールアドレス

---

### setDefaultReturnPath

```java
public void setDefaultReturnPath(String defaultReturnPath)
```

デフォルトの差し戻し先メールアドレスを設定する。

**パラメータ:**
- `defaultReturnPath` - デフォルトのメール差し戻し先

---

### getDefaultCharset

```java
public String getDefaultCharset()
```

デフォルトの文字セットを取得する。

**戻り値:**
デフォルトの文字セット

---

### setDefaultCharset

```java
public void setDefaultCharset(String defaultCharset)
```

デフォルトの文字セットを設定する。

**パラメータ:**
- `defaultCharset` - デフォルトの文字セット

---

### getMaxRecipientCount

```java
public int getMaxRecipientCount()
```

最大宛先数を取得する。

**戻り値:**
最大宛先数

---

### setMaxRecipientCount

```java
public void setMaxRecipientCount(int maxRecipientCount)
```

最大宛先数を設定する。

**パラメータ:**
- `maxRecipientCount` - 最大宛先数

---

### getMaxAttachedFileSize

```java
public int getMaxAttachedFileSize()
```

最大添付ファイルサイズを取得する。

**戻り値:**
最大添付ファイルサイズ

---

### setMaxAttachedFileSize

```java
public void setMaxAttachedFileSize(int maxAttachedFileSize)
```

最大添付ファイルサイズを設定する。

**パラメータ:**
- `maxAttachedFileSize` - 最大添付ファイルサイズ

---
