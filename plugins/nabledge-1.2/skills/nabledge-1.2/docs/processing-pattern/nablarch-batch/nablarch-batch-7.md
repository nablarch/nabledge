# バッチ処理を実行するとDuplicateProcessが発生し、処理が異常終了してしまいます。対処方法を教えてください

## DuplicateProcessエラーの原因と対処法

## DuplicateProcessエラーの原因と対処法

**エラーメッセージ**:
```
[500 DuplicateProcess] specified request_id is already used by another process. you can not start two or more processes with same request_id.
```

Nablarchの多重起動防止機能はデータベースの実行中フラグで多重起動チェックを行う。実行中フラグが適切にクリアされないと（例: デバッグ実行中に処理を停止した場合）、何度実行しても *DuplicateProcess* が発生し続ける。

**対処方法**: プロセス管理テーブルの実行中フラグをクリアする。問題のリクエストIDを条件にして実行中フラグを0で更新することで、再度バッチ処理を実行できるようになる。

<details>
<summary>keywords</summary>

DuplicateProcess, 多重起動防止, プロセス管理テーブル, 実行中フラグ, request_id, バッチ多重起動, プロセス多重起動防止ハンドラ

</details>
