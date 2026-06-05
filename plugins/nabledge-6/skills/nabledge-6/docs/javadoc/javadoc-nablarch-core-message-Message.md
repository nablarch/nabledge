# class Message

**パッケージ:** nablarch.core.message

---

```java
public class Message
```

メッセージに必要な情報を保持し、メッセージのフォーマットを行うクラス。<br/>

**作成者:** Koichi Asano  

---

## フィールドの詳細

### DEFAULT_MESSAGE_FORMATTER

```java
private static final MessageFormatter DEFAULT_MESSAGE_FORMATTER
```

デフォルトのメッセージフォーマッタ

---

### level

```java
private final MessageLevel level
```

メッセージの通知レベル。

---

### stringResource

```java
private final StringResource stringResource
```

メッセージの文字列リソース。

---

### option

```java
private final Object[] option
```

メッセージのパラメータ。

---

### DEFAULT_LOCALE

```java
private static final Locale DEFAULT_LOCALE
```

デフォルトの言語

---

## コンストラクタの詳細

### Message

```java
public Message(MessageLevel level, StringResource stringResource)
```

メッセージの通知レベル、文字列リソースを指定して、インスタンスを生成する。

**パラメータ:**
- `level` - メッセージの通知レベル
- `stringResource` - メッセージの文字列リソース

---

### Message

```java
public Message(MessageLevel level, StringResource stringResource, Object[] option)
```

メッセージの通知レベル、文字列リソース、オプションパラメータを指定して、インスタンスを生成する。

**パラメータ:**
- `level` - メッセージの通知レベル
- `stringResource` - メッセージの文字列リソース
- `option` - メッセージのオプションパラメータ

---

## メソッドの詳細

### getLevel

```java
public MessageLevel getLevel()
```

メッセージの通知レベルを取得する。

**戻り値:**
メッセージの通知レベル

---

### getMessageId

```java
public String getMessageId()
```

文字列リソースのメッセージIDを取得する。

**戻り値:**
文字列リソースのメッセージID

---

### formatMessage

```java
public String formatMessage()
```

フォーマットしたメッセージを取得する。
<p/>
メッセージの言語には{@link ThreadContext#getLanguage()}に設定された言語を使用する。
スレッドコンテキストに設定されていない場合は、{@link Locale#getDefault()}から取得した言語を返す。

**戻り値:**
フォーマットしたメッセージ

---

### getLanguage

```java
private static Locale getLanguage()
```

スレッドコンテキストから言語を取得する。

スレッドコンテキストに設定されていない場合は
{@link Locale#getDefault()}から取得した言語を返す。

**戻り値:**
言語

---

### formatMessage

```java
public String formatMessage(Locale locale)
```

言語を指定してフォーマットしたメッセージを取得する。<br/>
オプションパラメータにMessageが含まれていた場合、フォーマットして使用する。
オプションパラメータにStringResourceが含まれていた場合、言語に対応する文字列を取得して使用する。

**パラメータ:**
- `locale` - メッセージの言語

**戻り値:**
フォーマットしたメッセージ

---

### equals

```java
public boolean equals(Object o)
```

文字列リソースが等価であるか判定する。

---

### equals

```java
private boolean equals(StringResource one, StringResource another)
```

文字列リソースが等価であるか判定する。

**パラメータ:**
- `one` - 比較対象１
- `another` - 比較対象２

**戻り値:**
比較対象オブジェクトが等価の場合{@code true}

---

### hashCode

```java
public int hashCode()
```

---

### getMessageFormatter

```java
private MessageFormatter getMessageFormatter()
```

メッセージフォーマッタを取得する。

**戻り値:**
メッセージフォーマッター

---
