# Java21で使用する場合のセットアップ方法

**公式ドキュメント**: [Java21で使用する場合のセットアップ方法](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Java21.html)

## Java21で使用する場合のセットアップ方法

Java21でブランクプロジェクトを使用する場合、各ブランクプロジェクトの疎通確認前に以下の手順を行う。

1. 依存モジュールの追加
2. gsp-dba-maven-pluginがJava21で動くように設定する
3. 自動テストで使用するJettyのモジュール変更（ウェブプロジェクト または RESTfulウェブサービスプロジェクトの場合のみ）
4. --add-opensオプションの追加（JSR352に準拠したバッチプロジェクトの場合のみ）
5. 標準エンコーディングの変更（標準エンコーディングをJava17以前と同じく実行環境依存にしたい場合）
6. Javaバージョンの変更

<details>
<summary>keywords</summary>

Java21, ブランクプロジェクト, セットアップ, 疎通確認前, 必要手順一覧, 依存モジュール, gsp-dba-maven-plugin, Jetty, --add-opens, 標準エンコーディング, Javaバージョン変更

</details>

## 依存モジュールの追加

Java17の手順と同様。:ref:`setup_blank_project_for_Java17_add_dependencies` を参照。

<details>
<summary>keywords</summary>

依存モジュール追加, Java21, Java17と同様

</details>

## gsp-dba-maven-pluginがJava21で動くように設定する

Java17の手順と同様。:ref:`setup_blank_project_for_Java17_gsp_dba_maven_plugin` を参照。

<details>
<summary>keywords</summary>

gsp-dba-maven-plugin, Java21, Maven, Java17と同様

</details>

## 自動テストで使用するJettyのモジュール変更(ウェブプロジェクト または RESTfulウェブサービスプロジェクトの場合のみ)

Java17の手順と同様。[setup_java17_jetty9](blank-project-setup_Java17.md) を参照。

<details>
<summary>keywords</summary>

Jetty, 自動テスト, ウェブプロジェクト, RESTfulウェブサービス, モジュール変更, Java17と同様

</details>

## --add-opensオプションの追加（JSR352に準拠したバッチプロジェクトの場合のみ）

Java17の手順と同様。:ref:`setup_blank_project_for_Java17_add_JVMoption` を参照。

<details>
<summary>keywords</summary>

--add-opens, JVMオプション, JSR352, バッチプロジェクト, Java17と同様

</details>

## 標準エンコーディングの変更（標準エンコーディングをJava17以前と同じく実行環境依存にしたい場合）

Java18以降は標準エンコーディングがUTF-8に統一され、環境依存ではなくなった。Java17以前と同じく実行環境依存にしたい場合は、Javaコマンドの実行時オプションとして以下のシステムプロパティを指定する。

- `-Dfile.encoding=COMPAT`

> **補足**: Mavenから実行する場合は、環境変数 [MAVEN_OPTS](https://maven.apache.org/configure.html#MAVEN_OPTS_environment_variable.3A) を使ってJVMオプションを設定できる（ログに `Picked up MAVEN_OPTS: -Dfile.encoding=COMPAT` が表示される）。MavenプラグインによってはJVMオプションの設定方法が異なる場合があるため注意。例: テスト実行用の maven-surefire-plugin では、pom.xml のプラグイン設定にある `argLine` で指定する必要がある。

> **重要**: Java17以前は `-Dfile.encoding=COMPAT` オプションは有効ではないため、従来の実行環境にこのJVMオプションが適用されないよう注意すること。

<details>
<summary>keywords</summary>

-Dfile.encoding=COMPAT, 標準エンコーディング, UTF-8, Java18以降, MAVEN_OPTS, maven-surefire-plugin, argLine

</details>

## Javaバージョンの変更

ブランクプロジェクトはデフォルトでJava8が設定されているため、`pom.xml` のJavaバージョン箇所を以下のように変更する。

```xml
<java.version>21</java.version>
```

<details>
<summary>keywords</summary>

java.version, pom.xml, Java21, Javaバージョン設定

</details>
