# class SessionConcurrentAccessHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class SessionConcurrentAccessHandler
implements Handler<Object,Object>
```

セッションスコープに対する並行アクセス制御を行うハンドラ。

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  
**非推奨:** 本ハンドラは、{@link nablarch.common.web.session.SessionStore}を用いてセッション管理を行う
            {@link nablarch.common.web.session.SessionStoreHandler}に置き換わりました。  

---

## フィールドの詳細

### concurrentAccessPolicy

```java
private ConcurrentAccessPolicy concurrentAccessPolicy
```

セッションスコープ変数に対する並行アクセス同期ポリシー

---

### conflictWarningMessageId

```java
private String conflictWarningMessageId
```

セッションへの書き込みの際に競合が発生した場合に表示されるメッセージのID

---

### THROWS_ON_SESSION_WRITE_CONFLICT

```java
private static final ThreadLocal<Boolean> THROWS_ON_SESSION_WRITE_CONFLICT
```

セッション変更の書き戻しに失敗した場合に実行時例外を送出するか否か

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## メソッドの詳細

### handle

```java
public Object handle(Object req, ExecutionContext ctx)
```

{@inheritDoc}
このハンドラの実装では、各並行アクセスポリシーを実装したMapWrapperによって
実行コンテキスト上のセッションスコープをラップし、同期アクセス制御を開始する。
その後、後続ハンドラに処理を委譲する。

同期制御はこのハンドラの終了とともに停止する。
そのため、JSPサーブレットからのセッション書込みを同期対象に含めるには、
本ハンドラをレスポンスハンドラより上位に配置する必要がある。

---

### manageSessionRWConfliction

```java
private void manageSessionRWConfliction(ExecutionContext ctx, RuntimeException e)
```

セッション書き込みの競合が発生した旨を知らせるワーニングを追加する。

**パラメータ:**
- `ctx` - 実行コンテキスト
- `e` - RuntimeException

---

### setConcurrentAccessPolicy

```java
public SessionConcurrentAccessHandler setConcurrentAccessPolicy(String policyName)
                                                         throws IllegalArgumentException
```

セッションスコープ変数に対する並行アクセス同期ポリシーを定義する。
<p>
補足：<br>
version 1.5.0以降では、"CONCURRENT" のみ有効。本メソッドは互換性のために残っている。
</p>

**パラメータ:**
- `policyName` - 平行アクセス同期ポリシーの名称(version 1.5.0以降では、"CONCURRENT" のみ有効)

**戻り値:**
このオブジェクト自体

**例外:**
- `IllegalArgumentException` - 上記以外の文字列を指定した場合。

---

### getConcurrentAccessPolicy

```java
public ConcurrentAccessPolicy getConcurrentAccessPolicy()
```

並行アクセス同期ポリシーを返す。
<pre>
</pre>

**戻り値:**
現状のセッションスコープ変数に対する並行アクセス同期ポリシー。
version 1.5.0以降では、{@link ConcurrentAccessPolicy.CONCURRENT}が常に返却される。

---

### setConflictWarningMessageId

```java
public void setConflictWarningMessageId(String messageId)
```

セッションへの書き込みの際に競合が発生した場合に表示される文言の
メッセージIDを設定する。

**パラメータ:**
- `messageId` - メッセージID

---

### lockSession

```java
public static void lockSession(Map<String,Object> session)
```

セッションオブジェクトに対する排他ロックを獲得する。

**パラメータ:**
- `session` - セッションオブジェクト

---

### unlockSession

```java
public static void unlockSession(Map<String,Object> session)
```

カレントスレッドがセッションオブジェクトに対する排他ロックを
保持しているばあい、それを開放する。

**パラメータ:**
- `session` - セッションオブジェクト

---

### getSessionLock

```java
private static Lock getSessionLock(Map<String,Object> session)
```

カレントスレッドが保持しているセッションオブジェクトに対する排他ロックを返す。

**パラメータ:**
- `session` - セッションオブジェクト

**戻り値:**
セッションオブジェクトに対する排他ロック
         (保持していない場合はnullを返す。)

---

### setThrowsErrorOnSessionWriteConflict

```java
public static void setThrowsErrorOnSessionWriteConflict(boolean throwsError)
```

セッション変更の書き戻しに失敗した場合に実行時例外を送出するか否かを設定する。
<pre>
明示的に設定しない場合のデフォルトはfalse。
この場合、エラー画面にワーニングが表示されるものの、DBのトランザクションは正常にコミットされる。
</pre>

**パラメータ:**
- `throwsError` - 例外を送出する場合はtrue

---
