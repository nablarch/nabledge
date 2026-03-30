# フォーム内の入力要素を出力するカスタムタグ

## カスタムタグ一覧

フォーム内の各入力要素に対応するカスタムタグ一覧：

| カスタムタグ | 出力するHTMLタグ |
|---|---|
| :ref:`WebView_TextTag` | inputタグ(type=text) |
| :ref:`WebView_TextareaTag` | textareaタグ |
| :ref:`WebView_PasswordTag` | inputタグ(type=password) |
| :ref:`WebView_HiddenTag` | HTMLタグの出力を行わず、ウィンドウスコープに値を出力する |
| :ref:`WebView_PlainHiddenTag` | inputタグ(type=hidden) |
| :ref:`WebView_RadioButtonTag` | inputタグ(type=radio) |
| :ref:`WebView_CheckboxTag` | inputタグ(type=checkbox) |
| :ref:`WebView_CompositeKeyRadioButtonTag` | inputタグ(type=radio)（複合キーを使用する場合） |
| :ref:`WebView_CompositeKeyCheckboxTag` | inputタグ(type=checkbox)（複合キーを使用する場合） |
| :ref:`WebView_SelectTag` | selectタグ（List型変数の各要素ごとにoptionタグを出力） |
| :ref:`WebView_RadioButtonsTag` | 複数のinputタグ(type=radio)（List型変数の各要素ごとにラジオボタンを出力） |
| :ref:`WebView_CheckboxesTag` | 複数のinputタグ(type=checkbox)（List型変数の各要素ごとにチェックボックスを出力） |

radioButtonsタグとcheckboxesタグの追加属性は :ref:`WebView_ListSelectCommon` のみ。

ラベル出力時はlabelタグを出力し、id属性値は「nablarch_<radio|checkbox><連番>」形式でフレームワークが生成する。連番は画面内でのradio/checkboxタグ出現順に1から採番。

tabindex属性で指定された値はすべてのinputタグに同じ値が出力される。

```jsp
<n:radioButtons name="team.color" tabindex="3"
          listName="allColors" elementLabelProperty="label" elementValueProperty="value" elementLabelPattern="$VALUE$:$LABEL$" />
<n:checkboxes name="team.titles" tabindex="5"
          listName="allTitles" elementLabelProperty="label" elementValueProperty="value" elementLabelPattern="$VALUE$:$LABEL$" />
```

出力HTML例（入力画面）:

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

フォーム入力要素, カスタムタグ一覧, WebView_TextTag, WebView_TextareaTag, WebView_PasswordTag, WebView_HiddenTag, WebView_PlainHiddenTag, WebView_RadioButtonTag, WebView_CheckboxTag, WebView_CompositeKeyRadioButtonTag, WebView_CompositeKeyCheckboxTag, WebView_SelectTag, WebView_RadioButtonsTag, WebView_CheckboxesTag, input, textarea, select, radioButtonsタグ, checkboxesタグ, nablarch_radio連番, nablarch_checkbox連番, tabindex, ラジオボタン一括出力, チェックボックス一括出力, id属性自動生成, labelタグ出力

</details>

## passwordタグ

passwordタグ固有の追加属性：

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| restoreValue | | false | 入力画面の再表示時に入力データを復元するか否か。true=復元、false=復元しない |
| replacement | | * | 確認画面用の出力時に使用する置換文字 |

使用例（置換文字を"#"に変更）：
```jsp
<n:password name="systemAccount.newPassword" replacement="#" />
```

HTML出力：
```html
<!-- 入力画面 -->
<input type="password" name="systemAccount.newPassword" value="password" />
<!-- 確認画面 -->
########
```

> **注意**: passwordタグでは、入力データと同じ数の置換文字が出力される。入力データに関係なく固定文字列を出力したい場合は、固定文字列をJSPに直接記述する。

:ref:`WebView_ListSelectCommon` に加えて以下の追加属性がある。

| 属性 | 説明 |
|---|---|
| withNoneOption | リスト先頭に選択なしのオプションを追加するか否か。追加する場合はtrue、追加しない場合はfalse。デフォルトはfalse。 |
| noneOptionLabel | リスト先頭に選択なしのオプションを追加する場合に使用するラベル。withNoneOptionにtrueを指定した場合のみ有効。デフォルトは""。 |

「選択なし」オプションのvalue属性は常に空文字。

```jsp
<n:select name="user.groupIds"
          listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
          elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul"
          withNoneOption="true" noneOptionLabel="選択なし" />
```

出力HTML例（入力画面、user.groupIds = "G002" の場合）:

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

restoreValue, replacement, passwordタグ, 確認画面, 置換文字, パスワード入力, type=password, selectタグ, withNoneOption, noneOptionLabel, 選択なしオプション, プルダウン選択, ドロップダウン, 選択なし追加

</details>

## radioButtonタグ

radioButtonタグ固有の追加属性：

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| label | ○ | | ラベル |

使用例：
```jsp
<n:radiobutton name="user.sex" value="0" label="0:男性" />
<n:radiobutton name="user.sex" value="1" label="1:女性" />
```

HTML出力（user.sex = 1 の場合）：
```html
<input id="nablarch_radio1" type="radio" name="user.sex" value="0" /><label for="nablarch_radio1">0:男性</label>
<input id="nablarch_radio2" type="radio" name="user.sex" value="1" checked="checked" /><label for="nablarch_radio2">1:女性</label>
```

- ラベルを出力する際にlabelタグを出力する。
- id属性の指定がない場合は、フレームワークで「nablarch_radio<連番>」形式のid属性値を生成（連番は画面内のradioタグ出現順に1から付番）。

<details>
<summary>keywords</summary>

label, radioButtonタグ, ラジオボタン, id自動生成, nablarch_radio, type=radio

</details>

## checkboxタグ

checkboxタグ固有の追加属性：

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| value | | 1 | チェックありの場合に使用する値 |
| label | | | チェックありの場合に使用するラベル（入力画面で表示） |
| useOffValue | | true | チェックなしの値設定を使用するか否か |
| offLabel | | | チェックなしの場合に使用するラベル |
| offValue | | 0 | チェックなしの場合に使用する値 |

HTMLのcheckboxタグはチェックなしの場合にリクエストパラメータが送信されない。本機能では、チェックなしに対応する値をhiddenタグとして出力し、NablarchTagHandlerがリクエスト受付時にチェックなしの場合のみリクエストパラメータに設定する。NablarchTagHandlerの設定は :ref:`WebView_NablarchTagHandler` を参照。

value属性とoffValue属性のデフォルト値の設定方法は :ref:`WebView_CustomTagConfig` を参照。

使用例：
```jsp
<n:checkbox name="user.useEmail" label="使用する" offLabel="使用しない" />
```

入力画面の出力例（user.useEmail = 1 の場合）：
```html
<input id="nablarch_checkbox1" type="checkbox" name="user.useEmail" value="1" checked="checked" />
<label for="nablarch_checkbox1">使用する</label>
```

確認画面の出力例：
- チェックあり（リクエストパラメータのuser.useEmailには"1"が設定）: 使用する
- チェックなし（リクエストパラメータのuser.useEmailには"0"が設定）: 使用しない

- ラベルを出力する際にlabelタグを出力する（ラベルがブランクでない場合のみ）。
- id属性の指定がない場合は、フレームワークで「nablarch_checkbox<連番>」形式のid属性値を生成（連番は画面内のcheckboxタグ出現順に1から付番）。

> **注意**: チェックなしの値設定が不要な場合（一括削除などで複数選択する場合等）は、useOffValue属性にfalseを指定する。

<details>
<summary>keywords</summary>

value, label, useOffValue, offLabel, offValue, checkboxタグ, チェックなし, NablarchTagHandler, WebView_NablarchTagHandler, WebView_CustomTagConfig, WebView_SingleCheckBoxTag, nablarch_checkbox, type=checkbox, hiddenタグ

</details>

## compositeKeyRadioButtonタグ、compositeKeyCheckboxタグ

compositeKeyRadioButtonタグ・compositeKeyCheckboxタグ固有の追加属性：

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| namePrefix | | | 選択している名称のプレフィクス。"." + keyNamesで指定したキー名と合致する値を通常のname属性と同様に取り扱う |
| keyNames | | | 複合キーのプロパティのリスト |
| valueObject | | | 複合キーを表すオブジェクト。keyNamesで指定したキー名を必ずプロパティに持つ必要がある |

これらのタグは、radioButtonタグとcheckboxタグで実現できない複合キーを持つ値の選択に使用する。

> **警告**: name属性には、namePrefixとkeyNamesで指定したキーの組み合わせと異なる名称にしなければならない特殊な制約がある。

**パターン1: キーの数と同じだけのプロパティで保持する場合**

Form実装例：
```java
public class SampleForm {
    private String[] compositeKeyCheckboxValue1;
    private String[] compositeKeyCheckboxValue2;
}
```

JSP実装例：
```jsp
<n:compositeKeyCheckbox 
   namePrefix="sampleForm" 
   label="" 
   valueObject="${row}" 
   keyNames="compositeKeyCheckboxValue1,compositeKeyCheckboxValue2" 
   name="form.compositeKeyCheckboxValue" />
```

**パターン2: CompositeKeyクラスのプロパティで保持する場合**

Form実装例：
```java
public class CompositeKeyForm {
    private CompositeKey[] compositeKeys;
}
```

JSP実装例：
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

namePrefix, keyNames, valueObject, CompositeKey, compositeKeyRadioButton, compositeKeyCheckbox, 複合キー, WebView_CompositeKeyRadioButtonTag, WebView_CompositeKeyCheckboxTag

</details>

## List型変数に対応するカスタムタグの共通属性

:ref:`WebView_SelectTag` 、 :ref:`WebView_RadioButtonsTag` 、 :ref:`WebView_CheckboxesTag` の共通属性：

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 選択された値をリクエストパラメータ又は変数スコープから取得する際に使用するname属性 |
| listName | ○ | | 選択項目のリストの属性名 |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| elementLabelPattern | | $LABEL$ | ラベルを整形するためのパターン。プレースホルダ: $LABEL$（ラベル）、$VALUE$（値）。"$VALUE$ - $LABEL$"と指定した場合、ラベル=グループ1・値=G001なら"G001 - グループ1"となる |
| listFormat | | br | リスト表示時のフォーマット。br/div/span/ul/ol/sp（スペース区切り） |

> **注意**: listFormat属性はタグにより適用範囲が異なる。selectタグは確認画面用の出力時のみ使用。radioButtonsタグとcheckboxesタグは入力画面と確認画面の両方で使用。

使用例（selectタグ、複数選択、ラベルパターン"$VALUE$ - $LABEL$"）：
```java
List<Group> groups = Arrays.asList(new Group("G001", "グループA"), new Group("G002", "グループB"),
                                   new Group("G003", "グループC"), new Group("G004", "グループD"),
                                   new Group("G005", "グループE"));
ctx.setRequestScoped("allGroups", groups);
```

```jsp
<n:select name="user.groupIds" multiple="true"
          listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
          elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul" />
```

HTML出力（user.groupIds = "G002", "G003", "G004" の場合）：
```html
<!-- 入力画面 -->
<select name="user.groupIds">
  <option value="G001">G001 - グループA</option>
  <option value="G002" selected="selected">G002 - グループB</option>
  <option value="G003" selected="selected">G003 - グループC</option>
  <option value="G004" selected="selected">G004 - グループD</option>
  <option value="G005">G005 - グループE</option>
</select>
<!-- 確認画面 -->
<ul>
  <li>G002 - グループB</li>
  <li>G003 - グループC</li>
  <li>G004 - グループD</li>
</ul>
```

<details>
<summary>keywords</summary>

name, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, WebView_SelectTag, WebView_RadioButtonsTag, WebView_CheckboxesTag, WebView_MultiSelectCustomTag, WebView_ListSelectCommon, List型変数, selectタグ, radioButtonsタグ, checkboxesタグ, $LABEL$, $VALUE$

</details>
