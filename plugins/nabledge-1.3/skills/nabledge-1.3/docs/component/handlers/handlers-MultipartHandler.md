# マルチパートリクエストハンドラ

## 概要

**クラス名**: `nablarch.fw.web.upload.MultipartHandler`

HTTPリクエストボディがマルチパート形式の場合、内容を解析して一時ファイルに保存する。保存されたファイルはアップロード用ユーティリティで業務アクションハンドラから参照可能。

**関連するハンドラ**:

- [HttpErrorHandler](handlers-HttpErrorHandler.md): アップロードファイルが許容上限サイズを越えた場合などに例外が送出されるため、[HttpErrorHandler](handlers-HttpErrorHandler.md) の後続に配置して適切なエラー画面を表示できるようにする
- [NablarchTagHandler](handlers-NablarchTagHandler.md): HTTPリクエストオブジェクトのリクエストパラメータを使用するため（POSTパラメータ解析時にリクエストボディが読み込まれる）、本ハンドラを [NablarchTagHandler](handlers-NablarchTagHandler.md) よりも上位に配置する必要がある

> **注意**: HTTPリクエストのリクエストボディの読み込みを行うハンドラは、必ず [MultipartHandler](handlers-MultipartHandler.md) の後続に配置する必要がある。具体的には、[HttpAccessLogHandler](handlers-HttpAccessLogHandler.md) を拡張して特定のリクエストパラメータを出力するケースや、[ThreadContextHandler](handlers-ThreadContextHandler.md) にリクエストパラメータ内容に依存したカスタム属性を追加するようなケースが該当する。

<details>
<summary>keywords</summary>

MultipartHandler, nablarch.fw.web.upload.MultipartHandler, マルチパートリクエスト処理, ファイルアップロード, 一時ファイル保存, HttpErrorHandler, NablarchTagHandler, HttpAccessLogHandler, ThreadContextHandler, ハンドラ配置順序

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(非マルチパートリクエストのスキップ)**: CONTENT-TYPEヘッダーが `"multipart/form-data"` に一致しない場合は何もせずに後続ハンドラの実行結果をリターン
2. **(マルチパートリクエストの解析)**: メッセージボディを読み込んでマルチパート解析し、アップロードファイルを一時ファイルとして保存。保存先は論理パス名 `"uploadFileTmpDir"` に設定されたパス。論理パス未設定の場合はJavaシステムプロパティ `"java.io.tmpdir"` の値を使用。解析結果はHTTPリクエストオブジェクトに格納され、`HttpRequest.getPart()` でアップロードファイル情報、`HttpRequest.getParam()` 等でその他パラメータを取得できる
3. **(ログ出力)**: アップロードファイル情報をINFOレベルでログ出力
4. **(後続ハンドラへの処理委譲)**: ハンドラキュー上の後続ハンドラに処理を委譲し結果を取得

**[復路処理]**

5. **(終端処理)**: アップロードされた一時ファイルを全て削除
6. **(正常終了)**: 4の結果をリターン

**[エラー処理]**

- **2a. マルチパート形式エラー**: 読み込んだリクエストボディがマルチパートフォーマットに反する場合（接続切断等）、`Result.BadRequest` を送出（ステータスコード400）
- **2b. アップロード上限超過エラー**: 読み込んだデータサイズが設定上限値を超過した場合、`Result.BadRequest` を送出（ステータスコード413）

**[例外処理]**

- **4a. 終端処理**: 後続ハンドラの処理中に何らかの例外が発生した場合、終端処理（5）を実行して例外を再送出

<details>
<summary>keywords</summary>

MultipartHandler, uploadFileTmpDir, java.io.tmpdir, Result.BadRequest, HttpRequest.getPart, HttpRequest.getParam, マルチパート解析, 一時ファイル削除, ファイルアップロード処理フロー

</details>

## 設定項目・拡張ポイント

設定値は `UploadSettings` クラスに集約されている。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| contentLengthLimit | int | | 無制限 | 1リクエストでアップロードできるデータの上限値（単位：バイト）。ファイルサイズの上限ではない。 |
| autoCleaning | boolean | | true | 一時ファイルの自動削除。デバッグや障害解析用に無効化可能 |

> **注意**: 一時ファイル保存中に例外が発生した場合は、`autoCleaning` がオフでもファイルを削除する（不正な状態のファイル—空ファイルや途中まで保存されたファイル—の作成防止）。一時ファイルが正常に保存されて後続ハンドラへ処理委譲できた場合のみ、`autoCleaning` オンの場合にファイルを削除する。

アップロードサイズの上限値を設定することを強く推奨する。上限値は変更になる可能性があるため設定パラメータとして外部化すること。

**基本設定例**:
```xml
<component class="nablarch.fw.web.upload.MultipartHandler" name="multipartHandler">
  <property name="uploadSettings">
    <component class="nablarch.fw.web.upload.UploadSettings">
      <property name="contentLengthLimit" value="${uploadSizeLimit}" />
    </component>
  </property>
</component>
```

アップロードファイルの一時保存先を指定する場合は論理パス名 `"uploadFileTmpDir"` を使用する。保存先パスは環境依存値のため設定パラメータとして外部化すること。

**一時保存先設定例**:
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

UploadSettings, contentLengthLimit, autoCleaning, uploadFileTmpDir, FilePathSetting, アップロードサイズ上限, 一時ファイル自動削除

</details>
