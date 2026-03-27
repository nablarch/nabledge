# Form の継承とバリデーション条件の継承

## Form の継承とバリデーション条件の継承

## Form の継承とバリデーション条件の継承

Formを継承してセッタメソッドの`@PropertyName`アノテーションをオーバライドすることで、画面に合わせてプロパティの表示名称を変更できる。この際、バリデーション条件は継承元Formに指定した条件が引き継がれる。

**バリデーション条件の上書きルール**: 継承クラスのオーバライドメソッドに1つ以上のバリデーション条件アノテーションを指定した場合、そのメソッドのバリデーション条件は継承元の条件から新たに指定した条件に置き換わる（必須チェックを外したい場合などに使用）。

**コンバータアノテーションの扱い**: コンバータアノテーション（例: `@Digits`）はバリデーション条件アノテーションとは別に取り扱われる。バリデーション条件アノテーションをオーバライドメソッドに指定した場合でも、親クラスのコンバータアノテーションはそのまま継承される。

```java
// 継承元Form
public class UserBase {
    @PropertyName("ユーザ名")
    @Required
    @Length(max=10)
    public void setName(String name) { this.name = name; }
}

// 表示名のみ変更（@Required, @Lengthは継承元から引き継がれる）
public class User extends UserBase {
    @PropertyName("氏名")
    public void setName(String name) { super.setName(name); }
}

// バリデーション条件も変更（@Requiredを外す）
public class User extends UserBase {
    @PropertyName("氏名")
    @Length(max=10)  // 1つ以上のバリデーションアノテーションを指定→継承元条件を置換
    public void setName(String name) { super.setName(name); }
}
```

コンバータアノテーション継承の例（`ChildEntity`に対するバリデーションでは`@Digits(integer=5, fraction=3)`と`@NumberRange(min=100.0, max=20000.0)`の両方が使用される）:

```java
// 親クラス
public class ParentEntity {
    @Digits(integer=5, fraction=3)  // コンバータアノテーション
    public void setBdValue(BigDecimal bdValue) { this.bdValue = bdValue; }
}

// 子クラス
public class ChildEntity extends ParentEntity {
    @Override
    @NumberRange(min=100.0, max=20000.0)  // バリデーション条件を追加
    public void setBdValue(BigDecimal bdValue) { super.setBdValue(bdValue); }
    // → @Digits（コンバータ）は親から継承、@NumberRange（バリデーション）が追加される
}
```

> **警告**: バリデーション条件の変更は継承元クラスの修正が継承クラスに反映されない状態となり、修正漏れバグの原因になりやすい。継承クラスでのバリデーション条件変更はこの問題を意識して慎重に実施すること。

<details>
<summary>keywords</summary>

UserBase, User, ParentEntity, ChildEntity, ValidationContext, ValidationUtil, @PropertyName, @Required, @Length, @ValidateFor, @Digits, @NumberRange, Formの継承, バリデーション条件の継承, 表示名称の変更, コンバータアノテーションの継承

</details>

## 国際化したプロパティの表示名称の取得方法

## 国際化したプロパティの表示名称の取得方法

`@PropertyName`アノテーションのvalue属性では国際化メッセージを取得できない。国際化が必要な場合は、:ref:`message_management` が提供するメッセージとして表示名称を言語ごとに登録し、以下のいずれかの方法でプロパティと対応付ける。

### 方法1: @PropertyName の messageId 属性を使用する

`@PropertyName`の`messageId`属性にメッセージIDを指定し、そのIDに対応するメッセージを言語ごとに:ref:`message_management`に登録する。

```java
@PropertyName(messageId="PROP0002")
@Required
@Length(max=10)
public void setName(String name) { this.name = name; }
```

メッセージテーブル例：

| メッセージID | 言語 | メッセージ |
|---|---|---|
| MSG00001 | ja | {0}は必ず入力してください。 |
| MSG00001 | en | You must input {0}. |
| PROP0002 | ja | 氏名 |
| PROP0002 | en | name |

### 方法2: クラス名+プロパティ名をメッセージIDとして使用する

`"<Formのクラス名>.<プロパティ名>"`（例: `User.name`）をメッセージIDとして使用する。Formに`@PropertyName`アノテーションは不要。

```java
@Required
@Length(min=6, max=10)
public void setName(String name) { this.name = name; }
```

メッセージテーブル例：

| メッセージID | 言語 | メッセージ |
|---|---|---|
| User.name | ja | 氏名 |
| User.name | en | name |

`ValidationManager`の`useFormPropertyNameAsMessageId`プロパティに`true`を設定する：

```xml
<component name="validationManager" class="nablarch.core.validation.ValidationManager">
    <property name="useFormPropertyNameAsMessageId" value="true"/>
</component>
```

### 2つの方法の選択基準

**通常は方法2を選択すること**。エンティティ自動生成のメリットが生産性と品質に大きく寄与するため。

方法1は、顧客指定によりメッセージIDの体系に制約があり方法2が使用できない場合のみ選択する。

| | 方法1（messageId属性） | 方法2（クラス名+プロパティ名） |
|---|---|---|
| メリット | メッセージIDの管理が容易 | エンティティ自動生成が不要なカスタマイズなし |
| デメリット | プロパティとメッセージIDの管理方法が必要、自動生成が難しい | 通常と異なるID体系のメッセージ登録が必要 |

<details>
<summary>keywords</summary>

ValidationManager, @PropertyName, useFormPropertyNameAsMessageId, messageId, 国際化, プロパティ表示名称, メッセージID, 言語ごとのメッセージ

</details>
