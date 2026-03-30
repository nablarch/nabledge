# 取引単体テストの実施方法（同期応答メッセージ受信処理)

## 同期応答メッセージ受信処理における取引単体テスト

**クラス**: `MessagingRequestTestSupport`

1リクエスト＝1取引の場合、取引単体テストは不要。

複数のメッセージで1取引が成立する場合は、バッチ処理と同様にリクエスト毎のテストを連続実行することで取引単体テストを実施できる。

テストクラス作成ルール（バッチとの差異あり）:
- 継承クラス: `MessagingRequestTestSupport`（バッチとは異なる）
- テストクラスのパッケージ: テスト対象取引のパッケージと同一
- クラス名: `<取引ID>Test`

例（取引IDがM21AA03の場合）:
```java
package nablarch.sample.ss21AA03

import nablarch.test.core.messaging.MessagingRequestTestSupport;

public class M21AA03Test extends MessagingRequestTestSupport {
```

[./batch](testing-framework-batch.md)

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, 取引単体テスト, 同期応答メッセージ受信処理, テストクラス命名規則, 取引ID

</details>
