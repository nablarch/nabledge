# interface ExecutionHandlerCallback

**パッケージ:** nablarch.fw.handler

---

```java
public interface ExecutionHandlerCallback
```

実行制御ハンドラ内の処理状況に応じて呼び出される各種コールバックを定義する
インターフェース。

**param:** ハンドラへの入力データの型  
**param:** ハンドラの処理結果データの型  
**作成者:** Iwauo Tajima  

---

## メソッドの詳細

### preExecution

```java
void preExecution(TData data, ExecutionContext context)
```

実行制御ハンドラが後続処理を実行する前にコールバックされる。
一括処理実行前に、なんらかの初期処理を行う場合に実装する。

**パラメータ:**
- `data` - 入力データ
- `context` - 実行コンテキスト

---

### errorInExecution

```java
void errorInExecution(Throwable error, ExecutionContext context)
```

実行制御ハンドラが後続処理を実行した後、
後続のハンドラでエラーが発生した場合に呼ばれる。

**パラメータ:**
- `error` - 後続ハンドラの処理中に発生した実行時例外/エラー
- `context` - 実行コンテキスト

---

### postExecution

```java
void postExecution(TResult result, ExecutionContext context)
```

実行制御ハンドラが後続処理を実行した後、正常、異常終了を問わず
処理が全て完了した直後に呼ばれる。

すなわち、正常終了時には、{@lik #preExecution(Object, ExecutionContext)}
の後、異常終了時には {@link #errorInExecution(Throwable, ExecutionContext)}
の後で本メソッドが呼ばれる。

**パラメータ:**
- `result` - ハンドラの戻り値となるオブジェクト
- `context` - 実行コンテキスト

---
