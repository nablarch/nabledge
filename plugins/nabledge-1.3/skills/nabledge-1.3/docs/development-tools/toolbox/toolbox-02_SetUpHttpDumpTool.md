# リクエスト単体データ作成ツール インストールガイド

## 前提事項

## 前提事項

本ツールを使用する際の必須要件:

- `java`コマンドがパスに含まれていること
- HTMLファイルがブラウザに関連付けされていること
- ブラウザのプロキシ設定で、localhostが除外されていること

<details>
<summary>keywords</summary>

インストール前提条件, javaコマンド設定, ブラウザプロキシ設定, localhost除外, HTMLファイル関連付け

</details>

## 提供方法

## 提供方法

Nablarchのサンプルアプリケーションに同梱して提供。ツール構成ファイル:

| ファイル名 | 説明 |
|---|---|
| httpDump.bat | 起動バッチファイル（Windows用） |
| nablarch-tfw-X.X.jar | Nablarch Testing Framework のJARファイル（X.Xはバージョン番号） |
| poi-X.X.jar | Apache POI のJARファイル（X.Xはバージョン番号） |
| jetty.jar | Jetty Server のJARファイル |
| jetty-util.jar | Jetty Utilities のJARファイル |
| servlet-api.jar | Servlet Specification 2.5 API のJARファイル |

`httpDump.bat`の配置パス:

```bash
/test/tool/httpDump.bat
```

<details>
<summary>keywords</summary>

ツール構成ファイル, httpDump.bat, nablarch-tfw, インストール, 配置パス

</details>

## Eclipseとの連携

## Eclipseとの連携

Eclipseから本ツールを起動するための設定手順:

1. ツールバー → ウィンドウ(Window) → 設定(Preference) を選択
2. 左ペイン: 一般(General) → エディタ(Editors) → ファイルの関連付け(File Associations) を選択
3. 右ペインから `*.html` を選択し、追加(Add)ボタンを押下
4. ラジオボタンから外部プログラム(External program)を選択し、参照(Browse)ボタンを押下
5. Windowsの場合は `httpDump.bat`、Linuxの場合は `httpDump.sh` を選択

**HTMLファイルからの起動方法**: Eclipseのパッケージエクスプローラ等からHTMLファイルを右クリックし、「httpDumpで開く」を選択することでツールを起動できる。

<details>
<summary>keywords</summary>

Eclipse連携, ファイル関連付け設定, 外部プログラム設定, httpDump起動, HTMLファイル起動方法, 設定画面起動, バッチファイル選択

</details>
