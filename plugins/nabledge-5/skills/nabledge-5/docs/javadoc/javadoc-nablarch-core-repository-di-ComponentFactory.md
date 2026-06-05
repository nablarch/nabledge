# interface ComponentFactory

**パッケージ:** nablarch.core.repository.di

---

```java
public interface ComponentFactory
```

コンポーネントのインスタンスを生成するインタフェース。

このインタフェースを登録したクラスをDIコンテナにコンポーネントとして登録した場合、
このオブジェクトそのものではなくメソッドcreateComponentで返されるオブジェクトが
コンポーネントとして使用される。

**param:** ファクトリが作成するオブジェクトの型。  
**作成者:** Koichi Asano  

---

## メソッドの詳細

### createObject

```java
T createObject()
```

オブジェクトを作成する。

**戻り値:**
作成したオブジェクト

---
