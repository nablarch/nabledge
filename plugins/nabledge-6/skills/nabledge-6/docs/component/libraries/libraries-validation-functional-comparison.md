# Bean ValidationとNablarch Validationの機能比較

ここでは、Nablarchの提供するバリデーション機能と <a href="https://jakarta.ee/specifications/bean-validation/" target="_blank">Jakarta Bean Validation(外部サイト、英語)</a> の機能比較を示す。

機能比較（○：提供あり　△：一部提供あり　×：提供なし　－:対象外）

| 機能 | Bean   Validation | Nablarch   Validation | Jakarta   Bean Validation |
|---|---|---|---|
| バリデーション対象の項目を指定できる | ○ [1] | ○   [解説書へ](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-execute) | ○ |
| 階層構造を持つJava Beansオブジェクトに   対してバリデーションできる | ○ [2] | ○   [解説書へ](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-nest-bean) | ○ |
| メソッドの引数、戻り値に対してバリデーションできる | × [3] | × [3] | ○ |
| 相関バリデーションができる | ○   [解説書へ](../../component/libraries/libraries-bean-validation.md#bean-validation-correlation-validation) | ○   [解説書へ](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-correlation-validation) | ○ |
| バリデーションの実行順序を指定できる | × [4] | ○   [解説書へ](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-execute) | ○ |
| 特定の項目の値を条件に   バリデーション項目を切り替えることが出来る | ○ [5] | ○   [解説書へ](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-conditional) | ○ |
| エラーメッセージに埋め込みパラメータを使用できる | ○ [6]   [解説書へ](../../component/libraries/libraries-message.md#message) | ○   [解説書へ](../../component/libraries/libraries-message.md#message) | ○ |
| ドメインバリデーションができる | ○   [解説書へ](../../component/libraries/libraries-bean-validation.md#bean-validation-domain-validation) | ○   [解説書へ](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-domain-validation) | × |
| 値の型変換ができる | × [7] | ○   [解説書へ](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-definition-validator-convertor) | × |
| 値の正規化ができる | × [8] | ○   [解説書へ](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-definition-validator-convertor) | × |
| エラーメッセージに項目名を埋め込むことができる | ○   [解説書へ](../../component/libraries/libraries-bean-validation.md#bean-validation-property-name) | ○   [解説書へ](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-property-name) | × |

Formの全ての項目に対してバリデーションを行うことで、不正な入力値の受付を防ぐことが出来る。 

このため、Bean Validationでは、項目指定のバリデーション実行は推奨していない。 

どうしても指定の項目に対してのみバリデーションを行いたい場合には、
ValidatorUtil#validate を使用すること。

対応方法は、 <a href="https://jakarta.ee/specifications/bean-validation/" target="_blank">Jakarta Bean Validation(外部サイト、英語)</a> の仕様に準拠する。

Nablarchでは外部からデータを受け付けたタイミングで必ずバリデーションを行うため、
メソッドの引数や戻り値に対するバリデーションには対応していない。

バリデーションの実行順は制御できないため、バリデーションの実行順序を期待するような実装は行わないこと。
例えば、項目毎のバリデーション後に相関バリデーションが実行されるといったことを期待してはならない。

<a href="https://jakarta.ee/specifications/bean-validation/" target="_blank">Jakarta Bean Validation(外部サイト、英語)</a> のクラスレベルのバリデーション機能を使用して、ロジックによりバリデーション項目を切り替えること。

Bean Validationでは、EL式を使用してパラメータを埋め込むこともできる。

Bean Validationでは、プロパティの型は全てStringとして定義する([Stringで定義する理由](../../component/libraries/libraries-bean-validation.md#bean-validation-form-property))ため型変換は行わない。
型変換が必要な場合には、バリデーション実施後に BeanUtil を使って型変換する。

正規化は、Bean Validationの機能ではなくハンドラとして提供している。正規化が必要な場合には、 [ノーマライズハンドラ](../../component/handlers/handlers-normalize-handler.md#normalize-handler) を使用して行う。
