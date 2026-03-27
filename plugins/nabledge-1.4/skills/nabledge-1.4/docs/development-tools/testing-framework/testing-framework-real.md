# 取引単体テストの実施方法（同期応答メッセージ受信処理)

## 取引単体テストの実施方法（同期応答メッセージ受信処理）

1リクエスト＝1取引の場合、取引単体テストは不要。複数メッセージで取引が成立する場合は、バッチと同様にリクエスト毎のテストを連続実行することで取引単体テストを実施可能。

テストクラス作成ルール: (1) テスト対象取引と同一パッケージ (2) クラス名は`<取引ID>Test` (3) **クラス**: `MessagingRequestTestSupport` を継承 (`import nablarch.test.core.messaging.MessagingRequestTestSupport;`)

実施方法の詳細は [./batch](testing-framework-batch.md) を参照。

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, nablarch.test.core.messaging.MessagingRequestTestSupport, 同期応答メッセージ受信処理, 取引単体テスト, メッセージング, テストクラス作成ルール

</details>
