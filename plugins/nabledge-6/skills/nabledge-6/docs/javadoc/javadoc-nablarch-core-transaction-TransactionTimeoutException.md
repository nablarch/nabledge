# class TransactionTimeoutException

**パッケージ:** nablarch.core.transaction

**継承階層:**
```
java.lang.Object
  └─ RuntimeException
      └─ nablarch.core.transaction.TransactionTimeoutException
```

**実装されたインタフェース:**
- Retryable

---

```java
public class TransactionTimeoutException
extends RuntimeException
implements Retryable
```

トランザクションタイムアウトエラー。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### MESSAGE_TEMPLATE

```java
private static final String MESSAGE_TEMPLATE
```

例外のデフォルトメッセージ

---

## コンストラクタの詳細

### TransactionTimeoutException

```java
public TransactionTimeoutException(long transactionExecutionTime)
```

コンストラクタ。
<p/>
デフォルトメッセージを持つトランザクションタイムアウト例外を生成する。

**パラメータ:**
- `transactionExecutionTime` - トランザクションの実行時間

---

### TransactionTimeoutException

```java
public TransactionTimeoutException(long transactionExecutionTime, SQLException e)
```

コンストラクタ。
<p/>
デフォルトメッセージを持つトランザクションタイムアウト例外を生成する。

**パラメータ:**
- `transactionExecutionTime` - トランザクションの実行時間
- `e` - 発生したSQL文実行時例外

---
