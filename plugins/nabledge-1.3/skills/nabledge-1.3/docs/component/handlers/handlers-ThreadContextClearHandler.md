# スレッドコンテキスト変数削除ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.threadcontext.ThreadContextClearHandler`

:ref:`ThreadContextHandler` で設定したスレッドローカル上の変数を削除するハンドラ。

> **注意**: 本ハンドラは極力手前側に配置すること。往路処理では、本ハンドラより手前のハンドラではスレッドコンテキストにアクセスできなくなるため。

<details>
<summary>keywords</summary>

ThreadContextClearHandler, nablarch.common.handler.threadcontext.ThreadContextClearHandler, ThreadContextHandler, スレッドコンテキスト変数削除, スレッドローカル変数, ハンドラ配置順序

</details>

## ハンドラ処理フロー

1. **[往路処理]** 何もせずに後続ハンドラへ処理委譲。
2. **[復路処理]** :ref:`ThreadContextHandler` で設定したスレッドローカル上の変数を削除。
3. **[例外処理]** 後続ハンドラでエラーが発生した場合も、:ref:`ThreadContextHandler` で設定したスレッドローカル上の変数を削除。

<details>
<summary>keywords</summary>

ThreadContextClearHandler, ThreadContextHandler, ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, スレッドローカル変数削除

</details>

## 設定項目・拡張ポイント

本ハンドラの実装内容は変更不要のため、そのまま使用可能。

```xml
<component class="nablarch.common.handler.threadcontext.ThreadContextClearHandler" />
```

<details>
<summary>keywords</summary>

ThreadContextClearHandler, DIリポジトリ設定, XML設定, ハンドラ設定, 設定不要

</details>
