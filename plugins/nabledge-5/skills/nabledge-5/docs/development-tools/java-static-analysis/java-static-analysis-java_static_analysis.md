# 効率的なJava静的チェック

**公式ドキュメント**: [効率的なJava静的チェック](https://nablarch.github.io/docs/LATEST/doc/development_tools/java_static_analysis/index.html)

## Inspectionを行う

IntelliJ IDEAの[Inspection機能](https://www.jetbrains.com/help/idea/code-inspection.html)で静的検査を行う。Javaコーディング慣例への準拠や潜在的バグの検出をリアルタイムに警告する。

- デフォルト設定で一般的な注意点について警告する
- プロジェクト規約に合わせて設定変更することで、より有効に活用できる
- 変更した設定はエクスポート/インポートにより開発者間で共有可能

エクスポート/インポートの方法: [プロファイルの構成](https://www.jetbrains.com/help/idea/customizing-profiles.html)

<details>
<summary>keywords</summary>

IntelliJ IDEA, Inspection, 静的検査, コード品質チェック, コーディング規約確認, プロファイル設定共有

</details>

## フォーマットを統一する

IntelliJ IDEAのコードフォーマッター機能でプロジェクトのコードスタイルを統一する。

使用方法: [JavaスタイルガイドのJavaコードフォーマッター解説](https://github.com/Fintan-contents/coding-standards/blob/main/java/code-formatter.md)

<details>
<summary>keywords</summary>

IntelliJ IDEA, コードフォーマッター, コードスタイル統一, Javaスタイルガイド

</details>

## 許可していないAPIが使用されていないかチェックする

許可していないAPIの使用チェックには2種類のツールを提供している。

**nablarch-intellij-plugin**（IntelliJ IDEA用プラグイン）:
- リポジトリ: [nablarch-intellij-plugin](https://github.com/nablarch/nablarch-intellij-plugin)
- Nablarch非公開APIが使用されている場合に警告を出す
- ブラックリストに登録したJava APIが使用されている場合に警告を出す

**使用不許可APIチェックツール**（SpotBugsプラグイン）:
- 仕様・実行方法: [Javaスタイルガイドの使用不許可APIチェックツール解説](https://github.com/Fintan-contents/coding-standards/blob/main/java/staticanalysis/unpublished-api/README.md)
- ブランクプロジェクトには[Mavenで実行するための設定](https://github.com/Fintan-contents/coding-standards/blob/main/java/staticanalysis/spotbugs/docs/Maven-settings.md)があらかじめ設定済みのため、即時チェック可能

<details>
<summary>keywords</summary>

nablarch-intellij-plugin, SpotBugs, 使用不許可APIチェックツール, Nablarch非公開API, ブラックリストAPI, Maven

</details>
