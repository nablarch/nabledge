# GitHub Copilot 利用ガイド

Nabledge-6を GitHub Copilot で使用するためのガイドです。

## 前提条件

- **WSL または GitBash 環境**
  - VS Code のターミナルを使用する場合は、ターミナルを WSL または GitBash に設定してください
  - PowerShell や Command Prompt では動作しません（セットアップスクリプトが `jq` コマンドを使用するため）
- プロジェクトディレクトリで作業していること
- VS Code の GitHub Copilot 拡張機能がインストール済みであること

## インストール

### 1. スキルをプロジェクトに追加

プロジェクトルートで以下のコマンドを実行：

```bash
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-6-ghc.sh | bash
```

実行後、以下のファイルが自動的に作成されます：
- `.claude/skills/nabledge-6/` - スキル定義（GitHub Copilot が自動認識）
- `.vscode/settings.json` - VS Code 設定（GitHub Copilot スキル機能を有効化）

### 2. チーム共有

`.claude` ディレクトリと `.vscode/settings.json` をGitにコミット・プッシュしてください。チームメンバーがリポジトリをクローンすると、自動的に以下が有効になります：
- nabledge-6 スキルの利用
- GitHub Copilot スキル機能の有効化

**注**: チームメンバーは VS Code を再起動する必要があります。

## 使い方

### `/n6` プロンプト

Nablarchに関する質問やコード分析を実行するには、`/n6` プロンプトを使用します。

**基本的な使い方**:
```bash
/n6 UniversalDaoのページングを教えて
/n6 バッチ処理のエラーハンドリング方式を調べて
/n6 トランザクション管理ハンドラの設定方法
/n6 code-analysis LoginActionの構造を理解したい
```

### コマンドリファレンス

| コマンド | 説明 | 入力形式 | 出力場所・内容 |
|---------|------|---------|--------------|
| `/n6 <質問>` | 知識検索を実行 | 質問<br>例: `/n6 UniversalDaoのページング` | サマリー結果のみメインコンテキストに返る |
| `/n6 code-analysis <対象>` | コード分析を実行 | コマンド<br>例: `/n6 code-analysis LoginAction` | サマリー結果のみメインコンテキストに返る<br>詳細: `.nabledge/YYYYMMDD/code-analysis-<target>.md` |

## バージョンアップ

### 最新版へのアップデート（推奨）

セットアップスクリプトを再実行すると、常に最新版がインストールされます：

```bash
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-6-ghc.sh | bash
```

更新後、`.claude/` と `.github/` ディレクトリの変更をGitにコミット・プッシュしてください。

### 特定バージョンの指定（オプション）

特定のバージョンにしたい場合は、タグを指定できます：

```bash
# バージョン 0.2 にする場合
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-6-ghc.sh -o setup.sh
NABLEDGE_BRANCH=0.2 bash setup.sh
```

更新後、`.claude/` と `.github/` ディレクトリの変更をGitにコミット・プッシュしてください。

**注**: 通常は最新版の使用を推奨します。特定バージョンの指定は、動作検証やトラブルシューティングが必要な場合のみ使用してください。
