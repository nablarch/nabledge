# 文字列からBigDecimal変換時に発生する可能性のあるヒープ不足について

## 文字列からBigDecimal変換時に発生する可能性のあるヒープ不足について

文字列から`BigDecimal`に指数表現（例: `9e100000`）を変換する際に以下のヒープ圧迫が発生する可能性がある:

- `BigDecimal#toPlainString()` の呼び出しで非常に大きい文字列が生成される
- `java.text.DecimalFormat` でフォーマットする際に非常に大きい文字列が生成される

Nablarchでは `BigDecimal#scale` を使用して桁数チェックを行い、ヒープを圧迫するような大きな値の取り込みを防止している。許容するscaleの範囲は `-9999` 〜 `9999` であり、この範囲を超える指数表現の値を変換しようとした場合、例外を送出する。

許容するscaleの範囲は設定で変更可能。設定はシステムリポジトリ機能の環境設定ファイルに指定する（[repository_config_load](../../component/libraries/libraries-02_01_Repository_config.md) 参照）。

例: scaleの許容範囲を `-10` 〜 `10` に変更する場合:

```properties
nablarch.max_scale=10
```

<details>
<summary>keywords</summary>

BigDecimal, BigDecimal#scale, BigDecimal#toPlainString, java.text.DecimalFormat, nablarch.max_scale, ヒープ不足, 指数表現, BigDecimal変換, scale範囲制限

</details>
