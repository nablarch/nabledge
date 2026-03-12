# アプリケーションの責務配置

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/application_design.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result/Success.html)

## クラスとその責務

**アクションクラス** (`nablarch.fw.DataReader` / `nablarch.fw.Result`)

`DataReader` を生成し、読み込んだデータレコードを元に業務ロジックを実行して `Result` を返却する。

ファイル取り込みバッチの場合の業務ロジック例:
1. データレコードからフォームクラスを作成してバリデーションを実行
2. フォームクラスからエンティティクラスを作成してDBにデータを追加
3. `Success` を返す

**フォームクラス**

`DataReader` が読み込んだデータレコードをマッピングするクラス。バリデーションアノテーションや相関バリデーションロジックを持つ。入力データによっては階層構造（フォームがフォームを持つ）となる場合もある。

- プロパティは全て `String` で定義する（理由: [Bean Validation](../../component/libraries/libraries-bean_validation.md) 参照）
- バイナリ項目のみバイト配列で定義する

> **補足**: 外部ファイルなど入力データが安全でない場合はバリデーションを行いフォームクラスを作成する。DBなど入力データが安全な場合はフォームクラスを使用せず、データレコードから直接エンティティクラスを作成して業務ロジックを実行する。

**エンティティクラス**

テーブルと1対1で対応するクラス。カラムに対応するプロパティを持つ。

<details>
<summary>keywords</summary>

DataReader, Result, Result.Success, アクションクラス, フォームクラス, エンティティクラス, バリデーション, 責務配置, バッチ設計

</details>
