# class BasicProcessStopHandler

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- ProcessStopHandler
- Initializable

---

```java
public class BasicProcessStopHandler
implements ProcessStopHandler, Initializable
```

処理中のプロセスを停止するためのハンドラ。
<p/>
本ハンドラは、{@link LoopHandler}や{@link ProcessResidentHandler}の後続ハンドラに設定することにより、
処理中に安全にプロセスを停止することが可能となる。
<p/>
なお、プロセスを停止するために{@link ProcessStop}を送出するため、障害通知ログが出力されプロセスは異常終了する。
異常終了する際に終了コードは、{@link #setExitCode(int)}によって設定することが出来る。
終了コードの設定を省略した場合のデフォルト動作として終了コードは1となる。
<b>また、未コミットのトランザクションは全てロールバックされることに注意すること。</b>
<p/>
※処理を異常終了するかどうかは、前段に設定されたハンドラによって決定される。
<p/>
処理を停止するか否かのチェックは、リクエストテーブルにて行う。
本ハンドラが使用するリクエストテーブルの定義情報を下記に示す。
<p/>
<pre>
-----------------------------+----------------------------------------------------------
カラム名                     | 説明
-----------------------------+----------------------------------------------------------
リクエストID                 | プロセスを特定するためのリクエストID
処理停止フラグ               | 処理を停止するか否かの情報
                             | 本フラグの値が'1'の場合に処理を停止する。
                             |
                             | <b>本フラグの値は、自動的に'0'には変更されないため再実行する際には、
                             | 手動で'0'に変更する必要がある。</b>
-----------------------------+----------------------------------------------------------
</pre>

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### PROCESS_STOP

```java
private static final String PROCESS_STOP
```

プロセス停止を示す値

---

### checkInterval

```java
private int checkInterval
```

プロセスを停止するか否かをチェックする間隔

---

### dbTransactionManager

```java
private SimpleDbTransactionManager dbTransactionManager
```

データベーストランザクションマネージャ

---

### tableName

```java
private String tableName
```

チェック対象のテーブル名

---

### requestIdColumnName

```java
private String requestIdColumnName
```

リクエストIDを示すカラム名

---

### processHaltColumnName

```java
private String processHaltColumnName
```

処理停止フラグを示すカラム名

---

### query

```java
private String query
```

プロセス停止可否をチェックするためのSQL文

---

### exitCode

```java
private int exitCode
```

終了コード

---

### count

```java
private final ThreadLocal<Integer> count
```

現在の処理件数

---

## メソッドの詳細

### handle

```java
public Object handle(Object o, ExecutionContext context)
```

{@inheritDoc}
<p/>
処理停止チェックを行う。

---

### isProcessStop

```java
public boolean isProcessStop(String requestId)
```

プロセス停止可否を判定する。

**パラメータ:**
- `requestId` - リクエストID

**戻り値:**
プロセスを停止する必要がある場合はtrue

---

### setCheckInterval

```java
public void setCheckInterval(int checkInterval)
```

チェック間隔（{@link #handle(Object, ExecutionContext)}が
何回呼び出されるごとに停止フラグを確認するか？）を設定する。
<p/>

**パラメータ:**
- `checkInterval` - チェック間隔(0以下の値が設定された場合は1)

---

### setDbTransactionManager

```java
public void setDbTransactionManager(SimpleDbTransactionManager dbTransactionManager)
```

トランザクションマネージャ({@link SimpleDbTransactionManager})を設定する。
<p/>
本ハンドラは、ここで設定されたトランザクションマネージャを使用してデータベースアクセスを行う。

**パラメータ:**
- `dbTransactionManager` - トランザクションマネージャ

---

### initialize

```java
public void initialize()
```

{@inheritDoc}
<p/>
プロセス停止可否をチェックするためのSELECT文を構築する。

---

### setTableName

```java
public void setTableName(String tableName)
```

プロセス停止可否のチェックを行うテーブルの物理名を設定する。

**パラメータ:**
- `tableName` - テーブル物理名

---

### setRequestIdColumnName

```java
public void setRequestIdColumnName(String requestIdColumnName)
```

プロセスを特定するためのリクエストIDが格納されるカラムの物理名を設定する。

**パラメータ:**
- `requestIdColumnName` - リクエストIDカラムの物理名

---

### setProcessHaltColumnName

```java
public void setProcessHaltColumnName(String processHaltColumnName)
```

プロセス停止フラグが格納されるカラムの物理名を設定する。

**パラメータ:**
- `processHaltColumnName` - プロセス停止カラムフラグの物理名

---

### setExitCode

```java
public void setExitCode(int exitCode)
```

終了コードを設定する。
<p/>
終了コードの設定がない場合、デフォルトで{@link Result.InternalError#STATUS_CODE}が使用される。

**パラメータ:**
- `exitCode` - 終了コード

---
