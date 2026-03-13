# SLF4Jアダプタ

**公式ドキュメント**: [SLF4Jアダプタ](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/slf4j_adaptor.html)

## SLF4Jアダプタの概要

JavaのOSSはSLF4Jを使用してログ出力しているモジュールが多く、これらのモジュールを使用した場合にNablarchのログ出力機能にログ出力を集約したい場合がある。このケースに対応するため、SLF4JのAPIを経由してNablarchのログ出力機能でログ出力を行うアダプタを提供する。

<details>
<summary>keywords</summary>

SLF4Jアダプタ 用途, SLF4J ログ集約, Nablarch ログ出力機能 SLF4J, JavaのOSS ログ, いつ使うか

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>slf4j-nablarch-adaptor</artifactId>
</dependency>
```

> **補足**: SLF4Jのバージョン1.7.25を使用してテスト済み。バージョンを変更する場合は、プロジェクト側でテストを行い問題ないことを確認すること。

<details>
<summary>keywords</summary>

slf4j-nablarch-adaptor, com.nablarch.integration, SLF4Jアダプタ, モジュール依存関係, SLF4Jバージョン1.7.25

</details>

## SLF4Jアダプタを使用する

SLF4Jが実行時に必要なクラスを自動で検出するため、依存モジュールに追加するだけで使用できる。ログ出力の設定はNablarchのログ出力機能を参照。

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>slf4j-nablarch-adaptor</artifactId>
  <scope>runtime</scope>
</dependency>
```

<details>
<summary>keywords</summary>

slf4j-nablarch-adaptor, SLF4Jアダプタ設定, ログ出力集約, ランタイム依存関係, runtime scope

</details>
