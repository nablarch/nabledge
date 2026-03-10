# logアダプタ

## logアダプタ概要

Nablarchのログ出力機能のログ出力処理を以下のログフレームワークに委譲するアダプタ。

- slf4j
- JBoss Logging

顧客からの要求や使用する製品などにあわせてロガーを統一したい場合に、アダプタを使用する。アダプタを使用した場合、Nablarchのログ出力機能を使用したログ出力処理は全て選択したロギングフレームワークに委譲される。

## モジュール一覧

> **重要**: Nablarch5u15まで提供されていたlog4jアダプタは廃止。EOLを迎えたlog4j1.2を使用しており、[脆弱性](https://jvndb.jvn.jp/ja/contents/2019/JVNDB-2019-013606.html)への修正が公開されないため。slf4jまたはJBoss Loggingを使用すること。

### slf4j

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-slf4j-adaptor</artifactId>
</dependency>
```

> **重要**: slf4jにはFATALレベルが存在しないため、FATALレベルでのログ出力は全てERRORレベルで出力される。

> **補足**: slf4j バージョン2.0.11でテスト済み。バージョン変更時はプロジェクト側でテストを実施すること。

### JBoss Logging

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-jboss-logging-adaptor</artifactId>
</dependency>
```

> **補足**: JBoss Logging バージョン3.6.0.Finalでテスト済み。バージョン変更時はプロジェクト側でテストを実施すること。

## ロギングフレームワークを使用するための設定を行う

ログ出力機能の設定ファイル(**log.properties**)にファクトリを設定する。この設定によりログ出力処理がロギングフレームワークに委譲される。

### slf4j

```properties
loggerFactory.className=nablarch.integration.log.slf4j.Slf4JLoggerFactory
```

### JBoss Logging

```properties
loggerFactory.className=nablarch.integration.log.jbosslogging.JbossLoggingLoggerFactory
```
