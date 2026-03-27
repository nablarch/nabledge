# 環境設定ファイル自動生成ツール

## 概要

本ツールは、下記のファイルからアプリケーションで使用する環境設定ファイル（`*.config`）を作成する。

- アプリケーション設定一覧表
- 業務設定一覧表

<details>
<summary>keywords</summary>

環境設定ファイル自動生成, ConfigGenerator, *.config, アプリケーション設定一覧表, 業務設定一覧表, 環境設定ファイル生成, ツール概要

</details>

## ツール配置場所

本ツールはチュートリアルプロジェクトの `tool/configgenerator` ディレクトリに配置されている。

| ファイル/ディレクトリ | 説明 |
|---|---|
| resources/nablarch/tool/configgenerator/configgen.xml | 本ツールのコンポーネント定義ファイル |
| resources/nablarch/tool/configgenerator/アプリケーション設定一覧表.xls | アプリケーション設定一覧表 |
| resources/nablarch/tool/configgenerator/app | 業務設定一覧表の配置場所 |
| configgen-build.xml | 本ツールを実行するためのAntビルドファイル |
| configgen.properties | Antビルドファイルのプロパティファイル（通常、変更の必要なし） |

<details>
<summary>keywords</summary>

tool/configgenerator, configgen.xml, アプリケーション設定一覧表.xls, app, configgen-build.xml, configgen.properties, ツール配置, ディレクトリ構成

</details>

## 入力元となる設計書に関する設定

**クラス**: `nablarch.tool.configgenerator.ConfigurationLoader`

設計書のレイアウトや文言を変更しない限り、変更の必要はない。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| keyColumnName | | "キー" | キーを記載したカラム名 |
| descColumnName | | "項目名" | 項目名を記載したカラム名 |
| prefixRowIndex | | 2 | プレフィックスを記載したセルの位置（行番号） |
| prefixColumnIndex | | 1 | プレフィックスを記載したセルの位置（列番号） |
| outputFilePathRowIndex | | 3 | ファイル出力先を記載したセルの位置（行番号） |
| outputFilePathColumnIndex | | 1 | ファイル出力先を記載したセルの位置（列番号） |
| headerRowIndex | | 6 | 見出し行の行番号 |

> **注意**: 行番号・列番号は0オリジンで記載する。

```xml
<component name="configurationLoader"
           class="nablarch.tool.configgenerator.ConfigurationLoader">
  <property name="keyColumnName" value="キー"/>
  <property name="descColumnName" value="項目名"/>
  <property name="prefixRowIndex" value="2"/>
  <property name="prefixColumnIndex" value="1"/>
  <property name="outputFilePathRowIndex" value="3"/>
  <property name="outputFilePathColumnIndex" value="1"/>
  <property name="headerRowIndex" value="6"/>
</component>
```

<details>
<summary>keywords</summary>

ConfigurationLoader, nablarch.tool.configgenerator.ConfigurationLoader, keyColumnName, descColumnName, prefixRowIndex, prefixColumnIndex, outputFilePathRowIndex, outputFilePathColumnIndex, headerRowIndex, 設計書設定, 入力元設定, 列名設定, 行番号設定

</details>

## ファイル生成に関する設定

**クラス**: `nablarch.tool.configgenerator.ConfigGenSettings`

デフォルト値が無い項目については、各プロジェクトにて設定を行う必要がある。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| lineSeparator | | CRLF | 出力ファイル改行（"CR","LF","CRLF"のいずれか） |
| outputEncoding | | UTF-8 | 出力ファイルのファイルエンコーディング |
| outputBaseDir | | ./work | 出力先ディレクトリ |
| systemSettingsFile | ○ | | アプリケーション設定一覧表のパス |
| appSettingsDir | ○ | | 業務設定一覧表の配置ディレクトリ |
| importFileName | ○ | | import用コンポーネント定義ファイルのファイル名 |
| excludeSheetNames | | "表紙", "変更履歴", "目次" | 読み込み除外シート名 |

```xml
<component name="configGenSettings"
           class="nablarch.tool.configgenerator.ConfigGenSettings">
  <property name="lineSeparator" value="CRLF"/>
  <property name="outputEncoding" value="UTF-8"/>
  <property name="outputBaseDir" value="./work/config/"/>
  <property name="systemSettingsFile"
            value="tool/configgenerator/resources/nablarch/tool/configgenerator/アプリケーション設定一覧表.xls" />
  <property name="appSettingsDir"
            value="tool/configgenerator/resources/nablarch/tool/configgenerator/app/"/>
  <property name="importFileName" value="importConfig.xml" />
  <property name="excludeSheetNames">
    <list>
      <value>表紙</value>
      <value>変更履歴</value>
      <value>目次</value>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

ConfigGenSettings, nablarch.tool.configgenerator.ConfigGenSettings, lineSeparator, outputEncoding, outputBaseDir, systemSettingsFile, appSettingsDir, importFileName, excludeSheetNames, ファイル生成設定, 出力ディレクトリ, 文字コード, 改行コード

</details>

## 「処理方式名」「環境名」を事前に定義して実行する場合

`configgen-build.xml` にtargetタグを追記し、generateマクロを起動する。

```xml
<target name="画面オンライン-本番環境"
        description="画面オンライン-本番環境の環境設定ファイルを生成する。"
        depends="clean">
  <generate processingScheme="画面オンライン"
            envName="本番環境"/>
</target>
```

<details>
<summary>keywords</summary>

configgen-build.xml, generateマクロ, Antビルド, 処理方式名, 環境名, 自動生成実行, 環境設定ファイル生成

</details>

## 対話形式で生成を実行する場合

以下のコマンドを実行する。

```bash
ant -f configgen-build.xml
```

標準入力から「処理方式名」「環境名」を入力する。

```bash
clean:

generate-interactive:
    [input] 処理方式名を入力して下さい。（例：画面オンライン）
画面オンライン 
    [input] 環境名を入力して下さい。（例：本番環境）
本番環境
＜中略＞

BUILD SUCCESSFUL
Total time: 18 seconds
```

ファイル生成に関する設定の出力ディレクトリにファイルが生成される。

<details>
<summary>keywords</summary>

configgen-build.xml, ant コマンド, 対話形式実行, 標準入力, インタラクティブ実行, 処理方式名入力, 環境名入力

</details>
