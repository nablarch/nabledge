# 運用担当者向けのログ出力

## 運用担当者向けログの出力内容

運用担当者向けログには、最低限以下の内容を出力すること:
- 何が発生したか
- どのように対処すべきか

これらが出力されていない場合、運用担当者が対処方法を判断できない。

## 運用担当者向けのログを専用のログファイルに出力するための設定を追加する

運用担当者向けのログはログカテゴリ名 `operator` で出力する。

:ref:`log` を使用した場合の `log.properties` 設定例:

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

> **注意**: :ref:`log_adaptor` を使用している場合は、アダプタに対応したログライブラリのマニュアルを参照すること。

## 運用担当者向けのログを出力する

`OperationLogger#write` を使用してログを出力する。

> **重要**: バッチ処理を異常終了させたい場合は例外を送出すること。

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
```bash
ERROR operator ファイルが存在しません。正しく受信できているか確認してください。
```
