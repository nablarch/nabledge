# class JaxRsBodyMaskingFilter

**パッケージ:** nablarch.fw.jaxrs

**実装されたインタフェース:**
- LogContentMaskingFilter

---

```java
public class JaxRsBodyMaskingFilter
implements LogContentMaskingFilter
```

ログ出力するJAX-RSのボディ文字列をマスク処理するフィルタ。

---

## フィールドの詳細

### PROP_PREFIX

```java
private static final String PROP_PREFIX
```

プロパティ名のプレフィックス

---

### maskingString

```java
private String maskingString
```

マスク文字

---

### maskingJsonPatterns

```java
private List<Pattern> maskingJsonPatterns
```

マスク対象のJSON文字列パターン

---

## メソッドの詳細

### initialize

```java
public void initialize(Map<String,String> props)
```

---

### getMaskingString

```java
protected String getMaskingString(Map<String,String> props)
```

マスク文字列を取得する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

**戻り値:**
マスク文字列

---

### getMaskingChar

```java
protected char getMaskingChar(Map<String,String> props)
```

マスク文字を取得する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

**戻り値:**
マスク文字

---

### getMaskingJsonPatterns

```java
protected List<Pattern> getMaskingJsonPatterns(Map<String,String> props)
```

マスク対象のJSON文字列パターンを取得する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

**戻り値:**
マスク対象のパターン

---

### mask

```java
public String mask(String content)
```

---
