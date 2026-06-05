# class ResourcePathRule

**パッケージ:** nablarch.fw.web.i18n

---

```java
public abstract class ResourcePathRule
```

言語対応リソースパスのルールを表すクラス。
<p/>
自身が表すルールに基づき言語対応のリソースパスを提供する。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### servletContextCreator

```java
private ServletContextCreator servletContextCreator
```

{@link ServletContextCreator}のインスタンス

---

## メソッドの詳細

### setServletContextCreator

```java
public void setServletContextCreator(ServletContextCreator servletContextCreator)
```

{@link ServletContextCreator}を設定する。

**パラメータ:**
- `servletContextCreator` - サーブレットコンテキスト生成クラス

---

### getPathForLanguage

```java
public String getPathForLanguage(String path, HttpServletRequest request)
```

言語対応のリソースパスを取得する。
<pre>
言語は{@link ThreadContext#getLanguage()}から取得する。
{@link ThreadContext#getLanguage()}から言語を取得できない場合は指定されたリソースパスをそのまま返す。

言語対応のリソースパスが指すファイルが存在する場合は言語対応のリソースパスを返し、
存在しない場合は指定されたリソースパスをそのまま返す。
指定されたリソースパスに拡張子を含まない場合は指定されたリソースパスをそのまま返す。

言語対応のリソースパスは{@link #createPathForLanguage(String, String)}メソッドを呼び出し作成する。
{@link #createPathForLanguage(String, String)}メソッドはサブクラスにより実装される。
<pre>

**パラメータ:**
- `path` - オリジナルのリソースパス
- `request` - リクエスト

**戻り値:**
言語対応のリソースパス

---

### existsResource

```java
protected boolean existsResource(String resourcePath, HttpServletRequest request)
```

指定されたパスが指すファイルが存在するか否かを判定する。

**パラメータ:**
- `request` - リクエスト
- `resourcePath` - リソースパス

**戻り値:**
ファイルが存在する場合はtrue

---

### getServletContext

```java
private ServletContext getServletContext(HttpServletRequest request)
```

サーブレットコンテキストを取得する。

**パラメータ:**
- `request` - リクエスト

**戻り値:**
サーブレットコンテキスト

---

### convertToPathFromContextRoot

```java
protected String convertToPathFromContextRoot(String path, HttpServletRequest request)
```

コンテキストルートからのパスに変換する。

**パラメータ:**
- `path` - パス
- `request` - リクエスト

**戻り値:**
コンテキストルートからのパス

---

### createPathForLanguage

```java
protected abstract String createPathForLanguage(String pathFromContextRoot, String language)
```

言語対応のリソースパスを作成する。

**パラメータ:**
- `pathFromContextRoot` - コンテキストルートからのパス
- `language` - 言語

**戻り値:**
言語対応のリソースパス

---
