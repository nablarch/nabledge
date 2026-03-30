# Java静的解析ツール

**公式ドキュメント**: [1](http://findbugs.sourceforge.net/) [2](http://checkstyle.sourceforge.net/)

## Java静的解析ツール

NablarchはJava静的解析ツールとしてFindBugsとCheckstyleをデフォルト環境に設定して提供する。

| ツール名 | 公式サイト |
|---|---|
| FindBugs | [http://findbugs.sourceforge.net/](http://findbugs.sourceforge.net/) |
| Checkstyle | [http://checkstyle.sourceforge.net/](http://checkstyle.sourceforge.net/) |

> **警告**: デフォルトの環境に設定したJava静的解析ツールでは目的をすべて保証することはできない。アプリケーションプログラマに「Nablarch アプリケーション開発標準」に沿ったコーディングを要求し、ソースコードレビューでも「Nablarch アプリケーション開発標準」への準拠を観点に含めること。

> **注意**: デフォルトの環境とは異なる環境を構築する場合、「Nablarch アプリケーション開発標準 => コーディング規約チェックツール設定ファイル」にあるFindBugsとCheckstyleの設定ファイルを使用すること。これによりデフォルトの環境と同一のチェックが行える。

Nablarchが定める使用許可API以外のAPI使用を検知するため、NablarchはFindbugsのカスタムルールを提供する。仕様および使用方法は [./UnpublishedApi](java-static-analysis-UnpublishedApi.md) を参照。

<details>
<summary>keywords</summary>

FindBugs, Checkstyle, Java静的解析, コーディング規約チェック, カスタムルール, 未公開API検知, UnpublishedApi

</details>
