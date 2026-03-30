# 階層構造を持つFormのバリデーション

## 複数の Form に対するバリデーション

複数のEntityに対するバリデーションを行う場合、親Formのプロパティに子Formを保持し、まとめてバリデーションする。

**実装手順:**
1. 親Formのプロパティに子Formを追加する
2. 子Formを設定するセッタに `@ValidationTarget` アノテーションを設定する
3. 親Form・子Formに共通の名称で `validateFor` メソッドを作成する

> **注意**: 「共通の名称」とは同名メソッドであることではなく、`@ValidateFor` アノテーションに指定した文字列が同一であることを意味する。子Formの `validateFor` メソッド名が親Formと一致しない場合は、子Formの `@ValidateFor` に配列で複数の文字列を設定し、`validateAndConvertRequest` の第4引数の文字列と1つでも一致させること。

**HTMLフォームのname属性:** ピリオドで3段階に分けて記載する（例: `form.user.name`）
- 1段階目: プレフィクス
- 2段階目: 親Form上の子FormのプロパティName
- 3段階目: 子Formが持つプロパティ

例: `form.user.name` は `UserForm` の `user` プロパティである `UserEntity` の `name` プロパティとしてバリデーションされる。

```html
<form method="POST">
<!-- ユーザの情報 -->
ユーザ名: <input type="text" name="form.user.name"/> <br/>
備考: <input type="text" name="form.user.remarks"/> <br/>
<input type="hidden" name="form.user.id"/>

<!-- 住所の情報 -->
郵便番号: <input type="text" name="form.address.zipCode"/> <br/>
都道府県: <input type="text" name="form.address.address1"/> <br/>
市区町村番地: <input type="text" name="form.address.address2"/> <br/>
マンション・ビル名: <input type="text" name="form.address.building"/> <br/>
<input type="submit" value="更新" />
</form>
```

**アノテーション**: `@ValidationTarget`, `@ValidateFor`

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

```java
ValidationContext<UserForm> result =
    ValidationUtil.validateAndConvertRequest("form", UserForm.class, req, "updateUser");
if (!result.isValid()) {
    throw new ApplicationException(result.getMessages());
}
UserForm userForm = result.createObject();
UserEntity userEntity = userForm.getUser();
AddressEntity addressEntity = userForm.getAddress();
```

子FormのvalidateForメソッド名が親Formと一致しない場合の対応例:
```java
// UserForm
@ValidateFor("multiInsert")
public static void validateForMultiInsert(ValidationContext<UserForm> context) {
    ValidationUtil.validate(context, INSERT_PARAMS);
}

// UserEntity: @ValidateFor に配列で複数の文字列を設定
// validateAndConvertRequest の第4引数と1つでも一致したメソッドが呼び出される
@ValidateFor({"insert", "multiInsert"})
public static void validateForInsert(ValidationContext<UserEntity> context) {
    ValidationUtil.validate(context, INSERT_PARAMS);
}
```

DBでは1カラムだが画面では複数入力となる項目（電話番号など）は、FormにDB用プロパティとは別に画面用プロパティを保持することで、バリデーション機構をそのまま利用できる。文字列連結はActionで実施する。

HTMLフォームのフィールド名にはプレフィックス `userForm` を付与する（`validateAndConvertRequest` の第1引数に対応）:

```html
<form method="POST">
  <input type="hidden" name="userForm.user.id" value="00000001"/>
  電話番号: <input type="text" name="userForm.phoneNo1"/> - <input type="text" name="userForm.phoneNo2"/> - <input type="text" name="userForm.phoneNo3"/> <br/>
  <input type="submit" value="変更" />
</form>
```

**アノテーション**: `@ValidationTarget`, `@PropertyName`, `@Required`, `@Length`, `@ValidateFor`

各プロパティへのバリデーション設定例（UserForm）:

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
    public void setUser(UserEntity user) {
        this.user = user;
    }

    @PropertyName("電話番号1")
    @Required
    @Length(max=4)
    public void setPhoneNo1(String phoneNo1) {
        this.phoneNo1 = phoneNo1;
    }

    @PropertyName("電話番号2")
    @Required
    @Length(max=4)
    public void setPhoneNo2(String phoneNo2) {
        this.phoneNo2 = phoneNo2;
    }

    @PropertyName("電話番号3")
    @Required
    @Length(max=4)
    public void setPhoneNo3(String phoneNo3) {
        this.phoneNo3 = phoneNo3;
    }

    private static final String[] VALIDATE_PROPS = new String[] {"user", "phoneNo1", "phoneNo2", "phoneNo3"};

    @ValidateFor("updateUser")
    public static void validateForUpdateUser(ValidationContext<UserForm> context) {
        ValidationUtil.validate(context, VALIDATE_PROPS);
        if (!context.isValid()) {
            return;
        }
        String phoneNo1 = (String) context.getConvertedValue("phoneNo1");
        String phoneNo2 = (String) context.getConvertedValue("phoneNo2");
        String phoneNo3 = (String) context.getConvertedValue("phoneNo3");
        if (phoneNo1.length() + phoneNo2.length() + phoneNo3.length() > 11) {
            context.addResultMessage("phoneNo1", "MSG00001");
        }
    }
}
```

Actionでの文字列連結例:

```java
ValidationContext<UserForm> result
    = ValidationUtil.validateAndConvertRequest(
        "userForm", UserForm.class, req, "updateUser");

if (!result.isValid()) {
    throw new ApplicationException(result.getMessages());
}

UserForm userForm = result.createObject();
UserEntity userEntity = userForm.getUser();

userEntity.setPhoneNo(userForm.getPhoneNo1() + "-"
    + userForm.getPhoneNo2() + "-" + userForm.getPhoneNo3());
```

<details>
<summary>keywords</summary>

UserForm, UserEntity, AddressEntity, ValidationContext, ValidationUtil, @ValidationTarget, @ValidateFor, ApplicationException, 複数Formバリデーション, 親Form 子Form, validateFor, name属性 ピリオド区切り, @PropertyName, @Required, @Length, 画面入力用プロパティ, データベース用プロパティ変換, 複数入力を1カラムにマッピング, 電話番号分割入力, バリデーション

</details>

## Form の配列を入力する際のバリデーション

同一Entityを複数まとめて入力する場合、FormにEntityの配列を保持して実装する。

**Formの実装手順:**
1. Formのプロパティに Entityの配列を追加する
2. Entityの配列のセッタに `@ValidationTarget` を設定し、`size` 属性に配列長を指定する

**JSPの実装:** フォームのname属性は配列リテラル形式で記載する（例: `form.entityArray[0].value1`）。Javaソースコードの配列アクセスと同様の添え字形式で記載する。

```java
public class Example2Form {
    private Entity1[] entityArray;

    public Example2Form(Map<String, Object> params) {
        entityArray = (Entity1[]) params.get("entityArray");
    }

    public Entity1[] getEntityArray() { return entityArray; }

    // 固定の配列長を size 属性に設定する
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

```jsp
<c:forEach begin="0" end="2" step="1" varStatus="status">
    <%-- 配列リテラル形式でname属性を記載 --%>
    <n:error name="form.entityArray[${status.index}].value1" />
    <n:text name="form.entityArray[${status.index}].value1" cssClass="input" />
</c:forEach>
```

```java
// Actionの実装（通常のバリデーションと同様）
ValidationContext<Example2Form> validationResult =
    ValidationUtil.validateAndConvertRequest("form", Example2Form.class, request, "validateForSample");
if (!validationResult.isValid()) {
    throw new ApplicationException(validationResult.getMessages());
}
```

<details>
<summary>keywords</summary>

Example2Form, Entity1, ValidationContext, ValidationUtil, @ValidationTarget, @ValidateFor, ApplicationException, Form配列バリデーション, 配列リテラル形式, size属性, entityArray

</details>

## 可変配列長の Form 配列を入力する際の実装例

配列長が可変の場合、`@ValidationTarget` の `size` 属性の代わりに `sizeKey` 属性を使用する。`sizeKey` に配列長を表すプロパティ名を指定し、そのプロパティ値がリクエストパラメータとしてフレームワークに渡される。JSPでは `sizeKey` 属性で指定したキーで配列長がリクエストパラメータとして送信されるよう設定する。

**Formの実装:**
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

// sizeKey属性に配列長を表すプロパティ名を設定
@ValidationTarget(sizeKey="entityArraySize")
public void setEntityArray(Entity1[] entityArray) {
    this.entityArray = entityArray;
}
```

**JSPの実装:**
```jsp
<%-- sizeKey属性に設定したプロパティを hidden パラメータで送信する --%>
<n:hidden name="form.entityArraySize" />

<n:set var="loopCount" name="form.entityArraySize"/>
<c:forEach begin="0" end="${loopCount - 1}" step="1" varStatus="status">
    <n:error name="form.entityArray[${status.index}].value1" />
    <n:text name="form.entityArray[${status.index}].value1" cssClass="input" />
</c:forEach>
```

<details>
<summary>keywords</summary>

Example2Form, Entity1, @ValidationTarget, @Digits, @Required, @PropertyName, 可変配列長, sizeKey, entityArraySize, 配列長 リクエストパラメータ

</details>
