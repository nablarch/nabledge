# class SqlLogFormatter

**パッケージ:** nablarch.core.db.statement

---

```java
public class SqlLogFormatter
```

SQLログを出力するクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### PROPS_PREFIX

```java
public static final String PROPS_PREFIX
```

プロパティ名のプレフィックス

---

### PROPS_START_RETRIEVE_FORMAT

```java
private static final String PROPS_START_RETRIEVE_FORMAT
```

SqlPStatement#retrieveメソッドの検索開始時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_END_RETRIEVE_FORMAT

```java
private static final String PROPS_END_RETRIEVE_FORMAT
```

SqlPStatement#retrieveメソッドの検索終了時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_START_EXECUTE_FORMAT

```java
private static final String PROPS_START_EXECUTE_FORMAT
```

SqlPStatement#executeメソッドの実行開始時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_END_EXECUTE_FORMAT

```java
private static final String PROPS_END_EXECUTE_FORMAT
```

SqlPStatement#executeメソッドの実行終了時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_START_EXECUTE_QUERY_FORMAT

```java
private static final String PROPS_START_EXECUTE_QUERY_FORMAT
```

SqlPStatement#executeQueryメソッドの検索開始時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_END_EXECUTE_QUERY_FORMAT

```java
private static final String PROPS_END_EXECUTE_QUERY_FORMAT
```

SqlPStatement#executeQueryメソッドの検索終了時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_START_EXECUTE_UPDATE_FORMAT

```java
private static final String PROPS_START_EXECUTE_UPDATE_FORMAT
```

SqlPStatement#executeUpdateメソッドの更新開始時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_END_EXECUTE_UPDATE_FORMAT

```java
private static final String PROPS_END_EXECUTE_UPDATE_FORMAT
```

SqlPStatement#executeUpdateメソッドの更新終了時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_START_EXECUTE_BATCH_FORMAT

```java
private static final String PROPS_START_EXECUTE_BATCH_FORMAT
```

SqlPStatement#executeBatchメソッドの更新開始時のフォーマットを取得する際に使用するプロパティ名

---

### PROPS_END_EXECUTE_BATCH_FORMAT

```java
private static final String PROPS_END_EXECUTE_BATCH_FORMAT
```

SqlPStatement#executeBatchメソッドの更新終了時のフォーマットを取得する際に使用するプロパティ名

---

### DEFAULT_START_RETRIEVE_FORMAT

```java
private static final String DEFAULT_START_RETRIEVE_FORMAT
```

SqlPStatement#retrieveメソッドの検索開始時のデフォルトのフォーマット

---

### DEFAULT_END_RETRIEVE_FORMAT

```java
private static final String DEFAULT_END_RETRIEVE_FORMAT
```

SqlPStatement#retrieveメソッドの検索終了時のデフォルトのフォーマット

---

### DEFAULT_START_EXECUTE_FORMAT

```java
private static final String DEFAULT_START_EXECUTE_FORMAT
```

SqlPStatement#executeメソッドの実行開始時のデフォルトのフォーマット

---

### DEFAULT_END_EXECUTE_FORMAT

```java
private static final String DEFAULT_END_EXECUTE_FORMAT
```

SqlPStatement#executeメソッドの実行終了時のデフォルトのフォーマット

---

### DEFAULT_START_EXECUTE_QUERY_FORMAT

```java
private static final String DEFAULT_START_EXECUTE_QUERY_FORMAT
```

SqlPStatement#executeQueryメソッドの検索開始時のデフォルトのフォーマット

---

### DEFAULT_END_EXECUTE_QUERY_FORMAT

```java
private static final String DEFAULT_END_EXECUTE_QUERY_FORMAT
```

SqlPStatement#executeQueryメソッドの検索終了時のデフォルトのフォーマット

---

### DEFAULT_START_EXECUTE_UPDATE_FORMAT

```java
private static final String DEFAULT_START_EXECUTE_UPDATE_FORMAT
```

SqlPStatement#executeUpdateメソッドの更新開始時のデフォルトのフォーマット

---

### DEFAULT_END_EXECUTE_UPDATE_FORMAT

```java
private static final String DEFAULT_END_EXECUTE_UPDATE_FORMAT
```

SqlPStatement#executeUpdateメソッドの更新終了時のデフォルトのフォーマット

---

### DEFAULT_START_EXECUTE_BATCH_FORMAT

```java
private static final String DEFAULT_START_EXECUTE_BATCH_FORMAT
```

SqlPStatement#executeBatchメソッドの更新開始時のデフォルトのフォーマット

---

### DEFAULT_END_EXECUTE_BATCH_FORMAT

```java
private static final String DEFAULT_END_EXECUTE_BATCH_FORMAT
```

SqlPStatement#executeBatchメソッドの更新終了時のデフォルトのフォーマット

---

### startRetrieveLogItems

```java
private LogItem<SqlLogContext>[] startRetrieveLogItems
```

SqlPStatement#retrieveメソッドの検索開始時のログ出力項目

---

### endRetrieveLogItems

```java
private LogItem<SqlLogContext>[] endRetrieveLogItems
```

SqlPStatement#retrieveメソッドの検索終了時のログ出力項目

---

### startExecuteLogItems

```java
private LogItem<SqlLogContext>[] startExecuteLogItems
```

SqlPStatement#executeメソッドの実行開始時のログ出力項目

---

### endExecuteLogItems

```java
private LogItem<SqlLogContext>[] endExecuteLogItems
```

SqlPStatement#executeメソッドの実行終了時のログ出力項目

---

### startExecuteQueryLogItems

```java
private LogItem<SqlLogContext>[] startExecuteQueryLogItems
```

SqlPStatement#executeQueryメソッドの検索開始時のログ出力項目

---

### endExecuteQueryLogItems

```java
private LogItem<SqlLogContext>[] endExecuteQueryLogItems
```

SqlPStatement#executeQueryメソッドの検索終了時のログ出力項目

---

### startExecuteUpdateLogItems

```java
private LogItem<SqlLogContext>[] startExecuteUpdateLogItems
```

SqlPStatement#executeUpdateメソッドの更新開始時のログ出力項目

---

### endExecuteUpdateLogItems

```java
private LogItem<SqlLogContext>[] endExecuteUpdateLogItems
```

SqlPStatement#executeUpdateメソッドの更新終了時のログ出力項目

---

### startExecuteBatchLogItems

```java
private LogItem<SqlLogContext>[] startExecuteBatchLogItems
```

SqlPStatement#executeBatchメソッドの更新開始時のログ出力項目

---

### endExecuteBatchLogItems

```java
private LogItem<SqlLogContext>[] endExecuteBatchLogItems
```

SqlPStatement#executeBatchメソッドの更新終了時のログ出力項目

---

## コンストラクタの詳細

### SqlLogFormatter

```java
public SqlLogFormatter()
```

フォーマット済みのログ出力項目を初期化する。

---

## メソッドの詳細

### initialize

```java
protected void initialize(Map<String,String> props)
```

初期化

**パラメータ:**
- `props` - 各種ログの設定情報

---

### getFormattedLogItems

```java
protected LogItem<SqlLogContext>[] getFormattedLogItems(Map<String,LogItem<SqlLogContext>> logItems, Map<String,String> props, String formatPropName, String defaultFormat)
```

フォーマット済みのログ出力項目を取得する。

**パラメータ:**
- `logItems` - フォーマット対象のログ出力項目
- `props` - 各種ログ出力の設定情報
- `formatPropName` - フォーマットのプロパティ名
- `defaultFormat` - デフォルトのフォーマット

**戻り値:**
フォーマット済みのログ出力項目

---

### getLogItems

```java
protected Map<String,LogItem<SqlLogContext>> getLogItems()
```

フォーマット対象のログ出力項目を取得する。

**戻り値:**
フォーマット対象のログ出力項目

---

### startRetrieve

```java
public String startRetrieve(String methodName, String sql, int startPosition, int size, int queryTimeout, int fetchSize, String additionalInfo)
```

SqlPStatement#retrieveメソッドの検索開始時のSQLログをフォーマットする。

**パラメータ:**
- `methodName` - メソッド名 メソッド名
- `sql` - SQL文 SQL文
- `startPosition` - 取得開始位置
- `size` - 取得最大件数
- `queryTimeout` - タイムアウト時間
- `fetchSize` - フェッチする行数
- `additionalInfo` - 付加情報 付加情報

**戻り値:**
フォーマット済みのメッセージ

---

### endRetrieve

```java
public String endRetrieve(String methodName, long executeTime, long retrieveTime, int count)
```

SqlPStatement#retrieveメソッドの検索終了時のSQLログをフォーマットする。

**パラメータ:**
- `methodName` - メソッド名 メソッド名
- `executeTime` - 実行時間
- `retrieveTime` - データ取得時間
- `count` - 検索件数

**戻り値:**
フォーマット済みのメッセージ

---

### startExecuteQuery

```java
public String startExecuteQuery(String methodName, String sql, String additionalInfo)
```

SqlPStatement#executeQueryメソッドの検索開始時のSQLログをフォーマットする。

**パラメータ:**
- `methodName` - メソッド名 メソッド名
- `sql` - SQL文
- `additionalInfo` - 付加情報

**戻り値:**
フォーマット済みメッセージ

---

### endExecuteQuery

```java
public String endExecuteQuery(String methodName, long executeTime)
```

SqlPStatement#executeQueryメソッドの検索終了時のSQLログをフォーマットする。

**パラメータ:**
- `methodName` - メソッド名 メソッド名
- `executeTime` - 実行時間

**戻り値:**
フォーマット済みメッセージ

---

### startExecuteUpdate

```java
public String startExecuteUpdate(String methodName, String sql, String additionalInfo)
```

SqlPStatement#executeUpdateメソッドの更新開始時のSQLログをフォーマットする。

**パラメータ:**
- `methodName` - メソッド名 メソッド名
- `sql` - SQL文
- `additionalInfo` - 付加情報

**戻り値:**
フォーマット済みメッセージ

---

### endExecuteUpdate

```java
public String endExecuteUpdate(String methodName, long executeTime, int updateCount)
```

SqlPStatement#executeUpdateメソッドの更新終了時のSQLログをフォーマットする。

**パラメータ:**
- `methodName` - メソッド名 メソッド名
- `executeTime` - 実行時間
- `updateCount` - 更新件数

**戻り値:**
フォーマット済みメッセージ

---

### startExecute

```java
public String startExecute(String methodName, String sql, String additionalInfo)
```

SqlPStatement#executeメソッドの実行開始時のSQLログをフォーマットする。

**パラメータ:**
- `methodName` - メソッド名 メソッド名
- `sql` - SQL文
- `additionalInfo` - 付加情報

**戻り値:**
フォーマット済みメッセージ

---

### endExecute

```java
public String endExecute(String methodName, long executeTime)
```

SqlPStatement#executeメソッドの実行終了時のSQLログをフォーマットする。

**パラメータ:**
- `methodName` - メソッド名 メソッド名
- `executeTime` - 実行時間

**戻り値:**
フォーマット済みメッセージ

---

### startExecuteBatch

```java
public String startExecuteBatch(String methodName, String sql, String additionalInfo)
```

SqlPStatement#executeBatchメソッドの更新開始時のSQLログをフォーマットする。

**パラメータ:**
- `methodName` - メソッド名
- `sql` - SQL文
- `additionalInfo` - 付加情報

**戻り値:**
フォーマット済みメッセージ

---

### endExecuteBatch

```java
public String endExecuteBatch(String methodName, long executeTime, int batchCount)
```

SqlPStatement#executeBatchメソッドの更新終了時のSQLログをフォーマットする。

**パラメータ:**
- `methodName` - メソッド名
- `executeTime` - 実行時間
- `batchCount` - バッチ件数

**戻り値:**
フォーマット済みメッセージ

---
