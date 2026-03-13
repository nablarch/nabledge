# スレッドコンテキスト変数管理ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/thread_context_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/ThreadContextHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/ThreadContextAttribute.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/RequestIdAttribute.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/InternalRequestIdAttribute.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/UserIdAttribute.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/UserIdAttributeInSessionStore.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/LanguageAttribute.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/HttpLanguageAttribute.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/LanguageAttributeInHttpCookie.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/LanguageAttributeInHttpSession.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/TimeZoneAttribute.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/TimeZoneAttributeInHttpCookie.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/TimeZoneAttributeInHttpSession.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/ExecutionIdAttribute.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/LanguageAttributeInHttpUtil.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/TimeZoneAttributeInHttpUtil.html)

## ハンドラクラス名

スレッドコンテキストの各属性値について、リクエスト毎に初期化処理を行うハンドラ。

**クラス名**: `nablarch.common.handler.threadcontext.ThreadContextHandler`

<details>
<summary>keywords</summary>

ThreadContextHandler, nablarch.common.handler.threadcontext.ThreadContextHandler, スレッドコンテキスト変数管理ハンドラ, ハンドラクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw</artifactId>
</dependency>
```

国際化対応で言語やタイムゾーン選択画面を作る場合のみ追加:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw, nablarch-fw-web, モジュール依存関係, 国際化

</details>

## 制約

なし。

<details>
<summary>keywords</summary>

制約, スレッドコンテキスト変数管理ハンドラ制約

</details>

## リクエスト毎にスレッドコンテキストの初期化を行う

> **重要**: 本ハンドラで設定したスレッドローカル上の値は、[thread_context_clear_handler](handlers-thread_context_clear_handler.md) を使用して復路処理で削除すること。本ハンドラより手前のハンドラでスレッドコンテキストにアクセスした場合、値を取得できないため本ハンドラより手前ではスレッドコンテキストにアクセスしないよう注意すること。

> **補足**: 本ハンドラ以外のハンドラや業務アクションから任意の変数を設定可能。

スレッドコンテキストの初期化は `ThreadContextAttribute` インタフェースを実装したクラスで行う。

デフォルト提供クラス:

**リクエストID・内部リクエストID**
- `RequestIdAttribute`
- `InternalRequestIdAttribute` ※ :ref:`permission_check_handler` や :ref:`ServiceAvailabilityCheckHandler` のような内部リクエストIDに対する処理を実施するハンドラを使用する場合に設定する

**ユーザID**
- `UserIdAttribute`
- `UserIdAttributeInSessionStore`

**言語**
- `LanguageAttribute`
- `HttpLanguageAttribute`
- `LanguageAttributeInHttpCookie`
- `LanguageAttributeInHttpSession`

**タイムゾーン**
- `TimeZoneAttribute`
- `TimeZoneAttributeInHttpCookie`
- `TimeZoneAttributeInHttpSession`

**実行時ID**
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

`UserIdAttributeInSessionStore` はデフォルトでセッションストアからユーザIDを取得する。セッションストアへの設定はフレームワークでは実施しないため、ログイン時などにアプリケーションで設定する必要がある。デフォルトキーは `"user.id"`。

キーを上書きするには `UserIdAttribute#sessionKey` に値を設定する。`"login_id"` に上書きする設定例:
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

デフォルトキーでセッションストアにユーザIDを設定する実装例:
```java
SessionUtil.put(context, "user.id", userId);
```

ログイン情報をまとめて格納したい場合は `UserIdAttribute#getUserIdSession` をオーバーライドすることで任意の取得元からユーザIDを取得できる:
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

<details>
<summary>keywords</summary>

ThreadContextAttribute, RequestIdAttribute, InternalRequestIdAttribute, UserIdAttribute, UserIdAttributeInSessionStore, LanguageAttribute, HttpLanguageAttribute, LanguageAttributeInHttpCookie, LanguageAttributeInHttpSession, TimeZoneAttribute, TimeZoneAttributeInHttpCookie, TimeZoneAttributeInHttpSession, ExecutionIdAttribute, スレッドコンテキスト初期化, ユーザID設定, sessionKey, getUserIdSession, セッションストア, anonymousId, SessionUtil

</details>

## スレッドコンテキストの属性値を設定/取得する

スレッドコンテキストへのアクセスは `ThreadContext` を使用する。

```java
// リクエストIDの取得
String requestId = ThreadContext.getRequestId();
```

<details>
<summary>keywords</summary>

ThreadContext, nablarch.core.ThreadContext, getRequestId, スレッドコンテキスト取得, 属性値取得

</details>

## ユーザが言語を選択する画面を作る

言語選択には `LanguageAttributeInHttpCookie` または `LanguageAttributeInHttpSession` と `LanguageAttributeInHttpUtil` を使用する。

> **重要**: `LanguageAttributeInHttpUtil` を使用するため、コンポーネント名を `"languageAttribute"` にする。

設定例:
```xml
<component name="languageAttribute"
           class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
</component>
```

JSPの実装例:
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

ハンドラの実装例（複数画面で言語選択させる場合を想定）:
```java
public class I18nHandler implements HttpRequestHandler {
    public HttpResponse handle(HttpRequest request, ExecutionContext context) {
        String language = getLanguage(request, "user.language");
        if (StringUtil.hasValue(language)) {
            // クッキーとスレッドコンテキストに選択言語を設定。サポート対象外の場合は設定しない。
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

<details>
<summary>keywords</summary>

LanguageAttributeInHttpCookie, LanguageAttributeInHttpSession, LanguageAttributeInHttpUtil, 言語選択, 国際化, languageAttribute, keepLanguage, supportedLanguages, StringUtil

</details>

## ユーザがタイムゾーンを選択する画面を作る

タイムゾーン選択には `TimeZoneAttributeInHttpCookie` または `TimeZoneAttributeInHttpSession` と `TimeZoneAttributeInHttpUtil` を使用する。

> **重要**: `TimeZoneAttributeInHttpUtil` を使用するため、コンポーネント名を `"timeZoneAttribute"` にする。

設定例:
```xml
<component name="timeZoneAttribute"
           class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
</component>
```

JSPの実装例:
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

ハンドラの実装例（複数画面でタイムゾーン選択させる場合を想定）:
```java
public class I18nHandler implements HttpRequestHandler {
    public HttpResponse handle(HttpRequest request, ExecutionContext context) {
        String timeZone = getTimeZone(request, "user.timeZone");
        if (StringUtil.hasValue(timeZone)) {
            // クッキーとスレッドコンテキストに選択タイムゾーンを設定。サポート対象外の場合は設定しない。
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

<details>
<summary>keywords</summary>

TimeZoneAttributeInHttpCookie, TimeZoneAttributeInHttpSession, TimeZoneAttributeInHttpUtil, タイムゾーン選択, 国際化, timeZoneAttribute, keepTimeZone, supportedTimeZones, StringUtil

</details>
