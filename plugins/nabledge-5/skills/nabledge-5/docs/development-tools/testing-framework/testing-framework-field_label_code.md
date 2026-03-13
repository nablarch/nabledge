# コード値表示項目ウィジェット

**公式ドキュメント**: [コード値表示項目ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_label_code.html)

## コードサンプル

`field:label_code`: Nablarchのコード管理機能から取得したラベルや値を他の入力項目と並べて表示するウィジェット。通常の変数に格納された値を表示する場合は [field_label](testing-framework-field_label.md) を使用すること。

**ローカル動作（設計成果物）**
```jsp
<field:label_code
  title="ユーザIDロック">
</field:label_code>
```

**サーバ動作（実装成果物）**
```jsp
<field:label_code
  title="ユーザIDロック"
  name="11AC_W11AC01.userIdLocked"
  codeId="C0000001"
  pattern="PATTERN01"
  optionColumnName="OPTION01"
  labelPattern="$OPTIONALNAME$"
  listFormat="ul">
</field:code_label>
```

<details>
<summary>keywords</summary>

field:label_code, field_label_code, コード値表示, JSPウィジェット, コードサンプル, field_label

</details>

## 仕様

**サーバ動作時の挙動**: `codeId`属性に指定したコード値の内容を表示する。詳細はNablarch標準タグライブラリの`<n:code>`タグの仕様を参照。

**ローカル動作時の挙動**: `sample`に値を指定した場合はその内容を表示する。`codeId`属性にコードIDを指定した場合、`/js/devtool/resource/コード値定義.js`（コード設計書から自動生成）のエントリから該当するコードの名称を取得して表示する。`pattern`属性によるパターン指定や`optionColumnName`属性によるオプション名称指定も使用可能。`codeId`と`sample`を両方指定した場合は`sample`の値を優先する。

**属性値一覧** (◎=必須, ○=任意, ×=無効)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 項目名 | 文字列 | ◎ | ◎ | |
| name | 出力対象の値を変数スコープから取得するための名前 | 文字列 | ◎ | × | |
| sample | ローカル動作時に表示する文字列 | 文字列 | × | ○ | `"|"` 区切りで複数指定。`"[]"` で囲われた項目は選択状態で表示 |
| codeId | コード定義ID | 文字列 | ◎ | ○ | |
| pattern | 使用するコードパターンのカラム名 | 文字列 | ○ | ○ | デフォルト: `PATTERN01` |
| optionColumnName | 取得するオプション名称のカラム名 | 文字列 | ○ | ○ | デフォルト: `OPTION01` |
| labelPattern | ラベル表示書式 | 文字列 | ○ | ○ | プレースホルダ: `$NAME$`(コード名称), `$SHORTNAME$`(略称), `$OPTIONALNAME$`(オプション名称、`optionColumnName`指定必須), `$VALUE$`(コード値)。デフォルト: `"$NAME$"` |
| listFormat | リスト表示時フォーマット | 文字列 | ○ | ○ | デフォルト: `sp` |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 設計書用: 「表示情報取得元」.「表示項目名」形式 |
| comment | コード値表示についての備考 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |

<details>
<summary>keywords</summary>

title, name, sample, codeId, pattern, optionColumnName, labelPattern, listFormat, dataFrom, comment, initialValueDesc, サーバ動作, ローカル動作, 属性値一覧

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/field/label_code.tag` | [field_label_code](testing-framework-field_label_code.md) の実体となるタグファイル |
| `/js/jsp/taglib/nablarch.js` | `<n:code>` のエミュレーション機能を実装するタグライブラリスタブJS |

<details>
<summary>keywords</summary>

label_code.tag, nablarch.js, 部品一覧, タグファイル, コード値表示

</details>
