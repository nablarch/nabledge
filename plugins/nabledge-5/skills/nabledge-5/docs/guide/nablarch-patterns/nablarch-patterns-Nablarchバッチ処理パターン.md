# Nablarchバッチ処理パターン

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/index.html) [2](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/architecture.html#nablarch-batch-each-time-batch) [3](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/index.html)

## 起動方法による分類

Nablarchバッチの主な2つの起動方法:

1. **[都度起動バッチ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/architecture.html#nablarch-batch-each-time-batch)**: プロセスを都度起動してバッチ処理を実行。日次・月次など定期的な処理に使用。
2. **[テーブルをキューとして使ったメッセージング](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/index.html)**: プロセスを起動したままDBテーブルを定期監視し、未処理レコードを順次処理。オンライン処理で処理要求を受け付け、非同期でバッチ処理を実行する場合に使用。

<details>
<summary>keywords</summary>

都度起動バッチ, テーブルをキューとして使ったメッセージング, 常駐バッチ, バッチ起動方法, 非同期バッチ処理, 定期バッチ

</details>

## 入出力による分類

入出力の組み合わせによる3パターン:

|  | FILE to DB | DB to DB | DB to FILE |
|---|---|---|---|
| 都度起動 | ○ | ○ | ○ |
| 常駐 | ✕ | ○ | △ |

- ○：使用する、△：仕組み上は可能だが普通は使わない、✕：使わない
- 常駐バッチはDBを監視するため、FILE to DBとの組み合わせなし

### FILE to DB

- 外部から受け取ったファイルをシステムに取り込む際に使用
- 取り込み先はテンポラリテーブル（ファイルのレイアウトと1対1のカラム構成）。業務用テーブルではない
- できるだけ業務処理を加えず、ファイルをテンポラリテーブルにINSERTする
- メリット: (1) RDBの強力な機能（トランザクション・SQL）が使用できる。従来のマッチング処理はSQLのJOINで代替可能、コントロールブレイク処理はGROUP BYで代替できるケースあり。(2) Nablarchのファイル取り込み機能を使用すると障害発生時に途中から再開可能

### DB to DB

- 入力: SELECT文の結果セットの各レコード
- 1レコードのデータを受け取ってDBを更新
- 1レコードの処理中の更新は全て同一トランザクション下で実行されるため、障害発生時も不整合が発生しない

### DB to FILE

- 入力: SELECT文の結果セットの各レコード
- 1レコードのデータを受け取ってファイルを書き出す（通常は1行分）
- DBはトランザクション管理されるが、ファイル書き出しは管理外のため、障害発生時に不整合がありえる

### FILE to FILE

- Nablarchバッチではこの形態は使用しない
- 代替手段: 各ファイルをDBに取り込んだ後、SQLでJOINすることで同等の処理が可能
- FILE to FILEはバッチプログラムが複雑化し、ファイルとDBの切り分けが難しくバグが埋め込みやすい。前述のパターンの組み合わせで実現したほうが各バッチがシンプルになり設計しやすい

<details>
<summary>keywords</summary>

FILE to DB, DB to DB, DB to FILE, バッチ処理パターン, テンポラリテーブル, マッチング処理, コントロールブレイク, FILE to FILE

</details>

## 注意点（ファイルの移動・コピー）

FILE to DBまたはDB to FILEを行うバッチ処理には、ファイルの移動・コピーを含めないこと。

**問題（含めた場合）**: ファイル移動を初期化処理として本処理の前に含めると、本処理失敗時の再実行前に入力ファイルを元のディレクトリに戻すオペレーションが必要となる。

**ファイル移動・コピーを別出しするメリット**:
1. 再実行がやりやすくなる
2. ファイル取り込みバッチの単体テストがやりやすくなる
3. ファイルの移動・コピーを自分で実装しないので、その単体テストが不要になる

<details>
<summary>keywords</summary>

ファイル移動, ファイルコピー, バッチ再実行, 単体テスト, FILE to DB, DB to FILE

</details>
