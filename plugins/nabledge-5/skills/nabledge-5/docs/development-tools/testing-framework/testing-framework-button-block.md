# ボタン配置ブロック

[ボタン配置ブロック](../../development-tools/testing-framework/testing-framework-button-block.md) は、各種の [ボタンウィジェット](../../development-tools/testing-framework/testing-framework-button-submit.md)
を配置するためのブロックを定義するウィジェットである。
ブロック内の各ボタンは、 **UI標準** に沿って配置される。

## コードサンプル

**実装成果物(サーバ動作)**

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

## 仕様

このウィジェットは各種ボタンの配置を制御するためのラッパーDIVを定め、
その中にボディ部に記述された内容をそのまま出力する。

**属性値一覧**
なし

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/button/block.tag | [ボタン配置ブロック](../../development-tools/testing-framework/testing-framework-button-block.md) の実体となるタグファイル |
| /css/style/content.less | 各種ボタンの配置を制御するルールはこのファイル   に含まれる。 |
