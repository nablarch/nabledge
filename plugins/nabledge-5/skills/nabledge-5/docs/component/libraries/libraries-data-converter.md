# 様々なフォーマットのデータへのアクセス

様々なフォーマットのデータを扱う機能を提供する。

Nablarchでは、以下の2種類のデータ入出力機能を提供している。

データバインド(データとJava Beansオブジェクトをマッピングする機能) <data_io/data_bind>
汎用データフォーマット(フォーマット定義ファイルを元にデータ入出力を行う機能) <data_io/data_format>

上記のどちらの機能を使用した場合でも、データアクセスを行うことができるが、
以下の理由により [データバインド](../../component/libraries/libraries-data-bind.md#データバインド) を使用することを推奨する。

* [データバインド](../../component/libraries/libraries-data-bind.md#データバインド) は、データをJava Beansオブジェクトとして扱えるため、IDEの補完が有効活用でき開発効率が良い。(項目名のタイプミスなどが起こりえないメリットも有る）
* [汎用データフォーマット](../../component/libraries/libraries-data-format.md#汎用データフォーマット) は、フォーマットの定義が複雑で理解し難い。これにより、学習コストやメンテナンスコストが高くなる。

> **Important:**
> [データバインド](../../component/libraries/libraries-data-bind.md#データバインド) で扱うことのできないフォーマットについては、 [汎用データフォーマット](../../component/libraries/libraries-data-format.md#汎用データフォーマット) を使用する必要がある。

> **Tip:**
> [データバインド](../../component/libraries/libraries-data-bind.md#データバインド) と [汎用データフォーマット](../../component/libraries/libraries-data-format.md#汎用データフォーマット) で提供している機能の違いは、 [データバインドと汎用データフォーマットの比較表](../../component/libraries/libraries-data-io-functional-comparison.md#データバインドと汎用データフォーマットの比較表) を参照。

data_io/functional_comparison
