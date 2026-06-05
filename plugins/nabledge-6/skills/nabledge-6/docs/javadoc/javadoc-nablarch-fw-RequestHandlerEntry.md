# class RequestHandlerEntry

**パッケージ:** nablarch.fw

**実装されたインタフェース:**
- HandlerWrapper<TRequest,TResult>

---

```java
public class RequestHandlerEntry
implements HandlerWrapper<TRequest,TResult>
```

各リクエストのリクエストパスの内容に応じ、内部に保持するハンドラに
処理を委譲するかどうかを判断するハンドラ。
<p/>
このハンドラでは、その内部にあるハンドラに対する参照を保持し、
各リクエストに対し、そのハンドラを実行する条件をリクエストパスのパターンで指定する。
<p/>
URIとリクエストパスのパターンの照合処理はRequestPathMappingHelperに委譲する。

**param:** リクエストデータの型  
**param:**   
**関連項目:** Request#getRequestPath()  
**関連項目:** RequestPathMatchingHelper  
**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## フィールドの詳細

### handler

```java
private Handler<TRequest,TResult> handler
```

このハンドラエントリが保持しているハンドラ。

---

### helper

```java
private RequestPathMatchingHelper helper
```

URIとリクエストパターンのマッピングを行うクラス

---

## メソッドの詳細

### handle

```java
public TResult handle(TRequest request, ExecutionContext context)
```

{@inheritDoc}
この実装では、まずリクエストに対してこのエントリが保持する
ハンドラを実行する必要があるかどうかを{@link #isAppliedTo(Request, ExecutionContext)}
により決定する。
必要があればこのエントリ内のハンドラを実行しその結果を返す。
必要がなければこのエントリ内のハンドラは実行せずに、
ハンドラキュー上の後続ハンドラに処理を委譲し、その結果を返す。

---

### getDelegates

```java
public List<Object> getDelegates(TRequest request, ExecutionContext context)
```

{@inheritDoc}

---

### getDelegate

```java
protected Handler<TRequest,TResult> getDelegate()
```

処理移譲対象となるハンドラを返す。

**戻り値:**
処理移譲対象のハンドラ

---

### setHandler

```java
public RequestHandlerEntry<TRequest,TResult> setHandler(Handler<TRequest,TResult> handler)
```

このハンドラエントリ内にハンドラを設定する。

**パラメータ:**
- `handler` - リクエストハンドラ

**戻り値:**
このオブジェクト自体

---

### setRequestPattern

```java
public RequestHandlerEntry<TRequest,TResult> setRequestPattern(String requestPattern)
```

このエントリ内のハンドラを実行するリクエストパスの
パターン文字列を設定する。

**パラメータ:**
- `requestPattern` - リクエストパターン文字列

**戻り値:**
このインスタンス自体

---

### isAppliedTo

```java
public boolean isAppliedTo(TRequest request, ExecutionContext context)
```

渡されたリクエストに対して、ハンドラを実行する必要があるかどうかを判断する。
このエントリに設定されたリクエストパターンがリクエストパスにマッチする場合はtrueを返す。

**パラメータ:**
- `request` - リクエストデータ
- `context` - 実行コンテキスト

**戻り値:**
ハンドラを実行する必要がある場合はtrue

---

### toString

```java
public String toString()
```

{@inheritDoc}

---
