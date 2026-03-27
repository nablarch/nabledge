# バッチ処理を実行するとProcessStop(kill process.)が発生し、処理が異常終了してしまいます。対処方法を教えてください

## ProcessStop (kill process.) 発生時の対処方法

## ProcessStop (kill process.) 発生時の対処方法

**症状**: バッチ処理実行中に `[50 ProcessStop] kill process.` がログ出力され異常終了する。

> **重要**: Nablarchのプロセス強制終了機能を使用した場合、データベースの停止フラグのクリア処理は自動的に行われない。停止フラグの値をクリアする必要がある。

<details>
<summary>keywords</summary>

ProcessStop, kill process, プロセス強制終了, 停止フラグ, バッチ処理異常終了, プロセス停止制御ハンドラ

</details>
