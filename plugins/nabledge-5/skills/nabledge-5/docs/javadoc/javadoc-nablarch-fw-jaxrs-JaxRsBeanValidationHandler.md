# class JaxRsBeanValidationHandler

**パッケージ:** nablarch.fw.jaxrs

**実装されたインタフェース:**
- Handler<HttpRequest,Object>

---

```java
public class JaxRsBeanValidationHandler
implements Handler<HttpRequest,Object>
```

リソースメソッドが受け取るBeanオブジェクトに対してバリデーションを実行するハンドラ実装クラス。
<p/>
リソースメソッドに対して{@link Valid}アノテーションが設定されている場合、
データオブジェクト(リソースメソッドの引数となるBeanオブジェクト)に対してバリデーションを行う。
リソースメソッドに{@link ConvertGroup}アノテーションが設定されている場合、バリデーション時にBean Validationのグループを設定できる。
バリデーションエラーが発生した場合には、{@link ApplicationException}を送出する。
エラーが発生しなかった場合は、後続のハンドラに処理を委譲する。

**作成者:** Hisaaki Shioiri  

---

## メソッドの詳細

### handle

```java
public Object handle(HttpRequest request, ExecutionContext context)
```

---

### validateParam

```java
private void validateParam(JaxRsContext jaxRsContext)
```

リソースメソッドのパラメータとなるBeanオブジェクトへのバリデーションを行う。

**パラメータ:**
- `jaxRsContext` - {@link JaxRsContext}

---

### validateParamWithGroup

```java
private void validateParamWithGroup(JaxRsContext jaxRsContext)
```

---
