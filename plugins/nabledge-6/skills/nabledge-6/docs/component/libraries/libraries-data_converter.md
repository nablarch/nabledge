# 様々なフォーマットのデータへのアクセス

## 機能概要と推奨

:ref:`data_bind` の使用を推奨する。理由:
- :ref:`data_bind` はデータをJava Beansオブジェクトとして扱えるため、IDEの補完が有効活用でき開発効率が良い（項目名のタイプミスも防止）
- :ref:`data_format` はフォーマット定義が複雑で理解し難く、学習コストやメンテナンスコストが高い

> **重要**: :ref:`data_bind` で扱えないフォーマットには :ref:`data_format` を使用すること。

> **補足**: :ref:`data_bind` と :ref:`data_format` の機能比較は :ref:`data_io-functional_comparison` を参照。
