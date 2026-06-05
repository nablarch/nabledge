# interface DateTimeConfiguration

**パッケージ:** nablarch.integration.jsr310.util

**継承階層:**
```
java.lang.Object
  └─ DateTimeConverterConfiguration
      └─ nablarch.integration.jsr310.util.DateTimeConfiguration
```

---

```java
public interface DateTimeConfiguration
extends DateTimeConverterConfiguration
```

Date and Time APIに関する共通的なフォーマッタ、タイムゾーンを扱うためのインターフェース。
{@link nablarch.core.beans.converter.DateTimeConverterConfiguration}と同様のクラス
<p>
本アダプタで提供される機能はNablarch本体に取り込まれており、本アダプタは後方互換を維持するために残している。
新しく使用する場合は、Nablarch本体の{@link nablarch.core.beans.converter.DateTimeConverterConfiguration}を使用すること。

**作成者:** TIS  

---
