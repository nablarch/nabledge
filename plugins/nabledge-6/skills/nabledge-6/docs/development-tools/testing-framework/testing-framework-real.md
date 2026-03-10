# 取引単体テストの実施方法（同期応答メッセージ受信処理)

**公式ドキュメント**: [取引単体テストの実施方法（同期応答メッセージ受信処理)](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/real.html)

## 取引単体テストの実施方法（同期応答メッセージ受信処理)

1リクエスト＝1取引の場合、取引単体テストは不要。複数メッセージで取引が成立する場合は、リクエスト毎のテストを連続実行することで取引単体テストを実施できる。

テストクラス作成ルール（バッチと基本的に同様だが、スーパークラスが異なる）:
- スーパークラスは `MessagingRequestTestSupport` を使用する
- テストクラスのパッケージはテスト対象取引のパッケージとする
- クラス名は `<取引ID>Test` とする

```java
package nablarch.sample.ss21AA03

import nablarch.test.core.messaging.MessagingRequestTestSupport;

public class M21AA03Test extends MessagingRequestTestSupport {
```

[./batch](testing-framework-batch.md)

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, nablarch.test.core.messaging.MessagingRequestTestSupport, 同期応答メッセージ受信処理, 取引単体テスト, テストクラス命名規則, メッセージング取引単体テスト

</details>
