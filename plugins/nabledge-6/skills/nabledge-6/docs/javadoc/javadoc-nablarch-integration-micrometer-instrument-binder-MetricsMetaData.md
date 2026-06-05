# class MetricsMetaData

**パッケージ:** nablarch.integration.micrometer.instrument.binder

---

```java
public class MetricsMetaData
```

メトリクスに設定する情報（名前、説明、タグ）を保持するデータクラス。

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### name

```java
private final String name
```

メトリクス名。

---

### description

```java
private final String description
```

メトリクスの説明。

---

### tags

```java
private final Iterable<Tag> tags
```

タグの一覧。

---

## コンストラクタの詳細

### MetricsMetaData

```java
public MetricsMetaData(String name, String description, Iterable<Tag> tags)
```

名前、説明、タグ一覧を指定するコンストラクタ。

**パラメータ:**
- `name` - メトリクスの名前
- `description` - メトリクスの説明
- `tags` - メトリクスに設定するタグ一覧

---

### MetricsMetaData

```java
public MetricsMetaData(String name, String description)
```

名前、説明を指定するコンストラクタ。

**パラメータ:**
- `name` - メトリクスの名前
- `description` - メトリクスの説明

---

## メソッドの詳細

### getName

```java
public String getName()
```

メトリクスの名前を取得する。

**戻り値:**
メトリクスの名前

---

### getDescription

```java
public String getDescription()
```

メトリクスの説明を取得する。

**戻り値:**
メトリクスの説明

---

### getTags

```java
public Iterable<Tag> getTags()
```

タグ一覧を取得する。

**戻り値:**
タグ一覧

---
