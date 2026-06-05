# class CharacterReplacementConfig

**パッケージ:** nablarch.core.dataformat

---

```java
public class CharacterReplacementConfig
```

寄せ字変換処理の設定を保持するクラス。

**作成者:** Masato Inoue  

---

## フィールドの詳細

### typeName

```java
private String typeName
```

寄せ字変換タイプ名

---

### filePath

```java
private String filePath
```

寄せ字変換定義ファイルのパス

---

### encoding

```java
private String encoding
```

寄せ字処理の際に使用するエンコーディング

---

### byteLengthCheck

```java
private boolean byteLengthCheck
```

変換前と変換後の文字のバイト長一致チェックの要否

---

## メソッドの詳細

### getFilePath

```java
public String getFilePath()
```

寄せ字変換定義ファイルのパスを取得する。

**戻り値:**
寄せ字変換定義ファイルのパス

---

### setFilePath

```java
public CharacterReplacementConfig setFilePath(String filePath)
```

寄せ字変換定義ファイルのパスを設定する。

**パラメータ:**
- `filePath` - 寄せ字変換定義ファイルのパス

**戻り値:**
このオブジェクト自体

---

### getEncoding

```java
public String getEncoding()
```

寄せ字処理の際に使用するエンコーディングを取得する。

**戻り値:**
寄せ字処理の際に使用するエンコーディング

---

### setEncoding

```java
public CharacterReplacementConfig setEncoding(String encoding)
```

寄せ字処理の際に使用するエンコーディングを設定する。

**パラメータ:**
- `encoding` - 寄せ字処理の際に使用するエンコーディング

**戻り値:**
このオブジェクト自体

---

### getTypeName

```java
public String getTypeName()
```

寄せ字変換タイプ名を取得する。

**戻り値:**
寄せ字変換タイプ名

---

### setTypeName

```java
public CharacterReplacementConfig setTypeName(String typeName)
```

寄せ字変換タイプ名を設定する。

**パラメータ:**
- `typeName` - 寄せ字変換タイプ名

**戻り値:**
このオブジェクト自体

---

### isByteLengthCheck

```java
public boolean isByteLengthCheck()
```

変換前と変換後の文字のバイト長一致チェックの要否を取得する。

**戻り値:**
変換前と変換後の文字のバイト長一致チェックを行う場合、true

---

### setByteLengthCheck

```java
public CharacterReplacementConfig setByteLengthCheck(boolean byteLengthCheck)
```

変換前と変換後の文字のバイト長一致チェックの要否を設定する。

**パラメータ:**
- `byteLengthCheck` - 変換前と変換後の文字のバイト長一致チェックの要否

**戻り値:**
このオブジェクト自体

---
