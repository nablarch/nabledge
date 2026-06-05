# class FilenameBasedResourcePathRule

**パッケージ:** nablarch.fw.web.i18n

**継承階層:**
```
java.lang.Object
  └─ ResourcePathRule
      └─ nablarch.fw.web.i18n.FilenameBasedResourcePathRule
```

---

```java
public class FilenameBasedResourcePathRule
extends ResourcePathRule
```

ファイル名を言語の切り替えに使用するクラス。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### createPathForLanguage

```java
protected String createPathForLanguage(String pathFromContextRoot, String language)
```

{@inheritDoc}
<pre>
下記のパスを返す。

  pathFromContextRoot: "/aaa/bbb/ccc.css"
  language: "ja"

  戻り値: "/aaa/bbb/ccc_ja.css"
</pre>

---
