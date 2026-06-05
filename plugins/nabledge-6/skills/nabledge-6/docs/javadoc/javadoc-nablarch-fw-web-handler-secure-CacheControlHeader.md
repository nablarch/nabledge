# class CacheControlHeader

**パッケージ:** nablarch.fw.web.handler.secure

**継承階層:**
```
java.lang.Object
  └─ SecureResponseHeaderSupport
      └─ nablarch.fw.web.handler.secure.CacheControlHeader
```

---

```java
public class CacheControlHeader
extends SecureResponseHeaderSupport
```

Cache-Controlレスポンスヘッダを設定するクラス。

デフォルトは"no-store"。

Cache-Controlレスポンスヘッダを個別に指定したいケースに対応するため、
Cache-Controlレスポンスヘッダが設定されてない場合のみ設定を行う。
上書きは行わない。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### NAME

```java
private static final String NAME
```

---

## コンストラクタの詳細

### CacheControlHeader

```java
public CacheControlHeader()
```

コンストラクタ。

---

## メソッドの詳細

### isOutput

```java
public boolean isOutput(HttpResponse response, ServletExecutionContext context)
```

---
