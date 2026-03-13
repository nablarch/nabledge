# Nablarch 5u8 リリースノート

**公式ドキュメント**: [Nablarch 5u8 リリースノート](https://fintan.jp/page/252/)

## 5u8 変更内容（アプリケーションフレームワーク・Example・実装例集）

## Nablarch 5u8 変更内容

5u7からの変更点。

### アプリケーションフレームワーク（オブジェクトコード・ソースコード）

#### No.1: DatabaseRecordReaderに拡張ポイントを追加（変更）
- **対象モジュール**: `nablarch-fw-batch` 1.2.0
- **アプリへの影響**: なし
- `DatabaseRecordListener` の実装クラスを `DatabaseRecordReader` に設定することで、入力データのキャッシュのためのDBアクセス前に任意の処理を追加できる。

#### No.2: セッション変数が存在しない場合の例外を専用例外に変更（変更）
- **対象モジュール**: `nablarch-fw-web` 1.3.0
- **アプリへの影響**: なし
- セッション変数が存在しない場合、`SessionKeyNotFoundException` を送出するように変更。
- `SessionKeyNotFoundException` は変更前の `NoSuchElementException` を継承しているため、既存アプリへの影響はない。
- ハンドラで `SessionKeyNotFoundException` を捕捉し横断的な処理（専用エラーページへの遷移など）が可能。

#### No.3: メール送信機能のマルチプロセス化対応（変更）
- **対象モジュール**: `nablarch-mail-sender` 1.1.0
- **アプリへの影響**: なし（設定追加しなければ変更前と同様に動作）
- `MailSender` をマルチプロセスで実行可能に。メール送信要求テーブルにマルチプロセス用カラムを追加し、設定を追加すると処理対象データ読み込み前に悲観ロック処理を行い、プロセス間で同一データを処理しないよう変更。

#### No.4: テンプレートの置き換え文字にnullが指定された場合の挙動を修正（不具合）
- **対象モジュール**: `nablarch-mail-sender` 1.1.0（起因: 1.0.0）
- **アプリへの影響**: あり
- 修正前: 置き換え文字にnullが指定された場合、`NullPointerException` が発生。
- 修正後: nullは空文字列で置き換える。
- 置き換え対象のキーにnullが指定された場合は例外を送出（アプリの不具合の可能性が高いため）。
- > **警告**: アプリケーションで例外をハンドリングしている場合は、処理を見直すこと（例外が送出されなくなった）。

#### No.5: JSPカスタムタグで配列・コレクションの要素にnullが格納された場合の挙動を修正（不具合）
- **対象モジュール**: `nablarch-fw-web-tag` 1.0.5（起因: 1.0.0）
- **アプリへの影響**: あり
- 修正前: 各スコープ・リクエストパラメータから取得した配列・コレクションの要素にnullが格納されていた場合、`NullPointerException` が発生。
- 修正後: nullを空文字列として扱う。
- > **警告**: アプリケーションで例外をハンドリングしている場合は、処理を見直すこと（例外が送出されなくなった）。

#### No.6: データタイプ・コンバータ初期化時のnull指定で適切な例外を送出するよう変更（変更）
- **対象モジュール**: `nablarch-core-dataformat` 1.0.3（起因: 1.0.0）
- **アプリへの影響**: なし
- 修正前: パラメータが必須のものにnullを指定した場合、`NullPointerException` が発生し原因特定が困難。
- 修正後: 適切なメッセージを指定した例外を送出。

#### No.7: 例外メッセージのクラス名表記の不統一を修正（変更）
- **対象モジュール**: `nablarch-core-dataformat` 1.0.3（起因: 1.0.0）
- **アプリへの影響**: あり
- 対象クラス: `DoubleByteCharacterString`、`SignedPackedDecimal`、`SignedZonedDecimal`
- 修正内容: 例外メッセージに含まれる自身のクラス名を、完全修飾名からクラス名（単純名）に変更。
- > **警告**: アプリケーションで例外メッセージを処理している場合は、処理を見直すこと。

#### No.8: テスト時にコンバータ設定をデフォルトに戻せない問題に対応（不具合）
- **対象モジュール**: `nablarch-core-dataformat` 1.0.3（起因: 1.0.0）
- **アプリへの影響**: なし
- `SystemRepository#clear` を使用してコンバータ設定をデフォルトに戻せるように修正。
- 対象コンバータ設定: `VariableLengthConvertorSetting`、`FixedLengthConvertorSetting`、`XmlDataConvertorSetting`、`JsonDataConvertorSetting`

#### No.9: 書き込み時の値にnullが指定された場合の挙動を修正（不具合）
- **対象モジュール**: `nablarch-core-dataformat` 1.0.3（起因: 1.0.0）
- **アプリへの影響**: あり
- 数値型の項目: 修正前はnullまたは空文字で例外送出 → 修正後は0を出力。
- XMLの必須項目: 修正前はnullで例外送出 → 修正後は空文字を出力。
- 文字列型・バイナリ型などは変更なし。
- `NullableString#convertOnWrite` の動作変更: 引数がnullの場合、修正前はnullを返していたが、修正後は空文字を返す。`DataRecordFormatter` を実装したクラスで `NullableString` の使用を前提にしている場合は処理を見直すこと。
- > **警告**: アプリケーションで例外をハンドリングしている場合は処理を見直すこと。実装例集の「FormUrlEncodedデータフォーマッタ」を使用している場合はNo.27の変更を取り込むこと。

#### No.10: マルチレイアウトの識別項目がnullの場合の挙動を修正（不具合）
- **対象モジュール**: `nablarch-core-dataformat` 1.0.3（起因: 1.0.0）
- **アプリへの影響**: なし
- 修正前: 固定長/可変長のマルチレイアウトでデフォルト値を指定した場合でも、識別項目がnullの場合に `NullPointerException` が発生。
- 修正後: 識別項目がnullの場合はデフォルト値にマッチするレイアウトで実行。
- > **警告**: アプリケーションで例外をハンドリングしている場合は、処理を見直すこと（例外が送出されなくなった）。

#### No.11: required-decimal-pointディレクティブが符号なし数値で有効にならない問題に対応（不具合）
- **対象モジュール**: `nablarch-core-dataformat` 1.0.3（起因: 1.0.0）
- **アプリへの影響**: なし
- `required-decimal-point` ディレクティブをフォーマット定義ファイルに指定した場合、符号なし数値でも設定が有効となるように修正。

#### No.12: 固定長のバイナリ型で出力対象のバイト長を考慮しない問題を修正（不具合）
- **対象モジュール**: `nablarch-core-dataformat` 1.0.3（起因: 1.0.0）
- **アプリへの影響**: あり
- 修正前: 固定長バイナリ型データの出力において、指定バイト長に関係なく出力（不正なバイト長のデータを出力可能な状態）。
- 修正後: バイト長をチェックし、バイト長が正しくない場合は例外を送出。
- > **警告**: 固定長で出力時にバイト長の異なるバイナリデータを書き込むことを想定している場合、影響を受ける。影響を受ける場合はマルチレイアウトを用いるなどの対応を検討すること。

#### No.13: Bean Validationエラーメッセージのプロパティ名が誤っていた問題を修正（不具合）
- **対象モジュール**: `nablarch-core-validation-ee` 1.0.5（起因: 5u6）
- **アプリへの影響**: あり
- `InjectForm#prefix` を指定しなかった場合、エラーメッセージのプロパティ名の先頭に余計なドット(.)が含まれていた。これを除去するように修正。
- Nablarch Validationではこの問題は発生しない。
- > **警告**: アプリケーションで先頭にドット(.)が付くことを想定して処理している場合は、処理を見直すこと。

### アプリケーションフレームワーク（解説書）

#### No.14: JSPで自動的にHTTPセッションを作成しないようにする方法を追記（変更）
- **対象モジュール**: `nablarch-document` 5u8
- **アプリへの影響**: なし
- JSPで自動的にHTTPセッションを作成しないようにする方法を解説書に追記。

#### No.15: 常駐バッチのマルチプロセス化の方法を追記（変更）
- **対象モジュール**: `nablarch-document` 5u8
- **アプリへの影響**: なし
- 常駐バッチをマルチプロセスで起動させるための手順を機能詳細に追記。

#### No.16: テーブルをキューとしたメッセージングのマルチプロセス化の方法を追記（変更）
- **対象モジュール**: `nablarch-document` 5u8
- **アプリへの影響**: なし
- テーブルをキューとしたメッセージングのマルチプロセスで起動させるための手順を機能詳細に追記。

#### No.17: HIDDENストアの特徴にある誤った内容を削除（不具合）
- **対象モジュール**: `nablarch-document` 5u8（起因: 5u6）
- **アプリへの影響**: なし
- 「ブラウザの戻るボタンによる操作を許容している画面では使用できない。」という誤った記述を削除。

#### No.18: デフォルト設定一覧にメール送信バッチのマルチプロセス用カラム設定を追加（変更）
- **対象モジュール**: `nablarch-document` 5u8
- **アプリへの影響**: なし
- プロパティ名: `sendProcessIdColumnName`（メール送信要求管理テーブルのメール送信プロセスIDカラムの名前）をデフォルト設定一覧に追加。

#### No.19: ユニバーサルDAOの「現在のトランザクションとは異なるトランザクションで実行する」実装例の誤りを修正（不具合）
- **対象モジュール**: `nablarch-document` 5u8（起因: 5u6）
- **アプリへの影響**: なし
- `UniversalDao.Transaction` を継承したクラスの呼び出し実装例から、明示的な `doTransaction` メソッドの呼び出しを削除（明示的に呼び出すと2回実行される）。

#### No.20: 文字集合の包含関係を表す図の誤りを修正（不具合）
- **対象モジュール**: `nablarch-document` 5u8
- **アプリへの影響**: なし
- 「ASCII記号」が「半角英数」の直下ではなく「ASCII文字」の直下にある旨を修正。

### ブランクプロジェクト

#### No.21: メール送信バッチをマルチプロセスで動作するように変更（変更）
- **対象モジュール**: `nablarch-batch-archetype` 5u8
- **アプリへの影響**: なし
- `MAIL_REQUEST` テーブルに `PROCESS_ID` カラムを追加。

#### No.22: デフォルトコンフィグレーションにマルチプロセス用カラム名設定を追加（変更）
- **対象モジュール**: `nablarch-default-configuration` 1.0.4
- **アプリへの影響**: なし
- メール送信バッチがデフォルトでマルチプロセスで動作するよう、マルチプロセス用カラム名の設定を追加。

### Example

#### No.23: JSPで自動的にHTTPセッションを作成しないように変更（変更）
- **対象モジュール**: `nablarch-example-web` 5u8
- **アプリへの影響**: なし
- すべてのJSPに `pageディレクティブのsession属性（=false）` を指定。この指定がないと、HttpSessionを使用しない画面に大量アクセスがあった場合にメモリが枯渇する可能性がある。

#### No.24: 常駐バッチ実行時にレコードを削除しないように変更（変更）
- **対象モジュール**: `nablarch-example-batch` 5u8
- **アプリへの影響**: なし
- 処理後にレコードを削除する実装から、ステータスカラムを用意してステータスを更新する実装に変更。

#### No.25: 常駐バッチをマルチプロセスで起動しても動作するように変更（変更）
- **対象モジュール**: `nablarch-example-batch` 5u8
- **アプリへの影響**: なし
- 処理対象データ読み込み前に悲観ロック処理を追加し、プロセス間で同一データを処理しないよう変更。

#### No.26: テーブルをキューとしたメッセージングをマルチプロセスで起動しても動作するように変更（変更）
- **対象モジュール**: `nablarch-example-db-queue` 5u8
- **アプリへの影響**: なし
- 処理対象データ読み込み前に悲観ロック処理を追加し、プロセス間で同一データを処理しないよう変更。

### Nablarch実装例集

#### No.27: 汎用データフォーマットの不具合対応に合わせてFormUrlEncodedデータフォーマッタを修正（変更）
- **対象モジュール**: `nablarch-biz-sample-all` 5u8
- **アプリへの影響**: なし
- `NullableString` の動作変更（No.9）に伴い、`FormUrlEncodedデータフォーマッタ` を修正。No.9の影響を受ける場合はこの変更を取り込むこと。

<details>
<summary>keywords</summary>

DatabaseRecordReader, DatabaseRecordListener, SessionKeyNotFoundException, MailSender, NullableString, InjectForm, DoubleByteCharacterString, SignedPackedDecimal, SignedZonedDecimal, VariableLengthConvertorSetting, FixedLengthConvertorSetting, XmlDataConvertorSetting, JsonDataConvertorSetting, SystemRepository, DataRecordFormatter, UniversalDao, nablarch-fw-batch, nablarch-fw-web, nablarch-mail-sender, nablarch-core-dataformat, nablarch-core-validation-ee, nablarch-fw-web-tag, メール送信マルチプロセス, セッションストア専用例外, 汎用データフォーマットnull処理, Bean Validationエラーメッセージ, バージョンアップ手順, sendProcessIdColumnName, required-decimal-point

</details>

## 5u8 バージョンアップ手順

## バージョンアップ手順

5u8への適用手順:

1. `pom.xml` の `<dependencyManagement>` セクションに指定されている `nablarch-bom` のバージョンを `5u8` に書き換える。
2. mavenのビルドを再実行する。

<details>
<summary>keywords</summary>

nablarch-bom, pom.xml, dependencyManagement, 5u8, バージョンアップ, maven

</details>
