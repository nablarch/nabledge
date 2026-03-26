# ID:値セット項目表示ウィジェット

## コードサンプル

**設計成果物（ローカル動作）**

```jsp
<field:label_id_value
    title="グループ"
    sample="0000000000: お客様グループ">
</field:label_id_value>
```

**実装成果物（サーバ動作）**

```jsp
<field:label_id_value
    title="グループ"
    idName="ugroupInfo.ugroupId"
    valueName="ugroupInfo.ugroupName"
    sample="0000000000: お客様グループ">
</field:label_id_value>
```

<details>
<summary>keywords</summary>

field:label_id_value, label_id_value, ID値セット表示ウィジェット, JSPタグ, ローカル動作, サーバ動作, sample属性, idName属性, valueName属性

</details>

## 仕様

**サーバ動作**: `idName` 属性と `valueName` 属性の値をセパレータ `:` で連結した文字列を表示（入力画面・確認画面とも）。

**ローカル動作**: `sample` に指定した文字列を出力（入力画面・確認画面とも）。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 項目名 | 文字列 | ◎ | ◎ | |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| idName | ID値として表示する変数名 | 文字列 | ◎ | ○ | |
| valueName | 名称として表示する変数名 | 文字列 | ◎ | ○ | |
| sample | ローカル動作時に表示する文字列 | 文字列 | × | ○ | |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式で設定 |
| comment | 表示項目についての備考 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |

<details>
<summary>keywords</summary>

title, domain, idName, valueName, sample, dataFrom, comment, initialValueDesc, ID値表示, セパレータ, 属性一覧, サーバ動作, ローカル動作

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/label_id_value.tag | [field_label_id_value](ui-framework-field_label_id_value.md) の実体となるタグファイル |
| /js/jsp/taglib/nablarch.js | `<n:write>` のエミュレーション機能を実装するタグライブラリスタブJS |

<details>
<summary>keywords</summary>

label_id_value.tag, nablarch.js, タグファイル, 内部構造, n:write, タグライブラリスタブ

</details>
