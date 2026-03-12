# 様々なフォーマットのデータへのアクセス

**公式ドキュメント**: [様々なフォーマットのデータへのアクセス](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/data_converter.html)

## 機能概要と推奨

[data_bind](libraries-data_bind.md) の使用を推奨する。理由:
- [data_bind](libraries-data_bind.md) はデータをJava Beansオブジェクトとして扱えるため、IDEの補完が有効活用でき開発効率が良い（項目名のタイプミスも防止）
- [data_format](libraries-data_format.md) はフォーマット定義が複雑で理解し難く、学習コストやメンテナンスコストが高い

> **重要**: [data_bind](libraries-data_bind.md) で扱えないフォーマットには [data_format](libraries-data_format.md) を使用すること。

> **補足**: [data_bind](libraries-data_bind.md) と [data_format](libraries-data_format.md) の機能比較は :ref:`data_io-functional_comparison` を参照。

<details>
<summary>keywords</summary>

データバインド, 汎用データフォーマット, data_bind, data_format, データ入出力, フォーマット変換, 機能選択, IDE補完

</details>
