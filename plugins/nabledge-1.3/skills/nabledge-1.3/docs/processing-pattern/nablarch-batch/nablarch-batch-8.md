# バッチ処理を実行するとProcessStop(kill process.)が発生し、処理が異常終了してしまいます。対処方法を教えてください

## ProcessStop発生時の対処方法

## ProcessStop発生時の対処方法

バッチ実行中に以下のメッセージが出力されて異常終了する場合、Nablarchのプロセス強制終了機能によって停止されている。

```
[50 ProcessStop] kill process.
```

> **重要**: プロセスを強制停止した場合、データベースの停止フラグのクリア処理は行われない。停止フラグの値をクリアする必要がある。

<details>
<summary>keywords</summary>

ProcessStop, kill process, プロセス強制終了, 停止フラグ, バッチ処理異常終了, プロセス停止制御

</details>
