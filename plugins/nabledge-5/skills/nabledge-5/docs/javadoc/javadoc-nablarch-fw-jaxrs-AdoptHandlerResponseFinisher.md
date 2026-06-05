# class AdoptHandlerResponseFinisher

**パッケージ:** nablarch.fw.jaxrs

**実装されたインタフェース:**
- ResponseFinisher

---

```java
public class AdoptHandlerResponseFinisher
implements ResponseFinisher
```

{@link HttpRequestHandler}を{@link ResponseFinisher}として使用するクラス。

このクラスで使用できる{@link HttpRequestHandler}は、自らレスポンスを作成せず、
後続ハンドラが返すレスポンスに変更を加えるハンドラに限定される。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### handler

```java
private HttpRequestHandler handler
```

ハンドラ

---

## メソッドの詳細

### setHandler

```java
public void setHandler(HttpRequestHandler handler)
```

ハンドラを設定する。

**パラメータ:**
- `handler` - ハンドラ

---

### finish

```java
public void finish(HttpRequest request, HttpResponse response, ExecutionContext context)
```

---

### copy

```java
protected ExecutionContext copy(ExecutionContext original)
```

コンテキストをコピーする。

リクエストスコープ、セッションスコープ、セッションストアがコピーされる。

**パラメータ:**
- `original` - コピー元のコンテキスト

**戻り値:**
コピーされたコンテキスト

---
