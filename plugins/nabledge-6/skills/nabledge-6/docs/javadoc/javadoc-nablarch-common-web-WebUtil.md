# class WebUtil

**パッケージ:** nablarch.common.web

---

```java
public final class WebUtil
```

Webアプリケーションの作成に必要となる共通機能を提供するユーティリティ。

**作成者:** Kiyohito Itoh  

---

## コンストラクタの詳細

### WebUtil

```java
private WebUtil()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### notifyMessages

```java
public static void notifyMessages(ExecutionContext context, Message messages)
```

メッセージをユーザに通知する。
<pre>{@code
WebUtil.notifyMessages(context, MessageUtil.createMessage(MessageLevel.ERROR, "メッセージID"));
}</pre>
既にメッセージが存在する場合は既存メッセージの末尾に追加する。<br />
指定されたメッセージは n:errors タグを使用して出力する。<br />

**パラメータ:**
- `context` - 実行コンテキスト
- `messages` - メッセージ

---

### containsPropertyKey

```java
public static boolean containsPropertyKey(ValidationContext context, String key)
```

---

### containsPropertyKeyValue

```java
public static boolean containsPropertyKeyValue(ValidationContext context, String key, String value)
```

指定したキー（リクエストパラメータ名）に指定した値が含まれているか判定する。<br/>
例えば、form.sampleというキーの値が"ABC"だったとき、下記コードは{@code true}を返す。
<pre>{@code
WebUtil.containsPropertyKeyValue(context, "form.sample", "ABC"); //--> true
}</pre>
指定したキーと値の組み合わせがリクエストに存在しなかった場合は{@code false}を返す。

**パラメータ:**
- `context` - バリデーションコンテキスト
- `key` - プロパティに対応するキー
- `value` - プロパティの値

**戻り値:**
指定した値が含まれている場合{@code true}

---
