# タグリファレンス

## カスタムタグ一覧

Nablarch WebViewが提供するカスタムタグの一覧。

| タグ | 機能 |
|---|---|
| :ref:`WebView_FormTag` | HTMLのformタグ出力。サブミット制御（ボタンとアクションの紐付け、二重サブミット防止）。不正画面遷移チェック |
| :ref:`WebView_TextTag` | HTMLのinputタグ(type=text)出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_TextareaTag` | HTMLのtextareaタグ出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_PasswordTag` | HTMLのinputタグ(type=password)出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_RadioButtonTag` | HTMLのinputタグ(type=radio)出力。入力データ復元。HTMLエスケープ。radiobuttonsタグで表示できないレイアウト時に使用 |
| :ref:`WebView_CheckboxTag` | HTMLのinputタグ(type=checkbox)出力。入力データ復元。HTMLエスケープ。checkboxesタグで表示できないレイアウト時に使用 |
| :ref:`WebView_CompositeKeyRadioButtonTag` | 複数のHTMLのinputタグ(type=radio)出力。入力データ復元。HTMLエスケープ。radioButtonタグで実現できない複合キー使用時に使用 |
| :ref:`WebView_CompositeKeyCheckboxTag` | 複数のHTMLのinputタグ(type=checkbox)出力。入力データ復元。HTMLエスケープ。checkboxesタグで実現できない複合キー使用時に使用 |
| :ref:`WebView_FileTag` | HTMLのinputタグ(type=file)出力。HTMLエスケープ |
| :ref:`WebView_HiddenTag` | HTMLタグの出力を行わず、ウィンドウスコープに値を出力 |
| :ref:`WebView_PlainHiddenTag` | HTMLのinputタグ(type=hidden)出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_SelectTag` | HTMLのselectタグとoptionタグ出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_RadioButtonsTag` | 複数のHTMLのinputタグ(type=radio)出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_CheckboxesTag` | 複数のHTMLのinputタグ(type=checkbox)出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_SubmitTag` | HTMLのinputタグ(type=submit,image,button)出力。サブミット制御（ボタンとアクションの紐付け、二重サブミット防止） |
| :ref:`WebView_ButtonTag` | HTMLのbuttonタグ出力。サブミット制御（ボタンとアクションの紐付け、二重サブミット防止） |
| :ref:`WebView_SubmitLinkTag` | HTMLのaタグ出力。サブミット制御（リンクとアクションの紐付け、二重サブミット防止） |
| :ref:`WebView_PopupSubmitTag` | HTMLのinputタグ(type=submit,image,button)出力。新しいウィンドウをオープンしてサブミット。複数ウィンドウ立ち上げ時に使用 |
| :ref:`WebView_PopupButtonTag` | HTMLのbuttonタグ出力。新しいウィンドウをオープンしてサブミット。複数ウィンドウ立ち上げ時に使用 |
| :ref:`WebView_PopupLinkTag` | HTMLのaタグ出力。新しいウィンドウをオープンしてサブミット。複数ウィンドウ立ち上げ時に使用 |
| :ref:`WebView_DownloadSubmitTag` | HTMLのinputタグ(type=submit,image,button)出力。ダウンロード用サブミット |
| :ref:`WebView_DownloadButtonTag` | HTMLのbuttonタグ出力。ダウンロード用サブミット |
| :ref:`WebView_DownloadLinkTag` | HTMLのaタグ出力。ダウンロード用サブミット |
| :ref:`WebView_ParamTag` | サブミット時に追加するパラメータを指定 |
| :ref:`WebView_ChangeParamNameTag` | ポップアップ用のサブミット時にパラメータ名を変更 |
| :ref:`WebView_ATag` | HTMLのaタグ出力。コンテキストパスの付加とURLリライト |
| :ref:`WebView_ImgTag` | HTMLのimgタグ出力。コンテキストパスの付加とURLリライト |
| :ref:`WebView_LinkTag` | HTMLのlinkタグ出力。コンテキストパスの付加とURLリライト |
| :ref:`WebView_ScriptTag` | HTMLのscriptタグ出力。コンテキストパスの付加とURLリライト |
| :ref:`WebView_ErrorsTag` | エラーメッセージの複数件表示。画面上部に一覧で表示する場合に使用 |
| :ref:`WebView_ErrorTag` | エラーメッセージの個別表示。エラーの原因となった入力項目の近くに個別表示する場合に使用 |
| :ref:`WebView_NoCacheTag` | ブラウザのキャッシュを防止するmetaタグの出力及びレスポンスヘッダの設定 |
| :ref:`WebView_CodeSelectTag` | コード値の選択表示（selectタグ使用） |
| :ref:`WebView_CodeRadioButtonsTag` | コード値の選択表示（inputタグ type=radio使用） |
| :ref:`WebView_CodeCheckboxesTag` | コード値の選択表示（inputタグ type=checkbox使用） |
| :ref:`WebView_CodeCheckboxTag` | コード値の単一入力項目表示（inputタグ type=checkbox使用） |
| :ref:`WebView_CodeTag` | 一覧表示や参照画面でコード値を出力 |
| :ref:`WebView_MessageTag` | 言語に応じたメッセージを出力 |
| :ref:`WebView_WriteTag` | 一覧表示や参照画面でオブジェクトから値を出力 |
| :ref:`WebView_PrettyPrintTag` | 修飾系のHTML(`<b>`タグなど)をエスケープせずにオブジェクトの値を出力 |
| :ref:`WebView_RawWriteTag` | HTMLエスケープをせずにオブジェクトの値を直接出力 |
| :ref:`WebView_SetTag` | リクエストスコープの変数に値を設定 |
| :ref:`WebView_IncludeTag` | インクルード先のパスを言語対応のパスに変換してからインクルード |
| :ref:`WebView_IncludeParamTag` | インクルード時に追加するパラメータを指定 |
| :ref:`WebView_ConfirmationPageTag` | JSPが確認画面であることを示す。入力画面へのパスを指定することで入力画面と確認画面を共通化 |
| :ref:`WebView_IgnoreConfirmationTag` | JSPの画面状態が確認画面である場合に確認画面の画面状態を部分的に無効化。このタグで囲まれた範囲の入力項目は常に入力画面用の出力を行う |
| :ref:`WebView_ForInputPageTag` | 入力画面と確認画面を共通化したJSPにおいて、入力画面のみボディを評価 |
| :ref:`WebView_ForConfirmationPageTag` | 入力画面と確認画面を共通化したJSPにおいて、確認画面のみボディを評価 |

共通属性: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| valueObject | ○ | | XHTMLのvalue属性の代わりに使用するオブジェクト。keyNamesで指定したプロパティを持つ必要がある |
| keyNames | ○ | | 複合キーのキー名。カンマ区切りで指定 |
| namePrefix | ○ | | リクエストパラメータに展開する際に使用するプレフィクス |
| autofocus | | | HTML5のautofocus属性 |
| label | | | チェックありの場合に使用するラベル。入力画面で表示される |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

## popupLinkタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| :ref:`WebView_FocusAttributesTag` | | | |
| name | | | XHTMLのname属性 |
| uri | ○ | | URI。:ref:`WebView_SpecifyUri` を参照 |
| shape | | | XHTMLのshape属性 |
| coords | | | XHTMLのcoords属性 |
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |
| popupWindowName | | | ポップアップのウィンドウ名。window.open関数の第2引数(JavaScript)に指定する |
| popupOption | | | ポップアップのオプション情報。window.open関数の第3引数(JavaScript)に指定する |
| displayMethod | | | 認可判定と開閉局判定の結果による表示制御方法。NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

## codeCheckboxesタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | id属性は指定不可。 |
| :ref:`WebView_FocusAttributesTag` | | | accesskey属性は指定不可。 |
| name | ○ | | XHTMLのname属性。 |
| codeId | ○ | | コードID。 |
| disabled | | | XHTMLのdisabled属性。 |
| onchange | | | XHTMLのonchange属性。 |
| autofocus | | | HTML5のautofocus属性。選択肢のうち、先頭要素のみautofocus属性を出力する。 |
| pattern | | 指定なし | 使用するパターンのカラム名。 |
| optionColumnName | | | 取得するオプション名称のカラム名。 |
| labelPattern | | "$NAME$" | ラベルを整形するパターン。プレースホルダ: $NAME$(コード名称)、$SHORTNAME$(略称)、$OPTIONALNAME$(オプション名称、optionColumnName必須)、$VALUE$(コード値)。 |
| listFormat | | br | リスト表示フォーマット。br/div/span/ul/ol/sp のいずれかを指定。 |
| errorCss | | "nablarch_error" | エラーレベルのメッセージに使用するCSSクラス名。 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り。 |

<details>
<summary>keywords</summary>

formタグ, textタグ, textareaタグ, passwordタグ, radioButtonタグ, checkboxタグ, selectタグ, submitタグ, カスタムタグ, WebView, サブミット制御, 二重サブミット防止, コード値表示, ポップアップ, ダウンロード, 確認画面, 入力画面, compositeKeyCheckbox, name, valueObject, keyNames, namePrefix, errorCss, nameAlias, 複合キーチェックボックス, 複合キー, popupLink, ポップアップリンク, popupWindowName, popupOption, displayMethod, secure, uri, codeCheckboxes, コードチェックボックス複数, コードID, labelPattern, listFormat, codeId, pattern, optionColumnName, autofocus, disabled, onchange

</details>

## 全てのHTMLタグ

全てのHTMLカスタムタグで使用可能な共通属性（:ref:`WebView_GenericAttributesTag`）。

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

共通属性: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| valueObject | ○ | | XHTMLのvalue属性の代わりに使用するオブジェクト。keyNamesで指定したプロパティを持つ必要がある |
| keyNames | ○ | | 複合キーのキー名。カンマ区切りで指定 |
| namePrefix | ○ | | リクエストパラメータに展開する際に使用するプレフィクス |
| autofocus | | | HTML5のautofocus属性 |
| label | | | チェックありの場合に使用するラベル。入力画面で表示される |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

## downloadSubmitタグ

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
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か。許可する場合はtrue、許可しない場合はfalse |
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |
| displayMethod | | | 認可判定と開閉局判定の結果による表示制御方法。NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

## codeCheckboxタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| :ref:`WebView_FocusAttributesTag` | | | |
| name | ○ | | XHTMLのname属性。 |
| value | | "1" | XHTMLのvalue属性。チェックありの場合に使用するコード値。 |
| autofocus | | | HTML5のautofocus属性。 |
| codeId | ○ | | コードID。 |
| optionColumnName | | | 取得するオプション名称のカラム名。 |
| labelPattern | | "$NAME$" | ラベルを整形するパターン。プレースホルダ: $NAME$(コード名称)、$SHORTNAME$(略称)、$OPTIONALNAME$(オプション名称、optionColumnName必須)、$VALUE$(コード値)。 |
| offCodeValue | | | チェックなしの場合に使用するコード値。未指定時はcodeId属性の値からチェックなしコード値を検索。検索結果が2件かつ1件がvalue属性値の場合、残り1件を使用。見つからない場合はデフォルト値"0"を使用。 |
| disabled | | | XHTMLのdisabled属性。 |
| onchange | | | XHTMLのonchange属性。 |
| errorCss | | "nablarch_error" | エラーレベルのメッセージに使用するCSSクラス名。 |
| nameAlias | | | name属性のエイリアス。複数指定はカンマ区切り。 |

<details>
<summary>keywords</summary>

共通属性, id, cssClass, style, title, lang, xmlLang, dir, onclick, ondblclick, onmousedown, onmouseup, onmouseover, onmousemove, onmouseout, onkeypress, onkeydown, onkeyup, HTMLタグ共通属性, GenericAttributesTag, compositeKeyRadioButton, name, valueObject, keyNames, namePrefix, errorCss, nameAlias, 複合キーラジオボタン, カスタムタグ, 複合キー, downloadSubmit, ダウンロード送信, allowDoubleSubmission, 二重サブミット, displayMethod, secure, uri, codeCheckbox, コードチェックボックス単体, offCodeValue, コード値チェックボックス, codeId, labelPattern, value, autofocus, optionColumnName, disabled, onchange

</details>

## フォーカスを取得可能なHTMLタグ

フォーカスを取得可能なHTMLカスタムタグで使用可能な共通属性（:ref:`WebView_FocusAttributesTag`）。

| 属性 | 説明 |
|---|---|
| accesskey | XHTMLのaccesskey属性 |
| tabindex | XHTMLのtabindex属性 |
| onfocus | XHTMLのonfocus属性 |
| onblur | XHTMLのonblur属性 |

共通属性: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

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
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

## downloadButtonタグ

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
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か。許可する場合はtrue、許可しない場合はfalse |
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |
| displayMethod | | | 認可判定と開閉局判定の結果による表示制御方法。NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

## codeタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | 表示対象のコード値を変数スコープから取得する名前。省略時はcodeId属性とpattern属性で絞り込んだコードの一覧を表示する。 |
| codeId | ○ | | コードID。 |
| pattern | | 指定なし | 使用するパターンのカラム名。 |
| optionColumnName | | | 取得するオプション名称のカラム名。 |
| labelPattern | | "$NAME$" | ラベルを整形するパターン。プレースホルダ: $NAME$(コード名称)、$SHORTNAME$(略称)、$OPTIONALNAME$(オプション名称、optionColumnName必須)、$VALUE$(コード値)。 |
| listFormat | | br | リスト表示フォーマット。br/div/span/ul/ol/sp のいずれかを指定。 |

<details>
<summary>keywords</summary>

accesskey, tabindex, onfocus, onblur, フォーカス属性, FocusAttributesTag, file, name, disabled, readonly, accept, multiple, errorCss, nameAlias, ファイルアップロード, カスタムタグ, downloadButton, ダウンロードボタン, allowDoubleSubmission, 二重サブミット, displayMethod, secure, uri, code, コード値表示, コードリスト表示, codeId, pattern, labelPattern, listFormat, optionColumnName

</details>

## formタグ

HTMLのformタグを出力するカスタムタグ（:ref:`WebView_FormTag`）の属性一覧。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 共通属性参照 |
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
| windowScopePrefixes | | | ウィンドウスコープ変数のプレフィックス（カンマ区切りで複数指定可）。指定されたプレフィックスにマッチするリクエストパラメータをhiddenタグとして出力 |
| useToken | | false | トークンを設定するか否か（true=設定）。confirmationPageタグが指定された場合はデフォルトがtrueになる |
| secure | | | URIをhttpsにするか否か（true=https） |
| preventPostResubmit | | false | POST再送信防止機能を使用するか否か（true=使用） |

HTMLタグの出力を行わず、ウィンドウスコープに値を出力する。

共通属性: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性 |

## downloadLinkタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| :ref:`WebView_FocusAttributesTag` | | | |
| name | | | XHTMLのname属性 |
| uri | ○ | | URI。:ref:`WebView_SpecifyUri` を参照 |
| shape | | | XHTMLのshape属性 |
| coords | | | XHTMLのcoords属性 |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か。許可する場合はtrue、許可しない場合はfalse |
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |
| displayMethod | | | 認可判定と開閉局判定の結果による表示制御方法。NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

## messageタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messageId | ○ | | メッセージID。 |
| option0～option9 | | | メッセージフォーマットに使用するオプション引数(インデックス0～9)。最大10個まで指定可能。 |
| language | | スレッドコンテキストの言語 | メッセージの言語。 |
| var | | | リクエストスコープに格納する変数名。指定した場合はメッセージを出力せずリクエストスコープに設定する。この場合はHTMLエスケープとHTMLフォーマットを行わない。 |
| htmlEscape | | true | HTMLエスケープするか否か(true/false)。 |
| withHtmlFormat | | true | HTMLフォーマット(改行と半角スペースの変換)をするか否か。htmlEscape=trueの場合のみ有効。 |

<details>
<summary>keywords</summary>

name, action, method, enctype, onsubmit, onreset, accept, acceptCharset, target, autocomplete, windowScopePrefixes, useToken, secure, preventPostResubmit, formタグ, POST再送信防止, トークン, 不正画面遷移, ウィンドウスコープ, WebView_FormTag, hidden, disabled, 隠しフィールド, HTMLタグ非出力, カスタムタグ, downloadLink, ダウンロードリンク, allowDoubleSubmission, 二重サブミット, displayMethod, uri, message, メッセージ表示, メッセージID, HTMLエスケープ, messageId, htmlEscape, withHtmlFormat, var, language

</details>

## textタグ

HTMLのinputタグ(type=text)を出力するカスタムタグ（:ref:`WebView_TextTag`）の属性一覧。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 共通属性参照 |
| :ref:`WebView_FocusAttributesTag` | | | フォーカス属性参照 |
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
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切りで複数指定可） |
| valueFormat | | | 出力時のフォーマット。`データタイプ{パターン}` 形式で指定 |

**valueFormatのデータタイプ:**

- **yyyymmdd**: 年月日フォーマット。値はyyyyMMdd形式またはパターン形式の文字列。パターン文字にはy(年)・M(月)・d(日)のみ指定可能。:ref:`WebView_CustomTagConfig` でデフォルトパターンを設定可能。
  - 例: `valueFormat="yyyymmdd"` / `valueFormat="yyyymmdd{yyyy/MM/dd}"`
  > **注意**: 入力画面にもフォーマットした値が出力される。入力された年月日をアクションで取得する場合は :ref:`ExtendedValidation_yyyymmddConvertor` を使用する。textタグとコンバータが連携し、valueFormat属性に指定されたパターンを使用した値変換と入力精査を行う。

- **yyyymm**: 年月フォーマット。使用方法はyyyymmddと同様。
  > **注意**: コンバータには :ref:`ExtendedValidation_yyyymmConvertor` を使用する。

- **decimal**: 10進数フォーマット。値はjava.lang.Number型または数字の文字列。文字列の場合は言語に対応する1000の区切り文字を取り除いた後にフォーマットされる。パターンはjava.text.DecimalFormat形式。ThreadContextに設定された言語を使用して出力。区切り文字"|"でパターンに直接言語を指定可能。:ref:`WebView_CustomTagConfig` で区切り文字の変更可能。
  - 例: `valueFormat="decimal{###,###,###.000}"` / `valueFormat="decimal{###,###,###.000|ja}"`
  > **注意**: 入力画面にもフォーマットした値が出力される。入力された数値をアクションで取得する場合は数値コンバータ（BigDecimalConvertor、IntegerConvertor、LongConvertor）を使用する。textタグと数値コンバータが連携し、valueFormat属性に指定された言語に対応する値変換と入力精査を行う。

共通属性: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| disabled | | | XHTMLのdisabled属性 |

## paramタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| paramName | ○ | | サブミット時に使用するパラメータの名前 |
| name | | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する |
| value | | | 値。直接値を指定する場合に使用する。name属性とvalue属性のどちらか一方を指定する |

## writeタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する名前。 |
| withHtmlFormat | | true | HTMLフォーマット(改行と半角スペースの変換)をするか否か。HTMLエスケープをする場合のみ有効。 |
| valueFormat | | | 出力時のフォーマット。`データタイプ{パターン}`形式で指定。 |

**valueFormatのデータタイプ**:

- **yyyymmdd**: 年月日フォーマット。値はyyyyMMdd形式またはパターン形式の文字列。パターン文字はy(年)、M(月)、d(日)のみ指定可能。:ref:`WebView_CustomTagConfig` でデフォルトパターン設定可。
  ```
  valueFormat="yyyymmdd"
  valueFormat="yyyymmdd{yyyy/MM/dd}"
  ```

- **yyyymm**: 年月フォーマット。値はyyyyMM形式の文字列。使用方法はyyyymmddと同様。

- **dateTime**: 日時フォーマット(**writeタグのみで使用可能**)。値はjava.util.Date型。パターンはjava.text.SimpleDateFormat構文。ThreadContextのタイムゾーンを使用。区切り文字"|"でパターンにタイムゾーンを直接指定可能。:ref:`WebView_CustomTagConfig` でデフォルトパターン設定と区切り文字変更可。
  ```
  valueFormat="datetime"
  valueFormat="datetime{|Asia/Tokyo}"
  valueFormat="datetime{yy/MM/dd HH:mm:ss}"
  valueFormat="datetime{yy/MM/dd HH:mm:ss|Asia/Tokyo}"
  ```

- **decimal**: 10進数フォーマット。値はjava.lang.Number型または数字の文字列。文字列の場合、言語に対応する1000区切り文字を除去後にフォーマット。パターンはjava.text.DecimalFormat構文。ThreadContextの言語を使用。区切り文字"|"でパターンに言語を直接指定可能。:ref:`WebView_CustomTagConfig` で区切り文字変更可。
  ```
  valueFormat="decimal{###,###,###.000}"
  valueFormat="decimal{###,###,###.000|ja}"
  ```

<details>
<summary>keywords</summary>

name, disabled, readonly, size, maxlength, errorCss, nameAlias, valueFormat, yyyymmdd, yyyymm, decimal, textタグ, 入力データ復元, 日付フォーマット, 数値フォーマット, ExtendedValidation_yyyymmddConvertor, ExtendedValidation_yyyymmConvertor, WebView_TextTag, WebView_CustomTagConfig, BigDecimalConvertor, IntegerConvertor, LongConvertor, plainHidden, 隠しフィールド, カスタムタグ, param, paramName, サブミットパラメータ, パラメータ名, write, 値表示, dateTime, withHtmlFormat

</details>

## textareaタグ

HTMLのtextareaタグを出力するカスタムタグ（:ref:`WebView_TextareaTag`）の属性一覧。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 共通属性参照 |
| :ref:`WebView_FocusAttributesTag` | | | フォーカス属性参照 |
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
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切りで複数指定可） |

共通属性: :ref:`WebView_GenericAttributesTag`

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
| elementLabelPattern | | `$LABEL$` | ラベルを整形するためのパターン。プレースホルダ: `$LABEL$`（ラベル）、`$VALUE$`（値）。例: `$VALUE$ - $LABEL$` → `G001 - グループ1` |
| listFormat | | `br` | リスト表示フォーマット: br / div / span / ul / ol / sp（スペース区切り） |
| withNoneOption | | `false` | trueの場合、リスト先頭に選択なしオプションを追加 |
| noneOptionLabel | | `""` | withNoneOptionがtrueの場合のみ有効。選択なしオプションのラベル |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

## changeParamNameタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| paramName | ○ | | サブミット時に使用するパラメータの名前 |
| inputName | ○ | | 変更元となる元画面のinput要素のname属性 |

## prettyPrintタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する名前。 |

<details>
<summary>keywords</summary>

name, rows, cols, disabled, readonly, errorCss, nameAlias, textareaタグ, 入力データ復元, WebView_TextareaTag, select, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, withNoneOption, noneOptionLabel, セレクトボックス, プルダウン, カスタムタグ, changeParamName, パラメータ名変更, paramName, inputName, prettyPrint, 整形表示

</details>

## passwordタグ

HTMLのinputタグ(type=password)を出力するカスタムタグ（:ref:`WebView_PasswordTag`）の属性一覧。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 共通属性参照 |
| :ref:`WebView_FocusAttributesTag` | | | フォーカス属性参照 |
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
| restoreValue | | false | 入力画面の再表示時に入力データを復元するか否か（true=復元） |
| replacement | | * | 確認画面用出力時に使用する置換文字 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切りで複数指定可） |

> **注意**: :ref:`WebView_GenericAttributesTag` のid属性は指定不可。:ref:`WebView_FocusAttributesTag` のaccesskey属性は指定不可。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択項目のリストの属性名 |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性。先頭要素のみautofocus属性を出力する |
| elementLabelPattern | | `$LABEL$` | ラベルを整形するためのパターン。プレースホルダ: `$LABEL$`（ラベル）、`$VALUE$`（値） |
| listFormat | | `br` | リスト表示フォーマット: br / div / span / ul / ol / sp（スペース区切り） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

## aタグ

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
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |

## rawWriteタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する名前。 |

### setタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| var | ○ | | リクエストスコープに格納する変数名。 |
| name | | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する。 |
| value | | | 値。直接値を指定する場合に使用する。name属性とvalue属性のどちらか一方を指定する。 |
| scope | | リクエストスコープ | 変数を格納するスコープ。page(ページスコープ)またはrequest(リクエストスコープ)。 |
| bySingleValue | | true | name属性に対応する値を単一値として取得するか否か。 |

<details>
<summary>keywords</summary>

name, restoreValue, replacement, errorCss, nameAlias, passwordタグ, パスワード, 置換文字, 確認画面, WebView_PasswordTag, radioButtons, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, ラジオボタン, カスタムタグ, id属性指定不可, aタグ, アンカー, href, hreflang, secure, target, rawWrite, HTMLエスケープなし出力, 生データ表示, setタグ, var, scope, bySingleValue, value

</details>

## radioButtonタグ

HTMLのinputタグ(type=radio)を出力するカスタムタグ（:ref:`WebView_RadioButtonTag`）の属性一覧。radiobuttonsタグで表示できないレイアウト時に使用する。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 共通属性参照 |
| :ref:`WebView_FocusAttributesTag` | | | フォーカス属性参照 |
| name | ○ | | XHTMLのname属性 |
| value | ○ | | XHTMLのvalue属性 |
| label | ○ | | ラベル |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切りで複数指定可） |

> **注意**: :ref:`WebView_GenericAttributesTag` のid属性は指定不可。:ref:`WebView_FocusAttributesTag` のaccesskey属性は指定不可。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択項目のリストの属性名 |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性。先頭要素のみautofocus属性を出力する |
| elementLabelPattern | | `$LABEL$` | ラベルを整形するためのパターン。プレースホルダ: `$LABEL$`（ラベル）、`$VALUE$`（値） |
| listFormat | | `br` | リスト表示フォーマット: br / div / span / ul / ol / sp（スペース区切り） |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

## imgタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | |
| src | ○ | | XHTMLのsrc属性。:ref:`WebView_SpecifyUri` を参照 |
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
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |

## includeタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| path | ○ | | インクルード先のパス。 |

<details>
<summary>keywords</summary>

name, value, label, errorCss, nameAlias, radioButtonタグ, ラジオボタン, 入力データ復元, WebView_RadioButtonTag, checkboxes, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, チェックボックス, カスタムタグ, id属性指定不可, imgタグ, 画像, src, alt, secure, usemap, include, ファイルインクルード, path

</details>

## checkboxタグ

HTMLのinputタグ(type=checkbox)を出力するカスタムタグ（:ref:`WebView_CheckboxTag`）の属性一覧。checkboxesタグで表示できないレイアウト時に使用する。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| :ref:`WebView_GenericAttributesTag` | | | 共通属性参照 |
| :ref:`WebView_FocusAttributesTag` | | | フォーカス属性参照 |
| name | ○ | | XHTMLのname属性 |
| value | | 1 | チェックありの場合に使用する値 |
| autofocus | | | HTML5のautofocus属性 |
| label | | | チェックありの場合に使用するラベル（入力画面で表示） |
| useOffValue | | true | チェックなしの値設定を使用するか否か |
| offLabel | | | チェックなしの場合に使用するラベル |
| offValue | | 0 | チェックなしの場合に使用する値 |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切りで複数指定可） |

共通属性: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

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
| allowDoubleSubmission | | `true` | 二重サブミットを許可するか否か（true: 許可 / false: 不許可） |
| secure | | | URIをhttpsにするか否か（true: https / false: http） |
| displayMethod | | | 認可判定・開閉局判定に基づく表示制御: NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

## linkタグ

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
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |

## includeParamタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| paramName | ○ | | インクルード時に使用するパラメータの名前。 |
| name | | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する。 |
| value | | | 値。直接値を指定する場合に使用する。name属性とvalue属性のどちらか一方を指定する。 |

<details>
<summary>keywords</summary>

name, value, label, useOffValue, offLabel, offValue, errorCss, nameAlias, checkboxタグ, チェックボックス, 入力データ復元, WebView_CheckboxTag, submit, type, uri, allowDoubleSubmission, secure, displayMethod, src, alt, usemap, align, 二重サブミット, 認可判定, 開閉局判定, 画像ボタン, カスタムタグ, linkタグ, リンク, href, media, rel, includeParam, インクルードパラメータ, paramName

</details>

## compositeKeyCheckboxタグ

複数のHTMLのinputタグ(type=checkbox)を出力するカスタムタグ（:ref:`WebView_CompositeKeyCheckboxTag`）。checkboxesタグで実現できない複合キーを使用する際に使用する。入力データ復元およびHTMLエスケープをサポートする。

共通属性: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI（:ref:`WebView_SpecifyUri` 参照） |
| value | | | XHTMLのvalue属性 |
| type | | | XHTMLのtype属性 |
| disabled | | | XHTMLのdisabled属性 |
| autofocus | | | HTML5のautofocus属性 |
| allowDoubleSubmission | | `true` | 二重サブミットを許可するか否か（true: 許可 / false: 不許可） |
| secure | | | URIをhttpsにするか否か（true: https / false: http） |
| displayMethod | | | 認可判定・開閉局判定に基づく表示制御: NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

## scriptタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| type | ○ | | XHTMLのtype属性 |
| id | | | XHTMLのid属性 |
| charset | | | XHTMLのcharset属性 |
| language | | | XHTMLのlanguage属性 |
| src | | | XHTMLのsrc属性。:ref:`WebView_SpecifyUri` を参照 |
| defer | | | XHTMLのdefer属性 |
| xmlSpace | | | XHTMLのxml:space属性 |
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |

## confirmationPageタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| path | | | フォワード先(入力画面)のパス。 |

<details>
<summary>keywords</summary>

CompositeKeyCheckboxTag, WebView_CompositeKeyCheckboxTag, 複合キー, チェックボックス, 複数チェックボックス, checkboxesタグ, 入力データ復元, button, uri, allowDoubleSubmission, secure, displayMethod, ボタン, 二重サブミット, 認可判定, カスタムタグ, scriptタグ, スクリプト, src, xmlSpace, defer, confirmationPage, 確認画面, フォワード先, path

</details>

## submitLinkタグ

共通属性: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI（:ref:`WebView_SpecifyUri` 参照） |
| shape | | | XHTMLのshape属性 |
| coords | | | XHTMLのcoords属性 |
| allowDoubleSubmission | | `true` | 二重サブミットを許可するか否か（true: 許可 / false: 不許可） |
| secure | | | URIをhttpsにするか否か（true: https / false: http） |
| displayMethod | | | 認可判定・開閉局判定に基づく表示制御: NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

## errorsタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| cssClass | | nablarch_errors | リスト表示においてulタグに使用するCSSクラス名 |
| infoCss | | nablarch_info | 情報レベルのメッセージに使用するCSSクラス名 |
| warnCss | | nablarch_warn | 警告レベルのメッセージに使用するCSSクラス名 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| filter | | all | リストに含めるメッセージのフィルタ条件。all（全てのメッセージを表示）/ global（ValidationResultMessageのプロパティ名が入っているメッセージを取り除いて出力） |

## ignoreConfirmationタグ

属性なし。

<details>
<summary>keywords</summary>

submitLink, uri, allowDoubleSubmission, secure, displayMethod, shape, coords, リンクサブミット, 二重サブミット, カスタムタグ, errors, エラー表示, cssClass, filter, nablarch_errors, ValidationResultMessage, global, infoCss, warnCss, ignoreConfirmation, 確認画面無視, 入力確認フロー

</details>

## popupSubmitタグ

共通属性: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

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
| secure | | | URIをhttpsにするか否か（true: https / false: http） |
| popupWindowName | | | ポップアップのウィンドウ名（window.open第2引数） |
| popupOption | | | ポップアップのオプション情報（window.open第3引数） |
| displayMethod | | | 認可判定・開閉局判定に基づく表示制御: NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

## errorタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | エラーメッセージを表示する入力項目のname属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| messageFormat | | div | メッセージ表示時に使用するフォーマット。div（divタグ）/ span（spanタグ） |

## forInputPageタグ

属性なし。

<details>
<summary>keywords</summary>

popupSubmit, type, uri, popupWindowName, popupOption, secure, displayMethod, src, alt, usemap, align, ポップアップ, サブミット, 画像ボタン, カスタムタグ, error, エラーメッセージ, messageFormat, errorCss, nablarch_error, forInputPage, 入力画面条件表示, 入力画面専用

</details>

## popupButtonタグ

共通属性: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI（:ref:`WebView_SpecifyUri` 参照） |
| value | | | XHTMLのvalue属性 |
| type | | | XHTMLのtype属性 |
| disabled | | | XHTMLのdisabled属性 |
| autofocus | | | HTML5のautofocus属性 |
| secure | | | URIをhttpsにするか否か（true: https / false: http） |
| popupWindowName | | | ポップアップのウィンドウ名（window.open第2引数） |
| popupOption | | | ポップアップのオプション情報（window.open第3引数） |
| displayMethod | | | 認可判定・開閉局判定に基づく表示制御: NODISPLAY（非表示）/ DISABLED（非活性）/ NORMAL（通常表示） |

## noCacheタグ

属性なし。

## forConfirmationPageタグ

属性なし。

<details>
<summary>keywords</summary>

popupButton, uri, popupWindowName, popupOption, secure, displayMethod, ポップアップ, ボタン, カスタムタグ, noCache, キャッシュ無効化, forConfirmationPage, 確認画面条件表示, 確認画面専用

</details>

## codeSelectタグ

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
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | $NAME$ | ラベルを整形するパターン。プレースホルダ: $NAME$（コード名称）/ $SHORTNAME$（略称）/ $OPTIONALNAME$（オプション名称、使用時はoptionColumnName必須）/ $VALUE$（コード値） |
| listFormat | | br | リスト表示時のフォーマット。br / div / span / ul / ol / sp（スペース区切り） |
| withNoneOption | | false | リスト先頭に選択なしのオプションを追加するか否か |
| noneOptionLabel | | "" | withNoneOptionがtrueの場合に使用する選択なしオプションのラベル |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

<details>
<summary>keywords</summary>

codeSelect, コード選択, codeId, labelPattern, withNoneOption, noneOptionLabel, listFormat, nameAlias, optionColumnName, コード値, $NAME$, $SHORTNAME$, $OPTIONALNAME$, $VALUE$, pattern, errorCss

</details>

## codeRadioButtonsタグ

## codeRadioButtonsタグ

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
| labelPattern | | $NAME$ | ラベルを整形するパターン。プレースホルダ: $NAME$（コード名称）/ $SHORTNAME$（略称）/ $OPTIONALNAME$（オプション名称、使用時はoptionColumnName必須）/ $VALUE$（コード値） |
| listFormat | | br | リスト表示時のフォーマット。br / div / span / ul / ol / sp（スペース区切り） |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

<details>
<summary>keywords</summary>

codeRadioButtons, コードラジオボタン, codeId, labelPattern, listFormat, nameAlias, optionColumnName, コード値, $NAME$, $SHORTNAME$, $OPTIONALNAME$, $VALUE$, pattern, errorCss

</details>
