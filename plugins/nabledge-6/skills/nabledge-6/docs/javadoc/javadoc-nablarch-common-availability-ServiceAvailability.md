# interface ServiceAvailability

**パッケージ:** nablarch.common.availability

---

```java
public interface ServiceAvailability
```

サービス提供可否状態を判定するインタフェース。

**作成者:** Masayuki Fujikuma  

---

## メソッドの詳細

### isAvailable

```java
boolean isAvailable(String requestId)
```

パラメータのリクエストIDを元に、サービス提供可否状態を判定し結果を返却する。

**パラメータ:**
- `requestId` - リクエストID

**戻り値:**
サービス提供可否状態を表すboolean （提供可の場合、TRUE）

---
