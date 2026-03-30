# 同一スレッド内でのデータ共有(スレッドコンテキスト)

**公式ドキュメント**: [同一スレッド内でのデータ共有(スレッドコンテキスト)]()

## 同一スレッド内でのデータ共有(スレッドコンテキスト)

スレッドコンテキストは、スレッドローカル変数上に保持された変数スコープ。ユーザIDやリクエストIDのように、ログ出力やDB共通項目への設定などで実行コンテキストを経由した引き回しが難しいパラメータを格納する。

> **注意**: カレントスレッドで子スレッドを起動した場合、本クラスの値は暗黙的に子スレッドに引き継がれる。子スレッドで値を変更する場合は、明示的に子スレッドにて設定する必要がある。

![スレッドコンテキストクラス図](../../../knowledge/component/libraries/assets/libraries-thread_context/thread_context.jpg)

フレームワーク提供のThreadContextAttribute実装クラスが設定する属性:
- [リクエストID](../../about/about-nablarch/about-nablarch-concept.md)
- [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md)
- ユーザID
- 言語
- タイムゾーン
- [実行時ID](../../about/about-nablarch/about-nablarch-concept.md)

## ThreadContextHandler以外での属性更新状況

| 属性 | 更新箇所 |
|---|---|
| [リクエストID](../../about/about-nablarch/about-nablarch-concept.md) | [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) のみ、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) によって更新 |
| [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) | [../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) では内部フォーワード時に [../handler/ForwardingHandler](../handlers/handlers-ForwardingHandler.md) によって更新。[../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) では [../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) によって更新 |
| ユーザID | [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) のみ、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) によって更新 |

**クラス**: `nablarch.common.web.handler.threadcontext.HttpLanguageAttribute`, `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie`, `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession`

### LanguageAttribute（基底）プロパティ

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| defaultLanguage | | システムのデフォルトロケール | デフォルトの言語（文字列） |

### HttpLanguageAttribute

```xml
<component class="nablarch.common.web.handler.threadcontext.HttpLanguageAttribute">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
</component>
```

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| defaultLanguage | | システムのデフォルトロケール | デフォルトの言語 |
| supportedLanguages | ○ | | サポート対象の言語（文字列配列） |

### LanguageAttributeInHttpCookie

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

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| defaultLanguage | | システムのデフォルトロケール | デフォルトの言語 |
| supportedLanguages | ○ | | サポート対象の言語（文字列配列） |
| cookieName | | nablarch_language | 言語を保持するクッキー名 |
| cookiePath | | コンテキストパス | クッキーが送信されるURIパス階層 |
| cookieDomain | | リクエストURLのドメイン名 | クッキーが送信されるドメイン階層 |
| cookieMaxAge | | ブラウザ終了まで | クッキーの最長存続期間（秒） |
| cookieSecure | | secure属性なし | クッキーのsecure属性有無 |

`LanguageAttributeInHttpUtil`を使用するには、コンポーネント名を`languageAttribute`にする必要がある。

```xml
<!-- LanguageAttributeInHttpUtilを使用するため、
     コンポーネント名を"languageAttribute"にする。-->
<component name="languageAttribute"
           class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
</component>
```

**JSPの実装例**（`n:submitLink`タグでリンクを出力し、`n:param`タグでリンク毎に別々の言語を送信する）:

```jsp
<%-- n:submitLinkタグを使用しリンクを出力し、
     n:paramタグを使用しリンク毎に別々の言語を送信する。 --%>
<n:submitLink uri="/action/MenuAction/MENU00101" name="switchToEnglish">
  英語
  <n:param paramName="user.language" value="en" />
</n:submitLink>
<n:submitLink uri="/action/MenuAction/MENU00101" name="switchToJapanese">
  日本語
  <n:param paramName="user.language" value="ja" />
</n:submitLink>
```

**ハンドラの実装例**（複数画面でユーザに言語を選択させる場合を想定し、ハンドラとして実装する）:

```java
// ユーザが選択した言語の保持を行うハンドラ。
// 複数画面でユーザに言語を選択させる場合を想定しハンドラとして実装する。
public class I18nHandler implements HttpRequestHandler {

    public HttpResponse handle(HttpRequest request, ExecutionContext context) {
        String language = getLanguage(request, "user.language");
        if (StringUtil.hasValue(language)) {

            // LanguageAttributeInHttpUtilのkeepLanguageメソッドを呼び出し、
            // クッキーに選択された言語を設定する。
            // スレッドコンテキストにも言語が設定される。
            // 指定された言語がサポート対象の言語でない場合は、
            // クッキーとスレッドコンテキストへの設定を行わない。
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

> **注意**: `I18nHandler`はアプリケーションの共通ハンドラとして使用することを想定しているため、`HttpRequest`の`getParamMap`メソッドと`getParam`メソッドを使用して直接リクエストパラメータにアクセスしている。業務機能を提供する画面をアクションで実装する場合は、バリデーション機能を使用してリクエストパラメータを取得すること。

### LanguageAttributeInHttpSession

```xml
<component class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
  <property name="sessionKey" value="app_language" />
</component>
```

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| defaultLanguage | | システムのデフォルトロケール | デフォルトの言語 |
| supportedLanguages | ○ | | サポート対象の言語（文字列配列） |
| sessionKey | | LanguageAttribute.getKey()の戻り値 | 言語が格納されるセッションキー名 |

`LanguageAttributeInHttpUtil`を使用するには、コンポーネント名を`languageAttribute`にする必要がある。

```xml
<!-- LanguageAttributeInHttpUtilを使用するため、
     コンポーネント名を"languageAttribute"にする。-->
<component name="languageAttribute"
           class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
</component>
```

ログイン処理でユーザに紐づく言語をHTTPセッションに設定するアクションの実装例:

```java
public HttpResponse doLOGIN00101(HttpRequest request, ExecutionContext context) {

    // ログイン処理は省略。
    // 認証に成功した場合の処理を以下に示す。

    // ログインユーザに紐づく言語を取得する。
    String language = // データベースからの取得処理は省略

    // LanguageAttributeInHttpUtilのkeepLanguageメソッドを呼び出し、
    // HTTPセッションに言語を設定する。
    // スレッドコンテキストにも言語が設定される。
    LanguageAttributeInHttpUtil.keepLanguage(request, context, language);

    return new HttpResponse("/MENU00101.jsp");
}
```

<details>
<summary>keywords</summary>

スレッドコンテキスト, ThreadContextHandler, ThreadContextAttribute, 子スレッド値継承, リクエストID, ユーザID, 言語, タイムゾーン, 実行時ID, FwHeaderReader, ForwardingHandler, HttpLanguageAttribute, LanguageAttributeInHttpCookie, LanguageAttributeInHttpSession, LanguageAttributeInHttpUtil, defaultLanguage, supportedLanguages, cookieName, cookiePath, cookieDomain, cookieMaxAge, cookieSecure, sessionKey, keepLanguage, 言語設定, 多言語対応, クッキーで言語保持, セッションで言語保持, n:submitLink, n:param, I18nHandler, 言語切替, HttpRequestHandler

</details>

## インタフェース定義

**インタフェース**: `nablarch.common.handler.threadcontext.ThreadContextAttribute`

スレッドコンテキストに属性を設定するインタフェース。このインタフェースを実装したクラスはコンテキストから属性値を取得する責務を持つ。

**クラス**: `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie`, `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession`

### TimeZoneAttribute（基底）プロパティ

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| defaultTimeZone | | システムのデフォルトタイムゾーン | デフォルトのタイムゾーン（文字列） |

### TimeZoneAttributeInHttpCookie

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

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| defaultTimeZone | | システムのデフォルトタイムゾーン | デフォルトのタイムゾーン |
| supportedTimeZones | ○ | | サポート対象のタイムゾーン（文字列配列） |
| cookieName | | nablarch_timeZone | タイムゾーンを保持するクッキー名 |
| cookiePath | | コンテキストパス | クッキーが送信されるURIパス階層 |
| cookieDomain | | リクエストURLのドメイン名 | クッキーが送信されるドメイン階層 |
| cookieMaxAge | | ブラウザ終了まで | クッキーの最長存続期間（秒） |
| cookieSecure | | secure属性なし | クッキーのsecure属性有無 |

`TimeZoneAttributeInHttpUtil`を使用するには、コンポーネント名を`timeZoneAttribute`にする必要がある。

```xml
<!-- TimeZoneAttributeInHttpUtilを使用するため、
     コンポーネント名を"timeZoneAttribute"にする。-->
<component name="timeZoneAttribute"
           class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
</component>
```

**JSPの実装例**（`n:submitLink`タグでリンクを出力し、`n:param`タグでリンク毎に別々のタイムゾーンを送信する）:

```jsp
<%-- n:submitLinkタグを使用しリンクを出力し、
     n:paramタグを使用しリンク毎に別々のタイムゾーンを送信する。 --%>
<n:submitLink uri="/action/MenuAction/MENU00101" name="switchToNewYork">
  ニューヨーク
  <n:param paramName="user.timeZone" value="America/New_York" />
</n:submitLink>
<n:submitLink uri="/action/MenuAction/MENU00101" name="switchToTokyo">
  東京
  <n:param paramName="user.timeZone" value="Asia/Tokyo" />
</n:submitLink>
```

**ハンドラの実装例**（複数画面でユーザにタイムゾーンを選択させる場合を想定し、ハンドラとして実装する）:

```java
// ユーザが選択したタイムゾーンの保持を行うハンドラ。
// 複数画面でユーザにタイムゾーンを選択させる場合を想定しハンドラとして実装する。
public class I18nHandler implements HttpRequestHandler {

    public HttpResponse handle(HttpRequest request, ExecutionContext context) {
        String timeZone = getTimeZone(request, "user.timeZone");
        if (StringUtil.hasValue(timeZone)) {

            // TimeZoneAttributeInHttpUtilのkeepTimeZoneメソッドを呼び出し、
            // クッキーに選択されたタイムゾーンを設定する。
            // スレッドコンテキストにもタイムゾーンが設定される。
            // 指定されたタイムゾーンがサポート対象のタイムゾーンでない場合は、
            // クッキーとスレッドコンテキストへの設定を行わない。
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

> **注意**: `I18nHandler`はアプリケーションの共通ハンドラとして使用することを想定しているため、`HttpRequest`の`getParamMap`メソッドと`getParam`メソッドを使用して直接リクエストパラメータにアクセスしている。業務機能を提供する画面をアクションで実装する場合は、バリデーション機能を使用してリクエストパラメータを取得すること。

### TimeZoneAttributeInHttpSession

```xml
<component class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
  <property name="sessionKey" value="app_timeZone" />
</component>
```

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| defaultTimeZone | | システムのデフォルトタイムゾーン | デフォルトのタイムゾーン |
| supportedTimeZones | ○ | | サポート対象のタイムゾーン（文字列配列） |
| sessionKey | | TimeZoneAttribute.getKey()の戻り値 | タイムゾーンが格納されるセッションキー名 |

`TimeZoneAttributeInHttpUtil`を使用するには、コンポーネント名を`timeZoneAttribute`にする必要がある。

```xml
<!-- TimeZoneAttributeInHttpUtilを使用するため、
     コンポーネント名を"timeZoneAttribute"にする。-->
<component name="timeZoneAttribute"
           class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
</component>
```

ログイン処理でユーザに紐づくタイムゾーンをHTTPセッションに設定するアクションの実装例:

```java
public HttpResponse doLOGIN00101(HttpRequest request, ExecutionContext context) {

    // ログイン処理は省略。
    // 認証に成功した場合の処理を以下に示す。

    // ログインユーザに紐づくタイムゾーンを取得する。
    String timeZone = // データベースからの取得処理は省略

    // TimeZoneAttributeInHttpUtilのkeepTimeZoneメソッドを呼び出し、
    // HTTPセッションにタイムゾーンを設定する。
    // スレッドコンテキストにもタイムゾーンが設定される。
    TimeZoneAttributeInHttpUtil.keepTimeZone(request, context, timeZone);

    return new HttpResponse("/MENU00101.jsp");
}
```

<details>
<summary>keywords</summary>

ThreadContextAttribute, nablarch.common.handler.threadcontext.ThreadContextAttribute, スレッドコンテキスト属性インタフェース, TimeZoneAttributeInHttpCookie, TimeZoneAttributeInHttpSession, TimeZoneAttributeInHttpUtil, defaultTimeZone, supportedTimeZones, cookieName, cookiePath, cookieDomain, cookieMaxAge, cookieSecure, sessionKey, keepTimeZone, タイムゾーン設定, タイムゾーン切替, クッキーでタイムゾーン保持, セッションでタイムゾーン保持, n:submitLink, n:param, I18nHandler, HttpRequestHandler

</details>

## クラス定義

## コアクラス

| クラス名 | 概要 |
|---|---|
| `nablarch.common.handler.threadcontext.ThreadContextHandler` | スレッドコンテキストを初期化するハンドラ |
| `nablarch.common.handler.threadcontext.RequestIdAttribute` | [リクエストID](../../about/about-nablarch/about-nablarch-concept.md) をスレッドコンテキストに設定するThreadContextAttribute。URLの最後の"/"から"."の間の文字列をリクエストIDと判断 |
| `nablarch.common.handler.threadcontext.InternalRequestIdAttribute` | [内部リクエストID](../../about/about-nablarch/about-nablarch-concept.md) を [リクエストID](../../about/about-nablarch/about-nablarch-concept.md) と同じ値に初期設定 |
| `nablarch.common.handler.threadcontext.UserIdAttribute` | ログインユーザのユーザIDをスレッドコンテキストに設定。未ログイン時は未認証ユーザを示すユーザIDを設定。認証処理ではセッションにユーザIDを設定しておく必要がある |
| `nablarch.common.handler.threadcontext.LanguageAttribute` | 言語をスレッドコンテキストに設定するThreadContextAttribute。明示的に指定しなかった場合、システムのデフォルトロケールが使用される |
| `nablarch.common.handler.threadcontext.TimeZoneAttribute` | タイムゾーンをスレッドコンテキストに設定するThreadContextAttribute。明示的に指定しなかった場合、システムのデフォルトタイムゾーンが使用される |
| `nablarch.common.handler.threadcontext.ExecutionIdAttribute` | 実行時IDをスレッドコンテキストに設定。[execution_id](../../about/about-nablarch/about-nablarch-concept.md) 参照 |

## LanguageAttributeのサブクラスとユーティリティ

| クラス名 | 概要 |
|---|---|
| `nablarch.common.web.handler.threadcontext.HttpLanguageAttribute` | HTTPヘッダ(Accept-Language)からサポート対象の言語を取得し設定。取得できない場合は親クラスLanguageAttributeに委譲 |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSupport` | HTTP上で言語の選択と保持を行うThreadContextAttributeの実装サポートクラス |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie` | クッキーからサポート対象の言語を取得し設定。取得できない場合はHttpLanguageAttributeに委譲 |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession` | HTTPセッションからサポート対象の言語を取得し設定。LanguageAttributeInHttpCookieと同様の処理 |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpUtil` | ユーザが選択した言語をクッキーまたはHTTPセッションに設定する処理を提供するユーティリティ |

## TimeZoneAttributeのサブクラスとユーティリティ

| クラス名 | 概要 |
|---|---|
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSupport` | HTTP上でタイムゾーンの保持を行うThreadContextAttributeの実装サポートクラス |
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie` | クッキーからサポート対象のタイムゾーンを取得し設定。取得できない場合はTimeZoneAttributeに委譲 |
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession` | HTTPセッションからサポート対象のタイムゾーンを取得し設定。TimeZoneAttributeInHttpCookieと同様の処理 |
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpUtil` | ユーザが選択したタイムゾーンをクッキーまたはHTTPセッションに設定する処理を提供するユーティリティ |

> **注意**: `UserIdAttribute`のHttpセッションからユーザIDを取得するキーおよび未ログインユーザに設定するユーザIDは、本クラスのプロパティ設定で変更可能。

## LanguageAttribute選択基準

| クラス名 | 言語の選択 | 言語の保存 | 説明 |
|---|---|---|---|
| `LanguageAttribute` | なし | なし | 国際化なし。言語は固定。アプリ実装不要 |
| `HttpLanguageAttribute` | ブラウザの言語設定 | ブラウザの言語設定 | ブラウザ設定に応じて切り替え。ログイン前も有効。アプリ実装不要 |
| `LanguageAttributeInHttpCookie` | 選択画面やリンク | クッキー | アプリ提供の選択画面でユーザが言語選択。ログイン前も有効。クッキー設定はLanguageAttributeInHttpUtilが提供 |
| `LanguageAttributeInHttpSession` | 選択画面やリンク | データベース | ユーザ毎に言語保持。ログイン前は切り替わらない。ログイン時の言語取得・選択画面・DB保存処理をアプリで実装。HTTPセッション設定はLanguageAttributeInHttpUtilが提供 |

> **注意**: `LanguageAttributeInHttpUtil`を使用する場合は、リポジトリにLanguageAttributeInHttpSupportのサブクラスを"languageAttribute"という名前で登録すること。

## TimeZoneAttribute選択基準

| クラス名 | タイムゾーンの選択 | タイムゾーンの保存 | 説明 |
|---|---|---|---|
| `TimeZoneAttribute` | なし | なし | 国際化なし。タイムゾーンは固定。アプリ実装不要 |
| `TimeZoneAttributeInHttpCookie` | 選択画面やリンク | クッキー | アプリ提供の選択画面でユーザがタイムゾーン選択。ログイン前も有効。クッキー設定はTimeZoneAttributeInHttpUtilが提供 |
| `TimeZoneAttributeInHttpSession` | 選択画面やリンク | データベース | ユーザ毎にタイムゾーン保持。ログイン前は切り替わらない。ログイン時の取得・選択画面・DB保存処理をアプリで実装。HTTPセッション設定はTimeZoneAttributeInHttpUtilが提供 |

> **注意**: `TimeZoneAttributeInHttpUtil`を使用する場合は、リポジトリにTimeZoneAttributeInHttpSupportのサブクラスを"timeZoneAttribute"という名前で登録すること。

設定プロパティなし。

<details>
<summary>keywords</summary>

ThreadContextHandler, RequestIdAttribute, InternalRequestIdAttribute, UserIdAttribute, LanguageAttribute, TimeZoneAttribute, ExecutionIdAttribute, HttpLanguageAttribute, LanguageAttributeInHttpCookie, LanguageAttributeInHttpSession, LanguageAttributeInHttpUtil, TimeZoneAttributeInHttpCookie, TimeZoneAttributeInHttpSession, TimeZoneAttributeInHttpUtil, 言語選択, タイムゾーン選択, 国際化, 実行IDアトリビュート, 設定値なし

</details>

## ThreadContextHandlerの設定

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| attributes | List | ○ | | ThreadContextAttributeインタフェースを実装したクラスのリスト |

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

ThreadContextHandler, attributes, defaultLanguage, defaultTimeZone, sessionKey, anonymousId, スレッドコンテキスト設定例

</details>

## UserIdAttributeの設定

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| sessionKey | String | | USER_ID | セッションからユーザIDを取得する際のキー |
| anonymousId | String | | (未設定) | 未ログインユーザに対して設定するユーザID。未設定の場合、未ログインユーザのユーザIDは設定されない |

<details>
<summary>keywords</summary>

UserIdAttribute, sessionKey, anonymousId, ユーザID設定, 未ログインユーザ

</details>

## RequestIdAttributeの設定

RequestIdAttributeに設定値は存在しない。

<details>
<summary>keywords</summary>

RequestIdAttribute, リクエストID設定

</details>

## InternalRequestIdAttributeの設定

InternalRequestIdAttributeに設定値は存在しない。

<details>
<summary>keywords</summary>

InternalRequestIdAttribute, 内部リクエストID設定

</details>
