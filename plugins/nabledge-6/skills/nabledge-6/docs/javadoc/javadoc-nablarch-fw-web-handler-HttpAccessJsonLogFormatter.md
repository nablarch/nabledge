# class HttpAccessJsonLogFormatter

**パッケージ:** nablarch.fw.web.handler

**継承階層:**
```
java.lang.Object
  └─ HttpAccessLogFormatter
      └─ nablarch.fw.web.handler.HttpAccessJsonLogFormatter
```

---

```java
public class HttpAccessJsonLogFormatter
extends HttpAccessLogFormatter
```

HTTPアクセスログのメッセージをフォーマットするクラス。

**作成者:** Shuji Kitamura  

---

## フィールドの詳細

### TARGET_NAME_LABEL

```java
private static final String TARGET_NAME_LABEL
```

ラベルの項目名

---

### TARGET_NAME_REQUEST_ID

```java
private static final String TARGET_NAME_REQUEST_ID
```

リクエストIDの項目名

---

### TARGET_NAME_USER_ID

```java
private static final String TARGET_NAME_USER_ID
```

ユーザIDの項目名

---

### TARGET_NAME_URL

```java
private static final String TARGET_NAME_URL
```

URLの項目名

---

### TARGET_NAME_QUERY

```java
private static final String TARGET_NAME_QUERY
```

クエリ文字列の項目名

---

### TARGET_NAME_PORT

```java
private static final String TARGET_NAME_PORT
```

ポート番号の項目名

---

### TARGET_NAME_METHOD

```java
private static final String TARGET_NAME_METHOD
```

HTTPメソッドの項目名

---

### TARGET_NAME_PARAMETERS

```java
private static final String TARGET_NAME_PARAMETERS
```

リクエストパラメータの項目名

---

### TARGET_NAME_SESSION_SCOPE

```java
private static final String TARGET_NAME_SESSION_SCOPE
```

セッションスコープ情報の項目名

---

### TARGET_NAME_DISPATCHING_CLASS

```java
private static final String TARGET_NAME_DISPATCHING_CLASS
```

ディスパッチ先クラスの項目名

---

### TARGET_NAME_SESSION_ID

```java
private static final String TARGET_NAME_SESSION_ID
```

セッションIDの項目名

---

### TARGET_NAME_SESSION_STORE_ID

```java
private static final String TARGET_NAME_SESSION_STORE_ID
```

セッションストアIDの項目名

---

### TARGET_NAME_STATUS_CODE

```java
private static final String TARGET_NAME_STATUS_CODE
```

ステータスコードの項目名

---

### TARGET_NAME_RESPONSE_STATUS_CODE

```java
private static final String TARGET_NAME_RESPONSE_STATUS_CODE
```

クライアントへのレスポンスに使用するステータスコードの項目名

---

### TARGET_NAME_CONTENT_PATH

```java
private static final String TARGET_NAME_CONTENT_PATH
```

コンテンツパスの項目名

---

### TARGET_NAME_CLIENT_IP_ADDRESS

```java
private static final String TARGET_NAME_CLIENT_IP_ADDRESS
```

クライアント端末IPアドレスの項目名

---

### TARGET_NAME_CLIENT_HOST

```java
private static final String TARGET_NAME_CLIENT_HOST
```

クライアント端末ホストの項目名

---

### TARGET_NAME_CLIENT_USER_AGENT

```java
private static final String TARGET_NAME_CLIENT_USER_AGENT
```

HTTPヘッダのUser-Agentの項目名

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

### TARGET_NAME_FREE_MEMORY

```java
private static final String TARGET_NAME_FREE_MEMORY
```

空きメモリ量(開始時)の項目名

---

### PROPS_BEGIN_TARGETS

```java
private static final String PROPS_BEGIN_TARGETS
```

リクエスト処理開始時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_PARAMETERS_TARGETS

```java
private static final String PROPS_PARAMETERS_TARGETS
```

hiddenパラメータ復号後の出力項目を取得する際に使用するプロパティ名

---

### PROPS_DISPATCHING_CLASS_TARGETS

```java
private static final String PROPS_DISPATCHING_CLASS_TARGETS
```

ディスパッチ先クラス決定後の出力項目を取得する際に使用するプロパティ名

---

### PROPS_END_TARGETS

```java
private static final String PROPS_END_TARGETS
```

リクエスト処理終了時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_BEGIN_LABEL

```java
private static final String PROPS_BEGIN_LABEL
```

リクエスト処理開始時のラベルのプロパティ名

---

### PROPS_PARAMETERS_LABEL

```java
private static final String PROPS_PARAMETERS_LABEL
```

hiddenパラメータ復号後のラベルのプロパティ名

---

### PROPS_DISPATCHING_CLASS_LABEL

```java
private static final String PROPS_DISPATCHING_CLASS_LABEL
```

ディスパッチ先クラス決定後のラベルのプロパティ名

---

### PROPS_END_LABEL

```java
private static final String PROPS_END_LABEL
```

リクエスト処理終了時のラベルのプロパティ名

---

### DEFAULT_BEGIN_TARGETS

```java
private static final String DEFAULT_BEGIN_TARGETS
```

デフォルトのリクエスト処理開始時の出力項目

---

### DEFAULT_PARAMETERS_TARGETS

```java
private static final String DEFAULT_PARAMETERS_TARGETS
```

デフォルトのhiddenパラメータ復号後の出力項目

---

### DEFAULT_DISPATCHING_CLASS_TARGETS

```java
private static final String DEFAULT_DISPATCHING_CLASS_TARGETS
```

デフォルトのディスパッチ先クラス決定後の出力項目

---

### DEFAULT_END_TARGETS

```java
private static final String DEFAULT_END_TARGETS
```

デフォルトのリクエスト処理終了時の出力項目

---

### DEFAULT_BEGIN_LABEL

```java
private static final String DEFAULT_BEGIN_LABEL
```

デフォルトのリクエスト処理開始時のラベル

---

### DEFAULT_PARAMETERS_LABEL

```java
private static final String DEFAULT_PARAMETERS_LABEL
```

デフォルトのhiddenパラメータ復号後のラベル

---

### DEFAULT_DISPATCHING_CLASS_LABEL

```java
private static final String DEFAULT_DISPATCHING_CLASS_LABEL
```

デフォルトのディスパッチ先クラス決定後のラベル

---

### DEFAULT_END_LABEL

```java
private static final String DEFAULT_END_LABEL
```

デフォルトのリクエスト処理終了時のラベル

---

### beginStructuredTargets

```java
private List<JsonLogObjectBuilder<HttpAccessLogContext>> beginStructuredTargets
```

リクエスト処理開始時のフォーマット済みのログ出力項目

---

### parametersStructuredTargets

```java
private List<JsonLogObjectBuilder<HttpAccessLogContext>> parametersStructuredTargets
```

hiddenパラメータ復号後のフォーマット済みのログ出力項目

---

### dispatchingClassStructuredTargets

```java
private List<JsonLogObjectBuilder<HttpAccessLogContext>> dispatchingClassStructuredTargets
```

ディスパッチ先クラス決定後のフォーマット済みのログ出力項目

---

### endStructuredTargets

```java
private List<JsonLogObjectBuilder<HttpAccessLogContext>> endStructuredTargets
```

リクエスト処理終了時のフォーマット済みのログ出力項目

---

### containsMemoryItem

```java
private boolean containsMemoryItem
```

出力対象にメモリ項目が含まれているか否か。

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
protected void initialize(Map<String,String> props)
```

初期化。
フォーマット済みのログ出力項目を初期化する。

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

### initContainsMemoryItem

```java
private void initContainsMemoryItem()
```

{@link #containsMemoryItem}の値を初期化する。
<p>
{@link #endStructuredTargets}に{@link MaxMemoryBuilder}か{@link FreeMemoryBuilder}の
いずれかが設定されている場合は true を設定する。
</p>

---

### getObjectBuilders

```java
protected Map<String,JsonLogObjectBuilder<HttpAccessLogContext>> getObjectBuilders(Map<String,String> props)
```

フォーマット対象のログ出力項目を取得する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

**戻り値:**
フォーマット対象のログ出力項目

---

### getStructuredTargets

```java
private List<JsonLogObjectBuilder<HttpAccessLogContext>> getStructuredTargets(Map<String,JsonLogObjectBuilder<HttpAccessLogContext>> objectBuilders, Map<String,String> props, String targetsPropName, String defaultTargets)
```

フォーマット済みのログ出力項目を取得する。

**パラメータ:**
- `objectBuilders` - オブジェクトビルダー
- `props` - 各種ログ出力の設定情報
- `targetsPropName` - 出力項目のプロパティ名
- `defaultTargets` - デフォルトの出力項目

**戻り値:**
フォーマット済みのログ出力項目

---

### containsMemoryItem

```java
public boolean containsMemoryItem()
```

出力対象にメモリ項目が含まれているか否かを判定する。

**戻り値:**
出力対象にメモリ項目が含まれている場合はtrue

---

### formatBegin

```java
public String formatBegin(HttpAccessLogContext context)
```

リクエスト処理開始時のメッセージをフォーマットする。

**パラメータ:**
- `context` - HttpAccessLogContext

**戻り値:**
フォーマット済みのメッセージ

---

### formatParameters

```java
public String formatParameters(HttpAccessLogContext context)
```

hiddenパラメータ復号後のメッセージをフォーマットする。

**パラメータ:**
- `context` - HttpAccessLogContext

**戻り値:**
フォーマット済みのメッセージ

---

### formatDispatchingClass

```java
public String formatDispatchingClass(HttpAccessLogContext context)
```

ディスパッチ先クラス決定後のメッセージをフォーマットする。

**パラメータ:**
- `context` - HttpAccessLogContext

**戻り値:**
フォーマット済みのメッセージ

---

### formatEnd

```java
public String formatEnd(HttpAccessLogContext context)
```

リクエスト処理終了時のメッセージをフォーマットする。

**パラメータ:**
- `context` - HttpAccessLogContext

**戻り値:**
フォーマット済みのメッセージ

---
