# class LettuceSimpleRedisClient

**パッケージ:** nablarch.integration.redisstore.lettuce

**継承階層:**
```
java.lang.Object
  └─ AbstractLettuceRedisClient
      └─ nablarch.integration.redisstore.lettuce.LettuceSimpleRedisClient
```

**実装されたインタフェース:**
- Initializable

---

```java
public class LettuceSimpleRedisClient
extends AbstractLettuceRedisClient
implements Initializable
```

単一の Redis インスタンスに直接接続するためのシンプルな {@link LettuceRedisClient} 実装クラス。
<p>
このクラスの {@link #getType()} は、識別子 {@code "simple"} を返す。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### client

```java
private RedisClient client
```

---

### connection

```java
private StatefulRedisConnection<byte[],byte[]> connection
```

---

### commands

```java
private RedisCommands<byte[],byte[]> commands
```

---

### uri

```java
protected String uri
```

接続するRedisサーバーのURI。

---

## コンストラクタの詳細

### LettuceSimpleRedisClient

```java
public LettuceSimpleRedisClient()
```

コンストラクタ。

---

## メソッドの詳細

### set

```java
public void set(String key, byte[] value)
```

---

### pexpire

```java
public void pexpire(String key, long milliseconds)
```

---

### pexpireat

```java
public void pexpireat(String key, long milliseconds)
```

---

### pttl

```java
public long pttl(String key)
```

---

### get

```java
public byte[] get(String key)
```

---

### del

```java
public void del(String key)
```

---

### exists

```java
public boolean exists(String key)
```

---

### setUri

```java
public void setUri(String uri)
```

接続するRedisサーバーのURIを設定する。
<p>
URIの書式については、<a href="https://lettuce.io/core/release/reference/#redisuri.uri-syntax">Lettuceのドキュメント</a>を参照。
</p>

**パラメータ:**
- `uri` - 接続するRedisサーバーのURI

---

### initialize

```java
public void initialize()
```

{@inheritDoc}
<p>
このメソッドは、 {@link #createClient()} と {@link #createConnection(RedisClient)} メソッドを使って
{@link RedisClient} と {@link StatefulRedisConnection} のインスタンスを生成している。<br>
これらのインスタンスの設定を任意にカスタマイズしたい場合は、このクラスを継承したサブクラスを作り、
それぞれの {@code create} メソッドをオーバーライドすること。
</p>

---

### createClient

```java
protected RedisClient createClient()
```

{@link RedisClient} のインスタンスを生成する。

**戻り値:**
生成された {@link RedisClient}

---

### createConnection

```java
protected StatefulRedisConnection<byte[],byte[]> createConnection(RedisClient client)
```

{@link StatefulRedisConnection} のインスタンスを生成する。

**パラメータ:**
- `client` - {@link #createClient()} で生成された {@link RedisClient} インスタンス

**戻り値:**
生成された {@link StatefulRedisConnection}

---

### dispose

```java
public void dispose()
```

---
