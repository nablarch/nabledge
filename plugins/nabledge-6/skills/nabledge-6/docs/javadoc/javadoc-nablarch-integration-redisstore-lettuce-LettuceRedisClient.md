# interface LettuceRedisClient

**パッケージ:** nablarch.integration.redisstore.lettuce

**継承階層:**
```
java.lang.Object
  └─ Disposable
      └─ nablarch.integration.redisstore.lettuce.LettuceRedisClient
```

---

```java
public interface LettuceRedisClient
extends Disposable
```

セッションストアの実装に必要となる Redis コマンドを定義したインターフェース。

**作成者:** Tanaka Tomoyuki  

---

## メソッドの詳細

### getType

```java
String getType()
```

実装クラスを識別する種別を取得する。

**戻り値:**
実装クラスを識別する値

---

### set

```java
void set(String key, byte[] value)
```

値を保存する。

**パラメータ:**
- `key` - キー
- `value` - 値

---

### pexpire

```java
void pexpire(String key, long milliseconds)
```

キーの有効期限を設定する。

**パラメータ:**
- `key` - キー
- `milliseconds` - 有効期限（ミリ秒）

---

### pexpireat

```java
void pexpireat(String key, long milliseconds)
```

キーの有効期限をUTC時間で設定する

**パラメータ:**
- `key` - キー
- `milliseconds` - UTC時間で指定された有効期限（ミリ秒）

---

### pttl

```java
long pttl(String key)
```

キーの残りの生存期間を取得する。
<p>
キーに有効期限が設定されていない場合は {@code -1} を返し、
キーが存在しない場合は {@code -2} を返す。
</p>

**パラメータ:**
- `key` - キー

**戻り値:**
残りの生存期間（ミリ秒）

---

### get

```java
byte[] get(String key)
```

値を取得する。
<p>
該当するキーが存在しない場合は {@code null} を返す。
</p>

**パラメータ:**
- `key` - キー

**戻り値:**
値

---

### del

```java
void del(String key)
```

値を削除する。

**パラメータ:**
- `key` - キー

---

### exists

```java
boolean exists(String key)
```

指定したキーが存在するか確認する。

**パラメータ:**
- `key` - キー

**戻り値:**
キーが存在する場合は {@code true}

---

### dispose

```java
void dispose()
```

Redisサーバーとの接続を閉じる。

---
