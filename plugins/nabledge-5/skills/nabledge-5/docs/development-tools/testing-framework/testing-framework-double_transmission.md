# 二重サブミット防止機能のテスト実施方法

**公式ドキュメント**: [二重サブミット防止機能のテスト実施方法](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/double_transmission.html)

## リクエスト単体テストでの二重サブミット防止機能のテスト実施方法

リクエスト単体テストではサーバサイドでテストを実施する。テストショットのLIST_MAPに`isValidToken`カラムを指定し、`false`に設定した際にエラーが発生すれば二重サブミット防止機能が動作していることを確認できる。

<details>
<summary>keywords</summary>

二重サブミット防止, リクエスト単体テスト, isValidToken, LIST_MAP, サーバサイドテスト

</details>

## 取引単体テストでの二重サブミット防止機能のテスト実施方法

取引単体テストではクライアントサイドでテストを実施する。

テスト手順:
1. デバッグモードでアプリケーションを起動する
2. テスト対象リクエストのアクション処理にブレークポイントを設定する
3. 打鍵でテスト対象リクエストのボタンを選択する
4. ブレークポイントで処理を停止した状態で、再度テスト対象リクエストのボタンを選択し、リクエストが送信されないことを確認する

<details>
<summary>keywords</summary>

二重サブミット防止, 取引単体テスト, クライアントサイドテスト, デバッグモード, ブレークポイント

</details>
