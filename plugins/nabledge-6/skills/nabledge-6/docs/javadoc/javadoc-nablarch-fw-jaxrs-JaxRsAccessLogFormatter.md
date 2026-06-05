# class JaxRsAccessLogFormatter

**パッケージ:** nablarch.fw.jaxrs

---

```java
public class JaxRsAccessLogFormatter
```

RESTfulウェブサービスのアクセスログのメッセージをフォーマットするクラス。

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### DEFAULT_DATE_PATTERN

```java
private static final String DEFAULT_DATE_PATTERN
```

デフォルトの日時フォーマット

---

### DEFAULT_BEGIN_FORMAT

```java
private static final String DEFAULT_BEGIN_FORMAT
```

デフォルトのリクエスト処理開始時のフォーマット

---

### DEFAULT_END_FORMAT

```java
private static final String DEFAULT_END_FORMAT
```

デフォルトのリクエスト処理終了時のフォーマット

---

### DEFAULT_MASKING_CHAR

```java
private static final String DEFAULT_MASKING_CHAR
```

デフォルトのマスク文字

---

### DEFAULT_MASKING_PATTERNS

```java
private static final Pattern[] DEFAULT_MASKING_PATTERNS
```

デフォルトのマスク対象のパターン

---

### DEFAULT_PARAMETERS_SEPARATOR

```java
private static final String DEFAULT_PARAMETERS_SEPARATOR
```

デフォルトのリクエストパラメータの区切り文字

---

### DEFAULT_SESSION_SCOPE_SEPARATOR

```java
private static final String DEFAULT_SESSION_SCOPE_SEPARATOR
```

デフォルトのセッションスコープ情報の区切り文字

---

### DEFAULT_BEGIN_OUTPUT_ENABLED

```java
private static final String DEFAULT_BEGIN_OUTPUT_ENABLED
```

デフォルトのリクエスト処理開始時の出力が有効か否か。

---

### DEFAULT_END_OUTPUT_ENABLED

```java
private static final String DEFAULT_END_OUTPUT_ENABLED
```

デフォルトのリクエスト処理終了時の出力が有効か否か。

---

### PROPS_PREFIX

```java
public static final String PROPS_PREFIX
```

プロパティ名のプレフィックス

---

### PROPS_BEGIN_FORMAT

```java
private static final String PROPS_BEGIN_FORMAT
```

リクエスト処理開始時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_END_FORMAT

```java
private static final String PROPS_END_FORMAT
```

リクエスト処理終了時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_DATE_PATTERN

```java
private static final String PROPS_DATE_PATTERN
```

開始日時と終了日時のフォーマットに使用する日時パターンを取得する際に使用するプロパティ名

---

### PROPS_MASKING_CHAR

```java
private static final String PROPS_MASKING_CHAR
```

マスク文字を取得する際に使用するプロパティ名

---

### PROPS_MASKING_PATTERNS

```java
private static final String PROPS_MASKING_PATTERNS
```

マスク対象のパターンを取得する際に使用するプロパティ名

---

### PROPS_PARAMETERS_SEPARATOR

```java
private static final String PROPS_PARAMETERS_SEPARATOR
```

リクエストパラメータの区切り文字を取得する際に使用するプロパティ名

---

### PROPS_SESSION_SCOPE_SEPARATOR

```java
private static final String PROPS_SESSION_SCOPE_SEPARATOR
```

セッションスコープ情報の区切り文字を取得する際に使用するプロパティ名

---

### PROPS_BEGIN_OUTPUT_ENABLED

```java
private static final String PROPS_BEGIN_OUTPUT_ENABLED
```

リクエスト処理開始時の出力が有効か否かを取得する際に使用するプロパティ名

---

### PROPS_END_OUTPUT_ENABLED

```java
private static final String PROPS_END_OUTPUT_ENABLED
```

リクエスト処理終了時の出力が有効か否かを取得する際に使用するプロパティ名

---

### PROPS_BODY_MASKING_FILTER

```java
private static final String PROPS_BODY_MASKING_FILTER
```

ボディ出力時のマスク処理を行うクラス名を取得する際に使用するプロパティ名

---

### PROPS_BODY_LOG_TARGET_MATCHER

```java
private static final String PROPS_BODY_LOG_TARGET_MATCHER
```

ボディ出力対象か判定するクラス名を取得する際に使用するプロパティ名

---

### MULTIVALUE_SEPARATOR_PATTERN

```java
private static final Pattern MULTIVALUE_SEPARATOR_PATTERN
```

多値指定(カンマ区切り)のプロパティを分割する際に使用するパターン

---

### beginOutputEnabled

```java
private boolean beginOutputEnabled
```

リクエスト処理開始時の出力が有効か否か。

---

### endOutputEnabled

```java
private boolean endOutputEnabled
```

リクエスト処理終了時の出力が有効か否か。

---

### containsMemoryItem

```java
private boolean containsMemoryItem
```

出力対象にメモリ項目が含まれているか否か。

---

### beginLogItems

```java
private LogItem<JaxRsAccessLogContext>[] beginLogItems
```

リクエスト処理開始時のフォーマット済みのログ出力項目

---

### endLogItems

```java
private LogItem<JaxRsAccessLogContext>[] endLogItems
```

リクエスト処理終了時のフォーマット済みのログ出力項目

---

## メソッドの詳細

### initialize

```java
public void initialize(Map<String,String> props)
```

初期化する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### initializeEnabled

```java
protected void initializeEnabled(Map<String,String> props)
```

各ログ出力が有効か否かを初期化する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### initializeLogItems

```java
protected void initializeLogItems(Map<String,String> props)
```

フォーマット済みのログ出力項目を初期化する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### createAccessLogContext

```java
public JaxRsAccessLogContext createAccessLogContext()
```

JaxRsAccessLogContextを生成する。

**戻り値:**
JaxRsAccessLogContext

---

### containsMemoryItem

```java
public boolean containsMemoryItem()
```

出力対象にメモリ項目が含まれているか否かを判定する。

**戻り値:**
出力対象にメモリ項目が含まれている場合はtrue

---

### getLogItems

```java
protected Map<String,LogItem<JaxRsAccessLogContext>> getLogItems(Map<String,String> props)
```

フォーマット対象のログ出力項目を取得する。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
フォーマット対象のログ出力項目

---

### createBodyMaskingFilter

```java
protected LogContentMaskingFilter createBodyMaskingFilter(Map<String,String> props)
```

ボディ出力時のマスク処理を行うフィルタを生成します。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
マスク処理フィルタ

---

### createBodyLogTargetMatcher

```java
protected MessageBodyLogTargetMatcher createBodyLogTargetMatcher(Map<String,String> props)
```

ボディ出力対象であるか判定するMatcherを生成します。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
Matcher

---

### getDateFormat

```java
protected DateFormat getDateFormat(Map<String,String> props)
```

日時フォーマットを取得する。
プロパティの指定がない場合はデフォルトの日時フォーマットを返す。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
日時フォーマット

---

### getProp

```java
protected String getProp(Map<String,String> props, String propName, String defaultValue)
```

プロパティを取得する。
プロパティの指定がない場合はデフォルト値を返す。

**パラメータ:**
- `props` - 各種ログの設定情報
- `propName` - プロパティ名
- `defaultValue` - プロパティのデフォルト値

**戻り値:**
プロパティ

---

### getSeparator

```java
protected String getSeparator(Map<String,String> props, String propName, String defaultValue)
```

区切り文字を取得する。

**パラメータ:**
- `props` - 各種ログの設定情報
- `propName` - プロパティ名
- `defaultValue` - プロパティのデフォルト値

**戻り値:**
パラメータ間の区切り文字

---

### getMaskingChar

```java
protected char getMaskingChar(Map<String,String> props)
```

マスク文字を取得する。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
マスク文字

---

### getMaskingPatterns

```java
protected Pattern[] getMaskingPatterns(Map<String,String> props)
```

マスク対象のパラメータ名を取得する。
プロパティの指定がない場合はデフォルト値を返す。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
マスク対象のパラメータ名

---

### formatBegin

```java
public String formatBegin(JaxRsAccessLogContext context)
```

リクエスト処理開始時のメッセージをフォーマットする。

**パラメータ:**
- `context` - JaxRsAccessLogContext

**戻り値:**
フォーマット済みのメッセージ

---

### formatEnd

```java
public String formatEnd(JaxRsAccessLogContext context)
```

リクエスト処理終了時のメッセージをフォーマットする。

**パラメータ:**
- `context` - JaxRsAccessLogContext

**戻り値:**
フォーマット済みのメッセージ

---

### isBeginOutputEnabled

```java
public boolean isBeginOutputEnabled()
```

リクエスト処理開始時の出力が有効かを判定する。

**戻り値:**
リクエスト処理開始時の出力が有効な場合はtrue。

---

### isEndOutputEnabled

```java
public boolean isEndOutputEnabled()
```

リクエスト処理終了時の出力が有効かを判定する。

**戻り値:**
リクエスト処理終了時の出力が有効な場合はtrue。

---
