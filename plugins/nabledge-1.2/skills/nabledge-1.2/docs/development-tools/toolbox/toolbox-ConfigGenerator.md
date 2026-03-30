# 環境設定ファイル自動生成ツール

## 概要

環境設定ファイル自動生成ツールは、以下の入力ファイルからアプリケーションで使用する環境設定ファイル（*.config）を生成する。

- アプリケーション設定一覧表
- 業務設定一覧表

<details>
<summary>keywords</summary>

環境設定ファイル生成, *.config, アプリケーション設定一覧表, 業務設定一覧表, 自動生成ツール

</details>

## 入力元となる設計書に関する設定

**クラス**: `nablarch.tool.configgenerator.ConfigurationLoader`

設計書のレイアウトや文言を変更しない限り、デフォルト値から変更不要。行番号・列番号は0オリジン。

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| keyColumnName | "キー" | キーを記載したカラム名 |
| descColumnName | "項目名" | 項目名を記載したカラム名 |
| prefixRowIndex | 2 | プレフィックスセルの行番号（0オリジン） |
| prefixColumnIndex | 1 | プレフィックスセルの列番号（0オリジン） |
| outputFilePathRowIndex | 3 | ファイル出力先セルの行番号（0オリジン） |
| outputFilePathColumnIndex | 1 | ファイル出力先セルの列番号（0オリジン） |
| headerRowIndex | 6 | 見出し行の行番号（0オリジン） |

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

ConfigurationLoader, nablarch.tool.configgenerator.ConfigurationLoader, keyColumnName, descColumnName, prefixRowIndex, prefixColumnIndex, outputFilePathRowIndex, outputFilePathColumnIndex, headerRowIndex, 設計書レイアウト設定, 列名設定

</details>

## ファイル生成に関する設定

**クラス**: `nablarch.tool.configgenerator.ConfigGenSettings`

`systemSettingsFile`、`appSettingsDir`、`importFileName` はデフォルト値なし（必須）。プロジェクトごとに設定が必要。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| lineSeparator | | CRLF | 改行コード（"CR"/"LF"/"CRLF"） |
| outputEncoding | | UTF-8 | 出力ファイルエンコーディング |
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

ConfigGenSettings, nablarch.tool.configgenerator.ConfigGenSettings, lineSeparator, outputEncoding, outputBaseDir, systemSettingsFile, appSettingsDir, importFileName, excludeSheetNames, 出力先ディレクトリ, ファイル生成設定

</details>

## 自動生成ツールの実行手順

## 「処理方式名」「環境名」を事前に定義して実行する場合

`configgen-build.xml` に `target` タグを追記し、`generate` マクロを起動する。

```xml
<target name="画面オンライン-本番環境"
        description="画面オンライン-本番環境の環境設定ファイルを生成する。"
        depends="clean">
  <generate processingScheme="画面オンライン"
            envName="本番環境"/>
</target>
```

## 対話形式で生成を実行する場合

```bash
ant -f configgen-build.xml
```

標準入力から「処理方式名」「環境名」を入力する。生成されたファイルは `ConfigGenSettings` の `outputBaseDir` に出力される。

<details>
<summary>keywords</summary>

configgen-build.xml, generateマクロ, ant, 対話形式実行, 処理方式名, 環境名, 実行手順

</details>
