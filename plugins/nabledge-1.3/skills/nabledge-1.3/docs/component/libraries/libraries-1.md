# 数値型項目の場合の桁数精査の方法を教えて下さい

> **question:**
> 数値型のプロパティに桁数精査を表す *Lengthアノテーション* を付加しましたが、桁数精査が行われていないようです。
> 数値型の場合、桁数精査はどのように実施するのでしょうか？

> **answer:**
> 数値型項目の桁数精査は、 *Lengthアノテーション* ではなく、 *Digitsアノテーション* を使用する必要があります。
> *Digitsアノテーション* では、数値型特有の整数部桁数と小数部桁数それぞれの桁数精査が行える仕様となっています。

> なお、数値型項目に *Digitsアノテーション* を付加しなかった場合、クラス単体テストで下記のようなエラーが発生します。

> ```java
> java.lang.RuntimeException: unexpected exception occurred. target entity=[nablarch.sample.ss11.entity.SystemAccountEntity] property=[failedCount] parameter=[[Ljava.lang.String;@1de891b]
>     at nablarch.test.core.entity.SingleValidationTester.invokeValidation(SingleValidationTester.java:122)
>     at nablarch.test.core.entity.SingleValidationTester.testSingleValidation(SingleValidationTester.java:70)
>     ～ 省略 ～
> Caused by: java.lang.IllegalArgumentException: Must specify @Digits annotation.property = failedCount
>     at nablarch.core.validation.convertor.NumberConvertorSupport.isConvertible(NumberConvertorSupport.java:127)
>     at nablarch.core.validation.ValidationManager.validateAndConvertProperty(ValidationManager.java:377)
>     ～ 省略 ～
> ```

> 詳細は、以下のドキュメントを参照してください。

> * >   **[Nablarch Application Framework解説書]** -> **[NAF基盤ライブラリ]** -> **[入力値のバリデーション]** -> **[基本バリデータ・コンバータ]** -> **[コンバータ]**
> * >   **[Nablarch Application Framework解説書]** -> **[NAF基盤ライブラリ]** -> **[入力値のバリデーション]** -> **[バリデーション機能の基本的な使用方法]** -> **[値の変換]**
> * >   DigitsアノテーションのJavadoc
