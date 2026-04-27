

## Form の継承とバリデーション条件の継承

Form が持つプロパティの表示名称は、画面により様々に変化しうる。
このような場合、 Form を継承してセッタメソッドに設定する @PropertyName アノテーションを設定することで、画面に合わせてプロパティの表示名称を変更できる。
この際、バリデーションの条件は継承元の Form に指定した条件が引き継がれる。

例えば下記の Form のプロパティ「ユーザ名」を「氏名」と表示したい場合を考える。

```java
public class UserBase {
    private String id;

    private String name;

    private String remarks;

    public UserBase(Map<String, Object> params) {
        id = (String) params.get("id");
        name = (String) params.get("name");
        remarks = (String) params.get("remarks");
    }

    @PropertyName("ID")
    @Required
    @Length(min=8, max=8)
    public void setId(String id) {
        this.id = id;
    }

    @PropertyName("ユーザ名")
    @Required
    @Length(max=10)
    public void setName(String name) {
        this.name = name;
    }

    @PropertyName("備考")
    @Length(max=100)
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    // getter は省略
}
```

このような場合、下記のようにUserクラスを継承した、表示用の Form を作成する。
継承した Form は下記のようになる。

```java
public class User extends UserBase {

    public User(Map<String, Object> params) {
        super(params);
    }

    @PropertyName("氏名")
    public void setName(String name) {
        super.setName(name);
    }

    private static final String[] UPDATE_PARAMS = new String[] { "id", "name", "remarks" };
    @ValidateFor("insert")
    public static void validateForUpdate(ValidationContext<UserEntity> context) {
        ValidationUtil.validate(context, UPDATE_PARAMS);
    }
}
```

このように、継承した Form では、変更したい表示名称のプロパティのセッタをオーバライドし、変更したい表示名称にあわせて @PropertyName を設定する。

継承したクラスには、通常バリデーションの条件を表す @Required アノテーションや @Length アノテーションは指定しなくてよい。
この場合、バリデーションにはオーバライドしたメソッドで設定されていたバリデーションの条件が使用される。
上記例では、 User クラスの setName メソッドに設定された、 @Required アノテーションと @Length アノテーションで指定した条件がバリデーションに使用される。

もしバリデーションの条件も画面に特化して変更したい場合、継承するメソッドで1つ以上バリデーションの条件を表すアノテーションを指定すればよい。
例えば上記の Form で name 属性の必須入力チェックを外したい場合、下記のように User クラスを実装する。

```java
public class User extends UserBase {

    public User(Map<String, Object> params) {
        super(params);
    }

    @PropertyName("氏名")
    @Length(max=10)
    public void setName(String name) {
        super.setName(name);
    }

    private static final String[] UPDATE_PARAMS = new String[] { "id", "name", "remarks" };
    @ValidateFor("insert")
    public static void validateForUpdate(ValidationContext<UserEntity> context) {
        ValidationUtil.validate(context, UPDATE_PARAMS);
    }
}
```

なお、コンバータで使用するアノテーションも、バリデーションの条件を表すアノテーション同様に継承される。
ただし、コンバータで使用するアノテーションは、バリデーションの条件を表すアノテーションとは別に取り扱われるため、
バリデーションの条件を表すアノテーションを設定した場合でも親クラスに設定した条件がそのまま継承される。

例えば下記 ParentEntity と ChildEntity の組み合わせで、ChildEntityに対するバリデーションでは、 「@Digits(integer=5, fraction=3)」 と
「@NumberRange(min=100.0, max=20000.0)」が使用される。

```java
public class ParentEntity {

    private BigDecimal bdValue;

    // コンストラクタ省略

    public BigDecimal getBdValue() {
        return bdValue;
    }

    @Digits(integer=5, fraction=3)
    public void setBdValue(BigDecimal bdValue) {
        this.bdValue = bdValue;
    }
}
```

```java
public class ChildEntity extends ParentEntity {

    // コンストラクタ省略

    // validation の条件を追加
    @Override
    @NumberRange(min=100.0, max=20000.0)
    public void setBdValue(BigDecimal bdValue) {
        super.setBdValue(bdValue);
    }

    @ValidateFor("validateForSample")
    public static void validateForSample(ValidationContext<Entity1> context) {
        ValidationUtil.validate(context, new String[] { "dateValue", "bdValue"});
    }
}
```

> **Warning:**
> バリデーションの条件は、アプリケーションにとって重要な意味を持つ。
> 条件を変更すると、継承元のクラスの修正が継承されたクラスに反映されない状態となり、修正漏れのバグの原因になりやすい。
> 継承したクラスでのバリデーション条件の変更は、この問題を意識して慎重に実施すること。

## 国際化したプロパティの表示名称の取得方法

[バリデーションの実行と入力値の変換](../../component/libraries/libraries-08-02-validation-usage.md#validation-and-convert) の記述のように、プロパティの表示名称は基本的に @PropertyName アノテーションで指定する。
しかしこの表示名称の取得方法では、国際化したメッセージが取得できない。

このため、国際化したアプリケーションを構築する際は、  [メッセージ管理](../../component/libraries/libraries-07-Message.md#message-management) が提供するメッセージとして表示名称を対応する言語ごとに登録する。
登録した表示名称とプロパティは、下記いずれかの方法で対応付ける。

1. プロパティにつけた @PropertyName アノテーションの messageId 属性に指定した文字列をメッセージIDとして対応付ける。
2. 「クラス名 ＋ プロパティ名」をメッセージIDとして対応付ける。

それぞれの方法の使用方法を以下に示す。

### @PropertyName の messageId 属性を使用する方法

メッセージ機能から取得プロパティの表示名称を取得する際に、 @PropertyName アノテーションの value 属性ではなく、 messageId 属性を使用する。
この属性に指定したメッセージIDを使用して取得した文字列リソースをプロパティの表示名称として使用する。

この方法を使用する際、 [バリデーションの実行と入力値の変換](../../component/libraries/libraries-08-02-validation-usage.md#validation-and-convert) の例で示した Form は下記のように変わる。

```java
public class User {

    private String id;

    private String name;

    private String remarks;

    public User(Map<String, Object> params) {
        id = (String) params.get("id");
        name = (String) params.get("name");
        remarks = (String) params.get("remarks");
    }

    @PropertyName(messageId="PROP0001")
    @Required
    @Length(min=8, max=8)
    public void setId(String id) {
        this.id = id;
    }

    @PropertyName(messageId="PROP0002")
    @Required
    @Length(max=10)
    public void setName(String name) {
        this.name = name;
    }

    @PropertyName(messageId="PROP0003")
    @Length(max=100)
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    // getterは省略
}
```

このように @PropertyName の messageId 属性を設定し、messageId 属性と対応するメッセージを  [メッセージ管理](../../component/libraries/libraries-07-Message.md#message-management) が提供する
メッセージとして登録することで、「氏名は必ず入力してください。」と「You must input name.」のように、メッセージの国際化が実現できる。

例えば @Required 入力チェックエラーメッセージのメッセージIDが MSG00001 である場合、上記ソースコード例の Form の必須入力チェックの
エラーメッセージを「氏名は必ず入力してください。」と「You must input name.」とする場合、メッセージテーブルに設定するデータは下記のようになる。

| メッセージID | 言語 | メッセージ |
|---|---|---|
| MSG00001 | ja | {0}は必ず入力してください。 |
| MSG00001 | en | You must input {0}. |
| PROP0001 | ja | ID |
| PROP0001 | en | ID |
| PROP0002 | ja | 氏名 |
| PROP0002 | en | name |
| PROP0003 | ja | 備考 |
| PROP0003 | en | remarks |

### プロパティ名に対応する表示名称を使用する方法

この方法では、"<Form のクラス名>.<プロパティ名>"をメッセージIDとして使用してプロパティの表示名称を取得する。
この方法を使用する場合、 Form には @PropertyName アノテーションを設定する必要はない。

```java
public class User {

    private String id;

    private String name;

    private String remarks;

    public User(Map<String, Object> params) {
        id = (String) params.get("id");
        name = (String) params.get("name");
        remarks = (String) params.get("remarks");
    }

    @Required
    @Length(min=6, max=10)
    public void setId(String id) {
        this.id = id;
    }

    @Required
    @Length(min=6, max=10)
    public void setName(String name) {
        this.name = name;
    }

    @Length(max=100)
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    // getterは省略
}
```

例えば　@Required 入力チェックエラーメッセージのメッセージIDが MSG00001 である場合、上記ソースコード例のFormの必須入力チェックの
エラーメッセージを「氏名は必ず入力してください。」と「You must input name.」とする場合、メッセージテーブルに設定するデータは下記のようになる。

| メッセージID | 言語 | メッセージ |
|---|---|---|
| MSG00001 | ja | {0}は必ず入力してください。 |
| MSG00001 | en | You must input {0}. |
| User.id | ja | ID |
| User.id | en | ID |
| User.name | ja | 氏名 |
| User.name | en | name |
| User.remarks | ja | 備考 |
| User.remarks | en | remarks |

また、この方法を使用する際は下記のように ValidationManager クラスの useFormPropertyNameAsMessageId プロパティに true
を設定する。

```xml
<component name="validationManager" class="nablarch.core.validation.ValidationManager">
    <property name="useFormPropertyNameAsMessageId" value="true"/>
    <!-- その他のプロパティは省略 -->
</component>
```

上記のように登録、設定することで、 @PropertyName の messageId 属性を設定した場合と同様に
「氏名は必ず入力してください。」と「You must input name.」のように言語に合わせてエラーメッセージが取得できる。

### 2つの方法の選択基準

表示名称を取得する2つの方法には下記のメリット、デメリットが存在する。

1つ目の方法では、 @PropertyName アノテーションで明示的にメッセージIDを指定するため、メッセージIDの管理が容易になるメリットがあるが、
どのプロパティにどのメッセージIDを設定するかを管理する方法が必要となり、自動生成によるエンティティの生成が難しいデメリットがある。

2つ目の方法は、エンティティにアノテーションを指定する必要がなくなり、自動生成ツールが生成するエンティティのカスタマイズが不要になるメリットがある反面、
「クラス名＋プロパティ名」という通常のメッセージIDとは異なるID体系のメッセージを登録しなければならないデメリットがある。

通常のアプリケーションでは、エンティティ自動生成のメリットが生産性と品質に大きく寄与することを考慮して2つ目の方法を選択する。
1つ目の方法は顧客指定によりメッセージIDの体系に制約があり、2つ目の方法が使用できない場合のみ選択すること。
