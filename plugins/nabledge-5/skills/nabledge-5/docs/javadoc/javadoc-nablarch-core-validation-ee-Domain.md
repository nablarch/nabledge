# @interface Domain

**パッケージ:** nablarch.core.validation.ee

---

```java
public @interface Domain
```

指定されたドメイン定義に合致することを表わすアノテーション。
<p>
  <p>
    <b>ドメイン定義</b>
  </p>
  ドメインはBeanで定義する。
  Beanの各プロパティがそれぞれドメイン定義となり、
  プロパティ名がドメイン名となる。
  <pre>
    {@code public class SampleDomain} {
        {@code @Length(max = 10)}
        {@code @SystemChar(charsetDef="全角文字")
        String name;
    }}
  </pre>
  バリデーション条件のアノテーションの詳細は{@link nablarch.core.validation.ee}パッケージのjavadocを参照。

  <p>
    <b>ドメインマネージャの設定</b>
  </p>
  上で定義したドメインを使用するためにドメインマネージャを設定する必要がある。
  次のように、{@link DomainManager}を実装したクラスを用意し、
  "domainManager" という名前でコンポーネント定義する。
  <pre>
    {@code import nablarch.core.validation.ee.DomainManager;

    public class SampleDomainManager implements DomainManager<SampleDomain>} {
        {@code @Override
        public Class<SampleDomain> getDomainBean() {
            return SampleDomain.class;
        }
    }}
  </pre>
  <pre>
    {@code <component name="domainManager" class="com.example.SampleDomainManager"/>}
  </pre>

  <p>
    <b>ドメイン指定</b>
  </p>
  定義したドメインをバリデーション対象のBean(Formなど)のプロパティに次のように設定する。
  継承時にバリデーションの設定を引き継ぐためにプロパティのgetterに本アノテーションを設定することを推奨する。
  <pre>
    {@code public class SampleBean} {

        {@code private String name;}

        {@code @Domain("name")
        public String getName() {
            return name;
        }
    }}
  </pre>
</p>

**作成者:** kawasima  
**作成者:** T.Kawasaki  

---
