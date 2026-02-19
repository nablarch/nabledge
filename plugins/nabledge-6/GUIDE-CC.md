# Claude Code 利用ガイド

Nabledge-6を Claude Code で使用するためのガイドです。

## 前提条件

- Claude Code がインストール済みであること
- プロジェクトディレクトリで作業していること

## インストール

プロジェクトルートで以下のコマンドを実行：

```bash
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-6-cc.sh | bash
```

実行後、`.claude/skills/nabledge-6/` ディレクトリが作成され、スキルファイルがコピーされます。Claude Codeを起動するだけですぐにスキルが使えます。

### チーム共有

`.claude/skills/` ディレクトリをGitにコミット・プッシュしてください。チームメンバーがリポジトリをクローンすると、自動的にnabledge-6スキルが利用可能になります。

## 使い方

### 基本的な使い方

自然言語でNablarchに関する質問や依頼をするだけで、Claude Codeが自動的にnabledge-6スキルを使用します。

**例**:
```
Nablarchのバッチ処理の実装方法を教えて
```

```
このプロジェクトのコードをNablarchの観点から分析して
```

```
UniversalDaoの使い方を教えて
```

### 手動実行（オプション）

明示的にスキルを指定したい場合は、以下のコマンドで手動実行できます：

```bash
/nabledge-6
```

対話的にNablarchに関する質問や、コード分析を行うことができます。

コード分析を直接実行する場合:

```bash
/nabledge-6 code-analysis
```

### コマンドリファレンス

| コマンド | 説明 | 入力形式 | 出力場所・内容 |
|---------|------|---------|--------------|
| `/nabledge-6` | 対話モードで起動。知識検索またはコード分析を選択可能 | なし | なし（対話形式で結果を表示） |
| `/nabledge-6 code-analysis` | 既存コードの構造を分析し、ドキュメントを生成 | ターゲットコード指定（対話で入力）<br>例: "LoginAction", "proman-batchモジュール" | `.nabledge/YYYYMMDD/code-analysis-<target>.md`<br>依存関係図、コンポーネント一覧、Nablarch利用状況を含む構造化ドキュメント<br>[テンプレート](../assets/code-analysis-template.md) \| [ガイド](../assets/code-analysis-template-guide.md) \| [例](../assets/code-analysis-template-examples.md) |

## バージョンアップ

### 最新版へのアップデート（推奨）

セットアップスクリプトを再実行すると、常に最新版がインストールされます：

```bash
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-6-cc.sh | bash
```

実行後、更新された `.claude/skills/` ディレクトリをGitにコミット・プッシュしてください。

### 特定バージョンの指定（オプション）

特定のバージョンにしたい場合は、タグを指定できます：

```bash
# バージョン 0.2 にする場合
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-6-cc.sh -o setup.sh
NABLEDGE_BRANCH=0.2 bash setup.sh
```

実行後、`.claude/skills/` ディレクトリをGitにコミット・プッシュしてください。

**注**: 通常は最新版の使用を推奨します。特定バージョンの指定は、動作検証やトラブルシューティングが必要な場合のみ使用してください。
