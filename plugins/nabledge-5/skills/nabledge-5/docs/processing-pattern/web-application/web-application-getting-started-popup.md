# ポップアップ画面の作成

**公式ドキュメント**: [ポップアップ画面の作成](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/popup/index.html)

## ポップアップ(ダイアログ)画面を表示する

ポップアップ画面は別ウィンドウではなくダイアログ形式で作成する（:ref:`tag-submit_popup` 参照）。

ダイアログ表示にはBootstrap（OSS）を使用する。詳細は[Bootstrapのドキュメント(外部サイト、英語)](https://fezvrasta.github.io/bootstrap-material-design/)を参照。

**業務アクション**: ダイアログからのAjax呼び出しにより検索処理を実現する。アクションクラスの実装方法は :ref:`restful_web_service` を参照。

**ポップアップ画面JSP**: jQueryを使用してAjax呼び出しの結果を元にDOMを構築し結果を表示する。

**親ウィンドウへの値引き渡し**: jQueryを使用してダイアログ内の情報を顧客名と顧客ID部に設定する。

<details>
<summary>keywords</summary>

ポップアップ画面, ダイアログ形式, 別ウィンドウ不使用, Bootstrap, Ajax, jQuery, DOM構築, 親ウィンドウへの値引き渡し

</details>
