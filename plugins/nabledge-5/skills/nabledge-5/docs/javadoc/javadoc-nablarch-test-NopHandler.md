# class NopHandler

**パッケージ:** nablarch.test

**実装されたインタフェース:**
- Handler<Object,Object>
- Initializable

---

```java
public class NopHandler
implements Handler<Object,Object>, Initializable
```

何もしないハンドラ実装クラス。<br/>
本番で動作するハンドラを、テスト実行時のみ無効化する用途に使用する。
コンポーネント設定ファイルにて、無効にしたいハンドラの実体を本クラスにすることで、
そのハンドラの動作を無効化できる。

**作成者:** T.Kawasaki  

---

## メソッドの詳細

### handle

```java
public Object handle(Object o, ExecutionContext context)
```

{@inheritDoc}
この実装では、単に後続のハンドラに処理を委譲する。

---

### initialize

```java
public void initialize()
```

{@inheritDoc}

---
