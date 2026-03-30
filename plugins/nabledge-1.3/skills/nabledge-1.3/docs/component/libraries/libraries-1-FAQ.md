# 数値型項目の場合の桁数精査の方法を教えて下さい

## 数値型項目の桁数精査方法

数値型プロパティの桁数精査には `@Length` アノテーションではなく `@Digits` アノテーションを使用する必要がある。`@Digits` では整数部桁数と小数部桁数それぞれの桁数精査が可能。

> **重要**: 数値型プロパティに `@Digits` アノテーションを付加しない場合、クラス単体テストで以下のエラーが発生する。

```java
Caused by: java.lang.IllegalArgumentException: Must specify @Digits annotation.property = failedCount
    at nablarch.core.validation.convertor.NumberConvertorSupport.isConvertible(NumberConvertorSupport.java:127)
```

<details>
<summary>keywords</summary>

@Digits, @Length, NumberConvertorSupport, SingleValidationTester, ValidationManager, 数値型桁数精査, バリデーション, 桁数検証, IllegalArgumentException

</details>
