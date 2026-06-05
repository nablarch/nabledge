# class HandlerQueueManager

**パッケージ:** nablarch.fw

---

```java
public abstract class HandlerQueueManager
```

ハンドラキューとその上の各ハンドラを管理する機能を実装した抽象クラス。

**param:** 具象クラスの型  
**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### methodBinder

```java
private MethodBinder<?,?> methodBinder
```

メソッドレベルの処理委譲を行うコンポーネント

---

## メソッドの詳細

### getHandlerQueue

```java
public abstract List<Handler> getHandlerQueue()
```

現在のハンドラキューの内容を返す。

**戻り値:**
現在のハンドラキューの内容

---

### setHandlerQueue

```java
public TSelf setHandlerQueue(Collection<? extends Handler> handlers)
```

ハンドラキューの内容を入れ替える。

**パラメータ:**
- `handlers` - ハンドラキュー

**戻り値:**
このオブジェクト自体

---

### addHandlers

```java
public TSelf addHandlers(Collection<? extends Handler> handlers)
```

ハンドラキューにハンドラを登録する。

**パラメータ:**
- `handlers` - 登録するハンドラ

**戻り値:**
このオブジェクト自体

---

### clearHandlers

```java
public TSelf clearHandlers()
```

ハンドラーキューの内容をクリアする。

**戻り値:**
このオブジェクト自体

---

### addHandler

```java
public TSelf addHandler(Handler<?,?> handler)
```

ハンドラキューにハンドラを登録する。

**パラメータ:**
- `handler` - 登録するハンドラ

**戻り値:**
このインスタンス自体

---

### addHandler

```java
public TSelf addHandler(int pos, Handler<?,?> handler)
```

ハンドラキューにハンドラを登録する。

**パラメータ:**
- `pos` - ハンドラの挿入位置
- `handler` - 登録するハンドラ

**戻り値:**
このインスタンス自体

---

### addHandler

```java
public TSelf addHandler(String requestPattern, Handler<TRequest,?> handler)
```

ハンドラを登録する。

**パラメータ:**
- `<TRequest>` - 登録するハンドラのリクエストオブジェクトの型
- `requestPattern` - このハンドラがキューに積まれるリクエストパス(Glob書式)
- `handler` - 登録するハンドラ

**戻り値:**
このインスタンス自体

---

### getHandlerOf

```java
public T getHandlerOf(Class<T> handlerClass)
```

ハンドラキュー上の各ハンドラのうち、
指定されたクラスのものを返す。
<pre>
指定されたクラスのインスタンスが複数登録されていた場合は、
もっとも上位ハのンドラを返す。
該当するハンドラが登録されていなかった場合はnullを返す。
</pre>

**パラメータ:**
- `<T>` - ハンドラのクラス
- `handlerClass` - ハンドラのクラス

**戻り値:**
ハンドラのインスタンス

---

### addHandler

```java
public TSelf addHandler(String uriPattern, Object handler)
```

リクエストハンドラを登録する。
<pre>
登録するオブジェクトは暗黙的に{@link nablarch.fw.web.HttpMethodBinding}でラップされる。
すなわち、このメソッドの処理は以下のソースコードと等価である。
    addHandler(uriPattern, new HttpMethodBinder(handler));
</pre>

**パラメータ:**
- `uriPattern` - リクエストハンドラが実行されるリクエストURIのパターン
    (null,空文字は不可)
- `handler` - リクエストハンドラ (null不可)

**戻り値:**
このオブジェクト自体

---

### addHandler

```java
public TSelf addHandler(Object handler)
```

リクエストハンドラを登録する。

**パラメータ:**
- `handler` - リクエストハンドラ

**戻り値:**
このオブジェクト自体

---

### allowsMethodLevelDelegation

```java
private boolean allowsMethodLevelDelegation()
```

メソッド単位の処理委譲を行うか否か。

**戻り値:**
メソッド単位の処理委譲を行う場合は true

---

### setMethodBinder

```java
public TSelf setMethodBinder(MethodBinder<?,?> binder)
```

メソッドレベルの処理委譲を行うコンポーネントを指定する。

**パラメータ:**
- `binder` - 処理委譲を行うコンポーネント

**戻り値:**
このインスタンス自体

---

### getMethodBinder

```java
public MethodBinder<TData,TResult> getMethodBinder()
```

メソッドレベルの処理委譲を行うコンポーネントを返す。

**パラメータ:**
- `<TData>` - 入力データの型
- `<TResult>` - 結果データの型

**戻り値:**
処理委譲を行うコンポーネント

---
