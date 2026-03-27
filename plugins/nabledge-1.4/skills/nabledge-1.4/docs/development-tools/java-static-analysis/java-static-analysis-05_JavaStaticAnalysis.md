# Java静的解析ツール

**公式ドキュメント**: [1](http://findbugs.sourceforge.net/) [2](http://checkstyle.sourceforge.net/)

## Java静的解析ツール

Nablarchが提供するJava静的解析ツール。Nablarchコーディング規約の遵守と潜在的バグの検出を目的とする。

> **警告**: デフォルト環境のツールだけでは目的を完全に保証できない。アプリケーションプログラマは「Nablarch アプリケーション開発標準」に沿ったコーディングを行うこと。ソースコードレビュアーも同標準への準拠を観点としてレビューすること。

デフォルト環境に設定されているツール:

| ツール名 | 公式サイト |
|---|---|
| FindBugs | [http://findbugs.sourceforge.net/](http://findbugs.sourceforge.net/) |
| Checkstyle | [http://checkstyle.sourceforge.net/](http://checkstyle.sourceforge.net/) |

> **注意**: デフォルト以外の環境を構築する場合は、「Nablarch アプリケーション開発標準 => コーディング規約チェックツール設定ファイル」にあるFindBugsとCheckstyleの設定ファイルを使用すること。これにより、デフォルト環境と同一のチェックが行える。

Nablarchが定める使用許可API以外のAPI使用を検知するため、NablarchはFindbugsのカスタムルールを提供する。仕様および使用方法は [./UnpublishedApi](java-static-analysis-UnpublishedApi.md) を参照。

<details>
<summary>keywords</summary>

FindBugs, Checkstyle, Java静的解析, コーディング規約チェック, 未公開API使用検知, FindBugsカスタムルール, UnpublishedApi

</details>
