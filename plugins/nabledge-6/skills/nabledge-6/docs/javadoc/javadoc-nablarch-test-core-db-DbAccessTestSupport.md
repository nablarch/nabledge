# class DbAccessTestSupport

**パッケージ:** nablarch.test.core.db

**継承階層:**
```
java.lang.Object
  └─ TestEventDispatcher
      └─ nablarch.test.core.db.DbAccessTestSupport
```

---

```java
public class DbAccessTestSupport
extends TestEventDispatcher
```

データベースアクセス自動テスト用基底クラス。<br/>
データベースアクセスクラスの自動テストを行う場合には、本クラスを継承しテストクラスを作成する。<br/>
本クラス以外の基底クラスを継承しなければならない場合は、<br/>
本クラスのインスタンスを生成し処理を委譲することで代替可能である。

**作成者:** Tsuyoshi Kawasaki  

---

## フィールドの詳細

### TRANSACTIONS_KEY

```java
public static final String TRANSACTIONS_KEY
```

データベーストランザクション名を取得する為のキー

---

### DB_TRANSACTION_FOR_TEST

```java
public static final String DB_TRANSACTION_FOR_TEST
```

テストクラス用トランザクション名

---

### DB_TRANSACTION_FOR_TEST_FW

```java
public static final String DB_TRANSACTION_FOR_TEST_FW
```

テスティングフレームワーク用トランザクション名

---

### transactionManagers

```java
private final List<SimpleDbTransactionManager> transactionManagers
```

トランザクションマネージャ

---

### testSupport

```java
private final TestSupport testSupport
```

テストサポート

---

## コンストラクタの詳細

### DbAccessTestSupport

```java
protected DbAccessTestSupport()
```

デフォルトコンストラクタ<br/>
サブクラスからの呼び出しを想定している。<br/>
サブクラス以外から本クラスを使用する場合は、{@link DbAccessTestSupport#DbAccessTestSupport(Class)}を使用すること。

---

### DbAccessTestSupport

```java
public DbAccessTestSupport(Class<?> testClass)
```

コンストラクタ

**パラメータ:**
- `testClass` - テストクラス（テスト対象クラスではない）

---

### DbAccessTestSupport

```java
public DbAccessTestSupport(TestSupport testSupport)
```

コンストラクタ

**パラメータ:**
- `testSupport` - テストサポート

---

## メソッドの詳細

### beginTransactions

```java
public void beginTransactions()
```

データベースアクセスクラスのテスト用にトランザクションを開始する。<br/>
開始対象のトランザクション名は、設定ファイルより取得する。<br/>
複数のトランザクションを開始する場合には、カンマ(",")区切りで複数のトランザクション名を設定する。<br/>
設定ファイル例:<br/>
<p/>
<pre>
dbAccessTest.dbTransactionName = transaction-name1,transaction-name2
</pre>
<p/>
デフォルトのトランザクション(nablarch.core.db.connection.DbConnectionContext#getConnection()で取得されるトランザクション)は、<br/>
設定ファイルの記述の有無に関わらず開始される。<br/>
デフォルトのトランザクションのみを使用する場合は、設定ファイルへの記述は不要である。

---

### getDefaultManager

```java
private SimpleDbTransactionManager getDefaultManager()
```

デフォルトのトランザクションマネージャを取得する。

**戻り値:**
デフォルトのトランザクションマネージャ

---

### commitTransactions

```java
public void commitTransactions()
```

コミットを実行する。

---

### rollbackTransactions

```java
public void rollbackTransactions()
```

トランザクションをロールバックする。

---

### endTransactions

```java
public void endTransactions()
```

トランザクションを終了する。

---

### setUpDb

```java
public void setUpDb(String sheetName)
```

データベースにデータを投入する。<br/>

**パラメータ:**
- `sheetName` - シート名

---

### setUpDb

```java
public void setUpDb(String sheetName, String groupId)
```

データベースにデータを投入する。<br/>

**パラメータ:**
- `sheetName` - シート名
- `groupId` - グループID

---

### setThreadContextValues

```java
public void setThreadContextValues(String sheetName, String id)
```

ThreadContextに値を設定する。<br/>

**パラメータ:**
- `sheetName` - 取得元シート名
- `id` - 取得元ID

---

### assertSqlResultSetEquals

```java
public void assertSqlResultSetEquals(String message, String sheetName, String id, SqlResultSet actual)
```

SqlResultSetの値とExcelファイルに記載したデータの比較を行う。<br/>
検索系テスト実行結果の検索結果確認に使用する。<br/>

**パラメータ:**
- `message` - 比較失敗時のメッセージ
- `sheetName` - 期待値を格納したシート名
- `id` - シート内のデータを特定するためのID
- `actual` - 実際の値

---

### assertSqlRowEquals

```java
public void assertSqlRowEquals(String message, String sheetName, String id, SqlRow actual)
```

SqlRowの値とExcelファイルに記載したデータの比較を行う。<br/>
検索系テスト実行結果の検索結果確認に使用する。<br/>

**パラメータ:**
- `message` - 比較失敗時のメッセージ
- `sheetName` - 期待値を格納したシート名
- `id` - シート内のデータを特定するためのID
- `actual` - 実際の値

---

### getListMap

```java
public List<Map<String,String>> getListMap(String sheetName, String id)
```

List-Map形式でデータを取得する。<br/>

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
List-Map形式のデータ

---

### getListParamMap

```java
public List<Map<String,String[]>> getListParamMap(String sheetName, String id)
```

List-Map形式でデータを取得する。<br/>
HTTPパラメータと同じ形式で取得できる（Mapの値がString[]となる）。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
List-Map形式のデータ

---

### getParamMap

```java
public Map<String,String[]> getParamMap(String sheetName, String id)
```

List-Map形式でデータを取得する。<br/>
HTTPパラメータと同じ形式で取得できる（Mapの値がString[]となる）。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
Map形式のデータ

---

### assertTableEquals

```java
public void assertTableEquals(String sheetName)
```

データベースのテーブルの値とExcelファイルに記載した値の比較を行う。<br/>
更新系テスト実行後の更新結果確認用に使用する。
テストクラスと同一のパッケージに存在するテストデータファイルから、 期待値を読み取り実際のテーブルと比較を行う。

**パラメータ:**
- `sheetName` - 期待値を格納したシート名

---

### assertTableEquals

```java
public void assertTableEquals(String message, String sheetName, boolean failIfNoDataFound)
                       throws IllegalArgumentException
```

テーブルの比較を行う。<br/>
テストクラスと同一のパッケージに存在するテストデータファイルから、
期待値を読み取り実際のテーブルと比較を行う。

**パラメータ:**
- `message` - 比較失敗時のメッセージ
- `sheetName` - 期待値を格納したシート名
- `failIfNoDataFound` - データが存在しない場合に例外とするかどうか

**例外:**
- `IllegalArgumentException` - 期待値のデータが存在せず、failIfNoDataFoundが真の場合

---

### assertTableEquals

```java
public void assertTableEquals(String sheetName, String groupId)
                       throws IllegalArgumentException
```

テーブルの比較を行う。<br/>
テストクラスと同一のパッケージに存在するテストデータファイルから、
期待値を読み取り実際のテーブルと比較を行う。

**パラメータ:**
- `sheetName` - 期待値を格納したシート名
- `groupId` - グループID（オプション）

**例外:**
- `IllegalArgumentException` - 期待値のデータが存在しない場合

---

### assertTableEquals

```java
public void assertTableEquals(String message, String sheetName, String groupId)
                       throws IllegalArgumentException
```

テーブルの比較を行う。<br/>
テストクラスと同一のパッケージに存在するテストデータファイルから、
期待値を読み取り実際のテーブルと比較を行う。

**パラメータ:**
- `message` - 比較失敗時のメッセージ
- `groupId` - グループID（オプション）
- `sheetName` - 期待値を格納したシート名

**例外:**
- `IllegalArgumentException` - 期待値のデータが存在しない場合

---

### assertTableEquals

```java
public void assertTableEquals(String message, String sheetName, String groupId, boolean failIfNoDataFound)
                       throws IllegalArgumentException
```

テーブルの比較を行う。<br/>
テストクラスと同一のパッケージに存在するテストデータファイルから、
期待値を読み取り実際のテーブルと比較を行う。

**パラメータ:**
- `message` - 比較失敗時のメッセージ
- `groupId` - グループID（オプション）
- `sheetName` - 期待値を格納したシート名
- `failIfNoDataFound` - データが存在しない場合に例外とするかどうか

**例外:**
- `IllegalArgumentException` - 期待値のデータが存在せず、failIfNoDataFoundが真の場合

---

### getTestSupport

```java
public TestSupport getTestSupport()
```

テストサポートクラスを返却する。

**戻り値:**
テストクラス

---
