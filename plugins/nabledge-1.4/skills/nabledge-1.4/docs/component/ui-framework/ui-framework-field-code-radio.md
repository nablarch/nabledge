# コード値ラジオボタン入力項目ウィジェット

[コード値ラジオボタン入力項目ウィジェット](../../component/ui-framework/ui-framework-field-code-radio.md) は [ラジオボタン入力項目ウィジェット](../../component/ui-framework/ui-framework-field-radio.md) について
Nablarchのコード管理機能で取得したラベル、値をもとにした
ラジオボタンを出力できるように改修したものである。

表示仕様など、上記以外の仕様については [ラジオボタン入力項目ウィジェット](../../component/ui-framework/ui-framework-field-radio.md) と同じである。

## コードサンプル

**設計成果物(ローカル動作)**

```jsp
<field:code_radio
  title            = "ユーザIDロック"
  listFormat       = "ul">
</field:code_radio>
```

**実装成果物(サーバ動作)**

```jsp
<field:code_radio
  title            = "ユーザIDロック"
  name             = "11AC_W11AC01.userIdLocked"
  codeId           = "C0000001"
  pattern          = "PATTERN01"
  optionColumnName = "OPTION01"
  labelPattern     = "$OPTIONALNAME$"
  listFormat       = "ul">
</field:code_radio>
```

## 仕様

本ウィジェットの仕様は [ラジオボタン入力項目ウィジェット](../../component/ui-framework/ui-framework-field-radio.md) とほぼ同じである。
以下では差分となる内容について述べる。

**ローカル動作時の挙動**
[ラジオボタン入力項目ウィジェット](../../component/ui-framework/ui-framework-field-radio.md) と同様、 **sample** に指定したラベル分だけラジオボタンとラベルを表示する。
ただし、**codeId** 属性にコードIDを指定した場合、下記のファイル内のエントリーから、
該当するコードの名称を取得し、表示する。 **pattern** 属性によるパターン指定や
**optionColumnName** 属性によるオプション名称指定も利用できる。
(**codeId** と **sample** を両方指定した場合は **sample** の値を優先する。)

**パス**
/js/devtool/resource/コード値定義.js

**属性値一覧**  [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

([入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) との共通属性は省略)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ |  |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| disabled | サーバに対する入力値の送信を 抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ |  |
| nameAlias | 一つのエラーメッセージに 対して複数の入力項目を ハイライト表示する場合に そのname属性をカンマ区切り で指定する。 | 文字列 | ○ | × |  |
| sample | ローカル動作時に表示する ラジオボタンのラベル | 文字列 | × | ○ | **"\|"** 区切りで複数指定する。 **"[]"** で囲われた項目は選択状態 で表示される。 |
| codeId | コード定義ID | 文字列 | ◎ | ○ |  |
| pattern | 使用するコードパターンの カラム名 | 文字列 | ○ | ○ | デフォルトは 'PATTERN01' |
| optionColumnName | 取得するオプション名称の カラム名 | 文字列 | ○ | ○ | デフォルトは 'OPTION01' |
| labelPattern | ラベル表示書式 | 文字列 | ○ | ○ | ラベルを整形するパターン。 プレースホルダを下記に示す。 $NAME$: コード値に対応するコード名称 $SHORTNAME$: コード値に対応するコードの略称 $OPTIONALNAME$: コード値に対応するコードのオプション名称 $OPTIONALNAME$を使用する場合は optionColumnName属性の指定が必須となる。 $VALUE$: コード値 デフォルトは”$NAME$”。 |
| listFormat | リスト表示時に使用する フォーマット | 文字列 | ○ | ○ | デフォルトは 'span' |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する、 「表示情報取得元」.「表示項目名」 の形式で設定する。 |
| comment | ラジオボタンについての備考 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/code_radio.tag | [コード値ラジオボタン入力項目ウィジェット](../../component/ui-framework/ui-framework-field-code-radio.md) |
| /WEB-INF/tags/widget/field/base.tag | [入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) |
| /js/jsp/taglib/nablarch.js | <n:codeRadioButtons> のエミュレーション機能を実装する タグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。 ラジオボタンに関する定義もここに含まれる。 |
