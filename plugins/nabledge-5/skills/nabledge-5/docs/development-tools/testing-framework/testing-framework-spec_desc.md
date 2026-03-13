# 設計情報コメントウィジェット

**公式ドキュメント**: [設計情報コメントウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/spec_desc.html)

## 設計情報コメントウィジェット（spec:desc）

`<spec:desc>` ウィジェットは、設計時情報としてソースコード中にコメントを残す用途に使用する。この部品はローカル表示、サーバ表示、解説書の内容のいずれにも影響しない。

> **補足**: `<spec:condition>` で `<c:if>` による分岐を切り替える際に、`<spec:desc>` タグの内容を参照する。詳細は [spec_condition](testing-framework-spec_condition.md) を参照すること。

このタグの内容は、JSPプレビュー表示・設計書ビューの内容には一切影響しない。

サーバ表示で動作するタグファイル（`desc.tag`）は、JSPコンパイルを通すためのダミーである。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/desc.tag | [spec_desc](testing-framework-spec_desc.md) のタグファイル |

<details>
<summary>keywords</summary>

spec:desc, spec_desc, desc.tag, 設計情報コメントウィジェット, 設計時コメント, JSPプレビュー非表示, spec:condition連携

</details>
