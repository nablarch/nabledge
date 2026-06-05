# class PerformanceLogUtil

**パッケージ:** nablarch.core.log.app

---

```java
public final class PerformanceLogUtil
```

パフォーマンスログを出力するクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### PERFORMANCE_LOGGER

```java
private static final Logger PERFORMANCE_LOGGER
```

パフォーマンスログを出力するロガー

---

### PROPS_CLASS_NAME

```java
private static final String PROPS_CLASS_NAME
```

{@link PerformanceLogFormatter}のクラス名

---

### PERFORMANCE_LOG_FORMATTER_CREATOR

```java
private static final ObjectCreator<PerformanceLogFormatter> PERFORMANCE_LOG_FORMATTER_CREATOR
```

{@link PerformanceLogFormatter}を生成する{@link ObjectCreator}

---

## コンストラクタの詳細

### PerformanceLogUtil

```java
private PerformanceLogUtil()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### initialize

```java
public static void initialize()
```

クラスローダに紐付く{@link PerformanceLogFormatter}を生成する。

---

### getPerformanceLogFormatter

```java
private static PerformanceLogFormatter getPerformanceLogFormatter()
```

クラスローダに紐付く{@link PerformanceLogFormatter}を取得する。

**戻り値:**
{@link PerformanceLogFormatter}

---

### start

```java
public static void start(String point)
```

測定を開始する。

**パラメータ:**
- `point` - 測定対象を識別するID

---

### end

```java
public static void end(String point, String result, Object logOptions)
```

測定を終了しパフォーマンスログを出力する。

**パラメータ:**
- `point` - 測定対象を識別するID
- `result` - 処理結果を表す文字列
- `logOptions` - ログのオプション情報

---
