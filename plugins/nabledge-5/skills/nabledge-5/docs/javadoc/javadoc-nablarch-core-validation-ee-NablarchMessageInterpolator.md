# class NablarchMessageInterpolator

**パッケージ:** nablarch.core.validation.ee

**実装されたインタフェース:**
- MessageInterpolator

---

```java
public class NablarchMessageInterpolator
implements MessageInterpolator
```

Nablarchのメッセージ管理機能を使用してメッセージを構築するクラス。
<p>
この実装では、メッセージの取得処理を{@link MessageUtil#createMessage(MessageLevel, String, Object...)}に委譲する。
{@link MessageUtil#createMessage(MessageLevel, String, Object...)}に指定するメッセージIDは以下のルールにより導出する。
<ol>
<li>メッセージが"{"、"}"で囲まれていてメッセージ内に"}"が存在しない場合は、前後のカッコを取り除いた値をメッセージIDとする。</li>
<li>上記以外の場合は、メッセージをデフォルトの{@link MessageInterpolator}によりメッセージに変換する。</li>
</ol>
<p>
以下に例をしめす。
<pre>
<code>
// カッコが取り除かれ「user.required.message」がメッセージIDとなる。
{@literal @}Required(message = "{user.required.message}")

// 「{user.{required}.message}」をメッセージとして、
// デフォルトのMessageInterpolatorによりメッセージを構築する。
{@literal @}Required(message = "{user.{required}.message}")

// 「入力してください。」をメッセージとして、
// デフォルトのMessageInterpolatorによりメッセージを構築する。
{@literal @}Required(message = "入力してください。")
</code>
</pre>

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### MESSAGE_ID_PATTERN

```java
private static final Pattern MESSAGE_ID_PATTERN
```

メッセージIDの形式

---

### defaultMessageInterpolator

```java
private final MessageInterpolator defaultMessageInterpolator
```

デフォルトの{@link MessageInterpolator}

---

## メソッドの詳細

### interpolate

```java
public String interpolate(String message, Context context)
```

---

### interpolate

```java
public String interpolate(String message, Context context, Locale locale)
```

---

### isMessageId

```java
private static boolean isMessageId(String message)
```

メッセージがメッセージID形式かどうか判定する。
<p>
メッセージが、"{"、"}"で囲まれている場合はメッセージID形式とする。
ただし、メッセージ中に"}"がある場合は、メッセージID形式とはならない。

**パラメータ:**
- `message` - メッセージ

**戻り値:**
メッセージID形式の場合{@code true}

---

### getMessageId

```java
private static String getMessageId(String message)
```

メッセージIDを取得する。
<p>
メッセージIDの前後の"{"、"}"を除去する。

**パラメータ:**
- `message` - メッセージ

**戻り値:**
メッセージID

---
