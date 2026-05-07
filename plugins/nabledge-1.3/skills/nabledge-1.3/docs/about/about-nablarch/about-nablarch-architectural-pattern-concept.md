## NAF基本アーキテクチャ

NAFは、画面オンライン処理、バッチ処理、メッセージング処理 といった
基幹システムで必要とされる広範な実行形態をサポートしつつも、
簡潔かつ単一の制御モデルに従って動作するという特徴を備える。

この節では、全ての処理において共通となるNAFアプリケーションの動作モデルについて解説する。

-----

-----

-----

-----

-----

-----

### NAFのアプリケーション動作モデル

NAFにおけるアプリケーションの動作モデルは極めて単純である。

まず、アプリケーションに対して何らかの依頼がなされる。この依頼を **リクエスト** と呼ぶ。
リクエストは依頼したい **「処理」** と **「データ」** から構成され、NAFにおける処理の最小単位となる。

例えば、画面オンライン処理では、ブラウザが送信するHTTPリクエストが処理の最小単位となり、
バッチ処理ではファイルもしくはDB上のデータレコードが処理の最小単位となりうる。

次にアプリケーションは与えられたリクエストに対して処理を行い、その処理結果を返す。
画面オンライン処理であれば、HTTPレスポンスの内容が返され、
バッチ処理では入力レコードに対する処理結果ステータスが返される。

**NAFアプリケーションの基本構造**

NAFにおけるアプリケーションの処理は、「トランザクション制御」や「応答電文の送信」といったステップごとに
細かく分割され、それぞれ **ハンドラ** と呼ばれるモジュールによって実装される。

これらのハンドラは、あらかじめ定められた順序に沿って並べられ、順次 **リクエスト** を処理していく。
このとき、内部的には、各ハンドラを実行順に並べたキューが作成される。
これを **ハンドラキュー** とよぶ。

ハンドラが呼び出される際、引数として **リクエスト** が渡される。
各ハンドラはこれをもとに必要な処理を行った後、同じ **リクエスト** を引数としてハンドラキュー上の次のハンドラを呼び出す。
こうして、ハンドラキュー上のハンドラを先頭から順次実行していき、最終的に業務ロジックを実装したハンドラを実行する。
このハンドラを **業務アクションハンドラ** と呼ぶ。
業務アクションハンドラは業務処理を実行し、その処理結果をリターンする。
各ハンドラはリターンされた処理結果に対して(必要であれば)処理を行い、再びリターンしていく。
これにより、処理結果はハンドラキューを **リクエスト** の時とは逆の方向に遡っていき、
先頭のハンドラまで処理結果が戻された時点で処理が完了する。

次の図はこの内容を表した模式図である。
(①～⑥の順)

![handler_queue.png](../../../knowledge/assets/about-nablarch-architectural-pattern-concept/handler_queue.png)

**NAFにおけるアプリケーションの基本構造**

### 標準ハンドラ構成

NAFには、以下に挙げるような様々な機能を実装したハンドラが存在している。
NAFの機能は、基本的にこれらのハンドラの組み合わせによって実現されている。

**汎用的に使用できるハンドラ**

* [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md)
* [リクエストディスパッチハンドラ](../../component/handlers/handlers-RequestPathJavaPackageMapping.md)
* [認可制御ハンドラ](../../component/handlers/handlers-PermissionCheckHandler.md)
* [開閉局制御ハンドラ](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md)   ... など

**画面オンライン処理に固有のハンドラ**

* [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md)
* [HTTPアクセスログハンドラ](../../component/handlers/handlers-HttpAccessLogHandler.md)
* [Nablarchカスタムタグ制御ハンドラ](../../component/handlers/handlers-NablarchTagHandler.md)  ... など

**バッチ処理に固有のハンドラ**

* [マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md)
* [プロセス多重起動防止ハンドラ](../../component/handlers/handlers-DuplicateProcessCheckHandler.md)  ... など

**メッセージング処理に固有のハンドラ**

* [電文応答制御ハンドラ](../../component/handlers/handlers-MessageReplyHandler.md)
* [再送電文制御ハンドラ](../../component/handlers/handlers-MessageResendHandler.md)  ... など

NAFでは、標準的なハンドラキューの構成を用途ごとに定義しており、それらを **標準ハンドラ構成** と呼んでいる。

以下の図は、オンライン画面処理で使用される標準ハンドラ構成を表した概念図である。

![handler_structure_online_minify.png](../../../knowledge/assets/about-nablarch-architectural-pattern-concept/handler_structure_online_minify.png)

**画面オンライン処理ハンドラ構成(簡易版)**

バッチ処理では以下のようになる。

リクエスト/処理結果の型や、ハンドラキューの構成が一部異なるものの、
基本的な処理フローは同じだということがわかる。

![handler_structure_batch_minify.png](../../../knowledge/assets/about-nablarch-architectural-pattern-concept/handler_structure_batch_minify.png)

**バッチ処理ハンドラ構成(簡易版)**

> **Note:**
> ここであげた標準ハンドラ構成は、主要なハンドラのみをピックアップした簡易版である。
> 実際のハンドラ構成については、以下の各項を参照すること。

> * >   [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md)
> * >   [都度起動バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-single-shot.md)
> * >   [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md)
> * >   [同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md)
> * >   [応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md)

### アプリケーションの実行と初期化処理

**リポジトリによるハンドラ構成の初期化**

前節で述べた方式に従って処理を実行するためには、
アプリケーションの起動時に標準ハンドラ構成に沿ったハンドラキューを構築する必要がある。

NAFでは、DI(Dependency Injection)ベースのオブジェクト管理機構([リポジトリ](../02_FunctionDemandSpecifications/01_Core/02_Repository.html))を実装しており、
アプリケーションの動作に必要となる全てのオブジェクトの生成と初期化処理を行う。
前節で述べたハンドラキューもリポジトリによって構築されるオブジェクトの一つである。

以下は、バッチ処理におけるリポジトリ初期化設定ファイルの中から、
ハンドラ構成の定義部分を抜粋したものである。

```xml
<!-- ハンドラ構成 -->
<list name="handlerQueue">
  <!-- ステータスコードを終了コードに変換するハンドラ -->
  <component class="nablarch.fw.handler.StatusCodeConvertHandler" />

  <!-- グローバルエラーハンドラ -->
  <component class="nablarch.fw.handler.GlobalErrorHandler" />

  <!-- スレッドコンテキスト設定ハンドラ -->
  <component-ref name="threadContextHandler" />

  <!-- ２重起動防止ハンドラ -->
  <component-ref name="duplicateProcessCheckHandler" />

  <!-- データベース接続ハンドラ -->
  <component-ref name="dbConnectionManagementHandler" />

  <!-- トランザクションマネージャ -->
  <component-ref name="transactionManagementHandler" />

  <!-- ディスパッチハンドラ -->
  <component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
    <property name="basePackage" value="nablarch.sample" />
    <property name="immediate" value="false" />
  </component>

  <!-- マルチスレッド実行制御ハンドラ -->
  <component class="nablarch.fw.handler.MultiThreadExecutionHandler">
    <property name="concurrentNumber" value="${threadCount}" />
    <property name="commitLogger" ref="commitLogger" />
  </component>

  <!-- データベース接続ハンドラ -->
  <component-ref name="dbConnectionManagementHandler" />

  <!-- ループ・トランザクション制御ハンドラ -->
  <component class="nablarch.fw.handler.LoopHandler">
    <property name="commitInterval" value="${commitInterval}" />
    <property name="transactionFactory" ref="transactionFactory" />
  </component>

  <!--処理停止ハンドラ-->
  <component-ref name="processStopHandler" />

  <!-- データリードハンドラ -->
  <component class="nablarch.fw.handler.DataReadHandler">
    <property name="maxCount" value="${maxCount}" />
  </component>
</list>
```

**NAFアプリケーションの実行方法**

NAFアプリケーションの実行方法は2とおり存在する。一つはjavaコマンドから直接起動する方法、
もう一つはTomcatなどのサーブレットコンテナにデプロイして実行する方法である。

[画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) では、サーブレットAPIの使用が前提となるため後者の方法をとる。
一方、それ以外の処理( [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) など)では、javaコマンドから直接起動する方法をとる。

**サーブレットコンテナ上での実行**

NAFアプリケーションをサーブレットコンテナ上で実行するには
[Nablarchサーブレットコンテキスト初期化リスナ](../../component/handlers/handlers-NablarchServletContextListener.md) および、 [Webフロントコントローラ (サーブレットフィルタ)](../../component/handlers/handlers-WebFrontController.md)
をアプリケーションサーバにデプロイする。

[Nablarchサーブレットコンテキスト初期化リスナ](../../component/handlers/handlers-NablarchServletContextListener.md) は、アプリケーションデプロイ時に web.xml に設定された
リポジトリの設定ファイルを読み込み、リポジトリの初期化を行なう。
ハンドラキューの構築についても、この初期化の中で行なわれる。

[Webフロントコントローラ (サーブレットフィルタ)](../../component/handlers/handlers-WebFrontController.md) は、アプリケーションに対する全てのHTTPリクエストを
ハンドラキューに対する入力データとして処理する。
業務処理の実行や、処理結果画面の送信といった処理はハンドラキュー上の各ハンドラによって実行される。

以下はデプロイメントディスクリプタの記述例である。

```xml
<web-app>
  <context-param>
    <!-- リポジトリの設定ファイルパス -->
    <param-name>di.config</param-name>
    <param-value>web-component-configuration.xml</param-value>
  </context-param>

  <listener>
    <listener-class>nablarch.fw.web.servlet.NablarchServletContextListener</listener-class>
  </listener>

  <filter>
    <filter-name>controller</filter-name>
    <filter-class>nablarch.fw.web.servlet.RepositoryBasedWebFrontController</filter-class>
  </filter>

  <filter-mapping>
    <filter-name>controller</filter-name>
      <url-pattern>/*</url-pattern>
    </filter-mapping>
  </filter-mapping>

</web-app>
```

> **Note:**
> 詳細については以下の各項を参照すること。

> * >   [Nablarchサーブレットコンテキスト初期化リスナ](../../component/handlers/handlers-NablarchServletContextListener.md)
> * >   [Webフロントコントローラ (サーブレットフィルタ)](../../component/handlers/handlers-WebFrontController.md)

**Javaコマンドでの実行**

NAFアプリケーションを通常のJavaコマンドから実行する場合は、 [共通起動ランチャ](../../component/handlers/handlers-Main.md) のメイン関数を実行する。
この関数では、起動引数で指定された [リポジトリ](../02_FunctionDemandSpecifications/01_Core/02_Repository.html) の設定ファイルを読み込んでその初期化を行なう。
ハンドラキューの構築もこの初期化の中で行なわれる。

アプリケーションの処理は、起動引数を格納したオブジェクトを入力としてハンドラキューを実行することによって行なわれる。

以下は、NAFバッチアプリケーションの起動コマンドの例である。
(リポジトリ設定ファイルのパスは起動引数 **[-diConfig]** で与えられる。)

```sh
java                                                 \
    -Xmx128m                                         \
    -DcommitInterval=100                             \
    -DmaxExecutionCount=100000                       \
nablarch.fw.launcher.Main                            \
    -diConfig    file:./batch-config.xml             \
    -requestPath admin.DataUnloadBatchAction/BC0012  \
    -userId      batchUser012
```

> **Note:**
> 詳細については [共通起動ランチャ](../../component/handlers/handlers-Main.md) の項を参照すること。

### ハンドラの構造と実装

**ハンドラインターフェースの定義**

ハンドラクラスとは、以下のインターフェース **nablarch.fw.Handler** を実装したクラスのことを指す。

```java
package nablarch.fw;
/**
 * NAFのパイプライン処理において、
 * 各ステップの処理を実装するモジュール(ハンドラ)が
 * 実装するインターフェース。
 *
 * @param <TData>    リクエストデータ型
 * @param <TResult>  処理結果データ型
 *
 * @author Iwauo Tajima
 * @since  1.0
 */
public interface Handler<TData, TResult> {
    /**
     * リクエストに対する処理を実行する。
     *
     * @param data    リクエストデータ
     * @param context 実行コンテキスト
     * @return 処理結果
     */
    TResult handle(TData data, ExecutionContext context);
}
```

このインターフェースにはただ1つのメソッド `handle()` が定義されている。
ハンドラの全ての責務は基本的にこのメソッドに対して実装される。

> **Note:**
> ただし、業務アクションハンドラを実装する場合は、Handlerインターフェース直接実装するのでは無く、
> 典型的な処理がテンプレート化されたクラスが提供されているので、それらを利用して実装する。

> * >   [業務アクションハンドラ](../../component/handlers/handlers-handler.md#業務アクションハンドラ)

`handle()` メソッドの第一引数には、リクエストの内容を保持したオブジェクトが渡される。
リクエスト型はハンドラごとに型変数として宣言され、そのハンドラがリクエストをどのように扱うかを表す。
次の表は、 [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) で利用するハンドラを型変数で分類したものである。

| 型変数 | ハンドラの処理内容 | ハンドラの例 |
|---|---|---|
| Object | データベーストランザクション制御などの リクエストの内容に(直接には)関係しない処理を行う。 | [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) [開閉局制御ハンドラ](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md) |
| [Request](../../javadoc/nablarch/fw/Request.html) | 業務アクションハンドラのディスパッチなど リクエストの内容に沿った共通処理を行う。 (詳細は [リクエストの識別と業務処理の実行](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#リクエストの識別と業務処理の実行) を参照) | [リクエストディスパッチハンドラ](../../component/handlers/handlers-RequestPathJavaPackageMapping.md) [リクエストハンドラエントリ](../../component/handlers/handlers-RequestHandlerEntry.md) |
| [HttpRequest](../../javadoc/nablarch/fw/web/HttpRequest.html) | HTTPアクセスログの記録など HTTPリクエストに直接依存した処理を行う。 | [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) [HTTPアクセスログハンドラ](../../component/handlers/handlers-HttpAccessLogHandler.md) |

この型引数は、各ハンドラの適用範囲も表す。
例えば、 `Object` や [Request](../../javadoc/nablarch/fw/Request.html) を型変数とするハンドラは、 [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) だけでなく、
[バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) や [メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) においても共用することができる。
一方、 [HttpRequest](../../javadoc/nablarch/fw/web/HttpRequest.html) を型変数とするハンドラは、 [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) 以外で使用することはできない。

第二引数には、 **実行コンテキスト** と呼ばれる、アプリケーション実行中にサーバ側で使用する以下の制御情報を格納したオブジェクトが渡される。
(各項目の詳細についてはリンク先の解説を参照)

* [ハンドラキュー](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#nafのアプリケーション動作モデル)
* [リクエストスコープ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#変数スコープ)
* [セッションスコープ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#変数スコープ)
* [データリーダ/データリーダファクトリ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#データリーダ)

`handle()` メソッドはその戻り値として、ハンドラの処理結果を表すオブジェクトを返す。
処理結果オブジェクトの型もリクエストと同様、処理方式ごとに異なるため、ハンドラごとに型変数として
宣言する必要がある。

**ハンドラ処理フロー**

1つのハンドラの処理内容は以下の3つのブロックに分けて考えることができる。

**1. 往路処理**

`handle()` メソッド開始から、後続のハンドラに処理を移譲するまでの間に実行される処理。

主に、入力データの内容をもとにした事前処理を実行する。
**(例: 権限チェック、トランザクションの開始、アクセスログ出力など)**

**2. 復路処理**

後続ハンドラでの処理が正常終了してから `handle()` メソッド終了までの間に実行される処理。

主に後続ハンドラの処理結果を用いた処理や、正常終了時の事後処理を実行する。
**(例: クライアントに対する応答送信、トランザクションのコミット、リソースの開放など)**

**3. 例外処理**

当該のハンドラもしくは、後続ハンドラの処理中に例外が発生した場合に実行される処理。

主に後続ハンドラでエラー終了した場合の事後処理を実装する。
**(例: クライアントに対するエラー応答送信、障害ログの出力、トランザクションのロールバック、リソースの開放など)**

以下のソースコードは、後続のハンドラに対するトランザクション制御を行なうハンドラのサンプルコードである。

```java
public class TransactionHandler implements Handler<Request, Result> {

    public Result handle(Request request, ExecutionContext context) {
        try {
            /* 1. (往路処理) トランザクションを開始する。*/
            beginTransaction(request, context);

            Result result = context.handleNext(request);          // ExecutionContext#handleNext() を実行することで、
                                                                  // ハンドラキュー上の後続ハンドラに処理が移譲され、
                                                                  // その処理結果が返される。
            /* 2. (復路処理) トランザクションをコミットする。*/
            commitTransaction(result, request, context);

            //正常終了
            return result;                                        // 後続のハンドラの処理結果をそのまま返却する。

        /* 3. (例外処理) トランザクションをロールバックする。*/
        } catch (RuntimeException e) {                            // handle() メソッドはチェック例外を送出しないため、
            rollbackTransaction(e, request, context);             // 実行時例外(java.lang.RuntimeException)もしくは、
            throw e;                                              // エラー(java.lang.Error) のいずれかが送出される。

        /* 3. (例外処理) トランザクションをロールバックする。*/
        } catch (Error e) {                                       // 通常の用途ではjava.lang.Errorを捕捉する必要はない。
            rollbackTransaction(e, request, context);
            throw e;

        /* (終端処理) トランザクションの終了*/
        } finally {                                               // 2. 復路処理、3. 例外処理の双方で実行される。
            endTransaction(request, context);
        }
    }

    private void beginTransaction(Request request, ExecutionContext context) {
        // (後略)
    }
}
```

-----

### リクエストの識別と業務処理の実行

この項では、外部から送信される各リクエストに対し、必要な業務処理を実装する業務アクションハンドラを実行する
共通的な仕組みについて解説する。

#### リクエストIDと実行時ID

**リクエストID**

リクエストは依頼したい **処理** と **データ** から構成されるが、この **処理** を一意に識別する情報が **リクエストID** である。
リクエストIDは実装レベルにおいて後述の **リクエストパス** の一部に含まれる。

**実行時ID**

**実行時ID** は、各リクエストを実行するごとに割り振られる一意文字列であり、各種のログやデータベース上で個別の
業務処理を識別し、トレースする目的で使用する。

#### リクエストに対する業務処理のディスパッチ

**リクエストパス**

**リクエストパス** は、NAFが各リクエストを実行する業務アクションハンドラを特定するためのものである。
**リクエストID** を部分文字列に含み、 リクエストID と1対1の関係を持つ。依頼したい処理を リクエストパス
または リクエストID の形で指定することで、リクエスト毎に実行する業務処理を切り替えることができる。

なお、一般的なバッチ処理のように全リクエスト(この場合は全ての入力レコード)に
同一の業務アクションハンドラを割り当てる場合、リクエスト内に リクエストパス や リクエストID を含める必要はなく、
プロセスの起動引数などにリクエストパスを指定すれば、全てのリクエストに対してそれが適用される。

**リクエストパス** の内容は、実行制御基盤ごとに以下のように定められる。

| リクエストの種類 | 実行制御基盤 | リクエストパス | 備考 |
|---|---|---|---|
| HTTPリクエスト | [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) | リクエストURI | リクエストURIをリクエストパスとして使用する。 URIのパス階層を業務アクションハンドラのパッケージとクラスにマッピングする。 |
| 処理要求電文 | [メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) | FWヘッダ領域の 特定のフィールド | 受信電文中の特定のフィールドをリクエストIDとして読み込む。 リクエストパスとは異なり、リクエストIDには階層構造が含まれないので、 外部設定により業務アクションハンドラのパッケージを指定し、リクエストIDに 対応するクラスにディスパッチする。  ただし、受信電文中にリクエストIDに相当するフィールドが存在しない場合は、 後述する **コマンドラインオブジェクト** のリクエストパスを使用する。 この場合、ディスパッチは行われず、全ての電文は単一の業務アクションハンドラ によって処理される。 |
| データレコード | [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) | ファイル/DBテーブル の特定のカラム値 | バッチ処理では、入力ファイルやDBテーブルの特定のカラム値をリクエストID として読み込むことで、レコード毎に個別の業務アクションハンドラを 実行することができる。  ただし、一般的なバッチ処理では、リクエスト(=処理対象レコード)内に リクエストIDに相当するデータが存在するとは限らないため、その場合は 後述する **コマンドラインオブジェクト** に指定された値を使用して、 単一の業務アクションハンドラで処理を行う。 |
| コマンドライン | [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md)  [メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) | 起動コマンドの 特定のパラメータ値 | リクエストにリクエストID もしくは リクエストパスに相当するデータが 含まれない場合は、リクエスト毎のディスパッチは行なず、 全てのリクエストに対して、プロセスの起動パラメータに指定したリクエストパス に対応する業務アクションハンドラを実行する。 |

**リクエストパスとリクエストIDのマッピング**

アプリケーションが実装する業務処理を実行するためには、その **リクエストID** を指定する必要がある。
リクエスト中の **リクエストパス** と **リクエストID** は、標準設定において以下の例のように紐付けられる。

| リクエストパスの形態 | リクエストパス | リクエストID |
|---|---|---|
| リクエストURI | **http ://www.example.com/app/admin/UserAction/WAA0010.do** | WAA0010 |
| プロセス起動引数 | **-requestPath admin.DataUnloadBatchAction/BC0012** | BC0012 |

※  [メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) では、通常、リクエストIDが直接リクエストに含まれるため、マッピングは不要である。j

リクエストパスとリクエストIDとの紐付けは [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) が行い、以降のハンドラではリクエストIDをスレッドコンテキスト上の
変数として参照することができる。

**リクエストパス/リクエストID と業務アクションハンドラのマッピング**

リクエスト中の **リクエストパス** ないし **リクエストID** に対して、業務アクションハンドラをマッピングする処理は、
[リクエストディスパッチハンドラ](../../component/handlers/handlers-RequestPathJavaPackageMapping.md) で行なわれる。
マッピングされた業務アクションハンドラはハンドラキュー上に追加され、後続の処理の中で呼ばれる。

#### 特殊なリクエスト処理

**内部フォーワード処理と内部リクエストID**

**内部フォーワード処理** とは、リクエスト処理を実行中に、それまでのリクエストパスとは異なるリクエストパスを用いてハンドラキューの内容を
再実行する処理である。(詳細は [内部フォーワードハンドラ](../../component/handlers/handlers-ForwardingHandler.md) を参照)

この際、 **リクエストパス** の値は変更されるものの、 **リクエストID** および **実行時ID** は、同一リクエストを処理している間は不変である。
これは、 **リクエストパス** がリクエストとそれに対して実行する業務処理をマッピングするため文字表現であるのに対し、
**リクエストID** および **実行時ID** は、それぞれ、リクエストおよびその実行を識別するIDであるためである。

なお、変更後のリクエストパスに対するリクエストIDは、スレッドコンテキスト上の別変数として格納される。
これを **内部リクエストID** とよぶ。

例えば、開閉局制御と認可制御に内部リクエストIDを使用することで、フォワード先のリクエストIDで
開閉局制御と認可制御が実施できる。
開閉局制御と認可制御にリクエストIDを使用した場合と内部リクエストIDを使用した場合の動作の違いを下記に示す。

![internal_req_usecase.png](../../../knowledge/assets/about-nablarch-architectural-pattern-concept/internal_req_usecase.png)

開閉局制御と認可制御に内部リクエストIDを使用する場合は、各ハンドラの設定が必要である。
設定方法は、 [開閉局制御ハンドラ](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md) 、 [認可制御ハンドラ](../../component/handlers/handlers-PermissionCheckHandler.md) を参照。

-----

**メソッドレベルバインディング**

[リクエストディスパッチハンドラ](../../component/handlers/handlers-RequestPathJavaPackageMapping.md) によってハンドラキュー上に配置された業務アクションハンドラは、
通常のハンドラと同様、 `handle()` メソッドが呼ばれるので、そこに業務処理を実装する必要がある。
しかし、以下に述べる **メソッドレベルバインディング** と呼ばれるしくみを用いることで、
`handle()` メソッド以外の任意のメソッドに業務処理ディスパッチさせることができる。

**メソッドレベルバインディング** は、ハンドラインターフェースを実装して **いない** オブジェクトを
ハンドラキューに追加(もしくはディスパッチ)することで有効化される。

フレームワークは、ハンドラキュー上のハンドラがハンドラインターフェースを実装していない場合に、
実行コンテキスト上に設定された **MethodBinding** と呼ばれるモジュールを用いて `handle()` メソッドにかわる
メソッドを決定し、これを実行する。

フレームワーク標準の **MethodBinder** として、以下の実装が提供される。

| クラス名 | 概要 | 参照 |
|---|---|---|
| nablarch.fw.web.HttpMethodBinding | HTTPリクエストメソッド名(GET/POST/DELETE/PUT等) およびリソース名に応じてメソッドよび分ける。 | [画面オンライン処理用業務アクションハンドラ](../../component/handlers/handlers-HttpMethodBinding.md) |
| nablarch.fw.handler.RecordTypeBinding | 入力ファイルや、電文データ上のレコード種別 (ヘッダ、データ、トレーラ等) に応じて メソッドを呼び分ける。 | [ファイル入力のバッチ業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-FileBatchAction.md) |

なお、実行コンテキスト上に **MethodBinding** が設定されてない状態でハンドラインターフェースを実装していない
オブジェクトをハンドラキュー上に追加した場合は実行時エラーが送出される。

#### リクエストインターフェース

リクエストインターフェースとは、リクエストに対してリクエストパスを定義する際に実装するインターフェースである。
リクエストパスおよびリクエスト内に保持している各種パラメータに対するアクセサが定義されている。
リクエストがこのインターフェースを実装することにより、リクエスト毎に実行する業務処理を切り替えることが可能となる。

```java
/**
 * 処理要求を表すインターフェース。
 *
 * @param <TParam> リクエストパラメータの型
 * @author Iwauo Tajima
 * @since  1.0
 */
public interface Request<TParam> {
    /**
     * リクエストの種別を識別する文字列。
     * @return リクエストパス
     */
    String getRequestPath();

    /**
     * リクエストパスを設定する。
     * @param requestPath リクエストパス
     * @return このオブジェクト自体
     */
    Request<TParam> setRequestPath(String requestPath);

    /**
     * リクエストパラメータを取得する。
     * @param name パラメータ名
     * @see #getParamMap()
     */
    TParam getParam(String name);

    /**
     * リクエストパラメータのMapを返す。
     * @return リクエストパラメータのMap
     */
    Map<String, TParam> getParamMap();
}
```

### 処理結果の識別

**処理結果オブジェクト**

処理結果オブジェクトとは、ハンドラの処理結果を表すオブジェクトであり、次のインターフェースで定義される。

```java
/**
 * ハンドラでの処理結果を表すインターフェース。
 *
 * @author Iwauo Tajima
 * @since 1.0
 */
public interface Result {
    /**
     * ステータスコードを返す。
     * @return ステータスコード
     */
    int getStatusCode();

    /**
     * 処理結果に関する詳細情報を返す。
     * @return 詳細情報
     */
    String getMessage();

    /**
     * 処理が正常終了したかどうかを返す。
     * @return 正常終了した場合はtrue
     */
    @Published
    boolean isSuccess();
}
```

**ハンドラの処理結果**

ハンドラでの処理が終了した場合、その処理結果を上位のハンドラに返す方法は以下の4つのいずれかとなる。

1. **後続のハンドラの結果をそのままリターンする。**

多くのハンドラでは、後続のハンドラに処理を委譲し、その結果をそのままリターンする。

1. **処理結果オブジェクトを作成してリターンする。**

[リクエスト](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#リクエストの識別と業務処理の実行) に対する処理が正常終了し、処理結果が確定した場合、
その内容を表す以下のオブジェクトを作成してリターンする。
実行中のトランザクションは、 [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) によりコミットされる。

| 実行制御基盤 | 正常終了時に返却する型 | 内容 |
|---|---|---|
| [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) | [HttpResponse](../../javadoc/nablarch/fw/web/HttpResponse.html) | 遷移先画面のパス等の内容を設定したオブジェクトをリターンする。 |
| [同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) | [ResponseMessage](../../javadoc/nablarch/fw/messaging/ResponseMessage.html) | 応答電文のフォーマットや内容を設定したオブジェクト をリターンする。 |
| [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) [応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md) | [Result.Success](../../javadoc/nablarch/fw/Result.Success.html) | 正常終了を表すマーカオブジェクトをリターンする。 (これらの処理ではレスポンス処理が無いので、内容の設定は不要) |

1. **処理結果オブジェクトを実行時例外として送出する。**

[リクエスト](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#リクエストの識別と業務処理の実行) に対する処理が異常終了することが確定した場合、下記の例外を作成して送出する。
実行中のトランザクションは、 [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) によりロールバックされる。

| 実行制御基盤 | 異常終了時に送出する型 | 内容 |
|---|---|---|
| [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) | [HttpErrorResponse](../../javadoc/nablarch/fw/web/HttpErrorResponse.html) | エラー時遷移先画面のパス等の内容を設定したオブジェクトを 送出する。 |
| [同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) | [ErrorResponseMessage](../../javadoc/nablarch/fw/messaging/ErrorResponseMessage.html) | エラー応答電文のフォーマットや内容を設定したオブジェクトを 送出する。 |
| [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) [応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md) | [Result.Error](../../javadoc/nablarch/fw/Result.Error.html) のサブクラス | 異常終了を表すマーカオブジェクトを送出する。 (これらの処理ではレスポンス処理が無いので、内容の設定は不要) |

1. **処理結果オブジェクトではない実行時例外を送出する。**

その他、一般の実行時例外が送出された場合は、トランザクションがロールバックされ、
[画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) 、 [同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) ではレスポンス処理が行われる。
この場合はレスポンス内容を指定することができないため、既定のレスポンス処理が行われる。

**レスポンス処理**

上で述べたように、 [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) や [同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) では、クライアントに対する応答の内容を
指定するオブジェクトを処理結果として返却もしくは送出する。

これらのオブジェクトは、ハンドラキュー上の特定のハンドラによって処理され、クライアントに対するレスポンスとして送信される。 (下図)

![response_handler.png](../../../knowledge/assets/about-nablarch-architectural-pattern-concept/response_handler.png)

詳細は以下を参照すること。

* [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md)
* [電文応答制御ハンドラ](../../component/handlers/handlers-MessageReplyHandler.md)

-----

### 変数スコープ

**変数スコープ** とは、ハンドラキュー上のハンドラ間でデータを共有する際に使用する領域のことである。
変数スコープには共有範囲や存続期間が異なる以下の4つのスコープが存在し、それぞれ使用目的が異なる。

**リクエストスコープ**

各リクエストの開始から終了までの間、スレッド毎に固有の変数を保持する変数スコープである。
リクエストスコープは実行コンテキスト上に保持されており、
Map<String, Object>インターフェースでアクセスすることができる。

**セッションスコープ**

セッションスコープは複数のリクエストを跨って存続し、各リクエストスレッド間で共有される変数を保持する変数スコープである
(共有範囲、存続期間は各処理形態ごとに異なる)。
リクエストスコープと同様、実行コンテキストからMap<String, Object>インターフェースでアクセスすることができる。

なお、セッションスコープの内容をリクエストスレッドから変更する場合は、
[セッション並行アクセスハンドラ](../../component/handlers/handlers-SessionConcurrentAccessHandler.md) を使用するなど、何らかの同期化を行なう必要がある。

**スレッドローカル**

リクエストスコープやセッションスコープは、ハンドラ間の引数である実行コンテキストを経由して引き渡されるため、
DB接続のように、どこで使用するか予期できないデータの受け渡しをしようとすると、
ハンドラとは直接関係の無いクラスのメソッドにまで実行コンテキストを引数として渡さなければならず、あまり現実的では無い。

そのため、 [データベース接続管理ハンドラ](../../component/handlers/handlers-DbConnectionManagementHandler.md) など一部のハンドラでは、
変数スコープではなく、スレッドローカル変数(java.lang.ThreadLocal)を経由してデータやオブジェクトの引き回しを行なっている。

**スレッドコンテキスト**

スレッドコンテキストは、スレッドローカル変数上に保持された変数スコープ(Map)である。
ユーザIDや、リクエストIDのように、ログ出力やDB共通項目への設定などの用途において、実行コンテキストを経由した
引き回しが難しいパラメータ類を格納する。

その内容の多くは、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) によって設定されるが、
それ以外ハンドラでも、スレッドコンテキストに変数を設定するものが存在するほか、
業務アクションハンドラから任意の変数を設定することも可能である。

以下の図は、これらのスコープの特性をあらわしたものである。

![handler_scope.png](../../../knowledge/assets/about-nablarch-architectural-pattern-concept/handler_scope.png)

また、画面オンライン実行制御基盤では、上記のスコープに加えて **ウィンドウスコープ** と呼ばれる変数スコープを使用する。

#### ウィンドウスコープ

ウィンドウスコープとは、セッションスコープと同様、複数のリクエストを跨るデータを格納する変数スコープである。
セッションスコープがアプリケーションサーバ上でデータを格納するのに対して、
ウィンドウスコープは、複数画面間をhiddenタグで持ちまわることにより実現される。
ウィンドウスコープを使用することで、ブラウザで複数のウィンドウを立ち上げても
並列に動作させることができる。また、ブラウザのヒストリバックによる遷移が可能となる。

下図は、複数の入力画面で構成されるアンケートアプリケーションにおける動作イメージである。
ユーザからの入力項目をhiddenタグで持ちまわることで、
セッションスコープを使用せずに複数画面にまたがった情報の保持を可能としている。

![window_scope_sequence.png](../../../knowledge/assets/about-nablarch-architectural-pattern-concept/window_scope_sequence.png)

上記のように、hiddenで引き継がれる情報は特定のウィンドウ内のHTMLに記載されている。
このようにして、他のウィンドウやタブに影響を与えずに、複数のリクエストをまたがったデータ共有を実現している。

> **Note:**
> ウィンドウスコープに格納された変数は、カスタムタグを使用することで自動的にhiddenタグに変換されるので、
> **アプリケーションプログラマがJSPにhiddenタグを書く必要はない。**

画面オンライン制御基盤の画面間のデータ連携では、基本的にセッションスコープではなくこのウィンドウスコープを使用することになる。
詳細については、以下の文書を参照すること。

* 画面オンライン制御基盤における各種スコープの使い分けについて

  [画面オンライン用業務アクションハンドラ:変数スコープの利用](../handler/HttpMethodBinding.html#web-scope)
* カスタムタグを使用したウィンドウスコープの使用方法について

  [カスタムタグ実装例集](../../../../guide/development_guide/04_Explanation/CustomTag/basic.html#howto-window-scope)

### ハンドライベントコールバック

一部のハンドラでは、特定のインタフェースを実装した後続ハンドラに対してコールバックを行う。

コールバックを行うハンドラの代表例は [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) である。
このハンドラでは、以下のインタフェースを実装しているハンドラに対して、
コミットもしくはロールバックのタイミングでコールバックを行う。

```java
/**
 * トランザクション(コミット or ロールバック)毎に呼び出される
 * コールバックメソッドを定義するインタフェース。
 *
 * @param <TData>ハンドラへの入力データ
 * @author hisaaki sioiri
 * @since 1.1
 */
public interface TransactionEventCallback<TData> {

    /**
     * 入力データに対する処理が正常に処理された場合に呼ばれる。
     */
    void transactionNormalEnd(TData data, ExecutionContext ctx);

    /**
     * 入力データに対する処理で異常が発生した場合に呼ばれる。
     */
    void transactionAbnormalEnd(Throwable e, TData data, ExecutionContext ctx);
}
```

例えば、業務アクションハンドラがこのインターフェースを実装することによって、
業務トランザクションがロールバックされた場合の例外制御を行なうことができる。
次の図は、この動作を表した模式図である。

![handler_callback.png](../../../knowledge/assets/about-nablarch-architectural-pattern-concept/handler_callback.png)

このようなコールバック制御を行うハンドラには以下のものがある。

* [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md)
* [マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md)
* [トランザクションループ制御ハンドラ](../../component/handlers/handlers-LoopHandler.md)

-----

### データリーダ

データリーダとは、外部のリソース (ファイル、DB、メッセージキューなど) から、
1業務トランザクションの実行に必要な情報を読み込むコンポーネントである。
データリーダで読み込まれたデータは、後続のハンドラの入力として渡され、
最終的に業務アクションハンドラによって処理される。

> **Note:**
> [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) では、HTTPリクエスト内に1業務トランザクションの実行に必要な情報が含まれているので、
> 別途データリーダを使用する必要はない。

データリーダのインターフェースは以下で定義される。

```java
/**
 * ハンドラが処理する入力データを外部から読み込むインタフェース。
 *
 * データリーダは複数のリクエストスレッドから並行アクセスされ得るので、
 * 各メソッドはスレッドセーフに実装されなければならない。
 *
 * @param <TData> このクラスが読み込んだデータの型
 *
 * @author Iwauo Tajima
 * @since  1.1
 */
public interface DataReader<TData> {
    /**
     * ハンドラが処理する入力データを読み込んで返却する。
     *
     * 入力データがこれ以上存在しない状態、すなわち、hasNext()の結果がfalseとなる
     * 状態でこのメソッドを呼んだ場合の結果は不定である。
     *
     * @param ctx 実行コンテキスト
     * @return 入力データオブジェクト
     */
    TData read(ExecutionContext ctx);

    /**
     * 次に読み込むデータが存在するかどうかを返却する。
     *
     * @param ctx 実行コンテキスト
     * @return 次に読み込むデータがまだ残っている場合はtrue
     */
    boolean hasNext(ExecutionContext ctx);

    /**
     * このリーダの使用を停止し、内部的に保持している各種リソースを開放する。
     *
     * @param ctx 実行コンテキスト
     */
    void close(ExecutionContext ctx);
}
```

**データリーダの作成**

データリーダを作成する責務とタイミングは実行制御基盤ごとに以下のように異なる。
いずれの場合でも、作成されたデータリーダは実行コンテキストに設定され、後続のハンドラによって使用される。

| 実行制御基盤 | 作成するコンポーネント | 作成するタイミング |
|---|---|---|
| [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) | (データリーダを使用しない。) | N/A |
| [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) | 業務アクションハンドラ | [マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) の初期処理内。 (業務アクションハンドラが実装する [DataReaderFactory](../../javadoc/nablarch/fw/DataReaderFactory.html) をコールバックする。) |
| [メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) | [リポジトリ](../02_FunctionDemandSpecifications/01_Core/02_Repository.html) | [リポジトリ](../02_FunctionDemandSpecifications/01_Core/02_Repository.html) での初期化処理内で作成する。 (オブジェクトキー名: **dataReader**) |

**データリードハンドラ**

データリーダを使用して読込み処理を行うのは、 [データリードハンドラ](../../component/handlers/handlers-DataReadHandler.md) である。
このハンドラは、実行コンテキスト上のデータリーダから1件分の業務処理データを読み込み、
それを引数として後続ハンドラに処理を委譲する。

次の図は、データリードハンドラの挙動を表したものである。

![handler_datareader.png](../../../knowledge/assets/about-nablarch-architectural-pattern-concept/handler_datareader.png)

-----

### 業務アクションハンドラの実装

業務アクションハンドラは、業務処理を実装するハンドラであり、業務アプリケーションの開発担当者が実装する。
このハンドラで行う業務処理のおおまかな流れは下図のようになる。

![action_handler.png](../../../knowledge/assets/about-nablarch-architectural-pattern-concept/action_handler.png)

図中の番号は処理の順番を示している。以下は上図の説明である。

1. **入力データの取得**

入力データの内容は、基本的にMap形式で取得できるようになっている。(図中①)

(以降で使用する入力精査やDBアクセスといったライブラリも、基本的にMapを引数や戻り値として使用する。)

1. **入力精査**

前段で取得した入力データのMapに対して精査処理を行う。(図中②)
精査ロジックはフォーム定義に沿って行なう。

**フォーム定義に沿った入力精査**

フォームとは「システムへの入力項目」の精査と値の保持を行うクラスであり、画面項目定義や
電文フォーマット定義などに沿って作成される。
フォームクラスの各項目には宣言的に精査仕様を設定できるようになっており、
精査ロジックを簡便に実装できる。

なお、DB内容との比較などの処理を含む精査については、ビジネスロジックの一部として実装する。

> **Note:**
> フォームのうち、下記の特徴を持つクラスを特にエンティティと呼称する。
> エンティティはテーブル定義に沿って作成される。

> * >   フォームクラスがRDBMS上のテーブルと1対1にひもづく。
> * >   フォームクラスのプロパティとテーブルのカラムが1対1にひもづく。

1. **ビジネスロジックの実行**

精査が完了した入力データはフォームもしくはエンティティオブジェクトとして取得できる。
この内容をもとに、ビジネスロジックを実行する。
また、フレームワークが提供するライブラリを使用することで、
DB、データファイル、メッセージキューを通じた入出力を行うことができる。 (図中③)
これらのライブラリについても、Mapインターフェースを通じて使用できるようになっている。

**共通コンポーネントの使用**

複数の業務アクションから共用しうるロジックについては、業務アクションハンドラに直接実装するのではなく
個別のクラス(共通コンポーネント)として実装することを推奨する。(図中④)
また、既存の共通コンポーネントが適用可能であれば、積極的に使用すること。

1. **処理結果の返却**

ビジネスロジックの処理結果を表すオブジェクトを返却する。(図中⑤)
業務処理が正常終了した場合は、処理結果の内容を表すオブジェクトを生成して返す。
業務処理を異常終了させる場合には、実行時例外を送出する。
実行時例外を送出することで、 [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) により
業務トランザクションがロールバックされる。
