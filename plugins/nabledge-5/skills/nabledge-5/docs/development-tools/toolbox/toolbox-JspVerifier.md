# 業務画面JSP検証ツール

**公式ドキュメント**: [業務画面JSP検証ツール](https://nablarch.github.io/docs/LATEST/doc/development_tools/toolbox/JspVerifier/JspVerifier.html)

## 概要

JSPファイルに対して以下の検証を行うツール。検証内容は設定ファイルで変更・追加可能。

**実装済み**:
- 使用許可タグのみが使用されていること
- 必須構造が満たされていること
- 禁止構造を使用していないこと
- 各タグの属性がタグに定義済みの属性であること

**未実装**:
- 各タグの属性値が、その属性のtypeにあった値であること

<details>
<summary>keywords</summary>

JSP検証ツール, 使用可能タグ検証, 必須構造検証, 禁止構造検証, タグ属性検証, 業務画面JSP

</details>

## 初期環境構築

## Node.jsのインストール

[Node.js](https://nodejs.org/en) をインストールする。

## 環境変数（プロキシ環境）

| 環境変数名 | 値 |
|---|---|
| HTTP_PROXY | HTTP用プロキシサーバのURL |
| HTTPS_PROXY | HTTPS用プロキシサーバのURL |

## 依存パッケージのインストール

ルートディレクトリ（`package.json`のあるディレクトリ）で実行:

```
npm install
```

実行後、`node_modules`ディレクトリが作成されることを確認。

> **重要**: インターネット接続が必要。プロキシ環境では以下の環境変数を設定すること:
> - `http_proxy=http://proxy.example.com:8080`
> - `https_proxy=http://proxy.example.com:8080`
>
> オフライン環境へのインストール: インターネット接続環境で`npm install`を実行後、生成された`node_modules`ディレクトリを対象環境のルートディレクトリにコピーする。

## 動作確認

ルートディレクトリで`npm test`を実行し、すべてのテストが成功することを確認。

## 環境依存設定値の修正

`verification_config.json`の`TagAttributeVerifier.directory`をタグファイルの実際のディレクトリに修正:

```json
{
  "TagAttributeVerifier": {
    "directory": "C:\\nablarch\\workspace\\tutorial\\main\\web\\WEB-INF\\tags\\widget",
    "encoding": "utf-8"
  }
}
```

<details>
<summary>keywords</summary>

Node.js, npm install, npm test, verification_config.json, HTTP_PROXY, HTTPS_PROXY, http_proxy, https_proxy, TagAttributeVerifier, 依存パッケージ, プロキシ環境

</details>

## ツールの使用方法

## batファイルでの実行

`jsp_verifier.bat`に検証対象のJSPファイルをDrag&Dropして実行。

## コマンドラインからの実行

ルートディレクトリで実行:

```sh
node bin/jsp_verifier <検証対象JSPファイルパス（複数可）>
```

## 出力内容

- エラー0件: `Verification Succeeded.`
- エラーあり: `Verification Failed!!` + エラー件数 + ログファイル名（例: `violations-1390366626297.log`）

<details>
<summary>keywords</summary>

jsp_verifier.bat, Drag&Drop, node bin/jsp_verifier, Verification Succeeded, Verification Failed, コマンドライン実行, violations.log

</details>

## 設定方法

設定ファイルは`verification_config.json`（ルートディレクトリ）。`verifiers`セクションに実施する検証を列挙する。定義されていない検証は実施されない。

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

> **重要**: JSONファイルにはコメントを記載できない。

<details>
<summary>keywords</summary>

verification_config.json, verifiers, TagUsageVerifier, RegexpBasedVerifier, SelectorBasedVerifier, WrappingTagVerifier, TagAttributeVerifier, 設定ファイル

</details>

## 使用可能タグ検証

`TagUsageVerifier`: 以下の許可タグのみ使用可能。

- `n:form`, `n:set`, `n:write`, `n:ConfirmationPage`, `n:forConfirmationPage`, `n:forInputPage`, `n:param`, `n:hidden`
- `t:page_template`, `t:errorpage_template`
- `box:.*`, `button:.*`, `field:.*`, `link:.*`, `tab:.*`, `table:.*`, `column:.*`, `spec:.*`
- `c:if`, `jsp:attribute`
- `%--`, `%@page`, `%@taglib`

<details>
<summary>keywords</summary>

TagUsageVerifier, 使用可能タグ, n:form, n:write, n:hidden, button, table, spec, 許可タグ一覧

</details>

## 正規表現検証

`RegexpBasedVerifier`: 以下の正規表現にマッチする文字列が存在しないこと（大文字・小文字区別なし）。

- `/>` — 自己終了エレメント。使用するとその要素以降の記述内容が描画されなくなるため禁止。

<details>
<summary>keywords</summary>

RegexpBasedVerifier, 正規表現検証, 自己終了エレメント, />, 禁止パターン

</details>

## DOMツリー検証

`SelectorBasedVerifier`: 以下の禁止構造を使用しないこと。

- `table:not([id])` — テーブルを複数表示する場合にIDが必須となるため、すべてのテーブルにIDを付与すること。
- `table:not([listSearchInfoName])` — `listSearchInfoName`がないと結果件数が表示されないため、すべてのテーブルに`listSearchInfoName`を付与すること。

<details>
<summary>keywords</summary>

SelectorBasedVerifier, DOMツリー検証, table id, listSearchInfoName, 禁止構造

</details>

## 親タグ検証

`WrappingTagVerifier`: 以下の必須構造が満たされていること。

- `table`ウィジェットは`n:form`で囲む必要がある。
- `button`ウィジェットは`n:form`で囲む必要がある。
- 設計書ビューで画面項目定義に表示されるウィジェットは`spec:layout`で囲む必要がある。

<details>
<summary>keywords</summary>

WrappingTagVerifier, 親タグ検証, n:form, spec:layout, 必須構造, 囲みタグ

</details>

## タグ属性検証

`TagAttributeVerifier`: JSPで使用されているタグの属性が、タグファイルに実際に定義されている属性であること。

対象タグファイルは`verification_config.json`の`TagAttributeVerifier.directory`で指定したディレクトリ配下に格納されているtagファイル。

<details>
<summary>keywords</summary>

TagAttributeVerifier, タグ属性検証, tagファイル, 属性定義, directory, encoding

</details>
