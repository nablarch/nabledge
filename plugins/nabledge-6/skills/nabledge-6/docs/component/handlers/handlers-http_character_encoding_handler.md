# HTTP文字エンコード制御ハンドラ

## ハンドラクラス名

`HttpServletRequest` 及び `HttpServletResponse` に規定の文字エンコーディングを設定するハンドラ。

**クラス名**: `nablarch.fw.web.handler.HttpCharacterEncodingHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

> **重要**: 本ハンドラはどのハンドラよりも前に配置すること。前に配置しないと以下の問題が発生する可能性がある。
> - レスポンスへの規定の文字エンコーディングが設定されない
> - リクエストパラメータにアクセスした際に規定の文字エンコーディングの設定が有効とならず、サーバサイドで文字化けが発生する

## 規定の文字エンコーディングを設定する

`defaultEncoding` プロパティに文字エンコーディングを設定する。省略時は `UTF-8` が使用される。

`Windows-31J` を設定する例:
```xml
<component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler">
  <property name="defaultEncoding" value="Windows-31J" />
</component>
```

## レスポンスに対する規定の文字エンコーディングの設定を切り替える

デフォルトでは、レスポンスへの規定の文字エンコーディングは設定しない。後続ハンドラで処理した全レスポンスに文字エンコーディングが設定されてしまうためで（例: 画像返却時に `Content-Type: image/jpeg;charset=UTF-8` となる）。

WEB APIのように全レスポンスに規定の文字エンコーディングを設定する場合は、`appendResponseCharacterEncoding` プロパティに `true` を設定する。
```xml
<component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler">
  <property name="appendResponseCharacterEncoding" value="true" />
</component>
```

## 一律ではなくリクエストごとに文字エンコーディングを変更したい

リクエストごとに文字エンコーディングを変更する場合は、本ハンドラを継承して対応する。例えば、外部サイトからのリクエストを処理するシステムで、外部サイト毎にエンコーディングが異なる場合には、この対応が必要となる。

- リクエストのエンコーディングを変更する場合は `resolveRequestEncoding` をオーバーライドする
- レスポンスのエンコーディングを変更する場合は `resolveResponseEncoding` をオーバーライドする

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
