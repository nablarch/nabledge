# class SqlJsonLogFormatter

**パッケージ:** nablarch.core.db.statement

**継承階層:**
```
java.lang.Object
  └─ SqlLogFormatter
      └─ nablarch.core.db.statement.SqlJsonLogFormatter
```

---

```java
public class SqlJsonLogFormatter
extends SqlLogFormatter
```

SQLログを出力するクラス。

**作成者:** Shuji Kitamura  

---

## フィールドの詳細

### TARGET_NAME_METHOD_NAME

```java
private static final String TARGET_NAME_METHOD_NAME
```

メソッド名の項目名

---

### TARGET_NAME_SQL

```java
private static final String TARGET_NAME_SQL
```

SQL文の項目名

---

### TARGET_NAME_START_POSITION

```java
private static final String TARGET_NAME_START_POSITION
```

取得開始位置の項目名

---

### TARGET_NAME_SIZE

```java
private static final String TARGET_NAME_SIZE
```

最大取得件数の項目名

---

### TARGET_NAME_QUERY_TIMEOUT

```java
private static final String TARGET_NAME_QUERY_TIMEOUT
```

タイムアウト時間の項目名

---

### TARGET_NAME_FETCH_SIZE

```java
private static final String TARGET_NAME_FETCH_SIZE
```

フェッチ件数の項目名

---

### TARGET_NAME_EXECUTE_TIME

```java
private static final String TARGET_NAME_EXECUTE_TIME
```

実行時間の項目名

---

### TARGET_NAME_RETRIEVE_TIME

```java
private static final String TARGET_NAME_RETRIEVE_TIME
```

データ取得時間の項目名

---

### TARGET_NAME_COUNT

```java
private static final String TARGET_NAME_COUNT
```

検索件数の項目名

---

### TARGET_NAME_UPDATE_COUNT

```java
private static final String TARGET_NAME_UPDATE_COUNT
```

更新件数の項目名

---

### TARGET_NAME_BATCH_COUNT

```java
private static final String TARGET_NAME_BATCH_COUNT
```

バッチ件数の項目名

---

### TARGET_NAME_ADDITIONAL_INFO

```java
private static final String TARGET_NAME_ADDITIONAL_INFO
```

付加情報の項目名

---

### PROPS_START_RETRIEVE_TARGETS

```java
private static final String PROPS_START_RETRIEVE_TARGETS
```

SqlPStatement#retrieveメソッドの検索開始時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_END_RETRIEVE_TARGETS

```java
private static final String PROPS_END_RETRIEVE_TARGETS
```

SqlPStatement#retrieveメソッドの検索終了時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_START_EXECUTE_TARGETS

```java
private static final String PROPS_START_EXECUTE_TARGETS
```

SqlPStatement#executeメソッドの実行開始時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_END_EXECUTE_TARGETS

```java
private static final String PROPS_END_EXECUTE_TARGETS
```

SqlPStatement#executeメソッドの実行終了時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_START_EXECUTE_QUERY_TARGETS

```java
private static final String PROPS_START_EXECUTE_QUERY_TARGETS
```

SqlPStatement#executeQueryメソッドの検索開始時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_END_EXECUTE_QUERY_TARGETS

```java
private static final String PROPS_END_EXECUTE_QUERY_TARGETS
```

SqlPStatement#executeQueryメソッドの検索終了時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_START_EXECUTE_UPDATE_TARGETS

```java
private static final String PROPS_START_EXECUTE_UPDATE_TARGETS
```

SqlPStatement#executeUpdateメソッドの更新開始時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_END_EXECUTE_UPDATE_TARGETS

```java
private static final String PROPS_END_EXECUTE_UPDATE_TARGETS
```

SqlPStatement#executeUpdateメソッドの更新終了時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_START_EXECUTE_BATCH_TARGETS

```java
private static final String PROPS_START_EXECUTE_BATCH_TARGETS
```

SqlPStatement#executeBatchメソッドの更新開始時の出力項目を取得する際に使用するプロパティ名

---

### PROPS_END_EXECUTE_BATCH_TARGETS

```java
private static final String PROPS_END_EXECUTE_BATCH_TARGETS
```

SqlPStatement#executeBatchメソッドの更新終了時の出力項目を取得する際に使用するプロパティ名

---

### DEFAULT_START_RETRIEVE_TARGETS

```java
private static final String DEFAULT_START_RETRIEVE_TARGETS
```

SqlPStatement#retrieveメソッドの検索開始時のデフォルトの出力項目

---

### DEFAULT_END_RETRIEVE_TARGETS

```java
private static final String DEFAULT_END_RETRIEVE_TARGETS
```

SqlPStatement#retrieveメソッドの検索終了時のデフォルトの出力項目

---

### DEFAULT_START_EXECUTE_TARGETS

```java
private static final String DEFAULT_START_EXECUTE_TARGETS
```

SqlPStatement#executeメソッドの実行開始時のデフォルトの出力項目

---

### DEFAULT_END_EXECUTE_TARGETS

```java
private static final String DEFAULT_END_EXECUTE_TARGETS
```

SqlPStatement#executeメソッドの実行終了時のデフォルトの出力項目

---

### DEFAULT_START_EXECUTE_QUERY_TARGETS

```java
private static final String DEFAULT_START_EXECUTE_QUERY_TARGETS
```

SqlPStatement#executeQueryメソッドの検索開始時のデフォルトの出力項目

---

### DEFAULT_END_EXECUTE_QUERY_TARGETS

```java
private static final String DEFAULT_END_EXECUTE_QUERY_TARGETS
```

SqlPStatement#executeQueryメソッドの検索終了時のデフォルトの出力項目

---

### DEFAULT_START_EXECUTE_UPDATE_TARGETS

```java
private static final String DEFAULT_START_EXECUTE_UPDATE_TARGETS
```

SqlPStatement#executeUpdateメソッドの更新開始時のデフォルトの出力項目

---

### DEFAULT_END_EXECUTE_UPDATE_TARGETS

```java
private static final String DEFAULT_END_EXECUTE_UPDATE_TARGETS
```

SqlPStatement#executeUpdateメソッドの更新終了時のデフォルトの出力項目

---

### DEFAULT_START_EXECUTE_BATCH_TARGETS

```java
private static final String DEFAULT_START_EXECUTE_BATCH_TARGETS
```

SqlPStatement#executeBatchメソッドの更新開始時のデフォルトの出力項目

---

### DEFAULT_END_EXECUTE_BATCH_TARGETS

```java
private static final String DEFAULT_END_EXECUTE_BATCH_TARGETS
```

SqlPStatement#executeBatchメソッドの更新終了時のデフォルトの出力項目

---

### SUPPORTED_TARGETS_BY_START_RETRIEVE

```java
private static final Set<String> SUPPORTED_TARGETS_BY_START_RETRIEVE
```

startRetrieve でサポートしている出力項目の一覧。

---

### SUPPORTED_TARGETS_BY_END_RETRIEVE

```java
private static final Set<String> SUPPORTED_TARGETS_BY_END_RETRIEVE
```

endRetrieve でサポートしている出力項目の一覧。

---

### SUPPORTED_TARGETS_BY_START_EXECUTE

```java
private static final Set<String> SUPPORTED_TARGETS_BY_START_EXECUTE
```

startExecute でサポートしている出力項目の一覧。

---

### SUPPORTED_TARGETS_BY_END_EXECUTE

```java
private static final Set<String> SUPPORTED_TARGETS_BY_END_EXECUTE
```

endExecute でサポートしている出力項目の一覧。

---

### SUPPORTED_TARGETS_BY_START_EXECUTE_QUERY

```java
private static final Set<String> SUPPORTED_TARGETS_BY_START_EXECUTE_QUERY
```

startExecuteQuery でサポートしている出力項目の一覧。

---

### SUPPORTED_TARGETS_BY_END_EXECUTE_QUERY

```java
private static final Set<String> SUPPORTED_TARGETS_BY_END_EXECUTE_QUERY
```

endExecuteQuery でサポートしている出力項目の一覧。

---

### SUPPORTED_TARGETS_BY_START_EXECUTE_UPDATE

```java
private static final Set<String> SUPPORTED_TARGETS_BY_START_EXECUTE_UPDATE
```

startExecuteUpdate でサポートしている出力項目の一覧。

---

### SUPPORTED_TARGETS_BY_END_EXECUTE_UPDATE

```java
private static final Set<String> SUPPORTED_TARGETS_BY_END_EXECUTE_UPDATE
```

endExecuteUpdate でサポートしている出力項目の一覧。

---

### SUPPORTED_TARGETS_BY_START_EXECUTE_BATCH

```java
private static final Set<String> SUPPORTED_TARGETS_BY_START_EXECUTE_BATCH
```

startExecuteBatch でサポートしている出力項目の一覧。

---

### SUPPORTED_TARGETS_BY_END_EXECUTE_BATCH

```java
private static final Set<String> SUPPORTED_TARGETS_BY_END_EXECUTE_BATCH
```

endExecuteBatch でサポートしている出力項目の一覧。

---

### startRetrieveStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> startRetrieveStructuredTargets
```

SqlPStatement#retrieveメソッドの検索開始時のログ出力項目

---

### endRetrieveStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> endRetrieveStructuredTargets
```

SqlPStatement#retrieveメソッドの検索終了時のログ出力項目

---

### startExecuteStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> startExecuteStructuredTargets
```

SqlPStatement#executeメソッドの実行開始時のログ出力項目

---

### endExecuteStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> endExecuteStructuredTargets
```

SqlPStatement#executeメソッドの実行終了時のログ出力項目

---

### startExecuteQueryStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> startExecuteQueryStructuredTargets
```

SqlPStatement#executeQueryメソッドの検索開始時のログ出力項目

---

### endExecuteQueryStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> endExecuteQueryStructuredTargets
```

SqlPStatement#executeQueryメソッドの検索終了時のログ出力項目

---

### startExecuteUpdateStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> startExecuteUpdateStructuredTargets
```

SqlPStatement#executeUpdateメソッドの更新開始時のログ出力項目

---

### endExecuteUpdateStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> endExecuteUpdateStructuredTargets
```

SqlPStatement#executeUpdateメソッドの更新終了時のログ出力項目

---

### startExecuteBatchStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> startExecuteBatchStructuredTargets
```

SqlPStatement#executeBatchメソッドの更新開始時のログ出力項目

---

### endExecuteBatchStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> endExecuteBatchStructuredTargets
```

SqlPStatement#executeBatchメソッドの更新終了時のログ出力項目

---

### support

```java
private JsonLogFormatterSupport support
```

各種ログのJSONフォーマット支援オブジェクト

---

## メソッドの詳細

### newUnmodifiableSet

```java
private static Set<String> newUnmodifiableSet(String values)
```

引数で指定した要素を持つ変更不可能な{@link Set}を生成する。

**パラメータ:**
- `values` - {@link Set}の要素

**戻り値:**
変更不可能な{@link Set}

---

### initialize

```java
protected void initialize(Map<String,String> props)
```

{@inheritDoc}

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

### getObjectBuilders

```java
protected Map<String,JsonLogObjectBuilder<SqlLogContext>> getObjectBuilders()
```

フォーマット対象のログ出力項目を取得する。

**戻り値:**
フォーマット対象のログ出力項目

---

### getStructuredTargets

```java
private List<JsonLogObjectBuilder<SqlLogContext>> getStructuredTargets(Map<String,JsonLogObjectBuilder<SqlLogContext>> objectBuilders, Map<String,String> props, String targetsPropName, String defaultTargets, Set<String> supportedTargets)
```

フォーマット済みのログ出力項目を取得する。

**パラメータ:**
- `objectBuilders` - オブジェクトビルダー
- `props` - 各種ログ出力の設定情報
- `targetsPropName` - 出力項目のプロパティ名
- `defaultTargets` - デフォルトの出力項目
- `supportedTargets` - サポートされている出力項目

**戻り値:**
フォーマット済みのログ出力項目

---

### startRetrieve

```java
public String startRetrieve(String methodName, String sql, int startPosition, int size, int queryTimeout, int fetchSize, String additionalInfo)
```

{@inheritDoc}

---

### endRetrieve

```java
public String endRetrieve(String methodName, long executeTime, long retrieveTime, int count)
```

{@inheritDoc}

---

### startExecuteQuery

```java
public String startExecuteQuery(String methodName, String sql, String additionalInfo)
```

{@inheritDoc}

---

### endExecuteQuery

```java
public String endExecuteQuery(String methodName, long executeTime)
```

{@inheritDoc}

---

### startExecuteUpdate

```java
public String startExecuteUpdate(String methodName, String sql, String additionalInfo)
```

{@inheritDoc}

---

### endExecuteUpdate

```java
public String endExecuteUpdate(String methodName, long executeTime, int updateCount)
```

{@inheritDoc}

---

### startExecute

```java
public String startExecute(String methodName, String sql, String additionalInfo)
```

{@inheritDoc}

---

### endExecute

```java
public String endExecute(String methodName, long executeTime)
```

{@inheritDoc}

---

### startExecuteBatch

```java
public String startExecuteBatch(String methodName, String sql, String additionalInfo)
```

{@inheritDoc}

---

### endExecuteBatch

```java
public String endExecuteBatch(String methodName, long executeTime, int batchCount)
```

{@inheritDoc}

---
