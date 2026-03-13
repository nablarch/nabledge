# コンテンツ用表示領域ウィジェット

**公式ドキュメント**: [コンテンツ用表示領域ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/box_content.html)

## コンテンツ用表示領域ウィジェット（仕様・部品一覧）

**タグ**: `<box:content>`

定義情報を持ったブロックで囲んだボディ部の内容を出力する。ローカル動作とサーバ動作の挙動は同じ。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 名称 | 内容 | タイプ | サーバ | ローカル |
|---|---|---|---|---|
| cssClass | 定義領域のclass属性を指定する | 文字列 | ○ | ○ |

**コードサンプル**

```jsp
<box:content>
  ここに記載された説明文などは定義情報を持ったブロック要素として出力され、
  PJ共通のスタイル定義を設定できる。
</box:content>
```

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/box/content.tag | box_content の実体となるタグファイル |
| /js/jsp/taglib/box.js | box_content をローカルレンダリングするスタブファイル |

<details>
<summary>keywords</summary>

box:content, cssClass, コンテンツ表示領域, ウィジェット, content.tag, box.js, ローカルレンダリング

</details>
