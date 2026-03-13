# 入力値のチェック

**公式ドキュメント**: [入力値のチェック](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation.html)

## 入力値チェックの概要

入力値のチェックでは以下のことを行う:
- 入力値が妥当な形式かどうか（例えば、桁数や文字種などのチェック）
- システムの状態に適合しているかどうか（例えば、アカウントの重複登録チェック）

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, 形式チェック, 桁数, 文字種, 業務チェック, 重複登録チェック, システム状態

</details>

## バリデーション機能の選択

Nablarchでは以下の2種類のバリデーション機能を提供している:
- Java EE7のBean Validation（JSR349）準拠: [validation/bean_validation](libraries-bean_validation.md)
- Nablarch独自のバリデーション機能: [validation/nablarch_validation](libraries-nablarch_validation.md)

**推奨**: Java EE7に準拠したBean Validationを使用すること。理由:
1. Bean ValidationはJava EEで仕様が定められており情報が豊富
2. 開発者がNablarch独自バリデーションの使い方を覚える必要がない

> **補足**: [bean_validation](libraries-bean_validation.md) と [nablarch_validation](libraries-nablarch_validation.md) の機能比較は :ref:`validation-functional_comparison` を参照。

<details>
<summary>keywords</summary>

Bean Validation, Nablarch Validation, バリデーション, 入力値チェック, JSR349, bean_validation, nablarch_validation, validation-functional_comparison

</details>
