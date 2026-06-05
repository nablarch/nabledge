# class FrameOptionsHeader

**パッケージ:** nablarch.fw.web.handler.secure

**実装されたインタフェース:**
- SecureResponseHeader

---

```java
public class FrameOptionsHeader
implements SecureResponseHeader
```

X-Frame-Optionsレスポンスヘッダを設定するクラス。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### option

```java
private OPTIONS option
```

X-Frame-Optionsヘッダーに設定する値

---

## コンストラクタの詳細

### FrameOptionsHeader

```java
public FrameOptionsHeader()
```

デフォルトの設定でオブジェクトを構築する。

---

## メソッドの詳細

### setOption

```java
public void setOption(String xFrameOptions)
```

X-Frame-Optionsを設定する。

**パラメータ:**
- `xFrameOptions` - X-Frame-Optionsの値

---

### isOutput

```java
public boolean isOutput(HttpResponse response, ServletExecutionContext context)
```

{@link OPTIONS#NONE}以外の場合は出力する。

---

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
