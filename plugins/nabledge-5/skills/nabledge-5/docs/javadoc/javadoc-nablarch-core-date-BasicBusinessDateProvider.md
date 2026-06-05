# class BasicBusinessDateProvider

**パッケージ:** nablarch.core.date

**実装されたインタフェース:**
- BusinessDateProvider
- Initializable

---

```java
public class BasicBusinessDateProvider
implements BusinessDateProvider, Initializable
```

業務日付を提供するクラス。
<p/>
本クラスでは、テーブルで管理されている業務日付を取得する機能を提供する。
<p/>
業務日付の取得要求の都度データベースアクセスを行うとパフォーマンス上問題となる場合がある。
このため、{@link #cacheEnabled}プロパティを使用して業務日付のキャッシュ有無を設定でき、
データベースアクセスを最小限に抑えることが可能となっている。
<p/>
{@link #cacheEnabled}にtrueを設定するとキャッシュが有効になり、
初回アクセス時にテーブルの情報が{@link ThreadContext}にキャッシュされる。
キャッシュされた値の生存期間は、{@link ThreadContext}がクリアされるか、
スレッドが破棄されるかのどちらかである。
<p/>
例えば、画面オンライン処理の場合は、リクエスト受付時に{@link ThreadContext}の情報がクリアされるため、
業務日付のキャッシュ有効期間はクライアントからの１リクエストを処理する間となる。
<p/>
業務日付を管理するテーブルのレイアウトを以下に示す。
<table border="1">
<tr  bgcolor="#CCCCFF">
<th>カラム名</th>
<th>説明</th>
</tr>
<tr>
<td>区分</td>
<td>
業務日付を特定するための区分<br/>
例えば、画面処理とバッチ処理で日付の更新タイミングが異なる場合は、<br/>
画面処理用とバッチ処理用の区分を設けて日付を管理すれば良い。
</td>
</tr>
<tr>
<td>日付</td>
<td>区分に対応する業務日付</td>
</tr>
</table>
<p/>
なお、本クラスでは特定の区分の業務日付をリポジトリ({@link SystemRepository})
に登録した日付で上書きする機能を提供する。
この機能は、バッチアプリケーションなどで指定した日付で業務処理を実行したい場合に使用する。<br/>
<b>リポジトリに登録された日付の形式が不正な場合、初回アクセス時に{@link RuntimeException}を送出する。</b>
<p/>
リポジトリには、下記形式で上書きを行いたい日付を登録すること。
<table border="1">
<tr  bgcolor="#CCCCFF">
<th>キー</th>
<th>値</th>
</tr>
<tr>
<td>BasicBusinessDateProvider.区分値</td>
<td>上書く日付</td>
</tr>
</table>
以下に例を示す。:
<pre>
{@code
区分値:00の日付を20110101に上書きする場合

システムプロパティに「BasicBusinessDateProvider.00=20110101」を設定しプロセスを起動する。
java -DBasicBusinessDateProvider.00=20110101 Main
}
</pre>

**作成者:** Miki Habu  

---

## フィールドの詳細

### tableName

```java
private String tableName
```

業務日付テーブル物理名

---

### segmentColumnName

```java
private String segmentColumnName
```

業務日付テーブルの区分カラム物理名

---

### dateColumnName

```java
private String dateColumnName
```

業務日付テーブルの日付カラム物理名

---

### defaultSegment

```java
private String defaultSegment
```

区分値省略時のデフォルト値

---

### selectSql

```java
private String selectSql
```

取得用SQL

---

### selectAllSql

```java
private String selectAllSql
```

取得用SQL(全ての業務日付)

---

### updateDateSql

```java
private String updateDateSql
```

更新用SQL(業務日付)

---

### cacheEnabled

```java
private boolean cacheEnabled
```

キャッシュ有無

---

### dbTransactionName

```java
private String dbTransactionName
```

トランザクション名称

---

### transactionManager

```java
private SimpleDbTransactionManager transactionManager
```

トランザクションマネージャ

---

### CACHE_KEY

```java
private static final String CACHE_KEY
```

キャッシュキー

---

### CLASS_NAME

```java
private static final String CLASS_NAME
```

クラス名(単純形式)。

---

### validSegment

```java
private static Set<String> validSegment
```

有効な日付の区分を保持するSet。
<br/>
リポジトリに登録された日付のバリデーションを必要最低限に留めるために、
バリデーション済みまたはリポジトリに未登録の区分を保持する。

---

## メソッドの詳細

### setTableName

```java
public void setTableName(String tableName)
```

業務日付テーブル物理名を設定する。

**パラメータ:**
- `tableName` - 業務日付テーブル物理名

---

### setSegmentColumnName

```java
public void setSegmentColumnName(String segmentColumnName)
```

業務日付テーブルの区分カラム物理名を設定する。

**パラメータ:**
- `segmentColumnName` - 業務日付テーブルの区分カラム物理名

---

### setDateColumnName

```java
public void setDateColumnName(String dateColumnName)
```

業務日付テーブルの日付カラム物理名を設定する。

**パラメータ:**
- `dateColumnName` - 業務日付テーブルの日付カラム物理名

---

### setDefaultSegment

```java
public void setDefaultSegment(String defaultSegment)
```

区分省略時のデフォルト値を設定する。

**パラメータ:**
- `defaultSegment` - 区分省略時のデフォルト値

---

### setCacheEnabled

```java
public void setCacheEnabled(boolean cache)
```

キャッシュ有無を設定する。
<br/>
本設定を省略した場合のデフォルト動作は、キャッシュ有りとなる。

**パラメータ:**
- `cache` - キャッシュをするか否か。（キャッシュを行う場合は、true)

---

### setDbTransactionName

```java
public void setDbTransactionName(String dbTransactionName)
```

トランザクション名称を設定する。
<p/>
本設定は、デフォルトのトランザクション名({@link TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY})
以外のトランザクション名を使用する場合に設定を行えば良い。
<p/>
なお、本プロパティに設定したトランザクション名称に紐付く{@link AppDbConnection}が存在しない場合は、
{@link #setDbTransactionManager(nablarch.core.db.transaction.SimpleDbTransactionManager)}で設定された
トランザクションマネージャを使用して、短期的なトランザクションを用いて日付の取得処理を行う。

**パラメータ:**
- `dbTransactionName` - トランザクション名称。

---

### setDbTransactionManager

```java
public void setDbTransactionManager(SimpleDbTransactionManager transactionManager)
```

{@link SimpleDbTransactionManager トランザクションマネージャ}を設定する。
<p/>
データベースから日付を取得する際に使用するトランザクションを設定すること。

**パラメータ:**
- `transactionManager` - {@link SimpleDbTransactionManager トランザクションマネージャ}

---

### getDate

```java
public String getDate()
```

{@inheritDoc}
リポジトリに日付が設定されている場合は、その日付を返却する。

---

### getDate

```java
public String getDate(String segment)
```

{@inheritDoc}
リポジトリに日付が設定されている場合は、その日付を返却する。

---

### getDateBySegment

```java
private String getDateBySegment(AppDbConnection connection, String segment)
                        throws IllegalStateException
```

日付取得用のSQL文を実行し結果を返却する。

**パラメータ:**
- `connection` - {@link AppDbConnection データベース接続}
- `segment` - 区分

**戻り値:**
取得した業務日付

**例外:**
- `IllegalStateException` - 区分に対応するデータが存在しない場合

---

### getAllDate

```java
public Map<String,String> getAllDate()
```

{@inheritDoc}

---

### getAllBusinessDate

```java
private Map<String,String> getAllBusinessDate()
```

全ての業務日付を取得する。
<p/>
取得したデータは、下記形式の{@link Map}として返却する。
<pre>
key:区分
value:日付
</pre>

**戻り値:**
全業務日付

---

### getDateByUnCondition

```java
private SqlResultSet getDateByUnCondition(AppDbConnection connection)
                                  throws IllegalStateException
```

条件なしで、全日付データを取得する。

**パラメータ:**
- `connection` - {@link AppDbConnection データベース接続}

**戻り値:**
取得した日付データ

**例外:**
- `IllegalStateException` - 日付が存在しない場合

---

### setDate

```java
public void setDate(String segment, String date)
             throws IllegalArgumentException
```

{@inheritDoc}
<p/>
指定された区分に対応する業務日付を更新する。

**例外:**
- `IllegalArgumentException` - 区分または、業務日付がnullまたは空文字列の場合。
または、指定された業務日付が'yyyyMMdd'形式でない場合。

---

### updateDate

```java
private void updateDate(String segment, String date, AppDbConnection connection)
```

指定された区分に対応する日付を指定された日付に更新する。

**パラメータ:**
- `segment` - 区分
- `date` - 更新する日付
- `connection` - {@link AppDbConnection データベース接続}

---

### initialize

```java
public void initialize()
```

初期化処理を行う。<br>
SQLを組み立てる

---

### getRepositoryDate

```java
private static String getRepositoryDate(String segment)
```

リポジトリから指定された区分に対応する業務日付を取得する。

**パラメータ:**
- `segment` - 区分

**戻り値:**
業務日付。リポジトリに指定された区分が存在しない場合は、null。

---

### getCacheData

```java
private Map<String,String> getCacheData()
```

キャッシュされた業務日付を取得する。
<p/>
キャッシュにデータが存在しない場合は、{@link #getAllBusinessDate()}を使用して、
全ての業務日付を取得しキャッシュを行う。
<p/>
本機能でキャッシュしたデータは、{@link nablarch.common.handler.threadcontext.ThreadContextHandler#handle(Object, nablarch.fw.ExecutionContext)}
でクリアされる。

**戻り値:**
業務日付データ

---
