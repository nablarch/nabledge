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

実行後、`.claude/settings.json` が自動的に作成または更新されます。

### チーム共有

`.claude/settings.json` をGitにコミット・プッシュしてください。チームメンバーがリポジトリをクローンしてClaude Codeを起動すると、自動的にプラグインのインストールが促されます。

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

## バージョンアップ

### 最新版へのアップデート（推奨）

セットアップスクリプトを再実行すると、常に最新版がインストールされます：

```bash
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-6-cc.sh | bash
```

実行後、更新された `.claude/settings.json` をGitにコミット・プッシュしてください。

### 特定バージョンの指定（オプション）

特定のバージョンにしたい場合は、タグを指定できます：

```bash
# バージョン 0.2 にする場合
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-6-cc.sh -o setup.sh
NABLEDGE_BRANCH=0.2 bash setup.sh
```

実行後、`.claude/settings.json` をGitにコミット・プッシュしてください。

**注**: 通常は最新版の使用を推奨します。特定バージョンの指定は、動作検証やトラブルシューティングが必要な場合のみ使用してください。
