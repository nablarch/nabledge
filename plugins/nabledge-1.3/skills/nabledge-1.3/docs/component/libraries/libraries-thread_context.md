# 同一スレッド内でのデータ共有(スレッドコンテキスト)

## 同一スレッド内でのデータ共有(スレッドコンテキスト)

スレッドコンテキストはスレッドローカル変数上に保持された変数スコープ。ユーザIDやリクエストIDなど、実行コンテキストを経由した引き回しが難しいパラメータを格納する。設定の多くは [../handler/ThreadContextHandler](../handlers/handlers-ThreadContextHandler.md) によって行われるが、それ以外のハンドラでもスレッドコンテキストに変数を設定するものが存在するほか、業務アクションハンドラから任意の変数を設定することも可能。

**子スレッドへの値の引き継ぎ**:
- 親スレッドで保持する値は暗黙的に子スレッドに引き継がれる
- 子スレッドで値を変更する場合は、明示的に子スレッドで値を設定する必要がある

## LanguageAttribute

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultLanguage | String | | システムデフォルトロケール | システムで使用するデフォルト言語 |

## HttpLanguageAttribute

**クラス**: `nablarch.common.web.handler.threadcontext.HttpLanguageAttribute`

```xml
<component class="nablarch.common.web.handler.threadcontext.HttpLanguageAttribute">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
</component>
```

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultLanguage | String | | システムデフォルトロケール | システムで使用するデフォルト言語 |
| supportedLanguages | String配列 | ○ | | サポート対象言語 |

## LanguageAttributeInHttpCookie

**クラス**: `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie`

```xml
<component class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
  <property name="cookieName" value="app_language" />
  <property name="cookiePath" value="/action/" />
  <property name="cookieDomain" value="localhost" />
  <property name="cookieMaxAge" value="300" />
</component>
```

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultLanguage | String | | システムデフォルトロケール | システムで使用するデフォルト言語 |
| supportedLanguages | String配列 | ○ | | サポート対象言語 |
| cookieName | String | | `nablarch_language` | 言語保持クッキーの名前 |
| cookiePath | String | | コンテキストパス | クッキー送信URIのパス階層 |
| cookieDomain | String | | リクエストURLのドメイン名 | クッキー送信のドメイン階層 |
| cookieMaxAge | int | | ブラウザ終了まで | クッキーの最長存続期間（秒） |
| cookieSecure | boolean | | false（secure属性なし） | クッキーのsecure属性有無 |

`LanguageAttributeInHttpUtil`を使用する場合、コンポーネント名を`languageAttribute`にする必要がある。

`keepLanguage(request, context, language)`はクッキーとスレッドコンテキストの両方に言語を設定する。指定言語がサポート対象外の場合は設定されない。

設定例（コンポーネント名`languageAttribute`で登録）：
```xml
<component name="languageAttribute"
           class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
</component>
```

JSP実装例（`n:submitLink` + `n:param`でリンクごとに言語送信）：
```jsp
<n:submitLink uri="/action/MenuAction/MENU00101" name="switchToEnglish">
  英語
  <n:param paramName="user.language" value="en" />
</n:submitLink>
<n:submitLink uri="/action/MenuAction/MENU00101" name="switchToJapanese">
  日本語
  <n:param paramName="user.language" value="ja" />
</n:submitLink>
```

ハンドラ実装例：
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

> **注意**: `I18nHandler`は共通ハンドラのため`getParamMap`/`getParam`で直接リクエストパラメータにアクセスしている。業務アクションではバリデーション機能でリクエストパラメータを取得すること。

## LanguageAttributeInHttpSession

**クラス**: `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession`

```xml
<component class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
  <property name="sessionKey" value="app_language" />
</component>
```

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultLanguage | String | | システムデフォルトロケール | システムで使用するデフォルト言語 |
| supportedLanguages | String配列 | ○ | | サポート対象言語 |
| sessionKey | String | | `LanguageAttribute.getKey()`の戻り値 | 言語を格納するセッションキー名 |

`LanguageAttributeInHttpUtil`を使用する場合、コンポーネント名を`languageAttribute`にする必要がある。

ログイン処理でHTTPセッションに言語を設定する実装例：
```xml
<component name="languageAttribute"
           class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
</component>
```
```java
public HttpResponse doLOGIN00101(HttpRequest request, ExecutionContext context) {
    String language = // データベースからの取得処理は省略
    LanguageAttributeInHttpUtil.keepLanguage(request, context, language);
    return new HttpResponse("/MENU00101.jsp");
}
```

<details>
<summary>keywords</summary>

スレッドコンテキスト, ThreadContextHandler, 子スレッド, スレッドローカル変数, リクエストID, ユーザID, データ共有, HttpLanguageAttribute, LanguageAttributeInHttpCookie, LanguageAttributeInHttpSession, LanguageAttributeInHttpUtil, I18nHandler, defaultLanguage, supportedLanguages, cookieName, cookiePath, cookieDomain, cookieMaxAge, cookieSecure, sessionKey, keepLanguage, 多言語対応, 言語切り替え, クッキーで言語保持, セッションで言語保持

</details>

## インタフェース定義

**インタフェース**: `nablarch.common.handler.threadcontext.ThreadContextAttribute`

スレッドコンテキストに属性を設定するインタフェース。実装クラスはコンテキストから属性値を取得する責務を持つ。

## TimeZoneAttribute

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultTimeZone | String | | システムデフォルトタイムゾーン | システムで使用するデフォルトタイムゾーン |

## TimeZoneAttributeInHttpCookie

**クラス**: `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie`

```xml
<component class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
  <property name="cookieName" value="app_timeZone" />
  <property name="cookiePath" value="/action/" />
  <property name="cookieDomain" value="localhost" />
  <property name="cookieMaxAge" value="300" />
</component>
```

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultTimeZone | String | | システムデフォルトタイムゾーン | システムで使用するデフォルトタイムゾーン |
| supportedTimeZones | String配列 | ○ | | サポート対象タイムゾーン |
| cookieName | String | | `nablarch_timeZone` | タイムゾーン保持クッキーの名前 |
| cookiePath | String | | コンテキストパス | クッキー送信URIのパス階層 |
| cookieDomain | String | | リクエストURLのドメイン名 | クッキー送信のドメイン階層 |
| cookieMaxAge | int | | ブラウザ終了まで | クッキーの最長存続期間（秒） |
| cookieSecure | boolean | | false（secure属性なし） | クッキーのsecure属性有無 |

`TimeZoneAttributeInHttpUtil`を使用する場合、コンポーネント名を`timeZoneAttribute`にする必要がある。

`keepTimeZone(request, context, timeZone)`はクッキーとスレッドコンテキストの両方にタイムゾーンを設定する。指定タイムゾーンがサポート対象外の場合は設定されない。

設定例（コンポーネント名`timeZoneAttribute`で登録）：
```xml
<component name="timeZoneAttribute"
           class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
</component>
```

JSP実装例（`n:submitLink` + `n:param`でリンクごとにタイムゾーン送信）：
```jsp
<n:submitLink uri="/action/MenuAction/MENU00101" name="switchToNewYork">
  ニューヨーク
  <n:param paramName="user.timeZone" value="America/New_York" />
</n:submitLink>
<n:submitLink uri="/action/MenuAction/MENU00101" name="switchToTokyo">
  東京
  <n:param paramName="user.timeZone" value="Asia/Tokyo" />
</n:submitLink>
```

ハンドラ実装例：
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

> **注意**: `I18nHandler`は共通ハンドラのため`getParamMap`/`getParam`で直接リクエストパラメータにアクセスしている。業務アクションではバリデーション機能でリクエストパラメータを取得すること。

## TimeZoneAttributeInHttpSession

**クラス**: `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession`

```xml
<component class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
  <property name="sessionKey" value="app_timeZone" />
</component>
```

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultTimeZone | String | | システムデフォルトタイムゾーン | システムで使用するデフォルトタイムゾーン |
| supportedTimeZones | String配列 | ○ | | サポート対象タイムゾーン |
| sessionKey | String | | `TimeZoneAttribute.getKey()`の戻り値 | タイムゾーンを格納するセッションキー名 |

`TimeZoneAttributeInHttpUtil`を使用する場合、コンポーネント名を`timeZoneAttribute`にする必要がある。

ログイン処理でHTTPセッションにタイムゾーンを設定する実装例：
```xml
<component name="timeZoneAttribute"
           class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
</component>
```
```java
public HttpResponse doLOGIN00101(HttpRequest request, ExecutionContext context) {
    String timeZone = // データベースからの取得処理は省略
    TimeZoneAttributeInHttpUtil.keepTimeZone(request, context, timeZone);
    return new HttpResponse("/MENU00101.jsp");
}
```

<details>
<summary>keywords</summary>

ThreadContextAttribute, スレッドコンテキスト属性インタフェース, TimeZoneAttributeInHttpCookie, TimeZoneAttributeInHttpSession, TimeZoneAttributeInHttpUtil, I18nHandler, defaultTimeZone, supportedTimeZones, cookieName, cookiePath, cookieDomain, cookieMaxAge, cookieSecure, sessionKey, keepTimeZone, タイムゾーン切り替え, クッキーでタイムゾーン保持, セッションでタイムゾーン保持

</details>

## クラス定義

## クラス一覧

| クラス名 | 概要 |
|---|---|
| `nablarch.common.handler.threadcontext.ThreadContextHandler` | スレッドコンテキストを初期化するハンドラ |
| `nablarch.common.handler.threadcontext.RequestIdAttribute` | [リクエストID](../../about/about-nablarch/about-nablarch-concept.md) をスレッドコンテキストに設定するThreadContextAttribute |
| `nablarch.common.handler.threadcontext.InternalRequestIdAttribute` | [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) をリクエストIDと同じ値に初期設定する |
| `nablarch.common.handler.threadcontext.UserIdAttribute` | ログインユーザのユーザIDをスレッドコンテキストに設定する。未ログイン時は未認証ユーザIDを設定する |
| `nablarch.common.handler.threadcontext.LanguageAttribute` | 言語をスレッドコンテキストに設定するThreadContextAttribute |
| `nablarch.common.handler.threadcontext.TimeZoneAttribute` | タイムゾーンをスレッドコンテキストに設定するThreadContextAttribute |
| `nablarch.common.handler.threadcontext.ExecutionIdAttribute` | 実行時IDをスレッドコンテキストに設定するThreadContextAttribute（[execution_id](../../about/about-nablarch/about-nablarch-concept.md) 参照） |

**LanguageAttributeのサブクラスとユーティリティ**

| クラス名 | 概要 |
|---|---|
| `nablarch.common.web.handler.threadcontext.HttpLanguageAttribute` | HTTPヘッダ(Accept-Language)から言語を取得するThreadContextAttribute |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSupport` | HTTP上で言語の選択と保持を行うThreadContextAttributeの実装サポートクラス |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie` | クッキーを使用して言語を保持するThreadContextAttribute |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession` | HTTPセッションを使用して言語を保持するThreadContextAttribute |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpUtil` | ユーザが選択した言語を保持する処理を提供するユーティリティクラス |

**TimeZoneAttributeのサブクラスとユーティリティ**

| クラス名 | 概要 |
|---|---|
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSupport` | HTTP上で選択されたタイムゾーンの保持を行うThreadContextAttributeの実装サポートクラス |
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie` | クッキーを使用してタイムゾーンを保持するThreadContextAttribute |
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession` | HTTPセッションを使用してタイムゾーンを保持するThreadContextAttribute |
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpUtil` | ユーザが選択したタイムゾーンを保持する処理を提供するユーティリティクラス |

設定値は存在しない。

<details>
<summary>keywords</summary>

ThreadContextHandler, RequestIdAttribute, InternalRequestIdAttribute, UserIdAttribute, LanguageAttribute, TimeZoneAttribute, ExecutionIdAttribute, HttpLanguageAttribute, LanguageAttributeInHttpCookie, LanguageAttributeInHttpSession, LanguageAttributeInHttpUtil, LanguageAttributeInHttpSupport, TimeZoneAttributeInHttpCookie, TimeZoneAttributeInHttpSession, TimeZoneAttributeInHttpUtil, TimeZoneAttributeInHttpSupport, 設定項目なし, 実行ID

</details>

## 使用方法

ThreadContextHandlerはリクエスト毎にスレッドコンテキストを初期化する。実際の属性値取得はThreadContextAttributeインタフェース実装クラスが担う。

フレームワーク提供のThreadContextAttribute実装クラスが設定する属性: [リクエストID](../../about/about-nablarch/about-nablarch-concept.md) / [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) / ユーザID / 言語 / タイムゾーン / [実行時ID](../../about/about-nablarch/about-nablarch-concept.md)

**ThreadContextHandler以外による属性更新状況**:

| 属性 | 更新される状況 |
|---|---|
| [リクエストID](../../about/about-nablarch/about-nablarch-concept.md) | [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) のみ、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) によって更新される |
| [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) | [../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) では内部フォーワード時に [../handler/ForwardingHandler](../handlers/handlers-ForwardingHandler.md) によって更新される。[../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) では [../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) によって更新される |
| ユーザID | [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) のみ、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) によって更新される |

### RequestIdAttribute

URLの最後の"/"から"."の間の文字列をリクエストIDと判断する。

### InternalRequestIdAttribute

スレッドコンテキスト変数 [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) を [リクエストID](../../about/about-nablarch/about-nablarch-concept.md) と同じ値に初期化する。

### UserIdAttribute

HttpセッションからユーザIDを取得してスレッドコンテキストに設定する。取得できなかった場合は未ログインユーザとして扱い、特別なユーザIDを設定する。

> **注意**: 認証処理ではセッションにユーザIDを設定しておく必要がある。セッションキーと未ログインユーザIDはプロパティで変更可能。

### ExecutionIdAttribute

実行時IDをスレッドコンテキストに設定する。[execution_id](../../about/about-nablarch/about-nablarch-concept.md) 参照。

### 設定例

```xml
<component class="nablarch.common.handler.threadcontext.ThreadContextHandler">
  <property name="attributes">
    <list>
      <component class="nablarch.common.handler.threadcontext.UserIdAttribute">
        <property name="sessionKey" value="user.id" />
        <property name="anonymousId" value="guest" />
      </component>
      <component class="nablarch.common.handler.threadcontext.RequestIdAttribute" />
      <component class="nablarch.common.handler.threadcontext.InternalRequestIdAttribute" />
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

<details>
<summary>keywords</summary>

ThreadContextHandler, 属性更新, RequestIdAttribute, InternalRequestIdAttribute, UserIdAttribute, ExecutionIdAttribute, FwHeaderReader, ForwardingHandler, 設定例

</details>

## LanguageAttributeの選択

**LanguageAttributeおよびサブクラスの説明**:

| クラス名 | 説明 |
|---|---|
| `LanguageAttribute` | リポジトリの設定で指定された言語をスレッドコンテキストに設定する。未指定の場合、システムデフォルトロケールを使用 |
| `HttpLanguageAttribute` | HTTPヘッダ(Accept-Language)から取得した言語を設定する。サポート対象言語が取得できない場合はLanguageAttributeに委譲 |
| `LanguageAttributeInHttpCookie` | クッキーを使用した言語の保持。サポート対象言語が取得できない場合はHttpLanguageAttributeに委譲 |
| `LanguageAttributeInHttpSession` | HTTPセッションを使用した言語の保持。具体的な処理はLanguageAttributeInHttpCookieと同じ |
| `LanguageAttributeInHttpUtil` | LanguageAttributeInHttpSupportのサブクラスを使用するアプリに対して、ユーザが選択した言語を保持する処理を提供する |

**選択基準**:

| クラス名 | 言語の選択 | 言語の保存 | 説明 |
|---|---|---|---|
| `LanguageAttribute` | なし | なし | 国際化なし。言語は固定。アプリ実装不要 |
| `HttpLanguageAttribute` | ブラウザの言語設定 | ブラウザの言語設定 | ブラウザの言語設定に応じて切り替え。ログイン前でも有効。アプリ実装不要 |
| `LanguageAttributeInHttpCookie` | 選択画面やリンクなど | クッキー | アプリが言語選択画面を提供する場合。ログイン前でも有効。ブラウザ毎に保持 |
| `LanguageAttributeInHttpSession` | 選択画面やリンクなど | データベース | アプリが言語選択画面を提供する場合。ユーザ毎に保持。ログイン後のみ有効 |

> **注意**: `LanguageAttributeInHttpUtil` を使用する場合は、リポジトリにLanguageAttributeInHttpSupportのサブクラスを `"languageAttribute"` という名前で登録する必要がある。

<details>
<summary>keywords</summary>

LanguageAttribute, HttpLanguageAttribute, LanguageAttributeInHttpCookie, LanguageAttributeInHttpSession, LanguageAttributeInHttpUtil, LanguageAttributeInHttpSupport, 言語設定, 国際化, defaultLanguage

</details>

## TimeZoneAttributeの選択

**TimeZoneAttributeおよびサブクラスの説明**:

| クラス名 | 説明 |
|---|---|
| `TimeZoneAttribute` | リポジトリの設定で指定されたタイムゾーンをスレッドコンテキストに設定する。未指定の場合、システムデフォルトタイムゾーンを使用 |
| `TimeZoneAttributeInHttpCookie` | クッキーを使用したタイムゾーンの保持。サポート対象タイムゾーンが取得できない場合はTimeZoneAttributeに委譲 |
| `TimeZoneAttributeInHttpSession` | HTTPセッションを使用したタイムゾーンの保持。具体的な処理はTimeZoneAttributeInHttpCookieと同じ |
| `TimeZoneAttributeInHttpUtil` | TimeZoneAttributeInHttpSupportのサブクラスを使用するアプリに対して、ユーザが選択したタイムゾーンを保持する処理を提供する |

**選択基準**:

| クラス名 | タイムゾーンの選択 | タイムゾーンの保存 | 説明 |
|---|---|---|---|
| `TimeZoneAttribute` | なし | なし | 国際化なし。タイムゾーンは固定。アプリ実装不要 |
| `TimeZoneAttributeInHttpCookie` | 選択画面やリンクなど | クッキー | アプリがタイムゾーン選択画面を提供する場合。ログイン前でも有効。ブラウザ毎に保持 |
| `TimeZoneAttributeInHttpSession` | 選択画面やリンクなど | データベース | アプリがタイムゾーン選択画面を提供する場合。ユーザ毎に保持。ログイン後のみ有効 |

> **注意**: `TimeZoneAttributeInHttpUtil` を使用する場合は、リポジトリにTimeZoneAttributeInHttpSupportのサブクラスを `"timeZoneAttribute"` という名前で登録する必要がある。

<details>
<summary>keywords</summary>

TimeZoneAttribute, TimeZoneAttributeInHttpCookie, TimeZoneAttributeInHttpSession, TimeZoneAttributeInHttpUtil, TimeZoneAttributeInHttpSupport, タイムゾーン設定, 国際化, defaultTimeZone

</details>

## ThreadContextHandlerの設定

**クラス**: `nablarch.common.handler.threadcontext.ThreadContextHandler`

| プロパティ名 | 説明 |
|---|---|
| attributes | ThreadContextAttributeインタフェースを実装したクラスのリストを設定する |

<details>
<summary>keywords</summary>

ThreadContextHandler, attributes, ThreadContextAttribute設定

</details>

## UserIdAttributeの設定

**クラス**: `nablarch.common.handler.threadcontext.UserIdAttribute`

| プロパティ名 | 説明 |
|---|---|
| sessionKey | セッションからユーザIDを取得する際のキーを設定する。設定しなかった場合、"USER_ID"がキーとして使用される |
| anonymousId | 未ログインユーザに対して設定するユーザIDを設定する。設定しなかった場合、未ログインユーザに対するユーザIDは設定されない |

<details>
<summary>keywords</summary>

UserIdAttribute, sessionKey, anonymousId, ユーザID設定, 未ログインユーザ

</details>

## RequestIdAttributeの設定

**クラス**: `nablarch.common.handler.threadcontext.RequestIdAttribute`

設定プロパティなし。

<details>
<summary>keywords</summary>

RequestIdAttribute, リクエストID設定, 設定プロパティなし

</details>

## InternalRequestIdAttributeの設定

**クラス**: `nablarch.common.handler.threadcontext.InternalRequestIdAttribute`

設定プロパティなし。

<details>
<summary>keywords</summary>

InternalRequestIdAttribute, 内部リクエストID設定, 設定プロパティなし

</details>
