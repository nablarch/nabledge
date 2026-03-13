# ID:値セット項目表示ウィジェット

**公式ドキュメント**: [ID:値セット項目表示ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_label_id_value.html)

## コードサンプル

**設計成果物(ローカル動作)**:
```jsp
<field:label_id_value
    title="グループ"
    sample="0000000000: お客様グループ">
</field:label_id_value>
```

**実装成果物(サーバ動作)**:
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

field:label_id_value, ID値セット項目表示ウィジェット, JSPウィジェット, ローカル動作, サーバ動作, コードサンプル

</details>

## 仕様

**サーバ動作時の挙動**: 入力画面・確認画面ともに `idName` 属性に指定した変数の値と `valueName` 属性に指定した変数の値をセパレータ `":"` で連結した文字列を表示する。

**ローカル動作時の挙動**: 入力画面・確認画面ともに `sample` に指定した文字列を出力する。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 項目名 | 文字列 | ◎ | ◎ | |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| idName | ID値として表示する変数名 | 文字列 | ◎ | ○ | |
| valueName | 名称として表示する変数名 | 文字列 | ◎ | ○ | |
| sample | ローカル動作時に表示する文字列 | 文字列 | × | ○ | |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する、「表示情報取得元」.「表示項目名」の形式で設定する。 |
| comment | 表示項目についての備考 | 文字列 | × | × | 設計書の表示時に、画面項目定義の項目定義一覧で、「備考」に表示される。 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に、画面項目定義の項目定義一覧で、「備考」に表示される。 |

<details>
<summary>keywords</summary>

title, domain, idName, valueName, sample, dataFrom, comment, initialValueDesc, 属性一覧, ID値表示, セパレータ連結, 入力画面, 確認画面

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/field/label_id_value.tag` | `field_label_id_value` の実体となるタグファイル |
| `/js/jsp/taglib/nablarch.js` | `<n:write>` のエミュレーション機能を実装するタグライブラリスタブJS |

<details>
<summary>keywords</summary>

label_id_value.tag, nablarch.js, タグファイル, タグライブラリスタブJS, 内部構造, 部品一覧

</details>
