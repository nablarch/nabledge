## スレッドコンテキスト変数削除ハンドラ

**クラス名:** `nablarch.common.handler.threadcontext.ThreadContextClearHandler`

-----

-----

### 概要

[スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md#スレッドコンテキスト変数管理ハンドラ) で設定したスレッドローカル上の変数を削除するハンドラである。

> **Note:**
> 本ハンドラは極力手前側に配置すること。
> なぜなら往路処理では、本ハンドラより手前のハンドラではスレッドコンテキストにアクセスできなくなるため。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| スレッドコンテキスト変数削除ハンドラ | nablarch.common.handler.threadcontext.ThreadContextClearHandler | Object | Object | - | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する |
| スレッドコンテキスト変数設定ハンドラ(メインスレッド) | nablarch.common.handler.ThreadContextHandler_main | Object | Object | 起動引数の内容からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。 | - | - |

### ハンドラ処理フロー

**[往路処理]**

**1. (後続ハンドラへの処理委譲)**

往路では何もせずに後続のハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

**2. (正常終了)**

[スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md#スレッドコンテキスト変数管理ハンドラ) で設定したスレッドローカル上の変数を削除する。

**[例外処理]**

**1. (エラー終了)**

後続ハンドラの処理中にエラーが発生した場合も、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md#スレッドコンテキスト変数管理ハンドラ) で設定したスレッドローカル上の変数を削除する。

### 設定項目・拡張ポイント

本ハンドラの実装内容は基本的に変更不要なものであり、そのまま使用することができる。
以下はDIリポジトリ設定ファイルへの記述例である。

```xml
<component class="nablarch.common.handler.threadcontext.ThreadContextClearHandler" />
```
