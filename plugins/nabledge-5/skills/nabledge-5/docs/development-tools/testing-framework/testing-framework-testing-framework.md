# テスティングフレームワーク

guide/development_guide/05_UnitTestGuide/index
guide/development_guide/06_TestFWGuide/index
guide/development_guide/08_TestTools/index

テスティングフレームワークを使用して機能のテストを実装するテストの実装者は [単体テスト実施方法](../../development-tools/testing-framework/testing-framework-guide-development-guide-05-UnitTestGuide.md#unittestguide) を、
テスティングフレームワークの導入をするアーキテクトは [自動テストフレームワークの使用方法](../../development-tools/testing-framework/testing-framework-guide-development-guide-06-TestFWGuide.md#testfwguide) を参照してください。

> **Important:**
> テスティングフレームワークは、以下の基盤やライブラリには対応していない。
> このため、これらの基盤やライブラリを使用するアプリケーションに対するテストは、 [JUnit(外部サイト、英語)](https://junit.org/junit5/) などのテスティングフレームワークを使用して行うこと。

> * >   [JSR352に準拠したバッチアプリケーション](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md#jsr352-batch)

> **Important:**
> テスティングフレームワークは、マルチスレッド機能に対応していない。
> マルチスレッド機能のテストは、テスティングフレームワークを使用しないテスト(結合テストなど)で行うこと。
