# 取引単体テストの実施方法

**公式ドキュメント**: [取引単体テストの実施方法](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/index.html)

## テスト準備

取引単体テストは、アプリケーションサーバにデプロイ後、手動操作でテストを行う方式。

同期応答メッセージ送信処理を伴う場合は、モックアップクラスを使用すること（詳細: :ref:`dealUnitTest_send_sync`）。

テスト準備として以下を行う。

1. データベース準備（データ投入）
2. アプリケーションのデプロイ
3. アプリケーションサーバ起動

<details>
<summary>keywords</summary>

取引単体テスト, モックアップクラス, アプリケーションサーバ, 同期応答メッセージ送信処理, 手動テスト

</details>

## テスト実施

テストケースに従ってテストを実施する。

> **補足**: DBダンプはテスト実行前のものが必要であるため、テスト実施前に取得しておくこと。

<details>
<summary>keywords</summary>

DBダンプ, テスト実施タイミング, エビデンス取得, テスト実行前

</details>

## テスト結果エビデンスの収集

収集するエビデンス:
- 画面ハードコピー
- DBダンプ（テスト実行前および実行後）

> **補足**: 画面ハードコピー取得ツール、DBダンプ取得ツール等のテスト補助ツールについては現在検討中。

<details>
<summary>keywords</summary>

画面ハードコピー, DBダンプ, テスト結果エビデンス, テスト証跡, エビデンス収集

</details>
