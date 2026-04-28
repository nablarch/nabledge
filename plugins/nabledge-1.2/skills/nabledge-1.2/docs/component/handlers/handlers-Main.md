## 共通起動ランチャ

**クラス名:** `nablarch.fw.launcher.Main`

-----

-----

### 概要

[共通起動ランチャ](../../component/handlers/handlers-Main.md) は本フレームワークの起動シーケンスの起点となるクラスであり、javaコマンドから直接起動することで、
リポジトリの初期化を行い、そこに定義されたハンドラキューを実行させることができる。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| 共通起動ランチャ | nablarch.fw.handler.Main | CommandLine | Integer | Javaコマンドから直接実行することで、DIリポジトリを初期化し、ハンドラキューを構築・実行する。 | 後続ハンドラの処理結果(整数値)を終了コードに指定し、プロセスを停止する。 | Fatalログを出力しプロセスを異常終了させる。 |
| ステータスコード→プロセス終了コード変換 | nablarch.fw.handler.StatusCodeConvertHandler | CommandLine | Integer | - | 後続ハンドラの処理結果をもとに、プロセス終了コード(整数値)を決定して返す。 | - |
| グローバルエラーハンドラ | nablarch.fw.handler.GlobalErrorHandler | Object | Result | - | - | 全ての実行時例外・エラーを捕捉し、ログ出力を行う |
| スレッドコンテキスト変数設定ハンドラ(メインスレッド) | nablarch.common.handler.ThreadContextHandler_main | Object | Object | 起動引数の内容からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。 | - | - |
| リクエストディスパッチハンドラ | nablarch.fw.handler.RequestPathJavaPackageMapping | Request | Object | 引数として渡されたリクエストオブジェクトのリクエストパスから、処理対象の業務アクションを決定しハンドラキューに追加する。 | - | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ステータスコード→プロセス終了コード変換ハンドラ](../../component/handlers/handlers-StatusCodeConvertHandler.md) | ハンドラキューの先頭に配置する。 [共通起動ランチャ](../../component/handlers/handlers-Main.md) では、このハンドラが返した整数値をプロセス終了コードとして使用する。 終了コードの体系はプロジェクト毎に異なる可能性があるので 必要に応じて差し替えられるよう、本クラスから責務を分離している。 |
| [グローバルエラーハンドラ](../../component/handlers/handlers-GlobalErrorHandler.md) | 後続のハンドラで発生した全ての実行時例外およびエラーはこのハンドラによって捕捉される。 [共通起動ランチャ](../../component/handlers/handlers-Main.md) では、このハンドラが [ステータスコード→プロセス終了コード変換ハンドラ](../../component/handlers/handlers-StatusCodeConvertHandler.md) の後続に 配置されていることを前提としている。 |
| [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) | [共通起動ランチャ](../../component/handlers/handlers-Main.md) の起動引数 **-requestPath** および、 **-userId** の値をもとに、 スレッドコンテキスト変数の **リクエストID** および、 **ユーザID** の値をそれぞれ設定する。 |
| [リクエストディスパッチハンドラ](../../component/handlers/handlers-RequestPathJavaPackageMapping.md) | [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) などでは、 [共通起動ランチャ](../../component/handlers/handlers-Main.md) の起動引数 **-requestPath** の値をもとに業務アクションクラスのディスパッチを 行う。 |

### ハンドラ処理フロー

本ハンドラの処理の流れは以下のとおりである。

> **Note:**
> 以下の説明において **異常終了する** と表現されている部分では、障害ログを出力してプロセスを終了させる。

**[往路処理]**

**1. (起動引数の解析)**

main関数に渡された起動引数をパースし、その結果をコマンドラインオブジェクト([CommandLine](../../javadoc/nablarch/fw/launcher/CommandLine.html))に設定する。
起動引数の扱いについては、 [後述](../../component/handlers/handlers-Main.md#parsing-commandline) する。

**2. (リポジトリの初期化)**

**-diConfig** パラメータに指定されたリポジトリ定義ファイルの内容に沿って初期化を行なう。
初期化が正常終了した場合は、下記のオブジェクトIDに登録されたオブジェクトを取得する。

| 論理名 | オブジェクトID | オブジェクトの型 |
|---|---|---|
| ハンドラキュー | **handlerQueue** | **List<Handler<?, ?>>** |
| データリーダ | **dataReader** | [DataReader](../../javadoc/nablarch/fw/DataReader.html) |
| データリーダファクトリ | **dataReaderFactory** | [DataReaderFactory](../../javadoc/nablarch/fw/DataReaderFactory.html) |

**3. (実行コンテキストの構築)**

実行コンテキスト([ExecutionContext](../../javadoc/nablarch/fw/ExecutionContext.html))を生成し、以下の処理を行う。

1. ハンドラキューを設定
2. データリーダおよびデータリーダファクトリを設定
3. セッションスコープ変数に、起動パラメータのMapを設定する。

**4. (ハンドラキューの実行)**

ハンドラキュー上の最初のハンドラに対して、コマンドラインオブジェクトと実行コンテキストを引数として処理を委譲する。
これにより、ハンドラキュー上の各ハンドラの処理が順次実行され、その処理結果オブジェクトが返される。

**[復路処理]**

**5. (正常終了)**

後続のハンドラが正常終了した場合、処理結果オブジェクトのステータスコードを終了コードとしてプロセスを終了させる。
ただし、ステータスコードが127を越えていた場合の終了コードは127とする。

**[例外処理]**

**1a. (必須パラメータ未指定エラー)**

以下の必須パラメータのうちいずれかが指定されていなかった場合は異常終了する。(終了コード127)

**-diConfig** 、 **-requestPath** 、 **-userId**

**2a. (リポジトリ初期化エラー)**

リポジトリ初期化時にエラーが発生した場合、もしくはハンドラキューが取得できな買った場合は異常終了する。
(終了コード=127)

**5a. (異常終了)**

後続ハンドラの実行中に実行時例外およびエラーが送出された場合、
それらを捕捉し、異常終了させる。(ステータスコード=127)

> **Note:**
> 本ハンドラはグローバルエラーハンドラの手前に配置されるため、基本的にここで例外を捕捉することは無い

-----

### コマンドライン起動引数の扱い

**起動引数の処理**

本クラスにおける起動引数の扱いについて、以下の実行例をもとに解説する。

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

Javaコマンドに指定する引数は以下の3つに分類することができる。
それぞれについて、本クラスでの取扱いについて述べる。

1. Java VMパラメータ
2. Javaシステムプロパティ
3. クラス引数

1. JavaVMパラメータ

上記例中の **-server** や **-Xmx** はJavaVM自体の挙動に関するパラメータである。
本フレームワークでこれらの値を直接使用することは無い。

1. Javaシステムプロパティ

DIリポジトリ設定ファイル中の埋め込みパラメータの値は、Javaシステムプロパティを用いて指定することができる。
上記の例では、 **-DcommitInterval=100** と **-DmaxExecutionCount=100000** がこれに相当し、それぞれ
埋め込みパラメータ **${commitInterval}** および **${maxExecutionCount}** の値を指定している。

1. クラス引数

本クラスに対する引数は、下記の形式に従ってパースし、
後述するコマンドラインオブジェクト(nablarch.fw.launcher.Commandline)の属性値として設定する。

1. 名前付きパラメータ

**書式**:

```
'-' + (パラメータ名) + '　' + (パラメータ値)
```

**アクセス方法**:

```
Commandline#getParamMap() : Map<String, String>
```

**上記例で取得できる値**

```javascript
{ diConfig   : "file:./batch-config.xml",
  requestPath: "nablarch.fw.sample.SampleBatchAction",
  userId     : "testUser",
  namedParam : "value" }
```

1. 無名パラメータ

**書式**:

```
(パラメータ値)
```

**アクセス方法**:

```
Commandline#getArgs() : List<String>
```

**上記例で取得できる値**

```javascript
[ "value1", "value2", "value3" ]
```

**必須パラメータ**

フレームワークの動作に必要となる以下の3つのパラメータについては、起動パラメータとして必ず指定する必要がある。

| パラメータ | 内容 |
|---|---|
| **-diConfig** | リポジトリの設定ファイルのパスを指定する。 |
| **-requestPath** | 以下の書式で定義される文字列を設定する。:  ``` (実行対象アクションハンドラクラス) + '/' + (リクエストID値) ```  この値はコマンドラインオブジェクトに設定され、以下のハンドラで使用される。  * [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) * [リクエストディスパッチハンドラ](../../component/handlers/handlers-RequestPathJavaPackageMapping.md) |
| **-userId** | プロセスの実行権限ユーザIDを設定する。 この値はセッションコンテキスト変数に格納される。 また、後続の [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) によってスレッドコンテキストに保持されることで、 ハンドラ以外の任意のコンポーネントからアクセスできるようになる。 (権限制御と関係なく、何らかの識別文字列を設定する必要がある。) |

上記の必須パラメータのうちいずれかが欠けていた場合は、即座に異常終了する。(終了コード = 127)

### 設定項目・拡張ポイント

本クラスはJavaコマンドラインから直接実行するため、固有の設定項目は存在しない。
