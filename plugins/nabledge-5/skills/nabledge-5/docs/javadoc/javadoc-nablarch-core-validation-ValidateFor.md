# @interface ValidateFor

**パッケージ:** nablarch.core.validation

---

```java
public @interface ValidateFor
```

バリデーションを実装するメソッドに付与するアノテーション。

<pre>
このアノテーションを付与したバリデーションメソッドは、{@link ValidationUtil}を使用して呼び出す。

    public class UserForm {

         ...

        {@code @ValidateFor("update")
        public static void validateForUpdate(ValidationContext<UserForm> context) {
            ValidationUtil.validateAll(context);
        }}
    }

    // 上のバリデーションメソッドを呼び出す場合
    // @ValidateForアノテーションで指定した"update"を指定してValidationUtilを呼び出す。
    {@code ValidationContext<UserForm> context =
        ValidationUtil.validateAndConvertRequest("user", UserForm.class, req, "update");}
</pre>

**作成者:** Koichi Asano  

---
