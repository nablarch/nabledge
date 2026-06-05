# class MultiThreadExecutionHandler

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- ExecutionHandler<Object,MultiStatus,MultiThreadExecutionHandler>

---

```java
public class MultiThreadExecutionHandler
implements ExecutionHandler<Object,MultiStatus,MultiThreadExecutionHandler>
```

後続ハンドラの処理を子スレッドを用いて実行するハンドラ。
<p/>
本ハンドラ以降の処理は、新たに作成する子スレッド上で実行される。
これにより、後続スレッドの処理に対するタイムアウトの設定や、
停止要求(graceful-termination)を行うことが可能となる。
<p/>
また、並行実行数を設定することにより、後続処理を複数のスレッド上で並行実行する
ことができる。(デフォルトの並行実行数は1)
<p/>
このハンドラでは、全てのスレッドで単一のデータリーダインスタンスを共有する。
従って、データリーダがアクセスするリソースに対する同期制御は各データリーダ側
で担保されている必要がある。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### concurrentNumber

```java
private int concurrentNumber
```

並行実行スレッド数 (デフォルト: 1スレッド)

---

### terminationTimeout

```java
private long terminationTimeout
```

処理停止要求のタイムアウト秒数 (デフォルト: 600秒)

---

### commitLogger

```java
private CommitLogger commitLogger
```

コミットログ

---

### taskExecutor

```java
private ThreadPoolExecutor taskExecutor
```

スレッド実行管理モジュール

---

### taskStatus

```java
private CompletionService<Result> taskStatus
```

スレッド実行状況監視モジュール

---

### taskTracker

```java
private List<Future<Result>> taskTracker
```

各スレッドの処理実行状況を保持するリスト

---

### support

```java
private final ExecutionHandler.Support<Object,MultiStatus> support
```

ユーティリティ

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## メソッドの詳細

### handle

```java
public MultiStatus handle(Object data, ExecutionContext context)
```

{@inheritDoc}
この実装では、実行コンテキストのクローンを作成し、後続のハンドラ処理を並列実行する。
<p/>
後続処理のいずれかのスレッドにおいて例外が発生した場合は、
処理中の全スレッドに対して中止要求(interruption)をかけ、その完了を待つ。
スレッド停止後、各スレッドでの処理状況の詳細をログに出力した後、
元例外をラップした Result.InternalError を送出する。
<p/>
ただし、中止要求後、terminationTimeout値に指定された秒数を過ぎても完了しない
スレッドがあった場合は、当該スレッドの停止を断念しリターンする。

---

### terminate

```java
private void terminate(ExecutionContext context)
```

使用中のデータリーダを閉じ、現在実行中の全てのスレッドに対して停止要求をかける。
<p/>
terminationTimeoutに設定された時間内にスレッドが停止しなかった場合、
その内容をログに出力する。

**パラメータ:**
- `context` - 実行コンテキスト

---

### reportThreadStatus

```java
private void reportThreadStatus(ExecutionContext context)
```

スレッドプール上の各スレッドの終了状態をログに出力する。

**パラメータ:**
- `context` - 実行コンテキスト

---

### initializeThreadPool

```java
private void initializeThreadPool()
```

スレッドプールを初期化する。

スレッドプールの通常値と上限値を一致させスレッドサイズを固定化する。
また、タスクキューの上限は設けないので、
タスク追加の時点で拒否されたり、ブロックされたりすることは無い。

なお、本ハンドラが複数回実行された場合、前回実行時に作成したスレッドプールが
アクティブであるかをチェックし、もしそうであれば再作成せずに流用する。

---

### createTaskFor

```java
private Callable<Result> createTaskFor(Object data, ExecutionContext context)
```

実行コンテキストのクローンを作成し、そのコンテキストを使用して
後続処理を行うタスクを作成する。

**パラメータ:**
- `data` - 入力データオブジェクト
- `context` - 実行コンテキスト

**戻り値:**
タスク

---

### setConcurrentNumber

```java
public MultiThreadExecutionHandler setConcurrentNumber(int concurrentNumber)
```

並行実行スレッド数を設定する。
<p/>
デフォルト値は1である。

**パラメータ:**
- `concurrentNumber` - 並行実行スレッド数

**戻り値:**
このハンドラ自体

---

### setTerminationTimeout

```java
public MultiThreadExecutionHandler setTerminationTimeout(int terminationTimeout)
```

処理停止要求のタイムアウト秒数を設定する。
<p/>
デフォルト値は 600秒 である。

**パラメータ:**
- `terminationTimeout` - 処理停止要求のタイムアウト秒数

**戻り値:**
このハンドラ自体。

---

### setCommitLogger

```java
public void setCommitLogger(CommitLogger commitLogger)
```

コミットログ出力オブジェクトを設定する。

**パラメータ:**
- `commitLogger` - コミットログ出力オブジェクト

---
