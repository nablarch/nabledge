# スレッドコンテキスト変数削除ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.threadcontext.ThreadContextClearHandler`

:ref:`ThreadContextHandler` で設定したスレッドローカル上の変数を削除するハンドラ。

> **注意**: 本ハンドラは極力手前側に配置すること。往路処理では、本ハンドラより手前のハンドラではスレッドコンテキストにアクセスできなくなるため。

<details>
<summary>keywords</summary>

ThreadContextClearHandler, nablarch.common.handler.threadcontext.ThreadContextClearHandler, スレッドコンテキスト変数削除, スレッドローカル変数削除, ThreadContextHandler, ハンドラ配置順序

</details>

## ハンドラ処理フロー

**往路処理:**
1. 後続ハンドラへ処理を委譲（往路では何もしない）

**復路処理:**
2. :ref:`ThreadContextHandler` で設定したスレッドローカル上の変数を削除

**例外処理:**
1. 後続ハンドラでエラーが発生した場合も、:ref:`ThreadContextHandler` で設定したスレッドローカル上の変数を削除

<details>
<summary>keywords</summary>

ThreadContextClearHandler, ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, スレッドローカル変数削除, ThreadContextHandler

</details>

## 設定項目・拡張ポイント

本ハンドラの実装内容は基本的に変更不要なものであり、そのまま使用することができる。以下はDIリポジトリ設定ファイルへの記述例である。

```xml
<component class="nablarch.common.handler.threadcontext.ThreadContextClearHandler" />
```

<details>
<summary>keywords</summary>

ThreadContextClearHandler, XML設定, DIリポジトリ設定, component設定, nablarch.common.handler.threadcontext.ThreadContextClearHandler

</details>
