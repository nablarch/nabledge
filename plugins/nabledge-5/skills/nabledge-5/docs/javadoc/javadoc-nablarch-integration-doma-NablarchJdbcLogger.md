# class NablarchJdbcLogger

**パッケージ:** nablarch.integration.doma

**継承階層:**
```
java.lang.Object
  └─ AbstractJdbcLogger<LogLevel>
      └─ nablarch.integration.doma.NablarchJdbcLogger
```

---

```java
public class NablarchJdbcLogger
extends AbstractJdbcLogger<LogLevel>
```

Nablarchの{@link Logger}へログを出力する{@link JdbcLogger}の実装クラス。

**作成者:** Taichi Uragami  

---

## フィールドの詳細

### logger

```java
private final Logger logger
```

Nablarchの{@link Logger}

---

## コンストラクタの詳細

### NablarchJdbcLogger

```java
public NablarchJdbcLogger(LogLevel level)
```

ログレベルを指定してインスタンスを構築する。

**パラメータ:**
- `level` - ログレベル

---

### NablarchJdbcLogger

```java
NablarchJdbcLogger(LogLevel level, Logger logger)
```

ログレベルとロガー指定してインスタンスを構築する（テストで使用する）。

**パラメータ:**
- `level` - ログレベル
- `logger` - ロガー

---

## メソッドの詳細

### log

```java
protected void log(LogLevel level, String callerClassName, String callerMethodName, Throwable throwable, Supplier<String> messageSupplier)
```

---
