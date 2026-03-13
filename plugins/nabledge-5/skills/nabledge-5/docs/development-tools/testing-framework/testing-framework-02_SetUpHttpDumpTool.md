# リクエスト単体データ作成ツール インストールガイド

**公式ドキュメント**: [リクエスト単体データ作成ツール インストールガイド](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/01_HttpDumpTool/02_SetUpHttpDumpTool.html)

## 前提条件・インストール・設定画面起動

## 前提条件

- Java、Mavenがインストール済みであること
- プロジェクトがMavenで管理されていること
- HTMLファイルがブラウザに関連付けされていること
- ブラウザのプロキシ設定でlocalhostが除外されていること

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing</artifactId>
  <scope>test</scope>
</dependency>
<!-- Java 8 以前 -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing-jetty6</artifactId>
  <scope>test</scope>
</dependency>
<!-- Java 11 以降 -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing-jetty9</artifactId>
  <scope>test</scope>
</dependency>
```

jarダウンロードコマンド: `mvn dependency:copy-dependencies -DoutputDirectory=lib`

`httpDump.bat` をpom.xmlと同じディレクトリに配置する。

## 設定画面起動手順

ツールバー: ウィンドウ(Window) → 設定(Preferences) → 一般(General) → エディタ(Editors) → ファイルの関連付け(File Associations) → 右ペインで`*.html`を選択 → 追加(Add)ボタン押下

<details>
<summary>keywords</summary>

nablarch-testing, nablarch-testing-jetty6, nablarch-testing-jetty9, インストール前提条件, Maven依存関係, Eclipseファイル関連付け設定, httpDump

</details>

## 外部プログラム選択

ラジオボタンから外部プログラム(External program)を選択し、参照(Browse)ボタンを押下する。

<details>
<summary>keywords</summary>

外部プログラム選択, Eclipse設定, エディタ設定, httpDump連携

</details>

## 起動用バッチファイル（シェルスクリプト）選択

OSに応じて以下のファイルを選択する。

- Windows: httpDump.bat
- Linux: httpDump.sh

<details>
<summary>keywords</summary>

httpDump.bat, httpDump.sh, バッチファイル, シェルスクリプト, Windows, Linux

</details>

## HTMLファイルからの起動方法

EclipseのパッケージエクスプローラからHTMLファイルを右クリックし、「httpDumpで開く」を選択するとツールが起動する。

<details>
<summary>keywords</summary>

HTMLファイル起動, パッケージエクスプローラ, httpDump起動方法, Eclipse右クリック

</details>
