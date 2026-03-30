# バッチ共通のアプリケーション構造

## 概要

Nablarch Application Frameworkのバッチ処理機能:
- **ループ処理の代行**: フレームワークがループ制御を代行。業務アプリケーションは作業単位毎の処理に集中できる。
- **イベントコールバック**: 開始時・エラー発生時・終了時の各イベント発生時に対応メソッドが起動される。エラー処理漏れやリソース解放漏れを抑止できる。
- **ファイル入出力の簡易化**: 設計書から自動生成されたフォーマット定義ファイルを使用。物理ファイルレイアウトを意識したプログラミング不要。フィールド名を指定するだけで入力データを取得できる。

バッチ処理実装時は、mainメソッドから全処理を実装するのではなく、フレームワークのクラスを継承して業務処理を実装する。

<details>
<summary>keywords</summary>

バッチ処理基本構造, 作業単位, ループ処理代行, イベントコールバック, ファイル入出力簡易化

</details>

## 作業単位

作業単位とは、同一のトランザクションで処理しなければならないデータのまとまりを指す。

典型的なバッチ処理での作業単位:
- **DB入力の場合**: 検索結果1行
- **ファイル入力の場合**: 1レコード

コントロールブレイクを行う場合は複数件のまとまりが作業単位となることがある。例えば「顧客毎に当月の売上明細を集計して翌月請求額を求める」という場合には、顧客の当月請求明細のまとまりが作業単位となる。

<details>
<summary>keywords</summary>

作業単位, コントロールブレイク, トランザクション単位, DB入力, ファイル入力

</details>

## クラス構造

### DBを入力とするバッチを実装する場合

**クラス**: `BatchAction`またはそのサブクラスを継承する。

| メソッド | 概要 | 起動タイミング | 要否 |
|---|---|---|---|
| `void initialize(CommandLine command, ExecutionContext context)` | 初期化処理 | メイン処理開始前に1回 | 任意 |
| `DataReader<D> createReader(ExecutionContext context)` | リーダを作成する | 初回データ読み込み時に1回 | 必須 |
| `Result handle(D inputData, ExecutionContext context)` | メイン処理 | 1作業単位の入力毎 | 必須 |
| `void transactionSuccess(D inputData, ExecutionContext context)` | 正常終了時の処理 | handleメソッド正常終了時毎 | 任意 |
| `void transactionFailure(D inputData, ExecutionContext context)` | 異常終了時の処理 | handleメソッド異常終了時毎 | 任意 |
| `void error(Throwable error, ExecutionContext context)` | エラー発生時の処理 | メイン処理でエラー発生後に1回 | 任意 |
| `void terminate(Result result, ExecutionContext context)` | 終了処理 | メイン処理終了後に1回 | 任意 |

> **注意**: `transactionFailure`はメイン処理とは別のトランザクションで実行される。メイン処理でエラーが発生した場合、そのトランザクションはロールバックされるため。

> **注意**: **D**はレコードの型を表す総称型。DB入力バッチの場合、通常`SqlRow`となる。

> **注意**: `BatchActionBase`は`DbAccessSupport`を継承しているため、サブクラスでも`DbAccessSupport`の機能を用いてデータベースアクセスできる。

### ファイルを入力とするバッチを実装する場合

**クラス**: `FileBatchAction`を継承する。

DBバッチのメソッド（`createReader`、`handle`を除く）に加え、以下を実装する:

| メソッド | 概要 | 起動タイミング | 要否 |
|---|---|---|---|
| `String getDataFileName()` | 入力ファイル名を返却する | メイン処理開始前に1回 | 必須 |
| `String getFormatFileName()` | レコードフォーマット定義ファイルを返却する | メイン処理開始前に1回 | 必須 |
| `Result do+レコードタイプ名(DataRecord inputData, ExecutionContext ctx)` | レコードタイプごとの処理 | 1作業単位の入力毎 | 必須 |

> **注意**: `createReader`はスーパクラスにて実装済みのため実装不要。`handle`も不要（代わりに`do+レコードタイプ名`メソッドを実装する）。

<details>
<summary>keywords</summary>

BatchAction, FileBatchAction, BatchActionBase, DbAccessSupport, ExecutionContext, createReader, handle, transactionSuccess, transactionFailure, initialize, terminate, error, getDataFileName, getFormatFileName, DBバッチ実装, ファイルバッチ実装, SqlRow, DataRecord, DataReader

</details>

## 処理の流れ

DBを入力とするバッチの典型的な処理フロー:

1. `initialize()` — メイン処理開始前に1回呼ばれる
2. `createReader()` — 初回データ読み込み時に1回呼ばれる
3. データが存在する間ループ:
   - `handle()` — 入力データ1件毎に繰り返し呼ばれる
   - 正常終了時: `transactionSuccess()` — handleが正常終了した場合に呼ばれる
   - 例外発生時: `transactionFailure()` — handleで例外が発生した場合に呼ばれる
4. 本処理エラー終了時: `error()` — 1回だけ呼ばれる
5. `postProcess()` — メイン処理が全て終了した後に1回呼ばれる（エラー終了時でも呼ばれる）

> **注意**: ファイルを入力とする場合もシーケンス自体は同じ。`DatabaseRecordReader`の代わりに`FileRecordReader`を使用する相違のみ。

フレームワーク動作イメージ（擬似コード）:

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
  error()                   //-- 本処理がエラー終了した場合に、一度だけ呼ばれる。
} finally {
  postProcess()             //-- 本処理が全て終了した後、一度だけ呼ばれる(エラー終了時でも呼ばれる)。
}
```

<details>
<summary>keywords</summary>

処理シーケンス, DatabaseRecordReader, FileRecordReader, フレームワーク動作, バッチ処理フロー, transactionSuccess, transactionFailure, postProcess

</details>

## コマンドライン引数

Java起動時のコマンドライン引数の解釈:

| 種別 | 説明 | 取得方法 |
|---|---|---|
| オプション | `-キー名=値` 形式のkey-valueペア | `CommandLine#getParamMap()` |
| 引数 | オプション以外の引数。単一の値を持つ | `CommandLine#getArgs()` |

バッチ処理共通のコマンドラインオプション:

| キー名 | 設定値 | 説明 |
|---|---|---|
| `diConfig` | コンポーネント設定ファイルへのパス | バッチ処理はここで指定されたファイルの設定で動作する |
| `requestPath` | リクエストを特定するためのパス | 通常`"ss" + (機能ID) + "." + (アクションクラス名) + "/" + (リクエストID)` |
| `userId` | ユーザID | バッチ処理はここで指定されたユーザIDで実行される |

起動例:

```bash
java <中略> nablarch.fw.launcher.Main -diConfig=file:./config/batch-config.xml \
                                      -requestPath=ss11AC.B11AC011Action/RB11AC0110 \
                                      -userId=batch_user
```

<details>
<summary>keywords</summary>

CommandLine, diConfig, requestPath, userId, コマンドライン引数, バッチ起動オプション, getParamMap, getArgs, nablarch.fw.launcher.Main

</details>

## 初期化処理（initialize）

`initialize`メソッドを実装する（任意）。

メイン処理実行前にフレームワークから起動される。処理不要な場合はオーバーライド不要。

実装すべき処理の例:
- コマンドライン引数を処理する
- リソースの取得を行う
- 開始ログの出力を行う
- インスタンス変数の初期化が必要な場合

> **警告**: バッチアクションでインスタンス変数を使用する場合の制約:
> - インスタンス変数を使用するバッチアクションは**マルチスレッド実行できない**
> - インスタンス変数は、initializeメソッドで**明示的に初期化しなければならない**
>
> ただし、以下の条件を満たす場合はマルチスレッド実行が可能:
> - インスタンス変数の初期化（代入）がinitializeで行われ、それ以降は値が更新されないこと（読取専用）

<details>
<summary>keywords</summary>

initialize, マルチスレッド, インスタンス変数, バッチメソッド詳細, コマンドライン引数処理

</details>

## リーダ作成（createReader）

`createReader`メソッドを実装する（必須）。

バッチ処理の入力となるデータを読み込むリーダを返却する。通常、入力データはファイルかデータベースのいずれかとなる。

フレームワークはこのメソッドを呼び出してリーダを取得し、そのリーダを使用して入力データの読み込みを行う。

<details>
<summary>keywords</summary>

createReader, DataReader, 入力データ読み込み

</details>

## 1作業単位毎の処理（handle）

`handle`メソッドを実装する（必須）。

フレームワークは`createReader`メソッドで取得したリーダからデータを読み込み、1作業単位毎にバッチアクションの`handle`メソッドを起動する。`handle`メソッドでは1作業単位毎のバッチ処理を行う。

戻り値には`nablarch.fw.Result`インタフェース実装クラスのインスタンスを返却する必要がある。通常は`nablarch.fw.Result.Success`（正常終了）を返却する。

<details>
<summary>keywords</summary>

handle, nablarch.fw.Result, nablarch.fw.Result.Success, 作業単位処理

</details>

## エラー発生時の処理

### エラーが発生した作業単位に対するエラー処理

`transactionFailure`メソッドを実装する（任意）。

`handle`メソッドでエラーが発生する度に呼び出される。引数にはエラー発生時に処理していたデータが渡される。

> **注意**: このメソッドは`handle`メソッドとは別のトランザクションで実行される。

実装すべき処理の例:
- エラーが発生したレコードのステータスを異常終了に更新する
- 専用のエラーファイルにエラーが発生したレコードを出力する（エラーリスト作成）

### エラーが発生したリクエストに対するエラー処理

`error`メソッドを実装する（任意）。

メイン処理がエラー終了した場合に1回だけ呼び出される（マルチスレッド実行時でも1回のみ）。通常、引数のThrowableには`java.util.concurrent.ExecutionException`が渡される。メイン処理で発生した例外またはエラーは`ExecutionException#getCause()`で取得できる。

<details>
<summary>keywords</summary>

transactionFailure, error, ExecutionException, エラー処理, エラーが発生した作業単位, エラーが発生したリクエスト

</details>

## 終了処理（terminate）

`terminate`メソッドを実装する（任意）。

リーダから全てのデータを読み取った後、フレームワークから起動される。全データ処理後に行うべき終了処理を実装する。

実装すべき処理の例:
- リソースの解放を行う
- 処理件数をログ出力する

<details>
<summary>keywords</summary>

terminate, 終了処理, リソース解放

</details>
