# パスワード入力ウィジェット

[パスワード入力ウィジェット](../../development-tools/testing-framework/testing-framework-field-password.md) **UI標準 UI部品 パスワード入力** の内容に準拠したパスワード入力欄を出力する。

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

## 仕様

このウィジェットは [入力項目ウィジェット共通テンプレート](../../development-tools/testing-framework/testing-framework-field-base.md) を用いて実装している。 [入力項目ウィジェット共通テンプレート](../../development-tools/testing-framework/testing-framework-field-base.md) が実装する共通仕様についてはここでは記述しない。

**ローカル動作時の挙動**

入力画面では **sample** に指定した値を初期表示値としてパスワード入力欄に表示する。

確認画面ではパスワード入力欄は、「*」でマスクされた値が表示される。

**属性値一覧**  [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのid属性 | 文字列 | ○ | ○ |  |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ |  |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| disabled | サーバに対する入力値の送信を 抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| maxlength | 入力文字数の上限 | 数値 | ○ | ○ |  |
| example | 具体的な入力例を表すテキスト (placeholderなどの 形式で表示する) | 文字列 | ○ | ○ |  |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ |  |
| nameAlias | 一つのエラーメッセージに 対して複数の入力項目を ハイライト表示する場合に 指定する。 | 文字列 | ○ | × |  |
| sample | ローカル動作時に表示する 文字列（実際には、マスクさ れて表示される。） | 文字列 | × | ○ |  |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する、 「表示情報取得元」.「表示項目名」 の形式で設定する。 |
| comment | パスワード入力項目について の備考 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/password.tag | [パスワード入力ウィジェット](../../development-tools/testing-framework/testing-framework-field-password.md) |
| /WEB-INF/tags/widget/field/base.tag | [入力項目ウィジェット共通テンプレート](../../development-tools/testing-framework/testing-framework-field-base.md) |
| /js/jsp/taglib/nablarch.js | パスワード入力ウィジェットが使用する <n:password> のエミュレーション機能を実装する タグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。  パスワード入力欄に関する定義もここに含まれる。 |
