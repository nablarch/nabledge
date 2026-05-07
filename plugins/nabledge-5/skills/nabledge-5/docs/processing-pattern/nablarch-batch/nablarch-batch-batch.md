# バッチアプリケーション編

本章ではNablarchアプリケーションフレームワークを使用してバッチアプリケーションを開発するために必要となる情報を提供する。

Nablarchのバッチアプリケーションでは、以下2種類のバッチアプリケーションのフレームワークを提供している。

jsr352/index
nablarch_batch/index

どちらのフレームワークを使用してもバッチアプリケーションを構築できるが、
以下の理由により [Nablarchバッチアプリケーション](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch.md) を使用してバッチアプリケーションを作成することを推奨する。

理由

JSR352は2020年時点で情報が少なく有識者もアサインしにくいため、[Nablarchバッチアプリケーション](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch.md) を使用してバッチアプリケーションを作成することを推奨する。

> **Tip:**
> Nablarch5u15までの解説書ではJSR352に準拠したバッチアプリケーションを推奨してきましたが、2020年現在の普及状況と学習コストの高さを鑑みNablarchバッチアプリケーションを推奨とするよう方針転換しました。

> **Tip:**
> [JSR352に準拠したバッチアプリケーション](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md#jsr352に準拠したバッチアプリケーション) と [Nablarchバッチアプリケーション](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch.md#nablarchバッチアプリケーション) で提供している機能の違いは、 [JSRに準拠したバッチアプリケーションとNablarchバッチアプリケーションとの機能比較](../../processing-pattern/nablarch-batch/nablarch-batch-functional-comparison.md#jsrに準拠したバッチアプリケーションとnablarchバッチアプリケーションとの機能比較) を参照。

functional_comparison
