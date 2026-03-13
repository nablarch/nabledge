# ループ制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/batch/dbless_loop_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DbLessLoopHandler.html)

## ハンドラクラス名

データリーダ上に処理対象データが存在する間、後続ハンドラの処理を繰り返し実行する。

> **重要**: DBに接続するバッチアプリケーションではトランザクション管理が必要になるため、本ハンドラではなく [loop_handler](handlers-loop_handler.md) を使用すること。

**クラス名**: `nablarch.fw.handler.DbLessLoopHandler`

**制約**: なし。

<details>
<summary>keywords</summary>

DbLessLoopHandler, nablarch.fw.handler.DbLessLoopHandler, ループ制御ハンドラ, データリーダ, 後続ハンドラ繰り返し実行, DBなしバッチ, 制約なし, DbLessLoopHandler制約

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

nablarch-fw-standalone, com.nablarch.framework, モジュール依存関係

</details>
