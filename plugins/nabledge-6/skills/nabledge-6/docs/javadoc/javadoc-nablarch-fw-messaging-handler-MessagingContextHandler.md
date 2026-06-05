# class MessagingContextHandler

**パッケージ:** nablarch.fw.messaging.handler

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class MessagingContextHandler
implements Handler<Object,Object>
```

メッセージコンテキストの初期化、スレッドコンテキストへの登録、および終端処理の実行
行うハンドラクラス。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### provider

```java
private MessagingProvider provider
```

メッセージング機能の実装

---

## メソッドの詳細

### handle

```java
public Object handle(Object data, ExecutionContext context)
```

{@inheritDoc}
この実装では、後続ハンドラへの処理移譲の前後で、メッセージコンテキストの
初期化および終端処理を行う。

---

### setMessagingProvider

```java
public MessagingContextHandler setMessagingProvider(MessagingProvider provider)
```

メッセージング機能実装を設定する。

**パラメータ:**
- `provider` - メッセージング機能実装実体

**戻り値:**
このインスタンス自体

---
