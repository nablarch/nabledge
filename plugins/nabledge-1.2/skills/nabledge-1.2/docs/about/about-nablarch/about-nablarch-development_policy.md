# Nablarchの目指す姿

## lean and rapid

## lean and rapid

Nablarchは以下を目指す。

- Nablarch固有の知識の初期習得コストが低いこと
- アプリケーション開発者が機能を単純に実装でき、本質的な作業に専念できること
  - 開発環境・実行環境の構築が簡単であること
  - Java、SQL、HTMLといった極めて基本的な技術のみで実装できること
  - 必要十分な抽象化が行われていること
  - 必要十分なユーティリティ、サンプル、テンプレート、ツール類があり、すぐに目的のものを探し出して利用できること
  - 汎用的な業務アプリケーションやビジネスロジックが再利用可能なコンポーネントとして用意されており、プロジェクトで必要な設定を行うだけで利用できること
  - プログラミング・単体テスト実施時に発生した問題の原因分析にはまらないこと
  - バグが作りこまれにくいこと
- アーキテクトが実施すべきことが明確になっていること
  - 必要十分なアプリケーション・アーキテクチャのデザイン・パターンが用意されていること
  - 外部仕様の設計に影響があるフレームワークの仕様や制限が明確であること
  - 拡張ポイントが適切に設定されており、個別PJ実装による入れ替えが可能であること。また、その拡張ポイントが明確であること
  - デフォルト実装で必要十分な基本機能が用意されていること

<details>
<summary>keywords</summary>

lean and rapid, 習得コスト, 開発生産性, アーキテクト, 拡張ポイント, コンポーネント再利用, バグ抑制

</details>

## long life

## long life

- 10年後も新規システム開発の基盤として使用できること。また、Nablarchを使用して構築したシステムが20年後も稼働し続けられること
- 採用されている技術や機能の変化に対応するためのコストや労力が最小限に抑えられること

<details>
<summary>keywords</summary>

long life, 長期運用, システム寿命, 技術変化対応, 保守コスト

</details>

## mission critical

## mission critical

- 大規模基幹システムで要求される性能を達成できること
- 大規模基幹システムを想定される可用性が実現されていること
- オンライン・バッチ処理ともにスケールアウトできるような仕組みが検討・実装されていること
- セキュリティ面で強固であること
- 分散開発に対応できること

<details>
<summary>keywords</summary>

mission critical, 大規模基幹システム, スケールアウト, セキュリティ, 可用性, 分散開発

</details>

## independent

## independent

- アプリケーション・フレームワークについては、プロプライエタリ・ソフトウェア、オープンソース・ソフトウェアにかかわらず、特定のソフトウェアに依存していないこと

<details>
<summary>keywords</summary>

independent, 特定ソフトウェア非依存, ベンダーロックイン回避, プロプライエタリ, オープンソース

</details>

## single point of truth and multi-purpose module

## single point of truth and multi-purpose module

- 専用の機能・コードではなく、多目的に利用できるシンプルな機能・コードを開発することで、不要な重複と学習コストの増加を回避していること
- Web・バッチといった処理方式ごとにアーキテクチャを設計するのではなく、Nablarch全体としてのシンプルで理解しやすいアーキテクチャが設計されていること

<details>
<summary>keywords</summary>

single point of truth, 多目的モジュール, 重複回避, 統一アーキテクチャ, 学習コスト削減

</details>

## global

## global

- システム利用者が日本人に限定されていないこと
- 開発関係者が日本人に限定されていないこと

<details>
<summary>keywords</summary>

global, 多言語対応, グローバル開発, 国際化

</details>

## testablity

## testablity

- アプリケーションフレームワークに最適なテスト・ポイントが用意されていること
- テストの作成から実行結果の検証までを最も効率化できるよう、テスティングフレームワークが設計されていること
- 開発工程全体でテストに重複がないように工夫されていること

<details>
<summary>keywords</summary>

testablity, テスト設計, テスティングフレームワーク, テスト効率化, テストポイント

</details>

## whole engineering

## whole engineering

- 全体最適の観点で解決策が提供されていること。すなわち、ソフトウェア開発の全工程における最も適した方法（開発プロセス、設計標準、ソフトウェア実装、テスト標準等）によって問題が解消されること

<details>
<summary>keywords</summary>

whole engineering, 全体最適, 開発プロセス, 設計標準, テスト標準

</details>
