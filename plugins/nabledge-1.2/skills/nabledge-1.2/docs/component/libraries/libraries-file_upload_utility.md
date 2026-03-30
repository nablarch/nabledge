# ファイルアップロード業務処理用ユーティリティ

## 概要

ファイルアップロードを伴う業務処理（ファイル内容をDB中間テーブルに格納してレスポンスを返し、各レコードへの業務処理は後続バッチで行うパターン）を実装するためのユーティリティ。以下の共通処理を提供する。

- ファイルを一時ディレクトリから移動する
- ファイルをバイナリとして読み込む
- ファイルをデータベースに登録する

<details>
<summary>keywords</summary>

UploadHelper, ファイルアップロード, 業務処理ユーティリティ, 中間テーブル, 後続バッチ処理

</details>

## 要求

## 実装済み機能

- アップロードファイルの形式が正しくない場合（固定長・CSVのフォーマット不正）、ユーティリティが例外をスローするため、ハンドリングによりエラー画面へ遷移可能
- アップロードファイルを指定ディレクトリへ移動する機能

## 未実装機能

- **トランザクション制御（1件ずつコミット）**: ユーティリティがActionとは別のトランザクションを開始して1件ずつコミットする機能は未実装

<details>
<summary>keywords</summary>

ファイルフォーマット検証, 固定長ファイル, CSVファイル, アップロード禁止, 未実装機能, トランザクション制御

</details>

## 特徴

必要な情報をユーティリティに設定して実行するだけでファイルデータをDBに登録できる。`UploadHelper` クラスのメソッドチェーンで精査・登録処理を簡潔に記述できる。

<details>
<summary>keywords</summary>

UploadHelper, メソッドチェーン, ファイルデータDB登録

</details>

## 構造

**パッケージ**: `nablarch.fw.web.upload`

| クラス名 | 概要 |
|---|---|
| `UploadHelper` | ユーティリティクラス本体。アプリケーションプログラマはこのクラスを使用する |
| `BulkValidator` | ファイルの各レコードに対して一括精査処理を行う |
| `BulkValidationDriver` | 精査処理を呼び出す |
| `BulkValidationResult` | 全精査結果を保持し、精査済みフォームの一括登録を受け付ける |
| `ValidatingStrategy` | 1レコードごとの精査処理（アプリケーション開発者が実装） |
| `BasicValidatingStrategy` | 典型的な精査ロジックを提供する `ValidatingStrategy` 実装クラス |
| `InsertionStrategy` | フォーム1件のINSERT処理（アプリケーション開発者が実装） |
| `BasicInsertionStrategy` | 典型的なINSERT処理を提供する `InsertionStrategy` 実装クラス |

<details>
<summary>keywords</summary>

UploadHelper, BulkValidator, BulkValidationDriver, BulkValidationResult, ValidatingStrategy, BasicValidatingStrategy, InsertionStrategy, BasicInsertionStrategy, nablarch.fw.web.upload

</details>

## ファイルを一時ディレクトリから移動する

`UploadHelper#moveFileTo(String basePathName, String newFileName)` でアップロードファイルを一時ディレクトリから移動する。

- 第1引数 `basePathName`: PathSettingsで管理されている論理ディレクトリ名（移動先）
- 第2引数 `newFileName`: 移動後のファイル名

```java
PartInfo part = req.getPart("fileToMove").get(0);
UploadHelper helper = new UploadHelper(part);
helper.moveFileTo("basePathName", "newFileName");
```

<details>
<summary>keywords</summary>

UploadHelper, moveFileTo, PathSettings, 論理ディレクトリ名, ファイル移動, PartInfo

</details>

## ファイルをバイナリとして読み込む

`UploadHelper#toByteArray()` でアップロードファイルをバイト配列として取得できる。

```java
PartInfo part = req.getPart("image").get(0);
byte[] bytes = new UploadHelper(part).toByteArray();
```

<details>
<summary>keywords</summary>

UploadHelper, toByteArray, バイト配列, バイナリ読み込み, PartInfo

</details>

## ファイルをデータベースに登録する

`UploadHelper` を起点としたメソッドチェーンでフォーマット検証・精査・DB一括登録を行う。

## 処理フロー

1. **フォーマット定義のロード**: `UploadHelper#applyFormat(String layoutFileName)` または `UploadHelper#applyFormat(String basePathName, String layoutFileName)` でフォーマットを指定
2. **形式チェック**: フォーマット定義に基づき各レコードを自動検証。通過したレコードはMap型に変換される
3. **精査処理**: `BulkValidator.MsgIdHolder#validateWith(Class<F> formClass, String validateFor)` で精査フォームクラスと精査メソッドを指定。通常のActionと同様にドメイン精査・DB精査・複雑精査が実装可能
4. **レコード登録**: 全レコードが精査通過後、`BulkValidationResult#importWith(DbAccessSupport dbAccessSupport, String insertSqlId)` でDB一括登録。第1引数は `DbAccessSupport` クラスのインスタンスを指定する。通常ActionクラスはDbAccessSupportクラスを継承しているので `this` を使用すればよい。第2引数はINSERT文のSQLID

## エラーメッセージ設定

`BulkValidator#setUpMessageIdOnError(String messageIdOnFormatError, String messageIdOnValidationError, String messageIdOnEmptyFile)`

- 第1引数（形式エラー）: プレースホルダ `{0}` にレコード番号が入る（例: `{0}行目の形式に誤りがあります。`）
- 第2引数（精査エラー）: `{0}` にレコード番号、`{1}` に精査エラー内容が入る（例: `{0}行目にエラーがあります。[ {1} ]`）
- 第3引数（空ファイル）: `{0}` にファイル名が入る（例: `空のファイルがアップロードされました。 [ {0} ]`）。**ファイル名のみが表示され、ファイルパスは表示されない。** 空ファイルは即座に `ApplicationException` を送出する

> **重要**: 空ファイルの場合のメッセージIDは**必須**。空ファイルのアップロードはユーザのオペレーションミスとみなすため。

> **注意**: 形式エラー・精査エラー発生時は即座に例外を送出しない。全レコードのエラーをまとめてユーザに通知するためMessageとして蓄積され、`importWith` 呼び出し時に1件でもエラーがあれば `ApplicationException` を送出する（蓄積された全メッセージが設定される）。

## 基本使用例

```java
@OnError(type = ApplicationException.class, path = "/path/to/forward")
public void doSaveFile(HttpRequest req, ExecutionContext ctx) {
    PartInfo part = req.getPart("fileToSave").get(0);
    UploadHelper helper = new UploadHelper(part);
    helper.applyFormat("FORMAT0001")
          .setUpMessageIdOnError("MSG_FORMAT_ERR",
                                 "MSG_VALIDATION_ERROR",
                                 "MSG_EMPTY_FILE")
          .validateWith(HogeForm.class, "validateUpload")
          .importWith(this, "SQL0001");
}
```

## 独自INSERT処理

単純なINSERT以外の処理（採番等）が必要な場合は `BulkValidationResult#importAll(InsertionStrategy<FORM> strategy)` を使用し、`InsertionStrategy` 実装クラスを渡す。

```java
helper.applyFormat("N11AA002")
      .setUpMessageIdOnError("MSG00037", "MSG00038")
      .validateWith(UserInfoTempEntity.class, "validateRegister")
      .importAll(new UserInfoInsertionStrategy());

private class UserInfoInsertionStrategy implements InsertionStrategy<UserInfoTempEntity> {
    public ParameterizedSqlPStatement prepareStatement(UserInfoTempEntity entity) {
        return getParameterizedSqlStatement("INSERT_USER_INFO_TEMP", entity);
    }
    public void addBatch(ParameterizedSqlPStatement statement, UserInfoTempEntity entity) {
        String id = IdGeneratorUtil.generateUserInfoId();
        entity.setUserInfoId(id);
        statement.addBatchObject(entity);
    }
}
```

<details>
<summary>keywords</summary>

UploadHelper, BulkValidator, BulkValidationResult, DbAccessSupport, applyFormat, setUpMessageIdOnError, validateWith, importWith, importAll, InsertionStrategy, ApplicationException, 形式エラー, 精査エラー, DB一括登録, ParameterizedSqlPStatement

</details>
