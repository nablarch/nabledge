# 文字列からBigDecimal変換時に発生する可能性のあるヒープ不足について

## 文字列からBigDecimal変換時のヒープ不足対策

文字列から `BigDecimal` への変換時に指数表現（例: `9e100000`）を指定すると、以下の問題が発生する可能性がある。

- `BigDecimal#toPlainString()` の呼び出しで非常に大きい文字列が生成されヒープが圧迫される
- `java.text.DecimalFormat` でフォーマットする際に非常に大きい文字列が生成されヒープが圧迫される

Nablarchでは文字列から `BigDecimal` に変換する際、`BigDecimal#scale` で桁数チェックを行い、許容範囲（`-9999` 〜 `9999`）を超える指数表現の値を変換しようとした場合に例外を送出してヒープ圧迫を防止する。

許容するscaleの範囲は設定変更可能。設定はシステムリポジトリ機能の環境設定ファイルに指定する（[repository_config_load](../../component/libraries/libraries-02_01_Repository_config.md) 参照）。

例として、許容範囲を `-10` 〜 `10` に変更する場合:

```properties
nablarch.max_scale=10
```

<details>
<summary>keywords</summary>

BigDecimal, BigDecimal#scale, BigDecimal#toPlainString, DecimalFormat, nablarch.max_scale, ヒープ不足, 指数表現, BigDecimal変換, scale範囲制限

</details>
