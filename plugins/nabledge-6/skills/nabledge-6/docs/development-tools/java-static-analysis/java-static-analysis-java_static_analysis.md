# 効率的なJava静的チェック

**公式ドキュメント**: [効率的なJava静的チェック](https://nablarch.github.io/docs/LATEST/doc/development_tools/java_static_analysis/index.html)

## Inspectionを行う

NablarchではJetBrains社製のIDEであるIntelliJ IDEAの使用を推奨しており、IntelliJ IDEAを用いた効率的なJava静的チェックを実践する。

IntelliJ IDEAの[Inspection機能](https://www.jetbrains.com/help/idea/code-inspection.html)は、Javaコーディングの慣例遵守や潜在的バグをリアルタイムに警告する静的検査機能。デフォルトは一般的に注意すべき点について警告する設定。

プロジェクト規約がある場合は設定を変更することでより有効に活用できる。変更した設定はエクスポート・インポートでプロジェクト開発者間で共有可能。設定共有方法: [プロファイルの構成](https://www.jetbrains.com/help/idea/customizing-profiles.html)

<details>
<summary>keywords</summary>

IntelliJ IDEA, Inspection機能, 静的検査, コーディング規約チェック, 潜在的バグ検出, プロファイル設定共有, IntelliJ IDEA推奨

</details>

## フォーマットを統一する

IntelliJ IDEAのコードフォーマッター機能でプロジェクトのコードスタイルを統一できる。使用方法: [JavaスタイルガイドのJavaコードフォーマッター解説](https://github.com/Fintan-contents/coding-standards/blob/main/java/code-formatter.md)

<details>
<summary>keywords</summary>

IntelliJ IDEA, コードフォーマッター, コードスタイル統一, Javaコードフォーマット

</details>

## 許可していないAPIが使用されていないかチェックする

許可していないAPI使用チェックに2種類のツールを提供。1つはIntelliJ IDEAのプラグイン、もう1つはIntelliJ IDEAに依存しないSpotBugsプラグインであり、IntelliJ IDEAを使用しない環境でもSpotBugsベースのツールを利用できる。

### nablarch-intellij-pluginを使用する

[nablarch-intellij-plugin](https://github.com/nablarch/nablarch-intellij-plugin): Nablarch開発支援のIntelliJ IDEA用プラグイン。機能:
- Nablarch非公開APIの使用時に警告
- ブラックリストに登録したJava APIの使用時に警告

### 使用不許可APIチェックツールを使用する

SpotBugsのプラグインとして作成されたツール（IntelliJ IDEAに依存しない）。詳細: [Javaスタイルガイドの使用不許可APIチェックツール解説](https://github.com/Fintan-contents/coding-standards/blob/main/java/staticanalysis/unpublished-api/README.md)

ブランクプロジェクトには[Mavenで実行するための設定](https://github.com/Fintan-contents/coding-standards/blob/main/java/staticanalysis/spotbugs/docs/Maven-settings.md)があらかじめ設定されており、すぐにチェック実施可能。

<details>
<summary>keywords</summary>

nablarch-intellij-plugin, 使用不許可APIチェックツール, SpotBugs, Nablarch非公開API, ブラックリストAPI, 使用不許可APIチェック, IntelliJ IDEA非依存, SpotBugsプラグイン

</details>
