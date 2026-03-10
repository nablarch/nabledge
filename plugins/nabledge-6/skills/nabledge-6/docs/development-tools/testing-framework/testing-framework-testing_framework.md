# テスティングフレームワーク

**公式ドキュメント**: [テスティングフレームワーク](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/index.html)

## テスティングフレームワーク概要と制限事項

> **重要**: テスティングフレームワークは、以下の基盤やライブラリには対応していない。これらを使用するアプリケーションのテストは、[JUnit(外部サイト、英語)](https://junit.org/junit5/) などのテスティングフレームワークを使用して行うこと。
> - :ref:`Jakarta Batchに準拠したバッチアプリケーション <jsr352_batch>`

> **重要**: テスティングフレームワークは、マルチスレッド機能に対応していない。マルチスレッド機能のテストは、テスティングフレームワークを使用しないテスト（結合テストなど）で行うこと。

<details>
<summary>keywords</summary>

テスティングフレームワーク非対応機能, Jakarta Batch非対応, マルチスレッド非対応, JUnit, jsr352_batch, テスト実装制限

</details>
