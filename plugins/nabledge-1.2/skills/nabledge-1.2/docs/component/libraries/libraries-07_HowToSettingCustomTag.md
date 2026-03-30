# カスタムタグライブラリに関する設定

## NablarchTagHandlerの設定

カスタムタグを使用する場合は `NablarchTagHandler` の設定が必須。

**クラス**: `NablarchTagHandler`

NablarchTagHandlerの処理内容:
- :ref:`WebView_ChangeableParams`
- :ref:`WebView_HiddenEncryption`
- :ref:`checkboxタグのチェックなしに対する値の設定<WebView_SingleCheckBoxTag>`

設定値の詳細は :ref:`NablarchTagHandler` を参照。

<details>
<summary>keywords</summary>

NablarchTagHandler, カスタムタグ必須設定, リクエスト前処理ハンドラ, WebView_ChangeableParams, WebView_HiddenEncryption, WebView_SingleCheckBoxTag

</details>

## カスタムタグのデフォルト値の設定

**クラス**: `CustomTagConfig`（リポジトリ登録名: `customTagConfig`）

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| errorCss | | errorタグと入力項目タグのerrorCss属性のデフォルト値 |
| messageFormat | | errorタグのmessageFormat属性のデフォルト値 |
| elementLabelPattern | | selectタグ、radioButtonsタグ、checkboxesタグのelementLabelPattern属性のデフォルト値 |
| listFormat | | selectタグ、radioButtonsタグ、checkboxesタグのlistFormat属性のデフォルト値 |
| codeLabelPattern | | codeSelectタグ、codeRadioButtonsタグ、codeCheckboxesタグ、codeタグのlabelPattern属性のデフォルト値 |
| codeListFormat | | codeSelectタグ、codeRadioButtonsタグ、codeCheckboxesタグ、codeタグのlistFormat属性のデフォルト値 |
| lineSeparator | LF | カスタムタグが出力時に使用する改行コード。LF/CR/CRLFから選択 |
| port | | URI指定でhttpとhttpsを切り替える際のhttp用ポート番号 |
| securePort | | URI指定でhttpとhttpsを切り替える際のhttps用ポート番号 |
| host | | URI指定でhttpとhttpsを切り替える際のホストのデフォルト値 |
| yyyymmddPattern | | 年月日フォーマットのデフォルトパターン |
| dateTimePattern | | 日時フォーマットのデフォルトパターン |
| patternSeparator | | フォーマットパターンの区切り文字のデフォルト値 |
| useHiddenEncryption | true | hiddenタグの暗号化機能を使用するか否か |
| noHiddenEncryptionRequestIds | | hiddenタグを暗号化しないリクエストID。:ref:`list要素<repository_elements_list>` で指定 |
| listSearchResultWrapperCss | | listSearchResultタグのlistSearchResultWrapperCss属性のデフォルト値 |
| useResultCount | | listSearchResultタグのuseResultCount属性のデフォルト値 |
| resultCountCss | | listSearchResultタグのresultCountCss属性のデフォルト値 |
| usePaging | | listSearchResultタグのusePaging属性のデフォルト値 |
| pagingPosition | | listSearchResultタグのpagingPosition属性のデフォルト値 |
| pagingCss | | listSearchResultタグのpagingCss属性のデフォルト値 |
| useCurrentPageNumber | | listSearchResultタグのuseCurrentPageNumber属性のデフォルト値 |
| currentPageNumberCss | | listSearchResultタグのcurrentPageNumberCss属性のデフォルト値 |
| useFirstSubmit | | listSearchResultタグのuseFirstSubmit属性のデフォルト値 |
| firstSubmitTag | | listSearchResultタグのfirstSubmitTag属性のデフォルト値 |
| firstSubmitType | | listSearchResultタグのfirstSubmitType属性のデフォルト値 |
| firstSubmitCss | | listSearchResultタグのfirstSubmitCss属性のデフォルト値 |
| firstSubmitLabel | | listSearchResultタグのfirstSubmitLabel属性のデフォルト値 |
| firstSubmitName | | listSearchResultタグのfirstSubmitName属性のデフォルト値 |
| usePrevSubmit | | listSearchResultタグのusePrevSubmit属性のデフォルト値 |
| prevSubmitTag | | listSearchResultタグのprevSubmitTag属性のデフォルト値 |
| prevSubmitType | | listSearchResultタグのprevSubmitType属性のデフォルト値 |
| prevSubmitCss | | listSearchResultタグのprevSubmitCss属性のデフォルト値 |
| prevSubmitLabel | | listSearchResultタグのprevSubmitLabel属性のデフォルト値 |
| prevSubmitName | | listSearchResultタグのprevSubmitName属性のデフォルト値 |
| usePageNumberSubmit | | listSearchResultタグのusePageNumberSubmit属性のデフォルト値 |
| pageNumberSubmitWrapperCss | | listSearchResultタグのpageNumberSubmitWrapperCss属性のデフォルト値 |
| pageNumberSubmitTag | | listSearchResultタグのpageNumberSubmitTag属性のデフォルト値 |
| pageNumberSubmitType | | listSearchResultタグのpageNumberSubmitType属性のデフォルト値 |
| pageNumberSubmitCss | | listSearchResultタグのpageNumberSubmitCss属性のデフォルト値 |
| pageNumberSubmitName | | listSearchResultタグのpageNumberSubmitName属性のデフォルト値 |
| useNextSubmit | | listSearchResultタグのuseNextSubmit属性のデフォルト値 |
| nextSubmitTag | | listSearchResultタグのnextSubmitTag属性のデフォルト値 |
| nextSubmitType | | listSearchResultタグのnextSubmitType属性のデフォルト値 |
| nextSubmitCss | | listSearchResultタグのnextSubmitCss属性のデフォルト値 |
| nextSubmitLabel | | listSearchResultタグのnextSubmitLabel属性のデフォルト値 |
| nextSubmitName | | listSearchResultタグのnextSubmitName属性のデフォルト値 |
| useLastSubmit | | listSearchResultタグのuseLastSubmit属性のデフォルト値 |
| lastSubmitTag | | listSearchResultタグのlastSubmitTag属性のデフォルト値 |
| lastSubmitType | | listSearchResultタグのlastSubmitType属性のデフォルト値 |
| lastSubmitCss | | listSearchResultタグのlastSubmitCss属性のデフォルト値 |
| lastSubmitLabel | | listSearchResultタグのlastSubmitLabel属性のデフォルト値 |
| lastSubmitName | | listSearchResultタグのlastSubmitName属性のデフォルト値 |
| resultSetCss | | listSearchResultタグのresultSetCss属性のデフォルト値 |
| varRowName | | listSearchResultタグのvarRowName属性のデフォルト値 |
| varStatusName | | listSearchResultタグのvarStatusName属性のデフォルト値 |
| varCountName | | listSearchResultタグのvarCountName属性のデフォルト値 |
| varRowCountName | | listSearchResultタグのvarRowCountName属性のデフォルト値 |
| varOddEvenName | | listSearchResultタグのvarOddEvenName属性のデフォルト値 |
| oddValue | | listSearchResultタグのoddValue属性のデフォルト値 |
| evenValue | | listSearchResultタグのevenValue属性のデフォルト値 |
| sortSubmitTag | | listSearchSortSubmitタグのsortSubmitTag属性のデフォルト値 |
| sortSubmitType | | listSearchSortSubmitタグのsortSubmitType属性のデフォルト値 |
| sortSubmitCss | | listSearchSortSubmitタグのsortSubmitCss属性のデフォルト値 |
| ascSortSubmitCss | | listSearchSortSubmitタグのascSortSubmitCss属性のデフォルト値 |
| descSortSubmitCss | | listSearchSortSubmitタグのdescSortSubmitCss属性のデフォルト値 |
| defaultSort | | listSearchSortSubmitタグのdefaultSort属性のデフォルト値 |
| checkboxOnValue | | checkboxタグのチェックありに対する値のデフォルト値 |
| checkboxOffValue | | checkboxタグのチェックなしに対する値のデフォルト値 |
| resourcePathRule | DirectoryBasedResourcePathRuleのインスタンス | 言語対応のリソースパスを取得する際に使用するリソースパスルール。`nablarch.fw.web.i18n.ResourcePathRule`インタフェースを実装したクラスのインスタンスを指定。詳細は [言語毎のコンテンツパスの切り替え](../handlers/handlers-HttpResponseHandler.md) を参照 |
| scriptBodyPrefix | `<!--` | scriptタグのボディに対するプレフィックス |
| scriptBodySuffix | `-->` | scriptタグのボディに対するサフィックス |
| displayControlCheckers | | フォームのサブミットを行うタグの表示制御の判定条件一覧。`nablarch.common.web.tag.DisplayControlChecker`インタフェースを実装したクラスのリストを設定 |
| displayMethod | NORMAL | サブミットを行うタグの表示制御の表示方法。NODISPLAY（非表示）/DISABLED（非活性）/NORMAL（通常表示）から選択 |
| submitLinkDisabledJsp | | `displayMethod`が`DISABLED`の場合に使用するJSPファイルのURL。JSPファイル編集で非活性時の描画方法をカスタマイズ可能。SubmitLinkのボディ部は`nablarch_link_body`キーでリクエストスコープに格納。活性時にaタグに出力される属性は`nablarch_link_attributes_<属性名>`キーで格納 |
| safeTags | b,big,blockquote,br,caption,center,dd,del,dl,dt,em,font,h1,h2,h3,hr,i,ins,li,ol,p,small,strong,sub,sup,table,td,th,tr,u,ul | n:prettyPrintタグでHTMLエスケープ対象外とするHTMLタグ名のリスト（カンマ区切り） |
| safeAttributes | color,size,border,colspan,rowspan,bgcolor | n:prettyPrintタグでHTMLエスケープ対象外とする属性名のリスト（カンマ区切り） |
| useValueAsNullIfObjectExists | true | name属性に対応するオブジェクトがnullであればnullとして動作するか否か。falseに設定すると、オブジェクトが存在してもプロパティがnullであればリクエストパラメータの値を優先使用（後方互換性のための設定） |
| popupWindowName | | ポップアップのウィンドウ名。window.open関数の第2引数に渡される |
| popupOption | | ポップアップのオプション情報。window.open関数の第3引数に渡される（例: `width=200,height=100`） |
| autocompleteDisableTarget | none | autocomplete属性をOFFにする対象。all（すべてのタグ）/password（パスワードのみ）/none（対象なし）から選択。個別指定した場合は個別指定値を優先 |

`submitLinkDisabledJsp` のJSP例（非活性項目をボディ部の内容が打ち消し線付きで描画する例）:

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

CustomTagConfig, customTagConfig, errorCss, messageFormat, elementLabelPattern, listFormat, codeLabelPattern, codeListFormat, lineSeparator, port, securePort, host, yyyymmddPattern, dateTimePattern, patternSeparator, useHiddenEncryption, noHiddenEncryptionRequestIds, listSearchResultWrapperCss, resultCountCss, pagingCss, useCurrentPageNumber, currentPageNumberCss, useFirstSubmit, firstSubmitTag, firstSubmitType, firstSubmitCss, firstSubmitLabel, firstSubmitName, usePrevSubmit, prevSubmitTag, prevSubmitType, prevSubmitCss, prevSubmitLabel, prevSubmitName, usePageNumberSubmit, pageNumberSubmitWrapperCss, pageNumberSubmitTag, pageNumberSubmitType, pageNumberSubmitCss, pageNumberSubmitName, useNextSubmit, nextSubmitTag, nextSubmitType, nextSubmitCss, nextSubmitLabel, nextSubmitName, useLastSubmit, lastSubmitTag, lastSubmitType, lastSubmitCss, lastSubmitLabel, lastSubmitName, resultSetCss, varRowName, varStatusName, varCountName, varRowCountName, varOddEvenName, oddValue, evenValue, sortSubmitTag, sortSubmitType, sortSubmitCss, ascSortSubmitCss, descSortSubmitCss, defaultSort, displayControlCheckers, displayMethod, submitLinkDisabledJsp, scriptBodyPrefix, scriptBodySuffix, safeTags, safeAttributes, autocompleteDisableTarget, checkboxOnValue, checkboxOffValue, useValueAsNullIfObjectExists, popupWindowName, popupOption, resourcePathRule, DirectoryBasedResourcePathRule, usePaging, useResultCount, pagingPosition, listSearchResult, DisplayControlChecker, ResourcePathRule, カスタムタグデフォルト値設定, リポジトリ登録

</details>
