# マルチパートリクエストハンドラ

## 概要

**クラス名**: `nablarch.fw.web.upload.MultipartHandler`

HTTPリクエストボディがマルチパート形式の場合、内容を解析して一時ファイルに保存する。保存ファイルはアップロード用ユーティリティで業務アクションハンドラから参照可能。

**関連ハンドラ**

| ハンドラ | 配置ルール |
|---|---|
| [HttpErrorHandler](handlers-HttpErrorHandler.md) | アップロードサイズ超過などの例外が送出される可能性があるため、本ハンドラより上位に配置する。 |
| [NablarchTagHandler](handlers-NablarchTagHandler.md) | NablarchTagHandlerはPOSTパラメータ解析時にリクエストボディを読み込むため、本ハンドラは [NablarchTagHandler](handlers-NablarchTagHandler.md) よりも上位に配置する。 |

> **注意**: HTTPリクエストボディを読み込むハンドラ（[HttpAccessLogHandler](handlers-HttpAccessLogHandler.md) を拡張して特定リクエストパラメータを出力するケース、[ThreadContextHandler](handlers-ThreadContextHandler.md) にリクエストパラメータ依存のカスタム属性を追加するケースなど）は、必ず本ハンドラの後続に配置すること。

<details>
<summary>keywords</summary>

MultipartHandler, nablarch.fw.web.upload.MultipartHandler, マルチパートリクエスト処理, ファイルアップロード, 一時ファイル保存, HttpErrorHandler, NablarchTagHandler, uploadFileTmpDir, HttpAccessLogHandler, ThreadContextHandler

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **非マルチパートリクエストのスキップ**: CONTENT-TYPEヘッダーが `"multipart/form-data"` に一致しない場合、後続ハンドラの結果をリターンして終了。
2. **マルチパートリクエストの解析**: リクエストボディを読み込みマルチパート解析。アップロードファイルを論理パス名 `"uploadFileTmpDir"` に一時保存（未設定時はJavaシステムプロパティ `"java.io.tmpdir"` のパス）。解析結果はHTTPリクエストオブジェクトに格納。ファイル情報は `HttpRequest.getPart()`、その他パラメータは `HttpRequest.getParam()` 等で取得可能。
3. **ログ出力**: アップロードファイル情報をINFOレベルでログ出力。
4. **後続ハンドラへの処理委譲**: 後続ハンドラに処理を委譲し結果を取得。

**[復路処理]**

5. **終端処理**: アップロードされた一時ファイルを全て削除。
6. **正常終了**: 4の結果をリターン。

**[エラー処理]**

- **2a. マルチパート形式エラー**: 接続切断等でリクエストボディがマルチパートフォーマット違反の場合、`Result.BadRequest` を送出して終了（ステータスコード400）。
- **2b. アップロード上限超過エラー**: 読み込んだデータサイズが設定上限値を超過した場合、`Result.BadRequest` を送出して終了（ステータスコード413）。
- **4a. 後続ハンドラ例外**: 後続ハンドラで例外発生時、終端処理（5）を実行して例外を再送出。

<details>
<summary>keywords</summary>

Result.BadRequest, HttpRequest, ハンドラ処理フロー, 一時ファイル削除, マルチパート解析, uploadFileTmpDir, java.io.tmpdir, ステータスコード400, ステータスコード413

</details>

## 設定項目・拡張ポイント

設定値は `UploadSettings` に集約されている。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| contentLengthLimit | int | | 無制限 | 1リクエストでアップロードできるデータの上限値（バイト）。ファイルサイズの上限ではない。 |
| autoCleaning | boolean | | true | 一時ファイルの自動削除。デバッグ・障害解析用に無効化可能。 |

> **注意**: `autoCleaning` がfalseでも、一時ファイル保存中に例外が発生した場合はファイルを削除する（不正な状態のファイル作成を防ぐため）。後続ハンドラへの委譲が成功した場合は `autoCleaning` がtrueの場合のみ削除する。

> **重要**: アップロードサイズの上限値を設定することを強く推奨。上限値はユーザ要望等による変更に備え、設定パラメータとして外部化すること。

**基本設定例**:
```xml
<component class="nablarch.fw.web.upload.MultipartHandler" name="multipartHandler">
  <property name="uploadSettings">
    <component class="nablarch.fw.web.upload.UploadSettings">
      <!-- Content-Lengthの上限値 -->
      <property name="contentLengthLimit" value="${uploadSizeLimit}" />
    </component>
  </property>
</component>
```

**一時保存先設定**（論理パス名 `"uploadFileTmpDir"` を使用、値は外部化）:
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

contentLengthLimit, autoCleaning, UploadSettings, nablarch.fw.web.upload.UploadSettings, アップロードサイズ上限, 一時ファイル保存先設定, uploadFileTmpDir, FilePathSetting, nablarch.core.util.FilePathSetting

</details>
