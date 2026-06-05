# class Jackson2BodyConverter

**パッケージ:** nablarch.integration.jaxrs.jackson

**継承階層:**
```
java.lang.Object
  └─ JacksonBodyConverterSupport
      └─ nablarch.integration.jaxrs.jackson.Jackson2BodyConverter
```

---

```java
public class Jackson2BodyConverter
extends JacksonBodyConverterSupport
```

Jackson2.xを使用してリクエスト/レスポンスの変換を行う{@link BodyConverter}実装クラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### objectMapper

```java
private final ObjectMapper objectMapper
```

{@link ObjectMapper}

---

## コンストラクタの詳細

### Jackson2BodyConverter

```java
public Jackson2BodyConverter()
```

{@code JacksonBodyConverter}を生成する。

---

## メソッドの詳細

### configure

```java
protected void configure(ObjectMapper objectMapper)
```

{@link ObjectMapper}に対するオプション設定などを行う。
<p/>
このクラスでは特に何も行わないので、オプション設定はサブクラス側で行う必要がある。

**パラメータ:**
- `objectMapper` - {@link ObjectMapper}

---

### readValue

```java
protected Object readValue(Reader src, Class<?> valueType)
                 throws IOException
```

---

### writeValueAsString

```java
protected String writeValueAsString(Object value)
                          throws IOException
```

---
