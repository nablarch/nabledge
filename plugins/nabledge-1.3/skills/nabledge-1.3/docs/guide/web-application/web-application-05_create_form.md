# Formクラスの実装

## Formクラスのプロパティの実装

**クラス名**: `W11AC02Form`
**ソース格納フォルダ**: `main/java/nablarch/sample/ss11AC`

> **補足**: コンストラクタ、ゲッター/セッターのテストはActionクラスのリクエスト単体テストでカバーできるため、Formクラス単体ではテストを作成しない。

実装手順:
1. プロパティ `user`（型：`UsersEntity`）を実装
2. Mapを引数に取るコンストラクタを実装
3. ゲッター/セッターを実装

```java
public class W11AC02Form {
    private UsersEntity user;

    public W11AC02Form(Map<String, Object> data) {
        user = (UsersEntity) data.get("user");
    }

    public UsersEntity getUser() {
        return user;
    }

    public void setUser(UsersEntity user) {
        this.user = user;
    }
}
```

<details>
<summary>keywords</summary>

W11AC02Form, UsersEntity, Formクラス実装, プロパティ定義, コンストラクタ, ゲッター/セッター

</details>

## Formクラスの精査処理の単体テスト作成

精査処理の実装フローは [Entityの精査処理実装フロー](web-application-04_create_entity.md) と同じ。

### テストデータ作成

- ファイル: `test/java/nablarch/sample/ss11AC/W11AC02FormTest.xlsx`
- シート名: `testValidateForRegister`
- 確認内容: `user` プロパティの「漢字氏名」と「カナ氏名」の精査（詳細は :ref:`entityUnitTest` 参照）

### テストコード作成

- 格納フォルダ: `test/java/nablarch/sample/ss11AC`
- クラス名: `W11AC02FormTest`（`EntityTestSupport` 継承）
- テストメソッド: `testValidateForRegister`

```java
public class W11AC02FormTest extends EntityTestSupport {
    @Test
    public void testValidateForRegister() {
        testValidateAndConvert(W11AC02Form.class, "testValidateForRegister", "register");
    }
}
```

### 単体テスト実行

単体テストを実行し、テストが失敗することを確認する（精査メソッドを実装していないため）。

<details>
<summary>keywords</summary>

W11AC02Form, W11AC02FormTest, EntityTestSupport, UsersEntity, testValidateForRegister, テストデータ作成, 単体テスト, 精査処理

</details>

## Formクラスへの精査処理実装

**クラス**: `W11AC02Form`  
**メソッド**: `validateForRegister`  
**格納フォルダ**: `main/java/nablarch/sample/ss11AC`

実装手順:
1. 単項目精査対象プロパティ `user` のセッターに `@ValidationTarget` を付与
2. `ValidationUtil.validate(context, new String[] {"user"})` で単項目精査実行

| プロパティ | アノテーション |
|---|---|
| user | `nablarch.core.validation.ValidationTarget` |

```java
@ValidationTarget
public void setUser(UsersEntity user) {
    this.user = user;
}

@ValidateFor("register")
public static void validateForRegister(ValidationContext<W11AC02Form> context) {
    ValidationUtil.validate(context, new String[] {"user"});
}
```

### 単体テスト再実行

Form単体テストを実行し、`UsersEntity` の単項目精査呼び出しが行われていることを確認する。

<details>
<summary>keywords</summary>

W11AC02Form, ValidationUtil, ValidationContext, @ValidationTarget, @ValidateFor, validateForRegister, UsersEntity, 単項目精査, 精査処理実装, user

</details>
