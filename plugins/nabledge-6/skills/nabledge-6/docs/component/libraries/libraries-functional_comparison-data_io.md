# データバインドと汎用データフォーマットの比較表

## データバインドと汎用データフォーマットの機能比較

機能比較（○：提供あり　△：一部提供あり　×：提供なし　－:対象外）

| 機能 | データバインド | 汎用データフォーマット |
|---|---|---|
| CSVの入出力 | ○ :ref:`data_bind-csv_format` | ○ :ref:`data_format-support_type` |
| レコード毎にフォーマットの異なるCSVの入出力 | × [1] | ○ :ref:`data_format-multi_layout_data` |
| CSVの定義を設定できる（カンマやクォート文字を変更） | ○ :ref:`data_bind-csv_format` | ○ :ref:`data_format-variable_data_directive` |
| 固定長データの入出力 | ○ :ref:`data_bind-fixed_length_format` | ○ :ref:`data_format-support_type` |
| レコード毎にフォーマットの異なる固定長データの入出力 | ○ :ref:`data_bind-fixed_length_format-multi_layout` | ○ :ref:`data_format-multi_layout_data` |
| JSONデータの入出力 | × [2] | ○ :ref:`data_format-support_type` |
| XMLデータの入出力 | × [3] | ○ :ref:`data_format-support_type` |
| データ入出力時に値の変換（trim、パック数値、ゾーン数値など） | △ [4] | ○ :ref:`data_format-value_convertor` |
| データの寄せ字（システムで許容可能な文字への変換） | × [5] | ○ :ref:`data_format-replacement` |

[1] レコード毎に異なるフォーマットのCSVを扱う場合には、:ref:`data_format` を使用すること。
[2] JSONデータの入出力は未実装。JSONデータを扱う場合は、:ref:`data_format` やOSSを使用すること。
[3] XMLデータの入出力は未実装。XMLデータを扱う場合は、:ref:`data_format` やJakarta XML Bindingを使用すること。
[4] 固定長データのみtrim等のコンバータを提供している。CSVで値を変換したい場合は、出力前及び入力後に変換すること。
[5] 入力データの寄せ字（文字変換）は、文字変換用のハンドラを作成し対応すること。
