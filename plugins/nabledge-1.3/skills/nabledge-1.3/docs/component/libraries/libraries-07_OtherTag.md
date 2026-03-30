# 変数に値を設定するsetタグ

## 変数に値を設定するsetタグ

`n:set`タグ（:ref:`WebView_SetTag`）で変数に値を設定する。

**属性**:
- `var`: 変数名を指定
- `value`: 直接値を指定する場合
- `name`: リクエストスコープなどスコープ上のオブジェクトを参照する場合
- `scope`: 変数を格納するスコープ（`request` または `page`）。未指定時はリクエストスコープに設定される
- `bySingleValue`: `name`属性指定時にデフォルト（`true`）で単一値として取得。デフォルト時、`name`属性に対応する値が配列やコレクションの場合は**先頭の要素を返す**。配列・コレクションをそのまま取得したい場合は`false`を指定

**scope属性の使い分け**:
- `request`（デフォルト）: 通常のケース
- `page`: 共通利用UIパーツで他JSPの変数との名前衝突を防ぎたい場合

```jsp
<n:set var="title" value="ユーザ情報登録" />
<head>
    <title><n:write name="title" /></title>
</head>
<body>
    <h1><n:write name="title" /></h1>
</body>
```

> **警告**: setタグはHTMLエスケープ処理を実施しない。setタグで設定した変数を出力する場合はwriteタグを使用すること。

<details>
<summary>keywords</summary>

n:set, n:write, WebView_SetTag, var属性, value属性, name属性, scope属性, bySingleValue属性, JSP変数設定, スコープ指定, ページスコープ, リクエストスコープ, HTMLエスケープ, 配列・コレクション取得

</details>
