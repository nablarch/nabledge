# SLF4Jアダプタ

**目次**

* モジュール一覧
* SLF4Jアダプタを使用する

JavaのOSSは [SLF4J(外部サイト、英語)](https://www.slf4j.org/) を使用してログ出力しているモジュールが多く、
これらのモジュールを使用した場合にNablarchの [ログ出力機能](../../component/libraries/libraries-log.md#ログ出力) にログ出力を集約したい場合がある。
このケースに対応するため、SLF4JのAPIを経由してNablarchのログ出力機能でログ出力を行うアダプタを提供する。

## モジュール一覧

```xml
<!-- SLF4Jアダプタ -->
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>slf4j-nablarch-adaptor</artifactId>
</dependency>
```

> **Tip:**
> SLF4Jのバージョン1.7.25を使用してテストを行っている。
> バージョンを変更する場合は、プロジェクト側でテストを行い問題ないことを確認すること。

## SLF4Jアダプタを使用する

SLF4Jが実行時に必要なクラスを自動で検出するため、本アダプタはSLF4Jアダプタをプロジェクトの依存モジュールに追加するだけで使用できる。
ログ出力の設定はNablarchの [ログ出力機能](../../component/libraries/libraries-log.md#ログ出力) を参照すること。

```xml
<!-- SLF4Jアダプタ -->
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>slf4j-nablarch-adaptor</artifactId>
  <scope>runtime</scope>
</dependency>
```
