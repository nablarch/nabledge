# class BasicExpirationSetting

**パッケージ:** nablarch.core.cache.expirable

**実装されたインタフェース:**
- ExpirationSetting

---

```java
public class BasicExpirationSetting
implements ExpirationSetting
```

{@link ExpirationSetting}の基本実装クラス。
IDと有効期限の紐付けをMapで保持する。

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### PTN

```java
private static final Pattern PTN
```

有効期限のパターン（数字＋アルファベット）

---

### DEFAULT_TIME_UNIT_MAPPING

```java
private static final Map<String,TimeUnit> DEFAULT_TIME_UNIT_MAPPING
```

デフォルトの時間単位

---

### systemTimeProvider

```java
private SystemTimeProvider systemTimeProvider
```

システム日時提供クラス

---

### expirationSetting

```java
private final Map<String,TimeoutExpression> expirationSetting
```

IDと有効期限のマッピング。
（例: "ID001", "100ms"）

---

## メソッドの詳細

### isCacheEnable

```java
public boolean isCacheEnable(String id)
```

{@inheritDoc}

---

### getExpiredDate

```java
public Date getExpiredDate(String id)
```

{@inheritDoc}

---

### setSystemTimeProvider

```java
public void setSystemTimeProvider(SystemTimeProvider systemTimeProvider)
```

システム日時提供クラスを設定する（必須）。
本メソッドはDIコンテナから使用されることを想定している。

**パラメータ:**
- `systemTimeProvider` - システム日時提供クラス

---

### setExpirationList

```java
public void setExpirationList(List<Map<String,String>> expirationList)
```

有効期限設定を設定する（必須）。


本メソッドはDIコンテナから使用されることを想定している。

**パラメータ:**
- `expirationList` - 有効期限設定のリスト

---

### setExpiration

```java
public void setExpiration(Map<String,String> expiration)
```

有効期限設定を設定する（必須）。


本メソッドはDIコンテナから使用されることを想定している。

**パラメータ:**
- `expiration` - 有効期限設定のリスト

---

### getTimeUnitMapping

```java
protected Map<String,TimeUnit> getTimeUnitMapping()
```

時間単位のマッピングを取得する。
本メソッドをオーバーライドすることで、
マッピングを変更することができる。

**戻り値:**
マッピング

---

### evaluate

```java
Date evaluate(String timeoutExpression)
```

有効期限の評価を行う。
文字列で表された有効期限を評価し、システム日時からの差分として返却する。
例えば、"30s"という文字列表現が与えられた場合、システム日時に30秒付加した
日時が返却される。

**パラメータ:**
- `timeoutExpression` - 有効期限の文字列表現

**戻り値:**
有効期限

---
