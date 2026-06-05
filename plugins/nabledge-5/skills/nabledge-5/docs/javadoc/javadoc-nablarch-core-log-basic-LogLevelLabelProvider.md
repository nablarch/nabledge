# class LogLevelLabelProvider

**パッケージ:** nablarch.core.log.basic

---

```java
public class LogLevelLabelProvider
```

{@link LogLevel}を表す文言を提供するクラス。<br>
<br>
{@link LogLevel}を表す文言を{@link LogFormatter}の設定から取得する。<br>
設定がない場合は、{@link LogLevel}の名称を使用する。<br>
<br>
プロパティファイルの記述ルールを下記に示す。
<dl>
  <dt>label.&lt;{@link LogLevel}の名称の小文字&gt;
  <dd>{@link LogLevel}に使用するラベル。オプション。<br>
      指定しなければ{@link LogLevel}の名称を使用する。
</dl>

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### fatalLabel

```java
private String fatalLabel
```

FATALレベルに使用するラベル

---

### errorLabel

```java
private String errorLabel
```

ERRORレベルに使用するラベル

---

### warnLabel

```java
private String warnLabel
```

WARNレベルに使用するラベル

---

### infoLabel

```java
private String infoLabel
```

INFOレベルに使用するラベル

---

### debugLabel

```java
private String debugLabel
```

DEBUGレベルに使用するラベル

---

### traceLabel

```java
private String traceLabel
```

TRACEレベルに使用するラベル

---

## コンストラクタの詳細

### LogLevelLabelProvider

```java
public LogLevelLabelProvider(ObjectSettings settings)
```

コンストラクタ。<br>
<br>
{@link LogFormatter}の設定を使用してラベルを初期化する。<br>
指定がない場合は、{@link LogLevel}の名称を使用する。

**パラメータ:**
- `settings` - {@link LogFormatter}の設定

---

## メソッドの詳細

### getLevelLabel

```java
protected String getLevelLabel(ObjectSettings settings, LogLevel level)
```

指定された{@link LogLevel}に対するラベルを取得する。

**パラメータ:**
- `settings` - {@link LogFormatter}の設定
- `level` - {@link LogLevel}

**戻り値:**
指定された{@link LogLevel}に対するラベル

---

### getLevelLabel

```java
public String getLevelLabel(LogLevel level)
```

{@link LogLevel}に使用するラベルを取得する。

**パラメータ:**
- `level` - {@link LogLevel}

**戻り値:**
{@link LogLevel}に使用するラベル

---
