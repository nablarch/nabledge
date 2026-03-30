# バッチ処理を実行するとDuplicateProcessが発生し、処理が異常終了してしまいます。対処方法を教えてください

## DuplicateProcess発生時の対処方法

## DuplicateProcess発生時の対処方法

`[500 DuplicateProcess] specified request_id is already used by another process. you can not start two or more processes with same request_id.` が発生する原因は、多重起動防止機能が使用する「実行中フラグ」が適切にクリアされていないことである。

> **注意**: デバッグ実行中に処理を停止した場合など、実行中フラグのクリアが行われずにフラグが実行中のままになることがある。この状態では、何度バッチ処理を実行しても *DuplicateProcess* が発生し続ける。

**対処手順**:

1. プロセス管理テーブル（Nablarchが多重起動チェックに使用するテーブル）を確認する
2. リクエストIDをキーにして、問題の起きているリクエストIDに対応する実行中フラグを `0` で更新する
3. 更新後、バッチ処理を再実行する

多重起動防止機能の詳細は「プロセス多重起動防止ハンドラ」を参照。

<details>
<summary>keywords</summary>

DuplicateProcess, 多重起動防止, 実行中フラグ, プロセス管理テーブル, リクエストID, 多重起動防止機能, プロセス多重起動防止ハンドラ

</details>
