# class DispatchHandler

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- Handler<TData,TResult>

---

```java
public abstract class DispatchHandler
implements Handler<TData,TResult>
```

ハンドラキューの委譲チェインとは独立したルールに従って、
ハンドラのディスパッチを行うハンドラ(ディスパッチャ)

**param:** ハンドラに対する入力オブジェクトの型  
**param:** ハンドラの処理結果オブジェクトの型  
**param:** 具象ハンドラの型  
**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### delegateFactory

```java
private DelegateFactory delegateFactory
```

デリゲートファクトリ

---

### immediate

```java
private boolean immediate
```

ディスパッチされたハンドラの実行タイミング。

---

## メソッドの詳細

### getHandlerClass

```java
protected abstract Class<?> getHandlerClass(TData input, ExecutionContext context)
                         throws ClassNotFoundException
```

処理を委譲するハンドラの型を決定する。

**パラメータ:**
- `input` - 入力データ
- `context` - 実行コンテキスト

**戻り値:**
処理を委譲するハンドラ

**例外:**
- `ClassNotFoundException` - 指定されたクラスが存在しなかった場合。

---

### handle

```java
public TResult handle(TData req, ExecutionContext ctx)
```

{@inheritDoc}

このクラスの実装では、 #getHandlerClass() で指定されるクラスのインスタンスを生成し、
ハンドラキューに追加した後、後続のハンドラに処理を委譲する。

ハンドラの追加位置は{@link #immediate}の値に従って以下のように変化する。
<pre>
  immediate = true : ハンドラキューの先頭に追加。(即時に実行される。)
  immediate = false: ハンドラキューの末尾に追加。 
</pre>

---

### createHandlerFor

```java
protected Handler<TData,TResult> createHandlerFor(Object delegate, ExecutionContext ctx)
```

渡されたインスタンスからハンドラインスタンスを作成して返す。

指定されたクラスがHandlerインターフェースを実装している場合は
そのインスタンスをキャストして返す。 
対象のクラスがハンドラインターフェースを実装していない場合でも、
MethodBinderが実行コンテキストに設定されていれば、それを使用して
Handlerインターフェースのラッパーを作成して返す。
MethodBinderも存在しない場合はnullを返す。

**パラメータ:**
- `delegate` - インスタンス
- `ctx` - 実行コンテキスト

**戻り値:**
ハンドラインスタンス

---

### saveHandlerClassAndMethodToRequestScope

```java
private void saveHandlerClassAndMethodToRequestScope(ExecutionContext context, Object delegate)
                                             throws NoSuchMethodException
```

---

### setImmediate

```java
public TSelf setImmediate(boolean immediate)
```

ディスパッチされたハンドラの実行タイミングを指定する。

**パラメータ:**
- `immediate` - trueの場合は、ディスパッチされたハンドラをハンドラキューの先端に追加する。
    falseの場合は、ディスパッチされたハンドラをハンドラキューの最後尾に追加する。

**戻り値:**
このオブジェクト自体

---

### writeDispatchingClassLog

```java
protected void writeDispatchingClassLog(TData data, ExecutionContext context, String fqn)
```

アクセスログにディスパッチ先クラスを出力する。

デフォルトでは何もしない。
必要に応じてオーバーライドすること。

**パラメータ:**
- `data` - 入力データオブジェクト
- `context` - 実行コンテキスト
- `fqn` - ディスパッチ先クラスの完全修飾クラス名

---

### setDelegateFactory

```java
public void setDelegateFactory(DelegateFactory delegateFactory)
```

ハンドラファクトリを設定する。
明示的に設定されない場合、デフォルト実装として{@link DefaultDelegateFactory}を使用する。

**パラメータ:**
- `delegateFactory` - ハンドラファクトリ

---
