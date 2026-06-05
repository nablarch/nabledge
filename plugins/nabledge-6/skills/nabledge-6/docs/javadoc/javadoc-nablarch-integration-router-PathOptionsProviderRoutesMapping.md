# class PathOptionsProviderRoutesMapping

**パッケージ:** nablarch.integration.router

**継承階層:**
```
java.lang.Object
  └─ RoutingHandlerSupport
      └─ nablarch.integration.router.PathOptionsProviderRoutesMapping
```

**実装されたインタフェース:**
- Initializable

---

```java
public class PathOptionsProviderRoutesMapping
extends RoutingHandlerSupport
implements Initializable
```

{@link PathOptionsProvider} から取得したルーティング定義をベースにActionメソッドを特定するハンドラ。

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

---

### routeSet

```java
private final RouteSet routeSet
```

---

### baseUri

```java
private String baseUri
```

---

### pathOptionsProvider

```java
private PathOptionsProvider pathOptionsProvider
```

---

### pathOptionsFormatter

```java
private PathOptionsFormatter pathOptionsFormatter
```

---

## メソッドの詳細

### getHandlerClass

```java
protected Class<?> getHandlerClass(HttpRequest request, ExecutionContext executionContext)
                         throws ClassNotFoundException
```

---

### getPath

```java
private String getPath(HttpRequest request, ExecutionContext executionContext)
```

---

### initialize

```java
public void initialize()
```

---

### getBaseUri

```java
public String getBaseUri()
```

ベースURIを取得する。

**戻り値:**
ベースURI

---

### setBaseUri

```java
public void setBaseUri(String baseUri)
```

ベースURIを設定する。

**パラメータ:**
- `baseUri` - ベースURI

---

### setPathOptionsProvider

```java
public void setPathOptionsProvider(PathOptionsProvider pathOptionsProvider)
```

{@link PathOptionsProvider} を設定する。

**パラメータ:**
- `pathOptionsProvider` - {@link PathOptionsProvider}

---

### setPathOptionsFormatter

```java
public void setPathOptionsFormatter(PathOptionsFormatter pathOptionsFormatter)
```

{@link PathOptionsFormatter} を設定する。

**パラメータ:**
- `pathOptionsFormatter` - {@link PathOptionsFormatter}

---
