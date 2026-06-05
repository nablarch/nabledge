# class JavaSerializeEncryptStateEncoder

**パッケージ:** nablarch.common.web.session.encoder

**実装されたインタフェース:**
- StateEncoder

---

```java
public class JavaSerializeEncryptStateEncoder
implements StateEncoder
```

Java標準のSerialize機構、暗号化を使用した{@link StateEncoder}実装クラス。
<p/>
デフォルトでは{@link AesEncryptor}による暗号化を行う。

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### encryptor

```java
private Encryptor<C> encryptor
```

暗号化と復号に使用する{@link Encryptor}

---

### encryptContext

```java
private C encryptContext
```

暗号化と復号に使用するコンテキスト情報

---

## コンストラクタの詳細

### JavaSerializeEncryptStateEncoder

```java
public JavaSerializeEncryptStateEncoder()
```

コンストラクタ。

---

## メソッドの詳細

### setEncryptor

```java
public void setEncryptor(Encryptor<C> encryptor)
```

暗号化/復号に使用する{@link Encryptor}を設定する。

**パラメータ:**
- `encryptor` - 暗号化/復号に使用する{@link Encryptor}

---

### encode

```java
public byte[] encode(T obj)
```

---

### decode

```java
public T decode(byte[] dmp, Class<T> type)
```

---
