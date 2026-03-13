# ETL Mavenプラグイン

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/extension_components/etl/etl_maven_plugin.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/javax/persistence/Table.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/Csv.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/WorkItem.html)

## モジュール一覧

ETLのExtractフェーズで使用する、**Oracle SQL*Loader用のコントロールファイルを自動生成するMavenプラグイン**。Java Beansクラスを元にOracle SQL*Loader用コントロールファイルを生成できる。Oracle固有のプラグインであり、CSVフォーマット以外の形式には対応していない。

**モジュール**:
```xml
<plugin>
  <groupId>com.nablarch.etl</groupId>
  <artifactId>nablarch-etl-maven-plugin</artifactId>
</plugin>
```

> **補足**: 本プラグインは [etl](etl-etl.md) 機能に依存している。ETL機能のバージョンを統一するために、プラグインのバージョン番号をnablarch-bomのバージョン番号と一致させること。

バージョン設定例:
```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>com.nablarch.profile</groupId>
      <artifactId>nablarch-bom</artifactId>
      <version>5u13</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

```xml
<plugin>
  <groupId>com.nablarch.etl</groupId>
  <artifactId>nablarch-etl-maven-plugin</artifactId>
  <version>5u13</version>
</plugin>
```

<details>
<summary>keywords</summary>

nablarch-etl-maven-plugin, com.nablarch.etl, nablarch-bom, ETL Mavenプラグイン, バージョン管理, モジュール設定, CSVフォーマット, CSV以外非対応, 対応フォーマット, Oracle, SQL*Loader, コントロールファイル自動生成, Oracle固有, Extractフェーズ

</details>

## 使用方法: コントロールファイルを生成するための設定

Oracle SQL*Loader用のコントロールファイルを生成するための設定。指定したJava Beansクラスから以下の情報を取得する。

| 取得する情報 | 取得元 |
|---|---|
| ワークテーブル名 | `Table` のname属性 |
| 入力ファイルの文字コード | `Csv` のtype属性 |
| 入力ファイルのヘッダレコードの有無 | `Csv` のtype属性 |
| 入力ファイルの項目の囲み文字 | `Csv` のtype属性 |
| 入力ファイルのフィールドの区切り文字 | `Csv` のtype属性 |
| 入力ファイルのレコードの区切り文字 | `Csv` のtype属性 |
| 入力ファイルの項目名リスト | `Csv` のproperties属性 |

Java Beansクラスは `WorkItem` を継承すること。

```java
@Entity
@Table(name = "sample_work")
@Csv(
        type = CsvType.DEFAULT,
        properties = {"userId", "name"}
)
public class Sample extends WorkItem {
    private String userId;
    private String name;
}
```

pom.xml設定（`classes`にFQCNで指定、`outputPath`は出力先ディレクトリ。未指定時は`target/etl/ctrl-file`に出力）:

```xml
<plugin>
  <groupId>com.nablarch.etl</groupId>
  <artifactId>nablarch-etl-maven-plugin</artifactId>
  <version>1.0.0</version>
  <configuration>
    <classes>
      <param>sample.Bean1</param>
      <param>sample.Bean2</param>
    </classes>
    <outputPath>etl/ctrl-file</outputPath>
  </configuration>
</plugin>
```

<details>
<summary>keywords</summary>

WorkItem, nablarch.etl.WorkItem, Csv, nablarch.common.databind.csv.Csv, Table, javax.persistence.Table, @Entity, @Table, @Csv, CsvType, Oracle SQL*Loader, コントロールファイル生成, Java Beans設定, outputPath, classes, ワークテーブル名, 文字コード, ヘッダレコード, 囲み文字, 区切り文字

</details>

## 使用方法: コントロールファイルを生成する

`generate-ctrl-file`ゴールを実行することでOracle SQL*Loader用コントロールファイルが生成される。

```bat
mvn nablarch-etl:generate-ctrl-file
```

> **重要**: 本プラグインはJava Beansクラスのclassファイルからコントロールファイルを生成するため、プラグイン実行前に必ずcompileを実施すること。

<details>
<summary>keywords</summary>

generate-ctrl-file, mvn nablarch-etl:generate-ctrl-file, ゴール実行, compile, classファイル, コンパイル前提

</details>

## 使用方法: コンパイル時に自動的にコントロールファイルを生成する

コンパイル時に自動的に本プラグインを実行するように設定することで、Java Beansクラスの定義を修正するたびに手動で実行する手間を省くことができる。

pom.xmlへの設定例（phase: compile）:

```xml
<plugin>
  <groupId>com.nablarch.etl</groupId>
  <artifactId>nablarch-etl-maven-plugin</artifactId>
  <version>1.0.0</version>
  <configuration>
    <!-- 省略 -->
  </configuration>
  <executions>
    <execution>
      <id>generate-ctrl-file</id>
      <phase>compile</phase>
      <goals>
        <goal>generate-ctrl-file</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

<details>
<summary>keywords</summary>

コンパイル時自動実行, executions, phase compile, generate-ctrl-file, 自動実行設定, pom.xml executions

</details>
