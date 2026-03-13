# パスワード入力ウィジェット

**公式ドキュメント**: [パスワード入力ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_password.html)

## パスワード入力ウィジェット

パスワード入力ウィジェット（[field_password](testing-framework-field_password.md)）は、UI標準のパスワード入力に準拠したパスワード入力欄を出力する。[field_base](testing-framework-field_base.md) を用いて実装されており、field_baseが実装する共通仕様はここでは記述しない。

**ローカル動作時の挙動**
- 入力画面: `sample` 属性に指定した値を初期表示値としてパスワード入力欄に表示する
- 確認画面: パスワード入力欄は「*」でマスクされた値が表示される

**コードサンプル（設計成果物/ローカル動作）**
```jsp
<field:password title="パスワード"
                domain="パスワード"
                required="true"
                maxlength="20"
                name=""
                sample="password">
</field:password>
```

**コードサンプル（実装成果物/サーバ動作）**
```jsp
<field:password title="パスワード"
                domain="パスワード"
                required="true"
                maxlength="20"
                name="W11AC02.newPassword">
</field:password>
```

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効（指定しても効果なし）]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのid属性 | 文字列 | ○ | ○ | |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: false |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: false |
| maxlength | 入力文字数の上限 | 数値 | ○ | ○ | |
| example | 具体的な入力例（placeholder形式で表示） | 文字列 | ○ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合に指定 | 文字列 | ○ | × | |
| sample | ローカル動作時に表示する文字列（実際にはマスクされて表示される） | 文字列 | × | ○ | |
| dataFrom | 表示するデータの取得元（「表示情報取得元」.「表示項目名」形式） | 文字列 | × | × | |
| comment | パスワード入力項目についての備考（設計書の画面項目定義の備考欄に表示） | 文字列 | × | × | |
| initialValueDesc | 初期表示内容に関する説明（設計書の画面項目定義の備考欄に表示） | 文字列 | × | × | |

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/password.tag | [field_password](testing-framework-field_password.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:password>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（パスワード入力欄に関する定義を含む） |

<details>
<summary>keywords</summary>

パスワード入力ウィジェット, field:password, id, sample属性, maxlength, domain, readonly, disabled, nameAlias, cssClass, dataFrom, example, initialValueDesc, comment, パスワードフィールド, ローカル動作, 確認画面マスク, JSPウィジェット

</details>
