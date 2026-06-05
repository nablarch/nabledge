# class FailureJsonLogFormatter

**パッケージ:** nablarch.core.log.app

**継承階層:**
```
java.lang.Object
  └─ FailureLogFormatter
      └─ nablarch.core.log.app.FailureJsonLogFormatter
```

---

```java
public class FailureJsonLogFormatter
extends FailureLogFormatter
```

障害通知ログと障害解析ログのメッセージをJSON形式でフォーマットするクラス。
<p>
{@link FailureLogFormatter}では、フォーマットとして出力内容を設定するが、
本クラスでは、 notificationTargets および、analysisTargets プロパティにて、
出力項目を指定する。指定可能な出力項目は下記の通り。
<ul>
<li>failureCode: 障害コード</li>
<li>message: メッセージ</li>
<li>data: 処理対象データ</li>
<li>contact: 連絡先</li>
</ul>
</p>

**作成者:** Shuji Kitamura  

---

## フィールドの詳細

### TARGET_NAME_FAILURE_CODE

```java
private static final String TARGET_NAME_FAILURE_CODE
```

障害コードの項目名

---

### TARGET_NAME_MESSAGE

```java
private static final String TARGET_NAME_MESSAGE
```

メッセージの項目名

---

### TARGET_NAME_DATA

```java
private static final String TARGET_NAME_DATA
```

処理対象データの項目名

---

### TARGET_NAME_CONTACT

```java
private static final String TARGET_NAME_CONTACT
```

連絡先の項目名

---

### PROPS_NOTIFICATION_TARGETS

```java
private static final String PROPS_NOTIFICATION_TARGETS
```

障害通知ログの出力項目を取得する際に使用するプロパティ名

---

### PROPS_ANALYSIS_TARGETS

```java
private static final String PROPS_ANALYSIS_TARGETS
```

障害解析ログの出力項目を取得する際に使用するプロパティ名

---

### DEFAULT_TARGETS

```java
private static final String DEFAULT_TARGETS
```

出力項目のデフォルト値

---

### notificationStructuredTargets

```java
private List<JsonLogObjectBuilder<FailureLogContext>> notificationStructuredTargets
```

障害通知ログの出力項目

---

### analysisStructuredTargets

```java
private List<JsonLogObjectBuilder<FailureLogContext>> analysisStructuredTargets
```

障害解析ログの出力項目

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
protected List<JsonLogObjectBuilder<FailureLogContext>> getStructuredTargets(Map<String,String> props, String targetsPropName)
```

ログ出力項目を取得する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報
- `targetsPropName` - 出力項目のプロパティ名

**戻り値:**
ログ出力項目

---

### formatNotificationMessage

```java
public String formatNotificationMessage(Throwable error, Object data, String failureCode, Object[] messageOptions)
```

{@inheritDoc}

---

### formatAnalysisMessage

```java
public String formatAnalysisMessage(Throwable error, Object data, String failureCode, Object[] messageOptions)
```

{@inheritDoc}

---

### format

```java
protected String format(List<JsonLogObjectBuilder<FailureLogContext>> structuredTargets, Throwable error, Object data, String failureCode, Object[] messageOptions)
```

指定されたフォーマット済みのログ出力項目を使用してメッセージをフォーマットする。
<pre>
フォーマット対象の出力項目を下記に示す。
障害コード
障害コードから取得したメッセージ
派生元実行時ID
</pre>

**パラメータ:**
- `structuredTargets` - ログ出力項目
- `error` - エラー情報
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

**戻り値:**
フォーマット後のメッセージ

---
