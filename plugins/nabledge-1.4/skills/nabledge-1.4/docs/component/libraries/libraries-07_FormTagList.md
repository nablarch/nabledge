# フォーム内の入力要素を出力するカスタムタグ

## カスタムタグ一覧

フォームの各入力要素に対応するカスタムタグの一覧:

| カスタムタグ | 出力するHTMLタグ |
|---|---|
| :ref:`WebView_TextTag` | inputタグ(type=text) |
| :ref:`WebView_TextareaTag` | textareaタグ |
| :ref:`WebView_PasswordTag` | inputタグ(type=password) |
| :ref:`WebView_HiddenTag` | HTMLタグの出力を行わず、ウィンドウスコープに値を出力する |
| :ref:`WebView_PlainHiddenTag` | inputタグ(type=hidden) |
| :ref:`WebView_RadioButtonTag` | inputタグ(type=radio) |
| :ref:`WebView_CheckboxTag` | inputタグ(type=checkbox) |
| :ref:`WebView_CompositeKeyRadioButtonTag` | inputタグ(type=radio)（複合キー使用時） |
| :ref:`WebView_CompositeKeyCheckboxTag` | inputタグ(type=checkbox)（複合キー使用時） |
| :ref:`WebView_SelectTag` | selectタグ（List型変数の各要素ごとにoptionタグを出力） |
| :ref:`WebView_RadioButtonsTag` | 複数のinputタグ(type=radio)（List型変数の各要素ごとにラジオボタンを出力） |
| :ref:`WebView_CheckboxesTag` | 複数のinputタグ(type=checkbox)（List型変数の各要素ごとにチェックボックスを出力） |

radioButtonsタグとcheckboxesタグの追加属性は :ref:`WebView_ListSelectCommon` のみ。

ラベル出力時にlabelタグを出力する。id属性はフレームワークが「nablarch_\<radio|checkbox>\<連番>」形式で生成する（画面内でradio/checkboxタグの出現順に1から連番）。tabindex属性の値はすべてのinputタグにそのまま出力される。

**JSP例**:
```jsp
<n:radioButtons name="team.color" tabindex="3"
            listName="allColors" elementLabelProperty="label" elementValueProperty="value" elementLabelPattern="$VALUE$:$LABEL$" />

<n:checkboxes name="team.titles" tabindex="5"
            listName="allTitles" elementLabelProperty="label" elementValueProperty="value" elementLabelPattern="$VALUE$:$LABEL$" />
```

**HTML出力例（入力画面）**:
```html
<input id="nablarch_radio1" tabindex="3" type="radio" name="team.color" value="001"><label for="nablarch_radio1">001:red</label><br>
<input id="nablarch_radio2" tabindex="3" type="radio" name="team.color" value="002"><label for="nablarch_radio2">002:blue</label><br>
<input id="nablarch_radio3" tabindex="3" type="radio" name="team.color" value="003"><label for="nablarch_radio3">003:green</label><br>
<input id="nablarch_radio4" tabindex="3" type="radio" name="team.color" value="004"><label for="nablarch_radio4">004:yellow</label><br>
<input id="nablarch_radio5" tabindex="3" type="radio" name="team.color" value="005"><label for="nablarch_radio5">005:pink</label><br>
<input id="nablarch_checkbox1" tabindex="5" type="checkbox" name="team.titles" value="01"><label for="nablarch_checkbox1">01:地区優勝</label><br>
<input id="nablarch_checkbox2" tabindex="5" type="checkbox" name="team.titles" value="02"><label for="nablarch_checkbox2">02:リーグ優勝</label><br>
<input id="nablarch_checkbox3" tabindex="5" type="checkbox" name="team.titles" value="03"><label for="nablarch_checkbox3">03:ファイナル優勝</label><br>
```

<details>
<summary>keywords</summary>

カスタムタグ, input, textarea, select, radiobutton, checkbox, hidden, フォーム入力要素, WebView_TextTag, WebView_TextareaTag, WebView_PasswordTag, WebView_HiddenTag, WebView_PlainHiddenTag, WebView_RadioButtonTag, WebView_CheckboxTag, WebView_CompositeKeyRadioButtonTag, WebView_CompositeKeyCheckboxTag, WebView_SelectTag, WebView_RadioButtonsTag, WebView_CheckboxesTag, radioButtonsタグ, checkboxesタグ, nablarch_radio連番, nablarch_checkbox連番, id属性自動生成, tabindex属性, ラジオボタン一覧出力, チェックボックス一覧出力

</details>

## passwordタグ

passwordタグの追加属性:

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| restoreValue | false | 入力画面の再表示時に入力データを復元するか。true=復元、false=復元しない |
| replacement | '*' | 確認画面用の出力時に使用する置換文字 |

```jsp
<n:password name="systemAccount.newPassword" replacement="#" />
```

入力画面出力:
```html
<input type="password" name="systemAccount.newPassword" value="password" />
```

確認画面出力 (replacement="#"):
```
########
```

> **注意**: passwordタグでは入力データと同じ数の置換文字が出力される。入力データに関係なく固定文字列を出力したい場合は、固定文字列をJSPに直接記述する。

selectタグの追加属性（ :ref:`WebView_ListSelectCommon` の共通属性に加えて）:

| 属性 | 説明 |
|---|---|
| withNoneOption | リスト先頭に選択なしのオプションを追加するか否か。追加する場合はtrue、追加しない場合はfalse。デフォルトはfalse。 |
| noneOptionLabel | リスト先頭に選択なしのオプションを追加する場合に使用するラベル。withNoneOptionにtrueを指定した場合のみ有効。デフォルトは""。 |

「選択なし」オプションのvalue属性は常に空文字になる。

**JSP例**:
```jsp
<n:select name="user.groupIds"
          listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
          elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul"
          withNoneOption="true" noneOptionLabel="選択なし" />
```

**HTML出力例（入力画面、user.groupIds = "G002" の場合）**:
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

password, restoreValue, replacement, 確認画面, 置換文字, パスワード, WebView_PasswordTag, selectタグ, withNoneOption, noneOptionLabel, 選択なしオプション, ドロップダウンリスト, 空文字value

</details>

## radioButtonタグ

radioButtonタグの追加属性:

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| label | ○ | ラベル |

radioButtonタグはラベル出力時にlabelタグを出力する。id属性の指定がない場合、フレームワークが「nablarch_radio<連番>」形式でid属性を生成する。連番は画面内でradioタグの出現順に1から付番。

```jsp
<n:radiobutton name="user.sex" value="0" label="0:男性" />
<n:radiobutton name="user.sex" value="1" label="1:女性" />
```

出力例 (user.sex = 1):
```html
<input id="nablarch_radio1" type="radio" name="user.sex" value="0" /><label for="nablarch_radio1">0:男性</label>
<input id="nablarch_radio2" type="radio" name="user.sex" value="1" checked="checked" /><label for="nablarch_radio2">1:女性</label>
```

<details>
<summary>keywords</summary>

radiobutton, label, ラジオボタン, nablarch_radio, id属性自動生成, WebView_RadioButtonTag

</details>

## checkboxタグ

checkboxタグの追加属性:

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| value | "1" | チェックありの場合に使用する値 |
| label | | チェックありの場合に使用するラベル。入力画面で表示される |
| useOffValue | true | チェックなしの値設定を使用するか否か |
| offLabel | | チェックなしの場合に使用するラベル |
| offValue | "0" | チェックなしの場合に使用する値 |

> **重要**: HTMLのcheckboxタグはチェックなし時にリクエストパラメータが送信されない。フレームワークはcheckboxタグ出力時にチェックなし対応値をhiddenタグとして出力し、NablarchTagHandlerがリクエスト受付時にチェックされていない場合のみリクエストパラメータにチェックなし対応値を設定する。NablarchTagHandlerの設定は :ref:`WebView_NablarchTagHandler` 参照。

value属性とoffValue属性のデフォルト値の設定方法は :ref:`WebView_CustomTagConfig` 参照。

checkboxタグのラベルはラベルがブランクでない場合のみ出力する。id属性の指定がない場合、フレームワークが「nablarch_checkbox<連番>」形式でid属性を生成する。連番は画面内でcheckboxタグの出現順に1から付番。

> **注意**: チェックなしの値設定が不要な場合（例：一括削除などで複数選択させる場合）は、useOffValue属性にfalseを指定する。

```jsp
<n:checkbox name="user.useEmail" label="使用する" offLabel="使用しない" />
```

入力画面出力 (user.useEmail = 1):
```html
<input id="nablarch_checkbox1" type="checkbox" name="user.useEmail" value="1" checked="checked" />
    <label for="nablarch_checkbox1">使用する</label>
```

確認画面出力:
```html
<%-- チェックありの場合: リクエストパラメータのuser.useEmailには"1"が設定されている --%>
使用する

<%-- チェックなしの場合: リクエストパラメータのuser.useEmailには"0"が設定されている --%>
使用しない
```

<details>
<summary>keywords</summary>

checkbox, value, offValue, useOffValue, offLabel, NablarchTagHandler, WebView_NablarchTagHandler, WebView_CustomTagConfig, チェックボックス, チェックなし, WebView_CheckboxTag, WebView_SingleCheckBoxTag

</details>

## compositeKeyRadioButtonタグ、compositeKeyCheckboxタグ

compositeKeyRadioButtonタグとcompositeKeyCheckboxタグの追加属性:

| プロパティ名 | 説明 |
|---|---|
| namePrefix | 選択している名称のプレフィクス。この名称に"."とkeyNamesで指定したキー名を連結した名称でリクエストスコープの値を取得・送信する。例: namePrefix="form"、keyNames="key1,key2" の場合、form.key1/form.key2 で値を取得/送信する |
| keyNames | 複合キーのプロパティのリスト |
| valueObject | 複合キーを表すオブジェクト。keyNamesで指定したキー名をプロパティに持つ必要がある |

> **重要**: name属性にはnamePrefixとkeyNamesで指定したキーの組み合わせと異なる名称を指定する必要がある特殊な制約がある。実装時は注意すること。

これらのタグはradioButtonタグとcheckboxタグでは対応できない複合キーを持つ値の選択に使用する。

**キーの数と同じプロパティで保持する場合:**

```java
public class SampleForm {
    private String[] compositeKeyCheckboxValue1;
    private String[] compositeKeyCheckboxValue2;
    // setter, getter, コンストラクタは省略
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

**CompositeKeyクラスのプロパティで保持する場合:**

```java
public class CompositeKeyForm {
    private CompositeKey[] compositeKeys;
    // setter, getter, コンストラクタは省略
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

<details>
<summary>keywords</summary>

compositeKeyRadioButton, compositeKeyCheckbox, namePrefix, keyNames, valueObject, CompositeKey, 複合キー, WebView_CompositeKeyRadioButtonTag, WebView_CompositeKeyCheckboxTag

</details>

## List型変数に対応するカスタムタグの共通属性

:ref:`WebView_SelectTag`、:ref:`WebView_RadioButtonsTag`、:ref:`WebView_CheckboxesTag` に共通する属性（List型変数の各要素ごとにタグを出力する仕様）:

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 選択された値をリクエストパラメータ/変数スコープから取得する際のname属性 |
| listName | ○ | | 選択項目のリストの属性名 |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するプロパティ名 |
| elementLabelPattern | | "$LABEL$" | ラベル整形パターン。プレースホルダ: $LABEL$=ラベル、$VALUE$=値。例: "$VALUE$ - $LABEL$" → "G001 - グループA" |
| listFormat | | br | リスト表示フォーマット。br/div/span/ul/ol/sp（スペース区切り）から選択 |

> **注意**: listFormat属性の適用範囲はタグにより異なる。selectタグは確認画面のみ使用。radioButtonsタグとcheckboxesタグは入力・確認画面の両方で使用する。

```java
// 選択項目に使用するクラス
public class Group {
    private String id;
    private String name;
    // アクセッサは省略
}

// アクションの実装例: 選択項目リストをリクエストスコープに設定
List<Group> groups = Arrays.asList(new Group("G001", "グループA"),
                                   new Group("G002", "グループB"),
                                   new Group("G003", "グループC"),
                                   new Group("G004", "グループD"),
                                   new Group("G005", "グループE"));
ctx.setRequestScoped("allGroups", groups);
```

```jsp
<n:select name="user.groupIds" multiple="true"
          listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
          elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul" />
```

入力画面出力 (user.groupIds = "G002", "G003", "G004"):
```html
<select name="user.groupIds">
  <option value="G001">G001 - グループA</option>
  <option value="G002" selected="selected">G002 - グループB</option>
  <option value="G003" selected="selected">G003 - グループC</option>
  <option value="G004" selected="selected">G004 - グループD</option>
  <option value="G005">G005 - グループE</option>
</select>
```

確認画面出力:
```html
<ul>
  <li>G002 - グループB</li>
  <li>G003 - グループC</li>
  <li>G004 - グループD</li>
</ul>
```

<details>
<summary>keywords</summary>

WebView_SelectTag, WebView_RadioButtonsTag, WebView_CheckboxesTag, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, List型変数, 選択項目リスト, WebView_ListSelectCommon, WebView_MultiSelectCustomTag

</details>
