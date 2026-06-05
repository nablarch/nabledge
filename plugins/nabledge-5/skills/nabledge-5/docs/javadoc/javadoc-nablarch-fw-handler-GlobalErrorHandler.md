# class GlobalErrorHandler

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- Handler<Request<?>,Object>
- ExceptionHandler

---

```java
public class GlobalErrorHandler
implements Handler<Request<?>,Object>, ExceptionHandler
```

異例処理用例外ハンドラ。
<p/>
このハンドラは、リクエストコントローラの直後に配置され、
ハンドラキュー上のどのハンドラでも捕捉されなかった例外に対して
最終的に処理を行う責務を持ったハンドラである。
<p/>
ほとんどのエラーは各処理方式に準じた例外ハンドラーにより捕捉されるが、
それらのハンドラが捕捉しないエラー、もしくは、それらのハンドラ以降の
処理で発生したエラーが対象となる。
<p/>
このハンドラが例外処理として行うのは以下の2点である。
1. ログ出力
2. コントローラに対する例外のリスロー
(コントローラ自体の処理継続が不可能な致命的エラーの場合。)

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## メソッドの詳細

### handle

```java
public Object handle(Request<?> req, ExecutionContext context)
```

{@inheritDoc}

---

### handleError

```java
public Result handleError(Error e, ExecutionContext context)
                   throws Error, RuntimeException
```

---

### handleRuntimeException

```java
public Result handleRuntimeException(RuntimeException e, ExecutionContext context)
                              throws RuntimeException
```

---
