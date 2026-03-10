# Nablarchバッチ処理パターン

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/index.html) [2](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/architecture.html#nablarch-batch-each-time-batch) [3](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/index.html)

## 起動方法による分類

Nablarchバッチの主な2つの起動方法:

- **[都度起動バッチ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/architecture.html#nablarch-batch-each-time-batch)**: プロセスを都度起動してバッチ処理を実行。日次・月次など定期的バッチに使用
- **[テーブルをキューとして使ったメッセージング](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/index.html)**: プロセスを起動しておき、定期的にDBテーブルを監視して未処理レコードを順次処理。オンライン処理の非同期バッチに使用

<details>
<summary>keywords</summary>

都度起動バッチ, テーブルをキューとして使ったメッセージング, バッチ起動方法, 非同期バッチ, 定期バッチ, 常駐バッチ

</details>

## 入出力による分類

入出力パターンの組み合わせ:

|          | FILE to DB | DB to DB | DB to FILE |
|----------|------------|----------|------------|
| 都度起動 | ○         | ○       | ○         |
| 常駐     | ✕          | ○       | △         |

- ○：使用する
- △：仕組み上は可能だが普通は使わない
- ✕：使わない

（常駐バッチは通常DBを監視するため、FILE to DBとの組み合わせはない）

### FILE to DB

外部ファイルをシステムに取り込む際に使用。ファイルをテンポラリテーブル（ファイルレイアウトと1対1のカラム）にINSERTする。**業務処理はできるだけ加えない**こと。

テンポラリテーブルに取り込むメリット:
- RDBの強力な機能（トランザクション、SQL）が使用できる
  - 従来のマッチング処理はSQLのJOINで代替可能
  - 従来のコントロールブレイク処理はGROUP BYで代替できるケースがある
- Nablarchのファイル取り込み機能（任意）: 障害発生時に途中から再開可能

### DB to DB

入力はSELECT文の結果セットの各レコード。1レコード受け取りDBを更新。1レコードの処理中の更新は全て同一トランザクション下で実行されるため、障害発生時でも不整合が発生しない。

### DB to FILE

入力はSELECT文の結果セットの各レコード。1レコード受け取りファイルを書き出す（通常1行）。DBはトランザクション管理されるが、ファイル書き出しは管理外のため、障害発生時に不整合が起きえる。

### FILE to FILE（技術的には可能だが非推奨）

Nablarchバッチではこの形態は**使用しない**ことを推奨する。マッチングやコントロールブレイクといったメインフレームのバッチでよくあるようなファイル処理をNablarchバッチで実現することは技術的には可能だが、以下の問題があるため推奨しない:
- バッチプログラムが複雑になる
- どこまでをファイルでどこまでをDBで扱うかという切り分けが難しい

代わりに各ファイルをDBに取り込んだ後、SQLでJOINすることで同等の処理ができる。各バッチがシンプルになり設計がしやすく、バグが埋め込みにくい。

<details>
<summary>keywords</summary>

FILE to DB, DB to DB, DB to FILE, テンポラリテーブル, バッチ入出力パターン, マッチング処理, コントロールブレイク, FILE to FILE

</details>

## 注意点

### ファイルの移動、コピー

FILE to DBまたはDB to FILEを行う場合、そのバッチ処理にはファイルの移動やコピーは含めないようにします。含めると処理失敗時の再実行前に入力ファイルを元のディレクトリに戻すオペレーションが必要になる。

ファイルの移動・コピーを別出しにするメリット:
- 再実行がやりやすくなる
- ファイル取り込みバッチの単体テストがやりやすくなる
- ファイルの移動・コピーに対する単体テストが不要になる

<details>
<summary>keywords</summary>

ファイル移動, ファイルコピー, バッチ再実行, 単体テスト, ファイル取り込み

</details>
