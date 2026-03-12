# アプリケーションの責務配置

**公式ドキュメント**: [アプリケーションの責務配置](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/application_design.html)

## Batchletステップの場合

**クラス**: `Batchlet`

バッチレットで業務ロジックを実行し、ステップの処理結果を表す文字列（バッチレットの終了ステータス）を返却する。終了ステータスの詳細は Jakarta Batch Specification を参照。用途例: ファイルダウンロード、`insert～select` のみで完結するSQL実行など。

<details>
<summary>keywords</summary>

Batchlet, バッチレット, ステップ処理結果, 業務ロジック実行, バッチレットクラス, 終了ステータス, Jakarta Batch Specification

</details>

## Chunkステップの場合

**クラス**: `ItemReader`

データソース（ファイルやデータベース等）から処理対象データを読み込み、フォームに変換して返却する。`ItemReader` は Jakarta Batch で規定されているインタフェースであるため、実装方法などの詳細は Jakarta Batch Specification を参照。

**クラス**: `ItemProcessor`

アイテムリーダが読み込んだデータを元に業務ロジックを実行し、出力対象データを生成する。出力対象がDBの場合はエンティティに変換、DB以外は出力用フォームに変換する。`ItemProcessor` は Jakarta Batch で規定されているインタフェースであるため、実装方法などの詳細は Jakarta Batch Specification を参照。

> **補足**: 外部から取得したデータを扱う場合は、業務ロジック実行前に入力値チェックを行うこと。[入力値のチェック](../../component/libraries/libraries-validation.md) 参照。

**クラス**: `ItemWriter`

アイテムプロセッサで変換したエンティティ（フォーム）をデータベースやファイルに出力する。`ItemWriter` は Jakarta Batch で規定されているインタフェースであるため、実装方法などの詳細は Jakarta Batch Specification を参照。

**クラス**: `Form`（フォームクラス）

アイテムリーダが読み込んだデータを保持するクラス。出力対象がDB以外の場合は出力データも保持する。外部から受け付けた信用できない値を保持するフォームでは、プロパティ型をすべて `String` にすること（バイナリ項目はバイト配列）。理由は [Bean Validation](../../component/libraries/libraries-bean_validation.md) 参照。

**クラス**: `Entity`（エンティティクラス）

テーブルと1対1で対応するクラス。カラムに対応するプロパティを持つ。

<details>
<summary>keywords</summary>

ItemReader, ItemProcessor, ItemWriter, Form, Entity, チャンク処理, フォームクラス, エンティティクラス, 入力値チェック, Bean Validation, Jakarta Batch Specification

</details>
