# コンテンツ用表示領域ウィジェット

## コードサンプル

## コードサンプル

```jsp
<box:content>
  ここに記載された説明文などは定義情報を持ったブロック要素として出力され、
  PJ共通のスタイル定義を設定できる。
</box:content>
```

<details>
<summary>keywords</summary>

box:content, JSP, コンテンツ表示領域, ウィジェット使用例

</details>

## 仕様

## 仕様

定義情報を持ったブロックで囲んだボディ部の内容を出力する。ローカル動作とサーバ動作の挙動は同じ。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)]

| プロパティ名 | 型 | サーバ | ローカル | 備考 |
|---|---|---|---|---|
| cssClass | 文字列 | ○ | ○ | 定義領域のclass属性を指定する。 |

<details>
<summary>keywords</summary>

cssClass, 属性値一覧, コンテンツ表示領域, ローカル動作, サーバ動作

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/box/content.tag | box_content の実体となるタグファイル |
| /js/jsp/taglib/box.js | box_content をローカルレンダリングするスタブファイル |

<details>
<summary>keywords</summary>

content.tag, box.js, タグファイル, ローカルレンダリング, 部品一覧

</details>
