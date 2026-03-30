# Form の継承とバリデーション条件の継承

## Form の継承とバリデーション条件の継承

Formを継承してセッタメソッドに `@PropertyName` を設定することで、画面に合わせてプロパティの表示名称を変更できる。バリデーション条件は継承元のFormから引き継がれる。

継承クラスでセッタをオーバーライドし `@PropertyName` のみ設定した場合（バリデーションアノテーションなし）、親クラスのバリデーションアノテーションがそのまま使用される。バリデーション条件を変更したい場合は、継承クラスのセッタに1つ以上のバリデーションアノテーションを指定する。

**アノテーション**: `@PropertyName`, `@Required`, `@Length`, `@ValidateFor`

継承の例（表示名称のみ変更、バリデーションは親から引き継ぐ）:

```java
public class UserBase {
    @PropertyName("ユーザ名")
    @Required
    @Length(max=10)
    public void setName(String name) { ... }
}

public class User extends UserBase {
    @PropertyName("氏名")  // 表示名称のみ変更
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

バリデーション条件も変更する場合（例: 必須チェックを外す）:

```java
@PropertyName("氏名")
@Length(max=10)  // バリデーションアノテーションを1つ以上指定すると親の条件を上書き
public void setName(String name) {
    super.setName(name);
}
```

コンバータアノテーション（`@Digits` 等）はバリデーションアノテーションとは独立して継承される。継承クラスにバリデーションアノテーションを追加しても、親クラスのコンバータアノテーションはそのまま引き継がれる。

例: `ParentEntity` に `@Digits(integer=5, fraction=3)` が設定されており、`ChildEntity` で `@NumberRange(min=100.0, max=20000.0)` を追加した場合、両方のアノテーションが適用される。

> **警告**: バリデーション条件の変更は、継承元の修正が継承先に反映されない修正漏れバグの原因になりやすい。継承クラスでのバリデーション条件変更は慎重に実施すること。

<details>
<summary>keywords</summary>

@PropertyName, @Required, @Length, @Digits, @NumberRange, @ValidateFor, ValidationContext, ValidationUtil, UserBase, ParentEntity, ChildEntity, Formの継承, バリデーション条件の継承, 表示名称変更, コンバータアノテーション継承, セッタオーバーライド

</details>

## 国際化したプロパティの表示名称の取得方法

`@PropertyName` の `value` 属性による表示名称指定では国際化メッセージが取得できない。国際化アプリケーションでは :ref:`message_management` のメッセージとして表示名称を言語ごとに登録し、以下いずれかの方法でプロパティと対応付ける。

1. `@PropertyName` アノテーションの `messageId` 属性にメッセージIDを指定する
2. `<クラス名>.<プロパティ名>` をメッセージIDとして使用する

<details>
<summary>keywords</summary>

@PropertyName, messageId, 国際化, プロパティ表示名称, メッセージ管理

</details>

## @PropertyName の messageId 属性を使用する方法

`@PropertyName` の `messageId` 属性に指定したメッセージIDで :ref:`message_management` から表示名称を取得する。`value` 属性は使用しない。

**アノテーション**: `@PropertyName`

```java
@PropertyName(messageId="PROP0001")
@Required
@Length(min=8, max=8)
public void setId(String id) { ... }

@PropertyName(messageId="PROP0002")
@Required
@Length(max=10)
public void setName(String name) { ... }

@PropertyName(messageId="PROP0003")
@Length(max=100)
public void setRemarks(String remarks) { ... }
```

メッセージテーブル設定例（`@Required` のメッセージIDが `MSG00001` の場合）:

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

<details>
<summary>keywords</summary>

@PropertyName, messageId, 国際化メッセージ, 表示名称国際化, メッセージID, PROP0001

</details>

## プロパティ名に対応する表示名称を使用する方法

`<Formクラス名>.<プロパティ名>` をメッセージIDとして使用する。この方法ではFormに `@PropertyName` アノテーションを設定する必要はない。

**クラス**: `ValidationManager` (`nablarch.core.validation.ValidationManager`)

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| useFormPropertyNameAsMessageId | | | trueにするとクラス名+プロパティ名をメッセージIDとして使用 |

```xml
<component name="validationManager" class="nablarch.core.validation.ValidationManager">
    <property name="useFormPropertyNameAsMessageId" value="true"/>
</component>
```

メッセージテーブル設定例（`<Formクラス名>.<プロパティ名>` 形式でIDを登録）:

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

<details>
<summary>keywords</summary>

ValidationManager, useFormPropertyNameAsMessageId, クラス名+プロパティ名, 国際化表示名称, nablarch.core.validation.ValidationManager

</details>

## 2つの方法の選択基準

| 方法 | メリット | デメリット |
|---|---|---|
| `@PropertyName` の `messageId` 属性指定 | メッセージIDの管理が容易 | IDとプロパティの対応管理が必要、エンティティ自動生成が困難 |
| `<クラス名>.<プロパティ名>` をIDとして使用 | `@PropertyName` 不要、自動生成エンティティのカスタマイズ不要 | 通常とは異なるID体系のメッセージ登録が必要 |

**通常は `<クラス名>.<プロパティ名>` 方式（2つ目の方法）を選択する。** エンティティ自動生成が生産性と品質に大きく寄与するため。1つ目の方法は顧客指定によりメッセージIDの体系に制約があり、2つ目の方法が使用できない場合のみ選択すること。

<details>
<summary>keywords</summary>

@PropertyName, messageId, useFormPropertyNameAsMessageId, 方法選択基準, エンティティ自動生成, メッセージID体系

</details>
