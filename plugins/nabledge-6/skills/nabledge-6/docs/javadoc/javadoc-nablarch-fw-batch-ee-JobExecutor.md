# class JobExecutor

**パッケージ:** nablarch.fw.batch.ee

---

```java
public class JobExecutor
```

JOB の実行をするクラス
<p/>
JOBを実行し、終了するまで待機して以下の戻り値を返す。
<ul>
<li>正常終了：0 - 終了ステータスが "WARNING" 以外の場合で、バッチステータスが {@link BatchStatus#COMPLETED}の場合</li>
<li>異常終了：1 - 終了ステータスが "WARNING" 以外の場合で、バッチステータスが {@link BatchStatus#COMPLETED} 以外の場合</li>
<li>警告終了：2 - 終了ステータスが "WARNING" の場合</li>
</ul>
なお、JOBの終了待ちの間に中断された場合は、異常終了のコードを返す。
<p/>
バリデーションエラーなど警告すべき事項が発生している場合に、警告終了させることができる。
警告終了の方法はchunkまたはbatchlet内で、{@link jakarta.batch.runtime.context.JobContext#setExitStatus(String)}を
呼び出し "WARNING" を終了ステータスとして設定する。警告終了時は、バッチステータスは任意の値を許可するため、
chunkまたはbatchlet内で、 例外を送出しバッチステータスが {@link BatchStatus#FAILED} となる場合であっても、
終了ステータスに “WARNING” を設定していれば、警告終了する。

**作成者:** T.Shimoda  

---

## フィールドの詳細

### jobXmlName

```java
private final String jobXmlName
```

JOB XMLファイル名（.xmlを除いた名前）

---

### properties

```java
private final Properties properties
```

バッチ起動時に指定する引数

---

### jobExecution

```java
private JobExecution jobExecution
```

JOBの実行情報。

---

## コンストラクタの詳細

### JobExecutor

```java
public JobExecutor(String jobXmlName, Properties properties)
```

コンストラクタ

**パラメータ:**
- `jobXmlName` - JOB XMLファイル名
- `properties` - properties

---

## メソッドの詳細

### getJobXmlName

```java
public String getJobXmlName()
```

JOB XMLファイル名を返す。

**戻り値:**
JOB XMLファイル名

---

### getJobExecution

```java
public JobExecution getJobExecution()
```

JOBの実行情報を返す。
開始時刻や終了時刻などJOBの詳細を取得したい場合にこのAPIから取得する。

**戻り値:**
JOBの実行情報、開始前はnullを返す。

---

### execute

```java
public int execute()
```

JOBを実行する。JOBが終了または中断されるまで待機する。

**戻り値:**
終了コード

---

### execute

```java
public int execute(long mills)
```

JOBを実行する。JOBが終了または中断されるまで待機する。
指定したミリ秒間隔で終了しているかどうかのチェックを行う。

**パラメータ:**
- `mills` - 終了をチェックするミリ秒の間隔

**戻り値:**
終了コード

**例外:**
- `IllegalArgumentException` - ミリ秒が0以下の場合

---

### start

```java
private void start()
```

JOBを開始する。非同期で開始するため、終了を待つには、{@link JobExecutor#waitForEnd}を呼び出す。

**例外:**
- `IllegalStateException` - JOBが既に開始されている場合

---

### waitForEnd

```java
private int waitForEnd(long mills)
```

開始したJOBの終了を待つ。
指定したミリ秒間隔で終了しているかどうかのチェックを行う。

**パラメータ:**
- `mills` - チェックを行うミリ秒

**戻り値:**
終了コード

---

### getExitCode

```java
private int getExitCode()
```

終了コードを導出する

**戻り値:**
終了コード

---
