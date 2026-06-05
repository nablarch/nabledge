# class RepositoryBasedWebFrontController

**パッケージ:** nablarch.fw.web.servlet

**実装されたインタフェース:**
- Filter

---

```java
public class RepositoryBasedWebFrontController
implements Filter
```

リポジトリ機能を使用して構築した{@link WebFrontController}を保持し、
そこに対してリクエスト処理を委譲するリクエストコントローラー.<br>
controllerNameのパラメータ値にコントローラ名を設定することで、設定した名前を元に移譲するWebFrontControllerを取得することができる。
デフォルトではwebFrontControllerという名前で移譲するWebFrontControllerを取得する。
<pre>{@code
-------------------------------------
デプロイメントディスクリプタの記述例
-------------------------------------
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://java.sun.com/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         version="2.5">
  <display-name>w8</display-name>
  <description>
    The default application-context for w8.http-based applications.
  </description>
  <filter>
    <filter-name>webEntryPoint</filter-name>
    <filter-class>
      nablarch.fw.web.servlet.RepositoryBasedWebFrontController
    </filter-class>
    <init-param>
      <param-name>controllerName</param-name>
      <param-value>otherNameController</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>webEntryPoint</filter-name>
   <url-pattern>/*</url-pattern>
  </filter-mapping>
</web-app>
 }</pre>

**関連項目:** WebFrontController  
**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### controller

```java
private WebFrontController controller
```

処理を委譲するリクエストコントローラのインスタンス

---

## メソッドの詳細

### destroy

```java
public void destroy()
```

{@inheritDoc}
この実装では、保持しているリクエストコントローラに対して
処理を委譲するのみ。

---

### doFilter

```java
public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
              throws IOException, ServletException
```

{@inheritDoc}
この実装では、保持しているリクエストコントローラに対して
処理を委譲するのみ。

---

### init

```java
public void init(FilterConfig filterConfig)
          throws ServletException
```

{@inheritDoc}
リポジトリ機能を用いてWebFrontControllerのインスタンスを初期化し、
以降の全ての処理をそこへ委譲する。

---
