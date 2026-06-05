# class ComplexRequestResponseProcessor

**パッケージ:** nablarch.test.core.http

**実装されたインタフェース:**
- RequestResponseProcessor

---

```java
public class ComplexRequestResponseProcessor
implements RequestResponseProcessor
```

複数の{@link RequestResponseProcessor}をまとめる{@link RequestResponseProcessor}実装

---

## フィールドの詳細

### processors

```java
private List<RequestResponseProcessor> processors
```

プロセッサ

---

## メソッドの詳細

### processRequest

```java
public HttpRequest processRequest(HttpRequest request)
```

---

### processResponse

```java
public HttpResponse processResponse(HttpRequest request, HttpResponse response)
```

---

### reset

```java
public void reset()
```

---

### setProcessors

```java
public void setProcessors(List<RequestResponseProcessor> processors)
```

実行するプロセッサを設定する。

**パラメータ:**
- `processors` - プロセッサのリスト

---
