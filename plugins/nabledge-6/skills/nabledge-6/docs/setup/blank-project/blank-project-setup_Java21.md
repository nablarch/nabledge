# Java21で使用する場合のセットアップ方法

## Java21で使用する場合のセットアップ方法

Java21でブランクプロジェクトを使用する場合、各ブランクプロジェクトの疎通確認前に以下の手順を行う。

- 標準エンコーディングの変更（標準エンコーディングをJava17以前と同じ実行環境にしたい場合）
- Javaバージョンの変更

## 標準エンコーディングの変更（標準エンコーディングをJava17以前と同じく実行環境依存にしたい場合）

Java18から標準エンコーディングがUTF-8に統一され、環境依存ではなくなった。標準エンコーディングをJava17以前と同じく実行環境依存にしたい場合は、JVMオプションとして `-Dfile.encoding=COMPAT` を指定する。

> **補足**: Mavenから実行する場合は、環境変数 [MAVEN_OPTS (外部サイト)](https://maven.apache.org/configure.html#MAVEN_OPTS_environment_variable.3A) を使ってJVMオプションを設定できる。ただしログに `Picked up MAVEN_OPTS: -Dfile.encoding=COMPAT` が表示される。MavenプラグインによってはJVMオプションの設定方法が異なる場合がある（例: テストを実行するmaven-surefire-pluginでは、pom.xmlのプラグイン設定の `argLine` で指定する）。

> **重要**: Java17までは `-Dfile.encoding=COMPAT` は有効ではないため、従来の実行環境にこのJVMオプションが適用されないよう注意すること。

## Javaバージョンの変更

ブランクプロジェクトではソース及びclassファイルが準拠するJavaバージョンとしてJava17が設定されているため、以下のようにpom.xmlを変更する。

```xml
<!-- Javaバージョンの箇所を以下のように変更する-->
<java.version>21</java.version>
```
