# interface Converter

**パッケージ:** nablarch.core.beans

---

```java
public interface Converter
```

JavaBeans間のプロパティ転送の際、型の変換を行うモジュールが実装する
インターフェース。

**param:** 転送先プロパティの型  
**作成者:** kawasima  
**作成者:** tajima  

---

## メソッドの詳細

### convert

```java
T convert(Object value)
```

転送先プロパティの型に指定された値を変換する。

**パラメータ:**
- `value` - 値

**戻り値:**
T

---
