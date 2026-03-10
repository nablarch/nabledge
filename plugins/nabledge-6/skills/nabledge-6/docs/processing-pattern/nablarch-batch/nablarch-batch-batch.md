# バッチアプリケーション編

## バッチフレームワークの選択推奨

Nablarchのバッチアプリケーションは以下2種類のフレームワークを提供する:
- [jsr352/index](jakarta-batch-jsr352.md) (Jakarta Batch)
- [nablarch_batch/index](nablarch-batch-getting-started-nablarch-batch.md) (Nablarchバッチ)

**推奨**: [nablarch_batch/index](nablarch-batch-getting-started-nablarch-batch.md) を使用すること。

**理由**: Jakarta Batchは2020年時点で情報が少なく有識者もアサインしにくい。

> **補足**: Nablarch5u15までの解説書ではJakarta Batchに準拠したバッチアプリケーションを推奨していたが、2020年現在の普及状況と学習コストの高さを鑑みNablarchバッチアプリケーションを推奨とするよう方針転換した。

:ref:`jsr352_batch`と:ref:`nablarch_batch`の機能比較は:ref:`batch-functional_comparison`を参照。
