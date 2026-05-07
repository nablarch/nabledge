# 階層構造を持つFormのバリデーション

## 複数の Form に対するバリデーション

[バリデーションの実行と入力値の変換](../../component/libraries/libraries-08-02-validation-usage.md#バリデーションの実行と入力値の変換) の例では、1画面で1つの Form のみをバリデーションの対象としていた。
しかし実際のアプリケーションでは、1画面で入力した値を複数のテーブルに登録しなければならないことがほとんどである。
このようなケースの画面をバリデーションする場合、2つ以上の Entity をバリデーションで使用することになる。

このようなケースのため、 Form のプロパティに別の Form を保持し、複数の Form をまとめてバリデーションできる機能を提供している。

この際必要な実装手順は下記のとおり。

1. 親の Form (親Form)のプロパティに別の Form (子Form)を追加する。
2. 親Formの子Formを設定するセッタに、 @ValidationTarget アノテーションを設定する。
3. 親Form、子Formに共通の名称 [1] で validateFor メソッドを作成する。

例えば [Entity の使用](../../component/libraries/libraries-08-02-validation-usage.md#entity-の使用) で示した USER テーブルと、ユーザが持つ住所を保持する
ADDRESS テーブルにまとめてデータを登録する画面の場合、下記のような Form を作成する。

```java
public class UserForm {

    // ユーザ
    private UserEntity user;
    // 住所
    private AddressEntity address;

    @ValidationTarget
    public void setUser(UserEntity user) {
        this.user = user;
    }

    // getterは省略

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

上記 Form の入力となるHTMLフォームは下記のようになる。

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

このように、複数の Form に対するバリデーションを行う場合、name属性に指定する文字列を「form.user.name」
のようにピリオドで3段階に分けて記載する。

上記例から想像できるように、このname属性は1段階目がプレフィクス、
2段階目が親 Form 上の子 Form のプロパティ名、
3段階目が子 Form が持つプロパティとしてバリデーションされる。

例えば、「form.user.name」 は UserForm の user プロパティである UserEntity の name プロパティとしてバリデーションされる。

この例の入力値をバリデーションする方法は、下記のように1つの Form をバリデーションする場合と同様である。

```java
// 複数のEntityをまとめてバリデーションする例。
ValidationContext<UserForm> result
    = ValidationUtil.validateAndConvertRequest(
        "form", UserForm.class, req, "updateUser");

if (!result.isValid()) {
    throw new ApplicationException(result.getMessages());
}

// Formの生成
UserForm userForm = result.createObject();
UserEntity userEntity = userForm.getUser();
AddressEntity addressEntity = userForm.getAddress();

// user、address を使用した業務処理の実装に続く。
```

共通の名称とは、実際に「同名メソッドであること」という意味ではなく
「@ValidateFor メソッドに指定した文字列が同一である」という意味である。
例えば下記例の UserForm と UserEntity の場合、 ValidationUtil.validateAndConvertRequest
メソッドの第4引数に "multiInsert" を指定して UserForm のバリデーションを実行することで、
UserEntity のバリデーションには validateForInsert メソッドが呼び出される。
子 Form の validateFor メソッドと親 Form の validateFor メソッド の名称を一致させられない場合、この方法を使用すること。

```java
public class UserForm {
    private class UserEntity user;

    @ValidationTarget
    public void setUser(UserEntity user) {
        this.user = user;
    }

    // 中略

    @ValidateFor("multiInsert")
    public static void validateForMultiInsert(ValidationContext<UserForm> context) {
        ValidationUtil.validate(context, INSERT_PARAMS);
    }
}
```

```java
public class UserEntity {
    // 中略

    // @ValidateFor アノテーションに設定した文字列のうち、ValidationUtil.validateAndConvertRequest
    // の第4引数と1つでも一致した validateFor メソッドが呼び出される。
    private static final String[] INSERT_PARAMS = new String[] {"name", "remarks"};
    @ValidateFor({"insert", "multiInsert"})
    public static void validateForInsert(ValidationContext<UserEntity> context) {
        ValidationUtil.validate(context, INSERT_PARAMS);
    }
}
```

## Form の配列を入力する際のバリデーション

実際のアプリケーションでは、複数の住所を1つの画面で入力するなど、同一の Entity を複数まとめて入力する場面がしばしば発生する。

このような場合、 [複数の Form に対するバリデーション](../../component/libraries/libraries-08-03-validation-recursive.md#複数の-form-に対するバリデーション) で記載した方法と同様に Form に Form の配列を保持する実装を行うことで容易に実装を行える。

以下にカスタムタグを使用して、任意の数の Entity をバリデーションする実装例を示す。
カスタムタグの詳細は [JSPカスタムタグライブラリの使用方法](../../component/libraries/libraries-07-CustomTag.md#jspカスタムタグライブラリの使用方法)  を参照のこと。

### Form の実装

任意の数の Entity をバリデーションするためには、通常のFormの実装手順に加えて下記手順が必要となる。

1. Form のプロパティに Entity の配列を追加する。
2. Entity の配列のセッタに @ValidationTarget を設定する。
  @ValidationTarget の size 属性には、配列の配列長を設定する。

以下に実装例を示す。

```java
public class Example2Form {

    // 手順1 Form のプロパティに Entity の配列を追加する
    private Entity1[] entityArray;

    public Example2Form() {

    }

    public Example2Form(Map<String, Object> params) {
        entityArray =  (Entity1[]) params.get("entityArray");
        entityArraySize = (Integer) params.get("entityArraySize");
    }

    public Entity1[] getEntityArray() {
        return entityArray;
    }

    // 手順2 固定の配列長を size 属性に設定する。
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

### JSPファイル の実装

任意の数の Entity をバリデーションする際の JSP ファイルは、通常の実装に加えて下記手順が必要となる。

1. form のプロパティに対するアクセスを配列リテラル形式で記載する。
  配列リテラル形式とは、 form の Entity 配列に設定するプロパティを例えば
  "form.entityArray[0].value1" のように、 Java
  ソースコードで配列に対するアクセスと同様の添え字で記載する形式である。

以下に実装例を示す。

```jsp
<n:form windowScopePrefixes="form" name="appForm">

<table>
<c:forEach begin="0" end="2" step="1" varStatus="status">
    <tr>
        <n:set var="loopIndex" value="${status.index}"/>
        <th rowspan="3">配列 Entity1-<n:write name="loopIndex"/></th>
        <th>値１(文字列)</th>
        <td>
            <%-- form のプロパティに対するアクセスを配列リテラル形式で記載する。 --%>
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
<%-- サブミットボタン等は省略 --%>
</table>
</n:form>
```

### Action の実装

Entity の配列を使用する際も、 Action の実装方法は通常のバリデーションと同様に実装できる。

以下に上記 Form 、 JSPファイルを使用した際のバリデーション方法を示す。

```java
ValidationContext<Example2Form> validationResult = ValidationUtil.validateAndConvertRequest("form"
        , Example2Form.class, request, "validateForSample");
if (!validationResult.isValid()) {
    throw new ApplicationException(validationResult.getMessages());
}

// form 内の Entity 配列を使用した業務処理の実装
```

## 可変配列長の Form 配列を入力する際の実装例

上記 [Form の配列を入力する際のバリデーション](../../component/libraries/libraries-08-03-validation-recursive.md#form-の配列を入力する際のバリデーション) の例は、Entityの配列長が固定である場合の実装例である。

一般的なアプリケーションでは、この項目長が可変であることが珍しくない。
このような場合、ValidationTarget アノテーションの size の代わりに sizeKey を使用し、可変長項目をリクエストパラメータに加えることで、
配列の項目長を変更できる。

JSPファイルでは、 sizeKey 属性で指定したキーで配列長が、リクエストパラメータとして送信されるよう設定する。
このパラメータは、フレームワークがEntityの配列を処理するために使用する。

以下に [Form の配列を入力する際のバリデーション](../../component/libraries/libraries-08-03-validation-recursive.md#form-の配列を入力する際のバリデーション) 例を可変長配列にした場合の実装例を示す。

### Form の実装

```java
// Form のプロパティに Entity の配列長を表すプロパティを追加する。
private Integer entityArraySize;

public Example2Form() {

}

public Example2Form(Map<String, Object> params) {
    entityArray =  (Entity1[]) params.get("entityArray");
    entityArraySize = (Integer) params.get("entityArraySize");
}

// 中略

@Digits(integer=1)
@Required
@PropertyName("Entity配列長")
public void setEntityArraySize(Integer entityArraySize) {
    this.entityArraySize = entityArraySize;
}

// Entity の配列のセッタに @ValidationTarget を設定。
// @ValidationTarget の sizeKey 属性に、配列長を表すプロパティ名を設定する。
@ValidationTarget(sizeKey="entityArraySize")
public void setEntityArray(Entity1[] entityArray) {
    this.entityArray = entityArray;
}
```

### JSPの実装

```jsp
<%-- @ValidationTarget の sizeKey 属性に設定したプロパティを hidden パラメータで送信する。 --%>
<n:hidden name="form.entityArraySize" />

<%-- ループの件数を設定 --%>
<n:set var="loopCount" name="form.entityArraySize"/>

<table>
<c:forEach begin="0" end="${loopCount - 1}" step="1" varStatus="status">
    <tr>
        <n:set var="loopIndex" value="${status.index}"/>
        <th rowspan="3">配列 Entity1-<n:write name="loopIndex"/></th>
        <th>値１(文字列)</th>
        <td>
            <%-- form のプロパティに対するアクセスを配列リテラル形式で記載する。 --%>
            <n:error name="form.entityArray[${status.index}].value1" />
            <n:text name="form.entityArray[${status.index}].value1" cssClass="input" />
        </td>
    </tr>
    <!-- 前述の実装と同じなので省略 -->
</c:forEach>
```

## 画面入力用プロパティとデータベースアクセス用プロパティの変換

電話番号などの項目は、データベース上では1つのカラムとなるデータを、画面入力時は複数の入力
として取り扱うことがある。
このような場合、 Form にデータベース用のプロパティとは別に画面用のプロパティを保持する
ことでバリデーションの機構をそのまま使用できる。

下記に示すユーザの電話番号変更のHTMLフォームを例に取って使用方法を説明する。

```html
<form method="POST">
<input type="hidden" name="userForm.user.id" value="00000001"/>
電話番号: <input type="text" name="userForm.phoneNo1"/> - <input type="text" name="userForm.phoneNo2"/> - <input type="text" name="userForm.phoneNo3"/> <br/>
<input type="submit" value="変更" />
</form>
```

上記のphoneNo1、phoneNo2、phoneNo3の入力をバリデーションし、バリデーションした結果を
1つのプロパティとする場合、 Form で3つの入力値のバリデーションを実施する。

```java
public class UserForm {

    private UserEntity user;

    // 画面表示用の電話番号プロパティ
    private String phoneNo1;
    private String phoneNo2;
    private String phoneNo3;

    public UserForm(Map<String, Object> params) {
        this.user = (UserEntity) params.get("user");

        this.phoneNo1 = (String) params.get("phoneNo1");
        this.phoneNo2 = (String) params.get("phoneNo2");
        this.phoneNo3 = (String) params.get("phoneNo3");

    }

    // 再帰的にバリデーションするプロパティ

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

    // 各プロパティの getter メソッドは省略

    private static final String[] VALIDATE_PROPS = new String[] {"user", "phoneNo1", "phoneNo2", "phoneNo3"};

    @ValidateFor("updateUser")
    public static void validateForUpdateUser(ValidationContext<UserForm> context) {

        // UserEntity と phoneNo1 ～ phoneNo3 の単項目精査を実行
        ValidationUtil.validate(context, VALIDATE_PROPS);

        // 単項目精査でエラーの場合は、共通項目チェックを行わない。
        if (!context.isValid()) {
            return;
        }

        String phoneNo1 = (String) context.getConvertedValue("phoneNo1");
        String phoneNo2 = (String) context.getConvertedValue("phoneNo2");
        String phoneNo3 = (String) context.getConvertedValue("phoneNo3");
        if (phoneNo1.length() + phoneNo2.length() + phoneNo3.length() > 11) {
            // 合わせて11文字以上なら精査エラー
            context.addResultMessage("phoneNo1", "MSG00001");
        }
    }

}
```

なお、文字列連結は Action で実施する。
以下に Action の例を示す。

```java
// 入力値の精査を実施
ValidationContext<UserForm> result
    = ValidationUtil.validateAndConvertRequest(
        "userForm", UserForm.class, req, "updateUser");

if (!result.isValid()) {
    throw new ApplicationException(result.getMessages());
}

// Formの生成
UserForm userForm = result.createObject();
UserEntity userEntity = userForm.getUser();

// Entity 文字列連結した値をに設定する。
userEntity.setPhoneNo(userForm.getPhoneNo1() + "-"
    + userForm.getPhoneNo2() + "-" + userForm.getPhoneNo3());

// ・・・DBへの登録、画面遷移の処理は省略・・・
```
