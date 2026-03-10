# ループ制御ハンドラ

## 概要

本ハンドラは、データリーダ上に処理対象のデータが存在する間、後続ハンドラの処理を繰り返し実行する。

> **重要**: DBに接続するバッチアプリケーションではトランザクション管理が必要になるため、本ハンドラではなく `loop_handler` を使用すること。

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.DbLessLoopHandler`

DBに接続しないバッチアプリケーション向けのループ制御ハンドラ。DBに接続するバッチアプリケーションでは、トランザクション管理が必要なため `loop_handler` を使用すること。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```
