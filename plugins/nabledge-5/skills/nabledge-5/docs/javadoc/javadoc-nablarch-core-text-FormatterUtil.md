# class FormatterUtil

**パッケージ:** nablarch.core.text

---

```java
public final class FormatterUtil
```

オブジェクトのフォーマットに使用するユーティリティクラス。

**作成者:** Ryota Yoshinouchi  

---

## フィールドの詳細

### FORMATTER_CONFIG

```java
private static final String FORMATTER_CONFIG
```

フォーマッタリストを保持するコンポーネント名。

---

### DEFAULT_CONFIG

```java
private static final FormatterConfig DEFAULT_CONFIG
```

フォーマッタのデフォルト値を設定していない場合に使用するデフォルト値

---

## コンストラクタの詳細

### FormatterUtil

```java
private FormatterUtil()
```

本クラスはインスタンスを生成しない。

---

## メソッドの詳細

### format

```java
public static String format(String formatterName, T input)
```

デフォルトの書式でフォーマットを行う。

**パラメータ:**
- `formatterName` - 使用するフォーマッタの名前
- `input` - フォーマット対象
- `<T>` - フォーマット対象の型

**戻り値:**
フォーマットされた文字列

---

### format

```java
public static String format(String formatterName, T input, String pattern)
```

書式を指定してフォーマットを行う。

**パラメータ:**
- `formatterName` - 使用するフォーマッタの名前
- `input` - フォーマット対象
- `pattern` - フォーマットの書式
- `<T>` - フォーマット対象の型

**戻り値:**
フォーマットされた文字列

---

### getFormatter

```java
private static Formatter<T> getFormatter(String formatterName, Class<?> clazz)
```

システムリポジトリからフォーマッタを取得する。
フォーマッタ名とフォーマット対象の型に対応するフォーマッタが
システムリポジトリに登録されていない場合は例外を送出する。

**パラメータ:**
- `<T>` - フォーマット対象の型
- `formatterName` - 取得するフォーマッタの名前
- `clazz` - フォーマット対象の型

**戻り値:**
フォーマッタ

---
