# リクエスト単体データ作成ツール インストールガイド

## 前提事項

本ツールの使用前提:
- Java・Mavenがインストール済みであること
- プロジェクトがMavenで管理されていること
- htmlファイルがブラウザに関連付けされていること
- ブラウザのプロキシ設定で、localhostが除外されていること

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

## 設定画面起動

EclipseにhttpDumpをHTMLファイルの外部エディタとして登録する: ウィンドウ(Window) → 設定(Preference) → 一般(General) → エディタ(Editors) → ファイルの関連付け(File Associations) → *.html を選択 → 追加(Add)ボタン押下。

## 外部プログラム選択

エディタ種別として「外部プログラム(External program)」ラジオボタンを選択し、参照(Browse)ボタンを押下する。

## 起動用バッチファイル（シェルスクリプト）選択

OSに応じてファイルを選択:
- Windows: `httpDump.bat`
- Linux: `httpDump.sh`

## HTMLファイルからの起動方法

Eclipseのパッケージエクスプローラ等でHTMLファイルを右クリック → 「httpDumpで開く」でツールを起動する。
