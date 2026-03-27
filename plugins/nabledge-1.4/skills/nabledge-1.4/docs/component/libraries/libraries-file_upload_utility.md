# ファイルアップロード業務処理用ユーティリティ

## 概要

ファイルアップロードを伴う業務処理向けのユーティリティ。アップロードファイルの内容をDB（中間テーブル等）に一時格納してレスポンスを返し、各レコードへの業務処理を後続バッチで行うパターンの共通処理を提供する。

提供する共通処理:
- ファイルを一時ディレクトリから移動する
- ファイルをバイナリとして読み込む
- ファイルをデータベースに登録する

<details>
<summary>keywords</summary>

UploadHelper, ファイルアップロード, 中間テーブル, バッチ処理, DB一時格納

</details>

## 要求

## 実装済み

- アップロードファイルの形式が正しくない場合にアップロードを禁止できる: 固定長ファイル・CSVファイルの形式が不正な場合に例外をスローする。その例外をハンドリングすることでエラー画面への遷移が可能。
- アップロードファイルを指定のディレクトリに移動する機能

## 未実装機能

- トランザクション制御（1件づつコミット）: ユーティリティがActionとは別のトランザクションを開始し、1件づつコミットする機能は未実装。

<details>
<summary>keywords</summary>

ファイル形式チェック, ApplicationException, ディレクトリ移動, トランザクション制御, 未実装機能

</details>

## 特徴

アプリケーションプログラマは必要な情報をユーティリティに設定して実行するだけで、ファイルデータをDBに登録できる。

<details>
<summary>keywords</summary>

UploadHelper, ファイルデータDB登録, 設定と実行

</details>

## 構造（クラス定義）

**クラス**: `nablarch.fw.web.upload` パッケージ

| クラス名 | 概要 |
|---|---|
| `UploadHelper` | ユーティリティクラス本体。アプリケーションプログラマが使用する |
| `BulkValidator` | ファイルの各レコードに対して一括精査処理を行う |
| `BulkValidationDriver` | 精査処理を呼び出す |
| `BulkValidationResult` | 全精査結果を保持する。精査済みフォームの一括登録を受け付ける |
| `ValidatingStrategy` | 1レコード毎の精査処理を行う。アプリケーション開発者が実装する |
| `BasicValidatingStrategy` | 典型的な精査ロジックを提供するValidationStrategy実装クラス |
| `InsertionStrategy` | フォーム1件のINSERT処理を行う。アプリケーション開発者が実装する |
| `BasicInsertionStrategy` | 典型的なINSERT処理を提供するInsertionValidationStrategy実装クラス |

![ファイルをデータベースに登録するシーケンス図](../../../knowledge/component/libraries/assets/libraries-file_upload_utility/FileUploadUtility_sequence.png)

<details>
<summary>keywords</summary>

UploadHelper, BulkValidator, BulkValidationDriver, BulkValidationResult, ValidatingStrategy, BasicValidatingStrategy, InsertionStrategy, BasicInsertionStrategy, nablarch.fw.web.upload

</details>

## ファイルを一時ディレクトリから移動する

`UploadHelper#moveFileTo(String basePathName, String newFileName)` で一時ディレクトリからファイルを移動する。
- 第1引数 `basePathName`: 移動先ディレクトリ（PathSettingsで管理されている論理ディレクトリ名）
- 第2引数 `newFileName`: 移動後のファイル名

```java
PartInfo part = req.getPart("fileToMove").get(0);
UploadHelper helper = new UploadHelper(part);
helper.moveFileTo("basePathName", "newFileName");
```

<details>
<summary>keywords</summary>

UploadHelper, moveFileTo, PathSettings, ファイル移動, 論理ディレクトリ名, PartInfo

</details>

## ファイルをバイナリとして読み込む

`UploadHelper#toByteArray()` でファイルをバイト配列に変換する。

```java
PartInfo part = req.getPart("image").get(0);
byte[] bytes = new UploadHelper(part).toByteArray();
```

<details>
<summary>keywords</summary>

UploadHelper, toByteArray, バイト配列, バイナリ読み込み, PartInfo

</details>

## ファイルをデータベースに登録する

`UploadHelper` を起点としてメソッドをチェーンし、ファイルの精査および登録を行う。

| 処理 | 説明 | 業務処理側で必要な実装 |
|---|---|---|
| フォーマット定義のロード | アップロードファイルのデータフォーマット定義ファイルを読み込む | `applyFormat` でパス指定 |
| 形式チェック | フォーマット定義の項目数・データ形式と一致するか検証。チェック通過レコードはMap型に変換 | `setUpMessageIdOnError` で形式エラー時メッセージID指定 |
| 精査処理 | 形式チェック通過レコードへの業務検証（ドメイン単項目精査、DB精査、ビジネスロジック精査が可能） | `validateWith` で精査フォームクラス・メソッド指定 |
| レコードの登録 | 全レコードが検査通過した場合にDBへ一括登録 | `importWith` または `importAll` |

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

## フォーマット定義ファイルパスの指定

以下のいずれかを使用:
- `UploadHelper#applyFormat(String layoutFileName)`
- `UploadHelper#applyFormat(String basePathName, String layoutFileName)`

## 精査エラー発生時のメッセージID指定

`BulkValidator#setUpMessageIdOnError(String messageIdOnFormatError, String messageIdOnValidationError, String messageIdOnEmptyFile)`

各引数に対応するエラー:
1. 第1引数（形式エラー）: `{0}行目の形式に誤りがあります。` → 出力例: `12行目の形式に誤りがあります。`
2. 第2引数（精査エラー）: `{0}行目にエラーがあります。[ {1} ]` → 出力例: `1行目にエラーがあります。[ 電話番号は半角数字で入力してください。]`
3. 第3引数（ファイルが空の場合）: `空のファイルがアップロードされました。 [ {0} ]`（`{0}` はファイル名のみ、パスなし）

> **注意**: 形式エラー・精査エラー発生時は即座に例外は送出されず、Messageが蓄積される。例外の送出は `importWith`/`importAll` のタイミングで判断され、蓄積された全メッセージが `ApplicationException` に設定される。

> **注意**: 空ファイルの場合は `ApplicationException` が即座に送出される（他のエラーとは異なる）。空ファイルメッセージIDは必須（0件登録は業務上無意味であり、ユーザのオペレーションミスと判断するため）。

## 精査処理を実装したクラス・メソッドの指定

`BulkValidator.MsgIdHolder#validateWith(Class<F> formClass, String validateFor)` で精査フォームクラスと精査メソッド名を指定する。精査エラーはMessageに蓄積され、`importWith`/`importAll` まで例外は送出されない。

## データベース一括登録

`BulkValidationResult#importWith(DbAccessSupport dbAccessSupport, String insertSqlId)`
- 第1引数: `DbAccessSupport` インスタンス（ActionクラスはDbAccessSupportを継承しているので `this` を指定）
- 第2引数: INSERT文のSQLID
- 形式エラー・精査エラーが1件でも存在する場合、蓄積された全メッセージを含む `ApplicationException` を送出

## データベース一括登録（独自実装）

単純なINSERT以外の処理が必要な場合は `BulkValidationResult#importAll(InsertionStrategy<FORM> strategy)` を使用。`InsertionStrategy` 実装クラスを引数に指定する。

`InsertionStrategy` の実装メソッド:
- `prepareStatement(FORM form)`: `ParameterizedSqlPStatement` を返す
- `addBatch(ParameterizedSqlPStatement statement, FORM form)`: バッチ処理（IDの採番なども可能）

```java
helper.applyFormat("N11AA002")
      .setUpMessageIdOnError("MSG00037", "MSG00038")
      .validateWith(UserInfoTempEntity.class, "validateRegister")
      .importAll(new UserInfoInsertionStrategy());
```

<details>
<summary>keywords</summary>

UploadHelper, BulkValidator, BulkValidator.MsgIdHolder, BulkValidationResult, applyFormat, setUpMessageIdOnError, validateWith, importWith, importAll, InsertionStrategy, ParameterizedSqlPStatement, ApplicationException, DbAccessSupport, フォーマット定義, 精査処理, 一括登録, 形式エラー, 精査エラー, 空ファイル, @OnError, PartInfo

</details>
