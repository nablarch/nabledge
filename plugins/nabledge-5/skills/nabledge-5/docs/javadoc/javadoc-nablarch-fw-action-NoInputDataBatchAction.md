# class NoInputDataBatchAction

**パッケージ:** nablarch.fw.action

**継承階層:**
```
java.lang.Object
  └─ BatchAction<Object>
      └─ nablarch.fw.action.NoInputDataBatchAction
```

---

```java
public abstract class NoInputDataBatchAction
extends BatchAction<Object>
```

入力データを必要としないバッチ処理用の基本実装クラス。
<p/>
本クラスの各メソッドがフレームワークによって呼び出される順序は以下のとおり。
<pre>
{@code
initialize()              <-- 本処理開始前に一度だけ呼ばれる。
try {
  handle()                <-- 1度だけ呼ばれる。
} catch(e) {
  error()                 <-- 本処理がエラー終了した場合に、一度だけ呼ばれる。
} finally {
  terminate()             <-- 本処理が全て終了した後、一度だけ呼ばれる。
}
}
</pre>

**作成者:** hisaaki sioiri  

---

## コンストラクタの詳細

### NoInputDataBatchAction

```java
public NoInputDataBatchAction()
```

インスタンスを生成する。

---

## メソッドの詳細

### handle

```java
public final Result handle(Object inputData, ExecutionContext ctx)
```

データリーダによって読み込まれた1件分の入力データに対する 業務処理を実行する。
<p/>
処理を{@link #handle(nablarch.fw.ExecutionContext)}に委譲する。

---

### handle

```java
public abstract Result handle(ExecutionContext ctx)
```

本処理を実行する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
処理結果を表す{@link Result}

---

### createReader

```java
public final DataReader<Object> createReader(ExecutionContext ctx)
```

1度だけ本処理を呼び出すための{@link DataReader}を生成する。

---
