# interface ResponseFinisher

**パッケージ:** nablarch.fw.jaxrs

---

```java
public interface ResponseFinisher
```

レスポンスを仕上げるインタフェース。

{@link JaxRsResponseHandler}が作成したレスポンス(エラーレスポンス含む)に共通する処理を行う。
共通処理としてはセキュリティやCORSに対応したレスポンスヘッダの設定などを想定している。

レスポンスの作成処理の後に実行する処理のため、このインタフェースの実装クラスでは例外を発生させてはならない。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### finish

```java
void finish(HttpRequest request, HttpResponse response, ExecutionContext context)
```

レスポンスを仕上げる。

**パラメータ:**
- `request` - リクエスト
- `response` - レスポンス
- `context` - コンテキスト

---
