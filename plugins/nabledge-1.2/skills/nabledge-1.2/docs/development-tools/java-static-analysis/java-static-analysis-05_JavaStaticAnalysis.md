# Java静的解析ツール

## Java静的解析ツール

Nablarchでは以下の目的でJava静的解析ツールをデフォルト環境に設定して提供する：
- Nablarchが定めるJavaコーディング規約への準拠をアプリケーションプログラマに要求する
- 業務アプリケーション作成過程に埋め込まれた潜在的な不具合を検出する

> **警告**: デフォルトの環境に設定したJava静的解析ツールでは上記の目的をすべて保証することはできない。
> - アプリケーションプログラマに、「Nablarch アプリケーション開発標準」に沿ったコーディングを行うことを求める。
> - ソースコードレビュアーに、「Nablarch アプリケーション開発標準」に沿ったコーディングが行われていることを観点に入れレビューすることを求める。

デフォルトの環境に設定されているツール：

| ツール名 | 公式サイト |
|---|---|
| FindBugs | [http://findbugs.sourceforge.net/](http://findbugs.sourceforge.net/) |
| Checkstyle | [http://checkstyle.sourceforge.net/](http://checkstyle.sourceforge.net/) |

> **注意**: デフォルトの環境とは異なる環境を構築する場合、「Nablarch アプリケーション開発標準 => コーディング規約チェックツール設定ファイル」にあるFindBugsとCheckstyleの設定ファイルを使用すること。これらの設定ファイルによりデフォルトの環境と同一のチェックを行える。

Nablarchが定める使用許可API以外のAPI使用を検知するため、NablarchはFindBugsのカスタムルールを提供する。仕様および使用方法は [./UnpublishedApi](java-static-analysis-UnpublishedApi.md) を参照。

<details>
<summary>keywords</summary>

FindBugs, Checkstyle, Java静的解析, コーディング規約チェック, 潜在的な不具合検出, 未公開APIチェック, FindBugsカスタムルール, UnpublishedApi

</details>
