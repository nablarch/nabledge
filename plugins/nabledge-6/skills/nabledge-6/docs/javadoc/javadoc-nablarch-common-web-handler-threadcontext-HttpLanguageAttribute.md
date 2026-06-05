# class HttpLanguageAttribute

**パッケージ:** nablarch.common.web.handler.threadcontext

**継承階層:**
```
java.lang.Object
  └─ LanguageAttribute
      └─ nablarch.common.web.handler.threadcontext.HttpLanguageAttribute
```

---

```java
public class HttpLanguageAttribute
extends LanguageAttribute
```

スレッドコンテキストに保持する言語属性をHTTPヘッダ(Accept-Language)から取得するクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### supportedLanguages

```java
private Set<String> supportedLanguages
```

サポート対象の言語

---

### COMMA_PATTERN

```java
private static final Pattern COMMA_PATTERN
```

カンマを表す正規表現のパターン

---

## メソッドの詳細

### setSupportedLanguages

```java
public void setSupportedLanguages(String supportedLanguages)
```

サポート対象の言語を設定する。

**パラメータ:**
- `supportedLanguages` - サポート対象の言語

---

### getValue

```java
public Object getValue(Request<?> req, ExecutionContext ctx)
```

コンテキストスレッドに格納するこのプロパティの値を返す。 
<p/>
{@link #getLocale(HttpRequest, ServletExecutionContext)}に処理を委譲する。

**パラメータ:**
- `req` - リクエスト
- `ctx` - 実行コンテキスト

**戻り値:**
サポート対象の言語

---

### getLocale

```java
protected Locale getLocale(HttpRequest req, ServletExecutionContext ctx)
```

スレッドコンテキストに保持する言語属性を返す。
<pre>
このクラスの実装では以下の処理を行う。

1.Accept-Languageヘッダから言語の取得を試みる。
  ({@link #getAcceptLanguage(HttpRequest, ServletExecutionContext)})

  サポート対象の言語が取得できた場合は取得できた言語を返す。
  サポート対象の言語が取得できない場合は2.に進む。

2.デフォルトの言語を返す。
  ({@link LanguageAttribute#getValue(Request, ExecutionContext)})

</pre>

**パラメータ:**
- `req` - リクエスト
- `ctx` - 実行コンテキスト

**戻り値:**
サポート対象の言語

---

### getAcceptLanguage

```java
protected String getAcceptLanguage(HttpRequest req, ServletExecutionContext ctx)
```

"Accept-Language"ヘッダをパースし、一番優先度が高いサポート対象の言語を返す。

**パラメータ:**
- `req` - リクエスト
- `ctx` - 実行コンテキスト

**戻り値:**
サポート対象の言語。サポート対象の言語が取得できない場合はnull。

---

### isSupportedLanguage

```java
protected boolean isSupportedLanguage(String language)
```

サポート対象の言語か否かを判定する。

**パラメータ:**
- `language` - 言語

**戻り値:**
サポート対象の言語の場合はtrue

---
