# class BasicHttpRequestTestTemplate

**パッケージ:** nablarch.test.core.http

**継承階層:**
```
java.lang.Object
  └─ AbstractHttpRequestTestTemplate<TestCaseInfo>
      └─ nablarch.test.core.http.BasicHttpRequestTestTemplate
```

---

```java
public abstract class BasicHttpRequestTestTemplate
extends AbstractHttpRequestTestTemplate<TestCaseInfo>
```

リクエスト単体テストテンプレートの基本実装クラス。<br/>
リクエスト単体テストクラスを実装する際の型指定を簡略化するため、
本クラスは{@link TestCaseInfo}の型を指定している。

**作成者:** Tsuyoshi Kawasaki  
**関連項目:** AbstractHttpRequestTestTemplate  
**関連項目:** TestCaseInfo  

---

## コンストラクタの詳細

### BasicHttpRequestTestTemplate

```java
protected BasicHttpRequestTestTemplate()
```

コンストラクタ。

---

### BasicHttpRequestTestTemplate

```java
public BasicHttpRequestTestTemplate(Class<?> testClass)
```

コンストラクタ。

**パラメータ:**
- `testClass` - テストクラス

---
