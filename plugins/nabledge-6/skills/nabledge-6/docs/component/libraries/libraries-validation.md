# 入力値のチェック

## 入力値のチェック概要と推奨機能

クライアントから送信されるユーザ入力値や、システム間連携により外部システムから送信される値が妥当かを検証するための機能を提供する。

入力値のチェックでは以下のことを行う。

- 入力値が妥当な形式かどうか(例えば、桁数や文字種などのチェック)
- システムの状態に適合しているかどうか(例えば、アカウントの重複登録チェック)

Nablarchでは2種類のバリデーション機能を提供している。

- **Jakarta Bean Validation (Bean Validation)**: Jakarta EEに準拠したバリデーション機能 ([validation/bean_validation](libraries-bean_validation.md))
- **Nablarch Validation**: Nablarch独自のバリデーション機能 ([validation/nablarch_validation](libraries-nablarch_validation.md))

**推奨**: Jakarta EEに準拠した機能（Bean Validation）を使用すること。理由:
1. Jakarta Bean ValidationはJakarta EEで仕様が定められており情報が豊富
2. 開発者がNablarch独自のバリデーションの使い方などを覚える必要がない

> **補足**: :ref:`bean_validation` と :ref:`nablarch_validation` で提供している機能の違いは、 :ref:`validation-functional_comparison` を参照。

バリデーションエラー時に表示するメッセージの定義方法は、 [message](libraries-message.md) を参照。
