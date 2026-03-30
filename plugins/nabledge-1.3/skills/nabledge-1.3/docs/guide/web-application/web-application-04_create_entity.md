# Entityクラス（精査処理）の実装

## Entityクラスに実装する精査処理の単体テストを作成

Entityの精査処理は、自動生成されたEntity（Abstractクラス）を拡張したクラスに実装する。そのため、まず精査処理を実装するためのEntityクラス（`UsersEntity extends AbstractUsersEntity`）を準備する。`AbstractUsersEntity`は自動生成された抽象基底クラスであり、精査ロジックは拡張クラス側に追加する。

精査処理の単体テストで検証する内容:
1. 精査対象プロパティに精査が行われること
2. 精査対象外プロパティに精査が行われないこと

> **注意**: 各プロパティが精査仕様に従って正しく精査されることは、Entity自動生成またはEntityの単項目精査テストで担保する。

**テストデータ**: `test/java/nablarch/sample/ss11/entity/UsersEntityTest.xlsx`（シート: `testValidateForRegister`）

**Entityクラス** (`main/java/nablarch/sample/ss11/entity/UsersEntity.java`):
- `UsersEntity extends AbstractUsersEntity`
- コンストラクタ: `UsersEntity(Map<String, Object> params)`

**テストクラス** (`test/java/nablarch/sample/ss11/entity/UsersEntityTest.java`):
- `UsersEntityTest extends EntityTestSupport`
- テストメソッド: `testValidateForRegister`

```java
@Test
public void testValidateForRegister() {
    testValidateAndConvert(UsersEntity.class, "testValidateForRegister", "register");
}
```

<details>
<summary>keywords</summary>

UsersEntity, AbstractUsersEntity, EntityTestSupport, testValidateAndConvert, エンティティ精査テスト, 単体テストデータ作成, UsersEntityTest

</details>

## Entityクラスの単体テストを実行（精査メソッド実装前）

精査メソッドを実装していない状態でテストを実行し、テストが失敗することを確認する（精査メソッドが未実装のため失敗する）。

<details>
<summary>keywords</summary>

単体テスト実行, テスト失敗確認, 精査メソッド未実装, JUnit

</details>

## Entityクラスに精査処理を実装

ファイル: `main/java/nablarch/sample/ss11/entity/UsersEntity.java`、メソッド: `validateForRegister`

`@ValidateFor("register")` アノテーションを付与したstaticメソッドを作成し、`ValidationUtil.validate(ValidationContext, String[])` を呼び出して単項目精査対象のプロパティ名を指定する。

```java
@ValidateFor("register")
public static void validateForRegister(ValidationContext<UsersEntity> context) {
    ValidationUtil.validate(context, new String[] {"kanjiName", "kanaName"});
}
```

<details>
<summary>keywords</summary>

UsersEntity, ValidationUtil, @ValidateFor, validateForRegister, ValidationContext, 単項目精査, 精査処理実装

</details>

## Entityクラスの単体テストを実行（精査処理実装後）

テストを実行し、精査対象プロパティのみに精査が行われることを確認する（テストが成功し、JUnitビューに緑のバーが表示される）。

<details>
<summary>keywords</summary>

単体テスト実行, テスト成功確認, 精査対象プロパティ検証

</details>
