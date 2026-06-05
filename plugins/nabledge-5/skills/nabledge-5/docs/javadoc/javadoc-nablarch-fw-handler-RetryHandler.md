# class RetryHandler

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class RetryHandler
implements Handler<Object,Object>
```

リトライ可能な例外を捕捉した場合に後続ハンドラの処理をリトライするハンドラ。
<p/>
{@link nablarch.fw.handler.retry.Retryable}インタフェースを実装した例外をリトライ可能な例外と判断する。
<p/>
リトライ処理の制御は{@link RetryContext}を実装したクラスに委譲する。
{@link RetryContext}を実装したクラスは{@link RetryContextFactory}から取得するので、
本クラスを使用する場合は{@link RetryContextFactory}オブジェクトをプロパティに設定すること。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### retryContextFactory

```java
private RetryContextFactory retryContextFactory
```

リトライコンテキストを生成する{@link RetryContextFactory}オブジェクト

---

### retryLimitExceededExitCode

```java
private int retryLimitExceededExitCode
```

リトライ上限を超えた場合に使用する終了コード(プロセスを終了({@link System#exit(int)})する際に設定する値)

---

### retryLimitExceededFailureCode

```java
private String retryLimitExceededFailureCode
```

リトライ上限を超えた場合に使用する障害コード

---

### destroyReader

```java
private boolean destroyReader
```

リトライ時に実行コンテキスト上の{@link nablarch.fw.DataReader}を破棄するか否か

---

## メソッドの詳細

### handle

```java
public Object handle(Object data, ExecutionContext context)
```

{@inheritDoc}
<p/>
リトライ対象でない例外を捕捉した場合は、補足した例外を再送出する。
<br/>
リトライ可能な例外を捕捉した場合、かつリトライ上限を超えていない場合は
後続ハンドラの処理をリトライする。
リトライ可能な例外を捕捉した場合、かつリトライ上限を超えている場合は
{@link #retryLimitExceededExitCode}プロパティと
{@link #retryLimitExceededFailureCode}プロパティを使用して
{@link ProcessAbnormalEnd}を送出する。

---

### destroyDataReader

```java
private static void destroyDataReader(ExecutionContext context)
```

実行コンテキスト上に設定された{@link nablarch.fw.DataReader}及び{@link nablarch.fw.DataReaderFactory}を破棄する。

**パラメータ:**
- `context` - 実行コンテキスト

---

### setDestroyReader

```java
public void setDestroyReader(boolean destroyReader)
```

リトライ時に{@link ExecutionContext}上に設定された{@link nablarch.fw.DataReader}を破棄するか否かを設定する。。
<p/>
本設定値に{@code true}を設定した場合、リトライ時に{@link ExecutionContext}上に設定された{@link nablarch.fw.DataReader}を破棄（削除）する。
これにより、後続ハンドラで{@link nablarch.fw.DataReader}が再生成される。

**パラメータ:**
- `destroyReader` - リトライ時にリーダを破棄するか否か

---

### setRetryContextFactory

```java
public void setRetryContextFactory(RetryContextFactory retryContextFactory)
```

リトライコンテキストを生成する{@link RetryContextFactory}オブジェクトを設定する。

**パラメータ:**
- `retryContextFactory` - リトライコンテキストを生成する{@link RetryContextFactory}オブジェクト

---

### setRetryLimitExceededExitCode

```java
public void setRetryLimitExceededExitCode(int retryLimitExceededExitCode)
```

リトライ上限を超えた場合に使用する終了コード(プロセスを終了({@link System#exit(int)})する際に設定する値)を設定する。

**パラメータ:**
- `retryLimitExceededExitCode` - リトライ上限を超えた場合に使用する終了コード(プロセスを終了({@link System#exit(int)})する際に設定する値)

---

### setRetryLimitExceededFailureCode

```java
public void setRetryLimitExceededFailureCode(String retryLimitExceededFailureCode)
```

リトライ上限を超えた場合に使用する障害コードを設定する。

**パラメータ:**
- `retryLimitExceededFailureCode` - リトライ上限を超えた場合に使用する障害コード

---
