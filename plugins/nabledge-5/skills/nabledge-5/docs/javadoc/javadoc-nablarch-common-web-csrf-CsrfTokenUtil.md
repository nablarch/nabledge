# class CsrfTokenUtil

**パッケージ:** nablarch.common.web.csrf

---

```java
public final class CsrfTokenUtil
```

CSRFトークンに関するユーティリティ。

**作成者:** Uragami Taichi  

---

## コンストラクタの詳細

### CsrfTokenUtil

```java
private CsrfTokenUtil()
```

本クラスはインスタンスを生成しない。

---

## メソッドの詳細

### getCsrfToken

```java
public static String getCsrfToken(ExecutionContext context)
```

CSRFトークンをセッションストアから取得する。

**パラメータ:**
- `context` - 実行コンテキスト

**戻り値:**
CSRFトークン。セッションストアに存在しない場合は{@code null}

---

### getHeaderName

```java
public static String getHeaderName()
```

CSRFトークンをHTTPリクエストヘッダーへ設定する際に使用する名前を取得する。

**戻り値:**
CSRFトークンをHTTPリクエストヘッダーへ設定する際に使用する名前

---

### getParameterName

```java
public static String getParameterName()
```

CSRFトークンをHTTPリクエストパラメーターへ設定する際に使用する名前を取得する。

**戻り値:**
CSRFトークンをHTTPリクエストパラメーターへ設定する際に使用する名前

---

### regenerateCsrfToken

```java
public static void regenerateCsrfToken(ExecutionContext context)
```

CSRFトークンを再生成する。

<p>
このメソッドはセキュリティのために用意されている。
悪意のある人がCSRFトークンとそれを保持しているセッションのセッションIDをなんらかの方法で利用者に送り込み、
利用者がこれに気づかずにログインをしたとする。
このときCSRFトークンが再生成されていないと、悪意のあるウェブサイトにCSRFトークンを仕込んだ罠ページを用意し、
利用者にリンクのクリックなどの操作をさせることで利用者の意図しない攻撃リクエストを送信させることができてしまう。
これを防ぐためにはログイン時にCSRFトークンを再生成しなくてはならない。
</p>

<p>
ログイン時にセッションを破棄して再生成する実装であればこのメソッドを利用する必要はない。
セッションの破棄と共にCSRFトークンも破棄され、その後のページ表示時に新しいCSRFトークンが生成されるためである。
ログイン時にセッションそのものの破棄ではなくセッションIDの再生成を行うにとどめる実装の場合は、
このメソッドを利用してCSRFトークンも再生成することを推奨する。
</p>

**パラメータ:**
- `context` - 実行コンテキスト

---
