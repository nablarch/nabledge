# class AsyncMessageSendAction

**パッケージ:** nablarch.fw.messaging.action

**継承階層:**
```
java.lang.Object
  └─ BatchAction<SqlRow>
      └─ nablarch.fw.messaging.action.AsyncMessageSendAction
```

---

```java
public class AsyncMessageSendAction
extends BatchAction<SqlRow>
```

MQ応答なし送信用の共通アクション。
<p/>
本クラスでは、送信用のテーブル（一時テーブル）から送信対象のデータを取得し、メッセージを送信する。
<p/>
送信対象のメッセージのリクエストIDは、本バッチの起動時の引数(起動パラメータ名:messageRequestId)として指定すること。
<p/>
送信対象のデータを抽出するSQL文は、テーブル単位に用意する必要がある。
詳細は、{@link nablarch.fw.messaging.action.AsyncMessageSendAction#createStatement()}を参照
<p/>
メッセージが正常に送信できた場合には、#transactionNormalEnd(nablarch.core.db.statement.SqlRow, nablarch.fw.ExecutionContext)にて
対象データのステータスを処理済みに更新する。
<p/>
メッセージ送信時に例外が発生した場合には、#transactionAbnormalEnd(Throwable, nablarch.core.db.statement.SqlRow, nablarch.fw.ExecutionContext)にて
対象データのステータスをエラーに更新する。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### ACTION_SETTINGS_KEY

```java
private static final String ACTION_SETTINGS_KEY
```

システムリポジトリ上の設定クラスの格納キー値

---

### LAYOUT_FILE_NAME_SUFFIX

```java
private static final String LAYOUT_FILE_NAME_SUFFIX
```

電文フォーマット定義ファイルのサフィックス

---

### formConstructor

```java
private Constructor<?> formConstructor
```

Formクラスのインスタンスを生成するためのコンストラクタ

---

### sendMessageRequestId

```java
private String sendMessageRequestId
```

送信メッセージのメッセージリクエストID

---

## メソッドの詳細

### initialize

```java
protected void initialize(CommandLine command, ExecutionContext context)
```

初期処理を行う。
<p/>
起動引数から送信対象のメッセージのリクエストIDを取得し、保持する。

---

### handle

```java
public Result handle(SqlRow inputData, ExecutionContext ctx)
```

入力データからヘッダ部及び業務データ部からなるメッセージオブジェクトを生成し、
送信処理（キューへのPUT）を行う。
<p/>
処理詳細は、以下のとおり。
<ol>
<li>ヘッダ部は、{@link #createHeaderRecord(nablarch.core.db.statement.SqlRow)}で生成する。</li>
<li>業務データ部は、インプットデータ(本メソッドの引数)をそのまま使用する。</li>
<li>送信先のキューは、{@link #getQueueName()}から取得する。</li>
</ol>

---

### transactionNormalEnd

```java
public void transactionNormalEnd(SqlRow inputData, ExecutionContext ctx)
```

インプットテーブルの対象レコードのステータスを処理済みに更新する。
これにより、次回対象データ抽出時に処理済みのレコードは対象外となり、
2重送信を防止する事が出来る。
<p/>
ステータスを更新するSQL文は、{@link #getSqlResource()}で取得した
SQLリソース内に記述されたSQL_ID=UPDATE_NORMAL_ENDを使用する。

---

### transactionAbnormalEnd

```java
public void transactionAbnormalEnd(Throwable e, SqlRow inputData, ExecutionContext ctx)
```

インプットテーブルの対象レコードのステータスをエラーに更新する。
これにより、エラーレコードを再度送信することを防止する事ができる。
<p/>
（エラーレコードは、何度送信してもエラーになることが考えられるため
ステータスをエラーに変更する必要がある。)
<p/>
ステータスを更新するSQL文は、{@link #getSqlResource()}で取得した
SQLリソース内に記述されたSQL_ID=UPDATE_ABNORMAL_ENDを使用する。

---

### updateStatus

```java
protected void updateStatus(SqlRow inputData, String sqlId)
```

ステータスを更新する。
<p/>
指定されたインプットデータ、SQL_IDを元にステータスを更新する。
ステータスを更新するためのFormクラスは、nablarch.fw.messaging.action.AsyncMessageSendActionSettings#getFormClassName()
から取得したFormクラスを使用して行う。

**パラメータ:**
- `inputData` - インプットデータ
- `sqlId` - SQL_ID

---

### createReader

```java
public DataReader<SqlRow> createReader(ExecutionContext ctx)
```

送信対象のデータを抽出するための{@link nablarch.fw.reader.DatabaseRecordReader}を生成する。
{@link nablarch.fw.reader.DatabaseRecordReader}生成時に指定する{@link SqlPStatement}は、
#createStatement()により生成する。

---

### createStatement

```java
protected SqlPStatement createStatement()
```

インプットデータを抽出するための{@link SqlPStatement}を生成する。
<p/>
{@link SqlPStatement}を生成するためのSQLは、下記ルールに従い取得する。
<ui>
<li>SQLリソースは、{@link #getSqlResource()}の実装に準拠する</li>
<li>SQL_IDは、SELECT_SEND_DATA固定</li>
</ui>

**戻り値:**
{@link SqlPStatement}

---

### getSqlResource

```java
protected String getSqlResource()
```

SQLリソース名称を取得する。
<p/>
返却するSQLリソース名称は、「nablarch.fw.messaging.action.AsyncMessageSendActionSettings#getSqlFilePackage() + "." + バッチ起動時に指定した送信メッセージのメッセージリクエストID」となる。

**戻り値:**
SQLリソース名称

---

### getSettings

```java
protected AsyncMessageSendActionSettings getSettings()
```

本アクションを実行するために必要となる設定値を保持するオブジェクトを取得する。
<p/>
デフォルト動作では、リポジトリ({@link SystemRepository})から設定オブジェクトを取得する。

**戻り値:**
設定オブジェクト

---

### createHeaderRecordFormatter

```java
protected DataRecordFormatter createHeaderRecordFormatter()
```

ヘッダ部のフォーマットを生成する。
<p/>
ヘッダ部を表すフォーマット定義ファイル名は、{@link #getHeaderFormatName()}より取得する。

**戻り値:**
生成したフォーマッタ

---

### getHeaderFormatName

```java
protected String getHeaderFormatName()
```

ヘッダ部のフォーマット定義ファイル名を取得する。
<p/>
ヘッダ部のフォーマット定義ファイル名は、nablarch.fw.messaging.action.AsyncMessageSendActionSettings#getHeaderFormatName()
から取得した値となる。

**戻り値:**
フォーマット定義ファイル名

---

### createHeaderRecord

```java
protected Map<String,Object> createHeaderRecord(SqlRow inputData)
```

ヘッダデータを生成する。
<p/>
ヘッダ部に設定する項目は以下のとおり。
<ul>
<li>リクエストIDを設定するフィールド(項目名:requestId)があること。
リクエストID部には、バッチ起動時に指定された送信メッセージのメッセージIDを設定する。
</li>
<li>リクエストID以外の項目は、任意の項目を設定することが可能である。
設定する項目は、nablarch.fw.messaging.action.AsyncMessageSendActionSettings#getHeaderItemList()から取得した項目となり、
設定する値は{@link #handle(nablarch.core.db.statement.SqlRow, nablarch.fw.ExecutionContext)}のインプットデータから取得する。
</li>
</ul>

**パラメータ:**
- `inputData` - 入力データ

**戻り値:**
生成したヘッダ情報

---

### createDataRecordFormatter

```java
protected DataRecordFormatter createDataRecordFormatter()
```

データ部のフォーマッタ生成する。

**戻り値:**
生成したフォーマッタ

---

### getQueueName

```java
protected String getQueueName()
```

送信キュー名を取得する。

**戻り値:**
送信キュー名

---

### getFormatDir

```java
protected String getFormatDir()
```

フォーマット定義ファイルの配置ディレクトリを示す論理名を取得する。

**戻り値:**
フォーマット定義ファイルの配置ディレクトリ(論理名)

---

### createFormInstance

```java
protected synchronized Object createFormInstance(Map<String,?> inputData)
```

送信用一時テーブルを更新するためのFormオブジェクトを生成する。

**パラメータ:**
- `inputData` - Formインスタンスを生成するためのインプットデータ

**戻り値:**
生成したFormクラスのインスタンス

---

### getTransactionName

```java
private String getTransactionName()
```

トランザクション名を取得する。

**戻り値:**
トランザクション名

---
