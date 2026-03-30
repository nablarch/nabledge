# リクエスト単体データ作成ツール インストールガイド

## 前提事項

## 前提事項

本ツール使用時の必須条件:

- `java` コマンドがパスに含まれていること
- HTMLファイルがブラウザに関連付けされていること
- ブラウザのプロキシ設定で、`localhost` が除外されていること

<details>
<summary>keywords</summary>

インストール前提条件, javaコマンド, プロキシ設定, ブラウザ関連付け, 環境要件

</details>

## 提供方法

## 提供方法

Nablarchのサンプルアプリケーションに同梱して提供される。ツール構成:

| ファイル名 | 説明 |
|---|---|
| `httpDump.bat` | 起動バッチファイル（Windows用） |
| `nablarch-tfw-X.X.jar` | Nablarch Testing Framework のJARファイル（X.Xの部分はバージョン番号） |
| `poi-X.X.jar` | Apache POI のJARファイル（X.Xの部分はバージョン番号など） |
| `jetty.jar` | Jetty Server のJARファイル |
| `jetty-util.jar` | Jetty Utilities のJARファイル |
| `servlet-api.jar` | Servlet Specification 2.5 API のJARファイル |

各JARファイルへのクラスパスが設定された `httpDump.bat` の配置パス:

```bash
/test/tool/httpDump.bat
```

<details>
<summary>keywords</summary>

ツール構成ファイル, httpDump.bat, nablarch-tfw, 配置パス, JARファイル一覧

</details>

## Eclipseとの連携

## Eclipseとの連携

Eclipseから本ツールを起動するための設定手順:

1. ツールバーから ウィンドウ(Window) → 設定(Preference) → 一般(General) → エディタ(Editors) → ファイルの関連付け(File Associations) を開き、`*.html` を選択して追加(Add)ボタンを押下する
2. 外部プログラム(External program)のラジオボタンを選択し、参照(Browse)ボタンを押下する
3. Windowsの場合は `httpDump.bat`、Linuxの場合は `httpDump.sh` を選択する
4. パッケージエクスプローラ等からHTMLファイルを右クリックし、「httpDumpで開く」を選択するとツールが起動する

<details>
<summary>keywords</summary>

Eclipse連携, ファイル関連付け設定, 外部プログラム設定, HTMLファイル起動, httpDumpで開く

</details>
