# マルチパートリクエストハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/multipart_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/upload/MultipartHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpRequest.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/upload/UploadSettings.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.upload.MultipartHandler`

<details>
<summary>keywords</summary>

MultipartHandler, nablarch.fw.web.upload.MultipartHandler, マルチパートリクエストハンドラ, ハンドラクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>

<!-- 一時保存先を指定する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, nablarch-core, モジュール依存関係, Maven

</details>

## 制約

なし。

<details>
<summary>keywords</summary>

制約, 前提条件, マルチパートリクエストハンドラ制約

</details>

## このハンドラの動作条件

リクエストヘッダの `Content-Type` が `multipart/form-data` と一致する場合のみボディ解析を行う。それ以外の場合は後続のハンドラに処理を委譲する（このハンドラは何もしない）。

<details>
<summary>keywords</summary>

Content-Type, multipart/form-data, マルチパート判定, 動作条件, リクエスト解析

</details>

## アップロードファイルの一時保存先を指定する

一時保存先ディレクトリは [file_path_management](../libraries/libraries-file_path_management.md) に設定する。論理名は `uploadFileTmpDir` とすること。設定がない場合は `java.io.tmpdir` を使用する。

> **補足**: 保存先ディレクトリはコンポーネント設定ファイルではなく、環境設定ファイルに設定することを推奨する（[repository-environment_configuration](../libraries/libraries-repository.md) 参照）。

```xml
<component name="filePathSetting" class="nablarch.core.util.FilePathSetting">
  <property name="basePathSettings">
    <map>
      <entry key="uploadFileTmpDir" value="file:/var/nablarch/uploadTmpDir" />
    </map>
  </property>
</component>
```

<details>
<summary>keywords</summary>

uploadFileTmpDir, FilePathSetting, java.io.tmpdir, 一時保存先ディレクトリ, アップロードファイル保存先

</details>

## 巨大なファイルのアップロードを防ぐ

アップロードサイズ上限を超過した場合、413(Payload Too Large)を返す。設定を省略した場合は無制限になる。

> **重要**: DoS攻撃を防ぐためにも、アップロードサイズの上限は常に設定すること。

> **補足**: アップロードサイズの上限はファイル単位ではなく1リクエスト単位（Content-Length）。複数ファイルをアップロードした場合、ファイルサイズの合計で上限チェックが行われる。ファイル単位でサイズチェックする場合はアクション側で実装すること。

```xml
<component class="nablarch.fw.web.upload.MultipartHandler" name="multipartHandler">
  <property name="uploadSettings">
    <component class="nablarch.fw.web.upload.UploadSettings">
      <!-- アップロードサイズ(Content-Length)の上限(約1MB) -->
      <property name="contentLengthLimit" value="1000000" />
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

contentLengthLimit, 413, Payload Too Large, ファイルサイズ制限, DoS対策, UploadSettings

</details>

## ファイルの大量アップロードを防ぐ

`maxFileCount` を設定することで1リクエストでアップロードできるファイル数に上限を設定できる。上限を超えた場合は400(Bad Request)を返す。

| 設定値 | 動作 |
|---|---|
| 0以上 | その値が上限 |
| 負数 | 無制限 |
| 未設定 | -1（無制限） |

```xml
<component class="nablarch.fw.web.upload.MultipartHandler" name="multipartHandler">
  <property name="uploadSettings">
    <component class="nablarch.fw.web.upload.UploadSettings">
      <property name="maxFileCount" value="100" />
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

maxFileCount, 400, ファイル数制限, 大量アップロード防止, UploadSettings

</details>

## 一時ファイルの削除（クリーニング）を行う

以下の条件で一時ファイルをクリーニングする:
1. ボディ解析中に例外が発生した場合
2. ハンドラの復路で自動削除設定が有効な場合

自動削除設定はデフォルトで有効。無効にするには `UploadSettings#autoCleaning` に `false` を設定する。

> **重要**: 本番環境で自動削除を無効にすると、大量の一時ファイルがディスク上に残り、ディスクフルの原因となる可能性がある。

<details>
<summary>keywords</summary>

autoCleaning, UploadSettings, 一時ファイルクリーニング, 自動削除, UploadSettings#autoCleaning

</details>

## マルチパート解析エラー及びファイルサイズ上限超過時の遷移先画面を設定する

マルチパート解析エラーや [ファイルサイズの上限超過](#s5) 時に `400(BadRequest)` を返す。`web.xml` に 400 に対応したエラーページ設定が必要。省略した場合はWebアプリケーションサーバのデフォルトページが返される。

マルチパート解析エラーが発生するケース:
- アップロード中にクライアントからの切断要求があり、ボディ部が不完全な場合
- バウンダリーが存在しない

> **重要**: このハンドラは [session_store_handler](handlers-SessionStoreHandler.md) より手前に設定する必要がある。このため、[session_store_handler](handlers-SessionStoreHandler.md) の後続に設定される [http_error_handler](handlers-HttpErrorHandler.md) の :ref:`HttpErrorHandler_DefaultPage` は使用できない。

<details>
<summary>keywords</summary>

エラーページ, 400 BadRequest, web.xml, session_store_handler, マルチパート解析エラー, http_error_handler

</details>

## アップロードしたファイルを読み込む

`HttpRequest` から `HttpRequest#getPart` を呼び出してアップロードファイルを取得する。引数にはパラメータ名を指定する。

アップロードファイルの処理には [data_bind](../libraries/libraries-data_bind.md) が推奨（扱えない形式は [data_format](../libraries/libraries-data_format.md) を使用）。詳細は [data_bind-upload_file](../libraries/libraries-data_bind.md)、[data_format-load_upload_file](../libraries/libraries-data_format.md) を参照。

```java
public HttpResponse upload(HttpRequest request, ExecutionContext context) throws IOException {
    List<PartInfo> partInfoList = request.getPart("uploadFile");

    if (partInfoList.isEmpty()) {
      // アップロードファイルが指定されていなかった場合は業務エラー
    }

    InputStream file = partInfoList.get(0).getInputStream();
    // 以下アップロードファイルを読み込み処理を行う。
}
```

> **補足**: アップロードされたファイルが画像ファイル等のバイナリファイルの場合は、読み込んだバイナリデータを使用して処理を行うこと。Java 8 であれば `partInfo.getSavedFile()` と `Files.readAllBytes()` を使用してバイトデータを読み込める。

```java
File savedFile = partInfo.getSavedFile();
try {
    byte[] bytes = Files.readAllBytes(savedFile.toPath());
} catch (IOException e) {
    throw new RuntimeException(e);
}
```

<details>
<summary>keywords</summary>

HttpRequest, getPart, PartInfo, アップロードファイル読み込み, nablarch.fw.web.HttpRequest, HttpRequest#getPart, getSavedFile, Files.readAllBytes, バイナリファイル, 画像ファイル

</details>
