# class TimeZoneAttribute

**パッケージ:** nablarch.common.handler.threadcontext

**実装されたインタフェース:**
- ThreadContextAttribute<Request<?>>

---

```java
public class TimeZoneAttribute
implements ThreadContextAttribute<Request<?>>
```

スレッドコンテキストに保持するタイムゾーン属性。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### defaultTimeZone

```java
private TimeZone defaultTimeZone
```

デフォルトタイムゾーン

---

## メソッドの詳細

### getKey

```java
public String getKey()
```

{@inheritDoc}
<pre>
{@link ThreadContext#TIME_ZONE_KEY} を使用する。
</pre>

---

### setDefaultTimeZone

```java
public void setDefaultTimeZone(String defaultTimeZone)
```

スレッドコンテキストに格納されるデフォルトのタイムゾーンを設定する。
<pre>
明示的に指定しなかった場合、システムのデフォルトタイムゾーンが使用される。
</pre>

**パラメータ:**
- `defaultTimeZone` - デフォルトタイムゾーンを表す文字列

---

### getValue

```java
public Object getValue(Request<?> req, ExecutionContext ctx)
```

{@inheritDoc}
<pre>
現行の実装では初期設定されたデフォルトタイムゾーンを返す。
</pre>

---
