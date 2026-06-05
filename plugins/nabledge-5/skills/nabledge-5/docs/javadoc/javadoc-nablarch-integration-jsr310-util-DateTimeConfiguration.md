# interface DateTimeConfiguration

**パッケージ:** nablarch.integration.jsr310.util

---

```java
public interface DateTimeConfiguration
```

Date and Time APIに関する共通的なフォーマッタ、タイムゾーンを扱うためのインターフェース。

**作成者:** TIS  

---

## メソッドの詳細

### getDateFormatter

```java
DateTimeFormatter getDateFormatter()
```

日付向けのフォーマッタ

**戻り値:**
日付向けの{@code java.time.format.DateTimeFormatter}のインスタンス

---

### getDateTimeFormatter

```java
DateTimeFormatter getDateTimeFormatter()
```

日時向けのフォーマッタ

**戻り値:**
日時向けの{@code java.time.format.DateTimeFormatter}のインスタンス

---

### getSystemZoneId

```java
ZoneId getSystemZoneId()
```

システムが依存する{@code java.time.ZoneId}を取得する

**戻り値:**
システムが依存するで管理している{@code java.time.ZoneId}

---
