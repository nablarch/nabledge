# Bean ValidationとNablarch Validationの機能比較

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/functional_comparison.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/ValidatorUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html)

## Bean ValidationとNablarch Validationの機能比較

## Bean ValidationとNablarch Validationの機能比較

（○：提供あり　△：一部提供あり　×：提供なし　－：対象外）

| 機能 | Bean Validation | Nablarch Validation | JSR 349 |
|---|---|---|---|
| バリデーション対象の項目を指定できる | ○ [1] | ○ | ○ |
| 階層構造を持つJava Beansオブジェクトに対してバリデーションできる | ○ [2] | ○ | ○ |
| メソッドの引数、戻り値に対してバリデーションできる | × [3] | × [3] | ○ |
| 相関バリデーションができる | ○ | ○ | ○ |
| バリデーションの実行順序を指定できる | × [4] | ○ | ○ |
| 特定の項目の値を条件にバリデーション項目を切り替えることが出来る | ○ [5] | ○ | ○ |
| エラーメッセージに埋め込みパラメータを使用できる | ○ [6] | ○ | ○ |
| ドメインバリデーションができる | ○ | ○ | × |
| 値の型変換ができる | × [7] | ○ | × |
| 値の正規化ができる | × [8] | ○ | × |
| エラーメッセージに項目名を埋め込むことができる | ○ | ○ | × |

[1] Formの全ての項目に対してバリデーションを行うことで、不正な入力値の受付を防ぐことが出来る。このため、Bean Validationでは、項目指定のバリデーション実行は推奨していない。特定項目のみバリデーションしたい場合は `ValidatorUtil#validate` を使用すること。

[2] 対応方法はJSR349の仕様に準拠。

[3] Nablarchは外部からデータを受け付けたタイミングで必ずバリデーションを行うため、メソッドの引数・戻り値へのバリデーションには対応していない。

[4] Bean Validationではバリデーションの実行順は制御できないため、実行順序を期待するような実装は行わないこと。例として、項目ごとのバリデーション後に相関バリデーションが実行されることを期待してはならない。

[5] JSR349のクラスレベルのバリデーション機能を使用して、ロジックによりバリデーション項目を切り替える。

[6] Bean ValidationではEL式を使用してパラメータを埋め込むこともできる。

[7] Bean Validationではプロパティの型はすべてStringとして定義する（[bean_validation-form_property](libraries-bean_validation.md) 参照）ため型変換は行わない。型変換が必要な場合は、バリデーション実施後に `BeanUtil` を使って型変換すること。

[8] 正規化はBean Validationの機能ではなくハンドラとして提供している。正規化が必要な場合は [normalize_handler](../handlers/handlers-normalize_handler.md) を使用すること。

<details>
<summary>keywords</summary>

Bean Validation, Nablarch Validation, JSR349, バリデーション機能比較, 相関バリデーション, ドメインバリデーション, 型変換, 正規化, ValidatorUtil, BeanUtil, 実行順序

</details>
