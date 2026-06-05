# class MessageUtil

**パッケージ:** nablarch.core.message

---

```java
public final class MessageUtil
```

アプリケーションがメッセージを取得する際に使用するユーティリティクラス。
<p/>
{@link SystemRepository}から{@link StringResourceHolder}を取得する。
取得できなかった場合は、{@link PropertiesStringResourceLoader}でロードしたリソースキャッシュを持つ{@link StringResourceHolder}を取得する。

**作成者:** Koichi Asano  
**関連項目:** SystemRepository  
**関連項目:** PropertiesStringResourceLoader  
**関連項目:** StringResourceHolder  

---

## フィールドの詳細

### STRING_RESOURCE_HOLDER_NAME

```java
private static final String STRING_RESOURCE_HOLDER_NAME
```

メッセージリソースのコンポーネント名。

---

### DEFAULT_STRING_RESOURCE_HOLDER

```java
private static final StringResourceHolder DEFAULT_STRING_RESOURCE_HOLDER
```

{@link StringResourceHolder}の初期値。

---

## コンストラクタの詳細

### MessageUtil

```java
private MessageUtil()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### getStringResourceHolder

```java
private static StringResourceHolder getStringResourceHolder()
```

{@link StringResourceHolder}をリポジトリから取得する。

**戻り値:**
取得したStringResourceHolder

---

### createMessage

```java
public static Message createMessage(MessageLevel level, String messageId, Object options)
```

メッセージを生成する。
テンプレート文字列が以下であるときの例を示す。<br/>
「errors.maxLength={0}は{1}文字以下で入力してください。」<br/>
例:
<pre>
{@code
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "errors.maxLength", "sample", 2);
String str = message.formatMessage(); //--> sampleは2文字以下で入力してください。
}</pre>

**パラメータ:**
- `level` - メッセージレベル
- `messageId` - メッセージID
- `options` - メッセージフォーマットに使用するオプション引数

**戻り値:**
生成した{@link Message}

---

### getStringResource

```java
public static StringResource getStringResource(String messageId)
```

メッセージIDに対応する{@link StringResource}を取得する。
メッセージIDがnullである場合は、nullを返す。
<p/>
テンプレート文字列が以下であるときの例を示す。<br/>
「errors.maxLength={0}は{1}文字以下で入力してください。」<br/>
例:
<pre>
{@code
StringResource resource = MessageUtil.getStringResource("errors.maxLength"); //-->メッセージIDに対応する文字列リソースを取得。
}</pre>

**パラメータ:**
- `messageId` - メッセージID

**戻り値:**
取得したメッセージ

---
