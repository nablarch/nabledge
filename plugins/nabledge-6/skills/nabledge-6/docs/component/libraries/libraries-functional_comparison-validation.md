# Bean ValidationとNablarch Validationの機能比較

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/functional_comparison.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/ValidatorUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html)

## Bean ValidationとNablarch Validationの機能比較

凡例: ○：提供あり　△：一部提供あり　×：提供なし　－:対象外

| 機能 | Bean Validation | Nablarch Validation | Jakarta Bean Validation |
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

[1] Formの全ての項目に対してバリデーションを行うことで、不正な入力値の受付を防ぐことが出来る。このため、Bean Validationでは項目指定のバリデーション実行は推奨していない。特定項目のみバリデーションする場合は `ValidatorUtil#validate` を使用する。

[2] Jakarta Bean Validation仕様に準拠。

[3] Nablarchでは外部からデータを受け付けたタイミングで必ずバリデーションを行うため、メソッドの引数や戻り値に対するバリデーションには対応していない。

[4] Bean Validationではバリデーションの実行順は制御できない。実行順序を期待する実装はしないこと（例：項目毎のバリデーション後に相関バリデーションが実行されることを期待しない）。

[5] Jakarta Bean Validationのクラスレベルのバリデーションでロジックにより切り替える。

[6] Bean ValidationではEL式を使用してパラメータを埋め込むこともできる。

[7] Bean Validationではプロパティの型は全てStringとして定義するため型変換は行わない。型変換が必要な場合はバリデーション実施後に `BeanUtil` を使って型変換する。

[8] 正規化はBean Validationの機能ではなくハンドラとして提供している。正規化が必要な場合は [normalize_handler](../handlers/handlers-normalize_handler.md) を使用する。

<details>
<summary>keywords</summary>

ValidatorUtil, BeanUtil, nablarch.core.validation.ee.ValidatorUtil, nablarch.core.beans.BeanUtil, Bean Validation機能比較, Nablarch Validation機能比較, バリデーション機能比較, ドメインバリデーション, 型変換, 正規化, 相関バリデーション, Jakarta Bean Validation

</details>
