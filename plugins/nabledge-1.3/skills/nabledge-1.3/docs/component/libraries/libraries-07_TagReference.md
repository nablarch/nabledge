# タグリファレンス

## タグリファレンス

WebViewカスタムタグのタグリファレンス。各カスタムタグの属性定義（共通属性・個別属性）を記載する。

## compositeKeyCheckboxタグ

複合キー用チェックボックスタグ。

:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` の属性を使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| valueObject | ○ | | XHTMLのvalue属性の代わりに使用するオブジェクト。keyNamesで指定したプロパティを持つ必要がある |
| keyNames | ○ | | 複合キーのキー名。カンマ区切りで指定する |
| namePrefix | ○ | | リクエストパラメータに展開する際に使用するプレフィクス |
| autofocus | | | HTML5のautofocus属性 |
| label | | | チェックありの場合に使用するラベル。入力画面で表示される |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
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
| popupWindowName | | | ポップアップのウィンドウ名。windwo.open関数の第2引数(JavaScript)に指定する |
| popupOption | | | ポップアップのオプション情報。windwo.open関数の第3引数(JavaScript)に指定する |
| displayMethod | | | 認可判定と開閉局判定の結果に応じて表示制御を行う場合の表示方法。NODISPLAY(非表示)、DISABLED(非活性)、NORMAL(通常表示) |

`codeCheckboxes`タグの属性一覧。:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` を継承。

> **注意**: :ref:`WebView_GenericAttributesTag` のid属性は指定不可。:ref:`WebView_FocusAttributesTag` のaccesskey属性は指定不可。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| codeId | ○ | | コードID |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性。選択肢のうち先頭要素のみautofocus属性を出力する |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`(コード名称)、`$SHORTNAME$`(略称)、`$OPTIONALNAME$`(オプション名称、optionColumnName指定が必須)、`$VALUE$`(コード値) |
| listFormat | | `br` | リスト表示フォーマット。`br`(brタグ)・`div`(divタグ)・`span`(spanタグ)・`ul`(ulタグ)・`ol`(olタグ)・`sp`(スペース区切り) |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

<details>
<summary>keywords</summary>

タグリファレンス, WebViewカスタムタグ, JSPカスタムタグ, WebView, compositeKeyCheckbox, 複合キーチェックボックス, name, valueObject, keyNames, namePrefix, errorCss, nameAlias, popupLinkタグ, ポップアップリンク, popupWindowName, popupOption, displayMethod, secure, popup, codeCheckboxes, codeId, labelPattern, listFormat, optionColumnName, autofocus, disabled, onchange, pattern, コードチェックボックス, チェックボックスグループ, コード値選択

</details>

## カスタムタグ一覧

## カスタムタグ一覧

| タグ | 機能 |
|---|---|
| :ref:`WebView_FormTag` | HTMLのformタグ出力。サブミット制御(ボタンとアクションの紐付け、二重サブミット防止)。不正画面遷移チェック |
| :ref:`WebView_TextTag` | HTMLのinputタグ(type=text)出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_TextareaTag` | HTMLのtextareaタグ出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_PasswordTag` | HTMLのinputタグ(type=password)出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_RadioButtonTag` | HTMLのinputタグ(type=radio)出力。入力データ復元。HTMLエスケープ。radioButtonsタグで表示できないレイアウト時に使用 |
| :ref:`WebView_CheckboxTag` | HTMLのinputタグ(type=checkbox)出力。入力データ復元。HTMLエスケープ。checkboxesタグで表示できないレイアウト時に使用 |
| :ref:`WebView_CompositeKeyRadioButtonTag` | 複数のHTMLのinputタグ(type=radio)出力。入力データ復元。HTMLエスケープ。radioButtonタグで実現できない複合キーを使用する際に使用 |
| :ref:`WebView_CompositeKeyCheckboxTag` | 複数のHTMLのinputタグ(type=checkbox)出力。入力データ復元。HTMLエスケープ。checkboxesタグで実現できない複合キーを使用する際に使用 |
| :ref:`WebView_FileTag` | HTMLのinputタグ(type=file)出力。HTMLエスケープ |
| :ref:`WebView_HiddenTag` | HTMLタグの出力を行わず、ウィンドウスコープに値を出力する |
| :ref:`WebView_PlainHiddenTag` | HTMLのinputタグ(type=hidden)出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_SelectTag` | HTMLのselectタグとoptionタグ出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_RadioButtonsTag` | 複数のHTMLのinputタグ(type=radio)出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_CheckboxesTag` | 複数のHTMLのinputタグ(type=checkbox)出力。入力データ復元。HTMLエスケープ |
| :ref:`WebView_SubmitTag` | HTMLのinputタグ(type=submit,image,button)出力。サブミット制御(ボタンとアクションの紐付け、二重サブミット防止) |
| :ref:`WebView_ButtonTag` | HTMLのbuttonタグ出力。サブミット制御(ボタンとアクションの紐付け、二重サブミット防止) |
| :ref:`WebView_SubmitLinkTag` | HTMLのaタグ出力。サブミット制御(リンクとアクションの紐付け、二重サブミット防止) |
| :ref:`WebView_PopupSubmitTag` | HTMLのinputタグ(type=submit,image,button)出力。新しいウィンドウをオープンしサブミット。複数ウィンドウ立ち上げ用 |
| :ref:`WebView_PopupButtonTag` | HTMLのbuttonタグ出力。新しいウィンドウをオープンしサブミット。複数ウィンドウ立ち上げ用 |
| :ref:`WebView_PopupLinkTag` | HTMLのaタグ出力。新しいウィンドウをオープンしサブミット。複数ウィンドウ立ち上げ用 |
| :ref:`WebView_DownloadSubmitTag` | HTMLのinputタグ(type=submit,image,button)出力。ダウンロード用サブミット |
| :ref:`WebView_DownloadButtonTag` | HTMLのbuttonタグ出力。ダウンロード用サブミット |
| :ref:`WebView_DownloadLinkTag` | HTMLのaタグ出力。ダウンロード用サブミット |
| :ref:`WebView_ParamTag` | サブミット時に追加するパラメータを指定する |
| :ref:`WebView_ChangeParamNameTag` | ポップアップ用のサブミット時にパラメータ名を変更する |
| :ref:`WebView_ATag` | HTMLのaタグ出力。コンテキストパスの付加とURLリライト |
| :ref:`WebView_ImgTag` | HTMLのimgタグ出力。コンテキストパスの付加とURLリライト |
| :ref:`WebView_LinkTag` | HTMLのlinkタグ出力。コンテキストパスの付加とURLリライト |
| :ref:`WebView_ScriptTag` | HTMLのscriptタグ出力。コンテキストパスの付加とURLリライト |
| :ref:`WebView_ErrorsTag` | エラーメッセージの複数件表示。画面上部に一覧でエラーメッセージを表示する場合に使用 |
| :ref:`WebView_ErrorTag` | エラーメッセージの表示。エラーの原因となった入力項目の近くにエラーメッセージを個別に表示する場合に使用 |
| :ref:`WebView_NoCacheTag` | ブラウザのキャッシュを防止するmetaタグの出力及びレスポンスヘッダの設定 |
| :ref:`WebView_CodeSelectTag` | コード値の選択表示。selectタグを使用する |
| :ref:`WebView_CodeRadioButtonsTag` | コード値の選択表示。inputタグ(type=radio)を使用する |
| :ref:`WebView_CodeCheckboxesTag` | コード値の選択表示。inputタグ(type=checkbox)を使用する |
| :ref:`WebView_CodeCheckboxTag` | コード値の単一入力項目表示。inputタグ(type=checkbox)を使用する |
| :ref:`WebView_CodeTag` | 一覧表示や参照画面などで、コード値を出力する |
| :ref:`WebView_MessageTag` | 言語に応じたメッセージを出力する |
| :ref:`WebView_WriteTag` | 一覧表示や参照画面などで、オブジェクトから値を出力する |
| :ref:`WebView_PrettyPrintTag` | 修飾系のHTML(`<b>`タグなど)をエスケープせずにオブジェクトの値を出力する |
| :ref:`WebView_RawWriteTag` | HTMLエスケープをせずにオブジェクトの値を直接出力する |
| :ref:`WebView_SetTag` | リクエストスコープの変数に値を設定する |
| :ref:`WebView_IncludeTag` | インクルード先のパスを言語対応のパスに変換してからインクルードを行う |
| :ref:`WebView_IncludeParamTag` | インクルード時に追加するパラメータを指定する |
| :ref:`WebView_ConfirmationPageTag` | JSPが確認画面であることを示す。このタグに入力画面へのパスを指定することで、入力画面と確認画面を共通化する |
| :ref:`WebView_IgnoreConfirmationTag` | JSPの画面状態が確認画面である場合に、部分的に確認画面の画面状態を無効化する。このタグで囲まれた範囲の入力項目のカスタムタグは常に入力画面用の出力を行う |
| :ref:`WebView_ForInputPageTag` | 入力画面と確認画面を共通化したJSPにおいて、入力画面のみボディを評価する |
| :ref:`WebView_ForConfirmationPageTag` | 入力画面と確認画面を共通化したJSPにおいて、確認画面のみボディを評価する |

## compositeKeyRadioButtonタグ

複合キー用ラジオボタンタグ。

:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` の属性を使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| valueObject | ○ | | XHTMLのvalue属性の代わりに使用するオブジェクト。keyNamesで指定したプロパティを持つ必要がある |
| keyNames | ○ | | 複合キーのキー名。カンマ区切りで指定する |
| namePrefix | ○ | | リクエストパラメータに展開する際に使用するプレフィクス |
| autofocus | | | HTML5のautofocus属性 |
| label | | | チェックありの場合に使用するラベル。入力画面で表示される |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
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
| displayMethod | | | 認可判定と開閉局判定の結果に応じて表示制御を行う場合の表示方法。NODISPLAY(非表示)、DISABLED(非活性)、NORMAL(通常表示) |

`codeCheckbox`タグの属性一覧。:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` を継承。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| value | | `1` | XHTMLのvalue属性。チェックありの場合に使用するコード値 |
| autofocus | | | HTML5のautofocus属性 |
| codeId | ○ | | コードID |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`(コード名称)、`$SHORTNAME$`(略称)、`$OPTIONALNAME$`(オプション名称、optionColumnName指定が必須)、`$VALUE$`(コード値) |
| offCodeValue | | `0` | チェックなしの場合に使用するコード値。未指定時はcodeId属性からチェックなしのコード値を検索。検索結果が2件かつ1件がvalue属性の値なら残りの1件を使用。見つからない場合はデフォルト`0` |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | `nablarch_error` | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

<details>
<summary>keywords</summary>

formタグ, textタグ, textareaタグ, passwordタグ, radioButtonタグ, checkboxタグ, submitタグ, buttonタグ, selectタグ, hiddenタグ, fileタグ, カスタムタグ一覧, サブミット制御, 二重サブミット防止, コード値, エラーメッセージ, 確認画面, ポップアップ, ダウンロード, ConfirmationPageTag, IgnoreConfirmationTag, WebView_RadioButtonsTag, WebView_CheckboxesTag, WebView_SubmitTag, WebView_ButtonTag, WebView_SubmitLinkTag, WebView_PopupSubmitTag, WebView_PopupButtonTag, WebView_PopupLinkTag, WebView_DownloadSubmitTag, WebView_DownloadButtonTag, WebView_DownloadLinkTag, WebView_ParamTag, WebView_ChangeParamNameTag, WebView_ATag, WebView_ImgTag, WebView_LinkTag, WebView_ScriptTag, WebView_ErrorsTag, WebView_ErrorTag, WebView_NoCacheTag, WebView_CodeSelectTag, WebView_CodeRadioButtonsTag, WebView_CodeCheckboxesTag, WebView_CodeCheckboxTag, WebView_CodeTag, WebView_MessageTag, WebView_WriteTag, WebView_PrettyPrintTag, WebView_RawWriteTag, WebView_SetTag, WebView_IncludeTag, WebView_IncludeParamTag, WebView_ForInputPageTag, WebView_ForConfirmationPageTag, WebView_CompositeKeyRadioButtonTag, WebView_CompositeKeyCheckboxTag, WebView_FileTag, WebView_HiddenTag, WebView_PlainHiddenTag, WebView_SelectTag, compositeKeyRadioButton, 複合キーラジオボタン, name, valueObject, keyNames, namePrefix, errorCss, nameAlias, downloadSubmitタグ, ダウンロードサブミット, allowDoubleSubmission, 二重サブミット, displayMethod, secure, codeCheckbox, codeId, offCodeValue, labelPattern, value, autofocus, optionColumnName, disabled, onchange, チェックボックス, チェックなし

</details>

## 全てのHTMLタグ（共通属性）

## 共通属性: 全てのHTMLタグ

全カスタムタグで参照可能な共通属性（:ref:`WebView_GenericAttributesTag`）。

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

## fileタグ

ファイル入力タグ。

:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` の属性を使用可能。

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
| displayMethod | | | 認可判定と開閉局判定の結果に応じて表示制御を行う場合の表示方法。NODISPLAY(非表示)、DISABLED(非活性)、NORMAL(通常表示) |

`code`タグの属性一覧。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | 表示対象のコード値を変数スコープから取得する名前。省略時はcodeId属性とpattern属性で絞り込んだコードの一覧を表示する |
| codeId | ○ | | コードID |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `$NAME$` | ラベルを整形するパターン。プレースホルダ: `$NAME$`(コード名称)、`$SHORTNAME$`(略称)、`$OPTIONALNAME$`(オプション名称、optionColumnName指定が必須)、`$VALUE$`(コード値) |
| listFormat | | `br` | リスト表示フォーマット。`br`(brタグ)・`div`(divタグ)・`span`(spanタグ)・`ul`(ulタグ)・`ol`(olタグ)・`sp`(スペース区切り) |

<details>
<summary>keywords</summary>

id, cssClass, style, title, lang, xmlLang, dir, onclick, ondblclick, onmousedown, onmouseup, onmouseover, onmousemove, onmouseout, onkeypress, onkeydown, onkeyup, 共通属性, HTMLタグ属性, WebView_GenericAttributesTag, file, ファイル入力, name, multiple, accept, errorCss, nameAlias, downloadButtonタグ, ダウンロードボタン, allowDoubleSubmission, 二重サブミット, displayMethod, secure, code, codeId, labelPattern, listFormat, optionColumnName, pattern, コード表示, コード値一覧

</details>

## フォーカスを取得可能なHTMLタグ（共通属性）

## 共通属性: フォーカスを取得可能なHTMLタグ

フォーカスを取得可能なHTMLタグで参照可能な共通属性（:ref:`WebView_FocusAttributesTag`）。

| 属性 | 説明 |
|---|---|
| accesskey | XHTMLのaccesskey属性 |
| tabindex | XHTMLのtabindex属性 |
| onfocus | XHTMLのonfocus属性 |
| onblur | XHTMLのonblur属性 |

## hiddenタグ

HTMLタグの出力を行わず、ウィンドウスコープに値を出力する。

:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` の属性を使用可能。

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
| displayMethod | | | 認可判定と開閉局判定の結果に応じて表示制御を行う場合の表示方法。NODISPLAY(非表示)、DISABLED(非活性)、NORMAL(通常表示) |

`message`タグの属性一覧。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| messageId | ○ | | メッセージID |
| option0〜option9 | | | メッセージフォーマットに使用するオプション引数。最大10個 |
| language | | スレッドコンテキストの言語 | メッセージの言語 |
| var | | | リクエストスコープに格納する変数名。指定した場合はメッセージを出力せずリクエストスコープに設定する（この場合、HTMLエスケープとHTMLフォーマットは行わない） |
| htmlEscape | | `true` | HTMLエスケープするか否か。`true`でエスケープ |
| withHtmlFormat | | `true` | HTMLフォーマット（改行と半角スペースの変換）するか否か。HTMLエスケープをする場合のみ有効 |

<details>
<summary>keywords</summary>

accesskey, tabindex, onfocus, onblur, フォーカス属性, WebView_FocusAttributesTag, hidden, ウィンドウスコープ, 非表示値出力, name, disabled, downloadLinkタグ, ダウンロードリンク, allowDoubleSubmission, 二重サブミット, displayMethod, secure, message, messageId, htmlEscape, withHtmlFormat, var, language, option0, メッセージ出力, メッセージフォーマット, HTMLエスケープ

</details>

## formタグ

## formタグ

:ref:`WebView_FormTag`

**共通属性**: :ref:`WebView_GenericAttributesTag`

| 属性 | 必須 | デフォルト | 説明 |
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
| windowScopePrefixes | | | ウィンドウスコープ変数のプレフィックス（カンマ区切りで複数指定可）。指定されたプレフィックスにマッチするリクエストパラメータをhiddenタグとして出力する |
| useToken | | false | トークンを設定するか否か（true=設定する、false=設定しない）。confirmationPageタグが指定された場合はデフォルトがtrueとなる |
| secure | | | URIをhttpsにするか否か（true=https、false=しない） |

## plainHiddenタグ

:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` の属性を使用可能。

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

`write`タグの属性一覧。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する名前 |
| withHtmlFormat | | `true` | HTMLフォーマット（改行と半角スペースの変換）するか否か。HTMLエスケープをする場合のみ有効 |
| valueFormat | | | 出力フォーマット。`データタイプ{パターン}`形式で指定する |

**valueFormat データタイプ:**

| データタイプ | 説明 |
|---|---|
| `yyyymmdd` | 年月日フォーマット。値はyyyyMMdd形式またはパターン形式の文字列。パターンはjava.text.SimpleDateFormatの構文（y/M/dのみ指定可）。:ref:`WebView_CustomTagConfig` でデフォルトパターン設定可 |
| `yyyymm` | 年月フォーマット。値はyyyyMM形式またはパターン形式。yyyymmddと同様 |
| `dateTime` | 日時フォーマット（**writeタグのみ使用可**）。値はjava.util.Date型。パターンはjava.text.SimpleDateFormatの構文。ThreadContextのタイムゾーンを使用。区切り文字`|`でパターンにタイムゾーンを直接指定可。:ref:`WebView_CustomTagConfig` でデフォルトパターンと区切り文字変更可 |
| `decimal` | 10進数フォーマット。値はjava.lang.Number型または数字文字列（言語対応の1000区切り文字除去後にフォーマット）。パターンはjava.text.DecimalFormatの構文。ThreadContextの言語を使用。区切り文字`|`で言語を直接指定可。:ref:`WebView_CustomTagConfig` で区切り文字変更可 |

**valueFormat 指定例:**

```bash
# yyyymmdd: デフォルトパターン使用
valueFormat="yyyymmdd"
# yyyymmdd: パターン指定
valueFormat="yyyymmdd{yyyy/MM/dd}"

# dateTime: デフォルトパターンとThreadContextのタイムゾーン使用
valueFormat="datetime"
# dateTime: タイムゾーンのみ指定
valueFormat="datetime{|Asia/Tokyo}"
# dateTime: パターンのみ指定
valueFormat="datetime{yy/MM/dd HH:mm:ss}"
# dateTime: パターンとタイムゾーン指定
valueFormat="datetime{yy/MM/dd HH:mm:ss|Asia/Tokyo}"

# decimal: パターンのみ指定
valueFormat="decimal{###,###,###.000}"
# decimal: パターンと言語指定
valueFormat="decimal{###,###,###.000|ja}"
```

<details>
<summary>keywords</summary>

formタグ, useToken, windowScopePrefixes, secure, method, autocomplete, 二重サブミット防止, トークン, ウィンドウスコープ, confirmationPageタグ, WebView_FormTag, plainHidden, hidden, name, disabled, paramタグ, パラメータ, paramName, サブミットパラメータ, value, write, valueFormat, withHtmlFormat, yyyymmdd, yyyymm, dateTime, decimal, SimpleDateFormat, DecimalFormat, 値表示, 日付フォーマット, 数値フォーマット

</details>

## textタグ

## textタグ

:ref:`WebView_TextTag`

**共通属性**: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

| 属性 | 必須 | デフォルト | 説明 |
|---|---|---|---|
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

**valueFormat に指定可能なデータタイプ:**

- `yyyymmdd`: 年月日フォーマット。値はyyyyMMdd形式またはパターン形式の文字列。パターンはjava.text.SimpleDateFormatの構文（**y/M/dのみ指定可**）。:ref:`WebView_CustomTagConfig` でデフォルトパターンを設定可能。例: `valueFormat="yyyymmdd"`, `valueFormat="yyyymmdd{yyyy/MM/dd}"`
  > **注意**: valueFormat属性を指定した場合、入力画面にもフォーマットした値が出力される。アクションで年月日を取得する場合は :ref:`ExtendedValidation_yyyymmddConvertor` を使用すること。textタグとコンバータが連携し、valueFormat属性に指定されたパターンを使用した値変換と入力精査を行う。
- `yyyymm`: 年月フォーマット。値はyyyyMM形式またはパターン形式の文字列。使用方法はyyyymmddと同様。コンバータには :ref:`ExtendedValidation_yyyymmConvertor` を使用すること。
- `decimal`: 10進数フォーマット。値はjava.lang.Number型または数字の文字列。**文字列の場合、言語に対応する1000の区切り文字を取り除いた後でフォーマットされる。** ThreadContextに設定された言語に応じた形式で出力。パターンはjava.text.DecimalFormatの構文。区切り文字`|`でパターンに直接言語指定可能（例: `###,###,###.000|ja`）。:ref:`WebView_CustomTagConfig` で区切り文字変更可能。例: `valueFormat="decimal{###,###,###.000}"`, `valueFormat="decimal{###,###,###.000|ja}"`
  > **注意**: valueFormat属性を指定した場合、入力画面にもフォーマットした値が出力される。アクションで数値を取得する場合は [数値コンバータ(BigDecimalConvertor、IntegerConvertor、LongConvertor)](libraries-validation_basic_validators.md) を使用すること。textタグと数値コンバータが連携し、valueFormat属性に指定された言語に対応する値変換と入力精査を行う。

## selectタグ

セレクトボックスタグ。

:ref:`WebView_GenericAttributesTag` の属性を使用可能。

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
| elementLabelPattern | | $LABEL$ | ラベルを整形するためのパターン。プレースホルダ: $LABEL$（ラベル）、$VALUE$（値）。例: "$VALUE$ - $LABEL$"と指定した場合、ラベル=グループ1・値=G001のとき"G001 - グループ1"となる |
| listFormat | | br | リスト表示時のフォーマット。br/div/span/ul/ol/sp（スペース区切り）のいずれかを指定 |
| withNoneOption | | false | リスト先頭に選択なしのオプションを追加するか否か |
| noneOptionLabel | | （空文字） | withNoneOptionにtrueを指定した場合のみ有効。選択なしオプションのラベル |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

## changeParamNameタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| paramName | ○ | | サブミット時に使用するパラメータの名前 |
| inputName | ○ | | 変更元となる元画面のinput要素のname属性 |

`prettyPrint`タグの属性一覧。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する名前 |

<details>
<summary>keywords</summary>

textタグ, valueFormat, yyyymmdd, yyyymm, decimal, errorCss, nameAlias, nablarch_error, 日付フォーマット, 数値フォーマット, ExtendedValidation_yyyymmddConvertor, ExtendedValidation_yyyymmConvertor, BigDecimalConvertor, IntegerConvertor, LongConvertor, WebView_TextTag, WebView_CustomTagConfig, select, セレクトボックス, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, withNoneOption, noneOptionLabel, changeParamNameタグ, パラメータ名変更, paramName, inputName, prettyPrint, name, 値表示

</details>

## textareaタグ

## textareaタグ

:ref:`WebView_TextareaTag`

**共通属性**: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

| 属性 | 必須 | デフォルト | 説明 |
|---|---|---|---|
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

## radioButtonsタグ

ラジオボタングループタグ。

:ref:`WebView_GenericAttributesTag`（id属性は指定不可）および :ref:`WebView_FocusAttributesTag`（accesskey属性は指定不可）の属性を使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択項目のリストの属性名 |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性。選択肢のうち先頭要素のみ出力する |
| elementLabelPattern | | $LABEL$ | ラベルを整形するためのパターン。プレースホルダ: $LABEL$（ラベル）、$VALUE$（値） |
| listFormat | | br | リスト表示時のフォーマット。br/div/span/ul/ol/sp（スペース区切り）のいずれかを指定 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
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

`rawWrite`タグの属性一覧。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | 表示対象の値を変数スコープから取得する名前 |

## setタグ

`set`タグの属性一覧。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| var | ○ | | リクエストスコープに格納する変数名 |
| name | | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する |
| value | | | 値（直接指定）。name属性とvalue属性のどちらか一方を指定する |
| scope | | `request` | 変数を格納するスコープ。`page`(ページスコープ)または`request`(リクエストスコープ) |
| bySingleValue | | `true` | name属性に対応する値を単一値として取得するか否か |

<details>
<summary>keywords</summary>

textareaタグ, rows, cols, errorCss, nameAlias, placeholder, maxlength, WebView_TextareaTag, radioButtons, ラジオボタン, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, aタグ, リンク, href, secure, ハイパーリンク, hreflang, rawWrite, set, var, scope, bySingleValue, name, value, スコープ設定, リクエストスコープ, ページスコープ

</details>

## passwordタグ

## passwordタグ

:ref:`WebView_PasswordTag`

**共通属性**: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

| 属性 | 必須 | デフォルト | 説明 |
|---|---|---|---|
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
| restoreValue | | false | 入力画面の再表示時に入力データを復元するか否か（true=復元する） |
| replacement | | * | 確認画面用の出力時に使用する置換文字 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切りで複数指定可） |

## checkboxesタグ

チェックボックスグループタグ。

:ref:`WebView_GenericAttributesTag`（id属性は指定不可）および :ref:`WebView_FocusAttributesTag`（accesskey属性は指定不可）の属性を使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| listName | ○ | | 選択項目のリストの属性名 |
| elementLabelProperty | ○ | | リスト要素からラベルを取得するためのプロパティ名 |
| elementValueProperty | ○ | | リスト要素から値を取得するためのプロパティ名 |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性。選択肢のうち先頭要素のみ出力する |
| elementLabelPattern | | $LABEL$ | ラベルを整形するためのパターン。プレースホルダ: $LABEL$（ラベル）、$VALUE$（値） |
| listFormat | | br | リスト表示時のフォーマット。br/div/span/ul/ol/sp（スペース区切り）のいずれかを指定 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

## imgタグ

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
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |

`include`タグの属性一覧。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| path | ○ | | インクルード先のパス |

<details>
<summary>keywords</summary>

passwordタグ, restoreValue, replacement, errorCss, nameAlias, 確認画面, 置換文字, WebView_PasswordTag, checkboxes, チェックボックスグループ, listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, imgタグ, 画像, src, alt, secure, usemap, include, path, インクルード

</details>

## radioButtonタグ

## radioButtonタグ

:ref:`WebView_RadioButtonTag`

**共通属性**: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

radioButtonsタグで表示できないレイアウト時に使用する。

| 属性 | 必須 | デフォルト | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| value | ○ | | XHTMLのvalue属性 |
| label | ○ | | ラベル |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| autofocus | | | HTML5のautofocus属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切りで複数指定可） |

## submitタグ

送信ボタンタグ。

:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` の属性を使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
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
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か。許可する場合はtrue、しない場合はfalse |
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |
| displayMethod | | | 認可判定と開閉局判定の結果に応じた表示制御方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示） |

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

`includeParam`タグの属性一覧。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| paramName | ○ | | インクルード時に使用するパラメータの名前 |
| name | | | 値を取得するための名前。name属性とvalue属性のどちらか一方を指定する |
| value | | | 値（直接指定）。name属性とvalue属性のどちらか一方を指定する |

<details>
<summary>keywords</summary>

radioButtonタグ, radioButtonsタグ, label, errorCss, nameAlias, ラジオボタン, WebView_RadioButtonTag, submit, 送信ボタン, allowDoubleSubmission, displayMethod, secure, uri, type, linkタグ, リンク要素, href, media, hreflang, includeParam, paramName, name, value, インクルードパラメータ

</details>

## checkboxタグ

## checkboxタグ

:ref:`WebView_CheckboxTag`

**共通属性**: :ref:`WebView_GenericAttributesTag`, :ref:`WebView_FocusAttributesTag`

checkboxesタグで表示できないレイアウト時に使用する。

| 属性 | 必須 | デフォルト | 説明 |
|---|---|---|---|
| name | ○ | | XHTMLのname属性 |
| value | | 1 | XHTMLのvalue属性。チェックありの場合に使用する値 |
| autofocus | | | HTML5のautofocus属性 |
| label | | | チェックありの場合に使用するラベル。入力画面ではこのラベルが表示される |
| useOffValue | | true | チェックなしの値設定を使用するか否か |
| offLabel | | | チェックなしの場合に使用するラベル |
| offValue | | 0 | チェックなしの場合に使用する値 |
| disabled | | | XHTMLのdisabled属性 |
| onchange | | | XHTMLのonchange属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス（カンマ区切りで複数指定可） |

## buttonタグ

ボタンタグ。

:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` の属性を使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI。:ref:`WebView_SpecifyUri` を参照 |
| value | | | XHTMLのvalue属性 |
| type | | | XHTMLのtype属性 |
| disabled | | | XHTMLのdisabled属性 |
| autofocus | | | HTML5のautofocus属性 |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か。許可する場合はtrue、しない場合はfalse |
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |
| displayMethod | | | 認可判定と開閉局判定の結果に応じた表示制御方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示） |

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

`confirmationPage`タグの属性一覧。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| path | | | フォワード先（入力画面）のパス |

<details>
<summary>keywords</summary>

checkboxタグ, checkboxesタグ, useOffValue, offValue, offLabel, errorCss, nameAlias, チェックボックス, WebView_CheckboxTag, button, ボタン, allowDoubleSubmission, displayMethod, secure, uri, scriptタグ, JavaScript, src, type, xmlSpace, confirmationPage, path, 確認画面, フォワード

</details>

## submitLinkタグ

## submitLinkタグ

リンク形式の送信タグ。

:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` の属性を使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI。:ref:`WebView_SpecifyUri` を参照 |
| shape | | | XHTMLのshape属性 |
| coords | | | XHTMLのcoords属性 |
| allowDoubleSubmission | | true | 二重サブミットを許可するか否か。許可する場合はtrue、しない場合はfalse |
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |
| displayMethod | | | 認可判定と開閉局判定の結果に応じた表示制御方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示） |

## errorsタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| cssClass | | nablarch_errors | リスト表示においてulタグに使用するCSSクラス名 |
| infoCss | | nablarch_info | 情報レベルのメッセージに使用するCSSクラス名 |
| warnCss | | nablarch_warn | 警告レベルのメッセージに使用するCSSクラス名 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| filter | | all | リストに含めるメッセージのフィルタ条件。all(全てのメッセージを表示)、global(入力項目に対応しないメッセージのみを表示)。globalの場合、ValidationResultMessageのプロパティ名が入っているメッセージを取り除いて出力する |

`ignoreConfirmation`タグ。属性なし。

<details>
<summary>keywords</summary>

submitLink, リンク送信, allowDoubleSubmission, displayMethod, secure, uri, shape, coords, errorsタグ, エラーメッセージ一覧, cssClass, filter, ValidationResultMessage, global, nablarch_errors, infoCss, warnCss, errorCss, ignoreConfirmation, 確認画面スキップ

</details>

## popupSubmitタグ

## popupSubmitタグ

ポップアップウィンドウを開く送信ボタンタグ。

:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` の属性を使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
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
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |
| popupWindowName | | | ポップアップのウィンドウ名。window.open関数の第2引数に指定する |
| popupOption | | | ポップアップのオプション情報。window.open関数の第3引数に指定する |
| displayMethod | | | 認可判定と開閉局判定の結果に応じた表示制御方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示） |

## errorタグ

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | エラーメッセージを表示する入力項目のname属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| messageFormat | | div | メッセージ表示時に使用するフォーマット。div(divタグ)、span(spanタグ) |

`forInputPage`タグ。属性なし。

<details>
<summary>keywords</summary>

popupSubmit, ポップアップ送信ボタン, popupWindowName, popupOption, displayMethod, secure, uri, type, errorタグ, エラーメッセージ, name, messageFormat, errorCss, nablarch_error, forInputPage, 入力画面, 条件分岐

</details>

## popupButtonタグ

## popupButtonタグ

ポップアップウィンドウを開くボタンタグ。

:ref:`WebView_GenericAttributesTag` および :ref:`WebView_FocusAttributesTag` の属性を使用可能。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | | | XHTMLのname属性 |
| uri | ○ | | URI。:ref:`WebView_SpecifyUri` を参照 |
| value | | | XHTMLのvalue属性 |
| type | | | XHTMLのtype属性 |
| disabled | | | XHTMLのdisabled属性 |
| autofocus | | | HTML5のautofocus属性 |
| secure | | | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse |
| popupWindowName | | | ポップアップのウィンドウ名。window.open関数の第2引数に指定する |
| popupOption | | | ポップアップのオプション情報。window.open関数の第3引数に指定する |
| displayMethod | | | 認可判定と開閉局判定の結果に応じた表示制御方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示） |

## noCacheタグ

属性なし。

`forConfirmationPage`タグ。属性なし。

<details>
<summary>keywords</summary>

popupButton, ポップアップボタン, popupWindowName, popupOption, displayMethod, secure, uri, noCacheタグ, キャッシュ無効化, noCache, forConfirmationPage, 確認画面, 条件分岐

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
| pattern | | (指定なし) | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | $NAME$ | ラベルを整形するパターン。プレースホルダ: $NAME$(コード名称)、$SHORTNAME$(略称)、$OPTIONALNAME$(オプション名称、optionColumnName属性の指定が必須)、$VALUE$(コード値) |
| listFormat | | br | リスト表示時に使用するフォーマット。br、div、span、ul、ol、sp(スペース区切り) |
| withNoneOption | | false | リスト先頭に選択なしのオプションを追加するか否か |
| noneOptionLabel | | "" | リスト先頭に選択なしのオプションを追加する場合のラベル。withNoneOptionにtrueを指定した場合のみ有効 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

<details>
<summary>keywords</summary>

codeSelectタグ, コードセレクト, codeId, labelPattern, withNoneOption, noneOptionLabel, コード値, プルダウン, listFormat, nameAlias, optionColumnName, pattern

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
| autofocus | | | HTML5のautofocus属性。選択肢のうち、先頭要素のみautofocus属性を出力する |
| pattern | | (指定なし) | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | $NAME$ | ラベルを整形するパターン。プレースホルダ: $NAME$(コード名称)、$SHORTNAME$(略称)、$OPTIONALNAME$(オプション名称、optionColumnName属性の指定が必須)、$VALUE$(コード値) |
| listFormat | | br | リスト表示時に使用するフォーマット。br、div、span、ul、ol、sp(スペース区切り) |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| nameAlias | | | name属性のエイリアス。複数指定する場合はカンマ区切り |

<details>
<summary>keywords</summary>

codeRadioButtonsタグ, コードラジオボタン, codeId, labelPattern, コード値, ラジオボタン, listFormat, nameAlias, optionColumnName, pattern

</details>
