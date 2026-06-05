# class RoutesMapping

**パッケージ:** nablarch.integration.router

**継承階層:**
```
java.lang.Object
  └─ RoutingHandlerSupport
      └─ nablarch.integration.router.RoutesMapping
```

**実装されたインタフェース:**
- Initializable

---

```java
public class RoutesMapping
extends RoutingHandlerSupport
implements Initializable
```

Routes定義ファイルをベースにActionメソッドを特定するハンドラ。

本ハンドラを使用することで、自由なURLを使用することができる。

**作成者:** kawasima  
**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### loading

```java
private static volatile boolean loading
```

---

### lastLoaded

```java
private static long lastLoaded
```

---

### baseUri

```java
private String baseUri
```

---

### routesUrl

```java
private URL routesUrl
```

---

### checkInterval

```java
private long checkInterval
```

---

### basePackage

```java
private String basePackage
```

---

## コンストラクタの詳細

### RoutesMapping

```java
public RoutesMapping()
```

コンストラクタ。
<p>
デフォルトで以下のプロパティを設定する。
<pre>
baseUri: ""
routes: routes.xml
checkInterval: 0L
</pre>

---

## メソッドの詳細

### getHandlerClass

```java
protected Class<?> getHandlerClass(HttpRequest request, ExecutionContext executionContext)
                         throws ClassNotFoundException
```

Routes定義にしたがい、リクエストのパスからハンドラのクラスを返す。

リクエストパスから処理対象のコントローラが特定できない場合には、
404を表す{@link HttpErrorResponse}を送出する。

**パラメータ:**
- `request` - リクエスト
- `executionContext` - 実行コンテキスト

**戻り値:**
Handlerクラス

**例外:**
- `ClassNotFoundException` - クラス不明例外

---

### reloadRoutes

```java
private void reloadRoutes()
```

routes定義ファイルのプロトコルが"file"かつ更新されている場合、再読み込みする。

---

### routesIsNotFile

```java
private boolean routesIsNotFile()
```

**戻り値:**
boolean

---

### setRoutes

```java
public void setRoutes(String routes)
```

**パラメータ:**
- `routes` - ルート

---

### setCheckInterval

```java
public void setCheckInterval(long checkInterval)
```

**パラメータ:**
- `checkInterval` - インターバル

---

### getBasePackage

```java
public String getBasePackage()
```

**戻り値:**
basePackage

---

### setBasePackage

```java
public void setBasePackage(String basePackage)
```

**パラメータ:**
- `basePackage` - ベースパッケージ

---

### setBaseUri

```java
public void setBaseUri(String baseUri)
```

**パラメータ:**
- `baseUri` - ベースURI

---

### initialize

```java
public void initialize()
```

初期化処理

---
