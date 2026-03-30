# 共通起動ランチャ

## 概要

**クラス**: `nablarch.fw.launcher.Main`

フレームワーク起動シーケンスの起点となるクラス。javaコマンドから直接起動してリポジトリを初期化し、定義されたハンドラキューを実行する。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [StatusCodeConvertHandler](handlers-StatusCodeConvertHandler.md) | ハンドラキューの先頭に配置。[Main](handlers-Main.md) はこのハンドラが返した整数値をプロセス終了コードとして使用する。終了コード体系はプロジェクトごとに異なるため、[Main](handlers-Main.md) から責務を分離している。 |
| [GlobalErrorHandler](handlers-GlobalErrorHandler.md) | 後続ハンドラで発生した全実行時例外およびエラーを捕捉する。[Main](handlers-Main.md) はこのハンドラが [StatusCodeConvertHandler](handlers-StatusCodeConvertHandler.md) の後続に配置されることを前提とする。 |
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | [Main](handlers-Main.md) の起動引数 **-requestPath** および **-userId** の値をもとに、スレッドコンテキスト変数の **リクエストID** および **ユーザID** をそれぞれ設定する。 |
| [RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) | [../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) などで、起動引数 **-requestPath** の値をもとに業務アクションクラスへのディスパッチを行う。 |

<details>
<summary>keywords</summary>

nablarch.fw.launcher.Main, Main, StatusCodeConvertHandler, GlobalErrorHandler, ThreadContextHandler, RequestPathJavaPackageMapping, 起動ランチャ, ハンドラキュー実行, リポジトリ初期化, フレームワーク起動

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(起動引数の解析)** main関数に渡された起動引数をパースし、CommandLineオブジェクトに設定する。
2. **(リポジトリの初期化)** `-diConfig` パラメータに指定されたリポジトリ定義ファイルの内容に沿って初期化する。正常終了後、以下のオブジェクトIDに登録されたオブジェクトを取得する:

| 論理名 | オブジェクトID | 型 |
|---|---|---|
| ハンドラキュー | handlerQueue | List\<Handler\<?, ?\>\> |
| データリーダ | dataReader | DataReader |
| データリーダファクトリ | dataReaderFactory | DataReaderFactory |

3. **(実行コンテキストの構築)** ExecutionContextを生成し、(1)ハンドラキューを設定、(2)データリーダおよびデータリーダファクトリを設定、(3)起動パラメータのMapをセッションスコープ変数に設定する。
4. **(ハンドラキューの実行)** ハンドラキューの最初のハンドラにCommandLineオブジェクトと実行コンテキストを渡して処理を委譲する。

**[復路処理]**

5. **(正常終了)** 処理結果オブジェクトのステータスコードを終了コードとしてプロセスを終了する。ステータスコードが127を超えた場合の終了コードは127とする。

**[例外処理]**

> **注意**: 異常終了する場合は、障害ログを出力してプロセスを終了させる。

- **1a. (必須パラメータ未指定エラー)** 必須パラメータ（`-diConfig`、`-requestPath`、`-userId`）のいずれかが指定されていない場合は異常終了する（終了コード127）。
- **2a. (リポジトリ初期化エラー)** リポジトリ初期化時にエラーが発生した場合、またはハンドラキューが取得できなかった場合は異常終了する（終了コード127）。
- **5a. (異常終了)** 後続ハンドラの実行中に実行時例外またはエラーが送出された場合、捕捉して異常終了させる（ステータスコード127）。

> **注意**: 本ハンドラはグローバルエラーハンドラの手前に配置されるため、基本的に5aで例外を捕捉することはない。

<details>
<summary>keywords</summary>

CommandLine, ExecutionContext, DataReader, DataReaderFactory, handlerQueue, dataReader, dataReaderFactory, ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, 終了コード, 異常終了

</details>

## コマンドライン起動引数の扱い

以下の実行例をもとに、起動引数の扱いを解説する。

```bash
java                                                 \
    -server                                          \
    -Xmx128m                                         \
    -DcommitInterval=100                             \
    -DmaxExecutionCount=100000                       \
nablarch.fw.launcher.Main                            \
    -diConfig    file:./batch-config.xml             \
    -requestPath admin.DataUnloadBatchAction/BC0012  \
    -userId      testUser                            \
    -namedParam  value                               \
    value1 value2 value3
```

Javaコマンドに指定する引数は以下の3つに分類できる。

**1. JavaVMパラメータ**

`-server` や `-Xmx` はJavaVM自体の挙動に関するパラメータである。本フレームワークでこれらの値を直接使用することはない。

**2. Javaシステムプロパティ**

DIリポジトリ設定ファイルの埋め込みパラメータ（`${key}`）の値として使用できる（例: `-DcommitInterval=100` → `${commitInterval}`）。

**3. クラス引数**

`nablarch.fw.launcher.Commandline` の属性値としてパースされる。

**a) 名前付きパラメータ**

- 書式: `-` + (パラメータ名) + ` ` + (パラメータ値)
- アクセス: `Commandline#getParamMap() : Map<String, String>`
- 上記例で取得できる値:

```javascript
{ diConfig   : "file:./batch-config.xml",
  requestPath: "nablarch.fw.sample.SampleBatchAction",
  userId     : "testUser",
  namedParam : "value" }
```

**b) 無名パラメータ**

- 書式: (パラメータ値)
- アクセス: `Commandline#getArgs() : List<String>`
- 上記例で取得できる値:

```javascript
[ "value1", "value2", "value3" ]
```

**必須パラメータ**

| パラメータ | 内容 |
|---|---|
| `-diConfig` | リポジトリの設定ファイルのパスを指定する。 |
| `-requestPath` | `(実行対象アクションハンドラクラス)/(リクエストID値)` 形式の文字列を設定する。[ThreadContextHandler](handlers-ThreadContextHandler.md) および [RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) で使用される。 |
| `-userId` | プロセスの実行権限ユーザIDを設定する。セッションコンテキスト変数に格納され、後続の [ThreadContextHandler](handlers-ThreadContextHandler.md) によりスレッドコンテキストに保持されることで任意のコンポーネントからアクセス可能になる。権限制御と関係なく、何らかの識別文字列の設定が必要。 |

必須パラメータのいずれかが欠けていた場合は即座に異常終了する（終了コード127）。

<details>
<summary>keywords</summary>

nablarch.fw.launcher.Commandline, getParamMap, getArgs, -diConfig, -requestPath, -userId, コマンドライン起動引数, 名前付きパラメータ, 無名パラメータ, 必須パラメータ

</details>

## 設定項目・拡張ポイント

本クラスはJavaコマンドラインから直接実行するため、固有の設定項目は存在しない。

<details>
<summary>keywords</summary>

設定項目, 拡張ポイント, 固有設定なし, Javaコマンドライン直接実行

</details>
