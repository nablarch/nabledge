# ポップアップ画面の作成

**公式ドキュメント**: [ポップアップ画面の作成](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/popup/index.html)

## ポップアップ(ダイアログ)画面を表示する

ポップアップ画面は別ウィンドウではなくダイアログ形式で作成する（:ref:`tag-submit_popup` 参照）。

ダイアログ表示はBootstrap (OSS)を使用して実現する。

**業務アクションメソッドの作成**: ダイアログからのAjax呼び出しにより検索処理を実現する。アクションクラスの実装は :ref:`restful_web_service` を参照。

**ポップアップ画面のJSP**: jQueryを使用してAjax呼び出し結果をもとにDOMを構築し結果を表示する。

**親ウィンドウへの値引き渡し**: jQueryを使用してダイアログ内の情報を顧客名・顧客ID部に設定する。

<details>
<summary>keywords</summary>

ポップアップ画面, ダイアログ表示, 別ウィンドウ禁止, Bootstrap, Ajax検索, jQuery, 親ウィンドウへの値引き渡し

</details>
