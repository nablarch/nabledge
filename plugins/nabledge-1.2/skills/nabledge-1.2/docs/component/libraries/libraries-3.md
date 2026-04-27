# カンマ編集された値を数値型として精査することは出来ますか?

> **question:**
> カンマ編集された値を数値型として精査する方法はありますか?

> 例えば、 *123,123* と画面で入力された場合、精査後に変換されたエンティティの数値型プロパティには、
> *123123* と設定されるようにしたいです。

> **answer:**
> 数値型項目の精査で使用する *Digitsアノテーション* に対してカンマを許容する設定を行うことにより、
> カンマ編集された値を、数値項目として精査することが可能となります。
> なお、カンマ編集は必須ではないためカンマ編集されていない場合でも、精査はOKとなります。

> 以下に実装例を示します。

> ```java
> // DigitsアノテーションにcommaSeparatedにtrueを設定するとカンマ編集を許容します。
> // なお、この動作はデフォルトのため、commaSeparatedの設定をしない場合でも同じ動作となります。
> @PropertyName("数値")
> @Digits(integer = 8, commaSeparated = true)
> public void setIntVal(Integer intVal) {
>     this.intVal = intVal;
> }
> ```

> 逆にカンマを許容したくない場合は、以下のように実装します。

> ```java
> // DigitsアノテーションにcommaSeparatedにfalseを設定する。
> @PropertyName("数値")
> @Digits(integer = 8, commaSeparated = false)
> public void setIntVal(Integer intVal) {
>     this.intVal = intVal;
> }
> ```

> **related information:**
> * >   [数値型項目の場合の桁数精査の方法を教えて下さい](../../component/libraries/libraries-1.md)
