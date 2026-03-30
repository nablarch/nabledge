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

1. **往路処理**: 何もせずに後続のハンドラに処理を委譲し、その結果を取得する。
2. **復路処理（正常終了）**: :ref:`ThreadContextHandler` で設定したスレッドローカル上の変数を削除する。
3. **例外処理（エラー終了）**: 後続ハンドラでエラーが発生した場合も、:ref:`ThreadContextHandler` で設定したスレッドローカル上の変数を削除する。

<details>
<summary>keywords</summary>

ThreadContextClearHandler, ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, スレッドコンテキスト削除

</details>

## 設定項目・拡張ポイント

実装内容は変更不要。DIリポジトリ設定ファイルへの記述例:

```xml
<component class="nablarch.common.handler.threadcontext.ThreadContextClearHandler" />
```

<details>
<summary>keywords</summary>

ThreadContextClearHandler, DIリポジトリ設定, コンポーネント定義, nablarch.common.handler.threadcontext.ThreadContextClearHandler

</details>
