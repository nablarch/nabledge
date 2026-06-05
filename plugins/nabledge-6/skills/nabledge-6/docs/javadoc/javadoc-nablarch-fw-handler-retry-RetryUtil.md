# class RetryUtil

**パッケージ:** nablarch.fw.handler.retry

---

```java
public final class RetryUtil
```

リトライ処理に使用するユーティリティクラス。

**作成者:** Kiyohito Itoh  

---

## コンストラクタの詳細

### RetryUtil

```java
private RetryUtil()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### isRetryable

```java
public static boolean isRetryable(Throwable e)
```

指定された例外がリトライ可能であるか否かを判定する。
<p/>
{@link Retryable}インタフェースを実装した例外をリトライ可能な例外と判断する。
起因となる例外も含めて判定する。

**パラメータ:**
- `e` - 例外

**戻り値:**
リトライ可能である場合はtrue

---
