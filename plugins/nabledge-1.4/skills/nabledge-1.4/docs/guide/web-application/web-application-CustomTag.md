# 画面オンライン処理の実装例集

本ページでは以下の実装例を説明する。

## 基本的な説明

./basic/

* [taglibディレクティブの指定方法](../../guide/web-application/web-application-basic.md#import-taglib-dilective)
* [URIの指定方法](../../guide/web-application/web-application-basic.md#uri-specifing)
* [JSPとActionクラスの間でデータを受け渡す方法](../../guide/web-application/web-application-basic.md#for-data-passing)
* [ウィンドウスコープの使用法](../../guide/web-application/web-application-basic.md#howto-window-scope)
* [JSP上で変数に値を設定する方法](../../guide/web-application/web-application-basic.md#set-value-on-jsp)

## 画面の入出力に関する実装例

./inputAndOutput/

* [フォーム内の入力要素を出力するカスタムタグ](../../guide/web-application/web-application-inputAndOutput.md#howto-single-input)
* [コード値の表示方法](../../guide/web-application/web-application-inputAndOutput.md#code-select)
* [入力/選択項目での初期値設定](../../guide/web-application/web-application-inputAndOutput.md#default-value-setting)
* [入力項目の確認画面用の出力](../../guide/web-application/web-application-inputAndOutput.md#howto-output-for-confirmation-page)
* [エラーメッセージの表示、エラー項目のハイライト](../../guide/web-application/web-application-inputAndOutput.md#output-for-error)
* [メッセージの表示](../../guide/web-application/web-application-inputAndOutput.md#custom-tag-message)
* [出力フォーマットの変更方法](../../guide/web-application/web-application-inputAndOutput.md#change-output-format)
* [HTMLエスケープせずに値を出力する方法](../../guide/web-application/web-application-inputAndOutput.md#howto-output-without-html-escape)
* [hiddenタグの暗号化機能の解除](../../guide/web-application/web-application-inputAndOutput.md#for-not-encryption)

## 画面遷移に関する実装例

./screenTransition/

* [ボタン又はリンクによるサブミット](../../guide/web-application/web-application-screenTransition.md#submit-with-button-and-link)
* [Enterキー押下時にデフォルトで動作するサブミットボタンを設定する方法](../../guide/web-application/web-application-screenTransition.md#default-button-on-enter)
* [一覧照会画面から詳細画面へ遷移する場合](../../guide/web-application/web-application-screenTransition.md#howto-submit-from-refer-to-detail)
* [複数ウィンドウを立ち上げたい場合](../../guide/web-application/web-application-screenTransition.md#howto-open-multi-window)
* [二重サブミットの防止](../../guide/web-application/web-application-screenTransition.md#howto-prevent-double-submission)
* [入力画面と確認画面の共通化をサポートするカスタムタグ](../../guide/web-application/web-application-screenTransition.md#common-page-support)
* [ブラウザのキャッシュ防止](../../guide/web-application/web-application-screenTransition.md#howto-prevent-history-back)

## よくある業務処理の実装例

./function/

* [ファイルダウンロードの実現方法](../../guide/web-application/web-application-function.md#howto-file-download)
* [ファイルアップロードの実現方法](../../guide/web-application/web-application-function.md#howto-file-upload)
* [検索結果の一覧表示](../../guide/web-application/web-application-function.md#custom-tag-paging)

  * [ページングを使用した一覧表示](../../guide/web-application/web-application-function.md#custom-tag-paging-paging)
  * [特定の一覧表示で表示件数と検索結果件数(上限)を個別に設定する方法](../../guide/web-application/web-application-function.md#custom-tag-paging-specified-page-settings)
  * [検索結果の並び替え](../../guide/web-application/web-application-function.md#custom-tag-paging-sort)
  * [ページングを使用しない一覧表示](../../guide/web-application/web-application-function.md#custom-tag-paging-nopaging)
* [複合キーを使用したデータの一覧画面から、ラジオボタン・チェックボックスでデータを選択する](../../guide/web-application/web-application-function.md#using-composite-key)
* [Javascriptの使用](../../guide/web-application/web-application-function.md#using-javascript)
