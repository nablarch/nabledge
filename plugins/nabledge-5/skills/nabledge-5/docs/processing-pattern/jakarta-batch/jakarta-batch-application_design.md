# アプリケーションの責務配置

**公式ドキュメント**: [アプリケーションの責務配置](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/application_design.html)

## Batchletステップの場合

## Batchletステップの場合

**Batchlet class**: 業務ロジックを実行し、ステップの処理結果を表す文字列（バッチレットの終了ステータス）を返却する。

用途例: インターネット上のファイルのダウンロード、`insert～select`のみで完結するSQL実行。

<details>
<summary>keywords</summary>

Batchlet, バッチレットステップ, 業務ロジック実行, 終了ステータス, insert～select

</details>

## Chunkステップの場合

## Chunkステップの場合

**ItemReader class**: データソース（ファイル・データベース等）からデータを読み込み、フォームに変換して返却する。ItemReaderはJSR352で規定されているインタフェースであるため、実装方法などの詳細はJSR352 Specificationを参照。

**ItemProcessor class**: ItemReaderが読み込んだデータを元に業務ロジックを実行し、出力対象データを生成する。DB出力の場合はエンティティに変換、それ以外は出力用フォームに変換する。ItemProcessorはJSR352で規定されているインタフェースであるため、実装方法などの詳細はJSR352 Specificationを参照。

> **補足**: ItemReaderで読み込んだデータが外部から取得したデータの場合は、業務ロジック実行前に入力値のチェック（[validation](../../component/libraries/libraries-validation.md)）を行うこと。

**ItemWriter class**: ItemProcessorで変換したエンティティ（フォーム）をデータベースやファイルに出力する。ItemWriterはJSR352で規定されているインタフェースであるため、実装方法などの詳細はJSR352 Specificationを参照。

**フォーム(form class)**: ItemReaderが読み込んだデータを保持するクラス。DB以外の出力の場合に出力データも保持する。外部から受け付けた信用できない値を保持するフォームの場合、プロパティの型は全て`String`とする（[Bean Validation](../../component/libraries/libraries-bean_validation.md) 参照）。ただし、バイナリ項目はバイト配列で定義する。

**エンティティ(entity class)**: テーブルと1対1で対応するクラス。カラムに対応するプロパティを持つ。

<details>
<summary>keywords</summary>

ItemReader, ItemProcessor, ItemWriter, チャンクステップ, フォーム, エンティティ, 入力値チェック, bean_validation-form_property, JSR352, 標準インタフェース

</details>
