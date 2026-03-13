# logアダプタ

**公式ドキュメント**: [logアダプタ](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/log_adaptor.html)

## モジュール一覧

NablarchのログフレームワークへのアダプタはNablarchの [ログ出力機能](../libraries/libraries-log.md) のログ出力処理をslf4jまたはJBoss Loggingに委譲する。顧客要求や使用製品に合わせてロガーを統一したい場合に使用する。アダプタを使用するとNablarchの [ログ出力機能](../libraries/libraries-log.md) を使用したログ出力処理は全て選択したロギングフレームワークに委譲される。

> **重要**: Nablarch5u15まで提供されていたlog4jアダプタは廃止。[脆弱性](https://jvndb.jvn.jp/ja/contents/2019/JVNDB-2019-013606.html)への修正が公開されないEOL済み[log4j1.2](https://logging.apache.org/log4j/1.x/)を使用していたため。slf4jまたはJBoss Loggingを使用すること。

## slf4j

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-slf4j-adaptor</artifactId>
</dependency>
```

> **重要**: slf4jにはFATALレベルが存在しないため、FATALレベルでのログ出力は全てERRORレベルで出力される。

> **補足**: slf4jバージョン1.7.22でテスト済み。バージョン変更時はプロジェクト側でテストを行い問題ないことを確認すること。

## JBoss Logging

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-jboss-logging-adaptor</artifactId>
</dependency>
```

> **補足**: JBoss Loggingバージョン3.3.0.Finalでテスト済み。バージョン変更時はプロジェクト側でテストを行い問題ないことを確認すること。

<details>
<summary>keywords</summary>

nablarch-slf4j-adaptor, nablarch-jboss-logging-adaptor, slf4j, JBoss Logging, logアダプタ, FATALレベル, ロギングフレームワーク統一, log4jアダプタ廃止

</details>

## ロギングフレームワークを使用するための設定を行う

[ログ出力機能](../libraries/libraries-log.md) の設定ファイル(**log.properties**)にファクトリを設定することで、ログ出力処理がロギングフレームワークに委譲される。

## slf4j

```properties
loggerFactory.className=nablarch.integration.log.slf4j.Slf4JLoggerFactory
```

## JBoss Logging

```properties
loggerFactory.className=nablarch.integration.log.jbosslogging.JbossLoggingLoggerFactory
```

<details>
<summary>keywords</summary>

Slf4JLoggerFactory, JbossLoggingLoggerFactory, nablarch.integration.log.slf4j.Slf4JLoggerFactory, nablarch.integration.log.jbosslogging.JbossLoggingLoggerFactory, loggerFactory.className, log.properties, ログファクトリ設定

</details>
