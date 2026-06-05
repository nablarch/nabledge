# class BatchActionBase

**パッケージ:** nablarch.fw.action

**継承階層:**
```
java.lang.Object
  └─ DbAccessSupport
      └─ nablarch.fw.action.BatchActionBase
```

**実装されたインタフェース:**
- ExecutionHandlerCallback<CommandLine,Result>
- TransactionEventCallback<D>

---

```java
public abstract class BatchActionBase
extends DbAccessSupport
implements ExecutionHandlerCallback<CommandLine,Result>, TransactionEventCallback<D>
```

バッチ処理方式において、業務処理が継承する抽象基底クラス。
<p/>
このクラスには、{@link ExecutionHandlerCallback}インタフェースに関するNOP実装が与えられており、
必要に応じてオーバーライドできるようになっている。

**param:** 本タスクが処理する入力データの型  
**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### LOG

```java
private static final Logger LOG
```

ロガー

---

## メソッドの詳細

### initialize

```java
protected void initialize(CommandLine command, ExecutionContext context)
```

実行管理ハンドラ({@link nablarch.fw.handler.ExecutionHandler})の本処理開始前に一度だけ実行される。
<p/>
デフォルトでは何もしない。
必要に応じてオーバライドすること。

**パラメータ:**
- `command` - 起動コマンドライン
- `context` - 実行コンテキスト

---

### error

```java
protected void error(Throwable error, ExecutionContext context)
```

実行時例外/エラーの発生によって本処理が終了した場合に一度だけ実行される。
<p/>
デフォルトでは何もしない。
必要に応じてオーバライドすること。

**パラメータ:**
- `error` - 本処理で発生した実行時例外/エラー
- `context` - 実行コンテキスト

---

### terminate

```java
protected void terminate(Result result, ExecutionContext context)
```

本処理が終了した場合に一度だけ実行される。
（エラー終了した場合でも実行される。）
<p/>
デフォルトでは何もしない。
必要に応じてオーバライドすること。

**パラメータ:**
- `result` - 本処理の実行結果
- `context` - 実行コンテキスト

---

### transactionSuccess

```java
protected void transactionSuccess(D inputData, ExecutionContext context)
```

トランザクション処理が正常終了した場合に実行される。
<p/>
デフォルトでは何もしない。
必要に応じてオーバライドすること。

**パラメータ:**
- `inputData` - 入力データ
- `context` - 実行コンテキスト

---

### transactionFailure

```java
protected void transactionFailure(D inputData, ExecutionContext context)
```

トランザクション処理が異常終了した場合に実行される。
<p/>
デフォルトでは何もしない。
必要に応じてオーバライドすること。

**パラメータ:**
- `inputData` - 入力データ
- `context` - 実行コンテキスト

---

### writeLog

```java
protected void writeLog(String msgId, Object msgOptions)
```

INFOレベルでログ出力を行う。

**パラメータ:**
- `msgId` - メッセージID
- `msgOptions` - メッセージIDから取得したメッセージに埋め込む値

---

### writeErrorLog

```java
protected void writeErrorLog(Object data, String failureCode, Object msgOptions)
```

ERRORレベルで障害ログ出力を行う。
<p/>
障害ログは、障害通知ログと障害解析ログの２種類に分けて出力される。

**パラメータ:**
- `data` - 処理対象データ
- `failureCode` - 障害コード（メッセージID）
- `msgOptions` - 障害コードから取得したメッセージに埋め込む値

---

### writeFatalLog

```java
protected void writeFatalLog(Object data, String failureCode, Object msgOptions)
```

FATALレベルで障害ログ出力を行う。
<p/>
障害ログは、障害通知ログと障害解析ログの２種類に分けて出力される。

**パラメータ:**
- `data` - 処理対象データ
- `failureCode` - 障害コード（メッセージID）
- `msgOptions` - 障害コードから取得したメッセージに埋め込む値

---

### preExecution

```java
public final void preExecution(CommandLine commandLine, ExecutionContext context)
```

---

### errorInExecution

```java
public final void errorInExecution(Throwable error, ExecutionContext context)
```

---

### postExecution

```java
public final void postExecution(Result result, ExecutionContext context)
```

---

### transactionNormalEnd

```java
public void transactionNormalEnd(D data, ExecutionContext ctx)
```

---

### transactionAbnormalEnd

```java
public void transactionAbnormalEnd(Throwable e, D data, ExecutionContext ctx)
```

---
