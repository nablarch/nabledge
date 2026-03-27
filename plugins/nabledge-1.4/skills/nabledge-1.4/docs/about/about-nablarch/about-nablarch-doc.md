# 開発ポータルサイト テンプレート

## テンプレートの概要・コンテンツ・利用方法とプロジェクト概要コンテンツ一覧

開発ポータルサイト テンプレートは、設計者・実装者が必要とする情報・資料へのリンク集ページ（HTML）を提供する。

## ディレクトリ構成

- `build/html` — 開発ポータルサイトのテンプレート（HTMLファイル）が含まれている。
- `source` — 開発ポータルサイトのHTMLを生成した Sphinx ソースコードが含まれている（HTML生成方法の確認や構造変更が必要な場合に参照）。

## 利用手順

1. `build/html/index.html` に記載されているリンク先を正しいリンク先に修正する（配布時はすべてダミー。各リンク先の詳細はコンテンツ一覧を参照）。
2. 同ファイルのタイトルやページの説明を修正する。
3. `build/html/` 配下のディレクトリ・ファイルを適切なサーバに配置し、`index.html` へのリンクをプロジェクトメンバーに展開する（ファイルサーバでも可）。

> **注意**: リンク先とポータルサイトの配置先が同一サーバの場合、URLにホスト名を含めず相対パスで記載すること。異なる拠点から異なるホスト名でアクセスする場合にも同一ファイルを使用可能になる。
> - OK: `<a href="/svn/">Subversion</a>`
> - NG: `<a href="http://some.example.co.jp/svn/">Subversion</a>`

## プロジェクト概要コンテンツ一覧

| コンテンツ | リンク先 |
|---|---|
| プロジェクト概要 | プロジェクトで作成したドキュメントへのリンク |
| マスタスケジュール | プロジェクトで作成したドキュメントへのリンク |
| 体制図 | プロジェクトで作成したドキュメントへのリンク |

<details>
<summary>keywords</summary>

開発ポータルサイトテンプレート, リンク集, build/html, source, Sphinx, 利用方法, プロジェクト概要, マスタスケジュール, 体制図, 相対パス, ホスト名なしリンク

</details>

## 設計関連ドキュメント

設計関連ドキュメントとして想定されるコンテンツおよび対応するNablarchコンテンツ（パスはnablarch.zip解凍ディレクトリからの相対パス）。

| コンテンツ | リンク先・対応Nablarchコンテンツ |
|---|---|
| 要件定義書 | プロジェクトで作成したドキュメントへのリンク |
| 外部設計書 | システム機能設計書等を格納したディレクトリへのリンク。Nablarchフォーマット: `nablarch/standard/document_format` |
| データモデル設計 | テーブル定義書等を格納したディレクトリへのリンク。Nablarchフォーマット: `nablarch/standard/document_format` |
| UI標準 | UI標準へのリンク。Nablarchサンプル: `nablarch/standard/design_standard` |
| DB設計標準 | DB設計標準へのリンク。Nablarchサンプル: `nablarch/standard/design_standard` |
| ID体系 | プロジェクトで作成したドキュメントへのリンク |
| 非機能要件定義書 | プロジェクトで作成したドキュメントへのリンク |
| 方式設計書 | プロジェクトで作成したドキュメントへのリンク |

<details>
<summary>keywords</summary>

設計ドキュメント, 外部設計書, データモデル設計, UI標準, DB設計標準, 非機能要件定義書, 方式設計書, document_format, design_standard

</details>

## 実装関連ドキュメント

実装関連ドキュメントとして想定されるコンテンツおよび対応するNablarchコンテンツ（パスはnablarch.zip解凍ディレクトリからの相対パス）。

| コンテンツ | リンク先・対応Nablarchコンテンツ |
|---|---|
| 開発環境構築ガイド | 開発環境構築手順ドキュメントへのリンク。Nablarchサンプル: `nablarch/guide/environment_guide` |
| 業務アプリケーション開発手順 | Nablarchコンテンツ: `nablarch/guide/development_guide/03_DevelopmentStep/index.html` |
| 開発プロセス | プロジェクトで作成したドキュメントへのリンク |
| レビュー依頼ルール | プロジェクトで作成したドキュメントへのリンク（実装完了後にレビュー依頼を行うために必要なチェック事項等を記載したドキュメント） |
| Redmine | 課題管理システムへのリンク |
| Jenkins | 継続的インテグレーションサーバへのリンク |
| Subversion | バージョン管理システムへのリンク |
| 責務配置 | 業務コンポーネント責務配置ドキュメントへのリンク。Nablarch解説書「業務コンポーネント責務配置例」に標準的な例あり。**プロジェクトで変更がなければ** Nablarchコンテンツ `nablarch/library/fw/doc/determining_stereotypes.html` へのリンクとする（プロジェクト固有の変更がある場合はプロジェクト作成ドキュメントへのリンク）。 |
| 単体テスト標準 | 単体テスト標準へのリンク。Nablarchサンプル: `nablarch/standard/unit_test` |
| コーディング規約 | Java/SQLコーディング規約格納ディレクトリへのリンク。Nablarchサンプル: `nablarch/standard/coding_rule` |
| 実装FAQ | アプリケーション実装時に参照するFAQへのリンク（本ドキュメント内でフォーマットを提供） |
| プログラミング・単体テストガイド | Nablarchコンテンツ: `nablarch/guide/development_guide/03_DevelopmentStep/index.html` |
| Nablarch Application Framework解説書 | Nablarchコンテンツ: `nablarch/library/fw/doc/index.html` |
| Nablarch Application Framework Javadoc | Nablarchコンテンツ: `nablarch/library/fw/javadoc_pg/index.html` |
| Nablarch Testing Framework Javadoc | Nablarchコンテンツ: `nablarch/library/tfw/javadoc_pg/index.html` |
| Nablarch FAQ | Nablarchコンテンツ: `FAQ/index.html` |

<details>
<summary>keywords</summary>

開発環境構築ガイド, 業務アプリケーション開発手順, 開発プロセス, レビュー依頼ルール, Redmine, Jenkins, Subversion, コーディング規約, 責務配置, 単体テスト標準, 実装FAQ, プログラミング・単体テストガイド, Nablarch Application Framework解説書, Nablarch Application Framework Javadoc, Nablarch Testing Framework Javadoc, Nablarch FAQ, environment_guide, development_guide, coding_rule

</details>
