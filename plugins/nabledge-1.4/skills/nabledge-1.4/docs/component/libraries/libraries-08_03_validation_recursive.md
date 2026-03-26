# 階層構造を持つFormのバリデーション

## 複数の Form に対するバリデーション

複数のFormをまとめてバリデーションする実装手順:
1. 親FormのプロパティにForm（子Form）を追加する
2. 子Formのセッタに `@ValidationTarget` を設定する
3. 親Form・子Formに `@ValidateFor` で共通名称の `validateFor` メソッドを作成する

HTMLフォームのname属性はピリオド区切り3段階で指定する（例: `form.user.name`）:
- 1段階目: プレフィクス
- 2段階目: 親Form上の子FormのプロパティName（例: `user`）
- 3段階目: 子Formのプロパティ（例: `name`）

> **注意**: `@ValidateFor` の共通名称は「同名メソッドであること」ではなく「アノテーションに指定した文字列が同一であること」を意味する。子Formのメソッド名が一致できない場合、子Formの `@ValidateFor` に複数の文字列を指定することで対応可能。

**アノテーション**: `@ValidationTarget`, `@ValidateFor`

Form実装例:
```java
public class UserForm {
    private UserEntity user;
    private AddressEntity address;

    @ValidationTarget
    public void setUser(UserEntity user) {
        this.user = user;
    }

    public UserForm(Map<String, Object> params) {
        user = (UserEntity) params.get("user");
        address = (AddressEntity) params.get("address");
    }

    @ValidationTarget
    public void setAddress(AddressEntity address) {
        this.address = address;
    }

    public static final String[] UPDATE_PARAMS = new String[] {"user", "address"};
    @ValidateFor("updateUser")
    public static void validateForUpdate(ValidationContext<UserForm> context) {
        ValidationUtil.validate(context, UPDATE_PARAMS);
    }
}
```

HTMLフォームの実装例（name属性にピリオド区切り3段階の形式を使用）:
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

バリデーション実行例:
```java
ValidationContext<UserForm> result
    = ValidationUtil.validateAndConvertRequest(
        "form", UserForm.class, req, "updateUser");

result.abortIfInvalid();

UserForm userForm = result.createObject();
UserEntity userEntity = userForm.getUser();
AddressEntity addressEntity = userForm.getAddress();
```

子Formのメソッド名が一致できない場合（`@ValidateFor` に複数文字列を指定）:
```java
// 親Form
@ValidateFor("multiInsert")
public static void validateForMultiInsert(ValidationContext<UserForm> context) {
    ValidationUtil.validate(context, INSERT_PARAMS);
}

// 子Form (UserEntity) — @ValidateFor に複数文字列を指定
@ValidateFor({"insert", "multiInsert"})
public static void validateForInsert(ValidationContext<UserEntity> context) {
    ValidationUtil.validate(context, INSERT_PARAMS);
}
```

DBでは1カラムだが画面では複数入力となる項目（例：電話番号）は、Formにデータベース用プロパティとは別に画面用プロパティを持つことで、既存のバリデーション機構をそのまま使用できる。文字列連結はActionで実施する。

**アノテーション**: `@ValidationTarget`, `@PropertyName`, `@Required`, `@Length`, `@ValidateFor`
**クラス**: `ValidationUtil`, `ValidationContext`

HTMLフォーム例（input要素のname属性は `フォーム名.プロパティ名` 形式）:
```html
<form method="POST">
<input type="hidden" name="userForm.user.id" value="00000001"/>
電話番号: <input type="text" name="userForm.phoneNo1"/> - <input type="text" name="userForm.phoneNo2"/> - <input type="text" name="userForm.phoneNo3"/> <br/>
<input type="submit" value="変更" />
</form>
```

Form実装例（電話番号3分割）:
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

    @PropertyName("電話番号2")
    @Required
    @Length(max=4)
    public void setPhoneNo2(String phoneNo2) { this.phoneNo2 = phoneNo2; }

    @PropertyName("電話番号3")
    @Required
    @Length(max=4)
    public void setPhoneNo3(String phoneNo3) { this.phoneNo3 = phoneNo3; }

    private static final String[] VALIDATE_PROPS = new String[] {"user", "phoneNo1", "phoneNo2", "phoneNo3"};

    @ValidateFor("updateUser")
    public static void validateForUpdateUser(ValidationContext<UserForm> context) {
        ValidationUtil.validate(context, VALIDATE_PROPS);
        if (!context.isValid()) return;

        String phoneNo1 = (String) context.getConvertedValue("phoneNo1");
        String phoneNo2 = (String) context.getConvertedValue("phoneNo2");
        String phoneNo3 = (String) context.getConvertedValue("phoneNo3");
        // 合計11文字超過でエラー
        if (phoneNo1.length() + phoneNo2.length() + phoneNo3.length() > 11) {
            context.addResultMessage("phoneNo1", "MSG00001");
        }
    }
}
```

Action側での文字列連結:
```java
ValidationContext<UserForm> result = ValidationUtil.validateAndConvertRequest(
    "userForm", UserForm.class, req, "updateUser");
result.abortIfInvalid();
UserForm userForm = result.createObject();
UserEntity userEntity = userForm.getUser();
userEntity.setPhoneNo(userForm.getPhoneNo1() + "-" + userForm.getPhoneNo2() + "-" + userForm.getPhoneNo3());
```

<details>
<summary>keywords</summary>

@ValidationTarget, @ValidateFor, ValidationUtil, ValidationContext, UserForm, UserEntity, AddressEntity, 複数Formバリデーション, 階層構造バリデーション, 子Formバリデーション, validateAndConvertRequest, @PropertyName, @Required, @Length, 画面入力プロパティ, 複数入力バリデーション, 電話番号分割入力, 文字列連結, バリデーション, HTMLフォーム, name属性, フォームバインディング

</details>

## Form の配列を入力する際のバリデーション: Form の実装

同一のEntityを複数まとめて入力する場合、Formに配列を保持する実装でバリデーションできる。任意の数のEntityをバリデーションするためのForm実装手順（固定配列長）:
1. FormのプロパティにEntityの配列を追加する
2. 配列のセッタに `@ValidationTarget` を設定し、`size` 属性に固定の配列長を指定する

**アノテーション**: `@ValidationTarget`, `@ValidateFor`

Form実装例（固定配列長3）:
```java
public class Example2Form {

    // 手順1: FormのプロパティにEntityの配列を追加する
    private Entity1[] entityArray;

    public Example2Form() {
    }

    public Example2Form(Map<String, Object> params) {
        entityArray = (Entity1[]) params.get("entityArray");
        entityArraySize = (Integer) params.get("entityArraySize");
    }

    public Entity1[] getEntityArray() {
        return entityArray;
    }

    // 手順2: 固定の配列長を size 属性に設定する
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

<details>
<summary>keywords</summary>

@ValidationTarget, @ValidateFor, ValidationContext, Example2Form, Entity1, Form配列バリデーション, 固定配列長, size属性, validateForSample

</details>

## Form の配列を入力する際のバリデーション: JSPファイルの実装

Form配列バリデーションのJSP実装手順:
1. formのプロパティに対するアクセスを配列リテラル形式で記載する（例: `form.entityArray[0].value1`）
   - JavaソースコードでArrayにアクセスする添え字と同様の形式

JSP実装例（配列リテラル形式）:
```jsp
<n:form windowScopePrefixes="form" name="appForm">

<table>
<c:forEach begin="0" end="2" step="1" varStatus="status">
    <tr>
        <n:set var="loopIndex" value="${status.index}"/>
        <th rowspan="3">配列 Entity1-<n:write name="loopIndex"/></th>
        <th>値１(文字列)</th>
        <td>
            <%-- formのプロパティに対するアクセスを配列リテラル形式で記載する --%>
            <n:error name="form.entityArray[${status.index}].value1" />
            <n:text name="form.entityArray[${status.index}].value1" cssClass="input" />
        </td>
    </tr>
    <tr>
        <th>値２(文字列)</th>
        <td>
            <n:error name="form.entityArray[${status.index}].value2" />
            <n:text name="form.entityArray[${status.index}].value2" cssClass="input" />
        </td>
    </tr>
    <tr>
        <th>数値</th>
        <td>
            <n:error name="form.entityArray[${status.index}].intVal" />
            <n:text name="form.entityArray[${status.index}].intVal" cssClass="input" />
        </td>
    </tr>
</c:forEach>
</table>
</n:form>
```

<details>
<summary>keywords</summary>

配列リテラル形式, c:forEach, n:text, n:error, Form配列バリデーション, entityArray, status.index

</details>

## Form の配列を入力する際のバリデーション: Action の実装

Entityの配列を使用する際も、ActionのバリデーションはFormが1つの場合と同様の実装方法で行える。

Action実装例:
```java
ValidationContext<Example2Form> validationResult = ValidationUtil.validateAndConvertRequest(
    "form", Example2Form.class, request, "validateForSample");

validateForSample.abortIfInvalid();

// form内のEntity配列を使用した業務処理の実装
```

<details>
<summary>keywords</summary>

ValidationUtil, validateAndConvertRequest, ValidationContext, abortIfInvalid, Example2Form, Form配列バリデーション

</details>

## 可変配列長の Form 配列を入力する際の実装例

配列長が可変の場合、`@ValidationTarget` の `size` 属性の代わりに `sizeKey` 属性を使用し、配列長をリクエストパラメータとして送信する。`sizeKey` にプロパティ名を指定することで、フレームワークがそのプロパティ値を配列長として使用する。

**アノテーション**: `@ValidationTarget`, `@Digits`, `@Required`, `@PropertyName`

Form実装例（可変配列長）:
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

// sizeKey に配列長プロパティ名を設定する
@ValidationTarget(sizeKey="entityArraySize")
public void setEntityArray(Entity1[] entityArray) {
    this.entityArray = entityArray;
}
```

JSP実装例（hiddenパラメータで配列長を送信）:
```jsp
<%-- sizeKey に設定したプロパティをhiddenパラメータで送信する --%>
<n:hidden name="form.entityArraySize" />

<n:set var="loopCount" name="form.entityArraySize"/>
<c:forEach begin="0" end="${loopCount - 1}" step="1" varStatus="status">
    <n:error name="form.entityArray[${status.index}].value1" />
    <n:text name="form.entityArray[${status.index}].value1" cssClass="input" />
</c:forEach>
```

<details>
<summary>keywords</summary>

@ValidationTarget, sizeKey, @Digits, @Required, @PropertyName, 可変配列長, Form配列バリデーション, entityArraySize, hiddenパラメータ

</details>
