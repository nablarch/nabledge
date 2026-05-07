# データバインドと汎用データフォーマットの比較表

この章では、以下の機能の比較を示す。

* [データバインド](../../component/libraries/libraries-data-bind.md#データバインド)
* [汎用データフォーマット](../../component/libraries/libraries-data-format.md#汎用データフォーマット)

機能比較（○：提供あり　△：一部提供あり　×：提供なし　－:対象外）

| 機能 | データバインド | 汎用データフォーマット |
|---|---|---|
| CSVの入出力ができる | ○   [解説書へ](../../component/libraries/libraries-data-bind.md#csvファイルのフォーマットを指定する) | ○   [解説書へ](../../component/libraries/libraries-data-format.md#標準でサポートするフォーマットが豊富) |
| レコード毎にフォーマットの異なる   CSVの入出力ができる | × [1] | ○   [解説書へ](../../component/libraries/libraries-format-definition.md#マルチフォーマット形式のレコードを定義する) |
| CSVの定義を設定できる   (カンマやクォート文字を変更することできる) | ○   [解説書へ](../../component/libraries/libraries-data-bind.md#csvファイルのフォーマットを指定する) | ○   [解説書へ](../../component/libraries/libraries-format-definition.md#variable可変長形式で指定可能なディレクティブ一覧) |
| 固定長データの入出力ができる | ○   [解説書へ](../../component/libraries/libraries-data-bind.md#固定長ファイルのフォーマットを指定する) | ○   [解説書へ](../../component/libraries/libraries-data-format.md#標準でサポートするフォーマットが豊富) |
| レコード毎にフォーマットの異なる   固定長データの入出力ができる | ○   [解説書へ](../../component/libraries/libraries-data-bind.md#固定長ファイルに複数のフォーマットを指定する) | ○   [解説書へ](../../component/libraries/libraries-format-definition.md#マルチフォーマット形式のレコードを定義する) |
| JSONデータの入出力ができる | × [2] | ○   [解説書へ](../../component/libraries/libraries-data-format.md#標準でサポートするフォーマットが豊富) |
| XMLデータの入出力ができる | × [3] | ○   [解説書へ](../../component/libraries/libraries-data-format.md#標準でサポートするフォーマットが豊富) |
| データ入出力時に値の変換ができる   (trimやパック数値やゾーン数値の変換など) | △ [4] | ○   [解説書へ](../../component/libraries/libraries-data-format.md#パディングやトリミングなどの変換処理に対応) |
| データの寄せ字ができる   システムで許容可能な文字への変換などを指す | × [5] | ○   [解説書へ](../../component/libraries/libraries-data-format.md#文字の置き換え寄せ字を行う) |

レコード毎に異なるフォーマットのCSVを扱う場合には、 [汎用データフォーマット](../../component/libraries/libraries-data-format.md#汎用データフォーマット) を使用すること。

JSONデータの入出力は未実装。JSONデータを扱う場合は、 [汎用データフォーマット](../../component/libraries/libraries-data-format.md#汎用データフォーマット) やOSSを使用すること。

XMLデータの入出力は未実装。XMLデータを扱う場合は、 [汎用データフォーマット](../../component/libraries/libraries-data-format.md#汎用データフォーマット) やJAXBを使用すること。

固定長データのみtrim等のコンバータを提供している。CSVで値を変換したい場合は、出力前及び入力後に変換すること。

入力データの寄せ字(文字変換)は、文字変換用のハンドラを作成し対応すること。
