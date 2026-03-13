# 取引単体テストの実施方法（同期応答メッセージ受信処理)

**公式ドキュメント**: [取引単体テストの実施方法（同期応答メッセージ受信処理)](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/real.html)

## 取引単体テストの実施方法（同期応答メッセージ受信処理）

## 取引単体テストの実施方法（同期応答メッセージ受信処理）

- １リクエスト＝１取引の場合、取引単体テストを実施する必要はない。
- 複数のメッセージにより取引が成立する場合は、リクエスト毎のテストを連続実行することにより取引単体テストが実施可能（バッチと同様）。

テストクラス作成ルール:
- テストクラスが継承するスーパークラスは `MessagingRequestTestSupport` を使用する（バッチと異なる点）。
- パッケージはテスト対象取引のパッケージとする。
- クラス名は `<取引ID>Test` とする。

```java
package nablarch.sample.ss21AA03

import nablarch.test.core.messaging.MessagingRequestTestSupport;

public class M21AA03Test extends MessagingRequestTestSupport {
```

実施方法の詳細: [./batch](testing-framework-batch.md)

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, 同期応答メッセージ受信処理, 取引単体テスト, テストクラス作成ルール, メッセージング取引テスト

</details>
