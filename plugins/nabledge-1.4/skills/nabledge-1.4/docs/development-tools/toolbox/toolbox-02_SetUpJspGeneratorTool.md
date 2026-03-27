# JSP自動生成ツール インストールガイド

## 前提事項

本ツールを使用する際、以下の前提事項を満たす必要がある。

- javaコマンドがパスに含まれていること

<details>
<summary>keywords</summary>

前提事項, javaコマンド, パス設定, インストール要件, 実行環境

</details>

## 提供方法・ツール構成

本ツールは、Nablarchのチュートリアルプロジェクトに同梱して提供する。

ツール構成（6ファイル）:

| ファイル名 | 説明 |
|---|---|
| jspGen.bat | 起動バッチファイル（Windows用） |
| jspGen.config | JSP自動生成ツールの設定ファイル |
| log.properties | ログ出力設定ファイル |
| nablarch-X.X.jar | Nablarch Application Framework のJARファイル（X.Xの部分はバージョン番号） |
| nablarch-tfw-X.X.jar | Nablarch Testing Framework のJARファイル（X.Xの部分はバージョン番号） |
| nablarch-toolbox-X.X.jar | Nablarch Toolbox のJARファイル（X.Xの部分はバージョン番号） |

各JARファイルへのクラスパスが設定された `jspGen.bat` がサンプルアプリケーションの `/Nablarch_sample/tool/jspgenerator/jspGen.bat` に配置されている。

<details>
<summary>keywords</summary>

提供方法, ツール構成, 同梱ファイル, jspGen.bat, jspGen.config, log.properties, nablarch-X.X.jar, nablarch-tfw-X.X.jar, nablarch-toolbox-X.X.jar, チュートリアルプロジェクト, JARファイル

</details>

## 設定画面起動

EclipseからJSP自動生成ツールを起動するための設定手順:

1. ツールバーから「ウィンドウ(Window)」→「設定(Preference)」を選択
2. 左ペインから「一般(General)」→「エディタ(Editors)」→「ファイルの関連付け(File Associations)」を選択
3. 右ペインから `*.html` を選択し、「追加(Add)」ボタンを押下

<details>
<summary>keywords</summary>

Eclipse設定, ファイルの関連付け, File Associations, JSP自動生成ツール設定, *.html, エディタ設定

</details>

## 外部プログラム選択

1. ラジオボタンから「外部プログラム(External program)」を選択
2. 「参照(Browse)」ボタンを押下して、起動用バッチファイルを選択する画面を開く

<details>
<summary>keywords</summary>

外部プログラム設定, Eclipse連携, エディタ外部プログラム登録, jspGen.bat登録

</details>

## 起動用バッチファイル選択

バッチファイル `jspGen.bat` を選択する。

Nablarch_sampleには、バッチファイルが `/Nablarch_sample/tool/jspgenerator/jspGen.bat` にあらかじめ配置されている。

<details>
<summary>keywords</summary>

jspGen.bat, バッチファイル選択, Nablarch_sample, 起動バッチ設定

</details>

## HTMLファイルからの起動方法

パッケージエクスプローラ等からHTMLファイルを右クリックし、「jspGenで開く」を選択することでツールを起動できる。

<details>
<summary>keywords</summary>

HTMLファイル起動, jspGenで開く, Eclipse右クリック起動, JSP自動生成実行

</details>

## 作成したファイルの表示

HTMLファイルからの起動実行により、HTMLファイルと同一ディレクトリにJSPファイルが生成される。

生成されたJSPファイルを確認するには、HTMLファイルと同一ディレクトリを右クリックし「フレッシュ(Refresh)」を選択する。

<details>
<summary>keywords</summary>

JSPファイル生成確認, Refresh, ファイル表示更新, JSP出力先

</details>
