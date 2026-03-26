# カスタムタグライブラリに関する設定

## NablarchTagHandlerの設定

カスタムタグを使用する場合は `NablarchTagHandler` の設定が必須。

NablarchTagHandlerが行う処理:
- :ref:`WebView_ChangeableParams`
- :ref:`WebView_HiddenEncryption`
- :ref:`WebView_SingleCheckBoxTag` (checkboxタグのチェックなしに対する値の設定)

設定値の詳細は :ref:`NablarchTagHandler` を参照。

<details>
<summary>keywords</summary>

NablarchTagHandler, カスタムタグ, 前処理ハンドラ, WebView_ChangeableParams, WebView_HiddenEncryption, WebView_SingleCheckBoxTag

</details>

## カスタムタグのデフォルト値の設定

`CustomTagConfig` クラスを `"customTagConfig"` という名前でリポジトリに登録することで、カスタムタグのデフォルト値を設定する。

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| errorCss | | errorタグと入力項目タグのerrorCss属性のデフォルト値 |
| messageFormat | | errorタグのmessageFormat属性のデフォルト値 |
| elementLabelPattern | | selectタグ、radioButtonsタグ、checkboxesタグのelementLabelPattern属性のデフォルト値 |
| listFormat | | selectタグ、radioButtonsタグ、checkboxesタグのlistFormat属性のデフォルト値 |
| codeLabelPattern | | codeSelectタグ、codeRadioButtonsタグ、codeCheckboxesタグ、codeタグのlabelPattern属性のデフォルト値 |
| codeListFormat | | codeSelectタグ、codeRadioButtonsタグ、codeCheckboxesタグ、codeタグのlistFormat属性のデフォルト値 |
| lineSeparator | LF | カスタムタグが出力時に使用する改行コード（LF/CR/CRLF） |
| port | | URIでhttpとhttpsを切り替える際のhttp用ポート番号 |
| securePort | | URIでhttpとhttpsを切り替える際のhttps用ポート番号 |
| host | | URIでhttpとhttpsを切り替える際のホストのデフォルト値 |
| yyyymmddPattern | | 年月日フォーマットに使用するデフォルトパターン |
| dateTimePattern | | 日時フォーマットに使用するデフォルトパターン |
| patternSeparator | | フォーマットに使用するパターンの区切り文字 |
| useHiddenEncryption | true | hiddenタグの暗号化機能を使用するか否か |
| noHiddenEncryptionRequestIds | | hiddenタグを暗号化しないリクエストIDのリスト（:ref:`list要素<repository_elements_list>` で指定） |
| checkboxOnValue | | checkboxタグのチェックありに対する値 |
| checkboxOffValue | | checkboxタグのチェックなしに対する値 |
| resourcePathRule | DirectoryBasedResourcePathRuleのインスタンス | 言語対応リソースパス取得に使用するルール（`nablarch.fw.web.i18n.ResourcePathRule` インタフェース実装クラス）。詳細は [http_response_handler_i18n](../handlers/handlers-HttpResponseHandler.md) を参照 |
| scriptBodyPrefix | `<!--` | scriptタグのボディに対するプレフィックス |
| scriptBodySuffix | `-->` | scriptタグのボディに対するサフィックス |
| displayControlCheckers | | フォームのサブミットタグの表示制御条件一覧（`nablarch.common.web.tag.DisplayControlChecker` インタフェース実装クラスのリスト） |
| displayMethod | NORMAL | サブミットタグの表示制御方法（NODISPLAY/DISABLED/NORMAL） |
| submitLinkDisabledJsp | | displayMethodがDISABLEDの場合に使用するJSPファイルのURL。JSPファイルを編集することで、非活性時の描画方法をカスタマイズできる。SubmitLinkのボディ部の値は `nablarch_link_body` キーで、活性時のaタグ属性は `nablarch_link_attributes_<属性名>` キー（例: `nablarch_link_attributes_class`）でリクエストスコープに格納される。以下は非活性項目を打ち消し線付きで描画する例:
```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<span class="<n:write name="nablarch_link_attributes_class" withHtmlFormat="false"/>" style="text-decoration: line-through;">
<n:write name="nablarch_link_body" />
</span>
``` |
| safeTags | b,big,blockquote,br,caption,center,dd,del,dl,dt,em,font,h1,h2,h3,hr,i,ins,li,ol,p,small,strong,sub,sup,table,td,th,tr,u,ul | n:prettyPrintタグにおいてHTMLエスケープせずにそのまま出力するHTMLタグ名（カンマ区切り） |
| safeAttributes | color,size,border,colspan,rowspan,bgcolor | n:prettyPrintタグにおいてHTMLエスケープせずにそのまま出力するHTML属性名（カンマ区切り） |
| useValueAsNullIfObjectExists | true | 入力系タグでname属性指定の値取得時に、値を保持するオブジェクトがnullであればnullとして動作するか否か。後方互換性のために存在。falseに設定するとリクエストスコープにオブジェクトが存在しても、プロパティがnullであればリクエストパラメータの値を優先する |
| popupWindowName | | ポップアップのウィンドウ名。window.open関数の第2引数に渡される |
| popupOption | | ポップアップのオプション情報。window.open関数の第3引数に渡される（例: `width=200,height=100`） |
| autocompleteDisableTarget | none | autocomplete属性をOFFにする対象（all/password/none）。カスタムタグで個別指定した場合は個別指定値が優先される |

<details>
<summary>keywords</summary>

CustomTagConfig, customTagConfig, カスタムタグデフォルト値, errorCss, messageFormat, elementLabelPattern, listFormat, codeLabelPattern, codeListFormat, lineSeparator, port, securePort, host, yyyymmddPattern, dateTimePattern, patternSeparator, useHiddenEncryption, noHiddenEncryptionRequestIds, checkboxOnValue, checkboxOffValue, resourcePathRule, nablarch.fw.web.i18n.ResourcePathRule, DirectoryBasedResourcePathRule, scriptBodyPrefix, scriptBodySuffix, displayControlCheckers, nablarch.common.web.tag.DisplayControlChecker, displayMethod, submitLinkDisabledJsp, safeTags, safeAttributes, useValueAsNullIfObjectExists, autocompleteDisableTarget, popupWindowName, popupOption, n:prettyPrint, nablarch_link_body, nablarch_link_attributes_class

</details>
