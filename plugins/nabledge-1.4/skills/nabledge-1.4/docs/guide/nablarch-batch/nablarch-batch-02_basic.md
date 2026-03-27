# バッチ共通のアプリケーション構造

## 作業単位

作業単位とは、同一のトランザクションで処理しなければならないデータのまとまり。

- DB入力バッチ: 検索結果1行が作業単位
- ファイル入力バッチ: 1レコードが作業単位
- コントロールブレイクの場合: 複数件のまとまりが作業単位（例: 顧客毎の当月請求明細）

<details>
<summary>keywords</summary>

作業単位, トランザクション, コントロールブレイク, DBバッチ, ファイルバッチ

</details>

## DBを入力とするバッチを実装する場合

`BatchAction`またはそのサブクラスを継承し、以下のメソッドを実装する。

| メソッド | 概要 | 起動タイミング | 要否 |
|---|---|---|---|
| `void initialize(CommandLine command, ExecutionContext context)` | 初期化処理 | メイン処理開始前に1回 | 任意 |
| `DataReader<D> createReader(ExecutionContext context)` | リーダを作成 | 初回データ読み込み時に1回 | 必須 |
| `Result handle(D inputData, ExecutionContext context)` | メイン処理 | 1作業単位の入力毎 | 必須 |
| `void transactionSuccess(D inputData, ExecutionContext context)` | 正常終了時の処理 | handleメソッド正常終了時毎 | 任意 |
| `void transactionFailure(D inputData, ExecutionContext context)` | 異常終了時の処理 | handleメソッド異常終了時毎 | 任意 |
| `void error(Throwable error, ExecutionContext context)` | エラー発生時の処理 | メイン処理でエラー発生後に1回 | 任意 |
| `void terminate(Result result, ExecutionContext context)` | 終了処理 | メイン処理終了後に1回 | 任意 |

> **注意**: `transactionFailure`はメイン処理とは別トランザクションで実行される（メイン処理エラー時はロールバックされるため）。

> **注意**: 型パラメータ`D`はレコードの型を表す総称型。DB入力バッチでは通常`SqlRow`となる。

> **注意**: `BatchActionBase`は`DbAccessSupport`を継承しているため、サブクラスでもDbAccessSupportの機能でデータベースアクセスが可能。

<details>
<summary>keywords</summary>

BatchAction, BatchActionBase, createReader, handle, transactionSuccess, transactionFailure, initialize, terminate, error, SqlRow, DbAccessSupport, DBバッチ実装, ExecutionContext

</details>

## ファイルを入力とするバッチを実装する場合

`FileBatchAction`を継承する。「DBを入力とするバッチを実装する場合」に示したメソッド（`createReader`、`handle`を除く）に加え、以下のメソッドを実装する。

| メソッド | 概要 | 起動タイミング | 要否 |
|---|---|---|---|
| `String getDataFileName()` | 入力ファイル名を返却 | メイン処理開始前に1回 | 必須 |
| `String getFormatFileName()` | レコードフォーマット定義ファイルを返却 | メイン処理開始前に1回 | 必須 |
| `Result do+レコードタイプ名(DataRecord inputData, ExecutionContext ctx)` | レコードタイプごとの処理 | 1作業単位の入力毎 | 必須 |

> **注意**: `createReader`メソッドは実装不要（スーパークラスに実装済み）。`handle`メソッドも実装不要（代わりに`do+レコードタイプ名`を実装する）。

`getFormatFileName()`で返却するフォーマット定義ファイルは、設計書から自動生成されたものを使用する。これにより、「レコード先頭xバイト目からxバイト分を半角数字として取得」するような物理的なファイルレイアウトを意識したプログラミングが不要になり、フィールド名を指定してデータを取得するだけでよい。

<details>
<summary>keywords</summary>

FileBatchAction, getDataFileName, getFormatFileName, DataRecord, ファイルバッチ実装, ExecutionContext

</details>

## フレームワーク動作イメージ

フレームワークの処理制御を擬似コードで示すと以下のようになる。

```java
initialize()                //-- 本処理開始前に一度だけ呼ばれる。
createReader()              //-- 初回データ読み込み時に1度だけ呼ばれる。
try {
  while(reader.hasNext()) {
    try {
      handle()              //-- 入力データ1件毎に繰り返し呼ばれる。
      transactionSuccess()  //-- handleが正常に終了した場合に呼ばれる。
    } catch(e) {
      transactionFailure()  //-- handleで例外が発生した場合に呼ばれる。
    }
  }
} catch(e) {
  error()                 //-- 本処理がエラー終了した場合に、一度だけ呼ばれる。
} finally {
  postProcess()             //-- 本処理が全て終了した後、一度だけ呼ばれる(エラー終了時でも呼ばれる)。
}
```

ファイル入力の場合も処理シーケンスは同じ。`DatabaseRecordReader`の代わりに`FileRecordReader`が使用される。

<details>
<summary>keywords</summary>

DatabaseRecordReader, FileRecordReader, バッチ処理フロー, 処理シーケンス, postProcess

</details>

## コマンドライン引数

Java起動時のコマンドライン引数は以下2種類に解釈される。

| 種別 | 説明 | 取得方法 |
|---|---|---|
| オプション | `-キー名=値` 形式のkey-valueペア | `CommandLine#getParamMap()` |
| 引数 | オプション以外。単一値 | `CommandLine#getArgs()` |

バッチ処理共通のコマンドラインオプション引数:

| キー名 | 設定値 | 説明 |
|---|---|---|
| `diConfig` | コンポーネント設定ファイルへのパス | バッチ処理はここで指定されたファイルの設定で動作する |
| `requestPath` | リクエストを特定するためのパス | 通常`"ss" + (機能ID) + "." + (アクションクラス名) + "/" + (リクエストID)` |
| `userId` | ユーザID | バッチ処理はここで指定されたユーザIDで実行される |

```bash
java <中略> nablarch.fw.launcher.Main -diConfig=file:./config/batch-config.xml \
                                      -requestPath=ss11AC.B11AC011Action/RB11AC0110 \
                                      -userId=batch_user
```

<details>
<summary>keywords</summary>

CommandLine, getParamMap, getArgs, diConfig, requestPath, userId, nablarch.fw.launcher.Main

</details>

## 初期化処理

`initialize`メソッド（任意）。メイン処理実行前にフレームワークから起動される。

実装すべき処理の例:
- コマンドライン引数の処理
- リソースの取得
- 開始ログの出力
- インスタンス変数の初期化

> **警告**: インスタンス変数を使用するバッチアクションは**マルチスレッド実行不可**。インスタンス変数は`initialize`メソッドで**明示的に初期化しなければならない**。ただし、`initialize`で初期化後に値が更新されない（読取専用）場合はマルチスレッド実行が可能。

<details>
<summary>keywords</summary>

initialize, マルチスレッド, インスタンス変数, 初期化処理

</details>

## リーダ作成

`createReader`メソッド（必須）。バッチ処理の入力データを読み込む`DataReader`を返却する。フレームワークがこのメソッドを呼び出してリーダを取得し、入力データの読み込みを行う。

<details>
<summary>keywords</summary>

createReader, DataReader, リーダ作成

</details>

## 1作業単位毎の処理

`handle`メソッド（必須）。`createReader`で取得したリーダから1作業単位のデータを読み込む毎に起動される。

戻り値には`nablarch.fw.Result`インタフェース実装クラスのインスタンスを返却する。通常は`nablarch.fw.Result.Success`を返却する。

<details>
<summary>keywords</summary>

handle, Result, Result.Success, nablarch.fw.Result

</details>

## エラー発生時の処理

**handleエラー時: transactionFailure**

`transactionFailure`メソッド（任意）。`handle`メソッドでエラーが発生する度に呼び出される。引数にはエラー発生時に処理していたデータが渡される。

> **注意**: `transactionFailure`は`handle`メソッドとは別のトランザクションで実行される。

実装すべき処理の例:
- エラーが発生したレコードのステータスを異常終了に更新
- 専用のエラーファイルへのエラーレコード出力（エラーリスト作成）

**処理全体のエラー時: error**

`error`メソッド（任意）。本処理がエラー終了した場合に一度だけ呼び出される（マルチスレッド実行時でも1回）。引数の`Throwable`には通常`java.util.concurrent.ExecutionException`が渡される。メイン処理で発生した例外は`ExecutionException#getCause()`で取得できる。

<details>
<summary>keywords</summary>

transactionFailure, error, ExecutionException, エラー処理, getCause

</details>

## 終了処理

`terminate`メソッド（任意）。リーダから全データを読み取った後にフレームワークから起動される。

実装すべき処理の例:
- リソースの解放
- 処理件数のログ出力

<details>
<summary>keywords</summary>

terminate, 終了処理, リソース解放

</details>
