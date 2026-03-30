# 共通起動ランチャ

## 概要

**クラス名**: `nablarch.fw.launcher.Main`

フレームワークの起動シーケンスの起点となるクラス。javaコマンドから直接起動し、リポジトリの初期化とハンドラキューの実行を行う。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [StatusCodeConvertHandler](handlers-StatusCodeConvertHandler.md) | ハンドラキューの先頭に配置する。[Main](handlers-Main.md) では、このハンドラが返した整数値をプロセス終了コードとして使用する。終了コードの体系はプロジェクト毎に異なる可能性があるので必要に応じて差し替えられるよう、本クラスから責務を分離している。 |
| [GlobalErrorHandler](handlers-GlobalErrorHandler.md) | 後続のハンドラで発生した全ての実行時例外およびエラーを捕捉する。[Main](handlers-Main.md) では、このハンドラが [StatusCodeConvertHandler](handlers-StatusCodeConvertHandler.md) の後続に配置されていることを前提とする。 |
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 起動引数 **-requestPath** および **-userId** の値をもとに、スレッドコンテキスト変数の **リクエストID** および **ユーザID** をそれぞれ設定する。 |
| [RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) | [../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) などでは、起動引数 **-requestPath** の値をもとに業務アクションクラスへのディスパッチを行う。 |

<details>
<summary>keywords</summary>

Main, nablarch.fw.launcher.Main, StatusCodeConvertHandler, GlobalErrorHandler, ThreadContextHandler, RequestPathJavaPackageMapping, 共通起動ランチャ, ハンドラキュー実行, リポジトリ初期化

</details>

## ハンドラ処理フロー

> **注意**: 以下で **異常終了する** と表現されている部分では、障害ログを出力してプロセスを終了させる。

**[往路処理]**

1. **(起動引数の解析)** main関数に渡された起動引数をパースし、コマンドラインオブジェクト(`CommandLine`)に設定する。
2. **(リポジトリの初期化)** **-diConfig** パラメータに指定されたリポジトリ定義ファイルに沿って初期化を行う。正常終了後、以下のオブジェクトIDに登録されたオブジェクトを取得する。

| 論理名 | オブジェクトID | オブジェクトの型 |
|---|---|---|
| ハンドラキュー | handlerQueue | List<Handler<?, ?>> |
| データリーダ | dataReader | DataReader |
| データリーダファクトリ | dataReaderFactory | DataReaderFactory |

3. **(実行コンテキストの構築)** `ExecutionContext`を生成し、(1) ハンドラキューを設定、(2) データリーダおよびデータリーダファクトリを設定、(3) セッションスコープ変数に起動パラメータのMapを設定する。
4. **(ハンドラキューの実行)** ハンドラキュー上の最初のハンドラに、コマンドラインオブジェクトと実行コンテキストを引数として処理を委譲する。

**[復路処理]**

5. **(正常終了)** 後続ハンドラが正常終了した場合、処理結果オブジェクトのステータスコードを終了コードとしてプロセスを終了させる。ステータスコードが127を超えていた場合の終了コードは127とする。

**[例外処理]**

- **1a. (必須パラメータ未指定エラー)** **-diConfig**、**-requestPath**、**-userId** のいずれかが指定されていなかった場合は異常終了する (終了コード=127)。
- **2a. (リポジトリ初期化エラー)** リポジトリ初期化時にエラーが発生した場合、もしくはハンドラキューが取得できなかった場合は異常終了する (終了コード=127)。
- **5a. (異常終了)** 後続ハンドラの実行中に実行時例外・エラーが送出された場合、捕捉して異常終了させる (ステータスコード=127)。

> **注意**: 本ハンドラはグローバルエラーハンドラの手前に配置されるため、基本的にここで例外を捕捉することはない。

<details>
<summary>keywords</summary>

CommandLine, ExecutionContext, DataReader, DataReaderFactory, handlerQueue, dataReader, dataReaderFactory, ハンドラ処理フロー, 終了コード, 異常終了, 往路処理, 復路処理

</details>

## コマンドライン起動引数の扱い

起動引数の処理について、以下の実行例をもとに解説する。

```bash
java \
    -server \
    -Xmx128m \
    -DcommitInterval=100 \
    -DmaxExecutionCount=100000 \
nablarch.fw.launcher.Main \
    -diConfig    file:./batch-config.xml \
    -requestPath admin.DataUnloadBatchAction/BC0012 \
    -userId      testUser \
    -namedParam  value \
    value1 value2 value3
```

Javaコマンドに指定する引数は以下の3つに分類できる。

**1. JavaVMパラメータ**

上記例中の **-server** や **-Xmx** はJavaVM自体の挙動に関するパラメータである。本フレームワークでこれらの値を直接使用することはない。

**2. Javaシステムプロパティ**

DIリポジトリ設定ファイル中の埋め込みパラメータの値は、Javaシステムプロパティを用いて指定することができる。上記の例では、**-DcommitInterval=100** と **-DmaxExecutionCount=100000** がこれに相当し、それぞれ埋め込みパラメータ **${commitInterval}** および **${maxExecutionCount}** の値を指定している。

**3. クラス引数**

本クラスに対する引数は、下記の形式に従ってパースし、コマンドラインオブジェクト(`nablarch.fw.launcher.CommandLine`)の属性値として設定する。

**a) 名前付きパラメータ**

書式: `-` + (パラメータ名) + ` ` + (パラメータ値)

アクセス方法: `Commandline#getParamMap() : Map<String, String>`

上記例で取得できる値:
```javascript
{ diConfig: "file:./batch-config.xml", requestPath: "nablarch.fw.sample.SampleBatchAction", userId: "testUser", namedParam: "value" }
```

**b) 無名パラメータ**

書式: (パラメータ値)

アクセス方法: `Commandline#getArgs() : List<String>`

上記例で取得できる値:
```javascript
[ "value1", "value2", "value3" ]
```

**必須パラメータ**

フレームワークの動作に必要な以下の3つのパラメータは必ず指定する必要がある。

| パラメータ | 内容 |
|---|---|
| **-diConfig** | リポジトリの設定ファイルのパスを指定する。 |
| **-requestPath** | `(実行対象アクションハンドラクラス) + '/' + (リクエストID値)` の形式で指定する。[ThreadContextHandler](handlers-ThreadContextHandler.md) および [RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) で使用される。 |
| **-userId** | プロセスの実行権限ユーザIDを設定する。この値はセッションコンテキスト変数に格納される。また、後続の [ThreadContextHandler](handlers-ThreadContextHandler.md) によってスレッドコンテキストに保持されることで、ハンドラ以外の任意のコンポーネントからアクセスできるようになる。(権限制御と関係なく、何らかの識別文字列を設定する必要がある。) |

> **注意**: 上記必須パラメータのいずれかが欠けていた場合は即座に異常終了する (終了コード=127)。

<details>
<summary>keywords</summary>

nablarch.fw.launcher.CommandLine, Commandline, getParamMap, getArgs, -diConfig, -requestPath, -userId, 名前付きパラメータ, 無名パラメータ, 必須パラメータ, 起動引数, Javaシステムプロパティ, JavaVMパラメータ, -DcommitInterval, commitInterval, ${commitInterval}, 埋め込みパラメータ

</details>

## 設定項目・拡張ポイント

本クラスはJavaコマンドラインから直接実行するため、固有の設定項目は存在しない。

<details>
<summary>keywords</summary>

設定項目, 拡張ポイント, 設定なし, Javaコマンドライン起動

</details>
