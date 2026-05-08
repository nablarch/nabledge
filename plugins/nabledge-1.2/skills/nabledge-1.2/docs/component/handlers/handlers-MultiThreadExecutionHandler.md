## マルチスレッド実行制御ハンドラ

**クラス名:** `nablarch.fw.MultiThreadExecutionHandler`

-----

-----

### 概要

本ハンドラでは、サブスレッドを作成し、ハンドラキュー上の後続ハンドラの処理を各サブスレッド上で並行実行することができる。
このハンドラでの処理結果は、各サブスレッドでの実行結果を集約したオブジェクト([Result.MultiStatus](../../javadoc/nablarch/fw/Result.MultiStatus.html))となる。

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| マルチスレッド実行制御ハンドラ | nablarch.fw.handler.MultiThreadExecutionHandler | Object | MultiStatus | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 実行コンテキスト上にデータリーダが存在しない場合は、コールバックを行う。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 | 1. 処理開始前 / 2. データリーダ作成 / 3. スレッド異常終了時 / 4. 処理完了時 |

**コールバック**

下記の抽象クラス／インターフェースを後続のハンドラで継承／実装することにより、本ハンドラ実行中にコールバックを受けることができる。

| 抽象クラス／インターフェース | メソッド | イベント |
|---|---|---|
| [BatchActionBase](../../javadoc/nablarch/fw/action/BatchActionBase.html) | initialize | マルチスレッド実行開始前一度だけ呼ばれる。 |
|  | error | サブスレッドのいずれかが異常終了(未捕捉の実行時例外またはエラーを送出) した場合に一度だけ呼ばれる。 |
|  | terminate | サブスレッド上の処理完了後に一度だけ呼ばれる。 (異常終了時では、error後に呼ばれる。) |
| [DataReaderFactory](../../javadoc/nablarch/fw/DataReaderFactory.html) | createReader | 実行コンテキスト上にデータリーダが設定されていなかった場合は、 BatchActionBase#initialize() の呼び出し直後に一度だけ呼ばれる。 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [バッチ処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-BatchAction.md) | バッチアクションでは、本ハンドラのコールバックを利用することで、 バッチの初期処理及び終了処理を実装している。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (並行実行スレッド数をスレッドコンテキストに登録)**

このハンドラに設定されている **並行実行スレッド数** をスレッドコンテキストの属性値として登録する。
この値は後続処理において、シングルスレッド環境でしか利用できない機能の実行可否を判定する際に参照する。

**2. (コールバック呼び出し)**

後続ハンドラの内、 **BatchActionBase** を継承しているものについて、下記のコールバックを呼び出す。:

```
BatchActionBase#initialize(Object data, ExecutionContext context): Object
```

**3. (データリーダを取得)**

サブスレッドで使用するデータリーダを実行コンテキスト([ExecutionContext](../../javadoc/nablarch/fw/ExecutionContext.html))から取得する。
データリーダが実行コンテキストに設定されていなかった場合は、データリーダファクトリを使用して
データリーダを作成する。

**3a. (データリーダ未設定エラー)**

実行コンテキスト上にデータリーダ及びデータリーダファクトリのいずれも設定されていなかった場合、
実行時例外([IllegalStateException](http://docs.oracle.com/javase/1.5.0/docs/api/java/lang/IllegalStateException.html))を送出する。

**4. (実行コンテキストのコピー)**

各サブスレッドで使用する実行コンテキストを、現在の実行コンテキストをもとに作成する。
この際、実行コンテキストの各属性は以下のように複製される。

| 属性名 | データ型 | コピーされる内容 |
|---|---|---|
| ハンドラキュー | List<[Handler](../../javadoc/nablarch/fw/Handler.html) > | 現在のListのシャローコピーを作成する。 従って、各ハンドラはスレッドセーフに作成される必要がある。 |
| リクエストコンテキスト | Map<String, Object> | 新規のMapを作成する。 メインスレッド側の変数はサブスレッドに引き継がれない。 |
| セッションコンテキスト | Map<String, Object> | 現在のセッションスコープのMapをそのまま設定する。 各サブスレッドは、単一のMapを共有する。 |
| データリーダ | [DataReader](../../javadoc/nablarch/fw/DataReader.html) | 現在のデータリーダをそのまま設定する。 |
| データリーダファクトリ | [DataReaderFactory](../../javadoc/nablarch/fw/DataReaderFactory.html) | 現在のファクトリをそのまま設定する。 |

**5. (サブスレッドの作成と実行)**

サブスレッドを作成し実行する。
各サブスレッドでは、 **4.** で作成した実行コンテキスト中のハンドラキューに処理を委譲し、その結果をサブスレッドの実行結果として
メインスレッドに返す。
メインスレッドは全てのサブスレッドが終了するまで待機する。

**[復路処理]**

**6. (コールバック呼び出し)**

後続ハンドラの内、 **BatchActionBase** を継承しているものについて、下記のコールバックを呼び出す。:

```
BatchActionBase#terminate(Object data, ExecutionContext context): Object
```

**7. (正常終了)**

各サブスレッドの処理結果を [Result.MultiStatus](../../javadoc/nablarch/fw/Result.MultiStatus.html) に追加してリターンする。

**[例外処理]**

**5a. (サブスレッドが異常終了)**

サブスレッド上のいずれかが異常終了(=未捕捉の実行時例外またはエラーを送出)した場合、
後続ハンドラの内、 **BatchActionBase** を継承しているものについて、下記のコールバックを呼び出す。:

```
BatchActionBase#error(Throwable e, ExecutionContext context): void
```

次に、現在実行中の各サブスレッド対して割り込み要求をおこなった上で、
全サブスレッドが完了するか、 **スレッド停止タイムアウト** を経過するまで待機する。
最後に **6.** のコールバックを呼び出した上で、起因例外を再送出する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| 並行実行スレッド数 | concurrentNumber | int | デフォルト値は1 |
| スレッド停止のタイムアウト秒数 | terminationTimeout | int | デフォルト値は600(秒) |

**基本設定**

以下は標準的なスレッドコンテキストの設定例である。
並行実行スレッド数は、運用時に値を変更する可能性が高い為、
埋め込みパラメータとして定義することを推奨する。

```xml
<!-- スレッド実行ハンドラ -->
<component class = "nablarch.fw.handler.MultiThreadExecutionHandler">
  <property name="concurrentNumber" value="${threadCount}" />
</component>
```
