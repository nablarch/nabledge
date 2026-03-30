# 開発ポータルサイト テンプレート

## 概要・コンテンツ・利用方法

**概要**: 各プロジェクトで設計者・実装者が必要とする情報を集約するために、それらの情報・資料へのリンク集となるページのテンプレートをHTMLとして提供します。

確認方法: `build/html/index.html` をブラウザで開いてご確認ください。

**コンテンツ**:
- `build/html` — 開発ポータルサイトのテンプレートが含まれています
- `source` — 開発ポータルサイトのHTMLを生成したSphinxソースコードが含まれています

**利用手順**:
1. `build/html/index.html` のダミーリンクを正しいリンク先に修正する（配布時はすべてダミー）
2. タイトルとページの説明を修正する
3. `build/html/` 配下を適切なサーバに配置し、`index.html` へのリンクをプロジェクトメンバーに展開する

> **注意**: リンク先とポータルサイトの配置先が同一サーバの場合、ホスト名は含めず相対パスで記載すること。異なる拠点から異なるホスト名でアクセスする場合も同一ファイルを利用できる。

OK（相対パス）:
```html
<a href="/svn/">Subversion</a>
```

NG（絶対URL）:
```html
<a href="http://some.example.co.jp/svn/">Subversion</a>
```

Nablarchコンテンツのパスは、nablarch.zipを解凍したディレクトリからの相対パスで記載されている。

<details>
<summary>keywords</summary>

開発ポータルサイト, テンプレート, 利用方法, 相対パス, ホスト名, build/html, source, Sphinx

</details>

## プロジェクト概要

| コンテンツ | リンク先 |
|---|---|
| プロジェクト概要 | プロジェクトで作成したドキュメント |
| マスタスケジュール | プロジェクトで作成したドキュメント |
| 体制図 | プロジェクトで作成したドキュメント |

<details>
<summary>keywords</summary>

プロジェクト概要, マスタスケジュール, 体制図, 開発ポータルサイト リンク先

</details>

## 設計関連ドキュメント

| コンテンツ | リンク先 | 対応Nablarchコンテンツ |
|---|---|---|
| 要件定義書 | プロジェクトで作成したドキュメント | — |
| 外部設計書 | システム機能設計書などの外部設計書ディレクトリ | nablarch/standard/document_format（フォーマット） |
| データモデル設計 | テーブル定義書などのデータモデル設計書ディレクトリ | nablarch/standard/document_format（フォーマット） |
| UI標準 | UI標準ドキュメント | nablarch/standard/design_standard（サンプル） |
| DB設計標準 | DB設計標準ドキュメント | nablarch/standard/design_standard（サンプル） |
| ID体系 | プロジェクトで作成したドキュメント | — |
| 非機能要件定義書 | プロジェクトで作成したドキュメント | — |
| 方式設計書 | プロジェクトで作成したドキュメント | — |

<details>
<summary>keywords</summary>

設計関連ドキュメント, 要件定義書, 外部設計書, データモデル設計, UI標準, DB設計標準, ID体系, 非機能要件定義書, 方式設計書, document_format, design_standard

</details>

## 実装関連ドキュメント

| コンテンツ | リンク先 | 対応Nablarchコンテンツ |
|---|---|---|
| 開発環境構築ガイド | 開発環境構築手順ドキュメント | nablarch/guide/environment_guide（サンプル） |
| 業務アプリケーション開発手順 | Nablarchのプログラミング・単体テストガイド | nablarch/guide/development_guide/03_DevelopmentStep/index.html |
| 開発プロセス | プロジェクトで作成したドキュメント | — |
| レビュー依頼ルール | プロジェクトで作成したドキュメント（レビュー依頼ルール：開発担当者の実装完了後に、レビュー依頼を行うために必要なチェック事項などを記載してあるドキュメント） | — |
| Redmine | 課題管理システム | — |
| Jenkins | 継続的インテグレーションサーバ | — |
| Subversion | バージョン管理システム | — |
| 責務配置 | 業務コンポーネントの責務配置ドキュメント。変更がなければ nablarch/library/fw/doc/determining_stereotypes.html（「業務コンポーネント責務配置例」）へのリンクとしてください。 | nablarch/library/fw/doc/determining_stereotypes.html |
| 単体テスト標準 | 単体テスト標準ドキュメント | nablarch/standard/unit_test（サンプル） |
| コーディング規約 | Java, SQLなどのコーディング規約ディレクトリ | nablarch/standard/coding_rule（サンプル） |
| 実装FAQ | アプリケーション実装時参照FAQ。本ドキュメント内でフォーマットを提供していますので、適宜コピーして利用してください。 | — |
| プログラミング・単体テストガイド | Nablarchのプログラミング・単体テストガイド | nablarch/guide/development_guide/03_DevelopmentStep/index.html |
| Nablarch Application Framework解説書 | Nablarch AF解説書 | nablarch/library/fw/doc/index.html |
| Nablarch Application Framework Javadoc | Nablarch AF Javadoc | nablarch/library/fw/javadoc_pg/index.html |
| Nablarch Testing Framework Javadoc | Nablarch TF Javadoc | nablarch/library/tfw/javadoc_pg/index.html |
| Nablarch FAQ | Nablarch FAQ | FAQ/index.html |

<details>
<summary>keywords</summary>

実装関連ドキュメント, 開発環境構築ガイド, 業務アプリケーション開発手順, 開発プロセス, レビュー依頼ルール, Redmine, Jenkins, Subversion, プログラミング・単体テストガイド, コーディング規約, 責務配置, Nablarch Application Framework解説書, 単体テスト標準, 実装FAQ, Nablarch FAQ, Javadoc

</details>
