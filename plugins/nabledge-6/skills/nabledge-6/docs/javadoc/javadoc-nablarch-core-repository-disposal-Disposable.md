# interface Disposable

**パッケージ:** nablarch.core.repository.disposal

---

```java
public interface Disposable
```

廃棄処理を行うインタフェース。<br>
廃棄処理を必要とするクラスは本インタフェースを実装すること。

**作成者:** Tanaka Tomoyuki  

---

## メソッドの詳細

### dispose

```java
void dispose()
             throws Exception
```

廃棄処理を行う。

**例外:**
- `Exception` - 廃棄処理中に例外が発生した場合

---
