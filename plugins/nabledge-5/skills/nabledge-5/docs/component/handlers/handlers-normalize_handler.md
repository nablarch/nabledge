# ノーマライズハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/normalize_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/NormalizationHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/normalizer/TrimNormalizer.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/normalizer/Normalizer.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.NormalizationHandler`

<details>
<summary>keywords</summary>

NormalizationHandler, nablarch.fw.web.handler.NormalizationHandler, ノーマライズハンドラ

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, モジュール依存関係, com.nablarch.framework

</details>

## 制約

[multipart_handler](handlers-multipart_handler.md) より後ろに配置すること。このハンドラはリクエストパラメータにアクセスするため、[multipart_handler](handlers-multipart_handler.md) よりも後ろに設定する必要がある。

<details>
<summary>keywords</summary>

multipart_handler, ハンドラ配置順序, リクエストパラメータアクセス, ノーマライズハンドラ配置

</details>

## 標準で提供しているノーマライズ処理

リクエストパラメータの前後のホワイトスペースを除去する `TrimNormalizer` を標準で提供している。ホワイトスペースの定義は `Character#isWhitespace` を参照。

<details>
<summary>keywords</summary>

TrimNormalizer, nablarch.fw.web.handler.normalizer.TrimNormalizer, ホワイトスペース除去, リクエストパラメータノーマライズ

</details>

## ノーマライズ処理を追加する

デフォルトで `TrimNormalizer` (前後のホワイトスペース除去) が有効。

プロジェクト要件で追加が必要な場合は `Normalizer` を実装してハンドラに設定する。複数設定した場合は上から順に実行される。順序性がある場合は設定順に注意すること。

ノーマライザの実装例:

```java
public class SampleNormalizer implements Normalizer {
    @Override
    public boolean canNormalize(final String key) {
        return key.contains("num");
    }
    @Override
    public String[] normalize(final String[] value) {
        final String[] result = new String[value.length];
        for (int i = 0; i < value.length; i++) {
            result[i] = value[i].replace(",", "");
        }
        return result;
    }
}
```

コンポーネント設定例:

```xml
<component class="nablarch.fw.web.handler.NormalizationHandler">
  <property name="normalizers">
    <list>
      <component class="sample.SampleNormalizer" />
      <component class="nablarch.fw.web.handler.normalizer.TrimNormalizer" />
    </list>
  </property>
</component>
```

> **補足**: ノーマライザを設定しない場合、デフォルトのTrimNormalizerが自動的に適用される。
> ```xml
> <component class="nablarch.fw.web.handler.NormalizationHandler" />
> ```

<details>
<summary>keywords</summary>

Normalizer, nablarch.fw.web.handler.normalizer.Normalizer, canNormalize, normalize, カスタムノーマライザ, ノーマライザ追加, SampleNormalizer

</details>
