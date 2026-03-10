# スレッドコンテキスト変数管理ハンドラ

## 概要

スレッドコンテキストの各属性値について、リクエスト毎に初期化処理を行うハンドラ。

**スレッドコンテキスト**とは、リクエストIDやユーザIDなど、同一の処理スレッド内で共有する値をスレッドローカル領域上に保持するための仕組みである。

## ハンドラクラス名

**クラス名**: `nablarch.common.handler.threadcontext.ThreadContextHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw</artifactId>
</dependency>
```

国際化対応で言語やタイムゾーンを選択できる画面を作る場合のみ:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

なし

## リクエスト毎にスレッドコンテキストの初期化を行う

> **重要**: 本ハンドラで設定したスレッドローカル上の値は、:ref:`thread_context_clear_handler` を使用して復路処理で削除すること。往路処理で本ハンドラより手前のハンドラでスレッドコンテキストにアクセスした場合、値を取得できないため、本ハンドラより手前ではスレッドコンテキストにアクセスしないよう注意すること。

> **補足**: 本ハンドラ以外のハンドラや業務アクションから任意の変数をスレッドコンテキストに設定可能。

`ThreadContextAttribute` インタフェースを実装したクラスを使用してスレッドコンテキストを初期化する。デフォルト提供クラスは以下の通り:

**リクエストID / 内部リクエストID**:
- `RequestIdAttribute`
- `InternalRequestIdAttribute` — :ref:`permission_check_handler` や :ref:`ServiceAvailabilityCheckHandler` のような内部リクエストIDに対する処理を行うハンドラを使用する場合に設定する

**ユーザID**:
- `UserIdAttribute`
- `UserIdAttributeInSessionStore`

**言語**:
- `LanguageAttribute`
- `HttpLanguageAttribute`
- `LanguageAttributeInHttpCookie`
- `LanguageAttributeInHttpSession`

**タイムゾーン**:
- `TimeZoneAttribute`
- `TimeZoneAttributeInHttpCookie`
- `TimeZoneAttributeInHttpSession`

**実行時ID**:
- `ExecutionIdAttribute`

設定例:
```xml
<component class="nablarch.common.handler.threadcontext.ThreadContextHandler">
  <property name="attributes">
    <list>
      <component class="nablarch.common.handler.threadcontext.RequestIdAttribute" />
      <component class="nablarch.common.handler.threadcontext.InternalRequestIdAttribute" />
      <component class="nablarch.common.handler.threadcontext.UserIdAttribute">
        <property name="sessionKey" value="user.id" />
        <property name="anonymousId" value="guest" />
      </component>
      <component class="nablarch.common.handler.threadcontext.LanguageAttribute">
        <property name="defaultLanguage" value="ja" />
      </component>
      <component class="nablarch.common.handler.threadcontext.TimeZoneAttribute">
        <property name="defaultTimeZone" value="Asia/Tokyo" />
      </component>
      <component class="nablarch.common.handler.threadcontext.ExecutionIdAttribute" />
    </list>
  </property>
</component>
```

### ユーザIDを設定する

`UserIdAttributeInSessionStore` はデフォルトでセッションストアからユーザIDを取得する。セッションストアへの設定はフレームワークでは実施しないため、ログイン時などにアプリケーションで設定する必要がある。デフォルトのセッションキーは `"user.id"`。上書きする場合は `UserIdAttribute#sessionKey` に値を設定する。

セッションキーを `"login_id"` に変更する設定例:
```xml
<component name="threadContextHandler" class="nablarch.common.handler.threadcontext.ThreadContextHandler">
  <property name="attributes">
    <list>
      <component class="nablarch.common.web.handler.threadcontext.UserIdAttributeInSessionStore">
        <property name="sessionKey" value="login_id"/>
        <property name="anonymousId" value="${nablarch.userIdAttribute.anonymousId}"/>
      </component>
    </list>
  </property>
</component>
```

デフォルトキー (`"user.id"`) でセッションストアにユーザIDを設定する例:
```java
SessionUtil.put(context, "user.id", userId);
```

任意の取得元からユーザIDを取得したい場合は `UserIdAttribute#getUserIdSession` をオーバーライドする。`"userContext"` キーでセッションストアに格納したオブジェクトからユーザIDを取得する実装例:
```java
public class SessionStoreUserIdAttribute extends UserIdAttribute {
    @Override
    protected Object getUserIdSession(ExecutionContext ctx, String skey) {
        LoginUserPrincipal userContext = SessionUtil.orNull(ctx, "userContext");
        if (userContext == null) {
            return null;
        }
        return String.valueOf(userContext.getUserId());
    }
}
```

```xml
<component class="nablarch.common.handler.threadcontext.ThreadContextHandler">
  <property name="attributes">
    <list>
      <component class="com.nablarch.example.proman.web.common.handler.threadcontext.SessionStoreUserIdAttribute">
        <property name="anonymousId" value="${nablarch.userIdAttribute.anonymousId}"/>
      </component>
    </list>
  </property>
</component>
```

## スレッドコンテキストの属性値を設定/取得する

スレッドコンテキストへのアクセスは `ThreadContext` を使用する。

```java
// リクエストIDの取得
String requestId = ThreadContext.getRequestId();
```

## ユーザが言語を選択する画面を作る

国際化対応でユーザが言語を選択できる機能は、`LanguageAttributeInHttpCookie` または `LanguageAttributeInHttpSession` と `LanguageAttributeInHttpUtil` を組み合わせて実現する。

クッキーに言語を保持してリンクで言語を選択させる実装例:

設定例（`LanguageAttributeInHttpUtil` を使用するためコンポーネント名を `"languageAttribute"` にすること）:
```xml
<component name="languageAttribute"
           class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
</component>
```

JSP実装例:
```jsp
<n:submitLink uri="/action/menu/index" name="switchToEnglish">
  英語
  <n:param paramName="user.language" value="en" />
</n:submitLink>
<n:submitLink uri="/action/menu/index" name="switchToJapanese">
  日本語
  <n:param paramName="user.language" value="ja" />
</n:submitLink>
```

ハンドラ実装例（`LanguageAttributeInHttpUtil.keepLanguage()` を呼び出してクッキーとスレッドコンテキストに言語を設定。指定言語がサポート対象外の場合は設定しない）:
```java
public class I18nHandler implements HttpRequestHandler {
    public HttpResponse handle(HttpRequest request, ExecutionContext context) {
        String language = getLanguage(request, "user.language");
        if (StringUtil.hasValue(language)) {
            LanguageAttributeInHttpUtil.keepLanguage(request, context, language);
        }
        return context.handleNext(request);
    }
    private String getLanguage(HttpRequest request, String paramName) {
        if (!request.getParamMap().containsKey(paramName)) {
            return null;
        }
        return request.getParam(paramName)[0];
    }
}
```

## ユーザがタイムゾーンを選択する画面を作る

国際化対応でユーザがタイムゾーンを選択できる機能は、`TimeZoneAttributeInHttpCookie` または `TimeZoneAttributeInHttpSession` と `TimeZoneAttributeInHttpUtil` を組み合わせて実現する。

クッキーにタイムゾーンを保持してリンクでタイムゾーンを選択させる実装例:

設定例（`TimeZoneAttributeInHttpUtil` を使用するためコンポーネント名を `"timeZoneAttribute"` にすること）:
```xml
<component name="timeZoneAttribute"
           class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
</component>
```

JSP実装例:
```jsp
<n:submitLink uri="/action/menu/index" name="switchToNewYork">
  ニューヨーク
  <n:param paramName="user.timeZone" value="America/New_York" />
</n:submitLink>
<n:submitLink uri="/action/menu/index" name="switchToTokyo">
  東京
  <n:param paramName="user.timeZone" value="Asia/Tokyo" />
</n:submitLink>
```

ハンドラ実装例（`TimeZoneAttributeInHttpUtil.keepTimeZone()` を呼び出してクッキーとスレッドコンテキストにタイムゾーンを設定。指定タイムゾーンがサポート対象外の場合は設定しない）:
```java
public class I18nHandler implements HttpRequestHandler {
    public HttpResponse handle(HttpRequest request, ExecutionContext context) {
        String timeZone = getTimeZone(request, "user.timeZone");
        if (StringUtil.hasValue(timeZone)) {
            TimeZoneAttributeInHttpUtil.keepTimeZone(request, context, timeZone);
        }
        return context.handleNext(request);
    }
    private String getTimeZone(HttpRequest request, String paramName) {
        if (!request.getParamMap().containsKey(paramName)) {
            return null;
        }
        return request.getParam(paramName)[0];
    }
}
```
