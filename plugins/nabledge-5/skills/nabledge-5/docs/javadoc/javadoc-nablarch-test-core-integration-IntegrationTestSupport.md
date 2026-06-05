# class IntegrationTestSupport

**パッケージ:** nablarch.test.core.integration

**継承階層:**
```
java.lang.Object
  └─ TestEventDispatcher
      └─ nablarch.test.core.integration.IntegrationTestSupport
```

---

```java
public class IntegrationTestSupport
extends TestEventDispatcher
```

結合テストサポートクラス。

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### testClass

```java
private Class<?> testClass
```

テストクラス。

---

## コンストラクタの詳細

### IntegrationTestSupport

```java
public IntegrationTestSupport(Class<?> testClass)
```

コンストラクタ

**パラメータ:**
- `testClass` - テストクラス

---

### IntegrationTestSupport

```java
protected IntegrationTestSupport()
```

コンストラクタ。

---

## メソッドの詳細

### setUpDbBeforeTestMethod

```java
public void setUpDbBeforeTestMethod()
```

テストメソッド実行前にデータベースセットアップを実行する。

---

### executeBatch

```java
public void executeBatch(String sheetName)
```

バッチ処理方式のテストを実行する。

**パラメータ:**
- `sheetName` - シート名

---

### executeMessagingSync

```java
public void executeMessagingSync(String sheetName)
```

メッセージ同期応答方式のテストを実行する。

**パラメータ:**
- `sheetName` - シート名

---

### executeOnline

```java
public void executeOnline(String sheetName, String baseUri)
```

オンライン処理方式のテストを実行する。

**パラメータ:**
- `sheetName` - シート名
- `baseUri` - ベースURI

---

### executeOnline

```java
public void executeOnline(String sheetName, String baseUri, Advice advice)
```

オンライン処理方式のテストを実行する。

**パラメータ:**
- `sheetName` - シート名
- `baseUri` - ベースURI
- `advice` - コールバック

---

### createInstance

```java
protected AbstractHttpRequestTestTemplate createInstance(String baseUri)
```

インスタンスを生成する。

**パラメータ:**
- `baseUri` - ベースURI

**戻り値:**
インスタンス

---
