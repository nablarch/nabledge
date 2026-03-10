# 二重サブミット防止機能のテスト実施方法

**公式ドキュメント**: [二重サブミット防止機能のテスト実施方法](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/double_transmission.html)

## リクエスト単体テストでの二重サブミット防止機能のテスト実施方法

リクエスト単体テストでは、サーバサイドの二重サブミット防止機能を検証する。テストショットのLIST_MAPに`isValidToken`カラムを指定し、`false`に設定してエラーが発生することで機能の動作を確認する。

テストデータの記述方法詳細は :ref:`request_test_testcases` を参照。

<details>
<summary>keywords</summary>

二重サブミット防止, リクエスト単体テスト, サーバサイドテスト, isValidToken, LIST_MAP

</details>

## 取引単体テストでの二重サブミット防止機能のテスト実施方法

取引単体テストでは、クライアントサイドの二重サブミット防止機能を検証する。デバッグモードでアプリケーション起動後、対象アクションの処理にブレークポイントを設定し、ボタン選択でブレークポイント停止中に再度ボタンを選択してリクエストが送信されないことを確認する。

<details>
<summary>keywords</summary>

二重サブミット防止, 取引単体テスト, クライアントサイドテスト, デバッグモード, ブレークポイント

</details>
