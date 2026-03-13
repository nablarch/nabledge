# ワークフロー定義データ生成ツール

**公式ドキュメント**: [ワークフロー定義データ生成ツール](https://nablarch.github.io/docs/LATEST/doc/extension_components/workflow/tool/index.html)

## モジュール一覧

BPMN2.0準拠のワークフロー定義ファイル(xmlファイル)を読み込み、[ワークフロー関連テーブル](workflow-doc.md) 投入用CSVファイルを出力するMavenプラグイン。CSV出力時に [workflow](workflow-doc.md) で利用できるかのバリデーションも実施する。

**モジュール**:
```xml
<plugin>
  <groupId>com.nablarch.workflow</groupId>
  <artifactId>nablarch-workflow-tool</artifactId>
</plugin>
```

<details>
<summary>keywords</summary>

nablarch-workflow-tool, com.nablarch.workflow, ワークフロー定義データ生成ツール, BPMN, CSV生成, Mavenプラグイン

</details>

## プラグインに対する設定

本プラグインを使用するためには以下の設定値を指定する。

| プロパティ名 | 説明 |
|---|---|
| outputPath | CSVの出力先ディレクトリ |
| workflowBpmnDir | ワークフロー用のワークフロー定義ファイルの配置ディレクトリ。配下の拡張子`bpmn`ファイルが自動読み込みされCSV出力される |
| stateMachineBpmnDir | ステートマシン用のワークフロー定義ファイルの配置ディレクトリ。配下の拡張子`bpmn`ファイルが自動読み込みされCSV出力される |
| configurationFilePath | テーブル名やカラム名を定義したコンポーネント設定ファイルのパス |

設定例:
```xml
<plugin>
  <groupId>com.nablarch.workflow</groupId>
  <artifactId>nablarch-workflow-tool</artifactId>
  <version>1.1.0</version>
  <configuration>
    <outputPath>src/test/resources/data</outputPath>
    <configurationFilePath>src/design/workflow-tool.xml</configurationFilePath>
    <workflowBpmnDir>src/design/workflow</workflowBpmnDir>
    <stateMachineBpmnDir>src/design/statemachine</stateMachineBpmnDir>
  </configuration>
</plugin>
```

<details>
<summary>keywords</summary>

outputPath, workflowBpmnDir, stateMachineBpmnDir, configurationFilePath, プラグイン設定, 設定例

</details>

## プラグインを実行する

本プラグインのゴール `generate-csv` を実行することで、設定に従いCSVファイルが出力される。Mavenのビルドプロセス内に組み込むことで、ビルド時に自動的にCSVファイルが生成される。

```xml
<plugin>
  <groupId>com.nablarch.workflow</groupId>
  <artifactId>nablarch-workflow-tool</artifactId>
  <version>1.1.0</version>
  <executions>
    <execution>
      <id>generate-csv</id>
      <phase>generate-resources</phase>
      <goals>
        <goal>generate-csv</goal>
      </goals>
      <configuration>
        <!-- 設定値は省略 -->
      </configuration>
    </execution>
  </executions>
</plugin>
```

<details>
<summary>keywords</summary>

generate-csv, ゴール, generate-resources, Mavenビルド, CSV出力

</details>

## バリデーション内容

以下の内容でバリデーションを実施する:

- 想定している要素のみを使用しているか（プール、レーン、ユーザタスク(ワークフロー)、タスク(ステートマシン)、XORゲートウェイ、開始イベント、停止イベント、中断メッセージ境界イベント、シーケンスフロー）
- 遷移可能な要素となっているか
- 開始イベントから始まり停止イベントで終了できるか

バリデーションエラーは標準エラー出力に出力される:
```
[ERROR] sm1_ステートマシン_ver1_20170101.bpmn
[ERROR] 	境界イベントに遷移先が設定されていません。 id:manual_sinsa_message, name:null
[ERROR] wf1_ワークフロー_ver1_20170101.bpmn
[ERROR] 	ゲートウェイから伸びるシーケンスフローの場合、フロー進行条件は必須です。[条件]を設定してください。 id = [SequenceFlow_06] name = [確認OK]
[ERROR] 	サポート対象外の要素です。 id = [T001] name = [確認]
```

<details>
<summary>keywords</summary>

バリデーション, プール, レーン, ユーザタスク, XORゲートウェイ, 開始イベント, 停止イベント, シーケンスフロー, バリデーションエラー

</details>

## Java11で使用する場合の設定

> **重要**: 本プラグインをJava11で使用する場合は、Mavenのバージョンを3.6.1以上にする必要がある。

Java11で使用する場合、以下の依存関係をプラグインに追加する:
```xml
<plugin>
  <groupId>com.nablarch.workflow</groupId>
  <artifactId>nablarch-workflow-tool</artifactId>
  <version>1.1.0</version>
  <!-- 中略 -->
  <dependencies>
    <dependency>
      <groupId>com.sun.activation</groupId>
      <artifactId>javax.activation</artifactId>
      <version>1.2.0</version>
    </dependency>
    <dependency>
      <groupId>javax.xml.bind</groupId>
      <artifactId>jaxb-api</artifactId>
      <version>2.3.0</version>
    </dependency>
    <dependency>
      <groupId>com.sun.xml.bind</groupId>
      <artifactId>jaxb-core</artifactId>
      <version>2.3.0</version>
    </dependency>
    <dependency>
      <groupId>com.sun.xml.bind</groupId>
      <artifactId>jaxb-impl</artifactId>
      <version>2.3.0</version>
    </dependency>
  </dependencies>
</plugin>
```

<details>
<summary>keywords</summary>

Java11, JAXB, javax.xml.bind, jaxb-api, jaxb-core, jaxb-impl, javax.activation, Maven 3.6.1

</details>
