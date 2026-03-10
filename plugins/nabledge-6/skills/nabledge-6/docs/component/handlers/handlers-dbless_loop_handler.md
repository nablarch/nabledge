# ループ制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/batch/dbless_loop_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DbLessLoopHandler.html)

## 概要

本ハンドラは、データリーダ上に処理対象のデータが存在する間、後続ハンドラの処理を繰り返し実行する。

> **重要**: DBに接続するバッチアプリケーションではトランザクション管理が必要になるため、本ハンドラではなく `loop_handler` を使用すること。

<details>
<summary>keywords</summary>

ループ制御ハンドラ, DbLessLoopHandler, 繰り返し実行, データリーダ, 後続ハンドラ, DBなしバッチ, 処理対象データ

</details>

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.DbLessLoopHandler`

DBに接続しないバッチアプリケーション向けのループ制御ハンドラ。DBに接続するバッチアプリケーションでは、トランザクション管理が必要なため `loop_handler` を使用すること。

<details>
<summary>keywords</summary>

DbLessLoopHandler, nablarch.fw.handler.DbLessLoopHandler, ループ制御ハンドラ, DBなしバッチ, 繰り返し実行, データリーダ, loop_handler

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-standalone, com.nablarch.framework, Maven依存関係, モジュール

</details>
