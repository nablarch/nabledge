## HTTP文字エンコード制御ハンドラ

**クラス名:** `nablarch.fw.web.handler.HttpCharacterEncodingHandler`

-----

-----

### 概要

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| HTTP文字エンコード制御ハンドラ | nablarch.fw.web.handler.HttpCharacterEncodingHandler | Object | Object | HttpServletRequestおよびHttpServletResponseに対し文字エンコーディングを設定する。 | - | - |

### ハンドラ処理フロー

**[往路処理]**

**1. (既定の文字エンコーディングの設定)**

`HttpServletRequest` および `HttpServletResponse` に対し既定の文字エンコーディングを設定する。

**2. (後続ハンドラに対する処理委譲)**

ハンドラキュー上の後続ハンドラに対して処理を委譲し、その結果を取得する。

**[復路処理]**

**3. (正常終了)**

**2.** の結果をリターンして終了する。

**[例外処理]**

**2a. (エラー終了)**

後続ハンドラの処理中にエラーが発生した場合は、そのまま再送出して終了する。

### 設定項目・拡張ポイント

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| 既定の文字エンコーディング | defaultEncoding | String | 任意指定(デフォルト値="UTF-8") |

**標準設定**

以下は標準設定におけるDI設定の例である。

```xml
<component class ="nablarch.fw.web.handler.HttpCharacterEncodingHandler" />
```

**任意の設定項目も含めた例**

```xml
<component class ="nablarch.fw.web.handler.HttpCharacterEncodingHandler">
  <!-- 文字エンコーディング -->
  <property name="defaultEncoding" value="Windows-31J" />
</component>
```

**拡張例**

リクエスト毎に動的に使用する文字エンコーディングが変わる場合は本ハンドラを継承したハンドラを作成し、本ハンドラの代わりに設定する。
継承時に拡張可能なメソッドを以下に示す。

| 拡張可能なメソッド | 引数 | 戻り値 | 処理内容 |
|---|---|---|---|
| resolveRequestEncoding | HttpServletRequest | Charset | HTTP リクエストに設定する文字エンコードを返却する。 |
| resolveResponseEncoding | HttpServletRequest | Charset | HTTP レスポンスに設定する文字エンコードを返却する。 |

以下はリクエスト URI 毎に文字エンコーディングを変更する例である。

*拡張ハンドラの実装例*

```java
public class CustomHttpCharacterEncodingHandler extends
        HttpCharacterEncodingHandler {

    @Override
    protected Charset resolveRequestEncoding(HttpServletRequest req) {
        return resolveCharacterEncoding(req);
    }

    @Override
    protected Charset resolveResponseEncoding(HttpServletRequest req) {
        return resolveCharacterEncoding(req);
    }

    /**
     * 文字エンコードを解決する。<br />
     * <pre>
     * URI に "/RW99ZZ06" が含まれていた場合は文字エンコーディングを "Windows-31J" とする。
     * それ以外の場合はデフォルトの文字エンコードとする。
     * </pre>
     *
     * @param req リクエスト
     * @return 文字エンコード
     */
    private Charset resolveCharacterEncoding(HttpServletRequest req) {
        if (req.getRequestURI().contains("/RW99ZZ06")) {
            return Charset.forName("Windows-31J");
        }
        return getDefaultEncoding();
    }

}
```

*DIの設定例*

```xml
<component class ="sample.handler.CustomHttpCharacterEncodingHandler" />
```

> **Warning:**
> `resolveRequestEncoding`, `resolveResponseEncoding` の引数として `HttpServletRequest` が渡されるが、 
> `HttpServletRequest` からリクエストパラメータを取得してはならない。
> 文字エンコードを設定する前に``HttpServletRequest`` からリクエストパラメータを取得してしまった場合は
> 文字エンコードの設定ができないので文字化けの原因となる。
