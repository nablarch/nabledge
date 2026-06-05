# class LanguageAttribute

**パッケージ:** nablarch.common.handler.threadcontext

**実装されたインタフェース:**
- ThreadContextAttribute<Request<?>>

---

```java
public class LanguageAttribute
implements ThreadContextAttribute<Request<?>>
```

スレッドコンテキストに保持する言語属性。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### defaultLanguage

```java
private Locale defaultLanguage
```

デフォルトロケール

---

## メソッドの詳細

### getKey

```java
public String getKey()
```

{@inheritDoc}
<pre>
{@link ThreadContext#LANG_KEY} を使用する。
</pre>

---

### setDefaultLanguage

```java
public void setDefaultLanguage(String defaultLanguage)
```

スレッドコンテキストに格納されるデフォルトの言語を設定する。
<pre>
明示的に指定しなかった場合、システムデフォルトロケールが使用される。
</pre>

**パラメータ:**
- `defaultLanguage` - デフォルトロケールを表す文字列

---

### getValue

```java
public Object getValue(Request<?> req, ExecutionContext ctx)
```

{@inheritDoc}
<pre>
現行の実装では初期設定されたデフォルトロケールを返す。
</pre>

---
