# ファイル選択ウィジェット

## コードサンプル

**JSPサンプル**（設計成果物・実装成果物共通）:

```jsp
<field:file
    title="登録対象ファイル"
    name="userList">
</field:file>
```

<details>
<summary>keywords</summary>

field:file, ファイル選択ウィジェット, JSPタグ, コードサンプル

</details>

## 仕様

[field_base](ui-framework-field_base.md) を用いて実装。[field_base](ui-framework-field_base.md) が実装する共通仕様はここでは記述しない。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのname属性 | 文字列 | ○ | ○ | デフォルトはname属性の値 |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合に指定する | 文字列 | ○ | × | |
| comment | ファイル選択についての備考 | 文字列 | × | × | 設計書の表示時に、画面項目定義の項目定義一覧で、「備考」に表示される |

<details>
<summary>keywords</summary>

id, domain, disabled, cssClass, nameAlias, comment, ファイル選択, 属性一覧, ウィジェット仕様

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/file.tag | [field_file](ui-framework-field_file.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:file>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。ファイル選択に関する定義もここに含まれる。 |

<details>
<summary>keywords</summary>

file.tag, base.tag, nablarch.js, base.less, ファイル選択, タグライブラリスタブ, 部品一覧

</details>
