# データバインドと汎用データフォーマットの比較表

**公式ドキュメント**: [データバインドと汎用データフォーマットの比較表](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/data_io/functional_comparison.html)

## データバインドと汎用データフォーマットの機能比較

（○：提供あり　△：一部提供あり　×：提供なし　－:対象外）

| 機能 | データバインド | 汎用データフォーマット |
|---|---|---|
| CSVの入出力 | ○ [data_bind-csv_format](libraries-data_bind.md) | ○ [data_format-support_type](libraries-data_format.md) |
| レコード毎にフォーマットの異なるCSVの入出力 | × [1] | ○ [data_format-multi_layout_data](libraries-format_definition.md) |
| CSVの定義を設定（カンマやクォート文字の変更） | ○ [data_bind-csv_format](libraries-data_bind.md) | ○ [data_format-variable_data_directive](libraries-format_definition.md) |
| 固定長データの入出力 | ○ [data_bind-fixed_length_format](libraries-data_bind.md) | ○ [data_format-support_type](libraries-data_format.md) |
| レコード毎にフォーマットの異なる固定長データの入出力 | ○ [data_bind-fixed_length_format-multi_layout](libraries-data_bind.md) | ○ [data_format-multi_layout_data](libraries-format_definition.md) |
| JSONデータの入出力 | × [2] | ○ [data_format-support_type](libraries-data_format.md) |
| XMLデータの入出力 | × [3] | ○ [data_format-support_type](libraries-data_format.md) |
| データ入出力時の値変換（trim、パック数値、ゾーン数値など） | △ [4] | ○ [data_format-value_convertor](libraries-data_format.md) |
| データの寄せ字（システムで許容可能な文字への変換） | × [5] | ○ [data_format-replacement](libraries-data_format.md) |

[1] レコード毎に異なるフォーマットのCSVを扱う場合は [data_format](libraries-data_format.md) を使用すること。
[2] JSONデータの入出力は未実装。JSONデータを扱う場合は [data_format](libraries-data_format.md) やOSSを使用すること。
[3] XMLデータの入出力は未実装。XMLデータを扱う場合は [data_format](libraries-data_format.md) やJAXBを使用すること。
[4] 固定長データのみtrim等のコンバータを提供。CSVで値を変換する場合は、出力前および入力後に変換すること。
[5] 入力データの寄せ字（文字変換）は、文字変換用のハンドラを作成して対応すること。

<details>
<summary>keywords</summary>

データバインド, 汎用データフォーマット, CSV入出力, 固定長データ入出力, JSON入出力, XML入出力, 値変換, 寄せ字, マルチレイアウト, 機能比較

</details>
