# class PerformanceJsonLogFormatter

**パッケージ:** nablarch.core.log.app

**継承階層:**
```
java.lang.Object
  └─ PerformanceLogFormatter
      └─ nablarch.core.log.app.PerformanceJsonLogFormatter
```

---

```java
public class PerformanceJsonLogFormatter
extends PerformanceLogFormatter
```

パフォーマンスログのメッセージをJSON形式でフォーマットするクラス。
<p>
{@link PerformanceLogFormatter}では、フォーマットとして出力内容を設定するが、
本クラスでは、 notificationTargets および、analysisTargets プロパティにて、
出力項目を指定する。指定可能な出力項目は下記の通り。
<ul>
<li>point: ポイント</li>
<li>result: 処理結果</li>
<li>startTime: 開始日時</li>
<li>endTime: 終了日時</li>
<li>executionTime: 実行時間</li>
<li>maxMemory: 最大メモリ量</li>
<li>startFreeMemory: 開始時の空きメモリ量</li>
<li>endFreeMemory: 終了時の空きメモリ量</li>
<li>startUsedMemory: 開始時の使用メモリ量</li>
<li>endUsedMemory: 終了時の使用メモリ量</li>
</ul>
</p>

**作成者:** Shuji Kitamura  

---

## フィールドの詳細

### TARGET_NAME_POINT

```java
private static final String TARGET_NAME_POINT
```

ポイントの項目名

---

### TARGET_NAME_RESULT

```java
private static final String TARGET_NAME_RESULT
```

処理結果の項目名

---

### TARGET_NAME_START_TIME

```java
private static final String TARGET_NAME_START_TIME
```

開始日時の項目名

---

### TARGET_NAME_END_TIME

```java
private static final String TARGET_NAME_END_TIME
```

終了日時の項目名

---

### TARGET_NAME_EXECUTION_TIME

```java
private static final String TARGET_NAME_EXECUTION_TIME
```

実行時間の項目名

---

### TARGET_NAME_MAX_MEMORY

```java
private static final String TARGET_NAME_MAX_MEMORY
```

最大メモリ量の項目名

---

### TARGET_NAME_START_FREE_MEMORY

```java
private static final String TARGET_NAME_START_FREE_MEMORY
```

開始時の空きメモリ量の項目名

---

### TARGET_NAME_END_FREE_MEMORY

```java
private static final String TARGET_NAME_END_FREE_MEMORY
```

終了時の空きメモリ量の項目名

---

### TARGET_NAME_START_USED_MEMORY

```java
private static final String TARGET_NAME_START_USED_MEMORY
```

開始時の使用メモリ量の項目名

---

### TARGET_NAME_END_USED_MEMORY

```java
private static final String TARGET_NAME_END_USED_MEMORY
```

終了時の使用メモリ量の項目名

---

### PROPS_TARGETS

```java
private static final String PROPS_TARGETS
```

出力項目のプロパティ名

---

### DEFAULT_TARGETS

```java
private static final String DEFAULT_TARGETS
```

フォーマット指定が無い場合に使用する出力項目のデフォルト値

---

### TARGET_BUILDERS_MAP

```java
private static final Map<String,JsonLogObjectBuilder<PerformanceLogContext>> TARGET_BUILDERS_MAP
```

ターゲット名と {@link JsonLogObjectBuilder}の対応を定義したマップ。

---

### structuredTargets

```java
private List<JsonLogObjectBuilder<PerformanceLogContext>> structuredTargets
```

ログ出力項目

---

### support

```java
private JsonLogFormatterSupport support
```

各種ログのJSONフォーマット支援オブジェクト

---

## メソッドの詳細

### initialize

```java
protected void initialize()
```

{@inheritDoc}

---

### initializeFormatterSupport

```java
protected final void initializeFormatterSupport(Map<String,String> props, String prefix, String filePath)
```

各種ログのJSONフォーマット支援オブジェクトの初期化

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### createSerializationManager

```java
protected JsonSerializationManager createSerializationManager(JsonSerializationSettings settings)
```

変換処理に使用する{@link JsonSerializationManager}を生成する。

**パラメータ:**
- `settings` - 各種ログ出力の設定情報

**戻り値:**
{@link JsonSerializationManager}

---

### initializeTargets

```java
protected final void initializeTargets(Map<String,String> props)
```

出力項目の初期化

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### getStructuredTargets

```java
protected List<JsonLogObjectBuilder<PerformanceLogContext>> getStructuredTargets(Map<String,String> props)
```

ログ出力項目を取得する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

**戻り値:**
ログ出力項目

---

### containsAnyOfMemoryTarget

```java
private boolean containsAnyOfMemoryTarget(Set<String> targets)
```

メモリ関係のターゲットが1つ以上含まれているかどうか判定する。

**パラメータ:**
- `targets` - ターゲットのセット

**戻り値:**
メモリ関係のターゲットが1つ以上含まれている場合は true

---

### isAnyOfMemoryTarget

```java
private boolean isAnyOfMemoryTarget(String target)
```

指定された target がメモリに関するものかどうか判定する。

**パラメータ:**
- `target` - 判定対象の target

**戻り値:**
メモリ関係の target の場合は true

---

### formatMessage

```java
protected String formatMessage(PerformanceLogContext context)
```

{@inheritDoc}

---
