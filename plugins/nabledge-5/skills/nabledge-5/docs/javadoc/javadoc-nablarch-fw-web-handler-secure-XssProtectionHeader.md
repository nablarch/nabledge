# class XssProtectionHeader

**パッケージ:** nablarch.fw.web.handler.secure

**実装されたインタフェース:**
- SecureResponseHeader

---

```java
public class XssProtectionHeader
implements SecureResponseHeader
```

X-XSS-Protectionレスポンスヘッダを設定するクラス。
<p>
デフォルトでは、X-XSS-Protectionが有効となる。
無効化する場合には、{@link #setEnable(boolean)}に{@code false}を設定する。
また、モードを変更及びモードの出力を抑制したい場合には、{@link #setMode(String)}を使用して設定する。
({@link #setMode(String)}に空文字列を設定すると、モードの出力が抑制される。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### enable

```java
private boolean enable
```

有効にするかどうか

---

### mode

```java
private String mode
```

モード

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

常に出力するので、{@code true}を返す。

---

### setEnable

```java
public void setEnable(boolean enable)
```

X-XSS-Protectionを有効にするか否かを設定する。

**パラメータ:**
- `enable` - {@code true}を設定した場合有効となる

---

### setMode

```java
public void setMode(String mode)
```

モードを設定する。

**パラメータ:**
- `mode` - モード

---
