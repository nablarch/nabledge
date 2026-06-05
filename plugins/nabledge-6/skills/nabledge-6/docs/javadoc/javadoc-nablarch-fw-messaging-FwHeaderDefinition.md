# interface FwHeaderDefinition

**パッケージ:** nablarch.fw.messaging

---

```java
public interface FwHeaderDefinition
```

送受信電文中のフレームワーク制御ヘッダ項目に対する読み書きを行うモジュールが
実装するインターフェース。
具体的に電文中のどの部分をフレームワーク制御ヘッダの各項目に対応させるかについては、
各具象クラスごとに異なる。

---

## メソッドの詳細

### readFwHeaderFrom

```java
RequestMessage readFwHeaderFrom(ReceivedMessage message)
```

受信電文中のフレームワーク制御ヘッダ部を読み込み、
RequestMessageオブジェクトを生成する。

**パラメータ:**
- `message` - 受信電文オブジェクト

**戻り値:**
要求電文オブジェクト

---

### writeFwHeaderTo

```java
void writeFwHeaderTo(SendingMessage message, FwHeader header)
```

応答電文オブジェクトに設定されたフレームワーク制御ヘッダの内容を
送信電文に反映する。

**パラメータ:**
- `message` - 応答電文オブジェクト
- `header` - フレームワーク制御ヘッダー

---
