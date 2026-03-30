# Form の継承とバリデーション条件の継承

## Form の継承とバリデーション条件の継承

FormのセッタメソッドをオーバーライドしてFormを継承し、`@PropertyName`アノテーションを設定することで画面ごとにプロパティの表示名称を変更できる。バリデーション条件は継承元のFormの条件が引き継がれる。

**アノテーション**: `@PropertyName`, `@Required`, `@Length`, `@ValidateFor`, `@Digits`, `@NumberRange`

**バリデーション条件の継承ルール**:
- 継承クラスのオーバーライドメソッドにバリデーション条件アノテーション（`@Required`, `@Length`等）を指定しない場合、親クラスの条件が使用される
- 継承クラスに1つ以上のバリデーション条件アノテーションを指定した場合、親クラスのバリデーション条件は使用されなくなる（継承クラスの条件に差し替えられる）
- コンバータアノテーションはバリデーション条件アノテーションとは別扱い。バリデーション条件を差し替えた場合でも、親クラスのコンバータアノテーションは引き継がれる

**実装例（表示名称のみ変更）**:
```java
public class User extends UserBase {
    @PropertyName("氏名")   // @Required, @Length は指定不要（親クラスの条件が引き継がれる）
    public void setName(String name) { super.setName(name); }
}
```

**実装例（バリデーション条件も変更）**:
```java
public class User extends UserBase {
    @PropertyName("氏名")
    @Length(max=10)   // 1つ以上バリデーション条件アノテーションを指定 → 親クラスの@Required, @Lengthは使用されない
    public void setName(String name) { super.setName(name); }

    private static final String[] UPDATE_PARAMS = new String[] { "id", "name", "remarks" };
    @ValidateFor("insert")
    public static void validateForUpdate(ValidationContext<UserEntity> context) {
        ValidationUtil.validate(context, UPDATE_PARAMS);
    }
}
```

**コンバータアノテーション継承例（`@Digits`と`@NumberRange`の組み合わせ）**:
```java
// ParentEntity: @Digits(integer=5, fraction=3) が設定済み
// ChildEntityに @NumberRange(min=100.0, max=20000.0) を追加
// → ChildEntityのバリデーションには両方（@Digits と @NumberRange）が使用される
class ChildEntity extends ParentEntity {
    @Override
    @NumberRange(min=100.0, max=20000.0)
    public void setBdValue(BigDecimal bdValue) { super.setBdValue(bdValue); }

    @ValidateFor("validateForSample")
    public static void validateForSample(ValidationContext<Entity1> context) {
        ValidationUtil.validate(context, new String[] { "dateValue", "bdValue"});
    }
}
```

> **警告**: バリデーション条件の変更は、継承元の修正が継承クラスに反映されない状態となり、修正漏れのバグの原因になりやすい。継承クラスでのバリデーション条件変更は慎重に実施すること。

<details>
<summary>keywords</summary>

UserBase, UserEntity, ParentEntity, ChildEntity, ValidationContext, ValidationUtil, @PropertyName, @Required, @Length, @ValidateFor, @Digits, @NumberRange, Form継承, バリデーション条件継承, 表示名称変更, コンバータアノテーション継承, プロパティ名上書き

</details>

## 国際化したプロパティの表示名称の取得方法

`@PropertyName`アノテーションのvalue属性では国際化したメッセージが取得できない。国際化アプリケーションでは、:ref:`message_management`のメッセージとして表示名称を言語ごとに登録し、以下の2つの方法のいずれかでプロパティと対応付ける。

**クラス**: `nablarch.core.validation.ValidationManager`
**アノテーション**: `@PropertyName`

### @PropertyName の messageId 属性を使用する方法

`@PropertyName`の`value`属性ではなく`messageId`属性にメッセージIDを指定する。

```java
@PropertyName(messageId="PROP0002")
@Required
@Length(max=10)
public void setName(String name) { ... }
```

メッセージテーブル設定例:

| メッセージID | 言語 | メッセージ |
|---|---|---|
| MSG00001 | ja | {0}は必ず入力してください。 |
| MSG00001 | en | You must input {0}. |
| PROP0002 | ja | 氏名 |
| PROP0002 | en | name |

### プロパティ名に対応する表示名称を使用する方法（クラス名＋プロパティ名）

`"<Formクラス名>.<プロパティ名>"`をメッセージIDとして使用する。Formに`@PropertyName`の設定は不要。`ValidationManager`の`useFormPropertyNameAsMessageId`プロパティに`true`を設定する。

```xml
<component name="validationManager" class="nablarch.core.validation.ValidationManager">
    <property name="useFormPropertyNameAsMessageId" value="true"/>
</component>
```

メッセージテーブル設定例:

| メッセージID | 言語 | メッセージ |
|---|---|---|
| User.name | ja | 氏名 |
| User.name | en | name |

### 2つの方法の選択基準

**通常は方法2（クラス名＋プロパティ名）を選択する**。エンティティ自動生成ツールとの相性が良く、生産性と品質に大きく寄与する。

**方法1（messageId属性）を選択するケース**: 顧客指定によりメッセージIDの体系に制約があり、方法2が使用できない場合のみ。

- **方法1のメリット/デメリット**: メッセージIDの明示的管理が容易になる反面、プロパティとメッセージIDのマッピング管理が必要でエンティティ自動生成が困難
- **方法2のメリット/デメリット**: エンティティに`@PropertyName`アノテーションの設定が不要で自動生成ツールとの相性が良い反面、`"クラス名.プロパティ名"`という通常とは異なるID体系でのメッセージ登録が必要

<details>
<summary>keywords</summary>

ValidationManager, nablarch.core.validation.ValidationManager, @PropertyName, useFormPropertyNameAsMessageId, プロパティ表示名称国際化, messageId属性, クラス名プロパティ名メッセージID, 多言語対応バリデーション

</details>
