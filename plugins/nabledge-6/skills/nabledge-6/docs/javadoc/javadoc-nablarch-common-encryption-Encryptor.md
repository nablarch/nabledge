# interface Encryptor

**パッケージ:** nablarch.common.encryption

---

```java
public interface Encryptor
```

暗号化と復号を行うインタフェース。

**作成者:** Kiyohito Itoh  
**param:** 暗号化と復号に使用するコンテキスト情報の型  

---

## メソッドの詳細

### generateContext

```java
C generateContext()
```

暗号化と復号に使用するコンテキスト情報を生成する。<br>
コンテキスト情報には、共通鍵暗号方式であれば使用する共通鍵を保持する。

**戻り値:**
暗号化と復号に使用するコンテキスト情報

---

### encrypt

```java
byte[] encrypt(C context, byte[] src)
               throws IllegalArgumentException
```

コンテキスト情報を使用して暗号化を行う。

**パラメータ:**
- `context` - コンテキスト情報
- `src` - 暗号元

**戻り値:**
暗号結果

**例外:**
- `IllegalArgumentException` - 暗号化できなかった場合

---

### decrypt

```java
byte[] decrypt(C context, byte[] src)
               throws IllegalArgumentException
```

コンテキスト情報を使用して復号を行う。

**パラメータ:**
- `context` - コンテキスト情報
- `src` - 復号元

**戻り値:**
復号結果

**例外:**
- `IllegalArgumentException` - 復号できなかった場合

---
