# class WebFrontController

**パッケージ:** nablarch.fw.web.servlet

**継承階層:**
```
java.lang.Object
  └─ HandlerQueueManager<WebFrontController>
      └─ nablarch.fw.web.servlet.WebFrontController
```

**実装されたインタフェース:**
- Filter

---

```java
public class WebFrontController
extends HandlerQueueManager<WebFrontController>
implements Filter
```

アプリケーションサーバにデプロイして使用するリクエストコントローラ。
<pre>
本フレームワークをTomcat/Websphere等のアプリケーションサーバ上で使用する際に、
サーブレットフィルタとしてデプロイして使用するリクエストエントリポイントである。
各HTTPリクエスト毎に下記の処理を行う。
  1. HttpServletRequestオブジェクトをラップした
     HttpRequest, ExecutionContext オブジェクトを生成する。
  2. それらを引数としてリクエストプロセッサに処理を委譲する。
  3. その結果(HttpResponseオブジェクトの内容)に従って、
     HTTPクライアントに対するレスポンス処理を行う。
リクエストプロセッサの初期化処理は、本クラスのサブクラスを作成し、
オーバライドしたinit()メソッドの中で行う。
本サーブレットフィルタに処理が委譲された場合、必ずレスポンスかフォーワードを行う。
このため、後続のサーブレットフィルタチェインに処理が委譲されることは無い。

-------------------------------------
デプロイメントディスクリプタの記述例
-------------------------------------
&lt;?xml version="1.0" encoding="UTF-8"?>
&lt;web-app xmlns="http://java.sun.com/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         version="2.5">
  &lt;display-name>w8&lt;/display-name>
  &lt;description>
    The default application-context for w8.http-based applications.
  &lt;/description>
  &lt;filter>
    &lt;filter-name>WebFrontController&lt;/filter-name>
    &lt;filter-class>
      nablarch.fw.web.servlet.WebFrontController
    &lt;/filter-class>
  &lt;/filter>
  &lt;filter-mapping>
    &lt;filter-name>WebFrontController&lt;/filter-name>
   &lt;url-pattern>/*&lt;/url-pattern>
  &lt;/filter-mapping>
&lt;/web-app>

</pre>

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## フィールドの詳細

### preventSessionCreation

```java
private boolean preventSessionCreation
```

セッション生成を防止する機能を有効にするかどうかのフラグ。

---

### handlerQueue

```java
private List<Handler> handlerQueue
```

ハンドラキュー

---

### config

```java
private FilterConfig config
```

フィルタ設定

---

## コンストラクタの詳細

### WebFrontController

```java
public WebFrontController()
```

デフォルトコンストラクタ

---

## メソッドの詳細

### doFilter

```java
public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
              throws ServletException, IOException
```

{@inheritDoc}
<pre>
本クラスの実装では、HTTPリクエスト毎に下記の処理を行う。
  1. HttpServletRequestオブジェクトをラップした
     HttpRequest, ExecutionContext オブジェクトを生成する。
  2. それらを引数としてリクエストプロセッサに処理を委譲する。
  3. その結果(HttpResponseオブジェクトの内容)に従って、
     HTTPクライアントに対するレスポンス処理を行う。
</pre>

---

### applyPreventingSessionCreation

```java
private HttpServletRequest applyPreventingSessionCreation(HttpServletRequest request)
```

セッション生成防止機能が有効な場合は、指定したリクエストオブジェクトにセッション生成防止機能を適用する。
<p/>
機能が無効の場合は、受け取ったリクエストオブジェクトをそのまま返します。

**パラメータ:**
- `request` - 適用対象のリクエストオブジェクト

**戻り値:**
必要に応じてセッション生成防止機能が適用されたリクエストオブジェクト

---

### init

```java
public void init(FilterConfig config)
```

{@inheritDoc}
本クラスの実装では、リポジトリ上にコンポーネント"webFrontController"
が存在すれば、そのインスタンスを以降の処理で使用する。
存在しない場合は、このインスタンスをそのまま使用する。

---

### getHandlerQueue

```java
public List<Handler> getHandlerQueue()
```

---

### setServletFilterConfig

```java
public void setServletFilterConfig(FilterConfig config)
```

サーブレットフィルタの設定情報を設定する.

**パラメータ:**
- `config` - 設定情報

---

### getServletFilterConfig

```java
public FilterConfig getServletFilterConfig()
```

サーブレットフィルタの設定情報を取得する。

**戻り値:**
設定情報

---

### destroy

```java
public void destroy()
```

{@inheritDoc}
<pre>
本クラスのdestroy()メソッドでは何も行わない。
</pre>

---

### setPreventSessionCreation

```java
public void setPreventSessionCreation(boolean preventSessionCreation)
```

セッション生成を防止する機能を有効にするかどうかを設定する。

**パラメータ:**
- `preventSessionCreation` - 有効にする場合は {@code true}

---
