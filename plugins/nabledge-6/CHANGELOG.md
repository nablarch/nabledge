# 変更履歴

nabledge-6プラグインの主な変更内容を記録しています。

フォーマットは [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) に基づいています。

## [Unreleased]

### 追加
- 知識ファイルの閲覧用マークダウンに公式ドキュメントのURLを追加しました。各ページから対応する公式ドキュメントに直接アクセスできるようになりました。

### 修正
- 閲覧用マークダウンのリンク切れを修正しました。ドキュメント間のリンクや画像が正しく表示されるようになりました。

## [0.5] - 2026-03-10

### 追加
- Nablarch 6の全ドキュメントをカバーする知識ファイルを追加しました。より広い範囲の質問に回答できるようになりました。

## [0.4] - 2026-03-04

### 修正
- コード分析結果のソースファイル、知識ベースへのリンクが正しく遷移しない問題を修正しました (nablarch/nabledge#2)
- 開発用ファイル（`.github/workflows/`、`.github/scripts/`）が誤って配布されていた問題を修正しました。次回インストール時に既存の開発用ファイルも自動削除されます (nablarch/nabledge#7)

## [0.3] - 2026-02-24

### 追加
- **`/n6`コマンド**: nabledge-6を別コンテキストで実行できるようになりました。メイン会話のコンテキストを汚染せず、トークン使用量を約80%削減します。Claude CodeとGitHub Copilotの両方で利用可能です
  - 使い方: `/n6 <質問>`（例: `/n6 バッチ処理のエラーハンドリング方法は？`）
  - **重要**: 0.3以降、nabledge-6の機能を使うには `/n6` コマンドでの明示的な呼び出しが必要です
  - 詳細は [GUIDE-CC.md](GUIDE-CC.md) または [GUIDE-GHC.md](GUIDE-GHC.md) を参照してください

### 変更
- **知識検索の出力形式**: より簡潔な回答（500トークン以下を目標）になりました。回答は「結論」「根拠」「注意点」の3セクション構造で提供されます
- **出力先ディレクトリ**: コード分析の出力先を`.nabledge/`に変更しました（従来は`work/YYYYMMDD/`）。Nabledgeが生成したファイルをプロジェクトファイルから明確に分離できます

## [0.2] - 2026-02-17

### 修正
- Claude Codeのセットアップスクリプトがマーケットプレイス設定ではなく `.claude/skills/` ディレクトリへ直接スキルをインストールするように変更し、初回起動時に再起動なしで即座に認識されるようになりました (nablarch/nabledge#1)

## [0.1] - 2026-02-16

### 追加
- 評価版として、Nablarch 6のバッチ処理に関する基礎知識とコード分析ワークフローを提供

[0.5]: https://github.com/nablarch/nabledge/releases/tag/0.5
[0.4]: https://github.com/nablarch/nabledge/releases/tag/0.4
[0.3]: https://github.com/nablarch/nabledge/releases/tag/0.3
[0.2]: https://github.com/nablarch/nabledge/releases/tag/0.2
[0.1]: https://github.com/nablarch/nabledge/releases/tag/0.1
