# @interface Digits

**パッケージ:** nablarch.core.validation.convertor

---

```java
public @interface Digits
```

数値フォーマット指定を表わすアノテーション。
<p>
  {@link BigDecimalConvertor}, {@link LongConvertor}, {@link IntegerConvertor}を使用する場合は、
  本アノテーションの設定が必須である。<br>
　 <br>
  整数部1桁、小数部なしの場合は次のようにsetterに設定する。
  <pre>
    {@code @PropertyName("認証失敗回数")}
    {@code @Required}
    {@code @NumberRange(min = 0, max = 9)}
    {@code @Digits(integer = 1, fraction = 0)
    public void setFailedCount(Integer failedCount) {
        this.failedCount = failedCount;
    }}
  </pre>
  バリデーションの詳細は、各コンバータの仕様を参照。
</p>

**作成者:** Koichi Asano  
**関連項目:** NumberConvertorSupport  
**関連項目:** BigDecimalConvertor  
**関連項目:** LongConvertor  
**関連項目:** IntegerConvertor  

---
