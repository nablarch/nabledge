# class ApplicationSettingJsonLogFormatter

**パッケージ:** nablarch.core.log.app

**継承階層:**
```
java.lang.Object
  └─ ApplicationSettingLogFormatter
      └─ nablarch.core.log.app.ApplicationSettingJsonLogFormatter
```

---

```java
public class ApplicationSettingJsonLogFormatter
extends ApplicationSettingLogFormatter
```

アプリケーション設定に関するメッセージをJSON形式でフォーマットするクラス。
<p/>
基本的な仕様については、継承元クラスの{@link ApplicationSettingLogFormatter}を参照。
<p/>

**作成者:** Shuji Kitamura  

---

## フィールドの詳細

### PROPS_APP_SETTINGS_TARGETS

```java
private static final String PROPS_APP_SETTINGS_TARGETS
```

{@link #getAppSettingsLogMsg()}のターゲットを設定するプロパティの名前

---

### PROPS_APP_SETTINGS_WITH_DATE_TARGETS

```java
private static final String PROPS_APP_SETTINGS_WITH_DATE_TARGETS
```

{@link #getAppSettingsWithDateLogMsg()}のターゲットを設定するプロパティの名前

---

### DEFAULT_TARGETS_APP_SETTINGS

```java
private static final String DEFAULT_TARGETS_APP_SETTINGS
```

{@link #getAppSettingsLogMsg()}のデフォルトターゲット

---

### DEFAULT_TARGETS_APP_SETTINGS_WITH_DATE

```java
private static final String DEFAULT_TARGETS_APP_SETTINGS_WITH_DATE
```

{@link #getAppSettingsWithDateLogMsg()}のデフォルトターゲット

---

### TARGET_NAME_SYSTEM_SETTING

```java
private static final String TARGET_NAME_SYSTEM_SETTING
```

システム設定値の項目名

---

### TARGET_NAME_BUSINESS_DATE

```java
private static final String TARGET_NAME_BUSINESS_DATE
```

業務日付の項目名

---

### appSettingsTargets

```java
private List<JsonLogObjectBuilder<ApplicationSettingLogContext>> appSettingsTargets
```

{@link #getAppSettingsLogMsg()}の項目取得オブジェクトのリスト

---

### appSettingsWithDateTargets

```java
private List<JsonLogObjectBuilder<ApplicationSettingLogContext>> appSettingsWithDateTargets
```

{@link #getAppSettingsWithDateLogMsg()}の項目取得オブジェクトのリスト

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

### getStructuredTargets

```java
protected List<JsonLogObjectBuilder<ApplicationSettingLogContext>> getStructuredTargets(String propName, String defaultTargets)
```

ログ出力項目を取得する。

**パラメータ:**
- `propName` - ターゲットを取得するためのプロパティ名
- `defaultTargets` - ターゲットの設定値が取得できない場合に使用するデフォルト値

**戻り値:**
ログ出力項目

---

### getAppSettingsLogMsg

```java
public String getAppSettingsLogMsg()
```

{@inheritDoc}

---

### getAppSettingsWithDateLogMsg

```java
public String getAppSettingsWithDateLogMsg()
```

{@inheritDoc}

---
