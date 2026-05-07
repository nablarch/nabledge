## 認可制御ハンドラ

**クラス名:** `nablarch.common.handler.PermissionCheckHandler`

-----

-----

### 概要

リクエストIDを単位とした認可判定を行うハンドラ。

また、認可通過以降は、認可関連情報をスレッドコンテキスト経由で取得することができる。
認可機能の詳細については、 [認可](../../component/libraries/libraries-04-Permission.md) の章を参照すること。

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| スレッドコンテキスト変数設定ハンドラ(リクエストスレッド) | nablarch.common.handler.ThreadContextHandler_request | Object | Object | 前のループで設定されたスレッドコンテキスト変数をクリアするためここで再初期化する。 | - | - |
| 内部フォーワードハンドラ | nablarch.fw.web.handler.ForwardingHandler | HttpRequest | HttpResponse | - | 遷移先に内部フォーワードパスが指定されていた場合、HTTPリクエストオブジェクトのリクエストURIを内部フォーワードパスに書き換えた後、後続のハンドラを再実行する。 | - |
| 認可制御ハンドラ | nablarch.fw.common.handler.PermissionCheckHandler | Object | Object | スレッドコンテキスト上の userId/requestId をもとに認可判定を行う。認可判定に失敗した場合は例外を送出して終了する。成功した場合は、認可情報オブジェクトをスレッドローカルに設定する。 | - | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) | 本ハンドラではスレッドコンテキスト上に設定されたリクエストID/ユーザIDをもとに 認可判定を行なうため、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) を本ハンドラの上位に配置する必要がある。 |
| [内部フォーワードハンドラ](../../component/handlers/handlers-ForwardingHandler.md) | [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) において、内部フォーワードを行った際の認可判定を フォーワード先のリクエストID ([内部リクエストID](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#特殊なリクエスト処理)) で行う場合、 本ハンドラは [内部フォーワードハンドラ](../../component/handlers/handlers-ForwardingHandler.md) より下位に配置する必要がある。 |
| [データリードハンドラ](../../component/handlers/handlers-DataReadHandler.md) | [メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) では、 [要求電文(FWヘッダ)リーダ](../../component/readers/readers-FwHeaderReader.md) が受信電文中のフレームワークヘッダ部を解析する際に、 **requestId** および **userId** ヘッダの値をスレッドコンテキストに設定する。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (リクエストIDの取得)**

スレッドコンテキストから [リクエストID](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#リクエストの識別と業務処理の実行) もしくは
[内部リクエストID](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#特殊なリクエスト処理) を取得する。

**1a. (認可処理のスキップ)**

**1.** 取得したリクエストIDの値が、本ハンドラに設定された **認可対象外リクエストIDリスト** に含まれている場合、
本ハンドラではそれ以上の処理を行なわず、後続ハンドラに処理を委譲し、その結果をリターンして終了する。

**2. (ユーザIDの取得)**

スレッドコンテキストからユーザIDを取得する。

**3. (認可情報取得)**

本ハンドラに設定された **認可情報取得コンポーネント** を用いて、 **2.** で取得したユーザIDに対する
認可情報を取得する。

**4. (認可判定)**

**1.** で取得したリクエストIDが **2.** で取得した認可情報に含まれていることを確認し、
認可情報をスレッドローカルに格納する。

**4a. (認可エラー)**

**1.** で取得したリクエストIDが **2.** で取得した認可情報に含まれていなかった場合は、
後続のハンドラの処理を実行せずに、実行時例外 [Result.Forbidden](../../javadoc/nablarch/fw/Result.Forbidden.html) を送出して終了する。

**5. (後続ハンドラの実行)**

後続のハンドラに処理を委譲し、その結果を取得する。

**[往路での処理]**

**6. (正常終了)**

**5.** で取得した処理結果をリターンし終了する。

**[例外処理]**

**5a. (後続ハンドラの処理でエラー)**

後続ハンドラの実行中にエラーが発生した場合は、そのまま再送出して終了する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。
**認可情報取得コンポーネント** の設定については
[認可](../../component/libraries/libraries-04-Permission.md) の章を参照すること。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| 認可情報取得コンポーネント | permissionFactory | PermissionFactorry | 必須指定 |
| 認可判定対象外リクエストIDリスト | ignoreRequestIds | String[] | 任意指定(デフォルトは空のリスト) |
| 内部リクエストIDによる判定を行うかどうか | usesInternalRequestId | boolean | 任意指定(デフォルト=false) |

**標準設定**

以下は [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) における本ハンドラの設定例である。
[画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) では
**認可判定対象外リクエストIDリスト** にログイン画面に対するリクエストIDを設定する必要がある。

```xml
<!-- 認可チェックハンドラ -->
<component name="permissionCheckHandler"
           class="nablarch.common.handler.PermissionCheckHandler">
  <property name="permissionFactory" ref="permissionFactory" />
  <property name="ignoreRequestIds" value="login001, login002" />
  <property name="usesInternalRequestId" value="true" />
</component>
```
