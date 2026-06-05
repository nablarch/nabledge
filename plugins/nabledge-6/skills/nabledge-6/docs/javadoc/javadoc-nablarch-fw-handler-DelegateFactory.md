# interface DelegateFactory

**パッケージ:** nablarch.fw.handler

---

```java
public interface DelegateFactory
```

委譲先クラスのインスタンスを生成するファクトリインタフェース。
本インタフェースにて生成されたインタフェースは、
{@link DispatchHandler}からディスパッチされる用途に使用される。

**作成者:** Taichi Uragami  
**関連項目:** DispatchHandler#handle(Object, ExecutionContext)  

---

## メソッドの詳細

### create

```java
Object create(Class<?> clazz)
              throws InstantiationException, IllegalAccessException
```

ディスパッチ対象となるクラスのインスタンスを生成する。

**パラメータ:**
- `clazz` - ディスパッチ対象となるクラス

**戻り値:**
インスタンス

**例外:**
- `InstantiationException` - インスタンス生成に失敗した場合
- `IllegalAccessException` - クラスまたはコンストラクタにアクセスできない場合

---
