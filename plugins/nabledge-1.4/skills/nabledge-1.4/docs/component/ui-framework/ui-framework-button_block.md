# ボタン配置ブロック

## コードサンプル

## コードサンプル

[button_block](ui-framework-button_block.md) は、各種の [button_submit](ui-framework-button_submit.md) を配置するためのブロックを定義するウィジェット。ブロック内の各ボタンは **UI標準** に沿って配置される。

```jsp
<button:block>
  <n:forInputPage>
    <button:check uri="./確認画面.jsp">
    </button:check>
  </n:forInputPage>
  <n:forConfirmationPage>
    <button:cancel uri="./登録画面.jsp">
    </button:cancel>
  </n:forConfirmationPage>
</button:block>
```

<details>
<summary>keywords</summary>

button:block, button:submit, button:check, button:cancel, n:forInputPage, n:forConfirmationPage, ボタン配置ブロック, UI標準, JSP, ウィジェット, 入力画面, 確認画面

</details>

## 仕様

## 仕様

各種ボタンの配置を制御するラッパーDIVを定め、ボディ部に記述された内容をそのまま出力する。

**属性値一覧**: なし

<details>
<summary>keywords</summary>

ラッパーDIV, ボタン配置制御, 属性値なし, ボディ部出力

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/button/block.tag` | [button_block](ui-framework-button_block.md) の実体となるタグファイル |
| `/css/style/content.less` | 各種ボタンの配置を制御するルールを含む |

<details>
<summary>keywords</summary>

block.tag, content.less, タグファイル, CSSスタイル, ボタン配置ルール

</details>
