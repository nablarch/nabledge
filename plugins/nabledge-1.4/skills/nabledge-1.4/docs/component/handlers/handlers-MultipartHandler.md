# マルチパートリクエストハンドラ

## 

**クラス名**: `nablarch.fw.web.upload.MultipartHandler`

<details>
<summary>keywords</summary>

MultipartHandler, nablarch.fw.web.upload.MultipartHandler, マルチパートリクエストハンドラ, ファイルアップロード

</details>

## 概要

HTTPリクエストボディがマルチパート形式（Content-Type: `multipart/form-data`）の場合に解析し、アップロードされたファイルを一時ファイルとして保存する。保存されたファイルはアップロード用ユーティリティで業務アクションハンドラから参照可能。

<details>
<summary>keywords</summary>

マルチパートリクエスト解析, ファイルアップロード, 一時ファイル保存, MultipartHandler, マルチパートハンドラ概要

</details>

## 

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [HttpErrorHandler](handlers-HttpErrorHandler.md) | アップロード上限超過などの例外を適切なエラー画面で処理するため、[HttpErrorHandler](handlers-HttpErrorHandler.md) の後続に配置する必要がある |
| [NablarchTagHandler](handlers-NablarchTagHandler.md) | [NablarchTagHandler](handlers-NablarchTagHandler.md) はHTTPリクエストオブジェクトのリクエストパラメータを使用するためリクエストボディを読み込む。そのため本ハンドラを [NablarchTagHandler](handlers-NablarchTagHandler.md) より上位に配置する必要がある |

> **注意**: HTTPリクエストのリクエストボディを読み込むハンドラ（[HttpAccessLogHandler](handlers-HttpAccessLogHandler.md) の拡張や [ThreadContextHandler](handlers-ThreadContextHandler.md) のカスタム属性追加など）は、必ず [MultipartHandler](handlers-MultipartHandler.md) の後続に配置する必要がある。

<details>
<summary>keywords</summary>

HttpErrorHandler, NablarchTagHandler, ハンドラ配置順序, リクエストボディ読み込み, MultipartHandler後続配置, HttpAccessLogHandler, ThreadContextHandler

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 非マルチパートリクエストのスキップ: Content-Typeが`multipart/form-data`に一致しない場合、後続ハンドラの結果をリターンして終了
2. マルチパートリクエストの解析: リクエストボディを読み込み解析。アップロードファイルを論理パス名 **"uploadFileTmpDir"** に一時ファイルとして保存（論理パス未設定時はJavaシステムプロパティ **"java.io.tmpdir"** の値を使用）。解析結果はHTTPリクエストオブジェクトに格納。アップロードファイルは`HttpRequest.getPart()`で、その他パラメータは`HttpRequest.getParam()`等で取得可能
3. ログ出力: アップロードファイル情報をINFOレベルでログ出力
4. 後続ハンドラへの処理委譲

**[復路処理]**

5. 終端処理: アップロードされた一時ファイルを全て削除
6. 正常終了: 4. の結果をリターン

<details>
<summary>keywords</summary>

ハンドラ処理フロー, uploadFileTmpDir, java.io.tmpdir, HttpRequest.getPart, HttpRequest.getParam, 往路処理, 復路処理

</details>

## 

**[例外処理]**

- **2a. マルチパート形式エラー**: 接続切断等でリクエストボディがマルチパートフォーマット違反の場合、実行時例外 `Result.BadRequest` を送出（ステータスコード400）
- **2b. アップロード上限超過エラー**: データサイズが設定上限値を超過した場合、実行時例外 `Result.BadRequest` を送出（ステータスコード413）
- **4a. 例外処理**: 後続ハンドラ処理中に例外発生した場合、終端処理（一時ファイル全削除）を実行後に例外を再送出

<details>
<summary>keywords</summary>

Result.BadRequest, アップロード上限超過, マルチパート形式エラー, 例外処理, ステータスコード400, ステータスコード413

</details>

## 設定項目・拡張ポイント

設定値は `UploadSettings` に集約される。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| contentLengthLimit | int | | 無制限 | 1リクエストでアップロードできるデータの上限値（バイト）。ファイルサイズの上限ではない |
| autoCleaning | boolean | | true | 一時ファイル自動削除の実施有無。デバッグや障害解析用に無効化可能 |

> **注意**: `autoCleaning` がfalseでも、一時ファイル保存中に例外が発生した場合はファイルを削除する（不正な状態のファイル作成防止）。一時ファイルが正常保存され後続ハンドラに処理委譲できた場合のみ、`autoCleaning=true` の場合にファイルを削除する。

アップロードサイズ上限値の設定を強く推奨。変更可能性があるため外部化すること。

```xml
<component class="nablarch.fw.web.upload.MultipartHandler" name="multipartHandler">
  <property name="uploadSettings">
    <component class="nablarch.fw.web.upload.UploadSettings">
      <property name="contentLengthLimit" value="${uploadSizeLimit}" />
    </component>
  </property>
</component>
```

アップロードファイルの一時保存先は論理パス名 **"uploadFileTmpDir"** で指定。環境依存値のため外部化すること。

```xml
<component name="filePathSetting" class="nablarch.core.util.FilePathSetting">
  <property name="basePathSettings">
    <map>
      <entry key="uploadFileTmpDir" value="${upload-file-tmp-dir}" />
    </map>
  </property>
</component>
```

<details>
<summary>keywords</summary>

UploadSettings, contentLengthLimit, autoCleaning, アップロードサイズ上限, uploadFileTmpDir, 一時ファイル保存先, FilePathSetting

</details>
