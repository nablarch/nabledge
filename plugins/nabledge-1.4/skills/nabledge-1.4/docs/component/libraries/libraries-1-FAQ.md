# 数値型項目の場合の桁数精査の方法を教えて下さい

## 数値型項目の桁数精査方法

数値型項目の桁数精査には `@Length` アノテーションではなく `@Digits` アノテーションを使用すること。`@Digits` アノテーションは整数部桁数と小数部桁数それぞれの桁数精査が可能。

> **重要**: 数値型項目に `@Digits` アノテーションを付加しなかった場合、クラス単体テストで以下のエラーが発生する。

```
Caused by: java.lang.IllegalArgumentException: Must specify @Digits annotation.property = failedCount
    at nablarch.core.validation.convertor.NumberConvertorSupport.isConvertible(NumberConvertorSupport.java:127)
    at nablarch.core.validation.ValidationManager.validateAndConvertProperty(ValidationManager.java:377)
```

<details>
<summary>keywords</summary>

@Digits, @Length, NumberConvertorSupport, SingleValidationTester, ValidationManager, 桁数精査, 数値型バリデーション, 整数部桁数, 小数部桁数

</details>
