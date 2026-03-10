# スレッドコンテキスト変数削除ハンドラ

## ハンドラクラス名

**クラス名**: `nablarch.common.handler.threadcontext.ThreadContextClearHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw</artifactId>
</dependency>
```

## 制約

> **重要**: 本ハンドラは極力手前側に配置すること。復路処理では、本ハンドラより手前のハンドラはスレッドコンテキストにアクセスできなくなる。

## スレッドコンテキストの削除処理

`ThreadContextHandler` でスレッドローカル上に設定した値を全て削除する。
