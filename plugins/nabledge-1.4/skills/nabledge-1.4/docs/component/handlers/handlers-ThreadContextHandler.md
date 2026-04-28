## スレッドコンテキスト変数管理ハンドラ

**クラス名:** `nablarch.common.handler.threadcontext.ThreadContextHandler`

-----

-----

### 概要

本ハンドラでは、スレッドコンテキスト上の各属性値について、設定ファイルの内容に沿った初期化処理を
リクエスト毎に行うハンドラである。

**スレッドコンテキスト** とは、リクエストIDやユーザIDなど、同一の処理スレッド内で共有する値を
スレッドローカル領域上に保持するための仕組みである。

スレッドコンテキスト自体の解説については、 [同一スレッド内でのデータ共有(スレッドコンテキスト)](../../component/libraries/libraries-thread-context.md) を参照すること。

> **Note:**
> 本ハンドラで設定したスレッドローカル上の値は、 [スレッドコンテキスト変数削除ハンドラ](../../component/handlers/handlers-ThreadContextClearHandler.md#threadcontextclearhandler) を使用して、復路処理で削除を行うこと。
> 往路処理にて本ハンドラより手前のハンドラでスレッドコンテキストにアクセスした場合、 値を取得することはできないため本ハンドラより手前ではスレッドコンテキストにアクセスしないよう注意すること。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| スレッドコンテキスト変数削除ハンドラ | nablarch.common.handler.threadcontext.ThreadContextClearHandler | Object | Object | - | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する |
| スレッドコンテキスト変数設定ハンドラ(メインスレッド) | nablarch.common.handler.threadcontext.ThreadContextHandler_main | Object | Object | 起動引数の内容からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。 | - | - |

### ハンドラ処理フロー

**[往路処理]**

**1. (スレッドコンテキストのクリア)**

スレッドローカル上に保持されているスレッドコンテキスト変数のMapの内容を全てクリアする。

**2. (スレッドコンテキスト属性の初期化)**

本ハンドラに設定された **スレッドコンテキスト属性定義リスト** の内容に沿って初期化処理を実行する。

**3. (後続ハンドラの実行)**

ハンドラキュー上の後続ハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

**4. (正常終了)**

**3.** で取得した処理結果オブジェクトをそのままリターンして終了する。

**[例外処理]**

**3a. (エラー終了)**

後続ハンドラの処理中にエラーが発生した場合は、そのまま再送出して終了する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| スレッドコンテキスト属性リスト | attributes | List<ThreadContextAttribute> | 必須指定 |

**基本設定**

以下は標準的なスレッドコンテキストの設定例である。
詳細は、 [同一スレッド内でのデータ共有(スレッドコンテキスト)](../../component/libraries/libraries-thread-context.md) を参照すること。

```xml
<component class="nablarch.common.handler.threadcontext.ThreadContextHandler">
  <property name="attributes">
  <list>
  <!-- リクエストID -->
  <component class="nablarch.common.handler.threadcontext.RequestIdAttribute" />

  <!-- 内部リクエストID -->
  <component class="nablarch.common.handler.threadcontext.InternalRequestIdAttribute" />

  <!-- ユーザID -->
  <component class="nablarch.common.handler.threadcontext.UserIdAttribute">
    <property name="sessionKey"  value="user.id" />
    <property name="anonymousId" value="guest" />
  </component>

  <!-- 言語 -->
  <component class="nablarch.common.handler.threadcontext.LanguageAttribute">
    <property name="defaultLanguage" value="ja" />
  </component>

  <!-- タイムゾーン -->
  <component class="nablarch.common.handler.threadcontext.TimeZoneAttribute">
    <property name="defaultTimeZone" value="Asia/Tokyo" />
  </component>

  <!-- 実行時ID -->
    <component class="nablarch.common.handler.threadcontext.ExecutionIdAttribute" />
  </list>
  </property>
</component>
```
