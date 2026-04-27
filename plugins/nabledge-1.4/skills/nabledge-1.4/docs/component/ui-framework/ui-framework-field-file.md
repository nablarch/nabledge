# ファイル選択ウィジェット

[ファイル選択ウィジェット](../../component/ui-framework/ui-framework-field-file.md) **UI標準 UI部品 ファイル選択** の内容に準拠したファイル選択欄を出力する。

## コードサンプル

**設計成果物(ローカル動作)**

```jsp
<field:file
    title="登録対象ファイル"
    name="userList">
</field:file>
```

**実装成果物(サーバ動作)**

```jsp
<field:file
    title="登録対象ファイル"
    name="userList">
</field:file>
```

## 仕様

このウィジェットは [入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) を用いて実装している。 [入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) が実装する共通仕様についてはここでは記述しない。

**属性値一覧**  [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのname属性 | 文字列 | ○ | ○ | デフォルトはname属性の値 |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ |  |
| disabled | サーバに対する入力値の送信を 抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ |  |
| nameAlias | 一つのエラーメッセージに 対して複数の入力項目を ハイライト表示する場合に 指定する。 | 文字列 | ○ | × |  |
| comment | ファイル選択についての備考 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/file.tag | [ファイル選択ウィジェット](../../component/ui-framework/ui-framework-field-file.md) |
| /WEB-INF/tags/widget/field/base.tag | [入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) |
| /js/jsp/taglib/nablarch.js | <n:file> のエミュレーション機能を実装する タグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。 ファイル選択に関する定義もここに含まれる。 |
