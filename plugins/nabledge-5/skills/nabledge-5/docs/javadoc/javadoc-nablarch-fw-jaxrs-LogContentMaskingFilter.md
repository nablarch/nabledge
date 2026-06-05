# interface LogContentMaskingFilter

**パッケージ:** nablarch.fw.jaxrs

---

```java
public interface LogContentMaskingFilter
```

ログに出力する文字列をマスク処理するためのフィルタ。

---

## メソッドの詳細

### initialize

```java
void initialize(Map<String,String> props)
```

初期化する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### mask

```java
String mask(String content)
```

マスク対象のパターンにマッチする箇所をマスクする。

**パラメータ:**
- `content` - マスク対象の文字列

**戻り値:**
マスク後の文字列

---
