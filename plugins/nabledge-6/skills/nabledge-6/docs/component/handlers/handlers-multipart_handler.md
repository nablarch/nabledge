# マルチパートリクエストハンドラ

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.upload.MultipartHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```
一時保存先を指定する場合のみ:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

## 制約

なし。

## このハンドラの動作条件

リクエストヘッダの `Content-Type` が `multipart/form-data` と一致する場合のみリクエストボディを解析する。それ以外の場合は何もせず後続ハンドラに委譲する。

## アップロードファイルの一時保存先を指定する

一時保存先ディレクトリは :ref:`file_path_management` に設定する。論理名は `uploadFileTmpDir` とすること。未設定の場合はシステムプロパティ `java.io.tmpdir` の値を使用する。

> **補足**: 保存先ディレクトリの値は環境ごとに異なるため、コンポーネント設定ファイルではなく環境設定ファイルへの設定を推奨する。詳細は :ref:`repository-environment_configuration` 参照。

```xml
<component name="filePathSetting" class="nablarch.core.util.FilePathSetting">
  <property name="basePathSettings">
    <map>
      <entry key="uploadFileTmpDir" value="file:/var/nablarch/uploadTmpDir" />
    </map>
  </property>
</component>
```

## 巨大なファイルのアップロードを防ぐ

アップロードサイズの上限を超過した場合、413(Payload Too Large)をクライアントに返却する。設定省略時は無制限となる。DoS攻撃防止のため常に設定すること。

> **補足**: アップロードサイズの上限はファイル単位ではなく1リクエスト全体の上限。複数ファイルの場合はファイルサイズ合計値（Content-Length）でチェックされる。ファイル単位でのサイズチェックが必要な場合はアクション側で実装すること。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| contentLengthLimit | | | 無制限 | アップロードサイズ(Content-Length)の上限(バイト数) |

```xml
<component class="nablarch.fw.web.upload.MultipartHandler" name="multipartHandler">
  <property name="uploadSettings">
    <component class="nablarch.fw.web.upload.UploadSettings">
      <property name="contentLengthLimit" value="1000000" />
    </component>
  </property>
</component>
```

## ファイルの大量アップロードを防ぐ

上限を超えるファイルがアップロードされた場合、400(Bad Request)を返す。`maxFileCount` に0以上の値を設定するとその値が上限となる。負数を設定した場合は無制限。未設定時のデフォルトは-1（無制限）。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| maxFileCount | | | -1 | 一度にアップロードできるファイル数の上限。0以上: 上限値、負数: 無制限 |

```xml
<component class="nablarch.fw.web.upload.MultipartHandler" name="multipartHandler">
  <property name="uploadSettings">
    <component class="nablarch.fw.web.upload.UploadSettings">
      <property name="maxFileCount" value="100" />
    </component>
  </property>
</component>
```

## 一時ファイルの削除（クリーニング）を行う

クリーニング実行条件:
1. ボディの解析中に例外が発生した場合
2. ハンドラの復路で自動削除設定が有効な場合

自動削除設定はデフォルトで有効。本番環境で安易に無効にすると大量の一時ファイルがディスク上に残り、ディスクフルの原因となるため注意すること。無効にする場合は `UploadSettings#autoCleaning` に `false` を設定する。

## マルチパート解析エラー及びファイルサイズ上限超過時の遷移先画面を設定する

マルチパート解析エラーおよびファイルサイズ上限超過時に400(BadRequest)をクライアントに返却する。`web.xml` に400に対応したエラーページを設定すること。設定を省略した場合は、ウェブアプリケーションサーバが持つデフォルトのページなどがクライアントに返却される。

> **重要**: このハンドラは :ref:`session_store_handler` より手前に設定する必要がある。このため、後続に設定される :ref:`http_error_handler` の :ref:`HttpErrorHandler_DefaultPage` は使用できない。

マルチパート解析エラーが発生するケース:
- アップロード中にクライアントからの切断要求があり、ボディ部が不完全な場合
- バウンダリーが存在しない場合

## アップロードしたファイルを読み込む

`HttpRequest` の `HttpRequest#getPart` を呼び出してアップロードファイルを取得する。引数にはパラメータ名を指定する。

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

アップロードファイルの処理には :ref:`data_bind` が推奨。扱えない形式の場合は :ref:`data_format` を使用すること。

> **補足**: バイナリファイル（画像等）の場合は以下のようにバイトデータを読み込むこと。
>
> ```java
> File savedFile = partInfo.getSavedFile();
> try {
>     byte[] bytes = Files.readAllBytes(savedFile.toPath());
> } catch (IOException e) {
>     throw new RuntimeException(e);
> }
> ```
