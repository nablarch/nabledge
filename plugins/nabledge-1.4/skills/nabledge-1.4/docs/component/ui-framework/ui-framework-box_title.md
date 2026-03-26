# タイトル用表示領域ウィジェット

## コードサンプル

```jsp
<box:title>
  タイトル定義
</box:title>
<box:content>
  コンテンツとタイトルを区別することで
  PJのポリシーの適用を簡易にする。
</box:content>
```

<details>
<summary>keywords</summary>

box:title, box:content, タイトル用表示領域, JSPウィジェット, コードサンプル

</details>

## 仕様

定義情報を持ったブロックで囲んだボディ部の内容を出力する。ローカル動作とサーバ動作の挙動は同じ。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| プロパティ名 | 内容 | タイプ | サーバ | ローカル |
|---|---|---|---|---|
| cssClass | 定義領域のclass属性を指定する | 文字列 | ○ | ○ |
| id | 定義領域のid属性を指定する | 文字列 | ○ | ○ |

<details>
<summary>keywords</summary>

cssClass, id, 属性値一覧, タイトルウィジェット仕様, class属性, id属性, ローカル動作, サーバ動作

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/box/title.tag | [box_title](ui-framework-box_title.md) の実体となるタグファイル |
| /js/jsp/taglib/box.js | [box_title](ui-framework-box_title.md) をローカルレンダリングするスタブファイル |

<details>
<summary>keywords</summary>

title.tag, box.js, タグファイル, ローカルレンダリング, スタブファイル, 部品一覧

</details>
