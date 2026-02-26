# 変更履歴

nabledge-6プラグインの主な変更内容を記録しています。

フォーマットは [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) に基づいています。

## [Unreleased]

### 変更
- 知識検索時のファイル選択精度を向上させました。より関連性の高いドキュメントセクションを選択できるようになりました (Issue #88)

### 修正
- コード分析出力の知識ベースリンクが正しく動作するようになりました。セットアップスクリプトでインストールした場合に、`.nabledge/YYYYMMDD/`から`.claude/skills/nabledge-6/docs/`へのリンクが正しく解決されます（相対パス計算のバグを修正） (Issue #91)

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
- Claude Codeのセットアップスクリプトがマーケットプレイス設定ではなく `.claude/skills/` ディレクトリへ直接スキルをインストールするように変更し、初回起動時に再起動なしで即座に認識されるようになりました (Issue #27)

## [0.1] - 2026-02-16

### 追加
- 評価版として、Nablarch 6のバッチ処理に関する基礎知識とコード分析ワークフローを提供

[0.3]: https://github.com/nablarch/nabledge/releases/tag/0.3
[0.2]: https://github.com/nablarch/nabledge/releases/tag/0.2
[0.1]: https://github.com/nablarch/nabledge/releases/tag/0.1
