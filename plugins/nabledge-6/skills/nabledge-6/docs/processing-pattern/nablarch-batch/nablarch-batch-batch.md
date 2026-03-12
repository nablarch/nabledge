# バッチアプリケーション編

**公式ドキュメント**: [バッチアプリケーション編](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/index.html)

## バッチフレームワークの選択推奨

Nablarchのバッチアプリケーションは以下2種類のフレームワークを提供する:
- [jsr352/index](../jakarta-batch/jakarta-batch-jsr352.md) (Jakarta Batch)
- [nablarch_batch/index](nablarch-batch-nablarch_batch.md) (Nablarchバッチ)

**推奨**: [nablarch_batch/index](nablarch-batch-nablarch_batch.md) を使用すること。

**理由**: Jakarta Batchは2020年時点で情報が少なく有識者もアサインしにくい。

> **補足**: Nablarch5u15までの解説書ではJakarta Batchに準拠したバッチアプリケーションを推奨していたが、2020年現在の普及状況と学習コストの高さを鑑みNablarchバッチアプリケーションを推奨とするよう方針転換した。

[jsr352_batch](../jakarta-batch/jakarta-batch-jsr352.md)と[nablarch_batch](nablarch-batch-nablarch_batch.md)の機能比較は:ref:`batch-functional_comparison`を参照。

<details>
<summary>keywords</summary>

バッチアプリケーション, Jakarta Batch, Nablarchバッチ, フレームワーク選択, jsr352, nablarch_batch

</details>
