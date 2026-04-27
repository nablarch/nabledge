# タイトル用表示領域ウィジェット

[タイトル用表示領域ウィジェット](../../development-tools/testing-framework/testing-framework-box-title.md) は、タイトル用の表示領域を定義するウィジェットである。
各PJのポリシーに沿ったタイトル用の表示領域を出力する。

## コードサンプル

**実装成果物(サーバ動作)**

```jsp
<box:title>
  タイトル定義
</box:title>
<box:content>
  コンテンツとタイトルを区別することで
  PJのポリシーの適用を簡易にする。
</box:content>
```

## 仕様

定義情報を持ったブロックで囲んだボディ部の内容を出力する。
なおローカル動作とサーバ動作の挙動は同じである。

**属性値一覧**  [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

| 名称 | 内容 | タイプ | サーバ | ローカル |
|---|---|---|---|---|
| cssClass | 定義領域の class属性を指定する。 | 文字列 | ○ | ○ |
| id | 定義領域の id属性を指定する。 | 文字列 | ○ | ○ |

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/box/title.tag | [タイトル用表示領域ウィジェット](../../development-tools/testing-framework/testing-framework-box-title.md) の実体となるタグファイル |
| /js/jsp/taglib/box.js | [タイトル用表示領域ウィジェット](../../development-tools/testing-framework/testing-framework-box-title.md) をローカルレンダリングする スタブファイル |
