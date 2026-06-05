# interface MessagingProvider

**パッケージ:** nablarch.fw.messaging

---

```java
public interface MessagingProvider
```

メッセージング機能の基本API({@link MessagingContext})の実装系を提供する
モジュールが実装するインターフェース。
<p/>
本インターフェースの実装系の切り替えによって多様なメッセージングミドルウェアに
対応することができる。

**作成者:** Iwauo Tajima  

---

## メソッドの詳細

### createContext

```java
MessagingContext createContext()
```

メッセージングコンテキストを返す。

**戻り値:**
メッセージングコンテキスト

---

### setDefaultResponseTimeout

```java
MessagingProvider setDefaultResponseTimeout(long timeout)
```

同期送信処理における応答受信待ちのデフォルトタイムアウト値を設定する。
(単位:msec)

**パラメータ:**
- `timeout` - デフォルトタイムアウト値 (単位:msec)

**戻り値:**
このオブジェクト自体

---

### setDefaultTimeToLive

```java
MessagingProvider setDefaultTimeToLive(long timeToLive)
```

送信電文の有効期間のデフォルト値を設定する。 (単位:msec)

**パラメータ:**
- `timeToLive` - 送信電文の有効期間 (単位:msec)

**戻り値:**
このオブジェクト自体

---

### setMessagingExceptionFactory

```java
MessagingProvider setMessagingExceptionFactory(MessagingExceptionFactory messagingExceptionFactory)
```

{@link MessagingException}ファクトリオブジェクトを設定する。

**パラメータ:**
- `messagingExceptionFactory` - {@link MessagingException}ファクトリオブジェクト

**戻り値:**
このオブジェクト自体

---
