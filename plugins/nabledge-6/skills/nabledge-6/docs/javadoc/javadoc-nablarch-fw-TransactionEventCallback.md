# interface TransactionEventCallback

**パッケージ:** nablarch.fw

---

```java
public interface TransactionEventCallback
```

トランザクション(コミット or ロールバック)毎に
呼び出されるコールバックメソッドを定義するインタフェース。
<p/>

**param:**   
**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### REQUEST_DATA_REQUEST_SCOPE_KEY

```java
String REQUEST_DATA_REQUEST_SCOPE_KEY
```

リクエストデータを示すキー

---

## メソッドの詳細

### transactionNormalEnd

```java
void transactionNormalEnd(TData data, ExecutionContext ctx)
```

入力データに対する処理が正常に処理された場合に呼ばれる。

**パラメータ:**
- `data` - 入力データ
- `ctx` - 実行コンテキスト

---

### transactionAbnormalEnd

```java
void transactionAbnormalEnd(Throwable e, TData data, ExecutionContext ctx)
```

入力データに対する処理で異常が発生した場合に呼ばれる。

**パラメータ:**
- `e` - 発生したエラー
- `data` - 入力データ
- `ctx` - 実行コンテキスト

---
