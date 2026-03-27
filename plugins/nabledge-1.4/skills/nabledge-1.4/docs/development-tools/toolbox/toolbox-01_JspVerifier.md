# 業務画面JSP検証ツール

## 概要

JSPファイルに対して検証を行うツール。`verification_config.json`で検証内容の変更・追加が可能。

**実装済み**:
- 使用許可タグのみが利用されていることを検証
- JSPで必須となる構造が満たされていることを検証
- JSPで禁止されている構造を使用していないことを検証
- 各タグに指定されている属性がタグに定義されている属性であることを検証

**未実装**:
- 各タグの属性値がその属性のtypeにあった値となっていることの検証

<details>
<summary>keywords</summary>

JSP検証ツール, TagUsageVerifier, RegexpBasedVerifier, SelectorBasedVerifier, WrappingTagVerifier, TagAttributeVerifier, verification_config.json, JSP検証機能一覧

</details>

## Node.jsのインストール

本ツールはNode.jsに依存しているため、http://nodejs.org/ から使用する環境に合わせたインストーラをダウンロードしてインストールする。

<details>
<summary>keywords</summary>

Node.js, nodejs.org, インストーラ, 環境構築

</details>

## 環境変数の確認

プロキシ環境下で環境構築手順を実施する際には、以下の環境変数の値を確認すること。

| 環境変数名 | 値 |
|---|---|
| HTTP_PROXY | HTTP用プロキシサーバのURL |
| HTTPS_PROXY | HTTPS用プロキシサーバのURL |

<details>
<summary>keywords</summary>

HTTP_PROXY, HTTPS_PROXY, プロキシ環境, 環境変数

</details>

## 依存パッケージのインストール

本ツールのルートディレクトリ（`package.json`のあるディレクトリ）で`npm install`を実行する。コマンドが正常に完了し、`node_modules`ディレクトリが作成されたことを確認する。

> **警告**: `npm install`にはインターネット接続が必要。プロキシ環境では`http_proxy`と`https_proxy`環境変数（例: `http_proxy=http://proxy.example.com:8080`）の設定が必要。インターネット未接続環境への導入時は、接続環境で`node_modules`を作成してからコピーする。

<details>
<summary>keywords</summary>

npm install, node_modules, package.json, http_proxy, https_proxy, 依存パッケージ

</details>

## 正常に使用できることの確認

本ツールのルートディレクトリで`npm test`を実行し、すべてのテストが成功することを確認する。

<details>
<summary>keywords</summary>

npm test, テスト確認, 動作確認

</details>

## 環境依存設定値の修正

`verification_config.json`の`TagAttributeVerifier.directory`を、実際にタグファイルが配置されているディレクトリに修正する。

```json
"TagAttributeVerifier": {
  "directory": "C:\\nablarch\\workspace\\tutorial\\main\\web\\WEB-INF\\tags\\widget",
  "encoding": "utf-8"
}
```

<details>
<summary>keywords</summary>

TagAttributeVerifier, directory, verification_config.json, 環境依存設定

</details>

## ツールの使用方法

**batファイルでの実行**: `jsp_verifier.bat`にJSPファイルをDrag&Drop。

出力:
- 検証エラー0件: `Verification Succeeded.`
- 検証エラーあり: `Verification Failed!! / N violations are found. / Detected violations are dumped to violations-XXXXX.log.`

**コマンドラインからの実行**（ルートディレクトリで実行）:

```sh
node bin/jsp_verifier <検証対象JSPファイルパス（複数可）>
```

<details>
<summary>keywords</summary>

jsp_verifier.bat, jsp_verifier, JSP検証実行, コマンドライン実行, Drag&Drop

</details>

## 設定方法

設定ファイル: ルートディレクトリの`verification_config.json`。`verifiers`内に実施する検証クラス名を記載する。記載のない検証は実施されない。

```json
{
  "verifiers": {
    "TagUsageVerifier": {},
    "RegexpBasedVerifier": {},
    "SelectorBasedVerifier": {},
    "WrappingTagVerifier": {},
    "TagAttributeVerifier": {}
  }
}
```

使用可能な検証クラス:
- `TagUsageVerifier`: 使用可能タグ検証
- `RegexpBasedVerifier`: 正規表現検証
- `SelectorBasedVerifier`: DOMツリー検証
- `WrappingTagVerifier`: 親タグ検証
- `TagAttributeVerifier`: タグ属性検証

<details>
<summary>keywords</summary>

verification_config.json, TagUsageVerifier, RegexpBasedVerifier, SelectorBasedVerifier, WrappingTagVerifier, TagAttributeVerifier, 検証クラス設定

</details>

## 使用可能タグ検証

`TagUsageVerifier`が許可する使用可能タグ一覧:

- `n:form`, `n:set`, `n:write`, `n:ConfirmationPage`, `n:forConfirmationPage`, `n:forInputPage`, `n:param`, `n:hidden`
- `t:page_template`, `t:errorpage_template`
- `box:.*`, `button:.*`, `field:.*`, `link:.*`, `tab:.*`, `table:.*`, `column:.*`, `spec:.*`
- `c:if`, `jsp:attribute`
- `%--`, `%\@page`, `%\@taglib`

<details>
<summary>keywords</summary>

TagUsageVerifier, n:form, t:page_template, box:, button:, field:, 使用可能タグ一覧

</details>

## 正規表現検証

`RegexpBasedVerifier`のデフォルト検証（大文字・小文字区別なし）:

- `/>`: 自己終了エレメント。使用するとその要素以降の記述内容が描画されなくなるため禁止。

<details>
<summary>keywords</summary>

RegexpBasedVerifier, 自己終了エレメント, 禁止パターン, />

</details>

## DOMツリー検証

`SelectorBasedVerifier`のデフォルト禁止構造:

- `table:not([id])`: テーブルを複数表示する場合にIDが必須のため強制
- `table:not([listSearchInfoName])`: テーブルにはlistSearchInfoNameがないと結果件数が表示されないため強制

<details>
<summary>keywords</summary>

SelectorBasedVerifier, table, listSearchInfoName, 禁止構造, テーブルID

</details>

## 親タグ検証

`WrappingTagVerifier`のデフォルト必須構造:

- tableウィジェットはn:formで囲む必要がある
- buttonウィジェットはn:formで囲む必要がある
- 設計書ビューで画面項目定義に表示されるウィジェットはspec:layoutで囲む必要がある

<details>
<summary>keywords</summary>

WrappingTagVerifier, n:form, spec:layout, 必須構造, ラッピングタグ

</details>

## タグ属性検証

`TagAttributeVerifier`の検証: JSPで使用されているタグの属性が、実際にタグに定義されている属性であることを検証する。対象タグは`TagAttributeVerifier.directory`（デフォルト: `C:\nablarch\workspace\tutorial\main\web\WEB-INF\tags\widget`）配下のtagファイル。

<details>
<summary>keywords</summary>

TagAttributeVerifier, タグ属性検証, directory, tagファイル

</details>
