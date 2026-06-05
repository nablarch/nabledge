# class SecureResponseHeaderSupport

**パッケージ:** nablarch.fw.web.handler.secure

**実装されたインタフェース:**
- SecureResponseHeader

---

```java
public abstract class SecureResponseHeaderSupport
implements SecureResponseHeader
```

単純な{@link SecureResponseHeader}の実装を提供するサポートクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### name

```java
private String name
```

レスポンスヘッダの名前

---

### value

```java
private String value
```

レスポンスヘッダに指定する値

---

## コンストラクタの詳細

### SecureResponseHeaderSupport

```java
protected SecureResponseHeaderSupport(String name, String defaultValue)
```

コンストラクタ。

**パラメータ:**
- `name` - レスポンスヘッダの名前
- `defaultValue` - レスポンスヘッダに指定する値のデフォルト

---

## メソッドの詳細

### getName

```java
public String getName()
```

---

### getValue

```java
public String getValue()
```

---

### isOutput

```java
public boolean isOutput(HttpResponse response, ServletExecutionContext context)
```

---

### setValue

```java
public void setValue(String value)
```

レスポンスヘッダに指定する値を設定する。

**パラメータ:**
- `value` - レスポンスヘッダに指定する値

---
