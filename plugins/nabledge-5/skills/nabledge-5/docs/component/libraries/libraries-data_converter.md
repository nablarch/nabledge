# 様々なフォーマットのデータへのアクセス

**公式ドキュメント**: [様々なフォーマットのデータへのアクセス](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/data_converter.html)

## データ入出力機能の選択指針

Nablarchが提供する2種類のデータ入出力機能:
- [data_bind](libraries-data_bind.md): データをJava Beansオブジェクトにマッピングする機能
- [data_format](libraries-data_format.md): フォーマット定義ファイルを元にデータ入出力を行う汎用機能

[data_bind](libraries-data_bind.md) の使用を推奨する。理由:
- データをJava Beansオブジェクトとして扱えるためIDE補完が有効活用でき開発効率が良い（項目名のタイプミスが起こりえない）
- [data_format](libraries-data_format.md) はフォーマット定義が複雑で理解し難く、学習コストやメンテナンスコストが高い

> **重要**: [data_bind](libraries-data_bind.md) で扱えないフォーマットについては、[data_format](libraries-data_format.md) を使用すること。

<details>
<summary>keywords</summary>

データバインド, 汎用データフォーマット, データ入出力, フォーマット選択, data_bind, data_format

</details>
