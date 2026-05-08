## 開閉局制御ハンドラ

**クラス名:** `nablarch.common.handler.ServiceAvailabilityCheckHandler`

-----

### 概要

リクエストID単位での開閉局制御を行うハンドラ。

開閉局機能の詳細については、
[開閉局](../../component/libraries/libraries-05-ServiceAvailability.md)
の章を参照すること。

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| スレッドコンテキスト変数設定ハンドラ(リクエストスレッド) | nablarch.common.handler.ThreadContextHandler_request | Object | Object | 前のループで設定されたスレッドコンテキスト変数をクリアするためここで再初期化する。 | - | - |
| 内部フォーワードハンドラ | nablarch.fw.web.handler.ForwardingHandler | HttpRequest | HttpResponse | - | 遷移先に内部フォーワードパスが指定されていた場合、HTTPリクエストオブジェクトのリクエストURIを内部フォーワードパスに書き換えた後、後続のハンドラを再実行する。 | - |
| 開閉局制御ハンドラ | nablarch.fw.common.handler.ServiceAvailabilityCheckHandler | Request | Result | リクエストＩＤ単位での開閉局制御を行う | - | - |

-----

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) | 本ハンドラではスレッドコンテキスト上に設定された [内部リクエストID](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#特殊なリクエスト処理) をもとに開閉局判定を行なうため、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) を本ハンドラの上位に配置する必要がある。 |
| [内部フォーワードハンドラ](../../component/handlers/handlers-ForwardingHandler.md) | [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) において内部フォーワードが行われた際に、 開閉局の制御をフォーワード先のリクエストID ([内部リクエストID](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#特殊なリクエスト処理)) で行う必要がある場合は、本ハンドラを [内部フォーワードハンドラ](../../component/handlers/handlers-ForwardingHandler.md) より下位に配置する必要がある。 |
| [データリードハンドラ](../../component/handlers/handlers-DataReadHandler.md) | [メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) では、 受信電文中のフレームワークヘッダ内に定義された **requestId** ヘッダの値を使用して 開閉局制御を行う。 (この場合、 [要求電文(FWヘッダ)リーダ](../../component/readers/readers-FwHeaderReader.md) が **requestId** ヘッダの値を スレッドコンテキストに設定するので、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) は使用しなくてもよい) |

### ハンドラ処理フロー

**[往路処理]**

**1. (リクエストIDの取得)**

スレッドコンテキストから [リクエストID](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#リクエストの識別と業務処理の実行) もしくは
[内部リクエストID](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#特殊なリクエスト処理) を取得する。

**2. (開閉局判定)**

本ハンドラに設定された **サービス開閉局判定オブジェクト** を使用して、
**1.** で取得したリクエストIDに対するサービスが開局中であることを確認する。

**2a. (閉局エラー)**

サービスが閉局中であった場合は、後続のハンドラを実行せず、
実行時例外 [Result.ServiceUnavailable](../../javadoc/nablarch/fw/Result.ServiceUnavailable.html) (**ステータスコード:503**)を送出して終了する。

**3. (後続ハンドラの実行)**

当該サービスが開局状態であれば、後続のハンドラを実行し、その結果を取得する。

**[復路処理]**

**4. (正常終了)**

**3.** で取得した処理結果をリターンし終了する。

**[例外処理]**

**3a. (後続ハンドラの処理でエラー)**

後続ハンドラの実行中にエラーが発生した場合は、そのまま再送出して終了する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

なお、開閉局機能の設定内容の詳細については、
[開閉局](../../component/libraries/libraries-05-ServiceAvailability.md)
の章を参照すること。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| サービス開閉局判定コンポーネント | serviceAvailability | ServiceAvailability | 必須指定 |
| 内部リクエストIDによる判定を行うかどうか | usesInternalRequestId | boolean | 任意指定 (デフォルト=false) |

**標準設定**

```xml
<!-- サービス提供可否判定ハンドラ -->
<component
  name="serviceAvailabilityCheckHandler"
  class="nablarch.common.handler.ServiceAvailabilityCheckHandler">
  <property name="serviceAvailability" ref="serviceAvailability" />
  <property name="usesInternalRequestId" value="true" />
</component>
```
