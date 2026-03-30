# 取引単体テストの実施方法（同期応答メッセージ受信処理)

## 取引単体テストの実施方法（同期応答メッセージ受信処理）

1リクエスト＝1取引の場合は取引単体テストは不要。複数のメッセージにより取引が成立する場合は、バッチ処理と同様にリクエスト毎のテストを連続実行することで取引単体テストを実施できる。

テストクラス作成ルール:
- スーパークラス: `MessagingRequestTestSupport`
- パッケージ: テスト対象取引のパッケージと同一
- クラス名: `<取引ID>Test`（例: 取引IDがM21AA03の場合、`M21AA03Test`）

```java
package nablarch.sample.ss21AA03

import nablarch.test.core.messaging.MessagingRequestTestSupport;

public class M21AA03Test extends MessagingRequestTestSupport {
```

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, 同期応答メッセージ受信処理, 取引単体テスト, メッセージングリクエストテスト, 取引IDTest

</details>
