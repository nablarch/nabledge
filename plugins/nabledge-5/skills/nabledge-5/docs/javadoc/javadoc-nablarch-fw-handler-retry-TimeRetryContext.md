# class TimeRetryContext

**パッケージ:** nablarch.fw.handler.retry

**継承階層:**
```
java.lang.Object
  └─ RetryContextSupport
      └─ nablarch.fw.handler.retry.TimeRetryContext
```

---

```java
public class TimeRetryContext
extends RetryContextSupport
```

リトライ時間によりリトライ処理を制御するクラス。
<p/>
本クラスは、指定された時間の間、リトライを行う。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### retryTime

```java
private final long retryTime
```

リトライ時間(単位:msec)

---

### retryStartTime

```java
private long retryStartTime
```

リトライ開始時間

---

### firstRetry

```java
private boolean firstRetry
```

1回目のリトライであるか否か。
1回目のリトライである場合はtrue

---

## コンストラクタの詳細

### TimeRetryContext

```java
protected TimeRetryContext(long retryTime, long maxRetryTime, long retryIntervals)
```

コンストラクタ。

**パラメータ:**
- `retryTime` - リトライ時間(単位:msec)
- `maxRetryTime` - 最長リトライ時間(単位:msec)
- `retryIntervals` - リトライ間隔(単位:msec)

---

## メソッドの詳細

### onIsRetryable

```java
protected boolean onIsRetryable()
```

{@inheritDoc}
<p/>
1回目のリトライである場合はtrueを返す。
2回目以降のリトライでは、
リトライ開始後の経過時間がリトライ時間プロパティ以下の場合にtrueを返す。

---

### prepareRetry

```java
public void prepareRetry()
```

{@inheritDoc}
<p/>
1回目のリトライである場合は、親クラスの処理に加えて、リトライ開始時間の設定を行う。

---

### reset

```java
public void reset()
```

{@inheritDoc}
<p/>
親クラスの処理に加えて、リトライ開始時間をリセットする。

---
