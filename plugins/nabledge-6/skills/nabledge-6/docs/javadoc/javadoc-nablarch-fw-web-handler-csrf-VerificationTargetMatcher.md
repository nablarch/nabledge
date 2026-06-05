# interface VerificationTargetMatcher

**パッケージ:** nablarch.fw.web.handler.csrf

---

```java
public interface VerificationTargetMatcher
```

HTTPリクエストがCSRFトークンの検証対象となるか判定を行うインターフェース。

**作成者:** Uragami Taichi  

---

## メソッドの詳細

### match

```java
boolean match(HttpRequest request)
```

HTTPリクエストがCSRFトークンの検証対象となるか判定を行う。

**パラメータ:**
- `request` - HTTPリクエスト

**戻り値:**
検証対象であればtrue

---
