# 変数に値を設定するsetタグ

## setタグの属性と使用方法

:ref:`WebView_SetTag` の属性:

| 属性名 | 説明 |
|---|---|
| `var` | 変数名を指定 |
| `value` | 直接値を指定する場合 |
| `name` | スコープ上のオブジェクトを参照する場合 |
| `scope` | 変数を格納するスコープ（`request` または `page`）。未指定時はリクエストスコープ |
| `bySingleValue` | `false` を指定すると配列・コレクションをそのまま取得（デフォルト: `true` = 先頭要素のみ返す） |

- `scope`未指定時、変数はリクエストスコープに設定される。
- ページスコープ（`page`）は、共通UIコンポーネント作成時に他JSPの変数との名前衝突を防ぐ場合に使用する。
- `name`属性指定時、デフォルト（`bySingleValue=true`）では配列・コレクションの先頭要素のみ返す。共通UIコンポーネントで配列・コレクションをそのまま取得する場合は `bySingleValue=false` を指定する。

> **警告**: setタグはHTMLエスケープを実施しない。setタグで設定した変数を出力する場合は必ずwriteタグを使用すること。

```jsp
<n:set var="title" value="ユーザ情報登録" />
<head>
    <title><n:write name="title" /></title>
</head>
<body>
    <h1><n:write name="title" /></h1>
</body>
```

<details>
<summary>keywords</summary>

n:set, WebView_SetTag, var, value, name, scope, bySingleValue, setタグ, 変数設定, JSP変数, スコープ, ページスコープ, リクエストスコープ, HTMLエスケープ, n:write

</details>
