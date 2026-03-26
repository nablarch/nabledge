# 表示項目ウィジェット

## コードサンプル

field_label は field_text や field_checkbox などの入力項目と並べて表示項目を出力するウィジェットである。主に、更新画面で変更対象でない項目（ユーザIDなど）を他の更新可能なフィールドと並べて表示したい場合に使用する。

**設計成果物（ローカル動作）**

```jsp
<field:block title="ユーザ基本情報">
  <field:label
      title="ログインID"
      sample="nablarch">
  </field:label>

  <field:text
      title="漢字氏名"
      required="true"
      sample="名部　楽太郎">
  </field:text>
</field:block>
```

**実装成果物（サーバ動作）**

```jsp
<field:block title="ユーザ基本情報">
  <field:label
      title="ログインID"
      name="W11AC03.systemAccount.loginId"
      sample="nablarch">
  </field:label>

  <field:text
      title="漢字氏名"
      name="W11AC03.users.kanjiName"
      required="true"
      maxlength="50"
      hint="全角50文字以内"
      sample="名部　楽太郎">
  </field:text>
</field:block>
```

<details>
<summary>keywords</summary>

field:label, field:block, field:text, 表示項目ウィジェット, JSP コードサンプル, ローカル動作, サーバ動作, 更新画面, 変更対象でない項目, いつ使う

</details>

## 仕様

**サーバ動作時**: `name`属性に指定した変数の値を出力（入力・確認画面とも）。変数が存在しない場合は空文字を出力。出力内容は`<n:write>`タグに準拠。

**ローカル動作時**: `sample`属性の文字列をそのまま出力（入力・確認画面とも）。

### 属性値一覧

凡例: ◎ 必須属性 ○ 任意属性 × 無効（指定しても効果なし）

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 項目名 | 文字列 | ◎ | ◎ | |
| name | 変数スコープから値を取得するための名前 | 文字列 | ◎ | ○ | |
| id | HTMLのid属性値 | 文字列 | ○ | ○ | 省略時はname属性と同じ値 |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| sample | ローカル動作時に表示する文字列 | 文字列 | × | ○ | |
| valueFormat | 出力時のフォーマット（`n:write`タグ参照） | 文字列 | ○ | × | |
| unit | 値の右側に表示する単位 | 文字列 | ○ | ○ | 出力対象の値が空の場合は単位非表示。ローカル表示で使用する場合はname属性に値を設定すること（name属性未設定時は単位もブランク表示）。 |
| dataFrom | 表示するデータの取得元（「表示情報取得元.表示項目名」形式） | 文字列 | × | × | |
| comment | 表示項目についての備考 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |
| formatSpec | 編集仕様に関する説明 | 文字列 | × | × | 設計書の画面項目定義「編集仕様」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |

<details>
<summary>keywords</summary>

field:label 属性, name, title, sample, valueFormat, unit, dataFrom, n:write, 表示項目 仕様, 必須属性, id, cssClass, domain, comment, formatSpec, initialValueDesc

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/label.tag | field_label の実体となるタグファイル |
| /js/jsp/taglib/nablarch.js | `<n:write>` のエミュレーション機能を実装するタグライブラリスタブJS |

<details>
<summary>keywords</summary>

label.tag, nablarch.js, 内部構造, タグファイル, タグライブラリスタブ

</details>
