# class ThreadContextHandler

**パッケージ:** nablarch.common.handler.threadcontext

**実装されたインタフェース:**
- Handler<Object,Object>
- InboundHandleable
- OutboundHandleable

---

```java
public class ThreadContextHandler
implements Handler<Object,Object>, InboundHandleable, OutboundHandleable
```

スレッドコンテキストに保持される共通属性を管理するハンドラ。

フレームワークには、スレッドコンテキストにユーザID・リクエストID・言語設定を保持する実装が含まれている。
これらを有効化するには以下のリポジトリ設定を追加する。
  (同様にプロジェクト固有の属性を追加することも可能である。)
<pre>
&lt;component class="nablarch.common.handler.threadcontext.ThreadContextHandler"&gt;
  &lt;property name="attributes"&gt;
    &lt;list&gt;
      &lt;!-- ユーザID --&gt;
      &lt;component class="nablarch.common.handler.threadcontext.UserIdAttribute"&gt;
        &lt;property name="sessionKey"  value="user.id" /&gt;
        &lt;property name="anonymousId" value="guest" /&gt;
      &lt;/component&gt;

      &lt;!-- リクエストID --&gt;
      &lt;component class="nablarch.common.handler.threadcontext.RequestIdAttribute" /&gt;

      &lt;!-- 言語 --&gt;
      &lt;component class="nablarch.common.handler.threadcontext.LanguageAttribute"&gt;
          &lt;property name="defaultLanguage" value="ja" /&gt;
      &lt;/component&gt;
    &lt;/list&gt;
  &lt;/property&gt;
&lt;/component&gt;
</pre>

---

## フィールドの詳細

### attributes

```java
private List<ThreadContextAttribute> attributes
```

このハンドラが管理する属性のリスト

---

## コンストラクタの詳細

### ThreadContextHandler

```java
public ThreadContextHandler(ThreadContextAttribute attributes)
```

引数に渡されたスレッドコンテキスト属性を管理するハンドラを生成する。
<pre>
このメソッドの処理は以下のソースコードと等価である。

    new ThreadContextHandler()
        .setAttributes(Arrays.asList(attributes))
</pre>

**パラメータ:**
- `attributes` - スレッドコンテキスト属性

---

### ThreadContextHandler

```java
public ThreadContextHandler()
```

デフォルトコンストラクタ

---

## メソッドの詳細

### handle

```java
public Object handle(Object input, ExecutionContext ctx)
```

{@inheritDoc}
<pre>
このクラスの実装では以下の処理を行う。

  1. スレッドコンテキスト上の全てのエントリを削除する。
  2. このハンドラに登録されている全ての属性について、
     キー(ThreadContextAttribute#getKey()の結果)と値(ThreadContextAttribute#getValue()の結果)を
     スレッドコンテキストに格納する。
  3. 後続のリクエストハンドラに処理を委譲する。
</pre>

---

### setAttributes

```java
public ThreadContextHandler setAttributes(List<ThreadContextAttribute> attributes)
```

このハンドラが管理する属性のリストを登録する。

**パラメータ:**
- `attributes` - このハンドラが管理する属性のリスト

**戻り値:**
このオブジェクト自体

---

### handleInbound

```java
public Result handleInbound(ExecutionContext context)
```

---

### handleOutbound

```java
public Result handleOutbound(ExecutionContext context)
```

---
