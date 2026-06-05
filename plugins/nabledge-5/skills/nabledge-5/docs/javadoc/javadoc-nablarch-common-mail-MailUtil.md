# class MailUtil

**パッケージ:** nablarch.common.mail

---

```java
public final class MailUtil
```

メール送信ライブラリ関連のユーティリティ。

**作成者:** Shinsuke Yoshio  

---

## フィールドの詳細

### MAIL_REQUESTER_NAME

```java
private static final String MAIL_REQUESTER_NAME
```

リポジトリ上のMailRequesterの名称。

---

## コンストラクタの詳細

### MailUtil

```java
private MailUtil()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### getMailRequester

```java
public static MailRequester getMailRequester()
```

{@link SystemRepository}から{@link MailRequester}オブジェクトを取得する。

**戻り値:**
{@code MailRequester}オブジェクト

**例外:**
- `IllegalArgumentException` - {@code MailRequester}オブジェクトが取得できなかった場合

---
