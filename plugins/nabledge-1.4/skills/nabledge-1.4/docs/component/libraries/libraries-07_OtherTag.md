# 変数に値を設定するsetタグ

## setタグの使い方

:ref:`WebView_SetTag` は変数に値を設定するタグ。

| 属性 | 説明 |
|---|---|
| var | 変数名を指定 |
| value | 直接値を指定 |
| name | リクエストスコープなどスコープ上のオブジェクトを参照 |
| scope | 変数を格納するスコープ。`request`または`page`。デフォルトは`request` |
| bySingleValue | `false`を指定すると配列やコレクションをそのまま取得可。デフォルト（`true`）は単一値取得で、配列・コレクションの場合は先頭要素を返す |

- ページスコープ（`scope="page"`）は、共通利用されるUI部品で他JSPの変数とのバッティングを防ぐ場合に使用する。
- `bySingleValue="false"`は、共通利用されるUI部品で配列やコレクションをそのまま取得したい場合に使用する。

使用例（画面タイトルの設定）:

```jsp
<n:set var="title" value="ユーザ情報登録" />
<head>
    <title><n:write name="title" /></title>
</head>
<body>
    <h1><n:write name="title" /></h1>
</body>
```

> **警告**: setタグはHTMLエスケープ処理を実施しないため、setタグで設定した変数を出力する場合はwriteタグを使用すること。

<details>
<summary>keywords</summary>

WebView_SetTag, setタグ, var属性, value属性, name属性, scope属性, bySingleValue属性, 変数設定, ページスコープ, リクエストスコープ, HTMLエスケープ, 配列コレクション取得

</details>
