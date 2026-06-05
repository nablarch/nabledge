# class MBeanAttributeCondition

**パッケージ:** nablarch.integration.micrometer.instrument.binder.jmx

---

```java
public class MBeanAttributeCondition
```

JMXで取得するMBeanのAttributeを特定するための、オブジェクト名と属性名を保持したデータクラス。

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### objectName

```java
private final String objectName
```

オブジェクト名。

---

### attribute

```java
private final String attribute
```

属性名。

---

## コンストラクタの詳細

### MBeanAttributeCondition

```java
public MBeanAttributeCondition(String objectName, String attribute)
```

オブジェクト名と属性を指定するコンストラクタ。

**パラメータ:**
- `objectName` - オブジェクト名
- `attribute` - 属性名

---

## メソッドの詳細

### getObjectName

```java
public String getObjectName()
```

オブジェクト名を取得する。

**戻り値:**
オブジェクト名

---

### getAttribute

```java
public String getAttribute()
```

属性名を取得する。

**戻り値:**
属性名

---
