# 階層構造を持つFormのバリデーション

## 複数の Form に対するバリデーション

## 複数の Form に対するバリデーション

複数のEntityを含む画面のバリデーションには、親FormのプロパティにsubFormを保持する方式を使う。

**実装手順**:
1. 親Formのプロパティに子Formを追加する
2. 子Formを設定するセッタに `@ValidationTarget` アノテーションを設定する
3. 親Form・子Formに共通の `@ValidateFor` 文字列で `validateFor` メソッドを作成する

> **注意**: 「共通の名称」とは同名メソッドであることではなく「`@ValidateFor` に指定した文字列が同一」であること。子Formのメソッド名が親と一致しない場合は、`@ValidateFor` に複数文字列を配列で指定することで対応できる。

HTMLフォームのname属性はピリオドで3段階に分けて記載する:
- 1段階目: プレフィクス（例: `form`）
- 2段階目: 親Form上の子FormのプロパティName（例: `user`）
- 3段階目: 子Formが持つプロパティ（例: `name`）

例: `form.user.name` → UserFormの `user` プロパティ（UserEntity）の `name` プロパティとしてバリデーション

```java
public class UserForm {
    private UserEntity user;
    private AddressEntity address;

    @ValidationTarget
    public void setUser(UserEntity user) { this.user = user; }

    @ValidationTarget
    public void setAddress(AddressEntity address) { this.address = address; }

    public static final String[] UPDATE_PARAMS = new String[] {"user", "address"};

    @ValidateFor("updateUser")
    public static void validateForUpdate(ValidationContext<UserForm> context) {
        ValidationUtil.validate(context, UPDATE_PARAMS);
    }
}
```

```html
<form method="POST">
  ユーザ名: <input type="text" name="form.user.name"/>
  備考: <input type="text" name="form.user.remarks"/>
  <input type="hidden" name="form.user.id"/>
  郵便番号: <input type="text" name="form.address.zipCode"/>
  都道府県: <input type="text" name="form.address.address1"/>
  市区町村番地: <input type="text" name="form.address.address2"/>
  マンション・ビル名: <input type="text" name="form.address.building"/>
</form>
```

バリデーション実行は単一Formと同様:
```java
ValidationContext<UserForm> result =
    ValidationUtil.validateAndConvertRequest("form", UserForm.class, req, "updateUser");
result.abortIfInvalid();
UserForm userForm = result.createObject();
UserEntity userEntity = userForm.getUser();
AddressEntity addressEntity = userForm.getAddress();
```

子Formの `@ValidateFor` 文字列が親と一致しない場合の対応例（親側と子側それぞれに `@ValidateFor` を設定）:
```java
// UserForm側（親）: validateAndConvertRequest の第4引数に "multiInsert" を指定
public class UserForm {
    private UserEntity user;

    @ValidationTarget
    public void setUser(UserEntity user) { this.user = user; }

    // 中略

    @ValidateFor("multiInsert")
    public static void validateForMultiInsert(ValidationContext<UserForm> context) {
        ValidationUtil.validate(context, INSERT_PARAMS);
    }
}
```

```java
// UserEntity側（子）: @ValidateFor に設定した文字列のうち、validateAndConvertRequest の第4引数と
// 1つでも一致した validateFor メソッドが呼び出される
private static final String[] INSERT_PARAMS = new String[] {"name", "remarks"};
@ValidateFor({"insert", "multiInsert"})
public static void validateForInsert(ValidationContext<UserEntity> context) {
    ValidationUtil.validate(context, INSERT_PARAMS);
}
```

DBでは1カラムだが画面入力では複数フィールドに分割される項目（例：電話番号）の場合、FormにDB用プロパティとは別に画面用プロパティを定義することでバリデーション機構をそのまま利用できる。文字列連結はActionで実施する。

**アノテーション**: `@ValidationTarget`, `@PropertyName`, `@Required`, `@Length`, `@ValidateFor`

**クラス**: `ValidationUtil`, `ValidationContext`

HTMLフォームの例（フィールド名の命名規則）:

```html
<form method="POST">
<input type="hidden" name="userForm.user.id" value="00000001"/>
電話番号: <input type="text" name="userForm.phoneNo1"/> - <input type="text" name="userForm.phoneNo2"/> - <input type="text" name="userForm.phoneNo3"/> <br/>
<input type="submit" value="変更" />
</form>
```

実装パターン:

1. Formに画面用プロパティ（phoneNo1/phoneNo2/phoneNo3）を定義し、各setterに`@PropertyName`/`@Required`/`@Length`を付与
2. DB用プロパティ（UserEntity）のsetterに`@ValidationTarget`を付与して再帰バリデーション対象に指定
3. コンストラクタでparamsマップから各プロパティを初期化
4. `@ValidateFor`メソッドで`ValidationUtil.validate`を呼び出し後、`context.isValid()`確認のうえ複合チェック（合計文字数など）を実施
5. ActionでvalidateAndConvertRequestを呼び出し後、各プロパティを連結してEntityのプロパティにセット

```java
public class UserForm {
    private UserEntity user;
    private String phoneNo1;
    private String phoneNo2;
    private String phoneNo3;

    public UserForm(Map<String, Object> params) {
        this.user = (UserEntity) params.get("user");
        this.phoneNo1 = (String) params.get("phoneNo1");
        this.phoneNo2 = (String) params.get("phoneNo2");
        this.phoneNo3 = (String) params.get("phoneNo3");
    }

    @ValidationTarget
    public void setUser(UserEntity user) { this.user = user; }

    @PropertyName("電話番号1")
    @Required
    @Length(max=4)
    public void setPhoneNo1(String phoneNo1) { this.phoneNo1 = phoneNo1; }

    // phoneNo2, phoneNo3 も同様

    private static final String[] VALIDATE_PROPS = {"user", "phoneNo1", "phoneNo2", "phoneNo3"};

    @ValidateFor("updateUser")
    public static void validateForUpdateUser(ValidationContext<UserForm> context) {
        ValidationUtil.validate(context, VALIDATE_PROPS);
        if (!context.isValid()) return;
        String phoneNo1 = (String) context.getConvertedValue("phoneNo1");
        String phoneNo2 = (String) context.getConvertedValue("phoneNo2");
        String phoneNo3 = (String) context.getConvertedValue("phoneNo3");
        if (phoneNo1.length() + phoneNo2.length() + phoneNo3.length() > 11) {
            context.addResultMessage("phoneNo1", "MSG00001");
        }
    }
}
```

Actionでの処理:

```java
ValidationContext<UserForm> result =
    ValidationUtil.validateAndConvertRequest("userForm", UserForm.class, req, "updateUser");
result.abortIfInvalid();
UserForm userForm = result.createObject();
UserEntity userEntity = userForm.getUser();
userEntity.setPhoneNo(userForm.getPhoneNo1() + "-" + userForm.getPhoneNo2() + "-" + userForm.getPhoneNo3());
```

<details>
<summary>keywords</summary>

@ValidationTarget, @ValidateFor, ValidationUtil, ValidationContext, 複数Form バリデーション, 親Form 子Form, 階層バリデーション, validateAndConvertRequest, UserForm, UserEntity, AddressEntity, @PropertyName, @Required, @Length, getConvertedValue, 画面入力プロパティ分割, 電話番号分割入力, 複合バリデーション, バリデーション, 文字列連結

</details>

## Form の配列を入力する際のバリデーション

## Form の配列を入力する際のバリデーション

同一Entityを複数まとめて入力する場合、FormにEntityの配列を保持する（:ref:`multi-form-validation` と同様の方式）。

**Form実装手順**:
1. FormのプロパティにEntityの配列を追加する
2. 配列のセッタに `@ValidationTarget` を設定し、`size` 属性に固定の配列長を設定する

```java
public class Example2Form {
    private Entity1[] entityArray;

    public Example2Form(Map<String, Object> params) {
        entityArray = (Entity1[]) params.get("entityArray");
        entityArraySize = (Integer) params.get("entityArraySize");
    }

    public Entity1[] getEntityArray() { return entityArray; }

    // size属性に固定の配列長を設定する
    @ValidationTarget(size = 3)
    public void setEntityArray(Entity1[] entityArray) {
        this.entityArray = entityArray;
    }

    @ValidateFor("validateForSample")
    public static void validateForSample(ValidationContext<Entity1> context) {
        ValidationUtil.validate(context, new String[] {"entityArray"});
    }
}
```

JSPでは配列リテラル形式（`form.entityArray[0].value1` のように添え字）でname属性を記載する:
```jsp
<n:form windowScopePrefixes="form" name="appForm">
<table>
<c:forEach begin="0" end="2" step="1" varStatus="status">
    <tr>
        <n:set var="loopIndex" value="${status.index}"/>
        <td>
            <n:error name="form.entityArray[${status.index}].value1" />
            <n:text name="form.entityArray[${status.index}].value1" cssClass="input" />
        </td>
    </tr>
    <tr>
        <td>
            <n:error name="form.entityArray[${status.index}].value2" />
            <n:text name="form.entityArray[${status.index}].value2" cssClass="input" />
        </td>
    </tr>
    <tr>
        <td>
            <n:error name="form.entityArray[${status.index}].intVal" />
            <n:text name="form.entityArray[${status.index}].intVal" cssClass="input" />
        </td>
    </tr>
</c:forEach>
</table>
</n:form>
```

Actionのバリデーションは通常と同様:
```java
ValidationContext<Example2Form> validationResult = ValidationUtil.validateAndConvertRequest(
    "form", Example2Form.class, request, "validateForSample");
validationResult.abortIfInvalid();
// form内のEntity配列を使用した業務処理の実装
```

<details>
<summary>keywords</summary>

@ValidationTarget, @ValidateFor, ValidationUtil, Example2Form, 配列バリデーション, 固定配列長, 配列リテラル形式, size属性, Entity1, ValidationContext

</details>

## 可変配列長の Form 配列を入力する際の実装例

## 可変配列長の Form 配列を入力する際の実装例

配列長が可変の場合、`@ValidationTarget` の `size` 属性の代わりに `sizeKey` 属性を使い、配列長をリクエストパラメータとして渡す。

**Form実装**:
- 配列長を表すプロパティを追加する
- 配列長プロパティのセッタにバリデーションアノテーション（`@Digits`、`@Required`、`@PropertyName`）を設定する
- 配列セッタの `@ValidationTarget` の `sizeKey` 属性に配列長プロパティ名を指定する

```java
private Integer entityArraySize;

public Example2Form(Map<String, Object> params) {
    entityArray = (Entity1[]) params.get("entityArray");
    entityArraySize = (Integer) params.get("entityArraySize");
}

@Digits(integer=1)
@Required
@PropertyName("Entity配列長")
public void setEntityArraySize(Integer entityArraySize) {
    this.entityArraySize = entityArraySize;
}

// sizeKey属性に配列長プロパティ名を設定する
@ValidationTarget(sizeKey="entityArraySize")
public void setEntityArray(Entity1[] entityArray) {
    this.entityArray = entityArray;
}
```

JSPでは `sizeKey` で指定したプロパティを hidden パラメータで送信し、ループ件数として使用する:
```jsp
<%-- @ValidationTarget の sizeKey 属性に設定したプロパティを hidden パラメータで送信する --%>
<n:hidden name="form.entityArraySize" />

<%-- ループの件数を設定 --%>
<n:set var="loopCount" name="form.entityArraySize"/>

<table>
<c:forEach begin="0" end="${loopCount - 1}" step="1" varStatus="status">
    <tr>
        <n:set var="loopIndex" value="${status.index}"/>
        <td>
            <n:error name="form.entityArray[${status.index}].value1" />
            <n:text name="form.entityArray[${status.index}].value1" cssClass="input" />
        </td>
    </tr>
</c:forEach>
</table>
```

<details>
<summary>keywords</summary>

@ValidationTarget, sizeKey, @Digits, @Required, @PropertyName, 可変配列長, リクエストパラメータ 配列長, entityArraySize, Example2Form, Entity1

</details>
