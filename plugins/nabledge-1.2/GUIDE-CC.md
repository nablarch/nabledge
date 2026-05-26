# Claude Code 利用ガイド

Nabledge-1.2を Claude Code で使用するためのガイドです。

## 前提条件

- Claude Code がインストール済みであること
- プロジェクトディレクトリで作業していること

## インストール

プロジェクトルートで以下のコマンドを実行：

```bash
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-cc.sh | bash -s -- -v 1.2
```

実行後、`.claude/skills/nabledge-1.2/` ディレクトリが作成され、スキルファイルがコピーされます。Claude Codeを起動するだけですぐにスキルが使えます。

### チーム共有

`.claude/skills/` ディレクトリをGitにコミット・プッシュしてください。チームメンバーがリポジトリをクローンすると、自動的にnabledge-1.2スキルが利用可能になります。

## 使い方

### `/n1.2` コマンド

Nablarchに関する質問やコード分析を実行するには、`/n1.2` コマンドを使用します。

**基本的な使い方**:
```bash
/n1.2 ウェブアプリでUniversalDaoを使ったページング検索を実装したい
/n1.2 常駐バッチでのエラーハンドリング方式を調べたい
/n1.2 ウェブアプリでトランザクション管理ハンドラを設定する方法を教えて
/n1.2 code-analysis LoginActionの構造を理解したい
```

> **ヒント**: 処理方式（ウェブ、バッチ、メッセージングなど）と目的（実装方法を知りたい、設定を調べたいなど）を質問に含めると、確認なしでより的確な回答が得られます。

### コマンドリファレンス

| コマンド | 説明 | 入力形式 | 出力場所・内容 |
|---------|------|---------|--------------|
| `/n1.2 <質問>` | 知識検索を実行 | 質問<br>例: `/n1.2 UniversalDaoのページング` | 回答をメインコンテキストに返す |
| `/n1.2 code-analysis <対象>` | コード分析を実行 | コマンド<br>例: `/n1.2 code-analysis LoginAction` | サマリー結果をメインコンテキストに返す<br>詳細: `.nabledge/YYYYMMDD/code-analysis-<target>.md` |

## バージョンアップ

### 最新版へのアップデート（推奨）

セットアップスクリプトを再実行すると、常に最新版がインストールされます：

```bash
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-cc.sh | bash -s -- -v 1.2
```

実行後、更新された `.claude/` ディレクトリをGitにコミット・プッシュしてください。

### 特定バージョンの指定（オプション）

特定のバージョンにしたい場合は、タグを指定できます：

```bash
# バージョン 0.1 にする場合
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-cc.sh -o setup.sh
NABLEDGE_BRANCH=0.1 bash setup.sh -v 1.2
```

実行後、`.claude/skills/` ディレクトリをGitにコミット・プッシュしてください。

**注**: 通常は最新版の使用を推奨します。特定バージョンの指定は、動作検証やトラブルシューティングが必要な場合のみ使用してください。

## コマンドの自動承認について

nabledge-1.2 が実行するコマンドのうち、`scripts/` 配下のスクリプト（`find-file.sh`、`read-file.sh` など）はインストール時に `.claude/settings.json` へ自動承認ルールが設定されるため、確認プロンプトなしで実行されます。

それ以外の汎用シェルコマンド（`find | xargs grep` など）は Claude Code のデフォルト動作で承認が必要になる場合があります。nabledge-1.2 はすべての操作をスクリプト経由で実行するよう設計していますが、汎用コマンドが使われるケースも起こり得ます。その場合は `.claude/settings.json` の `permissions.allow` に同様のパターンを追加することをご検討ください。

## トラブルシューティング

インストール時に問題が発生した場合は、以下を参照してください。

- プロキシ環境・権限不足でインストールが失敗する場合：nablarch/nabledge#10
