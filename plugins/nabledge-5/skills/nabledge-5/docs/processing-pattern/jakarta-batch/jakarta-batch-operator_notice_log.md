# 運用担当者向けのログ出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/feature_details/operator_notice_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/operation/OperationLogger.html)

## 運用担当者向けログの出力内容

運用担当者向けログには最低限以下の内容を出力する必要がある:

- 何が発生したか
- どのように対処すべきか

<details>
<summary>keywords</summary>

運用担当者向けログ, ログ出力内容, 何が発生したか, どのように対処すべきか, ログ必須項目

</details>

## 運用担当者向けのログを専用のログファイルに出力するための設定を追加する

運用担当者向けのログはログカテゴリ名 `operator` として出力する。[log](../../component/libraries/libraries-log.md) を使用する場合の `log.properties` 設定例:

```properties
# operation log file
writer.operationLog.className=nablarch.core.log.basic.FileLogWriter
writer.operationLog.filePath=./log/operation.log
writer.operationLog.encoding=UTF-8
writer.operationLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.operationLog.formatter.format=$date$ -$logLevel$- $message$

# logger list
availableLoggersNamesOrder=SQL,MON,OPERATOR,ROO

# operation logger setting
loggers.OPERATOR.nameRegex=operator
loggers.OPERATOR.level=INFO
loggers.OPERATOR.writerNames=operationLog
```

[log_adaptor](../../component/adapters/adapters-log_adaptor.md) 使用時はアダプタ対応のログライブラリのマニュアルを参照して設定する。

<details>
<summary>keywords</summary>

operator, FileLogWriter, BasicLogFormatter, log.properties, 専用ログファイル設定, ログカテゴリ設定

</details>

## 運用担当者向けのログを出力する

`OperationLogger#write` を使用してログを出力する。バッチ処理を異常終了させる場合は例外を送出する。

```java
@Named
@Dependent
public class SampleBatchlet extends AbstractBatchlet {

    @Override
    public String process() throws Exception {

        try {
            // 省略
        } catch (FileNotFoundException e) {
            OperationLogger.write(
                    LogLevel.ERROR,
                    "ファイルが存在しません。正しく受信できているか確認してください。",
                    e);
            throw e;
        }

        // 省略
    }
}
```

出力例:
```
ERROR operator ファイルが存在しません。正しく受信できているか確認してください。
```

<details>
<summary>keywords</summary>

OperationLogger, OperationLogger#write, 運用担当者向けログ出力実装, 異常終了, FileNotFoundException, LogLevel, AbstractBatchlet, @Named, @Dependent

</details>
