# テスティングフレームワーク

* [単体テスト実施方法](../../development-tools/testing-framework/testing-framework-guide-development-guide-05-UnitTestGuide.md)
* [自動テストフレームワークの使用方法](../../development-tools/testing-framework/testing-framework-guide-development-guide-06-TestFWGuide.md)
* [プログラミング工程で使用するツール](../../development-tools/testing-framework/testing-framework-guide-development-guide-08-TestTools.md)

テスティングフレームワークを使用して機能のテストを実装するテストの実装者は [単体テスト実施方法](../../development-tools/testing-framework/testing-framework-guide-development-guide-05-UnitTestGuide.md#単体テスト実施方法) を、
テスティングフレームワークの導入をするアーキテクトは [自動テストフレームワークの使用方法](../../development-tools/testing-framework/testing-framework-guide-development-guide-06-TestFWGuide.md#自動テストフレームワークの使用方法) を参照してください。

> **Important:**
> テスティングフレームワークは、以下の基盤やライブラリには対応していない。
> このため、これらの基盤やライブラリを使用するアプリケーションに対するテストは、 [JUnit(外部サイト、英語)](https://junit.org/junit5/) などのテスティングフレームワークを使用して行うこと。

> * >   [Jakarta Batchに準拠したバッチアプリケーション](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md#jakarta-batchに準拠したバッチアプリケーション)

> **Important:**
> テスティングフレームワークは、マルチスレッド機能に対応していない。
> マルチスレッド機能のテストは、テスティングフレームワークを使用しないテスト(結合テストなど)で行うこと。
