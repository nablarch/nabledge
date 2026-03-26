# 共通起動ランチャ

## 概要

**クラス名**: `nablarch.fw.launcher.Main`

javaコマンドから直接起動することで、リポジトリの初期化を行い、定義されたハンドラキューを実行する。本フレームワークの起動シーケンスの起点となるクラス。

**関連ハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [StatusCodeConvertHandler](handlers-StatusCodeConvertHandler.md) | ハンドラキューの先頭に配置する。このハンドラが返した整数値をプロセス終了コードとして使用する。終了コードの体系はプロジェクト毎に異なる可能性があるため、Mainから責務を分離している。 |
| [GlobalErrorHandler](handlers-GlobalErrorHandler.md) | 後続ハンドラで発生した全ての実行時例外・エラーを捕捉する。Mainはこのハンドラが [StatusCodeConvertHandler](handlers-StatusCodeConvertHandler.md) の後続に配置されていることを前提とする。 |
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 起動引数 **-requestPath** および **-userId** の値をもとに、スレッドコンテキスト変数のリクエストIDとユーザIDを設定する。 |
| [RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) | [../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) などで、起動引数 **-requestPath** の値をもとに業務アクションクラスへのディスパッチを行う。 |

<details>
<summary>keywords</summary>

Main, nablarch.fw.launcher.Main, StatusCodeConvertHandler, GlobalErrorHandler, ThreadContextHandler, RequestPathJavaPackageMapping, 共通起動ランチャ, ハンドラキュー構成, 起動シーケンス

</details>

## ハンドラ処理フロー

> **注意**: 以下の説明において **異常終了する** と表現されている部分では、障害ログを出力してプロセスを終了させる。

**[往路処理]**

1. **(起動引数の解析)** main関数に渡された起動引数をパースし、コマンドラインオブジェクト(`CommandLine`)に設定する。
2. **(リポジトリの初期化)** **-diConfig** パラメータのリポジトリ定義ファイルで初期化し、以下のオブジェクトを取得する。

| 論理名 | オブジェクトID | 型 |
|---|---|---|
| ハンドラキュー | **handlerQueue** | `List<Handler<?, ?>>` |
| データリーダ | **dataReader** | `DataReader` |
| データリーダファクトリ | **dataReaderFactory** | `DataReaderFactory` |

3. **(実行コンテキストの構築)** `ExecutionContext`を生成し、ハンドラキュー・データリーダ/ファクトリを設定、セッションスコープ変数に起動パラメータのMapを設定する。
4. **(ハンドラキューの実行)** ハンドラキューの最初のハンドラにコマンドラインオブジェクトと実行コンテキストを引数として処理を委譲する。

**[復路処理]**

5. **(正常終了)** 処理結果オブジェクトのステータスコードを終了コードとしてプロセスを終了する。ステータスコードが127を超えた場合の終了コードは127とする。

**[例外処理]**

- **(1a. 必須パラメータ未指定エラー)** **-diConfig**、**-requestPath**、**-userId** のいずれかが未指定の場合、異常終了する（終了コード127）。
- **(2a. リポジトリ初期化エラー)** リポジトリ初期化時のエラー、またはハンドラキューが取得できない場合、異常終了する（終了コード127）。
- **(5a. 異常終了)** 後続ハンドラの実行中に実行時例外・エラーが送出された場合、捕捉して異常終了する（ステータスコード127）。

> **注意**: 本ハンドラはグローバルエラーハンドラの手前に配置されるため、基本的にここで例外を捕捉することは無い。

<details>
<summary>keywords</summary>

CommandLine, ExecutionContext, DataReader, DataReaderFactory, handlerQueue, dataReader, dataReaderFactory, 起動引数解析, リポジトリ初期化, ハンドラキュー実行, 異常終了, 終了コード127

</details>

## コマンドライン起動引数の扱い

起動引数は以下の3種に分類される。以下の実行例をもとに解説する。

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

1. **JavaVMパラメータ**（`-server`, `-Xmx128m` など）: フレームワークでは直接使用しない。
2. **Javaシステムプロパティ**（`-Dkey=value`）: DIリポジトリ設定ファイル中の埋め込みパラメータ（`${key}`）の値として使用される。上記例では `-DcommitInterval=100`、`-DmaxExecutionCount=100000` が該当し、それぞれ `${commitInterval}`、`${maxExecutionCount}` の値を指定している。
3. **クラス引数**: 以下の形式でパースし、`nablarch.fw.launcher.CommandLine` の属性値として設定する。

**a) 名前付きパラメータ**

書式: `-パラメータ名 パラメータ値`

アクセス方法: `Commandline#getParamMap() : Map<String, String>`

上記例で取得できる値:

```javascript
{ diConfig   : "file:./batch-config.xml",
  requestPath: "nablarch.fw.sample.SampleBatchAction",
  userId     : "testUser",
  namedParam : "value" }
```

**b) 無名パラメータ**

書式: `パラメータ値`（`-` プレフィックスなし）

アクセス方法: `Commandline#getArgs() : List<String>`

上記例で取得できる値:

```javascript
[ "value1", "value2", "value3" ]
```

**必須パラメータ**

以下3パラメータは必ず指定する必要がある。いずれかが欠けた場合は即座に異常終了する（終了コード127）。

| パラメータ | 内容 |
|---|---|
| **-diConfig** | リポジトリの設定ファイルのパスを指定する。 |
| **-requestPath** | `(実行対象アクションハンドラクラス) + '/' + (リクエストID値)` の形式で指定する。[ThreadContextHandler](handlers-ThreadContextHandler.md) と [RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) で使用される。 |
| **-userId** | プロセスの実行権限ユーザIDを設定する。セッションコンテキスト変数に格納され、後続の [ThreadContextHandler](handlers-ThreadContextHandler.md) によってスレッドコンテキストに保持される。権限制御と関係なく、何らかの識別文字列を設定する必要がある。 |

<details>
<summary>keywords</summary>

CommandLine, nablarch.fw.launcher.CommandLine, -diConfig, -requestPath, -userId, getParamMap, getArgs, 名前付きパラメータ, 無名パラメータ, 必須パラメータ

</details>

## 設定項目・拡張ポイント

本クラスはJavaコマンドラインから直接実行するため、固有の設定項目は存在しない。

<details>
<summary>keywords</summary>

設定項目, 拡張ポイント, 共通起動ランチャ設定, コマンドライン起動

</details>
