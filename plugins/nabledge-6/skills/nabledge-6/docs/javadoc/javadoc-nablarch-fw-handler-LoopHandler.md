# class LoopHandler

**パッケージ:** nablarch.fw.handler

**継承階層:**
```
java.lang.Object
  └─ TransactionEventCallback.Provider<Object>
      └─ nablarch.fw.handler.LoopHandler
```

**実装されたインタフェース:**
- Handler<Object,Result>

---

```java
public class LoopHandler
extends TransactionEventCallback.Provider<Object>
implements Handler<Object,Result>
```

ループ制御ハンドラークラス。
<p/>
本ハンドラは、アプリケーションが処理すべきデータが存在する間、後続のハンドラに対して繰り返し処理を委譲する。
処理すべきデータが存在するかは、{@link nablarch.fw.ExecutionContext#hasNextData()}により判断する。
<p/>
また、本ハンドラではトランザクション制御もあわせて行う。
トランザクションは、指定間隔({@link #setCommitInterval(int)}毎にコミット処理を行う。
後続ハンドラから例外が送出された場合には、未コミットのトランザクションを全てロールバックし、例外を再送出する。
<p/>
本ハンドラの事前ハンドラとして、{@link nablarch.common.handler.DbConnectionManagementHandler}を登録すること。

**作成者:** Hisaaki Sioiri  
**関連項目:** NoMoreRecord  
**関連項目:** CommitLogger  
**関連項目:** TransactionContext  
**関連項目:** TransactionFactory  
**関連項目:** TransactionExecutor  

---

## フィールドの詳細

### commitLogger

```java
private CommitLogger commitLogger
```

コミットログ出力オブジェクト

---

### IS_ABOUT_TO_COMMIT_FLAG_KEY

```java
private static final String IS_ABOUT_TO_COMMIT_FLAG_KEY
```

コミット実施予告フラグを保持するリクエストスコープ変数名

---

### transactionFactory

```java
private TransactionFactory transactionFactory
```

トランザクションオブジェクトを取得するためのファクトリ

---

### transactionName

```java
private String transactionName
```

トランザクションが使用するコネクションの登録名

---

### commitInterval

```java
private int commitInterval
```

コミット間隔

---

## メソッドの詳細

### handle

```java
public Result handle(Object data, ExecutionContext context)
```

{@inheritDoc}
この実装では、特定の条件を満たすまで、以降のハンドラキューの内容を
繰り返し処理する。

---

### commit

```java
private long commit(Transaction transaction, long count, ExecutionContext context)
```

トランザクションをコミットする。
<p/>
以下の条件に合致する場合にコミット処理を行う。
<ul>
<li>未コミット件数が、コミット間隔と一致した場合</li>
<li>これ以上処理するデータが存在しない場合</li>
</ul>

**パラメータ:**
- `transaction` - トランザクションオブジェクト
- `count` - 処理件数
- `context` - 実行コンテキスト

**戻り値:**
未コミットの処理件数

---

### errorCallback

```java
private void errorCallback(Transaction transaction, Throwable e, ExecutionContext context, List<TransactionEventCallback> listeners)
```

エラー発生時のコールバック処理。

**パラメータ:**
- `transaction` - トランザクション
- `e` - 発生したエラー
- `context` - 実行コンテキスト
- `listeners` - 後続ハンドラのうち {@link TransactionEventCallback}
                  を実装しているもの。

---

### getTransactionData

```java
private static Object getTransactionData(ExecutionContext context)
```

リクエストスコープからトランザクションデータを取得する。

**パラメータ:**
- `context` - 実行コンテキスト

**戻り値:**
トランザクションデータ

---

### restoreHandlerQueue

```java
private ExecutionContext restoreHandlerQueue(ExecutionContext context, List<Handler> snapshot)
```

ハンドラキューの内容を、ループ開始前の状態に戻す。

**パラメータ:**
- `context` - 実行コンテキスト
- `snapshot` - ハンドラキューのスナップショット

**戻り値:**
実行コンテキスト(引数と同じインスタンス)

---

### shouldStop

```java
public boolean shouldStop(ExecutionContext context)
```

現在の処理終了後にループを止める場合にtrueを返す。
<p/>
デフォルトの実装では、実行コンテキスト上のデータリーダのデータが
空になるまで繰り返し処理を行う。
<p/>
これと異なる条件でループを停止させたい場合は、本メソッドをオーバライドすること。

**パラメータ:**
- `context` - 実行コンテキスト

**戻り値:**
ループを止める場合はtrue

---

### setTransactionFactory

```java
public LoopHandler setTransactionFactory(TransactionFactory transactionFactory)
```

トランザクションオブジェクトを取得するためのファクトリを設定する。

**パラメータ:**
- `transactionFactory` - トランザクションオブジェクトを取得するためのファクトリ

**戻り値:**
このハンドラ自体

---

### setTransactionName

```java
public void setTransactionName(String transactionName)
```

このハンドラが管理するトランザクションの、スレッドコンテキスト上での登録名を設定する。
<pre>
デフォルトでは既定のトランザクション名
({@link TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY})を使用する。

</pre>

**パラメータ:**
- `transactionName` - データベース接続のスレッドコンテキスト上の登録名

---

### setCommitInterval

```java
public LoopHandler setCommitInterval(int commitInterval)
```

コミット間隔を設定する。
<p/>
コミット間隔を指定した場合、指定した間隔でコミットが行われる。
なお、0以下の値を設定した場合や、設定を省略した場合のコミット間隔は1となる。

**パラメータ:**
- `commitInterval` - コミット間隔

**戻り値:**
このハンドラ自体

---

### isAboutToCommit

```java
public static final boolean isAboutToCommit(ExecutionContext ctx)
```

現在のリクエストループの業務アクション実行後にLoopHandlerによるコミットが行われるか否か。

本メソッドは DataReadHandler よりも後ろで呼び出された場合のみ正しい結果が得られる。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
業務アクション実行後にコミットが行われる場合は true

---
