# 出力ファイル開放ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/file_record_writer_dispose_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/io/FileRecordWriterHolder.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/io/FileRecordWriterDisposeHandler.html)

## 概要

業務アクションやハンドラで開いた出力ファイルを閉じる(リソースの解放)ハンドラ。解放対象となるのは `FileRecordWriterHolder` を使用して開いた出力ファイルのみ。`java.io` パッケージ等の他のAPIで開いたリソースは個別にクローズ処理を行うこと。

<details>
<summary>keywords</summary>

出力ファイル開放ハンドラとは, FileRecordWriterDisposeHandler概要, 出力ファイルを閉じる, リソース解放ハンドラ

</details>

## ハンドラクラス名

**クラス**: `nablarch.common.io.FileRecordWriterDisposeHandler`

<details>
<summary>keywords</summary>

FileRecordWriterDisposeHandler, nablarch.common.io.FileRecordWriterDisposeHandler, 出力ファイル開放ハンドラ, ハンドラクラス

</details>

## モジュール一覧

**モジュール**:
```xml
<!-- 汎用データフォーマット -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-dataformat</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core-dataformat, com.nablarch.framework, 汎用データフォーマット, モジュール依存関係

</details>

## 制約

出力ファイル開放ハンドラに固有の制約はない。

<details>
<summary>keywords</summary>

制約なし, 出力ファイル開放ハンドラ制約

</details>

## ハンドラキューへの設定について

> **重要**: 解放対象は `FileRecordWriterHolder` を使用して開いた出力ファイルのみ。`java.io` パッケージ等で開いたリソースは個別にクローズ処理を行うこと。

ハンドラキューに設定するだけで、後続ハンドラや業務アクションで開いた出力ファイルを自動的にクローズする。ファイルを出力する全てのハンドラより手前に設定すること。

<details>
<summary>keywords</summary>

FileRecordWriterHolder, nablarch.common.io.FileRecordWriterHolder, ハンドラキュー設定, 出力ファイル自動クローズ, リソース解放

</details>
