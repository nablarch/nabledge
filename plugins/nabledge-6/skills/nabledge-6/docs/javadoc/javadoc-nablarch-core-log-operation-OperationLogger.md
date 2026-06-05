# class OperationLogger

**パッケージ:** nablarch.core.log.operation

---

```java
public final class OperationLogger
```

運用担当者向けの通知ログを出力するロガー

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## コンストラクタの詳細

### OperationLogger

```java
private OperationLogger()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### write

```java
public static void write(LogLevel level, String message)
```

メッセージをログに出力する。

**パラメータ:**
- `level` - ログレベル
- `message` - メッセージ

---

### write

```java
public static void write(LogLevel level, String message, Throwable throwable)
```

メッセージをログに出力する。

**パラメータ:**
- `level` - ログレベル
- `message` - メッセージ
- `throwable` - 例外

---
