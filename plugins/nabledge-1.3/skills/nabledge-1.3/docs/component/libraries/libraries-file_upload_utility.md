# ファイルアップロード業務処理用ユーティリティ

## 概要

アップロードファイルの内容をDB（中間テーブルなど）に格納してレスポンスを返し、各レコードへの業務処理は後続バッチで実行するパターンの実装を支援するユーティリティ。

提供機能:
1. ファイルを一時ディレクトリから移動する
2. ファイルをバイナリとして読み込む
3. ファイルをデータベースに登録する

<details>
<summary>keywords</summary>

UploadHelper, ファイルアップロード, DB登録, 中間テーブル, 後続バッチ処理

</details>

## 要求

**実装済み機能**

- アップロードファイルの形式が不正な場合、例外がスローされるためハンドリングによりエラー画面へ遷移可能。
- アップロードファイルを指定ディレクトリへ移動する機能。

**未実装機能**

- トランザクション制御（１件づつコミット）: Actionとは別トランザクションを開始し1件ごとにコミットする機能は未実装。

<details>
<summary>keywords</summary>

ファイル形式チェック, ファイル移動, トランザクション制御, 未実装機能

</details>

## 特徴

`UploadHelper`クラスに必要な情報を設定して実行するだけで、ファイルデータをDBに登録できる（アプリケーションプログラマ向けユーティリティ）。

<details>
<summary>keywords</summary>

UploadHelper, ファイルアップロードユーティリティ, DB登録

</details>

## 構造

**パッケージ**: `nablarch.fw.web.upload`

| クラス名 | 概要 |
|---|---|
| `UploadHelper` | ユーティリティクラス本体。アプリケーションプログラマが使用する。 |
| `BulkValidator` | ファイルの各レコードに対して一括精査処理を行う。 |
| `BulkValidationDriver` | 精査処理を呼び出す。 |
| `BulkValidationResult` | 全精査結果を保持する。精査済みフォームの一括登録を受け付ける。 |
| `ValidatingStrategy` | １レコード毎の精査処理を行う。アプリケーション開発者が実装する。 |
| `BasicValidatingStrategy` | 典型的な精査ロジックを提供する`ValidatingStrategy`実装クラス。 |
| `InsertionStrategy` | フォーム１件のINSERT処理を行う。アプリケーション開発者が実装する。 |
| `BasicInsertionStrategy` | 典型的なINSERT処理を提供する`InsertionValidationStrategy`実装クラス。 |

<details>
<summary>keywords</summary>

UploadHelper, BulkValidator, BulkValidationDriver, BulkValidationResult, ValidatingStrategy, BasicValidatingStrategy, InsertionStrategy, BasicInsertionStrategy, nablarch.fw.web.upload, クラス図

</details>

## ファイルを一時ディレクトリから移動する

**メソッド**: `UploadHelper#moveFileTo(String basePathName, String newFileName)`

- 第1引数 `basePathName`: PathSettingsで管理されている論理ディレクトリ名で移動先を指定する。
- 第2引数 `newFileName`: 移動後のファイル名を指定する。

```java
PartInfo part = req.getPart("fileToMove").get(0);
UploadHelper helper = new UploadHelper(part);
helper.moveFileTo("basePathName", "newFileName");
```

<details>
<summary>keywords</summary>

UploadHelper, moveFileTo, ファイル移動, 一時ディレクトリ, PathSettings

</details>

## ファイルをバイナリとして読み込む

**メソッド**: `UploadHelper#toByteArray()` → `byte[]`

```java
PartInfo part = req.getPart("image").get(0);
byte[] bytes = new UploadHelper(part).toByteArray();
```

<details>
<summary>keywords</summary>

UploadHelper, toByteArray, バイナリ読み込み, バイト配列

</details>

## ファイルをデータベースに登録する

`UploadHelper`を起点として各クラスのメソッドをチェーンすることで、ファイルの精査および登録を行う。

| 処理 | 説明 | 業務処理側の実装 |
|---|---|---|
| フォーマット定義のロード | アップロードファイルのデータフォーマット定義ファイルを読み込む | `applyFormat`メソッドでパスを指定 |
| 形式チェック | 各レコードがフォーマット定義に合致するか自動検証。通過したレコードはMap型に変換 | `setUpMessageIdOnError`で形式エラー時のメッセージIDを指定 |
| 精査処理 | 形式チェック通過後の各レコードに業務バリデーションを実行（ドメイン精査・DB精査・複雑な精査が実装可能） | `validateWith`で精査クラスとメソッドを指定 |
| レコード登録 | 全レコードが検査を通過した場合にDBへ一括登録 | `importWith`でSQLIDを指定 |

```java
@OnError(type = ApplicationException.class, path = "/path/to/forward")
public void doSaveFile(HttpRequest req, ExecutionContext ctx) {
    PartInfo part = req.getPart("fileToSave").get(0);
    UploadHelper helper = new UploadHelper(part);
    helper.applyFormat("FORMAT0001")
          .setUpMessageIdOnError("MSG_FORMAT_ERR", "MSG_VALIDATION_ERROR", "MSG_EMPTY_FILE")
          .validateWith(HogeForm.class, "validateUpload")
          .importWith(this, "SQL0001");
}
```

**フォーマット定義ファイルパスの指定**

- `UploadHelper#applyFormat(String layoutFileName)`
- `UploadHelper#applyFormat(String basePathName, String layoutFileName)`

**精査エラー発生時のメッセージID指定**

`BulkValidator#setUpMessageIdOnError(String messageIdOnFormatError, String messageIdOnValidationError, String messageIdOnEmptyFile)`

- 第1引数: 形式エラー時のメッセージID。`{0}`にレコード番号が設定される。例: `{0}行目の形式に誤りがあります。`
- 第2引数: 精査エラー時のメッセージID。`{0}`にレコード番号、`{1}`にエラー内容が設定される。例: `{0}行目にエラーがあります。[ {1} ]`
- 第3引数: 空ファイル時のメッセージID（必須）。`{0}`にファイル名が設定され、即座に`ApplicationException`が送出される。例: `空のファイルがアップロードされました。 [ {0} ]`

> **注意**: 形式エラー・精査エラーは即座に例外が送出されず、全レコードのエラーを蓄積し`importWith`のタイミングでまとめて`ApplicationException`として送出される。

> **注意**: 空ファイルアップロードはユーザのオペレーションミスとみなすため第3引数は必須。ファイル名のみが表示され、ファイルパスは表示されない。

**精査処理を実装したクラス、メソッドの指定**

`BulkValidator.MsgIdHolder#validateWith(Class<F> formClass, String validateFor)`

精査エラーのメッセージは蓄積され、`importWith`まで例外は送出されない。

**データベース一括登録**

`BulkValidationResult#importWith(DbAccessSupport dbAccessSupport, String insertSqlId)`

- 第1引数: `DbAccessSupport`インスタンス（ActionクラスはDbAccessSupportを継承しているため通常は`this`を指定）
- 第2引数: INSERT文のSQLID

形式エラーまたは精査エラーが1件でもある場合、蓄積された全メッセージを含む`ApplicationException`が送出される。

**データベース一括登録（独自実装）**

`BulkValidationResult#importAll(InsertionStrategy<FORM> strategy)`

`importWith`の代わりに使用する。INSERT時に独自処理（IDの採番など）が必要な場合は`InsertionStrategy`を実装して指定する。

```java
helper.applyFormat("N11AA002")
      .setUpMessageIdOnError("MSG00037", "MSG00038")
      .validateWith(UserInfoTempEntity.class, "validateRegister")
      .importAll(new UserInfoInsertionStrategy());

private class UserInfoInsertionStrategy implements InsertionStrategy<UserInfoTempEntity> {
    public ParameterizedSqlPStatement prepareStatement(UserInfoTempEntity userInfoTempEntity) {
        return getParameterizedSqlStatement("INSERT_USER_INFO_TEMP", userInfoTempEntity);
    }
    public void addBatch(ParameterizedSqlPStatement statement, UserInfoTempEntity userInfoTempEntity) {
        String id = IdGeneratorUtil.generateUserInfoId();
        userInfoTempEntity.setUserInfoId(id);
        statement.addBatchObject(userInfoTempEntity);
    }
}
```

<details>
<summary>keywords</summary>

UploadHelper, BulkValidator, BulkValidator.MsgIdHolder, BulkValidationResult, InsertionStrategy, ApplicationException, applyFormat, setUpMessageIdOnError, validateWith, importWith, importAll, DbAccessSupport, ParameterizedSqlPStatement, フォーマット検証, 精査処理, データベース一括登録, エラーメッセージ設定

</details>
