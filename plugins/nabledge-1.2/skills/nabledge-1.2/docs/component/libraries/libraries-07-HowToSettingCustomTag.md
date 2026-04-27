# カスタムタグライブラリに関する設定

## NablarchTagHandlerの設定

NablarchTagHandlerは、カスタムタグを使用したリクエストを処理する際に必要となる前処理を行うハンドラである。
カスタムタグを使用する場合は、NablarchTagHandlerの設定が必須となる。
NablarchTagHandlerの処理内容は、リンク先の説明を参照。

* [ボタン又はリンク毎にパラメータを変更する方法](../../component/libraries/libraries-07-SubmitTag.md#webview-changeableparams)
* [hiddenタグの暗号化](../../component/libraries/libraries-07-FormTag.md#webview-hiddenencryption)
* [checkboxタグのチェックなしに対する値の設定](../../component/libraries/libraries-07-FormTagList.md#webview-singlecheckboxtag)

NablarchTagHandler の設定値の詳細は、  [Nablarchカスタムタグ制御ハンドラ](../../component/handlers/handlers-NablarchTagHandler.md#nablarchtaghandler) に記載する。

## カスタムタグのデフォルト値の設定

選択項目のラベルパターンなど、カスタムタグの属性は、個々の画面で毎回設定するよりも、アプリケーション全体で統一したデフォルト値を使用したい場合がある。
このため、カスタムタグのデフォルト値の設定を行う機能を提供する。

カスタムタグのデフォルト値の設定は、CustomTagConfigクラスを"customTagConfig"という名前でリポジトリに登録することで行う。
下記のプロパティを指定することができる。

| property名 | 設定内容 |
|---|---|
| errorCss | errorタグと入力項目タグのerrorCss属性のデフォルト値。 |
| messageFormat | errorタグのmessageFormat属性のデフォルト値。 |
| elementLabelPattern | selectタグ、radioButtonsタグ、checkboxesタグのelementLabelPattern属性のデフォルト値。 |
| listFormat | selectタグ、radioButtonsタグ、checkboxesタグのlistFormat属性のデフォルト値。 |
| codeLabelPattern | codeSelectタグ、codeRadioButtonsタグ、codeCheckboxesタグ、codeタグのlabelPattern属性のデフォルト値。 |
| codeListFormat | codeSelectタグ、codeRadioButtonsタグ、codeCheckboxesタグ、codeタグのlistFormat属性のデフォルト値。 |
| lineSeparator | カスタムタグが出力時に使用する改行コードのデフォルト値。 下記のいずれかを指定する。 LF(Line Feed) CR(Carriage Return) CRLF デフォルトはLF。 |
| port | URI指定でhttpとhttpsを切り替える際に使用するhttp用のポート番号。 |
| securePort | URI指定でhttpとhttpsを切り替える際に使用するhttps用のポート番号。 |
| host | URI指定でhttpとhttpsを切り替える際に使用するホストのデフォルト値。 |
| yyyymmddPattern | 年月日のフォーマットに使用するデフォルトのパターンのデフォルト値。 |
| dateTimePattern | 日時のフォーマットに使用するデフォルトのパターンのデフォルト値。 |
| patternSeparator | フォーマットに使用するパターンの区切り文字のデフォルト値。 |
| useHiddenEncryption | hiddenタグの暗号化機能を使用するか否かのデフォルト値。 デフォルトはtrue。 |
| noHiddenEncryptionRequestIds | hiddenタグを暗号化しないリクエストIDのデフォルト値。 [list要素](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-list) で指定する。 |
| listSearchResultWrapperCss | listSearchResultタグのlistSearchResultWrapperCss属性のデフォルト値。 |
| useResultCount | listSearchResultタグのuseResultCount属性のデフォルト値。 |
| resultCountCss | listSearchResultタグのresultCountCss属性のデフォルト値。 |
| usePaging | listSearchResultタグのusePaging属性のデフォルト値。 |
| pagingPosition | listSearchResultタグのpagingPosition属性のデフォルト値。 |
| pagingCss | listSearchResultタグのpagingCss属性のデフォルト値。 |
| useCurrentPageNumber | listSearchResultタグのuseCurrentPageNumber属性のデフォルト値。 |
| currentPageNumberCss | listSearchResultタグのcurrentPageNumberCss属性のデフォルト値。 |
| useFirstSubmit | listSearchResultタグのuseFirstSubmit属性のデフォルト値。 |
| firstSubmitTag | listSearchResultタグのfirstSubmitTag属性のデフォルト値。 |
| firstSubmitType | listSearchResultタグのfirstSubmitType属性のデフォルト値。 |
| firstSubmitCss | listSearchResultタグのfirstSubmitCss属性のデフォルト値。 |
| firstSubmitLabel | listSearchResultタグのfirstSubmitLabel属性のデフォルト値。 |
| firstSubmitName | listSearchResultタグのfirstSubmitName属性のデフォルト値。 |
| usePrevSubmit | listSearchResultタグのusePrevSubmit属性のデフォルト値。 |
| prevSubmitTag | listSearchResultタグのprevSubmitTag属性のデフォルト値。 |
| prevSubmitType | listSearchResultタグのprevSubmitType属性のデフォルト値。 |
| prevSubmitCss | listSearchResultタグのprevSubmitCss属性のデフォルト値。 |
| prevSubmitLabel | listSearchResultタグのprevSubmitLabel属性のデフォルト値。 |
| prevSubmitName | listSearchResultタグのprevSubmitName属性のデフォルト値。 |
| usePageNumberSubmit | listSearchResultタグのusePageNumberSubmit属性のデフォルト値。 |
| pageNumberSubmitWrapperCss | listSearchResultタグのpageNumberSubmitWrapperCss属性のデフォルト値。 |
| pageNumberSubmitTag | listSearchResultタグのpageNumberSubmitTag属性のデフォルト値。 |
| pageNumberSubmitType | listSearchResultタグのpageNumberSubmitType属性のデフォルト値。 |
| pageNumberSubmitCss | listSearchResultタグのpageNumberSubmitCss属性のデフォルト値。 |
| pageNumberSubmitName | listSearchResultタグのpageNumberSubmitName属性のデフォルト値。 |
| useNextSubmit | listSearchResultタグのuseNextSubmit属性のデフォルト値。 |
| nextSubmitTag | listSearchResultタグのnextSubmitTag属性のデフォルト値。 |
| nextSubmitType | listSearchResultタグのnextSubmitType属性のデフォルト値。 |
| nextSubmitCss | listSearchResultタグのnextSubmitCss属性のデフォルト値。 |
| nextSubmitLabel | listSearchResultタグのnextSubmitLabel属性のデフォルト値。 |
| nextSubmitName | listSearchResultタグのnextSubmitName属性のデフォルト値。 |
| useLastSubmit | listSearchResultタグのuseLastSubmit属性のデフォルト値。 |
| lastSubmitTag | listSearchResultタグのlastSubmitTag属性のデフォルト値。 |
| lastSubmitType | listSearchResultタグのlastSubmitType属性のデフォルト値。 |
| lastSubmitCss | listSearchResultタグのlastSubmitCss属性のデフォルト値。 |
| lastSubmitLabel | listSearchResultタグのlastSubmitLabel属性のデフォルト値。 |
| lastSubmitName | listSearchResultタグのlastSubmitName属性のデフォルト値。 |
| resultSetCss | listSearchResultタグのresultSetCss属性のデフォルト値。 |
| varRowName | listSearchResultタグのvarRowName属性のデフォルト値。 |
| varStatusName | listSearchResultタグのvarStatusName属性のデフォルト値。 |
| varCountName | listSearchResultタグのvarCountName属性のデフォルト値。 |
| varRowCountName | listSearchResultタグのvarRowCountName属性のデフォルト値。 |
| varOddEvenName | listSearchResultタグのvarOddEvenName属性のデフォルト値。 |
| oddValue | listSearchResultタグのoddValue属性のデフォルト値。 |
| evenValue | listSearchResultタグのevenValue属性のデフォルト値。 |
| sortSubmitTag | listSearchSortSubmitタグのsortSubmitTag属性のデフォルト値。 |
| sortSubmitType | listSearchSortSubmitタグのsortSubmitType属性のデフォルト値。 |
| sortSubmitCss | listSearchSortSubmitタグのsortSubmitCss属性のデフォルト値。 |
| ascSortSubmitCss | listSearchSortSubmitタグのascSortSubmitCss属性のデフォルト値。 |
| descSortSubmitCss | listSearchSortSubmitタグのdescSortSubmitCss属性のデフォルト値。 |
| defaultSort | listSearchSortSubmitタグのdefaultSort属性のデフォルト値。 |
| checkboxOnValue | checkboxタグのチェックありに対する値のデフォルト値。 |
| checkboxOffValue | checkboxタグのチェックなしに対する値のデフォルト値。 |
| resourcePathRule | 言語対応のリソースパスを取得する際に使用するリソースパスルール。 nablarch.fw.web.i18n.ResourcePathRuleインタフェースを実装したクラスのインスタンスを指定する。 ResourcePathRuleおよびサブクラスの詳細は、 [言語毎のコンテンツパスの切り替え](../../component/handlers/handlers-HttpResponseHandler.md#http-response-handler-i18n) を参照。 デフォルトはDirectoryBasedResourcePathRuleのインスタンス。 |
| scriptBodyPrefix | scriptタグのボディに対するプレフィックス。 デフォルトを下記に示す。  ```bash <!-- ``` |
| scriptBodySuffix | scriptタグのボディに対するサフィックス。 デフォルトを下記に示す。  ```bash --> ``` |
| displayControlCheckers | フォームのサブミットを行うタグの表示制御を行うか否かの判定を行う条件一覧。 nablarch.common.web.tag.DisplayControlCheckerインタフェースを実装したクラスのリストを設定する。 |
| displayMethod | サブミットを行うタグの表示制御を行う場合の表示方法。 認可判定と開閉局判定の結果に応じて表示制御を行う場合に使用される。 下記のいずれかを指定する。 NODISPLAY (非表示) DISABLED (非活性) NORMAL (通常表示) デフォルトはNORMAL。 |
| submitLinkDisabledJsp | displayMethod の設定値が DISABLED の場合に使用するJSPファイルの URLを設定する。JSPファイルを編集することで、非活性時の描画方法をカスタマイズできる。 SubmitLinkのボディ部の値は、 nablarch_link_body というキーで リクエストスコープに格納されている。 また、活性時に a タグに出力される id や class といった属性は、  nablarch_link_attributes_<属性名> というキーでリクエストスコープに格納されている。 以下に例を示す。この例では、非活性項目はボディ部の内容が打ち消し線付きで描画され、 n:SubmitLink タグの cssClass 属性に指定した属性(活性時は a タグの class 属性に出力される) がそのまま span タグの class に出力される。  ```jsp <%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="n"            uri="http://tis.co.jp/nablarch" %> <span class="<n:write name="nablarch_link_attributes_class" withHtmlFormat="false"/>"       style="text-decoration: line-through;"> <n:write name="nablarch_link_body" /> </span> ``` |
| safeTags | 修飾付き出力(n:prettyPrint)タグにおいて、 HTMLエスケープの対象とせずにHTMLタグとしてそのまま出力するタグ名のリスト をカンマ区切りで設定する。 デフォルトの設定では、以下のタグが利用できる。  * b * big * blockquote * br * caption * center * dd * del * dl * dt * em * font * h1 * h2 * h3 * hr * i * ins * li * ol * p * small * strong * sub * sup * table * td * th * tr * u * ul |
| safeAttributes | 修飾付き出力(n:prettyPrint)タグにおいて、 HTMLエスケープの対象とせずにHTMLタグとしてそのまま出力する属性名のリスト をカンマ区切りで設定する。 デフォルトの設定では、以下の属性が利用できる。  * color * size * border * colspan * rowspan * bgcolor |
| useValueAsNullIfObjectExists | 入力系のタグで name 属性に指定した名称に対応する値を取得する際に、 値を保持するオブジェクトが null であれば null を設定されたものとして動作するか否かを設定する。 本設定値は後方互換性のために存在する。 false に設定することで、 リクエストスコープに設定されたオブジェクトが存在した場合も、 プロパティが null であればリクエストパラメータの値を優先的に使用するよう 動作する。 デフォルトは true 。 |
| popupWindowName | ポップアップのウィンドウ名を設定する。 新規ポップアップウィンドウを開くとき、window.open関数の第2引数に渡される。 |
| popupOption | ポップアップのオプション情報を設定する。 新規ポップアップウィンドウを開くとき、window.open関数の第3引数に渡される。 例えば、 width=200,height=100 のように指定する。 |
| autocompleteDisableTarget | autocomplete属性をOFFにする対象のデフォルト値。 下記のいずれかを指定する。 all(すべてのタグ) password(パスワードのみ) none(対象なし) デフォルトはnone。 カスタムタグでautocomplete属性を個別指定した場合は、デフォルト値でなく個別指定した値が使用される。 |
