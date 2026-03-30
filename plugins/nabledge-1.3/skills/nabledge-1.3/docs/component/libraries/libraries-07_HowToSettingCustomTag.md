# カスタムタグライブラリに関する設定

## NablarchTagHandlerの設定

カスタムタグを使用する場合、`NablarchTagHandler` の設定が必須。

**クラス**: `NablarchTagHandler`

カスタムタグを使用したリクエストの前処理を行うハンドラ。処理内容は :ref:`WebView_ChangeableParams`、:ref:`WebView_HiddenEncryption`、:ref:`checkboxタグのチェックなしに対する値の設定<WebView_SingleCheckBoxTag>` を参照。設定値の詳細は :ref:`NablarchTagHandler` を参照。

<details>
<summary>keywords</summary>

NablarchTagHandler, カスタムタグ, ハンドラ設定, 前処理, WebView_NablarchTagHandler

</details>

## カスタムタグのデフォルト値の設定

**クラス**: `CustomTagConfig`

`"customTagConfig"` という名前でリポジトリに登録する。

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| errorCss | | errorタグと入力項目タグのerrorCss属性のデフォルト値 |
| messageFormat | | errorタグのmessageFormat属性のデフォルト値 |
| elementLabelPattern | | selectタグ、radioButtonsタグ、checkboxesタグのelementLabelPattern属性のデフォルト値 |
| listFormat | | selectタグ、radioButtonsタグ、checkboxesタグのlistFormat属性のデフォルト値 |
| codeLabelPattern | | codeSelectタグ、codeRadioButtonsタグ、codeCheckboxesタグ、codeタグのlabelPattern属性のデフォルト値 |
| codeListFormat | | codeSelectタグ、codeRadioButtonsタグ、codeCheckboxesタグ、codeタグのlistFormat属性のデフォルト値 |
| lineSeparator | LF | カスタムタグ出力時の改行コード（LF/CR/CRLF） |
| port | | httpとhttpsを切り替える際のhttp用ポート番号 |
| securePort | | httpとhttpsを切り替える際のhttps用ポート番号 |
| host | | httpとhttpsを切り替える際のホスト |
| yyyymmddPattern | | 年月日フォーマットのデフォルトパターン |
| dateTimePattern | | 日時フォーマットのデフォルトパターン |
| patternSeparator | | フォーマットパターンの区切り文字 |
| useHiddenEncryption | true | hiddenタグの暗号化機能を使用するか否か |
| noHiddenEncryptionRequestIds | | hiddenタグを暗号化しないリクエストID。:ref:`list要素<repository_elements_list>` で指定 |
| checkboxOnValue | | checkboxタグのチェックありに対する値 |
| checkboxOffValue | | checkboxタグのチェックなしに対する値 |
| resourcePathRule | DirectoryBasedResourcePathRuleインスタンス | 言語対応リソースパスルール。`nablarch.fw.web.i18n.ResourcePathRule` 実装クラスを指定。詳細は [言語毎のコンテンツパスの切り替え](../handlers/handlers-HttpResponseHandler.md) 参照 |
| scriptBodyPrefix | `<!--` | scriptタグのボディのプレフィックス |
| scriptBodySuffix | `-->` | scriptタグのボディのサフィックス |
| displayControlCheckers | | サブミットタグの表示制御判定条件一覧。`nablarch.common.web.tag.DisplayControlChecker` 実装クラスのリストを設定 |
| displayMethod | NORMAL | サブミットタグの表示制御方法（NODISPLAY:非表示/DISABLED:非活性/NORMAL:通常表示） |
| submitLinkDisabledJsp | | displayMethodがDISABLEDの場合に使用するJSPファイルのURL。SubmitLinkのボディ部は `nablarch_link_body` キーで、活性時のaタグ属性は `nablarch_link_attributes_<属性名>` キーでリクエストスコープに格納 |
| safeTags | b,big,blockquote,br,caption,center,dd,del,dl,dt,em,font,h1,h2,h3,hr,i,ins,li,ol,p,small,strong,sub,sup,table,td,th,tr,u,ul | n:prettyPrintタグでHTMLエスケープせずそのまま出力するタグ名（カンマ区切り） |
| safeAttributes | color,size,border,colspan,rowspan,bgcolor | n:prettyPrintタグでHTMLエスケープせずそのまま出力する属性名（カンマ区切り） |
| useValueAsNullIfObjectExists | true | 入力系タグでname属性に対応するオブジェクトがnullの場合にnullとして動作するか否か。後方互換性のための設定。falseにするとオブジェクトが存在してもプロパティがnullならリクエストパラメータ値を優先 |
| popupWindowName | | ポップアップのウィンドウ名（window.openの第2引数） |
| popupOption | | ポップアップのオプション情報（window.openの第3引数。例：`width=200,height=100`） |
| autocompleteDisableTarget | none | autocomplete属性をOFFにする対象（all:全タグ/password:パスワードのみ/none:対象なし）。個別タグで個別指定した場合はデフォルト値より個別指定が優先 |

`submitLinkDisabledJsp` の設定例（非活性時に打ち消し線付きで描画）：

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<span class="<n:write name="nablarch_link_attributes_class" withHtmlFormat="false"/>" 
      style="text-decoration: line-through;">
<n:write name="nablarch_link_body" />
</span>
```

<details>
<summary>keywords</summary>

CustomTagConfig, customTagConfig, errorCss, messageFormat, elementLabelPattern, listFormat, codeLabelPattern, codeListFormat, lineSeparator, port, securePort, host, yyyymmddPattern, dateTimePattern, patternSeparator, useHiddenEncryption, noHiddenEncryptionRequestIds, checkboxOnValue, checkboxOffValue, resourcePathRule, DirectoryBasedResourcePathRule, DisplayControlChecker, displayControlCheckers, displayMethod, submitLinkDisabledJsp, safeTags, safeAttributes, useValueAsNullIfObjectExists, popupWindowName, popupOption, autocompleteDisableTarget, カスタムタグ デフォルト値, n:prettyPrint, hiddenタグ暗号化, 表示制御, scriptBodyPrefix, scriptBodySuffix

</details>
