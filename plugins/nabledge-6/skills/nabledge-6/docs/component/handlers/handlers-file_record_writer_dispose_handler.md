# 出力ファイル開放ハンドラ

## 概要

業務アクションやハンドラで開いた出力ファイルを閉じる(リソースの解放)ハンドラ。解放対象となるのは `FileRecordWriterHolder` を使用して開いた出力ファイルのみ。`java.io` パッケージ等の他のAPIで開いたリソースは個別にクローズ処理を行うこと。

## ハンドラクラス名

**クラス**: `nablarch.common.io.FileRecordWriterDisposeHandler`

## モジュール一覧

**モジュール**:
```xml
<!-- 汎用データフォーマット -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-dataformat</artifactId>
</dependency>
```

## 制約

出力ファイル開放ハンドラに固有の制約はない。

## ハンドラキューへの設定について

> **重要**: 解放対象は `FileRecordWriterHolder` を使用して開いた出力ファイルのみ。`java.io` パッケージ等で開いたリソースは個別にクローズ処理を行うこと。

ハンドラキューに設定するだけで、後続ハンドラや業務アクションで開いた出力ファイルを自動的にクローズする。ファイルを出力する全てのハンドラより手前に設定すること。
