# interface CustomResponseWriter

**パッケージ:** nablarch.fw.web.handler.responsewriter

---

```java
public interface CustomResponseWriter
```

HTTPレスポンスの書き込みを行うインタフェース。

レスポンスの種類に応じて、処理を行うか否かを判定する。
処理対象と判定した場合、レスポンス出力が実行される。
JSP以外で、任意のテンプレートエンジン等を使用して
レスポンスを出力する用途を想定している。

**作成者:** Tsuyoshi Kawasaki  
**関連項目:** HttpResponseHandler  

---

## メソッドの詳細

### isResponsibleTo

```java
boolean isResponsibleTo(String path, ServletExecutionContext context)
```

処理対象のレスポンスであるか判定する。

**パラメータ:**
- `path` - レスポンス出力に指定されたパス(テンプレートファイルへのパス等を指す。実装依存。)
- `context` - 実行コンテキスト

**戻り値:**
処理対象である場合、真

---

### writeResponse

```java
void writeResponse(String path, ServletExecutionContext context)
                   throws ServletException, IOException
```

レスポンスの書き込みを行う。

**パラメータ:**
- `path` - レスポンス出力に指定されたパス(テンプレートファイルへのパス等を指す。実装依存。)
- `context` - 実行コンテキスト

**例外:**
- `ServletException` - Servlet API使用時に発生した例外
- `IOException` - 入出力例外(ソケットI/Oエラー等)

---
