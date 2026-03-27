# リクエスト単体データ作成ツール インストールガイド

## 前提事項

本ツールを使用する際、以下の前提事項を満たす必要がある。

- javaコマンドがパスに含まれていること
- htmlファイルがブラウザに関連付けされていること
- ブラウザのプロキシ設定で、localhostが除外されていること

<details>
<summary>keywords</summary>

インストール前提, javaコマンド PATH, htmlファイル ブラウザ関連付け, プロキシ設定 localhost除外, httpDumpツール 動作要件

</details>

## 提供方法

本ツールは、Nablarchのサンプルアプリケーションに同梱して提供する。

ツール構成ファイル:

| ファイル名 | 説明 |
|---|---|
| httpDump.bat | 起動バッチファイル（Windows用） |
| nablarch-tfw-X.X.jar | Nablarch Testing Framework のJARファイル（X.Xはバージョン番号） |
| poi-X.X.jar | Apache POI のJARファイル（X.Xはバージョン番号など） |
| jetty.jar | Jetty Server のJARファイル |
| jetty-util.jar | Jetty Utilities のJARファイル |
| servlet-api.jar | Servlet Specification 2.5 API のJARファイル |

各JARファイルへのクラスパスが設定されたhttpDump.batはサンプルアプリケーションの以下のパスに配置されている。

```
/test/tool/httpDump.bat
```

<details>
<summary>keywords</summary>

httpDumpツール 構成ファイル, サンプルアプリケーション 同梱, httpDump.bat, nablarch-tfw jar, /test/tool/httpDump.bat, poi-X.X.jar Apache POI, jetty.jar Jetty Server, jetty-util.jar Jetty Utilities, servlet-api.jar Servlet API

</details>

## 設定画面起動

1. ツールバーから ウィンドウ(Window) → 設定(Preference) を選択
2. 左ペインから 一般(General) → エディタ(Editors) → ファイルの関連付け(File Associations) を選択
3. 右ペインから `*.html` を選択し、追加(Add)ボタンを押下

<details>
<summary>keywords</summary>

Eclipse設定画面, ファイル関連付け, httpDumpツール, *.html, Eclipse連携設定

</details>

## 外部プログラム選択

1. ラジオボタンから外部プログラム(External program)を選択
2. 参照(Browse)ボタンを押下する

<details>
<summary>keywords</summary>

外部プログラム設定, エディタ選択, Eclipse外部プログラム, httpDump起動設定

</details>

## 起動用バッチファイル（シェルスクリプト）選択

- Windows: バッチファイル `httpDump.bat` を選択
- Linux: シェルスクリプト `httpDump.sh` を選択

<details>
<summary>keywords</summary>

httpDump.bat, httpDump.sh, Windows設定, Linux設定, バッチファイル選択

</details>

## HTMLファイルからの起動方法

Eclipseのパッケージエクスプローラ等からHTMLファイルを右クリックし、httpDumpで開くとツールが起動する。

<details>
<summary>keywords</summary>

HTMLファイル起動, httpDumpで開く, パッケージエクスプローラ, ツール起動方法

</details>
