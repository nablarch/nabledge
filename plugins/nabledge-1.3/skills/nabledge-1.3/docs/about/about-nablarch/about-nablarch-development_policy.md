# Nablarchの目指す姿

## lean and rapid

## lean and rapid

Nablarchが目指す「lean and rapid」の設計目標:

- Nablarch固有の知識についての初期習得コストが低い
- アプリケーション開発者が機能を単純に実装でき、本質的な作業に専念できる
  - 開発環境・実行環境の構築が簡単
  - Java、SQL、HTMLといった基本技術のみを知っていれば実装できる
  - 必要十分な抽象化が行われている
  - 必要十分なユーティリティ・サンプル・テンプレート・ツール類があり、すぐに目的のものを探し出して利用できる
  - 汎用的に必要となる業務アプリケーションやビジネスロジックが再利用可能なコンポーネントとして用意されており、プロジェクトで必要な設定を行うだけで利用できる
  - プログラミング・単体テスト実施時に発生した問題の原因分析にはまらない
  - バグが作りこまれにくい
- アーキテクトが実施すべきことが明確
  - 必要十分なアプリケーション・アーキテクチャ（構造と責務配置）のデザイン・パターンが用意されている
  - 外部仕様の設計に影響があるアプリケーションフレームワークの仕様や制限が明確
  - 拡張ポイントが適切に設定されており、個別PJ実装による入れ替えが可能。また拡張ポイントが明確
  - デフォルト実装で必要十分な基本機能が用意されている

<details>
<summary>keywords</summary>

lean and rapid, 習得コスト低減, 開発効率, アーキテクチャ設計, 拡張ポイント, 再利用可能コンポーネント, デフォルト実装

</details>

## long life

## long life

Nablarchが目指す「long life」の設計目標:

- 10年後も新規システム開発の基盤として使用できる。また、Nablarchを使用して構築したシステムが20年後も稼働し続けることができる
- 採用されている技術や機能の変化に対応するためのコストや労力が最小限に抑えられている

<details>
<summary>keywords</summary>

long life, 長期稼働, システム寿命, 技術変化対応コスト

</details>

## mission critical

## mission critical

Nablarchが目指す「mission critical」の設計目標:

- 大規模基幹システムで要求される性能を達成できる
- 大規模基幹システムを想定した可用性が実現されている
- オンライン・バッチ処理ともにスケールアウトできる仕組みが検討・実装されている
- セキュリティ面で強固
- 分散開発に対応できる

<details>
<summary>keywords</summary>

mission critical, 大規模基幹システム, 性能, 可用性, スケールアウト, セキュリティ, 分散開発

</details>

## independent

## independent

Nablarchが目指す「independent」の設計目標:

- アプリケーション・フレームワークについては、プロプライエタリ・ソフトウェア、オープンソース・ソフトウェアにかかわらず、特定のソフトウェアに依存していない

<details>
<summary>keywords</summary>

independent, 特定ソフトウェア非依存, ベンダー非依存, プロプライエタリ, オープンソース

</details>

## single point of truth and multi-purpose module

## single point of truth and multi-purpose module

Nablarchが目指す「single point of truth and multi-purpose module」の設計目標:

- 専用の機能及びコードではなく、多目的に利用できるシンプルな機能及びコードを開発することで、不要な重複と学習コストの増加を回避
- Web・バッチといった処理方式ごとにアーキテクチャを設計するのではなく、Nablarch全体としてのシンプルで理解しやすいアーキテクチャを設計

<details>
<summary>keywords</summary>

single point of truth, multi-purpose module, 重複回避, 学習コスト, アーキテクチャ統一, 全体アーキテクチャ

</details>

## global

## global

Nablarchが目指す「global」の設計目標:

- システム利用者が日本人に限定されない
- 開発関係者が日本人に限定されない

<details>
<summary>keywords</summary>

global, 多言語対応, 国際化, グローバル開発

</details>

## testablity

## testablity

Nablarchが目指す「testablity」の設計目標:

- アプリケーションフレームワークに最適なテスト・ポイントが用意されている
- テストの作成から実行結果の検証までを最も効率化できるよう、テスティングフレームワークが設計されている
- 開発工程全体でテストに重複がないように工夫されている

<details>
<summary>keywords</summary>

testablity, テスト効率化, テスティングフレームワーク, テストポイント, テスト重複排除

</details>

## whole engineering

## whole engineering

Nablarchが目指す「whole engineering」の設計目標:

- 全体最適の観点で解決策が提供されている。すなわち、ソフトウェア開発の全工程における最も適した方法（開発プロセス、設計標準、ソフトウェア実装、テスト標準等）によって問題が解消される

<details>
<summary>keywords</summary>

whole engineering, 全体最適, 開発プロセス, 設計標準, テスト標準, ソフトウェア開発全工程

</details>
