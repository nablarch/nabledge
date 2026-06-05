# class LauncherJsonLogFormatter

**パッケージ:** nablarch.fw.launcher.logging

**継承階層:**
```
java.lang.Object
  └─ LauncherLogFormatter
      └─ nablarch.fw.launcher.logging.LauncherJsonLogFormatter
```

---

```java
public class LauncherJsonLogFormatter
extends LauncherLogFormatter
```

起動ログのメッセージをJSON形式でフォーマットするクラス。

**作成者:** Shuji Kitamura  

---

## フィールドの詳細

### TARGET_NAME_LABEL

```java
private static final String TARGET_NAME_LABEL
```

ラベルの項目名

---

### TARGET_NAME_COMMAND_LINE_OPTIONS

```java
private static final String TARGET_NAME_COMMAND_LINE_OPTIONS
```

コマンドラインオプションの項目名

---

### TARGET_NAME_COMMAND_LINE_ARGUMENTS

```java
private static final String TARGET_NAME_COMMAND_LINE_ARGUMENTS
```

コマンドライン引数の項目名

---

### TARGET_NAME_EXIT_CODE

```java
private static final String TARGET_NAME_EXIT_CODE
```

終了コードの項目名

---

### TARGET_NAME_EXECUTE_TIME

```java
private static final String TARGET_NAME_EXECUTE_TIME
```

処理時間の項目名

---

### PROPS_START_LOG_TARGETS

```java
private static final String PROPS_START_LOG_TARGETS
```

開始ログの出力項目を取得する際に使用するプロパティ名

---

### PROPS_END_LOG_TARGETS

```java
private static final String PROPS_END_LOG_TARGETS
```

終了ログの出力項目を取得する際に使用するプロパティ名

---

### PROPS_START_LOG_MSG_LABEL

```java
private static final String PROPS_START_LOG_MSG_LABEL
```

開始ログのラベルのプロパティ名

---

### PROPS_END_LOG_MSG_LABEL

```java
private static final String PROPS_END_LOG_MSG_LABEL
```

終了ログのラベルのプロパティ名

---

### DEFAULT_START_LOG_TARGETS

```java
private static final String DEFAULT_START_LOG_TARGETS
```

開始ログ出力項目のデフォルト値

---

### DEFAULT_END_LOG_TARGETS

```java
private static final String DEFAULT_END_LOG_TARGETS
```

終了ログ出力項目のデフォルト値

---

### DEFAULT_START_LOG_MSG_LABEL

```java
private static final String DEFAULT_START_LOG_MSG_LABEL
```

デフォルトの開始ログメッセージのラベル

---

### DEFAULT_END_LOG_MSG_LABEL

```java
private static final String DEFAULT_END_LOG_MSG_LABEL
```

デフォルトの州力ログメッセージのラベル

---

### startLogMessageTargets

```java
private List<JsonLogObjectBuilder<LauncherLogContext>> startLogMessageTargets
```

開始ログの出力項目

---

### endLogMessageTargets

```java
private List<JsonLogObjectBuilder<LauncherLogContext>> endLogMessageTargets
```

終了ログの出力項目

---

### support

```java
private JsonLogFormatterSupport support
```

各種ログのJSONフォーマット支援オブジェクト

---

## コンストラクタの詳細

### LauncherJsonLogFormatter

```java
public LauncherJsonLogFormatter()
```

コンストラクタ。

---

## メソッドの詳細

### initialize

```java
protected void initialize(Map<String,String> props)
```

初期化処理。

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

### getProp

```java
protected String getProp(Map<String,String> props, String propName, String defaultValue)
```

プロパティを取得する。<br>
プロパティの指定がない場合はデフォルト値を返す。

**パラメータ:**
- `props` - 各種ログの設定情報
- `propName` - プロパティ名
- `defaultValue` - プロパティのデフォルト値

**戻り値:**
プロパティ

---

### getObjectBuilders

```java
protected Map<String,JsonLogObjectBuilder<LauncherLogContext>> getObjectBuilders(Map<String,String> props)
```

フォーマット対象のログ出力項目を取得する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

**戻り値:**
フォーマット対象のログ出力項目

---

### getStructuredTargets

```java
private List<JsonLogObjectBuilder<LauncherLogContext>> getStructuredTargets(Map<String,JsonLogObjectBuilder<LauncherLogContext>> objectBuilders, Map<String,String> props, String targetsPropName, String defaultTargets)
```

ログ出力項目を取得する。

**パラメータ:**
- `objectBuilders` - オブジェクトビルダー
- `props` - 各種ログ出力の設定情報
- `targetsPropName` - 出力項目のプロパティ名
- `defaultTargets` - デフォルトの出力項目

**戻り値:**
ログ出力項目

---

### getStartLogMsg

```java
public String getStartLogMsg(CommandLine commandLine)
```

{@inheritDoc}

---

### getEndLogMsg

```java
public String getEndLogMsg(int exitCode, long executeTime)
```

{@inheritDoc}

---
