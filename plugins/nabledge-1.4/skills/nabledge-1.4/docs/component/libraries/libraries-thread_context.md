# 同一スレッド内でのデータ共有(スレッドコンテキスト)

## 同一スレッド内でのデータ共有(スレッドコンテキスト)

スレッドコンテキストはスレッドローカル変数上の変数スコープ。ユーザIDやリクエストIDなど、実行コンテキスト経由での引き回しが難しいパラメータを格納する。

- 多くの値は[../handler/ThreadContextHandler](../handlers/handlers-ThreadContextHandler.md)によって設定される
- それ以外ハンドラでも、スレッドコンテキストに変数を設定するものが存在するほか、業務アクションハンドラから任意の変数を設定することも可能である。
- 子スレッドを起動した場合、親スレッドの値が暗黙的に引き継がれる
- 子スレッドで値を変更する場合は、明示的に子スレッドで値を設定すること

![クラス図](../../../knowledge/component/libraries/assets/libraries-thread_context/thread_context.jpg)

## LanguageAttribute

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultLanguage | String | | システムデフォルトロケール | デフォルト言語 |

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
| defaultLanguage | String | | システムデフォルトロケール | デフォルト言語 |
| supportedLanguages | String | ○ | | サポート対象言語 |

## LanguageAttributeInHttpCookie

**クラス**: `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie`

> **重要**: `LanguageAttributeInHttpUtil`を使用するため、コンポーネント名を`languageAttribute`にする必要がある。

```xml
<component name="languageAttribute"
           class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
</component>
```

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultLanguage | String | | システムデフォルトロケール | デフォルト言語 |
| supportedLanguages | String | ○ | | サポート対象言語 |
| cookieName | String | | nablarch_language | 言語を保持するクッキー名 |
| cookiePath | String | | コンテキストパス | クッキーのURIパス階層 |
| cookieDomain | String | | リクエストURLのドメイン名 | クッキーのドメイン階層 |
| cookieMaxAge | int | | ブラウザ終了まで | クッキーの最長存続期間（秒） |
| cookieSecure | boolean | | false（secure属性なし） | クッキーのsecure属性 |

`LanguageAttributeInHttpUtil.keepLanguage(request, context, language)`を呼び出すと、クッキーとスレッドコンテキストの両方に言語が設定される。指定された言語がサポート対象外の場合は設定されない。

JSP実装例（n:submitLinkとn:paramで言語選択リンク）:

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

ハンドラ実装例:

```java
public class I18nHandler implements HttpRequestHandler {
    public HttpResponse handle(HttpRequest request, ExecutionContext context) {
        String language = getLanguage(request, "user.language");
        if (StringUtil.hasValue(language)) {
            LanguageAttributeInHttpUtil.keepLanguage(request, context, language);
        }
        return context.handleNext(request);
    }
}
```

> **注意**: I18nHandlerはアプリケーション共通ハンドラとして使用を想定しているため、`HttpRequest`の`getParamMap`/`getParam`メソッドで直接リクエストパラメータにアクセスしている。業務機能をアクションで実装する場合はバリデーション機能でリクエストパラメータを取得すること。

## LanguageAttributeInHttpSession

**クラス**: `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession`

> **重要**: `LanguageAttributeInHttpUtil`を使用するため、コンポーネント名を`languageAttribute`にする必要がある。

```xml
<component name="languageAttribute"
           class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession">
  <property name="defaultLanguage" value="ja" />
  <property name="supportedLanguages" value="ja,en" />
</component>
```

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultLanguage | String | | システムデフォルトロケール | デフォルト言語 |
| supportedLanguages | String | ○ | | サポート対象言語 |
| sessionKey | String | | LanguageAttributeのgetKeyメソッドの戻り値 | 言語が格納されるセッション上のキー名 |

ログイン処理でユーザに紐づく言語をHTTPセッションに設定する実装例:

```java
public HttpResponse doLOGIN00101(HttpRequest request, ExecutionContext context) {
    String language = // DBから取得
    LanguageAttributeInHttpUtil.keepLanguage(request, context, language);
    return new HttpResponse("/MENU00101.jsp");
}
```

<details>
<summary>keywords</summary>

ThreadContextHandler, ThreadContextAttribute, スレッドコンテキスト, 子スレッドへの値の引き継ぎ, LanguageAttribute, HttpLanguageAttribute, LanguageAttributeInHttpCookie, LanguageAttributeInHttpSession, LanguageAttributeInHttpUtil, defaultLanguage, supportedLanguages, cookieName, cookiePath, cookieDomain, cookieMaxAge, cookieSecure, sessionKey, 言語設定, 多言語対応, スレッドコンテキスト言語

</details>

## インタフェース定義

| クラス・インタフェース名 | 概要 |
|---|---|
| `nablarch.common.handler.threadcontext.ThreadContextAttribute` | スレッドコンテキストに属性を設定するインタフェース。実装クラスはコンテキストから属性値を取得する責務を持つ。 |

## TimeZoneAttribute

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultTimeZone | String | | システムデフォルトタイムゾーン | デフォルトタイムゾーン |

## TimeZoneAttributeInHttpCookie

**クラス**: `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie`

> **重要**: `TimeZoneAttributeInHttpUtil`を使用するため、コンポーネント名を`timeZoneAttribute`にする必要がある。

```xml
<component name="timeZoneAttribute"
           class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
</component>
```

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultTimeZone | String | | システムデフォルトタイムゾーン | デフォルトタイムゾーン |
| supportedTimeZones | String | ○ | | サポート対象タイムゾーン |
| cookieName | String | | nablarch_timeZone | タイムゾーンを保持するクッキー名 |
| cookiePath | String | | コンテキストパス | クッキーのURIパス階層 |
| cookieDomain | String | | リクエストURLのドメイン名 | クッキーのドメイン階層 |
| cookieMaxAge | int | | ブラウザ終了まで | クッキーの最長存続期間（秒） |
| cookieSecure | boolean | | false（secure属性なし） | クッキーのsecure属性 |

`TimeZoneAttributeInHttpUtil.keepTimeZone(request, context, timeZone)`を呼び出すと、クッキーとスレッドコンテキストの両方にタイムゾーンが設定される。指定されたタイムゾーンがサポート対象外の場合は設定されない。

JSP実装例（n:submitLinkとn:paramでタイムゾーン選択リンク）:

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

ハンドラ実装例:

```java
public class I18nHandler implements HttpRequestHandler {
    public HttpResponse handle(HttpRequest request, ExecutionContext context) {
        String timeZone = getTimeZone(request, "user.timeZone");
        if (StringUtil.hasValue(timeZone)) {
            TimeZoneAttributeInHttpUtil.keepTimeZone(request, context, timeZone);
        }
        return context.handleNext(request);
    }
}
```

> **注意**: I18nHandlerはアプリケーション共通ハンドラとして使用を想定しているため、`HttpRequest`の`getParamMap`/`getParam`メソッドで直接リクエストパラメータにアクセスしている。業務機能をアクションで実装する場合はバリデーション機能でリクエストパラメータを取得すること。

## TimeZoneAttributeInHttpSession

**クラス**: `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession`

> **重要**: `TimeZoneAttributeInHttpUtil`を使用するため、コンポーネント名を`timeZoneAttribute`にする必要がある。

```xml
<component name="timeZoneAttribute"
           class="nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession">
  <property name="defaultTimeZone" value="Asia/Tokyo" />
  <property name="supportedTimeZones" value="Asia/Tokyo,America/New_York" />
</component>
```

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultTimeZone | String | | システムデフォルトタイムゾーン | デフォルトタイムゾーン |
| supportedTimeZones | String | ○ | | サポート対象タイムゾーン |
| sessionKey | String | | TimeZoneAttributeのgetKeyメソッドの戻り値 | タイムゾーンが格納されるセッション上のキー名 |

ログイン処理でユーザに紐づくタイムゾーンをHTTPセッションに設定する実装例:

```java
public HttpResponse doLOGIN00101(HttpRequest request, ExecutionContext context) {
    String timeZone = // DBから取得
    TimeZoneAttributeInHttpUtil.keepTimeZone(request, context, timeZone);
    return new HttpResponse("/MENU00101.jsp");
}
```

<details>
<summary>keywords</summary>

ThreadContextAttribute, スレッドコンテキスト属性, インタフェース定義, TimeZoneAttribute, TimeZoneAttributeInHttpCookie, TimeZoneAttributeInHttpSession, TimeZoneAttributeInHttpUtil, defaultTimeZone, supportedTimeZones, cookieName, cookiePath, cookieDomain, cookieMaxAge, cookieSecure, sessionKey, タイムゾーン設定, 国際化対応, スレッドコンテキストタイムゾーン

</details>

## クラス定義

## コアクラス

| クラス名 | 概要 |
|---|---|
| `nablarch.common.handler.threadcontext.ThreadContextHandler` | スレッドコンテキストを初期化するハンドラ |
| `nablarch.common.handler.threadcontext.RequestIdAttribute` | [リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md)をスレッドコンテキストに設定するThreadContextAttribute |
| `nablarch.common.handler.threadcontext.InternalRequestIdAttribute` | [内部リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md)をリクエストIDと同じ値に初期設定する |
| `nablarch.common.handler.threadcontext.UserIdAttribute` | ログインユーザのユーザIDをスレッドコンテキストに設定するThreadContextAttribute。未ログイン時は未認証ユーザIDを設定 |
| `nablarch.common.handler.threadcontext.LanguageAttribute` | 言語をスレッドコンテキストに設定するThreadContextAttribute |
| `nablarch.common.handler.threadcontext.TimeZoneAttribute` | タイムゾーンをスレッドコンテキストに設定するThreadContextAttribute |
| `nablarch.common.handler.threadcontext.ExecutionIdAttribute` | [実行時ID](libraries-01_Log.md)をスレッドコンテキストに設定するThreadContextAttribute |

## LanguageAttributeのサブクラスとユーティリティ

| クラス名 | 概要 |
|---|---|
| `nablarch.common.web.handler.threadcontext.HttpLanguageAttribute` | HTTPヘッダ(Accept-Language)から言語を取得するThreadContextAttribute |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSupport` | HTTP上で言語の選択と保持を行うThreadContextAttributeの実装をサポートするクラス |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie` | クッキーを使用して言語を保持するThreadContextAttribute |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession` | HTTPセッションを使用して言語を保持するThreadContextAttribute |
| `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpUtil` | HTTP上で選択された言語を保持する処理を提供するユーティリティクラス |

## TimeZoneAttributeのサブクラスとユーティリティ

| クラス名 | 概要 |
|---|---|
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSupport` | HTTP上で選択されたタイムゾーンの保持を行うThreadContextAttributeの実装をサポートするクラス |
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie` | クッキーを使用してタイムゾーンを保持するThreadContextAttribute |
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession` | HTTPセッションを使用してタイムゾーンを保持するThreadContextAttribute |
| `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpUtil` | HTTP上で選択されたタイムゾーンを保持する処理を提供するユーティリティクラス |

ExecutionIdAttributeには設定値は存在しない。

<details>
<summary>keywords</summary>

ThreadContextHandler, RequestIdAttribute, InternalRequestIdAttribute, UserIdAttribute, LanguageAttribute, TimeZoneAttribute, ExecutionIdAttribute, HttpLanguageAttribute, LanguageAttributeInHttpCookie, LanguageAttributeInHttpSession, LanguageAttributeInHttpSupport, LanguageAttributeInHttpUtil, TimeZoneAttributeInHttpCookie, TimeZoneAttributeInHttpSession, TimeZoneAttributeInHttpSupport, TimeZoneAttributeInHttpUtil, クラス一覧, 実行ID属性, 設定値なし

</details>

## ThreadContextHandlerの設定

| プロパティ名 | 設定内容 |
|---|---|
| attributes | ThreadContextAttributeインタフェースを実装したクラスのリストを設定する |

<details>
<summary>keywords</summary>

ThreadContextHandler, attributes, スレッドコンテキスト設定, プロパティ設定

</details>

## UserIdAttributeの設定

| プロパティ名 | 設定内容 |
|---|---|
| sessionKey | セッションからユーザIDを取得する際のキーを設定する。設定しなかった場合、"USER_ID"がキーとして使用される |
| anonymousId | 未ログインユーザに対して設定するユーザIDを設定する。設定しなかった場合、未ログインユーザのユーザIDは設定されない |

<details>
<summary>keywords</summary>

UserIdAttribute, sessionKey, anonymousId, ユーザID設定, 未ログインユーザ

</details>

## RequestIdAttributeの設定

RequestIdAttributeには設定値は存在しない。

<details>
<summary>keywords</summary>

RequestIdAttribute, リクエストID設定, 設定プロパティ

</details>

## InternalRequestIdAttributeの設定

InternalRequestIdAttributeには設定値は存在しない。

<details>
<summary>keywords</summary>

InternalRequestIdAttribute, 内部リクエストID設定, 設定プロパティ

</details>

## 使用方法

ThreadContextHandlerは、リクエスト毎にスレッドコンテキストの初期化を行う。実際にスレッドコンテキストに設定する値を取得する責務は、ThreadContextAttributeインタフェース実装クラスが持つ。

## フレームワークが提供するThreadContextAttribute実装クラス

- [リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md)
- [内部リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md)
- ユーザID
- 言語
- タイムゾーン
- [実行時ID](libraries-01_Log.md)

## ThreadContextHandler以外での属性更新

| 属性 | 更新状況 |
|---|---|
| [リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) | [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) のみ、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) によって更新 |
| [内部リクエストID](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) | Web GUIでは内部フォワード時に[../handler/ForwardingHandler](../handlers/handlers-ForwardingHandler.md)で更新。メッセージングでは[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md)で更新 |
| ユーザID | [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) のみ、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) によって更新 |

## 各属性クラスの仕様

**RequestIdAttribute**: URLの最後の"/"から"."の間の文字列をリクエストIDとする。

**InternalRequestIdAttribute**: リクエストIDと同じ値に初期設定する。

**UserIdAttribute**: HttpセッションからユーザIDを取得してスレッドコンテキストに設定する。取得できない場合は未ログインを示す特別なユーザIDを設定する。認証処理ではセッションにユーザIDを設定しておく必要がある。

> **注意**: HttpセッションからユーザIDを取得するキーと未ログインユーザIDはプロパティで変更可能。

**ExecutionIdAttribute**: 実行時IDをスレッドコンテキストに設定する。詳細は[execution_id](libraries-01_Log.md)参照。

<details>
<summary>keywords</summary>

ThreadContextHandler, RequestIdAttribute, InternalRequestIdAttribute, UserIdAttribute, LanguageAttribute, TimeZoneAttribute, ExecutionIdAttribute, 言語切り替え, タイムゾーン切り替え, 国際化

</details>

## LanguageAttribute選択基準

LanguageAttributeクラスは、スレッドコンテキストに設定する言語を取得する責務を持つ。国際化を行うアプリケーション向けにサブクラスを提供する。

## LanguageAttributeおよびサブクラスの説明

| クラス名 | 説明 |
|---|---|
| LanguageAttribute | リポジトリの設定で指定された言語をスレッドコンテキストに設定する。明示的に指定しなかった場合、システムのデフォルトロケールが使用される |
| HttpLanguageAttribute | HTTPヘッダ(Accept-Language)から取得した言語をスレッドコンテキストに設定する。サポート対象の言語が取得できない場合は親クラスのLanguageAttributeに委譲 |
| LanguageAttributeInHttpCookie | クッキーを使用した言語の保持を行う。サポート対象の言語が取得できない場合は親クラスのHttpLanguageAttributeに委譲 |
| LanguageAttributeInHttpSession | HTTPセッションを使用した言語の保持を行う。言語の保持にHTTPセッションを使用することを除き、具体的な処理はLanguageAttributeInHttpCookieと同じ |
| LanguageAttributeInHttpUtil | LanguageAttributeInHttpSupportのサブクラスを使用するアプリケーション向けに、ユーザが選択した言語を保持する処理（言語選択処理やログイン処理でのクッキー/HTTPセッションへの言語設定）を提供するユーティリティクラス。リポジトリにLanguageAttributeInHttpSupportのサブクラスを"languageAttribute"という名前で登録する必要がある |

## 選択基準

| クラス名 | 言語の選択 | 言語の保存 | 説明 |
|---|---|---|---|
| LanguageAttribute | なし | なし | 国際化を行わないアプリケーションで使用する。言語は常に固定となる。アプリ実装不要 |
| HttpLanguageAttribute | ブラウザの言語設定 | ブラウザの言語設定 | ブラウザ設定に応じて切り替え。ログイン前でも有効。ブラウザ（IE、Firefoxなど）単位で保持。アプリ実装不要 |
| LanguageAttributeInHttpCookie | 選択画面やリンクなど | クッキー | アプリが言語選択画面を提供。ログイン前でも有効。ブラウザ単位で保持。選択言語をクッキーに設定する処理はLanguageAttributeInHttpUtilが提供 |
| LanguageAttributeInHttpSession | 選択画面やリンクなど | データベース | アプリが言語選択画面を提供。ログイン後のみ有効。ユーザ単位で保持（複数マシンからの利用でも同じ言語が適用）。アプリでは以下の実装が必要: ①ログイン時にユーザに紐づく言語の取得処理（HTTPセッションへの言語設定はLanguageAttributeInHttpUtilが提供）、②ユーザに言語を選択させる画面処理（選択言語のHTTPセッション設定はLanguageAttributeInHttpUtilが提供）、③選択された言語をユーザに紐付けてデータベースに保存する処理 |

LanguageAttributeInHttpUtilを使用する場合、リポジトリにLanguageAttributeInHttpSupportのサブクラスを"languageAttribute"という名前で登録すること。

<details>
<summary>keywords</summary>

LanguageAttribute, HttpLanguageAttribute, LanguageAttributeInHttpCookie, LanguageAttributeInHttpSession, LanguageAttributeInHttpSupport, LanguageAttributeInHttpUtil, 言語選択, 国際化, 言語切り替え, ログイン時言語取得

</details>

## TimeZoneAttribute選択基準

TimeZoneAttributeクラスは、スレッドコンテキストに設定するタイムゾーンを取得する責務を持つ。国際化を行うアプリケーション向けにサブクラスを提供する。

## TimeZoneAttributeおよびサブクラスの説明

| クラス名 | 説明 |
|---|---|
| TimeZoneAttribute | リポジトリの設定で指定されたタイムゾーンをスレッドコンテキストに設定する。明示的に指定しなかった場合、システムのデフォルトタイムゾーンが使用される |
| TimeZoneAttributeInHttpCookie | クッキーを使用したタイムゾーンの保持を行う。サポート対象のタイムゾーンが取得できない場合は親クラスのTimeZoneAttributeに委譲 |
| TimeZoneAttributeInHttpSession | HTTPセッションを使用したタイムゾーンの保持を行う。タイムゾーンの保持にHTTPセッションを使用することを除き、具体的な処理はTimeZoneAttributeInHttpCookieと同じ |
| TimeZoneAttributeInHttpUtil | TimeZoneAttributeInHttpSupportのサブクラスを使用するアプリケーション向けに、ユーザが選択したタイムゾーンを保持する処理（タイムゾーン選択処理やログイン処理でのクッキー/HTTPセッションへのタイムゾーン設定）を提供するユーティリティクラス。リポジトリにTimeZoneAttributeInHttpSupportのサブクラスを"timeZoneAttribute"という名前で登録する必要がある |

## 選択基準

| クラス名 | タイムゾーンの選択 | タイムゾーンの保存 | 説明 |
|---|---|---|---|
| TimeZoneAttribute | なし | なし | 国際化を行わないアプリケーションで使用する。タイムゾーンは常に固定となる。アプリ実装不要 |
| TimeZoneAttributeInHttpCookie | 選択画面やリンクなど | クッキー | アプリがタイムゾーン選択画面を提供。ログイン前でも有効。ブラウザ（IE、Firefoxなど）単位で保持。選択タイムゾーンをクッキーに設定する処理はTimeZoneAttributeInHttpUtilが提供 |
| TimeZoneAttributeInHttpSession | 選択画面やリンクなど | データベース | アプリがタイムゾーン選択画面を提供。ログイン後のみ有効。ユーザ単位で保持（複数マシンからの利用でも同じタイムゾーンが適用）。アプリでは以下の実装が必要: ①ログイン時にユーザに紐づくタイムゾーンの取得処理（HTTPセッションへのタイムゾーン設定はTimeZoneAttributeInHttpUtilが提供）、②ユーザにタイムゾーンを選択させる画面処理（選択タイムゾーンのHTTPセッション設定はTimeZoneAttributeInHttpUtilが提供）、③選択されたタイムゾーンをユーザに紐付けてデータベースに保存する処理 |

TimeZoneAttributeInHttpUtilを使用する場合、リポジトリにTimeZoneAttributeInHttpSupportのサブクラスを"timeZoneAttribute"という名前で登録すること。

<details>
<summary>keywords</summary>

TimeZoneAttribute, TimeZoneAttributeInHttpCookie, TimeZoneAttributeInHttpSession, TimeZoneAttributeInHttpSupport, TimeZoneAttributeInHttpUtil, タイムゾーン選択, 国際化, タイムゾーン切り替え, ログイン時タイムゾーン取得

</details>

## 設定例

基本的な属性を設定する場合の設定記述例:

```xml
<component class="nablarch.common.handler.threadcontext.ThreadContextHandler">
  <property name="attributes">
    <list>
      <!-- ユーザID -->
      <component class="nablarch.common.handler.threadcontext.UserIdAttribute">
        <property name="sessionKey"  value="user.id" />
        <property name="anonymousId" value="guest" />
      </component>
      <!-- リクエストID -->
      <component class="nablarch.common.handler.threadcontext.RequestIdAttribute" />
      <!-- 内部リクエストID -->
      <component class="nablarch.common.handler.threadcontext.InternalRequestIdAttribute" />
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

ThreadContextHandler, UserIdAttribute, RequestIdAttribute, InternalRequestIdAttribute, LanguageAttribute, TimeZoneAttribute, ExecutionIdAttribute, 設定例, XML設定

</details>
