# class JsonLogFormatter

**パッケージ:** nablarch.core.log.basic

**実装されたインタフェース:**
- LogFormatter

---

```java
public class JsonLogFormatter
implements LogFormatter
```

{@link LogFormatter}のJSON形式フォーマット実装クラス。<br>
<br>
JsonLogFormatterは、出力項目を指定してフォーマットを指定する。
出力項目の一覧を下記に示す。
<pre>
date
    このログ出力を要求した時点の日時。
logLevel
    このログ出力のログレベル。
    デフォルトはLogLevel列挙型の名称を文言に使用する。
    文言はプロパティファイルの設定で変更することができる。
loggerName
    このログ出力が対応するロガー設定の名称。
    このログ出力を呼び出した箇所に関わらず、プロパティファイル(log.properties)に記載したロガー名となる。
runtimeLoggerName
    実行時に、{@link nablarch.core.log.LoggerManager}からロガー取得に指定した名称。
    このログ出力を呼び出した際に{@link nablarch.core.log.LoggerManager#get(Class)}で指定したクラス名
    または{@link nablarch.core.log.LoggerManager#get(String)}で指定した名称となる。
bootProcess
    起動プロセスを識別する名前。
    起動プロセスは、システムプロパティ"nablarch.bootProcess"から取得する。
    指定がない場合はブランク。
processingSystem
    処理方式を識別する名前。
    処理方式は、プロパティファイル("nablarch.processingSystem")から取得する。
    指定がない場合はブランク。
requestId
    このログ出力を要求した時点のリクエストID。
executionId
    このログ出力を要求した時点の実行時ID
userId
    このログ出力を要求した時点のログインユーザのユーザID。
message
    このログ出力のメッセージ。
payload
    オプション情報に指定されたオブジェクトのフィールド情報。
    オブジェクトの型は {@code Map<String, Object> } でなければならない。
    Mapのアイテムがルート階層に追加される。
    キーが重複した場合は、いずれか一つのみが出力される。
stackTrace
    エラー情報に指定された例外オブジェクトのスタックトレース。
    エラー情報の指定がない場合は表示しない。
</pre>
プロパティファイルの記述ルールを下記に示す。<br>
<br>
<dl>
  <dt>{@code writer.<LogWriterの名称>.formatter.label.<LogLevelの名称の小文字>}<dt/>
  <dd>{@link LogLevel}に使用するラベル。オプション。<br>
      指定しなければ{@link LogLevel}の名称を使用する。<dd/>
  <dt>{@code writer.<LogWriterの名称>.formatter.targets}<dt/>
  <dd>出力項目をカンマ区切りで指定する。オプション。
      指定しなければ全ての出力項目が出力の対象となる。<dd/>
  <dt>{@code writer.<LogWriterの名称>.formatter.datePattern}<dt/>
  <dd>日時のフォーマットに使用するパターン。オプション。<br>
      指定しなければyyyy-MM-dd HH:mm:ss.SSSを使用する。<dd/>
  <dt>{@code writer.<LogWriterの名称>.formatter.structuredMessagePrefix}<dt/>
  <dd>各種ログで使用される組み込み処理用の接頭辞。オプション。<br>
      指定しなければ$JSON$を使用する。<dd/>
</dl>

**関連項目:** LogWriter  
**作成者:** Shuji Kitamura  

---

## フィールドの詳細

### TARGET_NAME_DATE

```java
private static final String TARGET_NAME_DATE
```

出力日時の項目名

---

### TARGET_NAME_LOG_LEVEL

```java
private static final String TARGET_NAME_LOG_LEVEL
```

ログレベルの項目名

---

### TARGET_NAME_LOGGER_NAME

```java
private static final String TARGET_NAME_LOGGER_NAME
```

ロガー名の項目名

---

### TARGET_NAME_RUNTIME_LOGGER_NAME

```java
private static final String TARGET_NAME_RUNTIME_LOGGER_NAME
```

実行時ロガー名の項目名

---

### TARGET_NAME_BOOT_PROCESS

```java
private static final String TARGET_NAME_BOOT_PROCESS
```

起動プロセスの項目名

---

### TARGET_NAME_PROCESSING_SYSTEM

```java
private static final String TARGET_NAME_PROCESSING_SYSTEM
```

処理方式の項目名

---

### TARGET_NAME_REQUEST_ID

```java
private static final String TARGET_NAME_REQUEST_ID
```

リクエストIDの項目名

---

### TARGET_NAME_EXECUTION_ID

```java
private static final String TARGET_NAME_EXECUTION_ID
```

実行時IDの項目名

---

### TARGET_NAME_USER_ID

```java
private static final String TARGET_NAME_USER_ID
```

ユーザIDの項目名

---

### TARGET_NAME_MESSAGE

```java
private static final String TARGET_NAME_MESSAGE
```

メッセージの項目名

---

### TARGET_NAME_STACK_TRACE

```java
private static final String TARGET_NAME_STACK_TRACE
```

エラー情報に指定された例外オブジェクトのスタックトレーの項目名

---

### TARGET_NAME_PAYLOAD

```java
private static final String TARGET_NAME_PAYLOAD
```

オプション情報に指定されたオブジェクトの項目名

---

### SYSTEM_PROP_PROCESSING_SYSTEM

```java
private static final String SYSTEM_PROP_PROCESSING_SYSTEM
```

システムプロパティから処理方式を識別する文字列を取得する際に使用するキー

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

出力項目のデフォルト値

---

### PROPS_STRUCTURED_MESSAGE_PREFIX

```java
private static final String PROPS_STRUCTURED_MESSAGE_PREFIX
```

messageを構造化されていることを示す接頭辞のプロパティ名

---

### DEFAULT_STRUCTURED_MESSAGE_PREFIX

```java
private static final String DEFAULT_STRUCTURED_MESSAGE_PREFIX
```

messageを構造化されていることを示す接頭辞のデフォルト値

---

### serializationManager

```java
private JsonSerializationManager serializationManager
```

Jsonのシリアライズに使用する管理クラス

---

### structuredTargets

```java
private List<JsonLogObjectBuilder<LogContext>> structuredTargets
```

ログ出力項目

---

### formatErrorSupport

```java
private FormatErrorSupport formatErrorSupport
```

フォーマットエラーを処理するクラス

---

## メソッドの詳細

### initialize

```java
public void initialize(ObjectSettings settings)
```

{@inheritDoc}<br>
<br>
出力項目を初期化する。

---

### createFormatErrorSupport

```java
protected FormatErrorSupport createFormatErrorSupport()
```

フォーマットエラーを処理するクラスを生成する。

**戻り値:**
フォーマットエラーを処理するクラス

---

### createSerializationManager

```java
protected JsonSerializationManager createSerializationManager(ObjectSettings settings)
```

Jsonのシリアライズに使用する管理クラスを生成する。

**パラメータ:**
- `settings` - LogFormatterの設定

**戻り値:**
Jsonのシリアライズに使用する管理クラス

---

### createStructuredTargets

```java
protected List<JsonLogObjectBuilder<LogContext>> createStructuredTargets(ObjectSettings settings)
```

ログ出力項目を生成する。

**パラメータ:**
- `settings` - LogFormatterの設定

**戻り値:**
ログ出力項目

---

### getStructuredMessagePrefix

```java
private String getStructuredMessagePrefix(ObjectSettings settings)
```

構造化済みメッセージを示す接頭辞を取得する。

**パラメータ:**
- `settings` - LogFormatterの設定

**戻り値:**
構造化済みメッセージを示す接頭辞

---

### getLogLevelLabelProvider

```java
protected LogLevelLabelProvider getLogLevelLabelProvider(ObjectSettings settings)
```

LogLevelLabelProviderを取得する。

**パラメータ:**
- `settings` - LogFormatterの設定

**戻り値:**
LogLevelLabelProvider

---

### format

```java
public String format(LogContext context)
```

{@inheritDoc}

---

### createStructuredObject

```java
protected Map<String,Object> createStructuredObject(LogContext context)
```

ログコンテキストからシリアライズ用のオブジェクトを作成する。

**パラメータ:**
- `context` - ログコンテキスト

**戻り値:**
シリアライズ用のオブジェクト

---
