# テスティングフレームワーク

**公式ドキュメント**: [テスティングフレームワーク](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/index.html)

## テスティングフレームワーク概要・制限事項

> **重要**: テスティングフレームワークは、以下の基盤やライブラリには対応していない。これらを使用するアプリケーションのテストは、[JUnit(外部サイト、英語)](https://junit.org/junit5/) などのテスティングフレームワークを使用して行うこと。
> - [jsr352_batch](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md)

> **重要**: テスティングフレームワークは、マルチスレッド機能に対応していない。マルチスレッド機能のテストは、テスティングフレームワークを使用しないテスト（結合テストなど）で行うこと。

<details>
<summary>keywords</summary>

テスティングフレームワーク, 制限事項, JSR352, マルチスレッド非対応, バッチアプリケーション, JUnit

</details>
