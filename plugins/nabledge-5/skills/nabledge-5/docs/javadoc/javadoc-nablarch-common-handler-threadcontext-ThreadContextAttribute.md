# interface ThreadContextAttribute

**パッケージ:** nablarch.common.handler.threadcontext

---

```java
public interface ThreadContextAttribute
```

{@link nablarch.core.ThreadContext}に設定する属性を返すインタフェース。
<p/>
本インタフェースを実装したクラスは、スレッドコンテキストに設定する値を取得する責務を持つ。

**param:** ハンドラの入力データの型  
**関連項目:** nablarch.core.ThreadContext  
**作成者:** Iwauo Tajima  

---

## メソッドの詳細

### getKey

```java
String getKey()
```

スレッドコンテキストに格納する際に使用するプロパティのキー名を返す。

**戻り値:**
プロパティのキー名

---

### getValue

```java
Object getValue(T req, ExecutionContext ctx)
```

スレッドコンテキストに格納するプロパティの値を返す。

**パラメータ:**
- `req` - ハンドラの入力データ
- `ctx` - 実行コンテキスト情報

**戻り値:**
プロパティの値

---
