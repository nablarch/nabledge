# スレッドコンテキスト変数削除ハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* スレッドコンテキストの削除処理

[スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) で設定したスレッドローカル上の変数を削除するハンドラ。

本ハンドラでは、以下の処理を行う。

* [スレッドコンテキストの削除処理](../../component/handlers/handlers-thread-context-clear-handler.md#thread-context-clear-handler-clear)

処理の流れは以下のとおり。

![flow.png](../../../knowledge/assets/handlers-thread-context-clear-handler/flow.png)

## ハンドラクラス名

* nablarch.common.handler.threadcontext.ThreadContextClearHandler

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw</artifactId>
</dependency>
```

## 制約

本ハンドラは極力手前側に配置すること。
なぜなら復路処理では、本ハンドラより手前のハンドラではスレッドコンテキストにアクセスできなくなるため。

## スレッドコンテキストの削除処理

[スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) でスレッドローカル上に設定した値を全て削除する。
