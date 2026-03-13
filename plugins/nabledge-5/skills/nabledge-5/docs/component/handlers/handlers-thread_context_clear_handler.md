# スレッドコンテキスト変数削除ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/thread_context_clear_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/ThreadContextClearHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.common.handler.threadcontext.ThreadContextClearHandler`

<details>
<summary>keywords</summary>

ThreadContextClearHandler, nablarch.common.handler.threadcontext.ThreadContextClearHandler, スレッドコンテキスト変数削除ハンドラ

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw, com.nablarch.framework, モジュール依存関係

</details>

## 制約

> **重要**: 本ハンドラは極力手前側に配置すること。復路処理では、本ハンドラより手前のハンドラはスレッドコンテキストにアクセスできなくなるため。

<details>
<summary>keywords</summary>

ハンドラ配置順序, スレッドコンテキスト, 復路処理, 配置制約

</details>

## スレッドコンテキストの削除処理

[thread_context_handler](handlers-thread_context_handler.md) でスレッドローカル上に設定した値を全て削除する。

<details>
<summary>keywords</summary>

スレッドコンテキスト削除, スレッドローカル変数削除, thread_context_handler, ThreadContextHandler

</details>
