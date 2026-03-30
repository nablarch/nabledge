# JSP自動生成ツール インストールガイド

## 前提事項

## 前提事項

- `java`コマンドがパスに含まれていること

<details>
<summary>keywords</summary>

JSP自動生成ツール, 前提条件, javaコマンド, PATH設定, インストール要件

</details>

## 提供方法

## 提供方法

Nablarchサンプルアプリケーションに同梱して提供される。

| ファイル名 | 説明 |
|---|---|
| jspGen.bat | 起動バッチファイル（Windows用） |
| jspGen.config | JSP自動生成ツールの設定ファイル |
| log.properties | ログ出力設定ファイル |
| nablarch-X.X.jar | Nablarch Application Framework のJARファイル |
| nablarch-tfw-X.X.jar | Nablarch Testing Framework のJARファイル |
| nablarch-toolbox-X.X.jar | Nablarch Toolbox のJARファイル |

`jspGen.bat` の配置パス: `/Nablarch_sample/tool/jspgenerator/jspGen.bat`

<details>
<summary>keywords</summary>

jspGen.bat, jspGen.config, log.properties, nablarch-toolbox, ツール構成, サンプルアプリケーション, nablarch-tfw, nablarch-X.X.jar

</details>

## Eclipseとの連携

## Eclipseとの連携

### 設定手順

1. ツールバーから「ウィンドウ(Window)→設定(Preference)」を選択
2. 左ペインから「一般(General)→エディタ(Editors)→ファイルの関連付け(File Associations)」を選択
3. 右ペインから `*.html` を選択し、「追加(Add)」ボタンを押下
4. 「外部プログラム(External program)」のラジオボタンを選択し、「参照(Browse)」ボタンを押下
5. `jspGen.bat`（`/Nablarch_sample/tool/jspgenerator/jspGen.bat`）を選択

### HTMLファイルからの起動方法

パッケージエクスプローラ等でHTMLファイルを右クリックし、「jspGenで開く」を選択するとツールが起動する。

### JSPファイルの確認

ツール実行後、HTMLファイルと同一ディレクトリにJSPファイルが生成される。ディレクトリを右クリックして「フレッシュ(Refresh)」を選択することで生成されたJSPファイルを確認できる。

<details>
<summary>keywords</summary>

Eclipse連携, ファイルの関連付け, 外部プログラム, HTMLファイル, JSP生成, パッケージエクスプローラ, File Associations

</details>
