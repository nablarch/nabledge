# リクエスト単体データ作成ツール インストールガイド

**公式ドキュメント**: [リクエスト単体データ作成ツール インストールガイド](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/01_HttpDumpTool/02_SetUpHttpDumpTool.html)

## 前提事項

本ツールの使用前提:
- Java・Mavenがインストール済みであること
- プロジェクトがMavenで管理されていること
- htmlファイルがブラウザに関連付けされていること
- ブラウザのプロキシ設定で、localhostが除外されていること

<details>
<summary>keywords</summary>

HttpDumpツール前提条件, Java Maven インストール要件, プロキシ設定 localhost除外, Mavenプロジェクト要件, ブラウザ関連付け

</details>

## 提供方法

提供JAR: `nablarch-testing-XXX.jar`、`nablarch-testing-jetty12-XXX.jar`

pom.xmlのdependencies要素以下の記述があることを確認する:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing</artifactId>
  <scope>test</scope>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing-jetty12</artifactId>
  <scope>test</scope>
</dependency>
```

JAR取得コマンド:
```text
mvn dependency:copy-dependencies -DoutputDirectory=lib
```

`httpDump.bat` をpom.xmlと同じディレクトリに配置する。

<details>
<summary>keywords</summary>

nablarch-testing, nablarch-testing-jetty12, Maven依存関係, mvn dependency:copy-dependencies, httpDump.bat, JAR取得

</details>

## 設定画面起動

EclipseにhttpDumpをHTMLファイルの外部エディタとして登録する: ウィンドウ(Window) → 設定(Preference) → 一般(General) → エディタ(Editors) → ファイルの関連付け(File Associations) → *.html を選択 → 追加(Add)ボタン押下。

<details>
<summary>keywords</summary>

Eclipse設定, ファイルの関連付け, 外部エディタ登録, *.html, Eclipse Preference

</details>

## 外部プログラム選択

エディタ種別として「外部プログラム(External program)」ラジオボタンを選択し、参照(Browse)ボタンを押下する。

<details>
<summary>keywords</summary>

外部プログラム設定, Eclipse エディタ選択, External program, Browse

</details>

## 起動用バッチファイル（シェルスクリプト）選択

OSに応じてファイルを選択:
- Windows: `httpDump.bat`
- Linux: `httpDump.sh`

<details>
<summary>keywords</summary>

httpDump.bat, httpDump.sh, Windows Linux OS別選択, バッチファイル指定

</details>

## HTMLファイルからの起動方法

Eclipseのパッケージエクスプローラ等でHTMLファイルを右クリック → 「httpDumpで開く」でツールを起動する。

<details>
<summary>keywords</summary>

HTMLファイル起動, Eclipse パッケージエクスプローラ, httpDumpで開く, 右クリック起動

</details>
