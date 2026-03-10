# ノーマライズハンドラ

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.NormalizationHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

- :ref:`multipart_handler` より後ろに配置すること。このハンドラはリクエストパラメータにアクセスするため、:ref:`multipart_handler` よりも後ろに設定する必要がある。

## 標準で提供しているノーマライズ処理

デフォルトで以下のノーマライザを提供:

- リクエストパラメータの前後のホワイトスペースを除去: `TrimNormalizer`

> **注**: ホワイトスペースの定義は `Character#isWhitespace` (`java.lang.Character.isWhitespace(int)`) を参照。

## ノーマライズ処理を追加する

カスタムノーマライザを追加するには `Normalizer` の実装クラスを作成してハンドラに設定する。

デフォルト動作では、リクエストパラメータの前後のホワイトスペース（定義は `Character#isWhitespace` (`java.lang.Character.isWhitespace(int)`) を参照）を除去するノーマライザが有効となっている。

複数のノーマライザを設定した場合、上に設定したものから順次ノーマライズ処理が実行される。順序性がある場合は設定順に注意すること。

> **補足**: ノーマライザを設定せずにハンドラを定義した場合、デフォルトのTrimNormalizerが自動的に適用される。

ノーマライザ実装例:
```java
public class SampleNormalizer implements Normalizer {

    @Override
    public boolean canNormalize(final String key) {
        // パラメータのキー値にnumが含まれた場合はノーマライズ対象
        return key.contains("num");
    }

    @Override
    public String[] normalize(final String[] value) {
        // パラメータ中のカンマ(,)を除去する
        final String[] result = new String[value.length];
        for (int i = 0; i < value.length; i++) {
            result[i] = value[i].replace(",", "");
        }
        return result;
    }
}
```

コンポーネント設定例（複数ノーマライザ）:
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
