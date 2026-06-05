# class JaxRsErrorLogWriter

**パッケージ:** nablarch.fw.jaxrs

---

```java
public class JaxRsErrorLogWriter
```

JAX-RSのエラー情報をログに出力するクラス。
<p/>
このクラスでは、{@link ApplicationException}以外の例外の場合に、
{@link FailureLogUtil}を用いてログ出力を行う。
<p/>
このクラスで要件を満たせない場合には、サブクラスで実装を置き換えること。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### LOGGER

```java
protected static final Logger LOGGER
```

ロガー

---

## メソッドの詳細

### write

```java
public void write(HttpRequest request, HttpResponse response, ExecutionContext context, Throwable throwable)
```

エラー情報をログに出力する。

**パラメータ:**
- `request` - {@link HttpRequest}
- `response` - {@link HttpResponse}
- `context` - {@link ExecutionContext}
- `throwable` - {@link Throwable}

---

### writeApplicationExceptionLog

```java
protected void writeApplicationExceptionLog(HttpRequest request, HttpResponse response, ExecutionContext context, ApplicationException exception)
```

{@link ApplicationException}の情報をログ出力する。
<p/>
デフォルト実装では何も出力しない。

**パラメータ:**
- `request` - {@link HttpRequest}
- `response` - {@link HttpResponse}
- `context` - {@link ExecutionContext}
- `exception` - {@link ApplicationException}

---
