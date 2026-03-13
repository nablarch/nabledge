# 出力ファイル開放ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/file_record_writer_dispose_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/io/FileRecordWriterHolder.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/io/FileRecordWriterDisposeHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.common.io.FileRecordWriterDisposeHandler`

> **重要**: 解放対象は `FileRecordWriterHolder` を使用して開いた出力ファイルのみ。`java.io` パッケージ等の他APIで開いたリソースは個別にクローズすること。

<details>
<summary>keywords</summary>

FileRecordWriterDisposeHandler, nablarch.common.io.FileRecordWriterDisposeHandler, FileRecordWriterHolder, 出力ファイル開放, ファイルクローズ, リソース解放

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-dataformat</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core-dataformat, 汎用データフォーマット, モジュール依存関係

</details>

## 制約

なし。

<details>
<summary>keywords</summary>

制約なし, 出力ファイル開放ハンドラ制約

</details>

## ハンドラキューへの設定について

ハンドラキューに設定するだけで、後続のハンドラや業務アクションで開いた出力ファイルを自動的にクローズする。ファイルを出力する全てのハンドラより手前に配置すること。

<details>
<summary>keywords</summary>

ハンドラキュー設定, 出力ファイル自動クローズ, ハンドラ配置順序, ハンドラキュー登録

</details>
