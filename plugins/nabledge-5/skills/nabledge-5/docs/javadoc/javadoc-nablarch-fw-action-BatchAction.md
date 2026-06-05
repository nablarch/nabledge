# class BatchAction

**パッケージ:** nablarch.fw.action

**継承階層:**
```
java.lang.Object
  └─ BatchActionBase<D>
      └─ nablarch.fw.action.BatchAction
```

**実装されたインタフェース:**
- Handler<D,Result>
- DataReaderFactory<D>

---

```java
public abstract class BatchAction
extends BatchActionBase<D>
implements Handler<D,Result>, DataReaderFactory<D>
```

標準的なバッチ処理における業務処理の基本実装クラス。
<p/>
バッチ処理方式では、以下のインタフェースを実装する必要がある。
<pre>
1. {@link Handler} or doXXXX() メソッド (Method-Binding使用時)
2. {@link DataReaderFactory}(必須)
3. {@link nablarch.fw.handler.ExecutionHandlerCallback}(任意)
</pre>
以下の擬似コードは、本クラスの各メソッドが
フレームワークによって呼び出される順序を表したものである。

<pre>
CommandLine      command;   // バッチ起動時のコマンドライン
ExecutionContext ctx;       // 実行コンテキスト

initialize(command, ctx);                       // バッチ処理開始前に一度だけ呼ばれる。
DataReader<TData> reader = createReader(ctx);   // バッチ処理開始前に一度だけ呼ばれる。

Result result = null;

try {
    while(reader.hasNext()) {               // データリーダ上のレコードが終端に達するまで繰り返す。

        TData data = reader.read(ctx);      // 業務トランザクション1件分の入力データを読み込む。

       try {
            result = handle(data, ctx);     // 入力データ1件毎に繰り返し呼ばれる。
            commit();                       // 業務トランザクションをコミット
            transactionSuccess(data, ctx);  // 業務トランザクションがコミットされた後で呼ばれる。

        } catch(e) {
            rollback();                     // 業務トランザクションをロールバック
            transactionFailure(data, ctx);  // 業務トランザクションがロールバックされた後で呼ばれる。
            throw e;
        }
    }

} catch(e) {
    error(e, ctx);                           // バッチがエラー終了した場合に、一度だけ呼ばれる。

} finally {
    terminate(result, ctx)                   // バッチが終了した後、一度だけ呼ばれる。
}
</pre>

また、DBアクセス処理に関するテンプレートメソッドを実装した {@link nablarch.core.db.support.DbAccessSupport}
を本クラスが継承している{@link BatchActionBase}が実装しているため、簡便に業務処理を実装することができる。

**param:** 業務処理が処理する入力データの型  
**作成者:** Iwauo Tajima  

---

## コンストラクタの詳細

### BatchAction

```java
public BatchAction()
```

{@code BatchAction}を生成する。

---

## メソッドの詳細

### handle

```java
public abstract Result handle(D inputData, ExecutionContext ctx)
```

データリーダによって読み込まれた1件分の入力データに対する業務処理を実行する。
</p>
<b>ここで実行される業務処理は原子性を保証される。</b>

**パラメータ:**
- `ctx` - 実行コンテキスト
- `inputData` - 入力データ

**戻り値:**
処理結果情報オブジェクト

---

### createReader

```java
public abstract DataReader<D> createReader(ExecutionContext ctx)
```

このタスクの入力データを読み込むデータリーダを生成して返す。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
データリーダ

---
