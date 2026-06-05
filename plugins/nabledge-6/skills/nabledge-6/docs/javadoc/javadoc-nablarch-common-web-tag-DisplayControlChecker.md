# interface DisplayControlChecker

**パッケージ:** nablarch.common.web.tag

---

```java
public interface DisplayControlChecker
```

サブミットを行うタグの表示制御が必要か否かを判定するインタフェース。

**作成者:** Tomokazu Kagawa  

---

## メソッドの詳細

### needsDisplayControl

```java
boolean needsDisplayControl(String requestId)
```

表示制御を行う必要があるか否かを判定する。

**パラメータ:**
- `requestId` - 該当のタグのサブミット先リクエストID

**戻り値:**
表示制御を行う必要がある場合は、{@code true}

---
