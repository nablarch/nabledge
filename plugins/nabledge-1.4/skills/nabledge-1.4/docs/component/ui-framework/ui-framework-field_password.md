# パスワード入力ウィジェット

## コードサンプル

**設計成果物(ローカル動作)**

```jsp
<field:password title="パスワード"
                domain="パスワード"
                required="true"
                maxlength="20"
                name=""
                sample="password">
</field:password>
```

**実装成果物(サーバ動作)**

```jsp
<field:password title="パスワード"
                domain="パスワード"
                required="true"
                maxlength="20"
                name="W11AC02.newPassword">
</field:password>
```

<details>
<summary>keywords</summary>

field:password, パスワード入力, コードサンプル, ローカル動作, サーバ動作, sample属性, JSP

</details>

## 仕様

このウィジェットはfield_baseを用いて実装している。field_baseが実装する共通仕様についてはここでは記述しない。

ローカル動作時の挙動:
- 入力画面: `sample` に指定した値を初期表示値としてパスワード入力欄に表示（マスクされて表示される）
- 確認画面: パスワード入力欄は「*」でマスクされた値が表示される

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのid属性 | 文字列 | ○ | ○ | |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: false |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: false |
| maxlength | 入力文字数の上限 | 数値 | ○ | ○ | |
| example | 具体的な入力例を表すテキスト（placeholderなどの形式で表示） | 文字列 | ○ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合に指定 | 文字列 | ○ | × | |
| sample | ローカル動作時に表示する文字列（実際にはマスクされて表示される） | 文字列 | × | ○ | |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式で設定 |
| comment | パスワード入力項目についての備考 | 文字列 | × | × | 設計書表示時に項目定義一覧の「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書表示時に項目定義一覧の「備考」に表示 |

<details>
<summary>keywords</summary>

field:password, パスワード入力仕様, マスク表示, ローカル動作, 属性値一覧, id, domain, readonly, disabled, maxlength, example, sample, nameAlias, cssClass, dataFrom, comment, initialValueDesc, field_base

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/password.tag | [field_password](ui-framework-field_password.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | パスワード入力ウィジェットが使用する `<n:password>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。パスワード入力欄に関する定義を含む |

<details>
<summary>keywords</summary>

password.tag, base.tag, nablarch.js, base.less, パスワード入力ウィジェット, 部品一覧, 改修, n:password

</details>
