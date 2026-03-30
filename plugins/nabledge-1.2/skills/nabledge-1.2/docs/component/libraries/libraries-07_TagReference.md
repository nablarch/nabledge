# タグリファレンス

## 

WebViewカスタムタグのリファレンス。各カスタムタグの定義でここで定義した共通属性を参照する。共通属性には全てのHTMLタグ共通の属性（:ref:`WebView_GenericAttributesTag`）とフォーカスを取得可能なHTMLタグ共通の属性（:ref:`WebView_FocusAttributesTag`）が定義されている。

複合キー対応チェックボックスタグ。:ref:`WebView_GenericAttributesTag`、:ref:`WebView_FocusAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| valueObject | ○ | | XHTMLのvalue属性の代わりに使用するオブジェクト。keyNamesで指定したプロパティを持つ必要がある |
| keyNames | ○ | | 複合キーのキー名（カンマ区切り） |
| namePrefix | ○ | | リクエストパラメータに展開する際のプレフィクス |
| autofocus | | | HTML5のautofocus属性 |
| label | | | チェックありの場合に使用するラベル。入力画面で表示される |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| :ref:`WebView_FocusAttributesTag` | | | |
| name | | | XHTMLのname属性 |
| uri | ○ | | URI。:ref:`WebView_SpecifyUri` を参照 |
| shape | | | XHTMLのshape属性 |
| coords | | | XHTMLのcoords属性 |
| secure | | | URIをhttpsにするか否か。trueでhttps、falseでhttps化しない |
| popupWindowName | | | ポップアップのウィンドウ名。新しいウィンドウを開く際にwindwo.open関数の第2引数(JavaScript)に指定する |
| popupOption | | | ポップアップのオプション情報。新しいウィンドウを開く際にwindwo.open関数の第3引数(JavaScript)に指定する |
| displayMethod | | | 表示制御方法。NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | id属性は指定不可 |
| :ref:`WebView_FocusAttributesTag` | | | accesskey属性は指定不可 |
| name | ○ | | XHTMLのname属性 |
| codeId | ○ | | コードID |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性。選択肢のうち先頭要素のみautofocus属性を出力する |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`(コード名称)、`$SHORTNAME$`(略称)、`$OPTIONALNAME$`(オプション名称、使用時はoptionColumnName必須)、`$VALUE$`(コード値) |
| listFormat | | `br` | リスト表示フォーマット: `br`/`div`/`span`/`ul`/`ol`/`sp`(スペース区切り) |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

## listSearchSortSubmitタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| tag | | submitLink | 並び替えサブミット用Nablarchタグ。`submitLink`(aタグ) / `submit`(inputタグ) / `button`(buttonタグ) |
| type | | | タグのtype属性。`submit` / `button`のみサポート。`submitLink`使用時は無効 |
| sortCss | | "nablarch_sort" | 並び替えサブミットのclass属性（常に出力） |
| ascCss | | "nablarch_asc" | 昇順時のclass属性。sortCssに付加して出力。例: `class="nablarch_sort nablarch_asc"` |
| descCss | | "nablarch_desc" | 降順時のclass属性。sortCssに付加して出力。例: `class="nablarch_sort nablarch_desc"` |
| ascSortId | ○ | | 昇順ソートID |
| descSortId | ○ | | 降順ソートID |
| defaultSort | | asc | デフォルトソート。`asc`（昇順）/ `desc`（降順） |
| label | ○ | | サブミット用ラベル |
| name | ○ | | タグのname属性。画面内で一意にすること |
| listSearchInfoName | ○ | | ListSearchInfoをリクエストスコープから取得する際の名前 |

<details>
<summary>keywords</summary>

WebViewカスタムタグ, タグリファレンス, 共通属性, 個別属性, カスタムタグ, compositeKeyCheckbox, 複合キー, チェックボックス, valueObject, keyNames, namePrefix, nameAlias, errorCss, popupLink, popupWindowName, popupOption, displayMethod, ポップアップリンク, URI指定, codeCheckboxes, name, codeId, pattern, optionColumnName, labelPattern, listFormat, autofocus, disabled, onchange, コードチェックボックス複数, コードID, ラベルパターン, リストフォーマット, listSearchSortSubmit, 並び替えソート送信, sortCss, ascCss, descCss, ascSortId, descSortId, defaultSort, listSearchInfoName, ListSearchInfo, 一覧検索ソート

</details>

## カスタムタグ一覧

| タグ | 機能 |
|---|---|
| :ref:`WebView_FormTag` | HTMLのformタグ出力、サブミット制御（ボタンとアクションの紐付け、二重サブミット防止）、不正画面遷移チェック |
| :ref:`WebView_TextTag` | HTMLのinputタグ(type=text)出力、入力データ復元、HTMLエスケープ |
| :ref:`WebView_TextareaTag` | HTMLのtextareaタグ出力、入力データ復元、HTMLエスケープ |
| :ref:`WebView_PasswordTag` | HTMLのinputタグ(type=password)出力、入力データ復元、HTMLエスケープ |
| :ref:`WebView_RadioButtonTag` | HTMLのinputタグ(type=radio)出力、入力データ復元、HTMLエスケープ。radiobuttonsタグで表示できないレイアウト時に使用 |
| :ref:`WebView_CheckboxTag` | HTMLのinputタグ(type=checkbox)出力、入力データ復元、HTMLエスケープ。checkboxesタグで表示できないレイアウト時に使用 |
| :ref:`WebView_CompositeKeyRadioButtonTag` | 複数のHTMLのinputタグ(type=radio)出力、入力データ復元、HTMLエスケープ。radioButtonタグで実現できない複合キーを使用する際に使用 |
| :ref:`WebView_CompositeKeyCheckboxTag` | 複数のHTMLのinputタグ(type=checkbox)出力、入力データ復元、HTMLエスケープ。checkboxesタグで実現できない複合キーを使用する際に使用 |
| :ref:`WebView_FileTag` | HTMLのinputタグ(type=file)出力、HTMLエスケープ |
| :ref:`WebView_HiddenTag` | HTMLタグの出力を行わず、ウィンドウスコープに値を出力する |
| :ref:`WebView_PlainHiddenTag` | HTMLのinputタグ(type=hidden)出力、入力データ復元、HTMLエスケープ |
| :ref:`WebView_SelectTag` | HTMLのselectタグとoptionタグ出力、入力データ復元、HTMLエスケープ |
| :ref:`WebView_RadioButtonsTag` | 複数のHTMLのinputタグ(type=radio)出力、入力データ復元、HTMLエスケープ |
| :ref:`WebView_CheckboxesTag` | 複数のHTMLのinputタグ(type=checkbox)出力、入力データ復元、HTMLエスケープ |
| :ref:`WebView_SubmitTag` | HTMLのinputタグ(type=submit,image,button)出力、サブミット制御（ボタンとアクションの紐付け、二重サブミット防止） |
| :ref:`WebView_ButtonTag` | HTMLのbuttonタグ出力、サブミット制御（ボタンとアクションの紐付け、二重サブミット防止） |
| :ref:`WebView_SubmitLinkTag` | HTMLのaタグ出力、サブミット制御（リンクとアクションの紐付け、二重サブミット防止） |
| :ref:`WebView_PopupSubmitTag` | HTMLのinputタグ(type=submit,image,button)出力、新しいウィンドウをオープンしてサブミット。複数ウィンドウを立ち上げたい場合に使用 |
| :ref:`WebView_PopupButtonTag` | HTMLのbuttonタグ出力、新しいウィンドウをオープンしてサブミット。複数ウィンドウを立ち上げたい場合に使用 |
| :ref:`WebView_PopupLinkTag` | HTMLのaタグ出力、新しいウィンドウをオープンしてサブミット。複数ウィンドウを立ち上げたい場合に使用 |
| :ref:`WebView_DownloadSubmitTag` | HTMLのinputタグ(type=submit,image,button)出力、ダウンロード用サブミット |
| :ref:`WebView_DownloadButtonTag` | HTMLのbuttonタグ出力、ダウンロード用サブミット |
| :ref:`WebView_DownloadLinkTag` | HTMLのaタグ出力、ダウンロード用サブミット |
| :ref:`WebView_ParamTag` | サブミット時に追加するパラメータを指定 |
| :ref:`WebView_ChangeParamNameTag` | ポップアップ用サブミット時にパラメータ名を変更 |
| :ref:`WebView_ATag` | HTMLのaタグ出力、コンテキストパスの付加とURLリライト |
| :ref:`WebView_ImgTag` | HTMLのimgタグ出力、コンテキストパスの付加とURLリライト |
| :ref:`WebView_LinkTag` | HTMLのlinkタグ出力、コンテキストパスの付加とURLリライト |
| :ref:`WebView_ScriptTag` | HTMLのscriptタグ出力、コンテキストパスの付加とURLリライト |
| :ref:`WebView_ErrorsTag` | エラーメッセージの複数件表示。画面上部に一覧でエラーメッセージを表示する場合に使用 |
| :ref:`WebView_ErrorTag` | エラーメッセージの表示。エラーの原因となった入力項目の近くに個別表示する場合に使用 |
| :ref:`WebView_NoCacheTag` | ブラウザのキャッシュを防止するmetaタグ出力とレスポンスヘッダ設定 |
| :ref:`WebView_CodeSelectTag` | コード値の選択表示（selectタグ使用） |
| :ref:`WebView_CodeRadioButtonsTag` | コード値の選択表示（inputタグ(type=radio)使用） |
| :ref:`WebView_CodeCheckboxesTag` | コード値の選択表示（inputタグ(type=checkbox)使用） |
| :ref:`WebView_CodeCheckboxTag` | コード値の単一入力項目表示（inputタグ(type=checkbox)使用） |
| :ref:`WebView_CodeTag` | 一覧表示や参照画面でコード値を出力 |
| :ref:`WebView_MessageTag` | 言語に応じたメッセージを出力 |
| :ref:`WebView_ListSearchResultTag` | 検索結果の一覧表示 |
| :ref:`WebView_ListSearchSortSubmitTag` | 検索結果の一覧表示で並び替え対応の列見出しを出力 |
| :ref:`WebView_WriteTag` | 一覧表示や参照画面でオブジェクトから値を出力 |
| :ref:`WebView_PrettyPrintTag` | 修飾系のHTML（\<b\>タグなど）をエスケープせずにオブジェクトの値を出力 |
| :ref:`WebView_RawWriteTag` | HTMLエスケープをせずにオブジェクトの値を直接出力 |
| :ref:`WebView_SetTag` | リクエストスコープの変数に値を設定 |
| :ref:`WebView_IncludeTag` | インクルード先のパスを言語対応のパスに変換してからインクルード |
| :ref:`WebView_IncludeParamTag` | インクルード時に追加するパラメータを指定 |
| :ref:`WebView_ConfirmationPageTag` | JSPが確認画面であることを示す。入力画面へのパスを指定することで入力画面と確認画面を共通化 |
| :ref:`WebView_IgnoreConfirmationTag` | 確認画面である場合に部分的に確認画面の状態を無効化。囲まれた範囲の入力項目は常に入力画面用の出力を行う |
| :ref:`WebView_ForInputPageTag` | 入力画面と確認画面を共通化したJSPで、入力画面のみボディを評価 |
| :ref:`WebView_ForConfirmationPageTag` | 入力画面と確認画面を共通化したJSPで、確認画面のみボディを評価 |

複合キー対応ラジオボタンタグ。:ref:`WebView_GenericAttributesTag`、:ref:`WebView_FocusAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| valueObject | ○ | | XHTMLのvalue属性の代わりに使用するオブジェクト。keyNamesで指定したプロパティを持つ必要がある |
| keyNames | ○ | | 複合キーのキー名（カンマ区切り） |
| namePrefix | ○ | | リクエストパラメータに展開する際のプレフィクス |
| autofocus | | | HTML5のautofocus属性 |
| label | | | チェックありの場合に使用するラベル。入力画面で表示される |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| :ref:`WebView_FocusAttributesTag` | | | |
| name | | | XHTMLのname属性 |
| type | ○ | | XHTMLのtype属性 |
| uri | ○ | | URI。:ref:`WebView_SpecifyUri` を参照 |
| disabled | | | XHTMLのdisabled属性 |
| value | | | XHTMLのvalue属性 |
| src | | | XHTMLのsrc属性 |
| alt | | | XHTMLのalt属性 |
| usemap | | | XHTMLのusemap属性 |
| align | | | XHTMLのalign属性 |
| autofocus | | | HTML5のautofocus属性 |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か。trueで許可、falseで不許可 |
| secure | | | URIをhttpsにするか否か。trueでhttps、falseでhttps化しない |
| displayMethod | | | 表示制御方法。NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| :ref:`WebView_FocusAttributesTag` | | | |
| name | ○ | | XHTMLのname属性 |
| value | | `1` | XHTMLのvalue属性。チェックありの場合に使用するコード値 |
| autofocus | | | HTML5のautofocus属性 |
| codeId | ○ | | コードID |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`/`$SHORTNAME$`/`$OPTIONALNAME$`(使用時はoptionColumnName必須)/`$VALUE$` |
| offCodeValue | | | チェックなしの場合に使用するコード値。未指定時はcodeIdからチェックなしのコード値を検索。検索結果が2件かつ1件がvalue属性の値の場合は残りの1件を使用。見つからない場合はデフォルト値`0`を使用 |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り |

## writeタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する際の名前 |
| withHtmlFormat | | true | HTMLフォーマット（改行と半角スペースの変換）をするか否か。HTMLエスケープする場合のみ有効 |
| valueFormat | | | 出力時フォーマット。`"データタイプ{パターン}"`形式で指定 |

`valueFormat`の対応フォーマット:

| データタイプ | 対象型 | 説明 |
|---|---|---|
| yyyymmdd | 文字列(yyyyMMdd形式またはパターン形式) | 年月日フォーマット。パターンにはjava.text.SimpleDateFormatが規定している構文を指定する。パターン文字はy(年)・M(月)・d(日)のみ指定可能。:ref:`WebView_CustomTagConfig` でデフォルトパターン設定可 |
| yyyymm | 文字列(yyyyMM形式またはパターン形式) | 年月フォーマット。使用方法はyyyymmddと同様 |
| dateTime | java.util.Date | 日時フォーマット（**writeタグのみ使用可**）。ThreadContextのタイムゾーンを使用。区切り文字`\|`でパターンにタイムゾーンを直接指定可。:ref:`WebView_CustomTagConfig` でデフォルトパターンと区切り文字変更可 |
| decimal | java.lang.Number または数字文字列 | 10進数フォーマット。文字列の場合、言語に対応する1000の区切り文字を取り除いた後でフォーマットされる。パターンにはjava.text.DecimalFormatが規定している構文を指定する。ThreadContextの言語を使用。区切り文字`\|`でパターンに言語を直接指定可。:ref:`WebView_CustomTagConfig` で区切り文字変更可 |

`valueFormat`指定例:

```bash
# yyyymmdd: デフォルトパターン
valueFormat="yyyymmdd"
# yyyymmdd: パターン指定
valueFormat="yyyymmdd{yyyy/MM/dd}"

# datetime: デフォルトパターン+ThreadContextタイムゾーン
valueFormat="datetime"
# datetime: タイムゾーンのみ指定
valueFormat="datetime{|Asia/Tokyo}"
# datetime: パターンのみ指定
valueFormat="datetime{yy/MM/dd HH:mm:ss}"
# datetime: パターン+タイムゾーン指定
valueFormat="datetime{yy/MM/dd HH:mm:ss|Asia/Tokyo}"

# decimal: パターンのみ指定
valueFormat="decimal{###,###,###.000}"
# decimal: パターン+言語指定
valueFormat="decimal{###,###,###.000|ja}"
```

<details>
<summary>keywords</summary>

formタグ, textタグ, textareaタグ, passwordタグ, radioButtonタグ, checkboxタグ, fileタグ, hiddenタグ, selectタグ, buttonタグ, errorsタグ, writeタグ, submitタグ, codeSelectタグ, listSearchResultタグ, confirmationPageタグ, WebView_FormTag, WebView_TextTag, WebView_TextareaTag, WebView_PasswordTag, WebView_RadioButtonTag, WebView_CheckboxTag, WebView_CompositeKeyRadioButtonTag, WebView_CompositeKeyCheckboxTag, WebView_FileTag, WebView_HiddenTag, WebView_PlainHiddenTag, WebView_SelectTag, WebView_RadioButtonsTag, WebView_CheckboxesTag, WebView_SubmitTag, WebView_ButtonTag, WebView_SubmitLinkTag, WebView_PopupSubmitTag, WebView_PopupButtonTag, WebView_PopupLinkTag, WebView_DownloadSubmitTag, WebView_DownloadButtonTag, WebView_DownloadLinkTag, WebView_ParamTag, WebView_ChangeParamNameTag, WebView_ATag, WebView_ImgTag, WebView_LinkTag, WebView_ScriptTag, WebView_ErrorsTag, WebView_ErrorTag, WebView_NoCacheTag, WebView_CodeSelectTag, WebView_CodeRadioButtonsTag, WebView_CodeCheckboxesTag, WebView_CodeCheckboxTag, WebView_CodeTag, WebView_MessageTag, WebView_ListSearchResultTag, WebView_ListSearchSortSubmitTag, WebView_WriteTag, WebView_PrettyPrintTag, WebView_RawWriteTag, WebView_SetTag, WebView_IncludeTag, WebView_IncludeParamTag, WebView_ConfirmationPageTag, WebView_IgnoreConfirmationTag, WebView_ForInputPageTag, WebView_ForConfirmationPageTag, 二重サブミット防止, 入力データ復元, HTMLエスケープ, サブミット制御, コード値選択, popupSubmit, downloadSubmit, ウィンドウスコープ, URLリライト, エラーメッセージ表示, キャッシュ防止, 並び替え, インクルード, 確認画面, compositeKeyRadioButton, 複合キー, ラジオボタン, valueObject, keyNames, namePrefix, nameAlias, errorCss, allowDoubleSubmission, ダウンロード送信, displayMethod, codeCheckbox, name, value, codeId, optionColumnName, labelPattern, offCodeValue, disabled, onchange, autofocus, コードチェックボックス単体, チェックなしコード値, write, valueFormat, withHtmlFormat, yyyymmdd, yyyymm, dateTime, decimal, 日時フォーマット, 10進数フォーマット, 値の出力, SimpleDateFormat, DecimalFormat

</details>

## 全てのHTMLタグ

全てのHTMLタグに共通する属性（:ref:`WebView_GenericAttributesTag`）。

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

ファイルアップロード用inputタグ。:ref:`WebView_GenericAttributesTag`、:ref:`WebView_FocusAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性 |
| readonly | | | XHTMLのreadonly属性 |
| size | | | XHTMLのsize属性 |
| maxlength | | | XHTMLのmaxlength属性 |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| accept | | | XHTMLのaccept属性 |
| autofocus | | | HTML5のautofocus属性 |
| multiple | | | HTML5のmultiple属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| :ref:`WebView_FocusAttributesTag` | | | |
| name | | | XHTMLのname属性 |
| uri | ○ | | URI。:ref:`WebView_SpecifyUri` を参照 |
| value | | | XHTMLのvalue属性 |
| type | | | XHTMLのtype属性 |
| disabled | | | XHTMLのdisabled属性 |
| autofocus | | | HTML5のautofocus属性 |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か。trueで許可、falseで不許可 |
| secure | | | URIをhttpsにするか否か。trueでhttps、falseでhttps化しない |
| displayMethod | | | 表示制御方法。NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | 表示対象のコード値を変数スコープから取得する名前。省略した場合はcodeIdとpatternで絞り込んだコード一覧を表示 |
| codeId | ○ | | コードID |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`/`$SHORTNAME$`/`$OPTIONALNAME$`(使用時はoptionColumnName必須)/`$VALUE$` |
| listFormat | | `br` | リスト表示フォーマット: `br`/`div`/`span`/`ul`/`ol`/`sp`(スペース区切り) |

## prettyPrintタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する際の名前 |

<details>
<summary>keywords</summary>

全HTMLタグ共通属性, id, cssClass, style, title, lang, xmlLang, dir, onclick, ondblclick, onmousedown, onmouseup, onmouseover, onmousemove, onmouseout, onkeypress, onkeydown, onkeyup, WebView共通属性, WebView_GenericAttributesTag, file, ファイルアップロード, multiple, accept, maxlength, size, nameAlias, errorCss, downloadButton, allowDoubleSubmission, 二重サブミット防止, ダウンロードボタン, displayMethod, code, name, codeId, pattern, optionColumnName, labelPattern, listFormat, コード値表示, コードID, ラベルパターン, prettyPrint, 整形出力, 値の表示

</details>

## フォーカスを取得可能なHTMLタグ

フォーカスを取得可能なHTMLタグに共通する属性（:ref:`WebView_FocusAttributesTag`）。

| 属性 | 説明 |
|---|---|
| accesskey | XHTMLのaccesskey属性 |
| tabindex | XHTMLのtabindex属性 |
| onfocus | XHTMLのonfocus属性 |
| onblur | XHTMLのonblur属性 |

HTMLタグの出力を行わず、ウィンドウスコープに値を出力する。:ref:`WebView_GenericAttributesTag`、:ref:`WebView_FocusAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性 |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| :ref:`WebView_FocusAttributesTag` | | | |
| name | | | XHTMLのname属性 |
| uri | ○ | | URI。:ref:`WebView_SpecifyUri` を参照 |
| shape | | | XHTMLのshape属性 |
| coords | | | XHTMLのcoords属性 |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か。trueで許可、falseで不許可 |
| secure | | | URIをhttpsにするか否か。trueでhttps、falseでhttps化しない |
| displayMethod | | | 表示制御方法。NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messageId | ○ | | メッセージID |
| option0～option9 | | | メッセージフォーマットに使用するオプション引数（インデックス0～9、最大10個） |
| language | | スレッドコンテキストの言語 | メッセージの言語 |
| var | | | リクエストスコープに格納する変数名。指定された場合はメッセージを出力せずリクエストスコープに設定。HTMLエスケープとHTMLフォーマットは行わない |
| htmlEscape | | `true` | HTMLエスケープをするか否か |
| withHtmlFormat | | `true` | HTMLフォーマット（改行と半角スペースの変換）をするか否か。htmlEscape=trueの場合のみ有効 |

## rawWriteタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する際の名前 |

<details>
<summary>keywords</summary>

フォーカス属性, accesskey, tabindex, onfocus, onblur, WebView_FocusAttributesTag, hidden, ウィンドウスコープ, HTMLタグ出力なし, name, disabled, downloadLink, allowDoubleSubmission, 二重サブミット防止, ダウンロードリンク, displayMethod, message, messageId, option0, language, var, htmlEscape, withHtmlFormat, メッセージ表示, HTMLエスケープ, HTMLフォーマット, rawWrite, 生値出力, HTMLエスケープなし出力

</details>

## formタグ

**formタグ**（:ref:`WebView_FormTag`）の属性。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 全HTMLタグ共通属性 |
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
| windowScopePrefixes | | | ウィンドウスコープ変数のプレフィックス（複数指定はカンマ区切り）。指定されたプレフィックスがマッチするリクエストパラメータをhiddenタグとして出力する |
| useToken | | false | トークンを設定するか否か。trueの場合設定、falseの場合設定しない。confirmationPageタグが指定された場合はデフォルトがtrueとなる |
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |

plainHiddenタグ。:ref:`WebView_GenericAttributesTag`、:ref:`WebView_FocusAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性 |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| paramName | ○ | | サブミット時に使用するパラメータの名前 |
| name | | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する |
| value | | | 値。直接値を指定する場合に使用する。name属性とvalue属性のどちらか一方を指定する |

listSearchResultタグでは、画面要素毎に属性を示す。

![ページング付きテーブルのレイアウト](../../../knowledge/component/libraries/assets/libraries-07_TagReference/WebView_ListSearchResultPagingTableFull.jpg)

## setタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| var | ○ | | リクエストスコープに格納する際に使用する変数名 |
| name | | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する |
| value | | | 値。直接値を指定する場合に使用する。name属性とvalue属性のどちらか一方を指定する |
| scope | | リクエストスコープ | 変数を格納するスコープ。`page`（ページスコープ）/ `request`（リクエストスコープ） |
| bySingleValue | | true | name属性に対応する値を単一値として取得するか否か |

<details>
<summary>keywords</summary>

formタグ, useToken, windowScopePrefixes, secure, 二重サブミット防止, トークン, ウィンドウスコープ, confirmationPage, autocomplete, plainHidden, hidden, name, disabled, param, paramName, サブミットパラメータ, パラメータ指定, listSearchResult, 検索結果一覧, ページング, 件数表示, ページング付きテーブル, set, var, scope, bySingleValue, リクエストスコープ格納, ページスコープ, 変数スコープ設定

</details>

## textタグ

**textタグ**（:ref:`WebView_TextTag`）の属性。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 全HTMLタグ共通属性 |
| :ref:`WebView_FocusAttributesTag` | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性 |
| readonly | | | XHTMLのreadonly属性 |
| size | | | XHTMLのsize属性 |
| maxlength | | | XHTMLのmaxlength属性 |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性 |
| placeholder | | | HTML5のplaceholder属性 |
| errorCss | | "nablarch_error" | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |
| valueFormat | | | 出力時のフォーマット。"データタイプ{パターン}"形式で指定 |

**valueFormat の詳細**:

- `yyyymmdd`: 年月日のフォーマット。値はyyyyMMdd形式またはパターン形式の文字列を指定する。パターンにはjava.text.SimpleDateFormatの構文を指定。**パターン文字には、y(年)、M(月)、d(月における日)のみ指定可能。** :ref:`WebView_CustomTagConfig` を使用してパターンのデフォルト値を設定可能。
  - 指定例: `valueFormat="yyyymmdd"` / `valueFormat="yyyymmdd{yyyy/MM/dd}"`
  - > **注意**: valueFormat属性を指定した場合、入力画面にもフォーマットした値が出力される。入力された年月日をアクションで取得する場合は :ref:`ExtendedValidation_yyyymmddConvertor` を使用する。textタグとコンバータが連携し、valueFormat属性に指定されたパターンを使用した値変換と入力精査を行う。

- `yyyymm`: 年月のフォーマット。値はyyyyMM形式またはパターン形式の文字列を指定する。使用方法はyyyymmddと同様。
  - > **注意**: コンバータには :ref:`ExtendedValidation_yyyymmConvertor` を使用する。

- `decimal`: 10進数のフォーマット。値はjava.lang.Number型または数字の文字列を指定する。文字列の場合、言語に対応する1000の区切り文字を取り除いた後でフォーマットされる。パターンにはjava.text.DecimalFormatの構文を指定。ThreadContextに設定された言語を使用して言語に応じた形式で値が出力される。区切り文字"|"を使用してパターンに直接言語を指定可能。:ref:`WebView_CustomTagConfig` を使用して区切り文字"|"の変更可。
  - 指定例: `valueFormat="decimal{###,###,###.000}"` / `valueFormat="decimal{###,###,###.000|ja}"`
  - > **注意**: valueFormat属性を指定した場合、入力画面にもフォーマットした値が出力される。入力された数値をアクションで取得する場合は [数値コンバータ(BigDecimalConvertor、IntegerConvertor、LongConvertor)](libraries-validation_basic_validators.md) を使用する。textタグと数値コンバータが連携し、valueFormat属性に指定された言語に対応する値変換と入力精査を行う。

セレクトボックスタグ。:ref:`WebView_GenericAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択項目のリストの属性名 |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| size | | | XHTMLのsize属性 |
| multiple | | | XHTMLのmultiple属性 |
| disabled | | | XHTMLのdisabled属性 |
| tabindex | | | XHTMLのtabindex属性 |
| onfocus | | | XHTMLのonfocus属性 |
| onblur | | | XHTMLのonblur属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性 |
| elementLabelPattern | | $LABEL$ | ラベルを整形するパターン。プレースホルダ: $LABEL$（ラベル）、$VALUE$（値）。例: "$VALUE$ - $LABEL$" → "G001 - グループ1" |
| listFormat | | br | リスト表示時のフォーマット。br/div/span/ul/ol/sp（スペース区切り）から選択 |
| withNoneOption | | false | リスト先頭に選択なしオプションを追加するか否か |
| noneOptionLabel | | "" | 選択なしオプションのラベル（withNoneOption=trueの場合のみ有効） |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| paramName | ○ | | サブミット時に使用するパラメータの名前 |
| inputName | ○ | | 変更元となる元画面のinput要素のname属性 |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| listSearchInfoName | | | ListSearchInfoをリクエストスコープから取得する名前。指定なしの場合は「検索結果件数」と「ページング」を表示しない。一覧表示のみの場合（一括削除確認画面など）は指定しない |
| listSearchResultWrapperCss | | `nablarch_listSearchResultWrapper` | ページング付きテーブル全体（検索結果件数、ページング、検索結果）をラップするdivタグのclass属性 |

## includeタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| path | ○ | | インクルード先のパス |

<details>
<summary>keywords</summary>

textタグ, valueFormat, yyyymmdd, yyyymm, decimal, errorCss, nameAlias, ExtendedValidation_yyyymmddConvertor, ExtendedValidation_yyyymmConvertor, DecimalFormat, SimpleDateFormat, WebView_CustomTagConfig, select, セレクトボックス, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, withNoneOption, noneOptionLabel, $LABEL$, $VALUE$, changeParamName, paramName, inputName, パラメータ名変更, listSearchInfoName, listSearchResultWrapperCss, ListSearchInfo, listSearchResult全体属性, 検索結果件数非表示, include, ファイルインクルード, path, インクルード

</details>

## textareaタグ

**textareaタグ**（:ref:`WebView_TextareaTag`）の属性。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 全HTMLタグ共通属性 |
| :ref:`WebView_FocusAttributesTag` | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| rows | ○ | | XHTMLのrows属性 |
| cols | ○ | | XHTMLのcols属性 |
| disabled | | | XHTMLのdisabled属性 |
| readonly | | | XHTMLのreadonly属性 |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性 |
| placeholder | | | HTML5のplaceholder属性 |
| maxlength | | | HTML5のmaxlength属性 |
| errorCss | | "nablarch_error" | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |

ラジオボタングループタグ。:ref:`WebView_GenericAttributesTag`（id属性は指定不可）、:ref:`WebView_FocusAttributesTag`（accesskey属性は指定不可）の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択項目のリストの属性名 |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性。先頭要素のみ出力される |
| elementLabelPattern | | $LABEL$ | ラベルを整形するパターン。プレースホルダ: $LABEL$（ラベル）、$VALUE$（値） |
| listFormat | | br | リスト表示時のフォーマット。br/div/span/ul/ol/sp（スペース区切り）から選択 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| :ref:`WebView_FocusAttributesTag` | | | |
| charset | | | XHTMLのcharset属性 |
| type | | | XHTMLのtype属性 |
| name | | | XHTMLのname属性 |
| href | | | XHTMLのhref属性。:ref:`WebView_SpecifyUri` を参照 |
| hreflang | | | XHTMLのhreflang属性 |
| rel | | | XHTMLのrel属性 |
| rev | | | XHTMLのrev属性 |
| shape | | | XHTMLのshape属性 |
| coords | | | XHTMLのcoords属性 |
| target | | | XHTMLのtarget属性 |
| secure | | | URIをhttpsにするか否か。trueでhttps、falseでhttps化しない |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| useResultCount | | `true` | 検索結果件数を表示するか否か |
| resultCountCss | | `nablarch_resultCount` | 検索結果件数をラップするdivタグのclass属性 |
| resultCountFragment | | `検索結果 <resultCount>件` | 検索結果件数を出力するJSPフラグメント（デフォルト: 「検索結果 <PagingInfoのresultCountプロパティ>件」） |

## includeParamタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| paramName | ○ | | インクルード時に使用するパラメータの名前 |
| name | | | 値を取得する名前。name属性とvalue属性のどちらか一方を指定 |
| value | | | 値を直接指定する場合に使用。name属性とvalue属性のどちらか一方を指定 |

<details>
<summary>keywords</summary>

textareaタグ, rows, cols, maxlength, placeholder, errorCss, nameAlias, autofocus, radioButtons, ラジオボタン, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, $LABEL$, $VALUE$, aタグ, href, secure, hreflang, リンク, URI指定, useResultCount, resultCountCss, resultCountFragment, 検索結果件数表示, PagingInfo, resultCount, includeParam, インクルードパラメータ, paramName, インクルード時パラメータ

</details>

## passwordタグ

**passwordタグ**（:ref:`WebView_PasswordTag`）の属性。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 全HTMLタグ共通属性 |
| :ref:`WebView_FocusAttributesTag` | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性 |
| readonly | | | XHTMLのreadonly属性 |
| size | | | XHTMLのsize属性 |
| maxlength | | | XHTMLのmaxlength属性 |
| onselect | | | XHTMLのonselect属性 |
| onchange | | | XHTMLのonchange属性 |
| autocomplete | | | HTML5のautocomplete属性 |
| autofocus | | | HTML5のautofocus属性 |
| placeholder | | | HTML5のplaceholder属性 |
| restoreValue | | false | 入力画面の再表示時に入力データを復元するか否か。復元する場合はtrue、復元しない場合はfalse |
| replacement | | '*' | 確認画面用の出力時に使用する置換文字 |
| errorCss | | "nablarch_error" | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |

チェックボックスグループタグ。:ref:`WebView_GenericAttributesTag`（id属性は指定不可）、:ref:`WebView_FocusAttributesTag`（accesskey属性は指定不可）の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択項目のリストの属性名 |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性。先頭要素のみ出力される |
| elementLabelPattern | | $LABEL$ | ラベルを整形するパターン。プレースホルダ: $LABEL$（ラベル）、$VALUE$（値） |
| listFormat | | br | リスト表示時のフォーマット。br/div/span/ul/ol/sp（スペース区切り）から選択 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| src | ○ | | XHTMLのcharsrc属性。:ref:`WebView_SpecifyUri` を参照 |
| alt | ○ | | XHTMLのalt属性 |
| name | | | XHTMLのname属性 |
| longdesc | | | XHTMLのlongdesc属性 |
| height | | | XHTMLのheight属性 |
| width | | | XHTMLのwidth属性 |
| usemap | | | XHTMLのusemap属性 |
| ismap | | | XHTMLのismap属性 |
| align | | | XHTMLのalign属性 |
| border | | | XHTMLのborder属性 |
| hspace | | | XHTMLのhspace属性 |
| vspace | | | XHTMLのvspace属性 |
| secure | | | URIをhttpsにするか否か。trueでhttps、falseでhttps化しない |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| usePaging | | `true` | ページングを表示するか否か |
| searchUri | | | ページングのサブミット要素に使用するURI。ページングを表示する場合は必ず指定すること |
| pagingPosition | | `top` | ページングの表示位置: `top`(上側のみ)/`bottom`(下側のみ)/`both`(両方)/`none`(表示なし) |
| pagingCss | | `nablarch_paging` | ページングのサブミット要素全体をラップするdivタグのclass属性 |

## confirmationPageタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| path | | | フォワード先（入力画面）のパス |

<details>
<summary>keywords</summary>

passwordタグ, restoreValue, replacement, 確認画面, errorCss, nameAlias, autocomplete, checkboxes, チェックボックスグループ, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, $LABEL$, $VALUE$, imgタグ, src, alt, secure, 画像表示, usePaging, searchUri, pagingPosition, pagingCss, ページング表示, 表示位置, top, bottom, both, none, confirmationPage, フォワード, 入力画面フォワード

</details>

## radioButtonタグ

**radioButtonタグ**（:ref:`WebView_RadioButtonTag`）の属性。radiobuttonsタグで表示できないレイアウト時に使用する。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 全HTMLタグ共通属性 |
| :ref:`WebView_FocusAttributesTag` | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| value | ○ | | XHTMLのvalue属性 |
| label | ○ | | ラベル |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性 |
| errorCss | | "nablarch_error" | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |

サブミットボタンタグ。:ref:`WebView_GenericAttributesTag`、:ref:`WebView_FocusAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| type | ○ | | XHTMLのtype属性 |
| uri | ○ | | URI（:ref:`WebView_SpecifyUri` 参照） |
| disabled | | | XHTMLのdisabled属性 |
| value | | | XHTMLのvalue属性 |
| src | | | XHTMLのsrc属性 |
| alt | | | XHTMLのalt属性 |
| usemap | | | XHTMLのusemap属性 |
| align | | | XHTMLのalign属性 |
| autofocus | | | HTML5のautofocus属性 |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か |
| secure | | | URIをhttpsにするか否か |
| displayMethod | | | 認可判定・開閉局判定の結果に応じた表示方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示）から選択 |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| charset | | | XHTMLのcharset属性 |
| href | | | XHTMLのhref属性。:ref:`WebView_SpecifyUri` を参照 |
| hreflang | | | XHTMLのhreflang属性 |
| type | | | XHTMLのtype属性 |
| rel | | | XHTMLのrel属性 |
| rev | | | XHTMLのrev属性 |
| media | | | XHTMLのmedia属性 |
| target | | | XHTMLのtarget属性 |
| secure | | | URIをhttpsにするか否か。trueでhttps、falseでhttps化しない |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| useCurrentPageNumber | | `true` | 現在のページ番号を使用するか否か |
| currentPageNumberCss | | `nablarch_currentPageNumber` | 現在のページ番号をラップするdivタグのclass属性 |
| currentPageNumberFragment | | `[currentPageNumber/pageCountページ]` | 現在のページ番号を出力するJSPフラグメント（デフォルト: 「[<PagingInfoのcurrentPageNumberプロパティ>/<PagingInfoのpageCountプロパティ>ページ]」） |

## ignoreConfirmationタグ

属性なし。

<details>
<summary>keywords</summary>

radioButtonタグ, radioButton, label, nameAlias, errorCss, autofocus, value, submit, サブミット, allowDoubleSubmission, displayMethod, uri, secure, NODISPLAY, DISABLED, NORMAL, linkタグ, href, rel, 外部リソース読み込み, useCurrentPageNumber, currentPageNumberCss, currentPageNumberFragment, 現在ページ番号表示, PagingInfo, currentPageNumber, pageCount, ignoreConfirmation, 確認画面スキップ, 確認ページ無視

</details>

## checkboxタグ

**checkboxタグ**（:ref:`WebView_CheckboxTag`）の属性。checkboxesタグで表示できないレイアウト時に使用する。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 全HTMLタグ共通属性 |
| :ref:`WebView_FocusAttributesTag` | | | フォーカス属性 |
| name | ○ | | XHTMLのname属性 |
| value | | "1" | XHTMLのvalue属性。チェックありの場合に使用する値 |
| autofocus | | | HTML5のautofocus属性 |
| label | | | チェックありの場合に使用するラベル。入力画面ではこのラベルが表示される |
| useOffValue | | true | チェックなしの値設定を使用するか否か |
| offLabel | | | チェックなしの場合に使用するラベル |
| offValue | | "0" | チェックなしの場合に使用する値 |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | "nablarch_error" | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（複数指定はカンマ区切り） |

ボタンタグ。:ref:`WebView_GenericAttributesTag`、:ref:`WebView_FocusAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI（:ref:`WebView_SpecifyUri` 参照） |
| value | | | XHTMLのvalue属性 |
| type | | | XHTMLのtype属性 |
| disabled | | | XHTMLのdisabled属性 |
| autofocus | | | HTML5のautofocus属性 |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か |
| secure | | | URIをhttpsにするか否か |
| displayMethod | | | 認可判定・開閉局判定の結果に応じた表示方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示）から選択 |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| type | ○ | | XHTMLのtype属性 |
| id | | | XHTMLのid属性 |
| charset | | | XHTMLのcharset属性 |
| language | | | XHTMLのlanguage属性 |
| src | | | XHTMLのsrc属性。:ref:`WebView_SpecifyUri` を参照 |
| defer | | | XHTMLのdefer属性 |
| xmlSpace | | | XHTMLのxml:space属性 |
| secure | | | URIをhttpsにするか否か。trueでhttps、falseでhttps化しない |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| useFirstSubmit | | `false` | 最初のページに遷移するサブミットを使用するか否か |
| firstSubmitTag | | `submitLink` | 使用するNablarchタグ: `submitLink`(aタグ)/`submit`(inputタグ)/`button`(buttonタグ) |
| firstSubmitType | | | タグのtype属性 (`submit`/`button`)。firstSubmitTagがsubmitLinkの場合は使用しない |
| firstSubmitCss | | `nablarch_firstSubmit` | ラップするdivタグのclass属性 |
| firstSubmitLabel | | `最初` | ラベル |
| firstSubmitName | | `firstSubmit` | name属性。表示位置のサフィックス(`_top`/`_bottom`)を付けて出力（例: `firstSubmit_top`） |

## forInputPageタグ

属性なし。

<details>
<summary>keywords</summary>

checkboxタグ, useOffValue, offValue, offLabel, value, label, nameAlias, errorCss, autofocus, button, ボタン, allowDoubleSubmission, displayMethod, uri, secure, NODISPLAY, DISABLED, NORMAL, scriptタグ, src, defer, xmlSpace, JavaScript読み込み, useFirstSubmit, firstSubmitTag, firstSubmitType, firstSubmitCss, firstSubmitLabel, firstSubmitName, 最初のページ, ページナビゲーション, submitLink, forInputPage, 入力画面, 入力ページ条件

</details>

## submitLinkタグ

サブミットリンクタグ。:ref:`WebView_GenericAttributesTag`、:ref:`WebView_FocusAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI（:ref:`WebView_SpecifyUri` 参照） |
| shape | | | XHTMLのshape属性 |
| coords | | | XHTMLのcoords属性 |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か |
| secure | | | URIをhttpsにするか否か |
| displayMethod | | | 認可判定・開閉局判定の結果に応じた表示方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示）から選択 |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| cssClass | | nablarch_errors | リスト表示においてulタグに使用するCSSクラス名 |
| infoCss | | nablarch_info | 情報レベルのメッセージに使用するCSSクラス名 |
| warnCss | | nablarch_warn | 警告レベルのメッセージに使用するCSSクラス名 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| filter | | all | リストに含めるメッセージのフィルタ条件。all（全メッセージ表示）/ global（入力項目に対応しないメッセージのみ表示。ValidationResultMessageのプロパティ名が含まれるメッセージを除外） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| usePrevSubmit | | `true` | 前のページに遷移するサブミットを使用するか否か |
| prevSubmitTag | | `submitLink` | 使用するNablarchタグ: `submitLink`(aタグ)/`submit`(inputタグ)/`button`(buttonタグ) |
| prevSubmitType | | | タグのtype属性 (`submit`/`button`)。prevSubmitTagがsubmitLinkの場合は使用しない |
| prevSubmitCss | | `nablarch_prevSubmit` | ラップするdivタグのclass属性 |
| prevSubmitLabel | | `前へ` | ラベル |
| prevSubmitName | | `prevSubmit` | name属性。表示位置のサフィックス(`_top`/`_bottom`)を付けて出力（例: `prevSubmit_top`） |

## forConfirmationPageタグ

属性なし。

<details>
<summary>keywords</summary>

submitLink, サブミットリンク, allowDoubleSubmission, displayMethod, uri, shape, coords, secure, errors, cssClass, infoCss, warnCss, errorCss, filter, バリデーションエラー表示, ValidationResultMessage, global, usePrevSubmit, prevSubmitTag, prevSubmitType, prevSubmitCss, prevSubmitLabel, prevSubmitName, 前のページ, ページナビゲーション, forConfirmationPage, 確認画面, 確認ページ条件

</details>

## popupSubmitタグ

ポップアップサブミットタグ。:ref:`WebView_GenericAttributesTag`、:ref:`WebView_FocusAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| type | ○ | | XHTMLのtype属性 |
| uri | ○ | | URI（:ref:`WebView_SpecifyUri` 参照） |
| disabled | | | XHTMLのdisabled属性 |
| value | | | XHTMLのvalue属性 |
| src | | | XHTMLのsrc属性 |
| alt | | | XHTMLのalt属性 |
| usemap | | | XHTMLのusemap属性 |
| align | | | XHTMLのalign属性 |
| autofocus | | | HTML5のautofocus属性 |
| secure | | | URIをhttpsにするか否か |
| popupWindowName | | | ポップアップのウィンドウ名。window.open関数の第2引数に指定 |
| popupOption | | | ポップアップのオプション情報。window.open関数の第3引数に指定 |
| displayMethod | | | 認可判定・開閉局判定の結果に応じた表示方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示）から選択 |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | エラーメッセージを表示する入力項目のname属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| messageFormat | | div | メッセージ表示時に使用するフォーマット。div（divタグ）/ span（spanタグ） |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| usePageNumberSubmit | | `false` | ページ番号のページに遷移するサブミットを使用するか否か |
| pageNumberSubmitTag | | `submitLink` | 使用するNablarchタグ: `submitLink`(aタグ)/`submit`(inputタグ)/`button`(buttonタグ) |
| pageNumberSubmitType | | | タグのtype属性 (`submit`/`button`)。pageNumberSubmitTagがsubmitLinkの場合は使用しない |
| pageNumberSubmitCss | | `nablarch_pageNumberSubmit` | ラップするdivタグのclass属性 |
| pageNumberSubmitName | | `pageNumberSubmit` | name属性。ページ番号と表示位置のサフィックスを付けて出力（例: `pageNumberSubmit3_top`） |

<details>
<summary>keywords</summary>

popupSubmit, ポップアップ, popupWindowName, popupOption, displayMethod, window.open, secure, uri, error, name, messageFormat, errorCss, エラーメッセージ表示, usePageNumberSubmit, pageNumberSubmitTag, pageNumberSubmitType, pageNumberSubmitCss, pageNumberSubmitName, ページ番号ナビゲーション, サフィックス

</details>

## popupButtonタグ

ポップアップボタンタグ。:ref:`WebView_GenericAttributesTag`、:ref:`WebView_FocusAttributesTag` の属性を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI（:ref:`WebView_SpecifyUri` 参照） |
| value | | | XHTMLのvalue属性 |
| type | | | XHTMLのtype属性 |
| disabled | | | XHTMLのdisabled属性 |
| autofocus | | | HTML5のautofocus属性 |
| secure | | | URIをhttpsにするか否か |
| popupWindowName | | | ポップアップのウィンドウ名。window.open関数の第2引数に指定 |
| popupOption | | | ポップアップのオプション情報。window.open関数の第3引数に指定 |
| displayMethod | | | 認可判定・開閉局判定の結果に応じた表示方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示）から選択 |

属性なし。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| useNextSubmit | | `true` | 次のページに遷移するサブミットを使用するか否か |
| nextSubmitTag | | `submitLink` | 使用するNablarchタグ: `submitLink`(aタグ)/`submit`(inputタグ)/`button`(buttonタグ) |
| nextSubmitType | | | タグのtype属性 (`submit`/`button`)。nextSubmitTagがsubmitLinkの場合は使用しない |
| nextSubmitCss | | `nablarch_nextSubmit` | ラップするdivタグのclass属性 |
| nextSubmitLabel | | `次へ` | ラベル |
| nextSubmitName | | `nextSubmit` | name属性。表示位置のサフィックス(`_top`/`_bottom`)を付けて出力（例: `nextSubmit_top`） |

<details>
<summary>keywords</summary>

popupButton, ポップアップボタン, popupWindowName, popupOption, displayMethod, window.open, secure, uri, noCache, キャッシュ無効化, useNextSubmit, nextSubmitTag, nextSubmitType, nextSubmitCss, nextSubmitLabel, nextSubmitName, 次のページ, ページナビゲーション

</details>

## codeSelectタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| name | ○ | | XHTMLのname属性 |
| codeId | ○ | | コードID |
| size | | | XHTMLのsize属性 |
| multiple | | | XHTMLのmultiple属性 |
| disabled | | | XHTMLのdisabled属性 |
| tabindex | | | XHTMLのtabindex属性 |
| onfocus | | | XHTMLのonfocus属性 |
| onblur | | | XHTMLのonblur属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性 |
| pattern | | （指定なし） | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | $NAME$ | ラベル整形パターン。プレースホルダ: $NAME$（コード名称）/ $SHORTNAME$（略称）/ $OPTIONALNAME$（オプション名称、optionColumnName指定が必須）/ $VALUE$（コード値） |
| listFormat | | br | リスト表示時のフォーマット。br / div / span / ul / ol / sp（スペース区切り） |
| withNoneOption | | false | リスト先頭に選択なしオプションを追加するか否か。trueで追加 |
| noneOptionLabel | | （空文字） | withNoneOptionがtrueの場合に使用する選択なしオプションのラベル |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| useLastSubmit | | `false` | 最後のページに遷移するサブミットを使用するか否か |
| lastSubmitTag | | `submitLink` | 使用するNablarchタグ: `submitLink`(aタグ)/`submit`(inputタグ)/`button`(buttonタグ) |
| lastSubmitType | | | タグのtype属性 (`submit`/`button`)。lastSubmitTagがsubmitLinkの場合は使用しない |
| lastSubmitCss | | `nablarch_lastSubmit` | ラップするdivタグのclass属性 |
| lastSubmitLabel | | `最後` | ラベル |
| lastSubmitName | | `lastSubmit` | name属性。表示位置のサフィックス(`_top`/`_bottom`)を付けて出力（例: `lastSubmit_top`） |

<details>
<summary>keywords</summary>

codeSelect, codeId, labelPattern, listFormat, withNoneOption, noneOptionLabel, optionColumnName, nameAlias, errorCss, コードリスト, セレクトボックス, useLastSubmit, lastSubmitTag, lastSubmitType, lastSubmitCss, lastSubmitLabel, lastSubmitName, 最後のページ, ページナビゲーション

</details>

## codeRadioButtonsタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | id属性は指定不可 |
| :ref:`WebView_FocusAttributesTag` | | | accesskey属性は指定不可 |
| name | ○ | | XHTMLのname属性 |
| codeId | ○ | | コードID |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性。先頭要素のみ出力される |
| pattern | | （指定なし） | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | $NAME$ | ラベル整形パターン。プレースホルダ: $NAME$（コード名称）/ $SHORTNAME$（略称）/ $OPTIONALNAME$（オプション名称、optionColumnName指定が必須）/ $VALUE$（コード値） |
| listFormat | | br | リスト表示時のフォーマット。br / div / span / ul / ol / sp（スペース区切り） |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| resultSetName | ○ | | 検索結果をリクエストスコープから取得する名前 |
| resultSetCss | | `nablarch_resultSet` | 検索結果テーブルのclass属性 |
| headerRowFragment | ○ | | ヘッダ行のJSPフラグメント |
| bodyRowFragment | ○ | | ボディ行のJSPフラグメント |
| varRowName | | `row` | ボディ行のフラグメントで行データ（c:forEachのvar属性）を参照する変数名 |
| varStatusName | | `status` | ボディ行のフラグメントでステータス（c:forEachのstatus属性）を参照する変数名 |
| varCountName | | `count` | ステータスのcountプロパティを参照する変数名 |
| varRowCountName | | `rowCount` | 検索結果のカウント（検索結果取得開始位置＋ステータスのカウント）を参照する変数名 |
| varOddEvenName | | `oddEvenCss` | ボディ行のclass属性を参照する変数名。1行おきにclass属性を変更したい場合に使用 |
| oddValue | | `nablarch_odd` | 奇数行のclass属性 |
| evenValue | | `nablarch_even` | 偶数行のclass属性 |

> **注意**: `varStatusName`で参照するステータスに`n:write`タグでアクセスするとエラーが発生する。`n:set`タグを使用してアクセスすること。使用例:
> ```jsp
> <n:set var="rowCount" value="${status.count}" />
> <n:write name="rowCount" />
> ```

<details>
<summary>keywords</summary>

codeRadioButtons, codeId, labelPattern, listFormat, optionColumnName, nameAlias, errorCss, コードリスト, ラジオボタン, resultSetName, resultSetCss, headerRowFragment, bodyRowFragment, varRowName, varStatusName, varCountName, varRowCountName, varOddEvenName, oddValue, evenValue, 検索結果テーブル, 行データ変数, 奇数偶数行CSS

</details>
