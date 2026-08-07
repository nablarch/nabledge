# Nablarch専用AIコーディングツール向けプラグイン

本プラグインは、NablarchによるAI支援開発スキルです。Claude CodeやGitHub Copilotといったコーディングエージェントに対して、Nablarchの知識とワークフローを提供します。

コーディングエージェントはNablarchのような企業フレームワークの知識を十分に持っていません。本プラグインを導入することで、エージェントがNablarchのドキュメントやベストプラクティスを参照しながら開発を支援できるようになります。

## プラグイン

| プラグイン | 対応バージョン |
|-----------|-------------|
| [nabledge-6](plugins/nabledge-6/README.md) | Nablarch 6u3 |
| [nabledge-5](plugins/nabledge-5/README.md) | Nablarch 5u26 |
| [nabledge-1.4](plugins/nabledge-1.4/README.md) | Nablarch 1.4.11 |
| [nabledge-1.3](plugins/nabledge-1.3/README.md) | Nablarch 1.3.7 |
| [nabledge-1.2](plugins/nabledge-1.2/README.md) | Nablarch 1.2.8 |

## インストール

プロジェクトルートで以下のコマンドを実行するだけでインストールできます。
`-v` には上記表の `nabledge-` に続く値（`6` `5` `1.4` `1.3` `1.2`）を指定します。

**Claude Code**:
```bash
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-cc.sh | bash -s -- -v 6
```

**GitHub Copilot**:
```bash
curl -sSL https://raw.githubusercontent.com/nablarch/nabledge/main/setup-ghc.sh | bash -s -- -v 6
```

`-v 5,6` のようにカンマ区切りで複数、`-v all` で全バージョンをインストールできます。

詳しい使い方は上記プラグインのリンクから各バージョンの利用ガイドを参照してください。

## 変更履歴

全体およびプラグイン別の変更履歴は [CHANGELOG.md](CHANGELOG.md) を参照してください。

## フィードバック

問題の報告や機能の提案は、[nablarch/nabledge のIssue](https://github.com/nablarch/nabledge/issues) にお願いします。

## ライセンス

Apache-2.0

## リンク

- 配布リポジトリ: https://github.com/nablarch/nabledge
- 開発リポジトリ: https://github.com/nablarch/nabledge-dev
