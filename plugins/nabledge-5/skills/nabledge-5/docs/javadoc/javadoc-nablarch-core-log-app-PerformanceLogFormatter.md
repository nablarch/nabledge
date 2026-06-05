# class PerformanceLogFormatter

**パッケージ:** nablarch.core.log.app

---

```java
public class PerformanceLogFormatter
```

パフォーマンスログのメッセージをフォーマットするクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### DEFAULT_DATE_FORMAT

```java
private static final DateFormat DEFAULT_DATE_FORMAT
```

デフォルトの日時フォーマット

---

### DEFAULT_FORMAT

```java
private static final String DEFAULT_FORMAT
```

デフォルトのフォーマット

---

### PROPS_PREFIX

```java
public static final String PROPS_PREFIX
```

プロパティ名のプレフィックス

---

### PROPS_TARGET_POINTS

```java
private static final String PROPS_TARGET_POINTS
```

出力対象のポイントを取得する際に使用するプロパティ名

---

### PROPS_DATE_PATTERN

```java
private static final String PROPS_DATE_PATTERN
```

開始日時と終了日時のフォーマットに使用する日時パターンを取得する際に使用するプロパティ名

---

### PROPS_FORMAT

```java
private static final String PROPS_FORMAT
```

フォーマットを取得する際に使用するプロパティ名

---

### targetPoints

```java
private Set<String> targetPoints
```

出力対象のポイント

---

### formattedLogItems

```java
private LogItem<PerformanceLogContext>[] formattedLogItems
```

フォーマット済みのログ出力項目

---

### containsMemoryItem

```java
private boolean containsMemoryItem
```

出力対象にメモリ項目が含まれているか否か。

---

### contextMap

```java
private final ThreadLocal<Map<String,PerformanceLogContext>> contextMap
```

コンテキストマップ

---

## コンストラクタの詳細

### PerformanceLogFormatter

```java
public PerformanceLogFormatter()
```

フォーマット済みのログ出力項目を初期化する。

---

## メソッドの詳細

### initialize

```java
protected void initialize()
```

初期化

---

### initializeTargetPoints

```java
protected void initializeTargetPoints(Map<String,String> props)
```

出力対象のポイントを初期化

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### initializeFormat

```java
protected void initializeFormat(Map<String,String> props)
```

フォーマットの初期化

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### setContainsMemoryItem

```java
protected void setContainsMemoryItem(boolean containsMemoryItem)
```

出力対象にメモリ項目が含まれているか否かを設定する。

**パラメータ:**
- `containsMemoryItem` - 出力対象にメモリ項目が含まれているときtrue

---

### getLogItems

```java
protected Map<String,LogItem<PerformanceLogContext>> getLogItems(DateFormat dateFormat)
```

フォーマット対象のログ出力項目を取得する。

**パラメータ:**
- `dateFormat` - 開始日時と終了日時のフォーマットに使用する日時フォーマット

**戻り値:**
フォーマット対象のログ出力項目

---

### isTargetPoint

```java
public boolean isTargetPoint(String point)
```

測定対象であるかを判定する。

**パラメータ:**
- `point` - 測定対象を識別するID

**戻り値:**
測定対象の場合はtrue

---

### start

```java
public void start(String point)
```

測定を開始する。

**パラメータ:**
- `point` - 測定対象を識別するID

---

### end

```java
public String end(String point, String result)
```

測定を終了し、パフォーマンスログのメッセージをフォーマットする。

**パラメータ:**
- `point` - 測定対象を識別するID
- `result` - 処理結果を表す文字列

**戻り値:**
フォーマット済みのメッセージ

---

### formatMessage

```java
protected String formatMessage(PerformanceLogContext context)
```

パフォーマンスログのメッセージをフォーマットする。

**パラメータ:**
- `context` - パフォーマンスログのコンテキスト情報

**戻り値:**
フォーマット済みのメッセージ

---
