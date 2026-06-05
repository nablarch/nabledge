# class JavaPackageMappingEntry

**パッケージ:** nablarch.fw.handler

---

```java
public class JavaPackageMappingEntry
```

リクエストパスのパターン文字列とマッピング先Javaパッケージの関連を保持するクラス。

**作成者:** Masato Inoue  

---

## フィールドの詳細

### basePackage

```java
private String basePackage
```

マッピング先Javaパッケージを設定する

---

### helper

```java
private RequestPathMatchingHelper helper
```

リクエストパスとリクエストパスのパターンの照合を行うクラス

---

## メソッドの詳細

### setRequestPattern

```java
public JavaPackageMappingEntry setRequestPattern(String requestPattern)
```

リクエストパスのパターン文字列を設定する。

**パラメータ:**
- `requestPattern` - リクエストパスのパターン文字列

**戻り値:**
このオブジェクト自体

---

### getRequestPathMatching

```java
public RequestPathMatchingHelper getRequestPathMatching()
```

リクエストパスとリクエストパスのパターンの照合を行うクラスを取得する。

**戻り値:**
リクエストパスとリクエストパスのパターンの照合を行うクラス

---

### getBasePackage

```java
public String getBasePackage()
```

マッピング先Javaパッケージを取得する。

**戻り値:**
マッピング先Javaパッケージ

---

### setBasePackage

```java
public JavaPackageMappingEntry setBasePackage(String basePackage)
```

マッピング先Javaパッケージを設定する。

**パラメータ:**
- `basePackage` - マッピング先Javaパッケージ

**戻り値:**
このオブジェクト自体

---
