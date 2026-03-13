# タグリファレンス

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/tag/tag_reference.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationResultMessage.html)

## 全てのHTMLタグ

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

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

動的属性: 使用可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| valueObject | ○ | | XHTMLのvalue属性の代わりに使用するオブジェクト。keyNames属性で指定したプロパティを持つ必要がある |
| keyNames | ○ | | 複合キーのキー名（カンマ区切り） |
| namePrefix | ○ | | リクエストパラメータに展開する際のプレフィクス。`{namePrefix}.{keyName}`形式でリクエストスコープの値を参照・取得する。**制約**: name属性はnamePrefix属性とkeyNames属性の組み合わせと異なる名称にしなければならない |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| label | | | チェックありの場合に使用するラベル（入力画面で表示） |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数はカンマ区切り） |

動的属性の使用可否：可

[tag-generic_attributes_tag](#s1)、[tag-focus_attributes_tag](#s1) の属性も使用可能。

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | XHTMLのname属性 |
| type | ○ | XHTMLのtype属性 |
| uri | ○ | URI。:ref:`tag-specify_uri` を参照 |
| disabled | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| value | | XHTMLのvalue属性 |
| src | | XHTMLのsrc属性 |
| alt | | XHTMLのalt属性 |
| usemap | | XHTMLのusemap属性 |
| align | | XHTMLのalign属性 |
| autofocus | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttpsにしない |
| popupWindowName | | ポップアップのウィンドウ名。window.open関数の第2引数（JavaScript） |
| popupOption | | ポップアップのオプション情報。window.open関数の第3引数（JavaScript） |
| displayMethod | | 認可判定・サービス提供可否判定結果に応じた表示制御方法。`NODISPLAY`（非表示）/ `DISABLED`（非活性）/ `NORMAL`（通常表示） |
| suppressDefaultSubmit | | サブミット用関数呼び出しをonclick属性に設定しないよう抑制するか否か。デフォルト`false` |

動的属性の使用可否：否

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| cssClass | | `nablarch_errors` | リスト表示においてulタグに使用するCSSクラス名 |
| infoCss | | `nablarch_info` | 情報レベルのメッセージに使用するCSSクラス名 |
| warnCss | | `nablarch_warn` | 警告レベルのメッセージに使用するCSSクラス名 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| filter | | `all` | リストに含めるメッセージのフィルタ条件。`all`（全てのメッセージを表示）または`global`（入力項目に対応しないメッセージのみ表示）。`global`の場合、`ValidationResultMessage` のプロパティ名が含まれるメッセージを取り除いて出力する |

[動的属性の使用可否](#s2)：否

| 属性 | 必須 | 説明 |
|---|---|---|
| name | ○ | 表示対象の値を変数スコープから取得する際に使用する名前 |

<details>
<summary>keywords</summary>

id, cssClass, style, onclick, onkeydown, onmouseover, 共通属性, 全タグ共通, イベントハンドラ属性, HTMLカスタムタグ, month入力フィールド, 月入力, valueFormat, nameAlias, errorCss, autocomplete, autofocus, 動的属性, compositeKeyRadioButton, 複合キーラジオボタン, name, valueObject, keyNames, namePrefix, label, popupSubmitタグ, ポップアップ, サブミット, window.open, popupWindowName, popupOption, displayMethod, suppressDefaultSubmit, secure, errorsタグ, エラーメッセージ一覧表示, infoCss, warnCss, filter, ValidationResultMessage, バリデーションエラー表示, メッセージフィルタ, global, rawWrite, rawWriteタグ, 変数スコープ, name属性

</details>

## フォーカスを取得可能なHTMLタグ

| 属性 | 説明 |
|---|---|
| accesskey | XHTMLのaccesskey属性 |
| tabindex | XHTMLのtabindex属性 |
| onfocus | XHTMLのonfocus属性 |
| onblur | XHTMLのonblur属性 |

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

動的属性: 使用可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| readonly | | | XHTMLのreadonly属性（[論理属性](libraries-tag.md)） |
| size | | | XHTMLのsize属性 |
| maxlength | | | XHTMLのmaxlength属性 |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| accept | | | XHTMLのaccept属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| multiple | | | HTML5のmultiple属性（[論理属性](libraries-tag.md)） |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数はカンマ区切り） |

動的属性の使用可否：可

[tag-generic_attributes_tag](#s1)、[tag-focus_attributes_tag](#s1) の属性も使用可能。

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | XHTMLのname属性 |
| uri | ○ | URI。:ref:`tag-specify_uri` を参照 |
| value | | XHTMLのvalue属性 |
| type | | XHTMLのtype属性 |
| disabled | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| autofocus | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttpsにしない |
| popupWindowName | | ポップアップのウィンドウ名。window.open関数の第2引数（JavaScript） |
| popupOption | | ポップアップのオプション情報。window.open関数の第3引数（JavaScript） |
| displayMethod | | 認可判定・サービス提供可否判定結果に応じた表示制御方法。`NODISPLAY`（非表示）/ `DISABLED`（非活性）/ `NORMAL`（通常表示） |
| suppressDefaultSubmit | | サブミット用関数呼び出しをonclick属性に設定しないよう抑制するか否か。デフォルト`false` |

動的属性の使用可否：否

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | エラーメッセージを表示する入力項目のname属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| messageFormat | | div | メッセージ表示時に使用するフォーマット。`div`（divタグ）または`span`（spanタグ） |

[動的属性の使用可否](#s2)：否

| 属性 | 必須 | 説明 |
|---|---|---|
| var | ○ | リクエストスコープに格納する際に使用する変数名 |
| name | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する |
| value | | 値。直接値を指定する場合に使用する。name属性とvalue属性のどちらか一方を指定する |
| scope | | 変数を格納するスコープ。`page`: ページスコープ / `request`: リクエストスコープ。デフォルトはリクエストスコープ |
| bySingleValue | | name属性に対応する値を単一値として取得するか否か。デフォルトは`true` |

<details>
<summary>keywords</summary>

accesskey, tabindex, onfocus, onblur, フォーカス属性, week入力フィールド, 週入力, valueFormat, nameAlias, errorCss, autocomplete, autofocus, 動的属性, fileタグ, ファイル入力, name, accept, multiple, readonly, popupButtonタグ, ポップアップ, ボタン, window.open, popupWindowName, popupOption, displayMethod, suppressDefaultSubmit, secure, errorタグ, 入力項目エラー表示, messageFormat, 単一エラーメッセージ表示, set, setタグ, リクエストスコープ, ページスコープ, var, value, bySingleValue, scope, スコープ格納

</details>

## 動的属性の使用

動的属性が使用可能なタグでは、定義されていない属性も設定が可能となる。

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

動的属性: 使用可

HTMLタグを出力せず、ウィンドウスコープに値を出力する。

> **重要**: ウィンドウスコープは非推奨。詳細は:ref:`tag-window_scope`を参照。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |

動的属性の使用可否：可

[tag-generic_attributes_tag](#s1)、[tag-focus_attributes_tag](#s1) の属性も使用可能。

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | XHTMLのname属性 |
| uri | ○ | URI。:ref:`tag-specify_uri` を参照 |
| shape | | XHTMLのshape属性 |
| coords | | XHTMLのcoords属性 |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttpsにしない |
| popupWindowName | | ポップアップのウィンドウ名。window.open関数の第2引数（JavaScript） |
| popupOption | | ポップアップのオプション情報。window.open関数の第3引数（JavaScript） |
| displayMethod | | 認可判定・サービス提供可否判定結果に応じた表示制御方法。`NODISPLAY`（非表示）/ `DISABLED`（非活性）/ `NORMAL`（通常表示） |
| suppressDefaultSubmit | | サブミット用関数呼び出しをonclick属性に設定しないよう抑制するか否か。デフォルト`false` |

動的属性の使用可否：否

属性なし。

[動的属性の使用可否](#s2)：否

| 属性 | 必須 | 説明 |
|---|---|---|
| path | ○ | インクルードするリソースのパス |

<details>
<summary>keywords</summary>

動的属性, 未定義属性, カスタム属性追加, time入力フィールド, 時刻入力, valueFormat, nameAlias, errorCss, autocomplete, autofocus, hiddenタグ, ウィンドウスコープ, ウィンドウスコープ非推奨, name, popupLinkタグ, ポップアップ, リンク, window.open, popupWindowName, popupOption, displayMethod, suppressDefaultSubmit, secure, noCacheタグ, キャッシュ無効化, noCache, include, includeタグ, リソースインクルード, path属性

</details>

## formタグ

[動的属性の使用可否](#s2) ：可

共通属性: [tag-generic_attributes_tag](#s1) 参照

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| action | | | XHTMLのaction属性 |
| method | | post | XHTMLのmethod属性 |
| enctype | | | XHTMLのenctype属性 |
| onsubmit | | | XHTMLのonsubmit属性 |
| onreset | | | XHTMLのonreset属性 |
| accept | | | XHTMLのaccept属性 |
| acceptCharset | | | XHTMLのaccept-charset属性 |
| target | | | XHTMLのtarget属性 |
| autocomplete | | | HTML5のautocomplete属性 |
| windowScopePrefixes | | | ウィンドウスコープ変数のプレフィックス。複数指定はカンマ区切り。指定されたプレフィックスがマッチするリクエストパラメータをhiddenタグとして出力する |
| useToken | | false | トークンを設定するか否か。[tag-confirmation_page_tag](#) が指定された場合はデフォルトが `true` となる |
| secure | | | URIをhttpsにするか否か。httpsにする場合は `true`、しない場合は `false` |
| preventPostResubmit | | false | POST再送信防止機能を使用するか否か |

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

動的属性: 使用可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |

動的属性の使用可否：可

[tag-generic_attributes_tag](#s1)、[tag-focus_attributes_tag](#s1) の属性も使用可能。

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | XHTMLのname属性 |
| type | ○ | XHTMLのtype属性 |
| uri | ○ | URI。:ref:`tag-specify_uri` を参照 |
| disabled | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| value | | XHTMLのvalue属性 |
| src | | XHTMLのsrc属性 |
| alt | | XHTMLのalt属性 |
| usemap | | XHTMLのusemap属性 |
| align | | XHTMLのalign属性 |
| autofocus | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| allowDoubleSubmission | | 二重サブミットを許可するか否か。`true`で許可、`false`で許可しない。デフォルト`true` |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttpsにしない |
| displayMethod | | 認可判定・サービス提供可否判定結果に応じた表示制御方法。`NODISPLAY`（非表示）/ `DISABLED`（非活性）/ `NORMAL`（通常表示） |
| suppressDefaultSubmit | | サブミット用関数呼び出しをonclick属性に設定しないよう抑制するか否か。デフォルト`false` |

動的属性の使用可否：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| name | ○ | | XHTMLのname属性 |
| codeId | ○ | | コードID |
| size | | | XHTMLのsize属性 |
| multiple | | | XHTMLのmultiple属性（論理属性） |
| disabled | | | XHTMLのdisabled属性（論理属性） |
| tabindex | | | XHTMLのtabindex属性 |
| onfocus | | | XHTMLのonfocus属性 |
| onblur | | | XHTMLのonblur属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（論理属性） |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称）、`$VALUE$`（コード値）。`$OPTIONALNAME$`を使用する場合はoptionColumnName属性の指定が必須 |
| listFormat | | br | リスト表示時に使用するフォーマット。`br`/`div`/`span`/`ul`/`ol`/`sp`（スペース区切り） |
| withNoneOption | | `false` | リスト先頭に選択なしのオプションを追加するか否か |
| noneOptionLabel | | `""` | 選択なしオプションのラベル。withNoneOptionが`true`の場合のみ有効 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

[動的属性の使用可否](#s2)：否

| 属性 | 必須 | 説明 |
|---|---|---|
| paramName | ○ | インクルード時に使用するパラメータの名前 |
| name | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する |
| value | | 値。直接値を指定する場合に使用する。name属性とvalue属性のどちらか一方を指定する |

<details>
<summary>keywords</summary>

method, useToken, windowScopePrefixes, preventPostResubmit, secure, POST再送信防止, トークン, action, enctype, acceptCharset, datetimeLocal入力フィールド, 日時入力, valueFormat, nameAlias, errorCss, autocomplete, autofocus, 動的属性, plainHiddenタグ, hidden, name, downloadSubmitタグ, ダウンロード, サブミット, allowDoubleSubmission, 二重サブミット, displayMethod, suppressDefaultSubmit, codeSelectタグ, コードセレクトボックス, codeId, labelPattern, listFormat, withNoneOption, noneOptionLabel, pattern, optionColumnName, size, multiple, disabled, tabindex, onfocus, onblur, onchange, コードマスタ, セレクトボックス, includeParam, includeParamタグ, インクルードパラメータ, paramName, value

</details>

## textタグ

[動的属性の使用可否](#s2) ：可

共通属性: [tag-generic_attributes_tag](#s1) 、[tag-focus_attributes_tag](#s1) 参照

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。value属性が未指定の場合はvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| readonly | | | XHTMLのreadonly属性（[論理属性](libraries-tag.md)） |
| size | | | XHTMLのsize属性 |
| maxlength | | | XHTMLのmaxlength属性 |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| placeholder | | | HTML5のplaceholder属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット。:ref:`tag-format_value` 参照 |

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

動的属性: 使用可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |

動的属性の使用可否：可

[tag-generic_attributes_tag](#s1)、[tag-focus_attributes_tag](#s1) の属性も使用可能。

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | XHTMLのname属性 |
| uri | ○ | URI。:ref:`tag-specify_uri` を参照 |
| value | | XHTMLのvalue属性 |
| type | | XHTMLのtype属性 |
| disabled | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| autofocus | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| allowDoubleSubmission | | 二重サブミットを許可するか否か。`true`で許可、`false`で許可しない。デフォルト`true` |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttpsにしない |
| displayMethod | | 認可判定・サービス提供可否判定結果に応じた表示制御方法。`NODISPLAY`（非表示）/ `DISABLED`（非活性）/ `NORMAL`（通常表示） |
| suppressDefaultSubmit | | サブミット用関数呼び出しをonclick属性に設定しないよう抑制するか否か。デフォルト`false` |

動的属性の使用可否：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性（id属性は指定不可） |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性（accesskey属性は指定不可） |
| name | ○ | | XHTMLのname属性 |
| codeId | ○ | | コードID |
| disabled | | | XHTMLのdisabled属性（論理属性） |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（論理属性）。選択肢のうち先頭要素のみautofocus属性を出力する |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称）、`$VALUE$`（コード値）。`$OPTIONALNAME$`を使用する場合はoptionColumnName属性の指定が必須 |
| listFormat | | br | リスト表示時に使用するフォーマット。`br`/`div`/`span`/`ul`/`ol`/`sp`（スペース区切り） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

[動的属性の使用可否](#s2)：否

| 属性 | 必須 | 説明 |
|---|---|---|
| path | | フォワード先（入力画面）のパス |

<details>
<summary>keywords</summary>

name, errorCss, nameAlias, valueFormat, placeholder, readonly, maxlength, テキスト入力, nablarch_error, 論理属性, number入力フィールド, 数値入力, autocomplete, autofocus, 動的属性, hiddenStoreタグ, hiddenStore, downloadButtonタグ, ダウンロード, ボタン, allowDoubleSubmission, 二重サブミット, displayMethod, suppressDefaultSubmit, secure, codeRadioButtonsタグ, コードラジオボタン, codeId, labelPattern, listFormat, pattern, optionColumnName, disabled, onchange, コードマスタ, ラジオボタン, confirmationPage, confirmationPageタグ, 確認画面, フォワード先, 入力画面パス, path

</details>

## searchタグ

[動的属性の使用可否](#s2) ：可

共通属性: [tag-generic_attributes_tag](#s1) 、[tag-focus_attributes_tag](#s1) 参照

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。value属性が未指定の場合はvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット。:ref:`tag-format_value` 参照 |

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

動的属性: 使用可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択肢リストの名前。リクエストスコープから選択肢リストを取得する。リストが空の場合は何も表示しない |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| size | | | XHTMLのsize属性 |
| multiple | | | XHTMLのmultiple属性（[論理属性](libraries-tag.md)） |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| tabindex | | | XHTMLのtabindex属性 |
| onfocus | | | XHTMLのonfocus属性 |
| onblur | | | XHTMLのonblur属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| elementLabelPattern | | $LABEL$ | ラベルを整形するパターン。プレースホルダ: `$LABEL$`（ラベル）、`$VALUE$`（値） |
| listFormat | | br | リスト表示フォーマット。br/div/span/ul/ol/sp（スペース区切り）から選択 |
| withNoneOption | | false | trueの場合、リスト先頭に選択なしオプションを追加 |
| noneOptionLabel | | "" | withNoneOptionがtrueの場合のみ有効。選択なしオプションのラベル |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数はカンマ区切り） |

動的属性の使用可否：可

[tag-generic_attributes_tag](#s1)、[tag-focus_attributes_tag](#s1) の属性も使用可能。

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | XHTMLのname属性 |
| uri | ○ | URI。:ref:`tag-specify_uri` を参照 |
| shape | | XHTMLのshape属性 |
| coords | | XHTMLのcoords属性 |
| allowDoubleSubmission | | 二重サブミットを許可するか否か。`true`で許可、`false`で許可しない。デフォルト`true` |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttpsにしない |
| displayMethod | | 認可判定・サービス提供可否判定結果に応じた表示制御方法。`NODISPLAY`（非表示）/ `DISABLED`（非活性）/ `NORMAL`（通常表示） |
| suppressDefaultSubmit | | サブミット用関数呼び出しをonclick属性に設定しないよう抑制するか否か。デフォルト`false` |

動的属性の使用可否：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性（id属性は指定不可） |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性（accesskey属性は指定不可） |
| name | ○ | | XHTMLのname属性 |
| codeId | ○ | | コードID |
| disabled | | | XHTMLのdisabled属性（論理属性） |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（論理属性）。選択肢のうち先頭要素のみautofocus属性を出力する |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称）、`$VALUE$`（コード値）。`$OPTIONALNAME$`を使用する場合はoptionColumnName属性の指定が必須 |
| listFormat | | br | リスト表示時に使用するフォーマット。`br`/`div`/`span`/`ul`/`ol`/`sp`（スペース区切り） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

[動的属性の使用可否](#s2)：否

属性なし。

<details>
<summary>keywords</summary>

name, errorCss, nameAlias, valueFormat, searchタグ, 検索テキスト, nablarch_error, range入力フィールド, スライダー入力, autocomplete, autofocus, 動的属性, selectタグ, セレクトボックス, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, withNoneOption, noneOptionLabel, downloadLinkタグ, ダウンロード, リンク, allowDoubleSubmission, 二重サブミット, displayMethod, suppressDefaultSubmit, secure, codeCheckboxesタグ, コード複数チェックボックス, codeId, labelPattern, pattern, optionColumnName, disabled, onchange, コードマスタ, チェックボックス複数, ignoreConfirmation, ignoreConfirmationタグ, 確認画面スキップ

</details>

## telタグ

[動的属性の使用可否](#s2) ：可

共通属性: [tag-generic_attributes_tag](#s1) 、[tag-focus_attributes_tag](#s1) 参照

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。value属性が未指定の場合はvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット。:ref:`tag-format_value` 参照 |

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性。値表示の際、value属性が指定されていない場合はXHTMLのvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |
| valueFormat | | | 出力時のフォーマット（:ref:`tag-format_value` 参照）|

動的属性: 使用可

id属性は指定不可。accesskey属性は指定不可。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性（id属性は指定不可） |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性（accesskey属性は指定不可） |
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択肢リストの名前。リクエストスコープから選択肢リストを取得する。リストが空の場合は何も表示しない |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)）。先頭要素のみに出力 |
| elementLabelPattern | | $LABEL$ | ラベルを整形するパターン。プレースホルダ: `$LABEL$`（ラベル）、`$VALUE$`（値） |
| listFormat | | br | リスト表示フォーマット。br/div/span/ul/ol/sp（スペース区切り）から選択 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数はカンマ区切り） |

動的属性の使用可否：否

| 属性名 | 必須 | 説明 |
|---|---|---|
| paramName | ○ | サブミット時に使用するパラメータの名前 |
| name | | 値を取得するための名前。リクエストスコープなどスコープ上のオブジェクトを参照する場合に指定。name属性とvalue属性のどちらか一方を指定する |
| value | | 値。直接値を指定する場合に使用。name属性とvalue属性のどちらか一方を指定する |

動的属性の使用可否：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| value | | `1` | XHTMLのvalue属性。チェックありの場合に使用するコード値 |
| autofocus | | | HTML5のautofocus属性（論理属性） |
| codeId | ○ | | コードID |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称）、`$VALUE$`（コード値）。`$OPTIONALNAME$`を使用する場合はoptionColumnName属性の指定が必須 |
| offCodeValue | | | チェックなしの場合に使用するコード値。未指定の場合はcodeId属性の値からチェックなしコード値を検索し、検索結果が2件かつvalue属性の値が1件であれば残りを使用。見つからない場合はデフォルト値`0`を使用 |
| disabled | | | XHTMLのdisabled属性（論理属性） |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

[動的属性の使用可否](#s2)：否

属性なし。

<details>
<summary>keywords</summary>

name, errorCss, nameAlias, valueFormat, telタグ, 電話番号, nablarch_error, color入力フィールド, カラー選択, autocomplete, autofocus, 動的属性, radioButtonsタグ, ラジオボタン, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, paramタグ, サブミットパラメータ, リクエストスコープ, paramName, パラメータ名, codeCheckboxタグ, コード単一チェックボックス, codeId, value, offCodeValue, labelPattern, optionColumnName, disabled, onchange, コードマスタ, 単一チェックボックス, forInputPage, forInputPageタグ, 入力画面向け

</details>

## urlタグ

[動的属性の使用可否](#s2) ：可

共通属性: [tag-generic_attributes_tag](#s1) 、[tag-focus_attributes_tag](#s1) 参照

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。value属性が未指定の場合はvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット。:ref:`tag-format_value` 参照 |

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性 |
| rows | ○ | | XHTMLのrows属性 |
| cols | ○ | | XHTMLのcols属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| readonly | | | XHTMLのreadonly属性（[論理属性](libraries-tag.md)) |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| placeholder | | | HTML5のplaceholder属性 |
| maxlength | | | HTML5のmaxlength属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

動的属性: 使用可

id属性は指定不可。accesskey属性は指定不可。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性（id属性は指定不可） |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性（accesskey属性は指定不可） |
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択肢リストの名前。リクエストスコープから選択肢リストを取得する。リストが空の場合は何も表示しない |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)）。先頭要素のみに出力 |
| elementLabelPattern | | $LABEL$ | ラベルを整形するパターン。プレースホルダ: `$LABEL$`（ラベル）、`$VALUE$`（値） |
| listFormat | | br | リスト表示フォーマット。br/div/span/ul/ol/sp（スペース区切り）から選択 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数はカンマ区切り） |

動的属性の使用可否：否

| 属性名 | 必須 | 説明 |
|---|---|---|
| paramName | ○ | サブミット時に使用するパラメータの名前 |
| inputName | ○ | 変更元となる元画面のinput要素のname属性 |

動的属性の使用可否：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | 表示対象のコード値を変数スコープから取得する際に使用する名前。省略した場合はcodeId属性とpattern属性にて絞り込んだコードの一覧を表示する |
| codeId | ○ | | コードID |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称）、`$VALUE$`（コード値）。`$OPTIONALNAME$`を使用する場合はoptionColumnName属性の指定が必須 |
| listFormat | | br | リスト表示時に使用するフォーマット。`br`/`div`/`span`/`ul`/`ol`/`sp`（スペース区切り） |

[動的属性の使用可否](#s2)：否

属性なし。

<details>
<summary>keywords</summary>

name, errorCss, nameAlias, valueFormat, urlタグ, URL入力, nablarch_error, テキストエリア, 複数行テキスト入力, rows, cols, placeholder, maxlength, readonly, 動的属性, checkboxesタグ, チェックボックス, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, changeParamNameタグ, パラメータ名変更, paramName, inputName, サブミットパラメータ, codeタグ, コード表示, codeId, pattern, labelPattern, optionColumnName, コードマスタ表示, forConfirmationPage, forConfirmationPageタグ, 確認画面向け

</details>

## emailタグ

[動的属性の使用可否](#s2) ：可

共通属性: [tag-generic_attributes_tag](#s1) 、[tag-focus_attributes_tag](#s1) 参照

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。value属性が未指定の場合はvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット。:ref:`tag-format_value` 参照 |

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| readonly | | | XHTMLのreadonly属性（[論理属性](libraries-tag.md)) |
| size | | | XHTMLのsize属性 |
| maxlength | | | XHTMLのmaxlength属性 |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| placeholder | | | HTML5のplaceholder属性 |
| restoreValue | | false | 入力画面の再表示時に入力データを復元するか否か（true: 復元する、false: 復元しない） |
| replacement | | * | 確認画面用の出力時に使用する置換文字 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

動的属性: 使用可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性 |
| name | | | XHTMLのname属性 |
| type | ○ | | XHTMLのtype属性 |
| uri | ○ | | URI（:ref:`tag-specify_uri`参照） |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| value | | | XHTMLのvalue属性 |
| src | | | XHTMLのsrc属性 |
| alt | | | XHTMLのalt属性 |
| usemap | | | XHTMLのusemap属性 |
| align | | | XHTMLのalign属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か |
| secure | | | URIをhttpsにするか否か |
| displayMethod | | | 認可判定・サービス提供可否判定の結果に応じた表示制御。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示） |
| suppressDefaultSubmit | | false | デフォルトで生成するサブミット用onclick属性の設定を抑制するか否か |

動的属性の使用可否：可

[tag-generic_attributes_tag](#s1)、[tag-focus_attributes_tag](#s1) の属性も使用可能。

| 属性名 | 必須 | 説明 |
|---|---|---|
| charset | | XHTMLのcharset属性 |
| type | | XHTMLのtype属性 |
| name | | XHTMLのname属性 |
| href | | XHTMLのhref属性。:ref:`tag-specify_uri` を参照 |
| hreflang | | XHTMLのhreflang属性 |
| rel | | XHTMLのrel属性 |
| rev | | XHTMLのrev属性 |
| shape | | XHTMLのshape属性 |
| coords | | XHTMLのcoords属性 |
| target | | XHTMLのtarget属性 |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttpsにしない |

動的属性の使用可否：否

[セキュアハンドラでnonceを生成する設定](../handlers/handlers-secure_handler.md) を行っている場合に、セキュアハンドラが生成したnonceを出力する。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| sourceFormat | | `false` | nonceを出力する際のフォーマット制御。`true`の場合はプレフィックス`nonce-`を付与して出力（meta要素で使用）、`false`の場合は付与しない |

<details>
<summary>keywords</summary>

name, errorCss, nameAlias, valueFormat, emailタグ, メールアドレス, nablarch_error, パスワード入力, restoreValue, replacement, 確認画面置換文字, readonly, size, maxlength, autocomplete, placeholder, 動的属性, submitタグ, サブミット, type, uri, allowDoubleSubmission, secure, displayMethod, suppressDefaultSubmit, aタグ, リンク, href, target, hreflang, cspNonceタグ, CSP, nonce, sourceFormat, ContentSecurityPolicy, コンテンツセキュリティポリシー, セキュアハンドラ

</details>

## dateタグ

[動的属性の使用可否](#s2) ：可

共通属性: [tag-generic_attributes_tag](#s1) 、[tag-focus_attributes_tag](#s1) 参照

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性。value属性が未指定の場合はvalue属性にも使用される |
| value | | | XHTMLのvalue属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |
| valueFormat | | | 出力時のフォーマット。:ref:`tag-format_value` 参照 |

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性 |
| value | ○ | | XHTMLのvalue属性 |
| label | ○ | | ラベル |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

動的属性: 使用可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性 |
| name | | | XHTMLのname属性 |
| uri | ○ | | URI（:ref:`tag-specify_uri`参照） |
| value | | | XHTMLのvalue属性 |
| type | | | XHTMLのtype属性 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)） |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)） |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か |
| secure | | | URIをhttpsにするか否か |
| displayMethod | | | 認可判定・サービス提供可否判定の結果に応じた表示制御。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示） |
| suppressDefaultSubmit | | false | デフォルトで生成するサブミット用onclick属性の設定を抑制するか否か |

動的属性の使用可否：可

[tag-generic_attributes_tag](#s1) の属性も使用可能。

| 属性名 | 必須 | 説明 |
|---|---|---|
| src | ○ | XHTMLのsrc属性（charsrc）。:ref:`tag-specify_uri` を参照 |
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
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttpsにしない |

動的属性の使用可否：否

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messageId | ○ | | メッセージID |
| option0〜option9 | | | メッセージフォーマットに使用するインデックス0〜9のオプション引数（最大10個） |
| language | | スレッドコンテキストの言語 | メッセージの言語 |
| var | | | リクエストスコープに格納する際に使用する変数名。指定した場合はメッセージを出力せずリクエストスコープに設定する（HTMLエスケープとHTMLフォーマットは行わない） |
| htmlEscape | | `true` | HTMLエスケープをするか否か |
| withHtmlFormat | | `true` | HTMLフォーマット（改行と半角スペースの変換）をするか否か。HTMLエスケープをする場合のみ有効 |

<details>
<summary>keywords</summary>

name, errorCss, nameAlias, valueFormat, dateタグ, 日付入力, nablarch_error, ラジオボタン, value, onchange, autofocus, label, 動的属性, buttonタグ, ボタン, uri, allowDoubleSubmission, secure, displayMethod, suppressDefaultSubmit, imgタグ, 画像, src, alt, usemap, ismap, messageタグ, メッセージ表示, messageId, language, var, htmlEscape, withHtmlFormat, option0, メッセージ出力, リクエストスコープ

</details>

## checkboxタグ

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性 |
| value | | 1 | XHTMLのvalue属性。チェックありの場合に使用する値 |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| label | | | チェックありの場合に使用するラベル。入力画面ではこのラベルが表示される |
| useOffValue | | true | チェックなしの値設定を使用するか否か |
| offLabel | | | チェックなしの場合に使用するラベル |
| offValue | | 0 | チェックなしの場合に使用する値 |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

動的属性: 使用可

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | 汎用属性 |
| [tag-focus_attributes_tag](#s1) | | | フォーカス属性 |
| name | | | XHTMLのname属性 |
| uri | ○ | | URI（:ref:`tag-specify_uri`参照） |
| shape | | | XHTMLのshape属性 |
| coords | | | XHTMLのcoords属性 |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か |
| secure | | | URIをhttpsにするか否か |
| displayMethod | | | 認可判定・サービス提供可否判定の結果に応じた表示制御。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示） |
| suppressDefaultSubmit | | false | デフォルトで生成するサブミット用onclick属性の設定を抑制するか否か |

動的属性の使用可否：可

[tag-generic_attributes_tag](#s1) の属性も使用可能。

| 属性名 | 必須 | 説明 |
|---|---|---|
| charset | | XHTMLのcharset属性 |
| href | | XHTMLのhref属性。:ref:`tag-specify_uri` を参照 |
| hreflang | | XHTMLのhreflang属性 |
| type | | XHTMLのtype属性 |
| rel | | XHTMLのrel属性 |
| rev | | XHTMLのrev属性 |
| media | | XHTMLのmedia属性 |
| target | | XHTMLのtarget属性 |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttpsにしない |

動的属性の使用可否：否

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | 表示対象の値を変数スコープから取得する際に使用する名前。value属性と同時に指定できない |
| value | | | 表示対象の値（直接指定）。name属性と同時に指定できない |
| withHtmlFormat | | `true` | HTMLフォーマット（改行と半角スペースの変換）をするか否か。HTMLエスケープをする場合のみ有効 |
| valueFormat | | | 出力時のフォーマット。:ref:`tag-format_value` を参照 |

<details>
<summary>keywords</summary>

チェックボックス, value, offValue, useOffValue, label, offLabel, nameAlias, errorCss, 動的属性, submitLinkタグ, リンクサブミット, uri, shape, coords, allowDoubleSubmission, secure, displayMethod, suppressDefaultSubmit, linkタグ, CSSリンク, href, media, rel, writeタグ, 値出力, name, withHtmlFormat, valueFormat, 変数値表示, HTMLエスケープ

</details>

## compositeKeyCheckboxタグ

[動的属性の使用可否](#s2) ：可

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| [tag-generic_attributes_tag](#s1) | | | |
| [tag-focus_attributes_tag](#s1) | | | |
| name | ○ | | XHTMLのname属性 |
| valueObject | ○ | | XHTMLのvalue属性の代わりに使用するオブジェクト。keyNames属性で指定したプロパティを持つ必要がある |
| keyNames | ○ | | 複合キーのキー名。カンマ区切りで指定 |
| namePrefix | ○ | | リクエストパラメータ展開時のプレフィクス。例: namePrefix=`form`、keyNames=`key1,key2` の場合、表示時は `form.key1`・`form.key2` でリクエストスコープの値を参照し、サブミット時も同パラメータ名で値を取得できる |
| autofocus | | | HTML5のautofocus属性（[論理属性](libraries-tag.md)) |
| label | | | チェックありの場合に使用するラベル。入力画面ではこのラベルが表示される |
| disabled | | | XHTMLのdisabled属性（[論理属性](libraries-tag.md)) |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

> **重要**: name属性には、namePrefix属性とkeyNames属性で指定したキーの組み合わせと異なる名称を設定しなければならない特殊な制約がある。

動的属性の使用可否：可

| 属性名 | 必須 | 説明 |
|---|---|---|
| type | ○ | XHTMLのtype属性 |
| id | | XHTMLのid属性 |
| charset | | XHTMLのcharset属性 |
| language | | XHTMLのlanguage属性 |
| src | | XHTMLのsrc属性。:ref:`tag-specify_uri` を参照 |
| defer | | XHTMLのdefer属性 |
| xmlSpace | | XHTMLのxml:space属性 |
| secure | | URIをhttpsにするか否か。`true`でhttps、`false`でhttpsにしない |

動的属性の使用可否：否

> **重要**: このタグは非推奨であるため使用しないこと。詳細は :ref:`prettyPrintタグの使用を推奨しない理由 <tag-pretty_print_tag-deprecated>` を参照。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する際に使用する名前 |

<details>
<summary>keywords</summary>

複合キーチェックボックス, compositeKeyCheckbox, valueObject, keyNames, namePrefix, 複合キー, nameAlias, errorCss, 動的属性, scriptタグ, JavaScript, src, secure, defer, xmlSpace, type, prettyPrintタグ, 非推奨, deprecated, name, 整形出力, prettyPrint

</details>
