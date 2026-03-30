# フォーム内の入力要素を出力するカスタムタグ

## 

フォーム内の各入力要素(<input>, <textarea>, <select>)に対応するカスタムタグ一覧:

| カスタムタグ | 出力するHTMLタグ |
|---|---|
| :ref:`WebView_TextTag` | inputタグ(type=text) |
| :ref:`WebView_TextareaTag` | textareaタグ |
| :ref:`WebView_PasswordTag` | inputタグ(type=password) |
| :ref:`WebView_HiddenTag` | HTMLタグを出力せず、ウィンドウスコープに値を出力する |
| :ref:`WebView_PlainHiddenTag` | inputタグ(type=hidden) |
| :ref:`WebView_RadioButtonTag` | inputタグ(type=radio) |
| :ref:`WebView_CheckboxTag` | inputタグ(type=checkbox) |
| :ref:`WebView_CompositeKeyRadioButtonTag` | inputタグ(type=radio) ※複合キーを使用する場合 |
| :ref:`WebView_CompositeKeyCheckboxTag` | inputタグ(type=checkbox) ※複合キーを使用する場合 |
| :ref:`WebView_SelectTag` | selectタグ ※List型変数の各要素ごとにoptionタグを出力 |
| :ref:`WebView_RadioButtonsTag` | 複数のinputタグ(type=radio) ※List型変数の各要素ごとにラジオボタンを出力 |
| :ref:`WebView_CheckboxesTag` | 複数のinputタグ(type=checkbox) ※List型変数の各要素ごとにチェックボックスを出力 |

追加属性は :ref:`WebView_ListSelectCommon` のみ。

ラベル出力時にlabelタグを使用。id属性は「nablarch_<radio|checkbox><連番>」形式でフレームワークが自動生成。<連番>は画面内でのradio（またはcheckbox）タグ出現順（1起算）。tabindex属性値はすべてのinputタグにそのまま出力される。

**使用例 (JSP)**:
```jsp
<n:radioButtons name="team.color" tabindex="3"
          listName="allColors" elementLabelProperty="label" elementValueProperty="value" elementLabelPattern="$VALUE$:$LABEL$" />
<n:checkboxes name="team.titles" tabindex="5"
          listName="allTitles" elementLabelProperty="label" elementValueProperty="value" elementLabelPattern="$VALUE$:$LABEL$" />
```

**出力HTML (入力画面)**:
```html
<input id="nablarch_radio1" tabindex="3" type="radio" name="team.color" value="001"><label for="nablarch_radio1">001:red</label><br>
<input id="nablarch_radio2" tabindex="3" type="radio" name="team.color" value="002"><label for="nablarch_radio2">002:blue</label><br>
<input id="nablarch_radio3" tabindex="3" type="radio" name="team.color" value="003"><label for="nablarch_radio3">003:green</label><br>
<input id="nablarch_checkbox1" tabindex="5" type="checkbox" name="team.titles" value="01"><label for="nablarch_checkbox1">01:地区優勝</label><br>
<input id="nablarch_checkbox2" tabindex="5" type="checkbox" name="team.titles" value="02"><label for="nablarch_checkbox2">02:リーグ優勝</label><br>
<input id="nablarch_checkbox3" tabindex="5" type="checkbox" name="team.titles" value="03"><label for="nablarch_checkbox3">03:ファイナル優勝</label><br>
```

<details>
<summary>keywords</summary>

WebView_TextTag, WebView_TextareaTag, WebView_PasswordTag, WebView_HiddenTag, WebView_PlainHiddenTag, WebView_RadioButtonTag, WebView_CheckboxTag, WebView_CompositeKeyRadioButtonTag, WebView_CompositeKeyCheckboxTag, WebView_SelectTag, WebView_RadioButtonsTag, WebView_CheckboxesTag, フォーム入力要素, カスタムタグ一覧, radioButtonsタグ, checkboxesタグ, nablarch_radio, nablarch_checkbox, tabindex, labelタグ, id属性自動生成, ラジオボタン一覧, チェックボックス一覧, WebView_ListSelectCommon

</details>

## passwordタグ

passwordタグの追加属性:

| 属性 | デフォルト値 | 説明 |
|---|---|---|
| restoreValue | false | 入力画面の再表示時に入力データを復元するか否か(true: 復元, false: 復元しない) |
| replacement | `*` | 確認画面用の出力時に使用する置換文字 |

> **注意**: 入力データと同じ数の置換文字が出力される。固定文字列を出力したい場合はJSPに直接記述する。

使用例(置換文字を"#"に変更):

```jsp
<n:password name="systemAccount.newPassword" replacement="#" />
```

HTML出力:

```html
<!-- 入力画面 -->
<input type="password" name="systemAccount.newPassword" value="password" />

<!-- 確認画面 -->
########
```

:ref:`WebView_ListSelectCommon` の属性に加えて、以下の属性を追加。

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| withNoneOption | false | リスト先頭に選択なしオプションを追加するか（true: 追加、false: 追加しない） |
| noneOptionLabel | "" | 選択なしオプションのラベル（withNoneOption=trueのみ有効） |

「選択なし」オプションのvalue属性は常に空文字。

**使用例 (JSP)**:
```jsp
<n:select name="user.groupIds"
          listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
          elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul"
          withNoneOption="true" noneOptionLabel="選択なし" />
```

**出力HTML (入力画面、user.groupIds = "G002" の場合)**:
```html
<select name="user.groupIds">
  <option value="">選択なし</option>
  <option value="G001">G001 - グループA</option>
  <option value="G002" selected="selected">G002 - グループB</option>
  <option value="G003">G003 - グループC</option>
  <option value="G004">G004 - グループD</option>
  <option value="G005">G005 - グループE</option>
</select>
```

<details>
<summary>keywords</summary>

passwordタグ, n:password, restoreValue, replacement, 確認画面置換文字, パスワード入力, selectタグ, withNoneOption, noneOptionLabel, 選択なしオプション, セレクトボックス, ドロップダウン, WebView_ListSelectCommon

</details>

## radioButtonタグ

radioButtonタグの追加属性:

| 属性 | 必須 | 説明 |
|---|---|---|
| label | ○ | ラベル |

使用例:

```jsp
<n:radiobutton name="user.sex" value="0" label="0:男性" />
<n:radiobutton name="user.sex" value="1" label="1:女性" />
```

HTML出力(user.sex = 1 の場合):

```html
<input id="nablarch_radio1" type="radio" name="user.sex" value="0" /><label for="nablarch_radio1">0:男性</label>
<input id="nablarch_radio2" type="radio" name="user.sex" value="1" checked="checked" /><label for="nablarch_radio2">1:女性</label>
```

ラベル出力時にlabelタグを出力する。id属性指定がない場合、フレームワークが「nablarch_radio<連番>」形式でid属性を生成(画面内radioタグの出現順に1から連番)。

<details>
<summary>keywords</summary>

radioButtonタグ, n:radiobutton, label, nablarch_radio, ラジオボタン, id属性自動生成

</details>

## 

RSTアンカー `.. _WebView_SingleCheckBoxTag:` の位置を示す区切り。このセクション自体にコンテンツはなく、checkboxタグの詳細なコンテンツはs5(checkboxタグセクション)を参照。

<details>
<summary>keywords</summary>

WebView_SingleCheckBoxTag, checkboxタグアンカー

</details>

## checkboxタグ

checkboxタグ(:ref:`WebView_SingleCheckBoxTag`)の追加属性:

| 属性 | デフォルト値 | 説明 |
|---|---|---|
| value | `1` | チェックありの場合に使用する値(XHTMLのvalue属性) |
| label | | チェックありの場合のラベル(入力画面に表示) |
| useOffValue | true | チェックなしの値設定を使用するか否か |
| offLabel | | チェックなしの場合のラベル |
| offValue | `0` | チェックなしの場合の値 |

HTMLのcheckboxはチェックなしの場合にリクエストパラメータが送信されない。フレームワークはチェックなしに対応する値をhiddenタグとして出力し、:ref:`WebView_NablarchTagHandler`がチェックなし時のみリクエストパラメータに値を設定する。

value属性とoffValue属性のデフォルト値の設定方法は:ref:`WebView_CustomTagConfig`を参照。

> **注意**: チェックなしの値設定が不要な場合(一括削除等での複数選択時など)はuseOffValue属性にfalseを指定する。

使用例:

```jsp
<n:checkbox name="user.useEmail" label="使用する" offLabel="使用しない" />
```

HTML出力(入力画面、user.useEmail = 1 の場合):

```html
<input id="nablarch_checkbox1" type="checkbox" name="user.useEmail" value="1" checked="checked" />
<label for="nablarch_checkbox1">使用する</label>
```

確認画面出力:
- チェックあり: `使用する`(リクエストパラメータuser.useEmail = "1")
- チェックなし: `使用しない`(リクエストパラメータuser.useEmail = "0")

ラベルがブランクでない場合のみlabelタグを出力。id属性指定がない場合、フレームワークが「nablarch_checkbox<連番>」形式でid属性を生成(checkboxタグ出現順に1から連番)。

<details>
<summary>keywords</summary>

checkboxタグ, n:checkbox, useOffValue, offValue, offLabel, チェックなし値設定, nablarch_checkbox, WebView_SingleCheckBoxTag, WebView_NablarchTagHandler, WebView_CustomTagConfig

</details>

## compositeKeyRadioButtonタグ、compositeKeyCheckboxタグ

compositeKeyRadioButtonタグとcompositeKeyCheckboxタグの追加属性:

| 属性 | 説明 |
|---|---|
| namePrefix | 選択している名称のプレフィクス。この名称に「.」とkeyNamesで指定したキー名を結合したパスを通常のname属性と同様に取り扱う。例えばnamePrefixに"form"、keyNamesに"key1,key2"を指定した場合、表示時にはform.key1、form.key2でリクエストスコープに含まれる値を使用してチェックボックスの値を出力する。また、サブミット後のリクエスト処理では、form.key1、form.key2というリクエストパラメータから選択された値が取得できる |
| keyNames | 複合キーのプロパティのリスト |
| valueObject | 複合キーを表すオブジェクト。keyNamesで指定したキー名を必ずプロパティに持つ必要がある |

> **注意**: このタグのname属性にはnamePrefix属性とkeyNames属性で指定したキーの組み合わせと異なる名称にしなければならない特殊な制約がある。実装時はこの点に十分注意すること。

radioButtonタグとcheckboxタグで実現できない複合キーを持つ値の選択に使用する。Form上で複合キーをキーの数と同じプロパティ、またはCompositeKeyクラスのプロパティで保持することを前提とする。キーの値はvalueObject属性で指定するオブジェクトに保持する必要がある。

**パターン1: キーの数と同じプロパティで保持する場合**

```java
public class SampleForm {
    private String[] compositeKeyCheckboxValue1;
    private String[] compositeKeyCheckboxValue2;
}
```

```jsp
<n:compositeKeyCheckbox 
   namePrefix="sampleForm" 
   label="" 
   valueObject="${row}" 
   keyNames="compositeKeyCheckboxValue1,compositeKeyCheckboxValue2" 
   name="form.compositeKeyCheckboxValue" />
```

> **注意**: name の名称は任意だが、 keyNames の名称と選択された複合キーのプロパティ名は一致させる必要がある。

**パターン2: CompositeKeyクラスのプロパティで保持する場合**

```java
public class CompositeKeyForm {
    private CompositeKey[] compositeKeys;
}
```

```jsp
<n:compositeKeyCheckbox 
   namePrefix="compositeKeyForm" 
   label="" 
   valueObject="${row}" 
   keyNames="key1,key2" 
   name="form.compositeKeys" />
```

> **注意**: name は必ず CompositeKey を表す名称とする。

<details>
<summary>keywords</summary>

compositeKeyRadioButtonタグ, compositeKeyCheckboxタグ, n:compositeKeyRadioButton, n:compositeKeyCheckbox, namePrefix, keyNames, valueObject, CompositeKey, 複合キー

</details>

## 

RSTアンカー `.. _WebView_MultiSelectCustomTag:` および `.. _WebView_ListSelectCommon:` の位置を示す区切り。このセクション自体にコンテンツはなく、List型変数に対応するカスタムタグの詳細なコンテンツはs8を参照。

<details>
<summary>keywords</summary>

WebView_MultiSelectCustomTag, WebView_ListSelectCommon, List型変数タグアンカー

</details>

## List型変数に対応するカスタムタグの共通属性

:ref:`WebView_SelectTag`、:ref:`WebView_RadioButtonsTag`、:ref:`WebView_CheckboxesTag`に共通する属性(:ref:`WebView_MultiSelectCustomTag`、:ref:`WebView_ListSelectCommon`):

| 属性 | 必須 | 説明 |
|---|---|---|
| name | ○ | 選択された値をリクエストパラメータまたは変数スコープから取得するname属性 |
| listName | ○ | 選択項目のリストの属性名 |
| elementLabelProperty | ○ | リスト要素からラベルを取得するプロパティ名 |
| elementValueProperty | ○ | リスト要素から値を取得するプロパティ名 |
| elementLabelPattern | | ラベル整形パターン。プレースホルダ: $LABEL$(ラベル)、$VALUE$(値)。例: "$VALUE$ - $LABEL$"→ラベル="グループ1"、値="G001"のとき"G001 - グループ1"。デフォルト"$LABEL$" |
| listFormat | | リスト表示フォーマット: br/div/span/ul/ol/sp(スペース区切り)。デフォルトbr |

> **注意**: listFormat属性の適用範囲はタグにより異なる。selectタグは確認画面用出力のみ。radioButtonsタグとcheckboxesタグは入力・確認画面の両方で使用する。

使用例:

```java
// 選択項目クラス(id, nameプロパティを持つGroupクラス)
List<Group> groups = Arrays.asList(
    new Group("G001", "グループA"), new Group("G002", "グループB"),
    new Group("G003", "グループC"), new Group("G004", "グループD"),
    new Group("G005", "グループE"));
ctx.setRequestScoped("allGroups", groups);
```

```jsp
<n:select name="user.groupIds" multiple="true"
          listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
          elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul" />
```

HTML出力(入力画面: user.groupIds = "G002", "G003", "G004" の場合):

```html
<select name="user.groupIds">
  <option value="G001">G001 - グループA</option>
  <option value="G002" selected="selected">G002 - グループB</option>
  <option value="G003" selected="selected">G003 - グループC</option>
  <option value="G004" selected="selected">G004 - グループD</option>
  <option value="G005">G005 - グループE</option>
</select>
```

HTML出力(確認画面):

```html
<ul>
  <li>G002 - グループB</li>
  <li>G003 - グループC</li>
  <li>G004 - グループD</li>
</ul>
```

<details>
<summary>keywords</summary>

selectタグ, radioButtonsタグ, checkboxesタグ, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, List型変数, n:select, n:radiobuttons, n:checkboxes, WebView_MultiSelectCustomTag, WebView_ListSelectCommon

</details>
