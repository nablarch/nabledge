# アプリケーションの責務配置

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/application_design.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.Success.html)

## アプリケーションの責務配置

Nablarchバッチアプリケーションを構成する3クラスとその責務:

**アクションクラス**: `nablarch.fw.DataReader`, `nablarch.fw.Result`

2つの責務を持つ:
1. 入力データ読み込みに使う `DataReader` を生成する
2. `DataReader` が読み込んだデータレコードを元に業務ロジックを実行し、`Result` を返却する

ファイル取り込みバッチの場合の業務ロジック例:
- データレコードからフォームクラスを作成してバリデーションを実行
- フォームクラスからエンティティクラスを作成してDBにデータを追加
- `Success` を返す

**フォームクラス**

`DataReader` が読み込んだデータレコードをマッピングするクラス。バリデーションアノテーションや相関バリデーションのロジックを持つ。フォームがフォームを持つ階層構造になる場合もある。

フォームクラスのプロパティは全て `String` で定義する（バイナリ項目はバイト配列）。理由は [Bean Validation](../../component/libraries/libraries-bean_validation.md) を参照。

> **補足**: 外部ファイルなど入力データが安全でない場合はバリデーションを行いフォームクラスを作成する。データベースなど入力データが安全な場合は、フォームクラスを使用せずデータレコードから直接エンティティクラスを作成して業務ロジックを実行してよい。

**エンティティクラス**

テーブルと1対1で対応するクラス。カラムに対応するプロパティを持つ。

<details>
<summary>keywords</summary>

DataReader, Result, Success, nablarch.fw.DataReader, nablarch.fw.Result, nablarch.fw.Result.Success, アクションクラス, フォームクラス, エンティティクラス, 責務配置, バリデーション, バッチアプリケーション設計

</details>
