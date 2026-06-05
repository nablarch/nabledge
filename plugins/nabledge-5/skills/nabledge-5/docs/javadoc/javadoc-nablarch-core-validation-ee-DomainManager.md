# interface DomainManager

**パッケージ:** nablarch.core.validation.ee

---

```java
public interface DomainManager
```

ドメインバリデーションに使用するドメイン定義を管理するクラス。
<p>
  本インタフェースの実装クラスは、
  PJで作成したドメイン定義BeanのClassを返却するように実装し、
  コンポーネント定義に{@literal domainManager}というキーで登録する。
  ドメインの定義方法は{@link Domain}を参照。
</p>

**作成者:** kawasima  
**作成者:** T.Kawasaki  

---

## メソッドの詳細

### getDomainBean

```java
Class<T> getDomainBean()
```

ドメインバリデーションに使用するドメイン定義BeanのClassを取得する。

**戻り値:**
ドメイン定義BeanのClass

---
