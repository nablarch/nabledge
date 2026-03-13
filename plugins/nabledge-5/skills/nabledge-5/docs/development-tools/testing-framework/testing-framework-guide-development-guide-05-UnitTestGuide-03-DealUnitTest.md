# 取引単体テストの実施方法

**公式ドキュメント**: [取引単体テストの実施方法](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/index.html)

## テスト準備

取引単体テストでは、アプリケーションをアプリケーションサーバにデプロイし、手動操作でテストを行う。

同期応答メッセージ送信処理を伴う場合は、モックアップクラスを使用する（詳細は :ref:`dealUnitTest_send_sync` を参照）。

テスト準備として以下を実施する：
1. データベース準備（データ投入）
2. アプリケーションのデプロイ
3. アプリケーションサーバ起動

<details>
<summary>keywords</summary>

取引単体テスト, モックアップクラス, 同期応答メッセージ送信, データベース準備, アプリケーションデプロイ, アプリケーションサーバ起動

</details>

## テスト実施

テストケースに従ってテストを実施する。

> **補足**: DBダンプはテスト実行前のものが必要なため、テスト実施前に取得しておくこと。

<details>
<summary>keywords</summary>

テスト実施, DBダンプ取得タイミング, エビデンス, テスト実行前

</details>

## テスト結果エビデンスの収集

以下のエビデンスを取得する：
- 画面ハードコピー
- DBダンプ（テスト実行前および実行後）

> **補足**: 画面ハードコピー取得ツール、DBダンプ取得ツール等のテスト補助ツールについては現在検討中。

<details>
<summary>keywords</summary>

エビデンス収集, 画面ハードコピー, DBダンプ, テスト証跡, テスト実行前後, テスト補助ツール, 検討中

</details>
