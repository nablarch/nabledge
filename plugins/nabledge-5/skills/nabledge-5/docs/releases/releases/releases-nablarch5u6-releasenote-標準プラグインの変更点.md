# ■UI開発基盤（標準プラグイン）の変更点

UI開発基盤の変更内容とプラグインの対応を示します。
標準プラグインの取込方法は、下記を参照ください。
Nablarch UI開発基盤 解説書＞開発作業手順＞Nablarch 標準プラグインの更新

|  | 変更実施 バージョン | No | タイトル | 標準プラグイン | プラグイン バージョン | プラグインの変更概要 |
|---|---|---|---|---|---|---|
|  | 5u6 | 1 | 特定端末向けパッチプラグインの注意事項を記載 | nablarch-device-fix-base | 1.0.1 | コメントを追加 |
|  | 5u6 | 2 | Nablarch UI開発基盤 テスト用簡易サーバーの提供形式を変更 | nablarch-dev-tool-server | 1.0.1 | バイナリを削除し、ビルドスクリプトを追加 |
|  | 5u6 | 3 | 「Form自動生成機能」の削除 | nablarch-dev-ui_tool-form_gen-core nablarch-dev-ui_tool-form_gen-resource nablarch-dev-ui_tool-base-core nablarch-dev-ui_tool-spec_view-core nablarch-dev-ui_test-support nablarch-dev-ui_demo-core nablarch-dev-ui_demo-core-lib | - - 1.0.1 1.0.1 1.1.2 1.0.1 1.0.1 | プラグインを削除 プラグインを削除 ソースコードのコメントを修正 当該機能のテストを削除 当該機能のテストページへのリンクを削除 コンテキストメニューからリンクを削除 依存ライブラリのバージョン変更を反映 |
|  | 5u6 | 4 | 「ローカル画面表示からドキュメントへのリンク」機能の削除 | nablarch-dev-ui_demo-core nablarch-dev-ui_demo-config | 1.0.1 1.0.1 | コンテキストメニューからリンクを削除 ドキュメントリンクのリソースを削除 |
