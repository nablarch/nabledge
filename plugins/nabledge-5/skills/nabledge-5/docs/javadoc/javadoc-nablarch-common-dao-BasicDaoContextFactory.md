# class BasicDaoContextFactory

**パッケージ:** nablarch.common.dao

**継承階層:**
```
java.lang.Object
  └─ DaoContextFactory
      └─ nablarch.common.dao.BasicDaoContextFactory
```

---

```java
public class BasicDaoContextFactory
extends DaoContextFactory
```

{@link DaoContextFactory}の基本実装クラス。
<p/>
本実装では、{@link BasicDaoContext}を生成する。
<p/>
{@link javax.persistence.GeneratedValue}で必要となる
{@link nablarch.common.idgenerator.IdGenerator}の実装をDIする必要がある。

**作成者:** kawasima  
**作成者:** Hisaaki Shioiri  

---

## メソッドの詳細

### create

```java
public DaoContext create()
```

---
