# HTTP文字エンコード制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.HttpCharacterEncodingHandler`

<details>
<summary>keywords</summary>

HttpCharacterEncodingHandler, nablarch.fw.web.handler.HttpCharacterEncodingHandler, HTTP文字エンコード制御ハンドラ, 文字エンコーディング設定

</details>

## ハンドラ処理フロー

**往路処理**

1. `HttpServletRequest` および `HttpServletResponse` に既定の文字エンコーディングを設定する
2. 後続ハンドラへ処理委譲

**復路処理**

3. 後続ハンドラの結果をリターンして終了

**例外処理**

- 後続ハンドラでエラー発生時はそのまま再送出して終了

<details>
<summary>keywords</summary>

ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, HttpServletRequest, HttpServletResponse

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultEncoding | String | | UTF-8 | 既定の文字エンコーディング |

```xml
<component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler" />
```

```xml
<component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler">
  <property name="defaultEncoding" value="Windows-31J" />
</component>
```

リクエスト毎に動的に使用する文字エンコーディングが変わる場合は本ハンドラを継承し、以下のメソッドをオーバーライドする。

| メソッド名 | 引数 | 戻り値 | 処理内容 |
|---|---|---|---|
| resolveRequestEncoding | HttpServletRequest | Charset | HTTPリクエストに設定する文字エンコードを返却する |
| resolveResponseEncoding | HttpServletRequest | Charset | HTTPレスポンスに設定する文字エンコードを返却する |

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
        if (req.getRequestURI().contains("/RW99ZZ06")) {
            return Charset.forName("Windows-31J");
        }
        return getDefaultEncoding();
    }
}
```

```xml
<component class="sample.handler.CustomHttpCharacterEncodingHandler" />
```

> **警告**: `resolveRequestEncoding`、`resolveResponseEncoding` の引数として `HttpServletRequest` が渡されるが、文字エンコード設定前に `HttpServletRequest` からリクエストパラメータを取得してはならない。文字エンコードの設定前にリクエストパラメータを取得すると文字化けの原因となる。

<details>
<summary>keywords</summary>

defaultEncoding, resolveRequestEncoding, resolveResponseEncoding, HttpServletRequest, Charset, 文字エンコーディング設定, Windows-31J, 拡張ポイント, CustomHttpCharacterEncodingHandler

</details>
