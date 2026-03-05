# SLF4Jアダプタ

## 概要

多くのJavaのOSSは SLF4J を使用してログ出力を行っている。これらのモジュールを使用する際、Nablarchの :ref:`ログ出力機能 <log>` にログ出力を集約したい場合がある。このケースに対応するため、SLF4JのAPIを経由してNablarchのログ出力機能でログ出力を行うアダプタを提供する。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>slf4j-nablarch-adaptor</artifactId>
</dependency>
```

> **補足**: SLF4Jバージョン2.0.11でテスト済み。バージョン変更時はプロジェクト側でテストを行うこと。SLF4J 2.0.0以降はロギング実装の検索方法が変更されており、互換性のない1.7系が使用された場合、以下のログが出力され以降のログ出力が行われないため注意:
```
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
```

## SLF4Jアダプタを使用する

SLF4Jは実行時に必要なクラスを自動検出するため、依存モジュールに追加するだけで使用できる。ログ出力の設定は :ref:`ログ出力機能 <log>` を参照。

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>slf4j-nablarch-adaptor</artifactId>
  <scope>runtime</scope>
</dependency>
```
