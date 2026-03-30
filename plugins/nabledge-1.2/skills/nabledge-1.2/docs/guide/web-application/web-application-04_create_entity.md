# Entityクラス（精査処理）の実装

## Entityクラス（精査処理）の実装

## Entityクラス（精査処理）の実装

> **注意**: Entityクラスは通常 Nablarch Toolbox のEntity自動生成ツールでひな形を作成する。0から実装する場合はプロジェクト規定の作成方法に従うこと。

### 実装の流れ

1. クラス単体テストデータの作成（テストデータシートに更新機能用シートを追加）
2. クラス単体テストコードの作成（精査メソッドのテストメソッドを追加）
3. クラス単体テスト実施（精査メソッド未実装のため失敗することを確認）
4. Entityクラスへ精査処理を実装
5. クラス単体テスト実施（成功確認）

> **警告**: Entityクラスを初めて使用する機能の場合、コンストラクタ・ゲッター/セッターのテストが必要なため、テストデータの準備が必要。Entityクラスのコンストラクタのテスト、ゲッター/セッターのテストについてはEntityクラスのクラス単体テストに関するドキュメントを参照。

> **注意**: 新規Entityを作成する場合はEntityテストデータ自動作成ツールで初回テストデータ作成を効率化できるが、全テストデータを自動生成できるわけではないため、ツールが作成したテストデータをベースに必要なデータを追加して使用すること。

### テストコード例

**クラス**: `UsersEntity`, `UsersEntityTest`
**アノテーション**: `@ValidateFor`

```java
@Test
public void testValidateForSimpleUpdate() {
    Class<?> entityClass = UsersEntity.class;
    String sheetName = "testValidateForSimpleUpdate";
    String validateFor = "simpleUpdate";
    testValidateAndConvert(entityClass, sheetName, validateFor);
}
```

### Entityクラス実装パターン

①単項目精査を実施するプロパティ配列を定義し、②`@ValidateFor`アノテーション付きstaticメソッドで`ValidationUtil.validate()`を呼び出す。

```java
// ①単項目精査を実施するプロパティを指定
private static final String[] SIMPLE_UPDATE_PROPS =
    new String[] {"userId", "kanjiName", "kanaName"};

@ValidateFor("simpleUpdate")
public static void validateForSimpleUpdate(ValidationContext<UsersEntity> context) {
    // ②単項目精査対象項目変数を設定する
    ValidationUtil.validate(context, SIMPLE_UPDATE_PROPS);
}
```

<details>
<summary>keywords</summary>

UsersEntity, UsersEntityTest, ValidationContext, ValidationUtil, @ValidateFor, validateForSimpleUpdate, バリデーション実装, 単項目精査, Entityクラス精査, testValidateAndConvert

</details>
