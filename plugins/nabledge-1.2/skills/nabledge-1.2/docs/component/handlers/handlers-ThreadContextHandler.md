# スレッドコンテキスト変数管理ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.threadcontext.ThreadContextHandler`

リクエスト毎にスレッドコンテキスト上の各属性値を設定ファイルの内容に沿って初期化するハンドラ。

**スレッドコンテキスト**: リクエストIDやユーザIDなど、同一の処理スレッド内で共有する値をスレッドローカル領域上に保持する仕組み。

> **注意**: 本ハンドラで設定したスレッドローカル上の値は、:ref:`ThreadContextClearHandler` を使用して、復路処理で削除すること。往路処理にて本ハンドラより手前のハンドラでスレッドコンテキストにアクセスした場合、値を取得できないため、本ハンドラより手前ではスレッドコンテキストにアクセスしないこと。

<details>
<summary>keywords</summary>

ThreadContextHandler, nablarch.common.handler.threadcontext.ThreadContextHandler, ThreadContextClearHandler, スレッドコンテキスト, リクエスト毎の属性初期化, スレッドローカル

</details>

## ハンドラ処理フロー

**[往路処理]**
1. スレッドローカル上のスレッドコンテキスト変数のMapを全てクリア
2. 設定された**スレッドコンテキスト属性定義リスト**の内容に沿って初期化処理を実行
3. 後続ハンドラに処理を委譲し、結果を取得

**[復路処理]**

4. 処理結果オブジェクトをそのままリターンして終了

**[例外処理]**

3a. 後続ハンドラでエラーが発生した場合、そのまま再送出して終了

<details>
<summary>keywords</summary>

ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, スレッドコンテキスト初期化フロー

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| attributes | List\<ThreadContextAttribute\> | ○ | | スレッドコンテキスト属性リスト |

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
      <property name="sessionKey" value="user.id" />
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

<details>
<summary>keywords</summary>

attributes, ThreadContextAttribute, RequestIdAttribute, InternalRequestIdAttribute, UserIdAttribute, LanguageAttribute, TimeZoneAttribute, ExecutionIdAttribute, スレッドコンテキスト属性設定, XML設定例

</details>
