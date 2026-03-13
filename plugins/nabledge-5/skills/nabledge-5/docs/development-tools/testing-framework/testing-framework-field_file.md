# ファイル選択ウィジェット

**公式ドキュメント**: [ファイル選択ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_file.html)

## コードサンプル

**設計成果物・実装成果物（共通）**:
```jsp
<field:file
    title="登録対象ファイル"
    name="userList">
</field:file>
```

<details>
<summary>keywords</summary>

field:file, ファイル選択ウィジェット, JSPタグ, ファイルアップロード, title属性, name属性

</details>

## 仕様（属性値一覧）

**属性値一覧** [○ 任意属性 × 無効(指定しても効果なし)]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのname属性 | 文字列 | ○ | ○ | デフォルトはname属性の値 |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| disabled | サーバへの入力値送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 複数の入力項目を一つのエラーメッセージでハイライト表示する場合に指定 | 文字列 | ○ | × | |
| comment | ファイル選択についての備考 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示される |

このウィジェットは [field_base](testing-framework-field_base.md) を用いて実装。共通仕様は [field_base](testing-framework-field_base.md) 参照。

<details>
<summary>keywords</summary>

id, domain, disabled, cssClass, nameAlias, comment, 属性値, ファイル選択, サーバ対応, ローカル対応

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/file.tag | [field_file](testing-framework-field_file.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:file>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。ファイル選択に関する定義もここに含まれる。 |

<details>
<summary>keywords</summary>

内部構造, 改修, タグファイル, nablarch.js, base.less, field/file.tag, field/base.tag

</details>
