# class SessionKeyNotFoundException

**パッケージ:** nablarch.common.web.session

**継承階層:**
```
java.lang.Object
  └─ NoSuchElementException
      └─ nablarch.common.web.session.SessionKeyNotFoundException
```

---

```java
public class SessionKeyNotFoundException
extends NoSuchElementException
```

セッションに指定したキーが存在しないことを示す例外クラス。

**作成者:** siosio  

---

## コンストラクタの詳細

### SessionKeyNotFoundException

```java
public SessionKeyNotFoundException(String key)
```

指定されたキーが存在しないことを示す例外を生成する。

**パラメータ:**
- `key` - キー

---
