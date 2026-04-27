# 環境設定ファイル自動生成ツール

## 概要

本ツールは、下記のファイルからアプリケーションで使用する環境設定ファイル（*.config）作成する。

* アプリケーション設定一覧表
* 業務設定一覧表

## 利用の準備

自動生成ツールの設定ファイルに、利用に必要な設定を記述する。

設定ファイルとその設定内容は下記の通り。

### 入力元となる設計書に関する設定

入力元となる設計書に関する設定を行う。設計書のレイアウトや文言を変更しない限り、
変更の必要はない。

**コンポーネント : nablarch.tool.configgenerator.ConfigurationLoader**

| キー名 | 設定内容 | デフォルト値 |
|---|---|---|
| keyColumnName | キーを記載したカラム名 | "キー" |
| descColumnName | 項目名を記載したカラム名 | "項目名" |
| prefixRowIndex | プレフィックスを記載したセルの位置（行番号） [1] | 2 |
| prefixColumnIndex | プレフィックスを記載したセルの位置（列番号） [1] | 1 |
| outputFilePathRowIndex | ファイル出力先を記載したセルの位置（行番号） [1] | 3 |
| outputFilePathColumnIndex | ファイル出力先を記載したセルの位置（列番号） [1] | 1 |
| headerRowIndex | 見出し行の行番号  [1] | 6 |

0オリジンで記載する。

設定例を以下に示す。

```xml
<component name="configurationLoader"
           class="nablarch.tool.configgenerator.ConfigurationLoader">
  <!-- キーを記載したカラム名 -->
  <property name="keyColumnName" value="キー"/>
  <!-- 項目名を記載したカラム名 -->
  <property name="descColumnName" value="項目名"/>
  <!-- プレフィックスを記載したセルの位置 -->
  <property name="prefixRowIndex" value="2"/>
  <property name="prefixColumnIndex" value="1"/>
  <!-- ファイル出力先を記載したセルの位置 -->
  <property name="outputFilePathRowIndex" value="3"/>
  <property name="outputFilePathColumnIndex" value="1"/>
  <!-- 見出し行の行番号 -->
  <property name="headerRowIndex" value="6"/>
</component>
```

### ファイル生成に関する設定

ファイル生成に関する設定を行う。
デフォルト値が無い項目については、各プロジェクトにて設定を行う必要がある。

**コンポーネント : nablarch.tool.configgenerator.ConfigGenSettings**

| キー名 | 設定内容 | デフォルト値 |
|---|---|---|
| lineSeparator | 出力ファイル改行（"CR","LF","CRLF"のいずれか） | CRLF |
| outputEncoding | 出力ファイルのファイルエンコーディング | UTF-8 |
| outputBaseDir | 出力先ディレクトリ | ./work |
| systemSettingsFile(必須) | アプリケーション設定一覧表のパス | 無し |
| appSettingsDir(必須) | 業務設定一覧表の配置ディレクトリ | 無し |
| importFileName(必須) | import用コンポーネント定義ファイルのファイル名 | 無し |
| excludeSheetNames | 読み込み除外シート名 | "表紙", "変更履歴", "目次" |

設定例を以下に示す。

```xml
<component name="configGenSettings"
           class="nablarch.tool.configgenerator.ConfigGenSettings">
  <!-- 改行コード -->
  <property name="lineSeparator" value="CRLF"/>
  <!-- 出力ファイルの文字コード -->
  <property name="outputEncoding" value="UTF-8"/>
  <!-- 出力先ディレクトリ -->
  <property name="outputBaseDir" value="./work/config/"/>
  <!-- アプリケーション設定一覧表のパス -->
  <property name="systemSettingsFile"
            value="tool/configgenerator/resources/nablarch/tool/configgenerator/アプリケーション設定一覧表.xls" />
  <!-- 業務設定一覧表の配置ディレクトリ -->
  <property name="appSettingsDir"
            value="tool/configgenerator/resources/nablarch/tool/configgenerator/app/"/>
  <!-- import用コンポーネント定義ファイルのファイル名-->
  <property name="importFileName" value="importConfig.xml" />
  <!-- 読み込み除外シート名 -->
  <property name="excludeSheetNames">
    <list>
      <value>表紙</value>
      <value>変更履歴</value>
      <value>目次</value>
    </list>
  </property>
</component>
```

## 自動生成ツールの実行手順

### 「処理方式名」「環境名」を事前に定義して実行する場合

configgen-build.xmlにtargetタグを追記し、generateマクロを起動する。
処理方式名「画面オンライン」、環境名「本番環境」の例を以下に示す。

```xml
<target name="画面オンライン-本番環境"
        description="画面オンライン-本番環境の環境設定ファイルを生成する。"
        depends="clean">
  <generate processingScheme="画面オンライン"
            envName="本番環境"/>
</target>
```

### 対話形式で生成を実行する場合

以下のコマンドを投入する。

```bash
ant -f configgen-build.xml
```

標準入力から「処理方式名」「環境名」を入力する。
以下に実行例を示す。

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

 ファイル生成に関する設定 の出力ディレクトリにファイルが生成される。
