# interface BodyConverter

**パッケージ:** nablarch.fw.jaxrs

---

```java
public interface BodyConverter
```

リクエスト/レスポンスの変換を行うインタフェース。

**作成者:** Naoki Yamamoto  

---

## メソッドの詳細

### read

```java
Object read(HttpRequest request, ExecutionContext executionContext)
```

メディアタイプに応じてリクエストボディ部を読み込み、Beanオブジェクトに変換する。

**パラメータ:**
- `request` - HTTPリクエスト
- `executionContext` - 実行コンテキスト

**戻り値:**
Beanオブジェクト

---

### write

```java
HttpResponse write(Object response, ExecutionContext executionContext)
```

Beanオブジェクトをメディアタイプに応じて変換し、レスポンスボディ部へ書き込む。

**パラメータ:**
- `response` - Beanオブジェクト
- `executionContext` - 実行コンテキスト

**戻り値:**
HTTPレスポンス

---

### isConvertible

```java
boolean isConvertible(String mediaType)
```

指定されたメディアタイプを変換できるかどうか。

**パラメータ:**
- `mediaType` - メディアタイプ

**戻り値:**
変換できる場合は{@code true}

---
