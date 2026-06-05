# interface DataReader

**パッケージ:** nablarch.fw

---

```java
public interface DataReader
```

{@link Handler}が処理する入力データを外部から読み込むインタフェース。
<p/>
データリーダは複数のリクエストスレッドから並行アクセスされ得るので、
各メソッドはスレッドセーフに実装されなければならない。

**param:** このクラスが読み込んだデータの型  
**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## メソッドの詳細

### read

```java
TData read(ExecutionContext ctx)
```

{@link Handler}が処理する入力データを読み込んで返却する。
<p/>
入力データがこれ以上存在しない状態、
すなわち、hasNext()の結果が{@code false}となる場合はnullを返すこと。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
入力データオブジェクト。存在しない場合はnull

---

### hasNext

```java
boolean hasNext(ExecutionContext ctx)
```

次に読み込むデータが存在するかどうかを返却する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
次に読み込むデータが存在する場合は{@code true}

---

### close

```java
void close(ExecutionContext ctx)
```

このリーダの利用を停止し、内部的に保持している各種リソースを解放する。

**パラメータ:**
- `ctx` - 実行コンテキスト

---
