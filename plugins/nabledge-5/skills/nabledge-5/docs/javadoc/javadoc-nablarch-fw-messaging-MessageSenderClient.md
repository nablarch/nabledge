# interface MessageSenderClient

**パッケージ:** nablarch.fw.messaging

---

```java
public interface MessageSenderClient
```

{@link MessageSender}から呼び出される通信機能の基本APIの実装系を提供するモジュールが実装するインターフェース。<br />
<p>
類似の機能を持つインターフェースとして、{@link MessagingProvider}が存在する。<br />
{@link MessagingProvider}との主な相違点は、キューの存在を仮定した実装が存在していないことである。
</p>

**作成者:** Masaya Seko  

---

## メソッドの詳細

### sendSync

```java
SyncMessage sendSync(MessageSenderSettings settings, SyncMessage requestMessage)
```

同期通信を行う。

**パラメータ:**
- `settings` - {@link MessageSender}の設定情報
- `requestMessage` - 要求電文

**戻り値:**
応答電文

---
