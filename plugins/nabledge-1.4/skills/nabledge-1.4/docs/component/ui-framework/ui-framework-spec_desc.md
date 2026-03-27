# 設計情報コメントウィジェット

## 設計情報コメントウィジェット（spec_desc）

[spec_desc](ui-framework-spec_desc.md) は設計時情報としてソースコード中にコメントを残す際に使用するウィジェット。ローカル表示・サーバ表示・解説書のいずれにも影響しない。

## 仕様

タグの内容はJSPプレビュー表示・設計書ビューのいずれにも影響しない。

> **注意**: 例外的に `[spec_condition](ui-framework-spec_condition.md)` の `<spec:condition>` で `<c:if>` による分岐を切り替える際に、`<spec:desc>` タグの内容を参照する。詳細は [spec_condition](ui-framework-spec_condition.md) を参照。

## 内部構造・改修時の留意点

サーバ表示で動作するタグファイル(desc.tag) は、JSPコンパイルを通すためのダミーである。

## 部品一覧

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/desc.tag | [spec_desc](ui-framework-spec_desc.md) のタグファイル |

<details>
<summary>keywords</summary>

spec_desc, spec:desc, 設計情報コメントウィジェット, JSPプレビュー表示, 設計書ビュー, spec:condition, 設計時コメント, desc.tag

</details>
