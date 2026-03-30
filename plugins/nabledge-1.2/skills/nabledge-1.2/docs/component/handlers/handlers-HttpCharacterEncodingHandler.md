# HTTP文字エンコード制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.HttpCharacterEncodingHandler`

<details>
<summary>keywords</summary>

HttpCharacterEncodingHandler, nablarch.fw.web.handler.HttpCharacterEncodingHandler, HTTP文字エンコーディング, 文字エンコード設定

</details>

## ハンドラ処理フロー

**[往路処理]**

1. `HttpServletRequest` および `HttpServletResponse` に対し既定の文字エンコーディングを設定する。
2. ハンドラキュー上の後続ハンドラに処理を委譲し、結果を取得する。

**[復路処理]**

3. 正常終了時は結果をリターンして終了する。

**[例外処理]**

- 2a. 後続ハンドラの処理中にエラーが発生した場合は、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

HttpCharacterEncodingHandler, HttpServletRequest, HttpServletResponse, 往路処理, 復路処理, 例外処理, 文字エンコーディング設定

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultEncoding | String | | UTF-8 | 既定の文字エンコーディング |

**標準設定**:
```xml
<component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler" />
```

**任意設定例**:
```xml
<component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler">
  <property name="defaultEncoding" value="Windows-31J" />
</component>
```

**拡張ポイント**: リクエスト毎に動的に文字エンコーディングを変える場合は本ハンドラを継承し、以下のメソッドをオーバーライドする。

| メソッド | 引数 | 戻り値 | 処理内容 |
|---|---|---|---|
| resolveRequestEncoding | HttpServletRequest | Charset | HTTPリクエストに設定する文字エンコードを返却する |
| resolveResponseEncoding | HttpServletRequest | Charset | HTTPレスポンスに設定する文字エンコードを返却する |

**拡張ハンドラ実装例**:
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

**DI設定例**:
```xml
<component class="sample.handler.CustomHttpCharacterEncodingHandler" />
```

> **警告**: `resolveRequestEncoding`、`resolveResponseEncoding` の引数として `HttpServletRequest` が渡されるが、文字エンコードを設定する前に `HttpServletRequest` からリクエストパラメータを取得してはならない。取得してしまった場合は文字エンコードの設定ができず文字化けの原因となる。

<details>
<summary>keywords</summary>

defaultEncoding, resolveRequestEncoding, resolveResponseEncoding, CustomHttpCharacterEncodingHandler, Windows-31J, 文字化け, DI設定, 拡張ポイント

</details>
