# class CountingRetryContext

**パッケージ:** nablarch.fw.handler.retry

**継承階層:**
```
java.lang.Object
  └─ RetryContextSupport
      └─ nablarch.fw.handler.retry.CountingRetryContext
```

---

```java
public class CountingRetryContext
extends RetryContextSupport
```

リトライ回数によりリトライ処理を制御するクラス。
<p/>
本クラスは、指定された回数分、リトライを行う。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### retryCount

```java
private final int retryCount
```

リトライ回数

---

## コンストラクタの詳細

### CountingRetryContext

```java
protected CountingRetryContext(int retryCount, long maxRetryTime, long retryIntervals)
```

コンストラクタ。

**パラメータ:**
- `retryCount` - リトライ回数
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
現在のリトライ回数がリトライ回数プロパティより小さい場合はtrueを返す。

---
