# タイトル用表示領域ウィジェット

**公式ドキュメント**: [タイトル用表示領域ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/box_title.html)

## コードサンプル

**実装例 (JSP)**:

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

box:title ウィジェット, タイトル用表示領域, JSPタグ実装例, box:content, タイトル定義

</details>

## 仕様

box_title は、タイトル用の表示領域を定義するウィジェットである。各PJのポリシーに沿ったタイトル用の表示領域を出力する。

定義情報を持ったブロックで囲んだボディ部の内容を出力する。ローカル動作とサーバ動作の挙動は同じ。

**属性値一覧** (◎ 必須属性、○ 任意属性、× 無効)

| 名称 | 内容 | タイプ | サーバ | ローカル |
|---|---|---|---|---|
| cssClass | 定義領域のclass属性を指定する。 | 文字列 | ○ | ○ |
| id | 定義領域のid属性を指定する。 | 文字列 | ○ | ○ |

<details>
<summary>keywords</summary>

PJポリシー, タイトル表示領域の定義, ボディ部の出力, cssClass, id, 属性値一覧, タイトルウィジェット仕様, ローカル動作, サーバ動作

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/box/title.tag | [box_title](testing-framework-box_title.md) の実体となるタグファイル |
| /js/jsp/taglib/box.js | [box_title](testing-framework-box_title.md) をローカルレンダリングするスタブファイル |

<details>
<summary>keywords</summary>

title.tag, box.js, 部品一覧, ローカルレンダリング, タグファイル

</details>
