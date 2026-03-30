# 環境設定ファイル自動生成ツール

## 概要

アプリケーション設定一覧表と業務設定一覧表から、環境設定ファイル（*.config）を自動生成するツール。

<details>
<summary>keywords</summary>

環境設定ファイル自動生成, configファイル生成, アプリケーション設定一覧表, 業務設定一覧表

</details>

## 利用の準備

## 入力元となる設計書に関する設定

**クラス**: `nablarch.tool.configgenerator.ConfigurationLoader`

設計書のレイアウトや文言を変更しない限り、変更不要。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| keyColumnName | | "キー" | キーを記載したカラム名 |
| descColumnName | | "項目名" | 項目名を記載したカラム名 |
| prefixRowIndex | | 2 | プレフィックスを記載したセルの行番号（0オリジン） |
| prefixColumnIndex | | 1 | プレフィックスを記載したセルの列番号（0オリジン） |
| outputFilePathRowIndex | | 3 | ファイル出力先を記載したセルの行番号（0オリジン） |
| outputFilePathColumnIndex | | 1 | ファイル出力先を記載したセルの列番号（0オリジン） |
| headerRowIndex | | 6 | 見出し行の行番号（0オリジン） |

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

## ファイル生成に関する設定

**クラス**: `nablarch.tool.configgenerator.ConfigGenSettings`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| lineSeparator | | CRLF | 出力ファイル改行（"CR","LF","CRLF"のいずれか） |
| outputEncoding | | UTF-8 | 出力ファイルエンコーディング |
| outputBaseDir | | ./work | 出力先ディレクトリ |
| systemSettingsFile | ○ | | アプリケーション設定一覧表のパス |
| appSettingsDir | ○ | | 業務設定一覧表の配置ディレクトリ |
| importFileName | ○ | | import用コンポーネント定義ファイルのファイル名 |
| excludeSheetNames | | "表紙","変更履歴","目次" | 読み込み除外シート名 |

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

ConfigurationLoader, ConfigGenSettings, nablarch.tool.configgenerator.ConfigurationLoader, nablarch.tool.configgenerator.ConfigGenSettings, keyColumnName, descColumnName, prefixRowIndex, prefixColumnIndex, outputFilePathRowIndex, outputFilePathColumnIndex, headerRowIndex, lineSeparator, outputEncoding, outputBaseDir, systemSettingsFile, appSettingsDir, importFileName, excludeSheetNames, 設計書設定, ファイル生成設定

</details>

## 自動生成ツールの実行手順

## 処理方式名・環境名を事前定義して実行する場合

configgen-build.xmlにtargetタグを追記し、generateマクロを起動する。

```xml
<target name="画面オンライン-本番環境"
        description="画面オンライン-本番環境の環境設定ファイルを生成する。"
        depends="clean">
  <generate processingScheme="画面オンライン"
            envName="本番環境"/>
</target>
```

## 対話形式で実行する場合

```bash
ant -f configgen-build.xml
```

標準入力から「処理方式名」「環境名」を入力する。実行例：

```
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

生成されたファイルは `configGenSettings` の `outputBaseDir` に出力される。

<details>
<summary>keywords</summary>

configgen-build.xml, generateマクロ, ant実行, 対話形式実行, 環境設定ファイル生成手順, processingScheme, envName, BUILD SUCCESSFUL, 処理方式名を入力, 環境名を入力

</details>
