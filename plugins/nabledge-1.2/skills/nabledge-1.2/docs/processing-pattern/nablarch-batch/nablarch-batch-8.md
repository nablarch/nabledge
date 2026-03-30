# バッチ処理を実行するとProcessStop(kill process.)が発生し、処理が異常終了してしまいます。対処方法を教えてください

## ProcessStop(kill process.)エラーの対処方法

バッチ処理実行時に `[50 ProcessStop] kill process.` がログ出力され異常終了する場合の対処方法。

Nablarchはプロセスを強制終了する機能を提供している。この機能を使ってプロセスを強制停止した場合、データベースの停止フラグのクリア処理は行われない。そのため、停止フラグの値をクリアする必要がある。

詳細は「プロセス停止制御ハンドラ」のドキュメントを参照。

<details>
<summary>keywords</summary>

ProcessStop, kill process, プロセス強制停止, 停止フラグ, バッチ異常終了

</details>
