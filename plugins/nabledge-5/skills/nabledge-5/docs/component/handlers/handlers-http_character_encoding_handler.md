# HTTP文字エンコード制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/http_character_encoding_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/javax/servlet/http/HttpServletRequest.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/servlet/http/HttpServletResponse.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpCharacterEncodingHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.HttpCharacterEncodingHandler`

<details>
<summary>keywords</summary>

HttpCharacterEncodingHandler, nablarch.fw.web.handler.HttpCharacterEncodingHandler, ハンドラクラス名

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

nablarch-fw-web, com.nablarch.framework, モジュール依存関係, Maven依存

</details>

## 制約

> **重要**: 本ハンドラは他のすべてのハンドラより前に配置すること。前に別のハンドラを配置した場合、以下の問題が発生する可能性がある。
> - レスポンスへの規定の文字エンコーディングが設定されない
> - リクエストパラメータへのアクセスにより規定エンコーディングが有効とならずサーバサイドで文字化けが発生する

<details>
<summary>keywords</summary>

ハンドラ配置順序, 制約, 文字化け防止, 最初に配置, リクエスト文字エンコーディング

</details>

## 規定の文字エンコーディングを設定する

`defaultEncoding` プロパティで文字エンコーディングを設定する。省略時は `UTF-8`。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultEncoding | String | | UTF-8 | 設定する文字エンコーディング |

```xml
<component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler">
  <property name="defaultEncoding" value="Windows-31J" />
</component>
```

<details>
<summary>keywords</summary>

defaultEncoding, 文字エンコーディング設定, UTF-8, Windows-31J, デフォルトエンコーディング

</details>

## レスポンスに対する規定の文字エンコーディングの設定を切り替える

デフォルトでは、レスポンスに対して規定の文字エンコーディングを設定しない。設定すると画像など全レスポンスのContent-Typeに `charset` が付与される（例: `image/jpeg;charset=UTF-8`）ため。

Web APIのように全レスポンスにエンコーディングを設定する場合は、`appendResponseCharacterEncoding` プロパティに `true` を設定する。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| appendResponseCharacterEncoding | boolean | | | trueに設定するとレスポンスにも文字エンコーディングを設定する（デフォルトは設定しない） |

```xml
<component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler">
  <property name="appendResponseCharacterEncoding" value="true" />
</component>
```

<details>
<summary>keywords</summary>

appendResponseCharacterEncoding, レスポンスエンコーディング, Web API, Content-Type, charset

</details>

## 一律ではなくリクエストごとに文字エンコーディングを変更したい

リクエストごとにエンコーディングを変更する場合は本ハンドラを継承してオーバーライドする（例: 外部サイト毎にエンコーディングが異なる場合）。

- リクエストのエンコーディング変更: `resolveRequestEncoding` をオーバーライド
- レスポンスのエンコーディング変更: `resolveResponseEncoding` をオーバーライド

```java
public class CustomHttpCharacterEncodingHandler extends HttpCharacterEncodingHandler {
  @Override
  protected Charset resolveRequestEncoding(HttpServletRequest req) {
    return resolveCharacterEncoding(req);
  }
  @Override
  protected Charset resolveResponseEncoding(HttpServletRequest req) {
    return resolveCharacterEncoding(req);
  }
  private Charset resolveCharacterEncoding(HttpServletRequest req) {
    if (req.getRequestURI().contains("/shop1")) {
      return Charset.forName("Windows-31J");
    }
    return getDefaultEncoding();
  }
}
```

<details>
<summary>keywords</summary>

resolveRequestEncoding, resolveResponseEncoding, リクエストごとのエンコーディング, カスタムハンドラ, 継承, エンコーディングカスタマイズ, CustomHttpCharacterEncodingHandler

</details>
