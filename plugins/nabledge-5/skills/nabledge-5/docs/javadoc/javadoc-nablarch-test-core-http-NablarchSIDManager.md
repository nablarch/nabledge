# class NablarchSIDManager

**パッケージ:** nablarch.test.core.http

**継承階層:**
```
java.lang.Object
  └─ RequestResponseCookieManager
      └─ nablarch.test.core.http.NablarchSIDManager
```

---

```java
public class NablarchSIDManager
extends RequestResponseCookieManager
```

セッションストアを引き継ぐためのプロセッサ。
セッションIDをレスポンスの"Set-Cookie"ヘッダーから抽出し
リクエストのCookieとして付加する。

---

## コンストラクタの詳細

### NablarchSIDManager

```java
public NablarchSIDManager()
```

---
