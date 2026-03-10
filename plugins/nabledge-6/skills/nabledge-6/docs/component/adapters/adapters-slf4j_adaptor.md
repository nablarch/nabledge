# SLF4Jアダプタ

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>slf4j-nablarch-adaptor</artifactId>
</dependency>
```

> **補足**: SLF4J 2.0.11でテスト済み。バージョンを変更する場合はプロジェクト側でテストを行うこと。SLF4J 2.0.0以降はロギング実装の検索方法が変わっているため、互換性のない1.7系バージョンを使用した場合は以下のログが出力され、以降のログ出力が行われない:
```
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
```

## SLF4Jアダプタを使用する

SLF4Jが実行時に必要なクラスを自動で検出するため、依存モジュールに追加するだけで使用可能。

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>slf4j-nablarch-adaptor</artifactId>
  <scope>runtime</scope>
</dependency>
```
