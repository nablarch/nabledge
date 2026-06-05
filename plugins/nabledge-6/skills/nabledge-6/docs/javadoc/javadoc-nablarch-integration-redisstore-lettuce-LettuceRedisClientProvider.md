# class LettuceRedisClientProvider

**パッケージ:** nablarch.integration.redisstore.lettuce

**実装されたインタフェース:**
- ComponentFactory<LettuceRedisClient>

---

```java
public class LettuceRedisClientProvider
implements ComponentFactory<LettuceRedisClient>
```

{@link LettuceRedisClient} のインスタンスを提供するクラス。
<p>
このクラスは、 {@link #setClientList(List)} で設定されたリストの中から、
{@link LettuceRedisClient#getType()} が返した値と {@link #setClientType(String)} で設定された値が
一致するインスタンスを検索し、最初に該当したインスタンスを {@link #createObject()} の結果として返す。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### clientType

```java
private String clientType
```

---

### clientList

```java
private List<LettuceRedisClient> clientList
```

---

## メソッドの詳細

### createObject

```java
public LettuceRedisClient createObject()
```

---

### createNoClientMatchesException

```java
private ContainerProcessException createNoClientMatchesException()
```

該当する {@link LettuceRedisClient} が見つからなかったときの例外を構築する。

**戻り値:**
構築した例外

---

### setClientType

```java
public void setClientType(String clientType)
```

使用する {@link LettuceRedisClient} の実装を識別する値。

**パラメータ:**
- `clientType` - {@link LettuceRedisClient} の実装を識別する値

---

### setClientList

```java
public void setClientList(List<LettuceRedisClient> clientList)
```

候補となる {@link LettuceRedisClient} インスタンスのリストを設定する。

**パラメータ:**
- `clientList` - {@link LettuceRedisClient} のリスト

---
