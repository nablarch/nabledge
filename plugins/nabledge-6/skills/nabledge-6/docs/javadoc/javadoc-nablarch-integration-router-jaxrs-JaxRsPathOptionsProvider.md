# class JaxRsPathOptionsProvider

**パッケージ:** nablarch.integration.router.jaxrs

**実装されたインタフェース:**
- PathOptionsProvider

---

```java
public class JaxRsPathOptionsProvider
implements PathOptionsProvider
```

{@link jakarta.ws.rs.Path} アノテーションが設定されたクラスを探索してルーティング定義を収集するクラス。

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### ORDER_BY_PATH_ASC

```java
private static final Comparator<PathOptions> ORDER_BY_PATH_ASC
```

---

### basePackage

```java
private String basePackage
```

---

### applicationPath

```java
private String applicationPath
```

---

## メソッドの詳細

### provide

```java
public List<PathOptions> provide()
```

---

### setBasePackage

```java
public void setBasePackage(String basePackage)
```

検索ルートとなるパッケージを設定する。

**パラメータ:**
- `basePackage` - 検索ルートとなるパッケージ

---

### setApplicationPath

```java
public void setApplicationPath(String applicationPath)
```

アプリケーションパスを設定する。

**パラメータ:**
- `applicationPath` - アプリケーションパス

---
