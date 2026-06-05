# class FailureLogFormatter

**パッケージ:** nablarch.core.log.app

---

```java
public class FailureLogFormatter
```

障害通知ログと障害解析ログのメッセージをフォーマットするクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### DEFAULT_FORMAT

```java
private static final String DEFAULT_FORMAT
```

デフォルトのフォーマット

---

### FRAMEWORK_PACKAGE_PREFIX

```java
private static final String FRAMEWORK_PACKAGE_PREFIX
```

フレームワークのパッケージ名のプレフィックス

---

### PROPS_PREFIX

```java
public static final String PROPS_PREFIX
```

プロパティ名のプレフィックス

---

### PROPS_DEFAULT_FAILURE_CODE

```java
private static final String PROPS_DEFAULT_FAILURE_CODE
```

デフォルトの障害コードを取得する際に使用するプロパティ名

---

### PROPS_DEFAULT_MESSAGE

```java
private static final String PROPS_DEFAULT_MESSAGE
```

デフォルトのメッセージを取得する際に使用するプロパティ名

---

### PROPS_LANGUAGE

```java
private static final String PROPS_LANGUAGE
```

メッセージを取得する際に使用する言語

---

### PROPS_NOTIFICATION_FORMAT

```java
private static final String PROPS_NOTIFICATION_FORMAT
```

障害通知ログのフォーマットを取得する際に使用するプロパティ名

---

### PROPS_ANALYSIS_FORMAT

```java
private static final String PROPS_ANALYSIS_FORMAT
```

障害解析ログのフォーマットを取得する際に使用するプロパティ名

---

### PROPS_CONTACT_FILE_PATH

```java
private static final String PROPS_CONTACT_FILE_PATH
```

連絡先情報のファイルパスを取得する際に使用するプロパティ名

---

### PROPS_APP_FAILURE_CODE_FILE_PATH

```java
private static final String PROPS_APP_FAILURE_CODE_FILE_PATH
```

アプリケーション用の障害コード変換情報のファイルパスを取得する際に使用するプロパティ名

---

### PROPS_APP_MESSAGE_ID_FILE_PATH

```java
private static final String PROPS_APP_MESSAGE_ID_FILE_PATH
```

アプリケーション用のメッセージID変換情報のファイルパスを取得する際に使用するプロパティ名

---

### PROPS_FW_FAILURE_CODE_FILE_PATH

```java
private static final String PROPS_FW_FAILURE_CODE_FILE_PATH
```

フレームワーク用の障害コード変換情報のファイルパスを取得する際に使用するプロパティ名

---

### PROPS_FW_MESSAGE_ID_FILE_PATH

```java
private static final String PROPS_FW_MESSAGE_ID_FILE_PATH
```

フレームワーク用のメッセージID変換情報のファイルパスを取得する際に使用するプロパティ名

---

### defaultFailureCode

```java
private String defaultFailureCode
```

デフォルトの障害コード

---

### defaultMessage

```java
private String defaultMessage
```

デフォルトのメッセージ

---

### locale

```java
private Locale locale
```

メッセージの言語

---

### appFailureCodes

```java
private Map<String,String> appFailureCodes
```

アプリケーション用の障害コード(キーはソース上で指定した障害コード)

---

### fwFailureCodes

```java
private List<Map.Entry<String,String>> fwFailureCodes
```

フレームワーク用の障害コード(キーはパッケージ名)

---

### notificationLogItems

```java
private LogItem<FailureLogContext>[] notificationLogItems
```

障害通知ログのフォーマット済みのログ出力項目

---

### analysisLogItems

```java
private LogItem<FailureLogContext>[] analysisLogItems
```

障害解析ログのフォーマット済みのログ出力項目

---

### KEY_LENGTH_DESCENDING_COMPARATOR

```java
private static final Comparator<Map.Entry<String,String>> KEY_LENGTH_DESCENDING_COMPARATOR
```

{@link Map.Entry}リストのキー文字列の長さの降順にソートする場合に使用する{@link Comparator}

---

## コンストラクタの詳細

### FailureLogFormatter

```java
public FailureLogFormatter()
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

### initializeFailureCodes

```java
protected void initializeFailureCodes(Map<String,String> props)
```

障害コードの初期化

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### initializeMessage

```java
protected void initializeMessage(Map<String,String> props)
```

メッセージの初期化

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

### initContacts

```java
private void initContacts(Map<String,String> props, LogItem<FailureLogContext>[] formattedLogItems)
```

指定されたフォーマット済みのログ出力項目に連絡先が含まれている場合は、連絡先を初期化する。
プロパティファイルのキー名の長さで降順にソートして返す。

**パラメータ:**
- `props` - 各種ログ出力の設定情報
- `formattedLogItems` - フォーマット済みのログ出力項目

---

### getContactList

```java
protected List<Map.Entry<String,String>> getContactList(Map<String,String> props)
```

連絡先を取得する。
プロパティファイルのキー名の長さで降順にソートして返す。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

**戻り値:**
連絡先

---

### getAppFailureCodes

```java
protected Map<String,String> getAppFailureCodes(Map<String,String> props)
```

アプリケーション用の障害コード変換情報を取得する。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
アプリケーション用の障害コード変換情報

---

### getFwFailureCodes

```java
protected List<Map.Entry<String,String>> getFwFailureCodes(Map<String,String> props)
```

フレームワーク用の障害コード変換情報を取得する。
プロパティファイルのキー名の長さで降順にソートして返す。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
フレームワーク用の障害コード変換情報

---

### getDefaultFailureCode

```java
protected String getDefaultFailureCode(Map<String,String> props)
```

デフォルトの障害コードを取得する。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
デフォルトの障害コード

---

### getDefaultMessage

```java
protected String getDefaultMessage(Map<String,String> props)
```

デフォルトのメッセージを取得する。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
デフォルトのメッセージ

---

### getNotificationFormat

```java
protected String getNotificationFormat(Map<String,String> props)
```

障害通知ログのフォーマットを取得する。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
障害通知ログのフォーマット

---

### getAnalysisFormat

```java
protected String getAnalysisFormat(Map<String,String> props)
```

障害解析ログのフォーマットを取得する。

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
障害解析ログのフォーマット

---

### getProps

```java
protected Map<String,String> getProps(Map<String,String> props, String key, String defaultFilePath)
```

プロパティを取得する。

**パラメータ:**
- `props` - 各種ログの設定情報
- `key` - プロパティのファイルパスを各種ログの設定情報から取得する際に使用するキー
- `defaultFilePath` - デフォルトのファイルパス

**戻り値:**
プロパティ

---

### getLogItems

```java
protected Map<String,LogItem<FailureLogContext>> getLogItems(Map<String,String> props)
```

フォーマット対象のログ出力項目を取得する。
<p/>
デフォルトで下記のプレースホルダを設定したログ出力項目を返す。
<pre>
  $failureCode$: 障害コード
  $messageId$: 障害コード(旧メッセージID。下位互換性のため)
  $message$: メッセージ
  $data$: 処理対象データ
  $contact$: 連絡先
</pre>

**パラメータ:**
- `props` - 各種ログの設定情報

**戻り値:**
フォーマット対象のログ出力項目

---

### formatNotificationMessage

```java
public String formatNotificationMessage(Throwable error, Object data, String failureCode, Object[] messageOptions)
```

障害通知ログのメッセージをフォーマットする。
<pre>
フォーマット対象の出力項目を下記に示す。
障害コード
障害コードから取得したメッセージ
派生元実行時ID
</pre>

**パラメータ:**
- `error` - エラー情報
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

**戻り値:**
フォーマット済みのメッセージ

---

### formatAnalysisMessage

```java
public String formatAnalysisMessage(Throwable error, Object data, String failureCode, Object[] messageOptions)
```

障害解析ログのメッセージをフォーマットする。
<pre>
フォーマット対象の出力項目を下記に示す。
障害コード
障害コードから取得したメッセージ
派生元実行時ID
</pre>

**パラメータ:**
- `error` - エラー情報
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

**戻り値:**
フォーマット済みのメッセージ

---

### format

```java
protected String format(LogItem<FailureLogContext>[] formattedLogItems, Throwable error, Object data, String failureCode, Object[] messageOptions)
```

指定されたフォーマット済みのログ出力項目を使用してメッセージをフォーマットする。
<pre>
フォーマット対象の出力項目を下記に示す。
障害コード
障害コードから取得したメッセージ
派生元実行時ID
</pre>

**パラメータ:**
- `formattedLogItems` - フォーマット済みのログ出力項目
- `error` - エラー情報
- `data` - 処理対象データ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

**戻り値:**
フォーマット後のメッセージ

---

### getMessage

```java
protected String getMessage(String failureCode, Object[] options, Throwable error)
```

障害コードからメッセージを取得する。
<pre>
障害コードがデフォルトの障害コードの場合は、デフォルトのメッセージを返す。
デフォルトのメッセージが指定されていない場合はブランクとなる。

メッセージ取得では、指定されたメッセージの言語を使用する。
メッセージの言語が指定されていない場合は、{@link ThreadContext#getLanguage()}を使用する。

メッセージ取得で例外が発生した場合は、下記の固定メッセージを返す。

"failed to get the message to output the failure log. failureCode = [障害コード]"
</pre>

**パラメータ:**
- `failureCode` - 障害コード
- `options` - 障害コードからメッセージを取得する際に使用するオプション情報
- `error` - エラー情報

**戻り値:**
メッセージ

---

### getLocale

```java
private Locale getLocale()
```

言語情報を取得する。

**戻り値:**
言語情報

---

### getFailureCode

```java
protected String getFailureCode(String failureCode, Throwable error)
```

ログ出力に使用する障害コードを取得する。

**パラメータ:**
- `failureCode` - 出力依頼時に指定された障害コード
- `error` - エラー情報

**戻り値:**
ログ出力に使用する障害コード

---

### getFrameworkFailureCode

```java
protected String getFrameworkFailureCode(Throwable error)
```

フレームワーク用の障害コード変換情報から障害コードを取得する。
<pre>
下記の場合はデフォルトの障害コードを返す。
・エラー情報のスタックトレースのルート要素がフレームワークでない場合
・フレームワーク用の障害コード変換情報から障害コードを取得できない場合
</pre>

**パラメータ:**
- `error` - エラー情報

**戻り値:**
フレームワーク用の障害コード

---

### findEntryValue

```java
static String findEntryValue(List<Map.Entry<String,String>> entries, String keyPrefix)
```

{@link Map.Entry}リストからキーのプレフィックス指定で値を検索する。

**パラメータ:**
- `entries` - {@link Map.Entry}リスト
- `keyPrefix` - キーのプレフィックス

**戻り値:**
値。見つからない場合はnull

---

### getRootExceptionPoint

```java
protected StackTraceElement getRootExceptionPoint(Throwable error)
```

スタックトレースからルート要素を取得する。

**パラメータ:**
- `error` - エラー情報

**戻り値:**
スタックトレースのルート要素。スタックトレースがない場合はnull

---
