# Formクラスの実装

## Formクラスの実装

## Formクラスのプロパティの実装

**アノテーション**: `@PropertyName`, `@Required`, `@Length`, `@SystemChar`, `@ValidationTarget`

Formクラスのsetterにアノテーションで精査仕様を設定する。

```java
public class W11ACXXForm {
    private String operationTargetUserId;
    private UsersEntity users;

    public W11ACXXForm() {
    }

    public W11ACXXForm(Map<String, Object> data) {
        operationTargetUserId = (String) data.get("operationTargetUserId");
        users = (UsersEntity) data.get("users");
    }

    @PropertyName("ユーザID")
    @Required
    @Length(max = 10)
    @SystemChar(charsetDef="numericCharset")
    public void setOperationTargetUserId(String operationTargetuserId) {
        this.operationTargetUserId = operationTargetuserId;
    }

    @ValidationTarget
    public void setUsers(UsersEntity users) {
        this.users = users;
    }
}
```

> **注意**: Formクラスのアクセッサのテストはリクエスト単体テストでカバーできる。そのため、Formクラスの単体テストでアクセッサのテストを行う必要はない。

単項目精査テスト（`EntityTestSupport`継承、`testValidateCharsetAndLength`使用）:

```java
public class W11ACXXFormTest extends EntityTestSupport {
    private static final Class<W11ACXXForm> FORM = W11ACXXForm.class;

    @Test
    public void testCharsetAndLength() {
        testValidateCharsetAndLength(FORM, "testCharsetAndLength", "charsetAndLength");
    }
}
```

## Formクラスの精査処理実装

**アノテーション**: `@ValidateFor`
**クラス**: `ValidationUtil`

精査対象プロパティを定数配列で定義し、`@ValidateFor`アノテーション付きの静的メソッドで `ValidationUtil.validate()` を呼び出す。

```java
private static final String[] SIMPLE_UPDATE_PROPS = new String[] {"users"};

@ValidateFor("simpleUpdate")
public static void validateForSimpleUpdate(ValidationContext<W11ACXXForm> context) {
    ValidationUtil.validate(context, SIMPLE_UPDATE_PROPS);
}

private static final String[] SELECT_USERINFO_PROPS = new String[] {"operationTargetUserId"};

@ValidateFor("selectUserInfo")
public static void validateForSelectUserInfo(ValidationContext<W11ACXXForm> context) {
    ValidationUtil.validate(context, SELECT_USERINFO_PROPS);
}
```

精査処理テスト（`testValidateAndConvert`使用）:

```java
@Test
public void testValidateForSimpleUpdate() {
    testValidateAndConvert(FORM, "testValidateForSimpleUpdate", "simpleUpdate");
}

@Test
public void testValidateForSelectUserInfo() {
    testValidateAndConvert(FORM, "testValidateForSelectUserInfo", "selectUserInfo");
}
```

<details>
<summary>keywords</summary>

W11ACXXForm, W11ACXXFormTest, UsersEntity, EntityTestSupport, ValidationUtil, ValidationContext, @PropertyName, @Required, @Length, @SystemChar, @ValidationTarget, @ValidateFor, Formクラス実装, バリデーション, 精査処理, 単項目精査, アノテーション設定

</details>
