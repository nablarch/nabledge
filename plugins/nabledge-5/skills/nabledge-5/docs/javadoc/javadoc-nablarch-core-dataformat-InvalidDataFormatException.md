# class InvalidDataFormatException

**パッケージ:** nablarch.core.dataformat

**継承階層:**
```
java.lang.Object
  └─ RuntimeException
      └─ nablarch.core.dataformat.InvalidDataFormatException
```

---

```java
public class InvalidDataFormatException
extends RuntimeException
```

入力データおよび出力データの不正により処理が継続できないことを示す例外クラス。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### recordNumber

```java
private int recordNumber
```

エラーが発生したレコード番号

---

### fieldName

```java
private String fieldName
```

エラーが発生したフィールド名

---

### sourcePath

```java
private String sourcePath
```

例外発生原因となった入出力元（ファイルなど）のパス

---

### formatFilePath

```java
private String formatFilePath
```

使用していたフォーマットファイルのパス

---

## コンストラクタの詳細

### InvalidDataFormatException

```java
public InvalidDataFormatException(String message)
```

エラーメッセージを使用して、{@code InvalidDataFormatException}を生成する。

**パラメータ:**
- `message` - エラーメッセージ

---

### InvalidDataFormatException

```java
public InvalidDataFormatException(String message, Throwable throwable)
```

エラーメッセージと起因となった例外を使用して、{@code InvalidDataFormatException}を生成する。

**パラメータ:**
- `message` - エラーメッセージ
- `throwable` - 起因となった例外

---

## メソッドの詳細

### getMessage

```java
public String getMessage()
```

エラーメッセージを返却する。
<p/>
エラーメッセージには、以下のうち設定されている項目のみが含まれる。
<ul>
    <li>例外発生原因となった入出力元（ファイルなど）のパス</li>
    <li>エラーが発生したフィールド名</li>
    <li>エラーが発生したレコード番号</li>
    <li>使用していたフォーマットファイルのパス</li>
</ul>

**戻り値:**
エラーメッセージ

---

### setRecordNumber

```java
public InvalidDataFormatException setRecordNumber(int recordNumber)
```

エラーが発生したレコード番号を設定する。

**パラメータ:**
- `recordNumber` - エラーが発生したレコード番号

**戻り値:**
このオブジェクト自体

---

### setFieldName

```java
public InvalidDataFormatException setFieldName(String fieldName)
```

エラーが発生したフィールド名を設定する。

**パラメータ:**
- `fieldName` - フィールド名

**戻り値:**
このオブジェクト自体

---

### setInputSourcePath

```java
public InvalidDataFormatException setInputSourcePath(String sourcePath)
```

例外発生原因となった入出力元（ファイルなど）のパスを設定する。

**パラメータ:**
- `sourcePath` - 入出力元のパス

**戻り値:**
このオブジェクト自体

---

### getInputSourcePath

```java
public String getInputSourcePath()
```

例外発生原因となった入出力元（ファイルなど）のパスを取得する。

**戻り値:**
入出力元のパス（設定されていない場合は{@code null}）

---

### getFormatFilePath

```java
public String getFormatFilePath()
```

入出力時に使用していたフォーマットファイルのパスを取得する。

**戻り値:**
フォーマットファイルのパス（設定されていない場合は{@code null}）

---

### setFormatFilePath

```java
public InvalidDataFormatException setFormatFilePath(String formatFilePath)
```

使用していたフォーマットファイルのパスを設定する。

**パラメータ:**
- `formatFilePath` - フォーマットファイルのパス

**戻り値:**
このオブジェクト自体

---

### getFieldName

```java
public String getFieldName()
```

エラーが発生したフィールド名を取得する。

**戻り値:**
フィールド名（設定されていない場合は{@code null}）

---

### getRecordNumber

```java
public int getRecordNumber()
```

エラーが発生したレコード番号を取得する。

**戻り値:**
レコード番号（設定されていない場合は0）

---
