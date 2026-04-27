# ■UI開発基盤（標準プラグイン）の変更点

UI開発基盤の変更内容とプラグインの対応を示します。
標準プラグインの取込方法は、下記を参照ください。
Nablarch UI開発基盤 解説書＞開発作業手順＞Nablarch 標準プラグインの更新

|  | 変更実施 バージョン | No | タイトル | 標準プラグイン | プラグイン バージョン | プラグインの変更概要 |
|---|---|---|---|---|---|---|
|  | 5u10 | 1 | ポップアップ機能と併用した場合の不具合に対応 | nablarch-widget-field-listbuilder | 1.0.2 | 不具合修正 |
|  | 5u10 | 2 | 画像表示ウィジェットをコンパクトモードで表示した際に画像が消えてしまう不具合に対応 | nablarch-ui-development-template | 1.1.0 | 不具合修正 |
|  | 5u10 | 3 | UIビルドコマンドの実行時に生成されるリソースに不要な文字列が出力されることがある不具合を修正 | nablarch-dev-tool-ui-build | 1.0.2 | 不具合修正 |
|  | 5u10 | 4 | 生成するCSSをminifyするように修正 | nablarch-dev-tool-uibuild | 1.1.0 | CSSのサイズをminifyするよう変更 |
|  | 5u10 | 5 | プロダクション環境にリリースされるJSPの配置場所をWEB-INF配下に変更 | nablarch-dev-tool-uibuild nablarch-dev-ui_demo-core-lib nablarch-dev-ui_test-support nablarch-template-app_aside nablarch-template-app_footer nablarch-template-app_header nablarch-template-app_nav nablarch-template-base nablarch-template-head nablarch-template-js_include nablarch-template-multicol-head nablarch-template-page nablarch-widget-event-listen nablarch-widget-slide-menu nablarch-ui-development-template | 1.1.0 1.1.0 1.2.0 1.1.0 1.1.0 1.1.0 1.1.0 1.1.0 1.1.0 1.1.0 1.1.0 1.1.0 1.1.0 1.1.0 1.1.0 | JSPの配置場所の変更 |
|  | 5u10 | 6 | resultSetName属性を指定せずにresultNumName属性を指定できない不具合に対応 | nablarch-widget-table-plain | 1.0.2 | 不具合修正 |
|  | 5u10 | 7 | 画面モック起動時にthead, tbody, tfootタグがHTMLに表示されない不具合に対応 | nablarch-dev-ui_demo-core-lib nablarch-dev-ui_demo-core | 1.1.1 1.0.2 | 不具合修正 |
|  | 5u10 | 8 | 動作確認用アプリケーションのハンドラ構成を最新化 | nablarch-dev-tool-server | 1.0.2 | ハンドラ構成の最新化 |
