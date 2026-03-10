# タグリファレンス

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/tag/tag_reference.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationResultMessage.html)

## 全てのHTMLタグ

各カスタムタグの定義でここで定義した共通属性を参照する。

| 属性 | 説明 |
|---|---|
| id | XHTMLのid属性 |
| cssClass | XHTMLのclass属性 |
| style | XHTMLのstyle属性 |
| title | XHTMLのtitle属性 |
| lang | XHTMLのlang属性 |
| xmlLang | XHTMLのxml:lang属性 |
| dir | XHTMLのdir属性 |
| onclick | XHTMLのonclick属性 |
| ondblclick | XHTMLのondblclick属性 |
| onmousedown | XHTMLのonmousedown属性 |
| onmouseup | XHTMLのonmouseup属性 |
| onmouseover | XHTMLのonmouseover属性 |
| onmousemove | XHTMLのonmousemove属性 |
| onmouseout | XHTMLのonmouseout属性 |
| onkeypress | XHTMLのonkeypress属性 |
| onkeydown | XHTMLのonkeydown属性 |
| onkeyup | XHTMLのonkeyup属性 |

<details>
<summary>keywords</summary>

id, cssClass, style, title, lang, xmlLang, dir, onclick, ondblclick, onmousedown, onmouseup, onmouseover, onmousemove, onmouseout, onkeypress, onkeydown, onkeyup, HTMLタグ共通属性, カスタムタグ共通属性

</details>

## フォーカスを取得可能なHTMLタグ

| 属性 | 説明 |
|---|---|
| accesskey | XHTMLのaccesskey属性 |
| tabindex | XHTMLのtabindex属性 |
| onfocus | XHTMLのonfocus属性 |
| onblur | XHTMLのonblur属性 |

<details>
<summary>keywords</summary>

accesskey, tabindex, onfocus, onblur, フォーカス属性, フォーカス取得可能タグ

</details>

## 動的属性の使用

動的属性が使用可能なタグでは、定義されていない属性も設定が可能となる。

<details>
<summary>keywords</summary>

動的属性, 未定義属性, カスタムタグ動的属性

</details>

## formタグ

動的属性: 使用可

:ref:`tag-generic_attributes_tag` の属性を含む。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| action | | | XHTMLのaction属性 |
| method | | `post` | XHTMLのmethod属性 |
| enctype | | | XHTMLのenctype属性 |
| onsubmit | | | XHTMLのonsubmit属性 |
| onreset | | | XHTMLのonreset属性 |
| accept | | | XHTMLのaccept属性 |
| acceptCharset | | | XHTMLのaccept-charset属性 |
| target | | | XHTMLのtarget属性 |
| autocomplete | | | HTML5のautocomplete属性 |
| windowScopePrefixes | | | ウィンドウスコープ変数のプレフィックス（カンマ区切り）。指定されたプレフィックスがマッチするリクエストパラメータをhiddenタグとして出力する |
| useToken | | `false` | トークンを設定するか否か。:ref:`tag-confirmation_page_tag` が指定された場合はデフォルトが `true` となる |
| secure | | | URIをhttpsにするか否か。httpsにする場合は `true` |
| preventPostResubmit | | `false` | POST再送信防止機能を使用するか否か |

<details>
<summary>keywords</summary>

windowScopePrefixes, useToken, preventPostResubmit, secure, フォームタグ, POST再送信防止, トークン, ウィンドウスコープ, autocomplete

</details>

## textタグ

動的属性: 使用可

:ref:`tag-generic_attributes_tag` 、:ref:`tag-focus_attributes_tag` の属性を含む。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（論理属性） |
| readonly | | | XHTMLのreadonly属性（論理属性） |
| size | | | XHTMLのsize属性 |
| maxlength | | | XHTMLのmaxlength属性 |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（論理属性） |
| placeholder | | | HTML5のplaceholder属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切り） |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照） |

<details>
<summary>keywords</summary>

errorCss, nameAlias, valueFormat, nablarch_error, テキスト入力, placeholder, maxlength, readonly, autofocus

</details>

## searchタグ

動的属性: 使用可

:ref:`tag-generic_attributes_tag` 、:ref:`tag-focus_attributes_tag` の属性を含む。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（論理属性） |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（論理属性） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切り） |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照） |

<details>
<summary>keywords</summary>

errorCss, nameAlias, valueFormat, nablarch_error, 検索テキスト, search入力

</details>

## telタグ

動的属性: 使用可

:ref:`tag-generic_attributes_tag` 、:ref:`tag-focus_attributes_tag` の属性を含む。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（論理属性） |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（論理属性） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切り） |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照） |

<details>
<summary>keywords</summary>

errorCss, nameAlias, valueFormat, nablarch_error, 電話番号入力, tel入力

</details>

## urlタグ

動的属性: 使用可

:ref:`tag-generic_attributes_tag` 、:ref:`tag-focus_attributes_tag` の属性を含む。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（論理属性） |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（論理属性） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切り） |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照） |

<details>
<summary>keywords</summary>

errorCss, nameAlias, valueFormat, nablarch_error, URL入力, url入力

</details>

## emailタグ

動的属性: 使用可

:ref:`tag-generic_attributes_tag` 、:ref:`tag-focus_attributes_tag` の属性を含む。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（論理属性） |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（論理属性） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切り） |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照） |

<details>
<summary>keywords</summary>

errorCss, nameAlias, valueFormat, nablarch_error, メールアドレス入力, email入力

</details>

## dateタグ

動的属性: 使用可

:ref:`tag-generic_attributes_tag` 、:ref:`tag-focus_attributes_tag` の属性を含む。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（論理属性） |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（論理属性） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切り） |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照） |

<details>
<summary>keywords</summary>

errorCss, nameAlias, valueFormat, nablarch_error, 日付入力, date入力

</details>

## monthタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

<details>
<summary>keywords</summary>

month, 月入力, HTML5 month, valueFormat, errorCss, nameAlias, 動的属性, 入力フォームタグ

</details>

## weekタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

<details>
<summary>keywords</summary>

week, 週入力, HTML5 week, valueFormat, errorCss, nameAlias, 動的属性, 入力フォームタグ

</details>

## timeタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

<details>
<summary>keywords</summary>

time, 時刻入力, HTML5 time, valueFormat, errorCss, nameAlias, 動的属性, 入力フォームタグ

</details>

## datetimeLocalタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

<details>
<summary>keywords</summary>

datetimeLocal, 日時入力, HTML5 datetime-local, valueFormat, errorCss, nameAlias, 動的属性, 入力フォームタグ

</details>

## numberタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

<details>
<summary>keywords</summary>

number, 数値入力, HTML5 number, valueFormat, errorCss, nameAlias, 動的属性, 入力フォームタグ

</details>

## rangeタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

<details>
<summary>keywords</summary>

range, 範囲入力, HTML5 range, valueFormat, errorCss, nameAlias, 動的属性, 入力フォームタグ

</details>

## colorタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

<details>
<summary>keywords</summary>

color, カラー入力, HTML5 color, valueFormat, errorCss, nameAlias, 動的属性, 入力フォームタグ

</details>

## textareaタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性 |
| rows | ○ | | XHTMLのrows属性 |
| cols | ○ | | XHTMLのcols属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| readonly | | | XHTMLのreadonly属性（:ref:`論理属性 <boolean_attribute>`）|
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| placeholder | | | HTML5のplaceholder属性 |
| maxlength | | | HTML5のmaxlength属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

<details>
<summary>keywords</summary>

textarea, テキストエリア, 複数行テキスト入力, rows, cols, placeholder, maxlength, errorCss, 動的属性

</details>

## passwordタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| readonly | | | XHTMLのreadonly属性（:ref:`論理属性 <boolean_attribute>`）|
| size | | | XHTMLのsize属性 |
| maxlength | | | XHTMLのmaxlength属性 |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| placeholder | | | HTML5のplaceholder属性 |
| restoreValue | | `false` | 入力画面の再表示時に入力データを復元するか否か。復元する場合は`true`、しない場合は`false` |
| replacement | | `*` | 確認画面用の出力時に使用する置換文字 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

<details>
<summary>keywords</summary>

password, パスワード入力, restoreValue, replacement, 確認画面置換文字, errorCss, 動的属性

</details>

## radioButtonタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性 |
| value | ○ | | XHTMLのvalue属性 |
| label | ○ | | ラベル |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

<details>
<summary>keywords</summary>

radioButton, ラジオボタン, 単一選択, label, errorCss, 動的属性

</details>

## checkboxタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性 |
| value | | `1` | XHTMLのvalue属性。チェックありの場合に使用する値 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| label | | | チェックありの場合に使用するラベル。入力画面で表示される |
| useOffValue | | `true` | チェックなしの値設定を使用するか否か |
| offLabel | | | チェックなしの場合に使用するラベル |
| offValue | | `0` | チェックなしの場合に使用する値 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| onchange | | | XHTMLのonchange属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

<details>
<summary>keywords</summary>

checkbox, チェックボックス, useOffValue, offValue, offLabel, 複数選択, errorCss, 動的属性

</details>

## compositeKeyCheckboxタグ

動的属性: 可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`tag-generic_attributes_tag` | | | |
| :ref:`tag-focus_attributes_tag` | | | |
| name | ○ | | XHTMLのname属性。namePrefix属性とkeyNames属性で指定したキーの組み合わせと異なる名称にしなければならない |
| valueObject | ○ | | XHTMLのvalue属性の代わりに使用するオブジェクト。keyNames属性で指定したプロパティを持つ必要がある |
| keyNames | ○ | | 複合キーのキー名（カンマ区切り）|
| namePrefix | ○ | | リクエストパラメータ展開時のプレフィクス。`namePrefix.keyName`形式でリクエストスコープの値を参照する。name属性はnamePrefix属性とkeyNames属性の組み合わせと異なる名称にしなければならない |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）|
| label | | | チェックありの場合に使用するラベル。入力画面で表示される |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`）|
| onchange | | | XHTMLのonchange属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

<details>
<summary>keywords</summary>

compositeKeyCheckbox, 複合キーチェックボックス, valueObject, keyNames, namePrefix, 複合キー, errorCss, 動的属性

</details>

## compositeKeyRadioButtonタグ

動的属性：可

:ref:`tag-generic_attributes_tag` および :ref:`tag-focus_attributes_tag` の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| valueObject | ○ | | value属性の代わりに使用するオブジェクト。keyNames属性で指定したプロパティを持つ必要がある |
| keyNames | ○ | | 複合キーのキー名（カンマ区切り） |
| namePrefix | ○ | | リクエストパラメータ展開用プレフィクス。`namePrefix.keyName`形式でリクエストスコープの値を参照・送信する（例：namePrefix=`form`、keyNames=`key1,key2`の場合、`form.key1`と`form.key2`で処理） |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| label | | | チェックありの場合に使用するラベル（入力画面で表示） |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数はカンマ区切り） |

> **重要**: name属性は、namePrefix属性とkeyNames属性で指定したキーの組み合わせと異なる名称にしなければならない特殊な制約がある。

<details>
<summary>keywords</summary>

compositeKeyRadioButton, 複合キーラジオボタン, namePrefix, keyNames, valueObject, 複合キー入力

</details>

## fileタグ

動的属性：可

:ref:`tag-generic_attributes_tag` および :ref:`tag-focus_attributes_tag` の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| readonly | | | XHTMLのreadonly属性（:ref:`論理属性 <boolean_attribute>`） |
| size | | | XHTMLのsize属性 |
| maxlength | | | XHTMLのmaxlength属性 |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| accept | | | XHTMLのaccept属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| multiple | | | HTML5のmultiple属性（:ref:`論理属性 <boolean_attribute>`） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数はカンマ区切り） |

<details>
<summary>keywords</summary>

fileタグ, ファイルアップロード入力, multiple, accept, ファイル選択, onselect, onchange, readonly, size, maxlength

</details>

## hiddenタグ

動的属性：可

HTMLタグを出力せず、ウィンドウスコープに値を出力する。

> **重要**: ウィンドウスコープは非推奨。詳細は :ref:`tag-window_scope` を参照。

:ref:`tag-generic_attributes_tag` および :ref:`tag-focus_attributes_tag` の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |

<details>
<summary>keywords</summary>

hiddenタグ, ウィンドウスコープ, 非推奨, hidden値出力

</details>

## plainHiddenタグ

動的属性：可

:ref:`tag-generic_attributes_tag` および :ref:`tag-focus_attributes_tag` の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |

<details>
<summary>keywords</summary>

plainHiddenタグ, hidden入力, hidden属性

</details>

## hiddenStoreタグ

動的属性：可

:ref:`tag-generic_attributes_tag` および :ref:`tag-focus_attributes_tag` の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |

<details>
<summary>keywords</summary>

hiddenStoreタグ, hidden入力保存, hidden属性

</details>

## selectタグ

動的属性：可

:ref:`tag-generic_attributes_tag` の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択肢リストの名前。リクエストスコープから取得する（空の場合は何も表示しない） |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| size | | | XHTMLのsize属性 |
| multiple | | | XHTMLのmultiple属性（:ref:`論理属性 <boolean_attribute>`） |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| tabindex | | | XHTMLのtabindex属性 |
| onfocus | | | XHTMLのonfocus属性 |
| onblur | | | XHTMLのonblur属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| elementLabelPattern | | `$LABEL$` | ラベル整形パターン（`$LABEL$`=ラベル、`$VALUE$`=値） |
| listFormat | | `br` | リスト表示フォーマット（br/div/span/ul/ol/sp） |
| withNoneOption | | `false` | 先頭に選択なしオプションを追加するか（true/false） |
| noneOptionLabel | | `""` | 選択なしオプションのラベル（withNoneOption=trueの場合のみ有効） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数はカンマ区切り） |

<details>
<summary>keywords</summary>

selectタグ, プルダウン, listName, elementLabelProperty, elementValueProperty, withNoneOption, elementLabelPattern, listFormat, 選択リスト, tabindex, onfocus, onblur, onchange, size, noneOptionLabel

</details>

## radioButtonsタグ

動的属性：可

:ref:`tag-generic_attributes_tag`（id属性は指定不可）および :ref:`tag-focus_attributes_tag`（accesskey属性は指定不可）の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択肢リストの名前。リクエストスコープから取得する（空の場合は何も表示しない） |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）。先頭要素のみ出力 |
| elementLabelPattern | | `$LABEL$` | ラベル整形パターン（`$LABEL$`=ラベル、`$VALUE$`=値） |
| listFormat | | `br` | リスト表示フォーマット（br/div/span/ul/ol/sp） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数はカンマ区切り） |

<details>
<summary>keywords</summary>

radioButtonsタグ, ラジオボタンリスト, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, onchange

</details>

## checkboxesタグ

動的属性：可

:ref:`tag-generic_attributes_tag`（id属性は指定不可）および :ref:`tag-focus_attributes_tag`（accesskey属性は指定不可）の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択肢リストの名前。リクエストスコープから取得する（空の場合は何も表示しない） |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）。先頭要素のみ出力 |
| elementLabelPattern | | `$LABEL$` | ラベル整形パターン（`$LABEL$`=ラベル、`$VALUE$`=値） |
| listFormat | | `br` | リスト表示フォーマット（br/div/span/ul/ol/sp） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数はカンマ区切り） |

<details>
<summary>keywords</summary>

checkboxesタグ, チェックボックスリスト, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, onchange

</details>

## submitタグ

動的属性：可

:ref:`tag-generic_attributes_tag` および :ref:`tag-focus_attributes_tag` の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| type | ○ | | XHTMLのtype属性 |
| uri | ○ | | URI（:ref:`tag-specify_uri` 参照） |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| value | | | XHTMLのvalue属性 |
| src | | | XHTMLのsrc属性 |
| alt | | | XHTMLのalt属性 |
| usemap | | | XHTMLのusemap属性 |
| align | | | XHTMLのalign属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| allowDoubleSubmission | | `true` | 二重サブミットを許可するか（true/false） |
| secure | | | URIをhttpsにするか（true/false） |
| displayMethod | | | 認可判定とサービス提供可否判定の結果に応じて表示制御を行う場合の表示方法（NODISPLAY=非表示/DISABLED=非活性/NORMAL=通常表示） |
| suppressDefaultSubmit | | `false` | デフォルトのサブミット関数呼び出しをonclickに設定しないよう抑制するか（true/false） |

<details>
<summary>keywords</summary>

submitタグ, サブミットボタン, allowDoubleSubmission, displayMethod, suppressDefaultSubmit, 二重サブミット防止, uri

</details>

## buttonタグ

動的属性：可

:ref:`tag-generic_attributes_tag` および :ref:`tag-focus_attributes_tag` の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI（:ref:`tag-specify_uri` 参照） |
| value | | | XHTMLのvalue属性 |
| type | | | XHTMLのtype属性 |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| allowDoubleSubmission | | `true` | 二重サブミットを許可するか（true/false） |
| secure | | | URIをhttpsにするか（true/false） |
| displayMethod | | | 認可判定とサービス提供可否判定の結果に応じて表示制御を行う場合の表示方法（NODISPLAY=非表示/DISABLED=非活性/NORMAL=通常表示） |
| suppressDefaultSubmit | | `false` | デフォルトのサブミット関数呼び出しをonclickに設定しないよう抑制するか（true/false） |

<details>
<summary>keywords</summary>

buttonタグ, ボタン, allowDoubleSubmission, displayMethod, suppressDefaultSubmit, uri

</details>

## submitLinkタグ

動的属性：可

:ref:`tag-generic_attributes_tag` および :ref:`tag-focus_attributes_tag` の属性も使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI（:ref:`tag-specify_uri` 参照） |
| shape | | | XHTMLのshape属性 |
| coords | | | XHTMLのcoords属性 |
| allowDoubleSubmission | | `true` | 二重サブミットを許可するか（true/false） |
| secure | | | URIをhttpsにするか（true/false） |
| displayMethod | | | 認可判定とサービス提供可否判定の結果に応じて表示制御を行う場合の表示方法（NODISPLAY=非表示/DISABLED=非活性/NORMAL=通常表示） |
| suppressDefaultSubmit | | `false` | デフォルトのサブミット関数呼び出しをonclickに設定しないよう抑制するか（true/false） |

<details>
<summary>keywords</summary>

submitLinkタグ, リンクボタン, allowDoubleSubmission, displayMethod, suppressDefaultSubmit, shape, coords, uri

</details>

## popupSubmitタグ

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| :ref:`tag-generic_attributes_tag` | | |
| :ref:`tag-focus_attributes_tag` | | |
| name | | XHTMLのname属性 |
| type | ○ | XHTMLのtype属性 |
| uri | ○ | URI（:ref:`tag-specify_uri` を参照） |
| disabled | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| value | | XHTMLのvalue属性 |
| src | | XHTMLのsrc属性 |
| alt | | XHTMLのalt属性 |
| usemap | | XHTMLのusemap属性 |
| align | | XHTMLのalign属性 |
| autofocus | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttps以外 |
| popupWindowName | | ポップアップのウィンドウ名（window.open第2引数） |
| popupOption | | ポップアップのオプション情報（window.open第3引数） |
| displayMethod | | 表示制御方法。`NODISPLAY`（非表示）、`DISABLED`（非活性）、`NORMAL`（通常表示） |
| suppressDefaultSubmit | | デフォルトのサブミット用関数呼び出しをonclickに設定しないか。デフォルト`false` |

<details>
<summary>keywords</summary>

popupSubmit, ポップアップサブミット, popupWindowName, popupOption, displayMethod, suppressDefaultSubmit, secure, uri, type, name

</details>

## popupButtonタグ

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| :ref:`tag-generic_attributes_tag` | | |
| :ref:`tag-focus_attributes_tag` | | |
| name | | XHTMLのname属性 |
| uri | ○ | URI（:ref:`tag-specify_uri` を参照） |
| value | | XHTMLのvalue属性 |
| type | | XHTMLのtype属性 |
| disabled | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| autofocus | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttps以外 |
| popupWindowName | | ポップアップのウィンドウ名（window.open第2引数） |
| popupOption | | ポップアップのオプション情報（window.open第3引数） |
| displayMethod | | 表示制御方法。`NODISPLAY`（非表示）、`DISABLED`（非活性）、`NORMAL`（通常表示） |
| suppressDefaultSubmit | | デフォルトのサブミット用関数呼び出しをonclickに設定しないか。デフォルト`false` |

<details>
<summary>keywords</summary>

popupButton, ポップアップボタン, popupWindowName, popupOption, displayMethod, suppressDefaultSubmit, secure, uri, name, type, disabled, value, autofocus

</details>

## popupLinkタグ

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| :ref:`tag-generic_attributes_tag` | | |
| :ref:`tag-focus_attributes_tag` | | |
| name | | XHTMLのname属性 |
| uri | ○ | URI（:ref:`tag-specify_uri` を参照） |
| shape | | XHTMLのshape属性 |
| coords | | XHTMLのcoords属性 |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttps以外 |
| popupWindowName | | ポップアップのウィンドウ名（window.open第2引数） |
| popupOption | | ポップアップのオプション情報（window.open第3引数） |
| displayMethod | | 表示制御方法。`NODISPLAY`（非表示）、`DISABLED`（非活性）、`NORMAL`（通常表示） |
| suppressDefaultSubmit | | デフォルトのサブミット用関数呼び出しをonclickに設定しないか。デフォルト`false` |

<details>
<summary>keywords</summary>

popupLink, ポップアップリンク, popupWindowName, popupOption, displayMethod, suppressDefaultSubmit, secure, uri, shape, coords

</details>

## downloadSubmitタグ

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| :ref:`tag-generic_attributes_tag` | | |
| :ref:`tag-focus_attributes_tag` | | |
| name | | XHTMLのname属性 |
| type | ○ | XHTMLのtype属性 |
| uri | ○ | URI（:ref:`tag-specify_uri` を参照） |
| disabled | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| value | | XHTMLのvalue属性 |
| src | | XHTMLのsrc属性 |
| alt | | XHTMLのalt属性 |
| usemap | | XHTMLのusemap属性 |
| align | | XHTMLのalign属性 |
| autofocus | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| allowDoubleSubmission | | 二重サブミットを許可するか否か。`true`で許可、`false`で不許可。デフォルト`true` |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttps以外 |
| displayMethod | | 表示制御方法。`NODISPLAY`（非表示）、`DISABLED`（非活性）、`NORMAL`（通常表示） |
| suppressDefaultSubmit | | デフォルトのサブミット用関数呼び出しをonclickに設定しないか。デフォルト`false` |

<details>
<summary>keywords</summary>

downloadSubmit, ダウンロードサブミット, ファイルダウンロード, allowDoubleSubmission, 二重サブミット, displayMethod, suppressDefaultSubmit, secure, uri

</details>

## downloadButtonタグ

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| :ref:`tag-generic_attributes_tag` | | |
| :ref:`tag-focus_attributes_tag` | | |
| name | | XHTMLのname属性 |
| uri | ○ | URI（:ref:`tag-specify_uri` を参照） |
| value | | XHTMLのvalue属性 |
| type | | XHTMLのtype属性 |
| disabled | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| autofocus | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| allowDoubleSubmission | | 二重サブミットを許可するか否か。`true`で許可、`false`で不許可。デフォルト`true` |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttps以外 |
| displayMethod | | 表示制御方法。`NODISPLAY`（非表示）、`DISABLED`（非活性）、`NORMAL`（通常表示） |
| suppressDefaultSubmit | | デフォルトのサブミット用関数呼び出しをonclickに設定しないか。デフォルト`false` |

<details>
<summary>keywords</summary>

downloadButton, ダウンロードボタン, ファイルダウンロード, allowDoubleSubmission, 二重サブミット, displayMethod, suppressDefaultSubmit, secure, uri, name, type, disabled, value, autofocus

</details>

## downloadLinkタグ

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| :ref:`tag-generic_attributes_tag` | | |
| :ref:`tag-focus_attributes_tag` | | |
| name | | XHTMLのname属性 |
| uri | ○ | URI（:ref:`tag-specify_uri` を参照） |
| shape | | XHTMLのshape属性 |
| coords | | XHTMLのcoords属性 |
| allowDoubleSubmission | | 二重サブミットを許可するか否か。`true`で許可、`false`で不許可。デフォルト`true` |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttps以外 |
| displayMethod | | 表示制御方法。`NODISPLAY`（非表示）、`DISABLED`（非活性）、`NORMAL`（通常表示） |
| suppressDefaultSubmit | | デフォルトのサブミット用関数呼び出しをonclickに設定しないか。デフォルト`false` |

<details>
<summary>keywords</summary>

downloadLink, ダウンロードリンク, ファイルダウンロード, allowDoubleSubmission, 二重サブミット, displayMethod, suppressDefaultSubmit, secure, uri, name, shape, coords

</details>

## paramタグ

動的属性の使用可否：否

| 属性名 | 必須 | 説明 |
|---|---|---|
| paramName | ○ | サブミット時に使用するパラメータの名前 |
| name | | 値を取得するための名前。リクエストスコープなどスコープ上のオブジェクトを参照する場合に指定。name属性とvalue属性のどちらか一方を指定する |
| value | | 値を直接指定する場合に使用。name属性とvalue属性のどちらか一方を指定する |

<details>
<summary>keywords</summary>

param, サブミットパラメータ, paramName, リクエストスコープ, パラメータ値指定

</details>

## changeParamNameタグ

動的属性の使用可否：否

| 属性名 | 必須 | 説明 |
|---|---|---|
| paramName | ○ | サブミット時に使用するパラメータの名前 |
| inputName | ○ | 変更元となる元画面のinput要素のname属性 |

<details>
<summary>keywords</summary>

changeParamName, パラメータ名変更, paramName, inputName, サブミットパラメータ

</details>

## aタグ

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| :ref:`tag-generic_attributes_tag` | | |
| :ref:`tag-focus_attributes_tag` | | |
| charset | | XHTMLのcharset属性 |
| type | | XHTMLのtype属性 |
| name | | XHTMLのname属性 |
| href | | XHTMLのhref属性（:ref:`tag-specify_uri` を参照） |
| hreflang | | XHTMLのhreflang属性 |
| rel | | XHTMLのrel属性 |
| rev | | XHTMLのrev属性 |
| shape | | XHTMLのshape属性 |
| coords | | XHTMLのcoords属性 |
| target | | XHTMLのtarget属性 |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttps以外 |

<details>
<summary>keywords</summary>

アンカータグ, リンク, href, secure, target, hreflang, rel, charset, rev, shape, coords, type, name

</details>

## imgタグ

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| :ref:`tag-generic_attributes_tag` | | |
| src | ○ | XHTMLのcharsrc属性（:ref:`tag-specify_uri` を参照） |
| alt | ○ | XHTMLのalt属性 |
| name | | XHTMLのname属性 |
| longdesc | | XHTMLのlongdesc属性 |
| height | | XHTMLのheight属性 |
| width | | XHTMLのwidth属性 |
| usemap | | XHTMLのusemap属性 |
| ismap | | XHTMLのismap属性 |
| align | | XHTMLのalign属性 |
| border | | XHTMLのborder属性 |
| hspace | | XHTMLのhspace属性 |
| vspace | | XHTMLのvspace属性 |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttps以外 |

<details>
<summary>keywords</summary>

画像タグ, イメージ, src, alt, secure, usemap, width, height, longdesc, ismap, align, border, hspace, vspace

</details>

## linkタグ

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| :ref:`tag-generic_attributes_tag` | | |
| charset | | XHTMLのcharset属性 |
| href | | XHTMLのhref属性（:ref:`tag-specify_uri` を参照） |
| hreflang | | XHTMLのhreflang属性 |
| type | | XHTMLのtype属性 |
| rel | | XHTMLのrel属性 |
| rev | | XHTMLのrev属性 |
| media | | XHTMLのmedia属性 |
| target | | XHTMLのtarget属性 |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttps以外 |

<details>
<summary>keywords</summary>

linkタグ, href, secure, rel, media, type, charset, hreflang, rev, target

</details>

## scriptタグ

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| type | ○ | XHTMLのtype属性 |
| id | | XHTMLのid属性 |
| charset | | XHTMLのcharset属性 |
| language | | XHTMLのlanguage属性 |
| src | | XHTMLのsrc属性（:ref:`tag-specify_uri` を参照） |
| defer | | XHTMLのdefer属性 |
| xmlSpace | | XHTMLのxml:space属性 |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttps以外 |

<details>
<summary>keywords</summary>

scriptタグ, JavaScript, src, secure, type, defer, xmlSpace, charset, language

</details>

## errorsタグ

動的属性: 不可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| cssClass | | `nablarch_errors` | リスト表示のulタグに使用するCSSクラス名 |
| infoCss | | `nablarch_info` | 情報レベルメッセージのCSSクラス名 |
| warnCss | | `nablarch_warn` | 警告レベルメッセージのCSSクラス名 |
| errorCss | | `nablarch_error` | エラーレベルメッセージのCSSクラス名 |
| filter | | `all` | メッセージフィルタ条件。`all`（全メッセージ）または`global`（入力項目に対応しないメッセージのみ）。`global`の場合、`ValidationResultMessage` のプロパティ名が含まれるメッセージを除外して出力する |

<details>
<summary>keywords</summary>

cssClass, infoCss, warnCss, errorCss, filter, エラーメッセージ一覧表示, バリデーションエラー表示, メッセージフィルタ, ValidationResultMessage

</details>

## errorタグ

動的属性: 不可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | エラーメッセージを表示する入力項目のname属性 |
| errorCss | | `nablarch_error` | エラーレベルメッセージのCSSクラス名 |
| messageFormat | | `div` | メッセージ表示フォーマット。`div`（divタグ）または`span`（spanタグ） |

<details>
<summary>keywords</summary>

name, errorCss, messageFormat, 入力項目エラー表示, エラーメッセージ表示

</details>

## noCacheタグ

動的属性: 不可

属性なし。

<details>
<summary>keywords</summary>

noCacheタグ, キャッシュ無効化, ブラウザキャッシュ制御

</details>

## codeSelectタグ

動的属性: 可

:ref:`tag-generic_attributes_tag` が使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| codeId | ○ | | コードID |
| size | | | XHTMLのsize属性 |
| multiple | | | XHTMLのmultiple属性（:ref:`論理属性 <boolean_attribute>`） |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| tabindex | | | XHTMLのtabindex属性 |
| onfocus | | | XHTMLのonfocus属性 |
| onblur | | | XHTMLのonblur属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベル整形パターン。`$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称）、`$VALUE$`（コード値）。`$OPTIONALNAME$`使用時はoptionColumnName必須 |
| listFormat | | `br` | リスト表示フォーマット。`br`/`div`/`span`/`ul`/`ol`/`sp`（スペース区切り） |
| withNoneOption | | `false` | 選択なしオプションをリスト先頭に追加するか。`true`で追加 |
| noneOptionLabel | | `""` | withNoneOption=`true`の場合の選択なしオプションラベル |
| errorCss | | `nablarch_error` | エラーレベルメッセージのCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

<details>
<summary>keywords</summary>

name, codeId, size, multiple, disabled, tabindex, onfocus, onblur, onchange, autofocus, pattern, labelPattern, listFormat, withNoneOption, noneOptionLabel, errorCss, nameAlias, optionColumnName, コードIDセレクトボックス, ドロップダウンリスト, コード選択

</details>

## codeRadioButtonsタグ

動的属性: 可

:ref:`tag-generic_attributes_tag`（id属性は指定不可）、:ref:`tag-focus_attributes_tag`（accesskey属性は指定不可）が使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| codeId | ○ | | コードID |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）。先頭要素のみautofocus属性を出力する |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベル整形パターン。`$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称）、`$VALUE$`（コード値）。`$OPTIONALNAME$`使用時はoptionColumnName必須 |
| listFormat | | `br` | リスト表示フォーマット。`br`/`div`/`span`/`ul`/`ol`/`sp`（スペース区切り） |
| errorCss | | `nablarch_error` | エラーレベルメッセージのCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

<details>
<summary>keywords</summary>

name, codeId, disabled, onchange, autofocus, pattern, optionColumnName, labelPattern, listFormat, errorCss, nameAlias, コードIDラジオボタン, ラジオボタングループ, コード選択

</details>

## codeCheckboxesタグ

動的属性: 可

:ref:`tag-generic_attributes_tag`（id属性は指定不可）、:ref:`tag-focus_attributes_tag`（accesskey属性は指定不可）が使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| codeId | ○ | | コードID |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`）。先頭要素のみautofocus属性を出力する |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベル整形パターン。`$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称）、`$VALUE$`（コード値）。`$OPTIONALNAME$`使用時はoptionColumnName必須 |
| listFormat | | `br` | リスト表示フォーマット。`br`/`div`/`span`/`ul`/`ol`/`sp`（スペース区切り） |
| errorCss | | `nablarch_error` | エラーレベルメッセージのCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

<details>
<summary>keywords</summary>

name, codeId, disabled, onchange, autofocus, pattern, optionColumnName, labelPattern, listFormat, errorCss, nameAlias, コードIDチェックボックス群, 複数コード選択

</details>

## codeCheckboxタグ

動的属性: 可

:ref:`tag-generic_attributes_tag`、:ref:`tag-focus_attributes_tag` が使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| value | | `1` | チェックありの場合に使用するコード値 |
| autofocus | | | HTML5のautofocus属性（:ref:`論理属性 <boolean_attribute>`） |
| codeId | ○ | | コードID |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベル整形パターン。`$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称）、`$VALUE$`（コード値）。`$OPTIONALNAME$`使用時はoptionColumnName必須 |
| offCodeValue | | | チェックなしの場合に使用するコード値。未指定の場合はcodeIdからコード値を検索する。検索結果が2件かつ1件がvalue属性の値の場合は残りの1件を使用する。見つからない場合はデフォルト値`0`を使用する |
| disabled | | | XHTMLのdisabled属性（:ref:`論理属性 <boolean_attribute>`） |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | `nablarch_error` | エラーレベルメッセージのCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

<details>
<summary>keywords</summary>

name, codeId, value, autofocus, optionColumnName, offCodeValue, disabled, onchange, labelPattern, errorCss, nameAlias, コードIDチェックボックス単一, チェック状態コード値

</details>

## codeタグ

動的属性: 可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | 表示対象のコード値を変数スコープから取得する名前。省略した場合はcodeIdとpatternで絞り込んだコード一覧を表示する |
| codeId | ○ | | コードID |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベル整形パターン。`$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称）、`$VALUE$`（コード値）。`$OPTIONALNAME$`使用時はoptionColumnName必須 |
| listFormat | | `br` | リスト表示フォーマット。`br`/`div`/`span`/`ul`/`ol`/`sp`（スペース区切り） |

<details>
<summary>keywords</summary>

codeId, name, pattern, labelPattern, listFormat, optionColumnName, コード値表示, コード名称表示

</details>

## cspNonceタグ

動的属性: 不可

:ref:`セキュアハンドラでnonceを生成する設定<content_security_policy>` を行っている場合に、セキュアハンドラが生成したnonceを出力する。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| sourceFormat | | `false` | nonce出力フォーマット制御。`true`の場合はプレフィックス`nonce-`を付与（meta要素で使用する場合）、`false`の場合は付与しない |

<details>
<summary>keywords</summary>

sourceFormat, CSPnonce, コンテンツセキュリティポリシー, nonce出力, セキュアハンドラ

</details>

## messageタグ

動的属性: 不可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messageId | ○ | | メッセージID |
| option0〜option9 | | | メッセージフォーマットに使用するインデックス0〜9のオプション引数（最大10個） |
| language | | スレッドコンテキストに設定された言語 | メッセージの言語 |
| var | | | リクエストスコープに格納する変数名。指定した場合はメッセージを出力せずリクエストスコープに設定する（HTMLエスケープとHTMLフォーマットは行わない） |
| htmlEscape | | `true` | HTMLエスケープをするか。`true`でエスケープ、`false`でしない |
| withHtmlFormat | | `true` | HTMLフォーマット（改行と半角スペースの変換）をするか。HTMLエスケープをする場合のみ有効 |

<details>
<summary>keywords</summary>

messageId, language, var, htmlEscape, withHtmlFormat, option0, メッセージID表示, メッセージ国際化, HTMLエスケープ, リクエストスコープ格納

</details>

## writeタグ

動的属性: 不可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | 表示対象の値を変数スコープから取得する名前。value属性と同時に指定不可 |
| value | | | 表示対象の値（直接指定）。name属性と同時に指定不可 |
| withHtmlFormat | | `true` | HTMLフォーマット（改行と半角スペースの変換）をするか。HTMLエスケープをする場合のみ有効 |
| valueFormat | | | 出力時のフォーマット。:ref:`tag-format_value` 参照 |

<details>
<summary>keywords</summary>

name, value, withHtmlFormat, valueFormat, 値の出力, HTMLフォーマット, 変数スコープ参照

</details>

## prettyPrintタグ

> **重要**: このタグは非推奨であるため使用しないこと。詳細は :ref:`prettyPrintタグの使用を推奨しない理由 <tag-pretty_print_tag-deprecated>` を参照。

動的属性: 不可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する名前 |

<details>
<summary>keywords</summary>

name, 非推奨, prettyPrint, prettyPrintタグ廃止

</details>

## rawWriteタグ

:ref:`動的属性の使用可否 <tag-dynamic_attributes_tag>` ：否

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する際に使用する名前 |

<details>
<summary>keywords</summary>

rawWriteタグ, name, 変数スコープ, 動的属性使用不可

</details>

## setタグ

:ref:`動的属性の使用可否 <tag-dynamic_attributes_tag>` ：否

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| var | ○ | | リクエストスコープに格納する際に使用する変数名 |
| name | | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する |
| value | | | 値（直接指定）。name属性とvalue属性のどちらか一方を指定する |
| scope | | request | 変数を格納するスコープ。`page`（ページスコープ）または `request`（リクエストスコープ） |
| bySingleValue | | true | name属性に対応する値を単一値として取得するか否か |

<details>
<summary>keywords</summary>

setタグ, var, name, value, scope, bySingleValue, リクエストスコープ, ページスコープ

</details>

## includeタグ

:ref:`動的属性の使用可否 <tag-dynamic_attributes_tag>` ：否

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| path | ○ | | インクルードするリソースのパス |

<details>
<summary>keywords</summary>

includeタグ, path, インクルード, 動的属性使用不可

</details>

## includeParamタグ

:ref:`動的属性の使用可否 <tag-dynamic_attributes_tag>` ：否

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| paramName | ○ | | インクルード時に使用するパラメータの名前 |
| name | | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する |
| value | | | 値（直接指定）。name属性とvalue属性のどちらか一方を指定する |

<details>
<summary>keywords</summary>

includeParamタグ, paramName, name, value, インクルードパラメータ

</details>

## confirmationPageタグ

:ref:`動的属性の使用可否 <tag-dynamic_attributes_tag>` ：否

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| path | | | フォワード先（入力画面）のパス |

<details>
<summary>keywords</summary>

confirmationPageタグ, path, 確認画面, 入力画面フォワード

</details>

## ignoreConfirmationタグ

:ref:`動的属性の使用可否 <tag-dynamic_attributes_tag>` ：否

属性なし。

<details>
<summary>keywords</summary>

ignoreConfirmationタグ, 確認スキップ, 動的属性使用不可

</details>

## forInputPageタグ

:ref:`動的属性の使用可否 <tag-dynamic_attributes_tag>` ：否

属性なし。

<details>
<summary>keywords</summary>

forInputPageタグ, 入力画面, 動的属性使用不可

</details>

## forConfirmationPageタグ

:ref:`動的属性の使用可否 <tag-dynamic_attributes_tag>` ：否

属性なし。

<details>
<summary>keywords</summary>

forConfirmationPageタグ, 確認画面, 動的属性使用不可

</details>
