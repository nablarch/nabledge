# @interface CodeValue

**パッケージ:** nablarch.common.code.validator.ee

---

```java
public @interface CodeValue
```

指定したコードIDの値と、プロパティの値が合致するかチェックするアノテーション。

<p>使用例</p>
<pre>
    genderがcodeIdとpatternで選択された値と合致するかチェック
    {@code public class Sample}{
        {@code @CodeValue(codeId = "GENDER", pattern = "PATTERN1")
        String gender;
    }}

    genderがcodeIdで選択された値と合致するかチェック
    {@code public class Sample}{
        {@code @CodeValue(codeId = "GENDER")
        String gender;
    }}
</pre>

**作成者:** T.Kawasaki  

---
