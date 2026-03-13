# ボタン配置ブロック

**公式ドキュメント**: [ボタン配置ブロック](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/button_block.html)

## ボタン配置ブロック

[button_block](testing-framework-button_block.md) は、各種の [button_submit](testing-framework-button_submit.md) を配置するためのブロックを定義するウィジェット。ブロック内の各ボタンは**UI標準**に沿って配置される。

## 仕様

ラッパーDIVを定め、ボディ部に記述された内容をそのまま出力する。属性値: なし

## コードサンプル

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

## 部品一覧

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/button/block.tag | [button_block](testing-framework-button_block.md) の実体となるタグファイル |
| /css/style/content.less | 各種ボタンの配置を制御するルールを含む |

<details>
<summary>keywords</summary>

ボタン配置ブロック, button:block, button_block, button_submit, ラッパーDIV, UI標準, ボタン配置制御, block.tag, content.less

</details>
