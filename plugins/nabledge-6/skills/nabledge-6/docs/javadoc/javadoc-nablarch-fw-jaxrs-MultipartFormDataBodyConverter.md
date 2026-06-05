# class MultipartFormDataBodyConverter

**パッケージ:** nablarch.fw.jaxrs

**実装されたインタフェース:**
- BodyConverter

---

```java
public class MultipartFormDataBodyConverter
implements BodyConverter
```

{@code multipart/form-data}形式のリクエストを後続のハンドラを呼び出すためにPass-Throughする{@link BodyConverter}の実装クラス。

---

## メソッドの詳細

### read

```java
public Object read(HttpRequest request, ExecutionContext executionContext)
```

マルチパートリクエストは後続のハンドラで処理するため、処理自体は行わず常に{@code null}を返却する。

**パラメータ:**
- `request` - HTTPリクエスト
- `executionContext` - 実行コンテキスト

**戻り値:**
常に{@code null}

---

### write

```java
public HttpResponse write(Object response, ExecutionContext executionContext)
```

マルチパートのメディアタイプがレスポンスとなることはないためサポートしない

**パラメータ:**
- `response` - Beanオブジェクト
- `executionContext` - 実行コンテキスト

**戻り値:**
なし

**例外:**
- `常に{@link` - UnsupportedOperationException}をスローする

---

### isConvertible

```java
public boolean isConvertible(String mediaType)
```

メディアタイプが{@code multipart/form-data}の場合、後続のハンドラで処理するため{@code true}を返却する

**パラメータ:**
- `mediaType` - メディアタイプ

**戻り値:**
メディアタイプが{@code multipart/form-data}の場合は{@code true}

---
