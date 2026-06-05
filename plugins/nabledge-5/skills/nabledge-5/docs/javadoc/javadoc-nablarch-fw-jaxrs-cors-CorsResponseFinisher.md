# class CorsResponseFinisher

**パッケージ:** nablarch.fw.jaxrs.cors

**実装されたインタフェース:**
- ResponseFinisher

---

```java
public class CorsResponseFinisher
implements ResponseFinisher
```

実際のリクエストに対するレスポンスにCORSのレスポンスヘッダを設定するクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### cors

```java
private Cors cors
```

---

## メソッドの詳細

### finish

```java
public void finish(HttpRequest request, HttpResponse response, ExecutionContext context)
```

---

### setCors

```java
public void setCors(Cors cors)
```

CORSの処理を行うインタフェースを設定する。

**パラメータ:**
- `cors` - CORSの処理を行うインタフェース

---
