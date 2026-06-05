# class HttpRequestTimeMetricsMetaDataBuilder

**パッケージ:** nablarch.integration.micrometer.instrument.http

**実装されたインタフェース:**
- HandlerMetricsMetaDataBuilder<HttpRequest,Object>

---

```java
public class HttpRequestTimeMetricsMetaDataBuilder
implements HandlerMetricsMetaDataBuilder<HttpRequest,Object>
```

HTTPリクエストの処理時間のメトリクスに設定するメタ情報を構築するビルダー。
<p>
メトリクスの名前は{@code "http.server.requests"}を返す。
</p>
<p>
また、タグのリストは以下の内容で作成する。
<table>
  <tr>
    <th>タグ</th>
    <th>説明</th>
  </tr>
  <tr>
    <td>class</td>
    <td>
      リクエストを処理したクラスの名前({@link Class#getName()})。<br>
      クラスの情報を取得できない場合は {@code UNKNOWN}。
    </td>
  </tr>
  <tr>
    <td>method</td>
    <td>
      リクエストを処理したメソッドを表す文字列。<br>
      この文字列は、メソッド名の後ろに引数の型の正規名({@link Class#getCanonicalName()})をアンダースコア({@code _})で
      つなげたものになる（例:{@code fooMethod_int_java.lang.String}）。<br>
      メソッドの情報を取得できない場合は {@code UNKNOWN}。
    </td>
  </tr>
  <tr>
    <td>httpMethod</td>
    <td>HTTPメソッド</td>
  </tr>
  <tr>
    <td>status</td>
    <td>HTTPステータスコード</td>
  </tr>
  <tr>
    <td>outcome</td>
    <td>
      HTTPステータスコードの種類を表す文字列。<br>
      1XX は {@code INFORMATION}, 2XX は {@code SUCCESS}, 3XX は {@code REDIRECTION},
      4XX は {@code CLIENT_ERROR}, 5XX は {@code SERVER_ERROR}, それ以外の場合は {@code UNKNOWN}。
    </td>
  </tr>
  <tr>
    <td>exception</td>
    <td>例外がスローされた場合は、そのクラスの単純名（スローされていない場合は {@code "None"}）</td>
  </tr>
</table>
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### DEFAULT_METRICS_NAME

```java
static final String DEFAULT_METRICS_NAME
```

デフォルトのメトリクス名。

---

### DEFAULT_METRICS_DESCRIPTION

```java
static final String DEFAULT_METRICS_DESCRIPTION
```

デフォルトのメトリクスの説明。

---

### metricsName

```java
private String metricsName
```

メトリクス名。

---

### metricsDescription

```java
private String metricsDescription
```

メトリクスの説明。

---

## メソッドの詳細

### buildTagList

```java
public List<Tag> buildTagList(HttpRequest request, ExecutionContext context, Object result, Throwable thrownThrowable)
```

---

### buildMethodTag

```java
private String buildMethodTag(Method method)
```

{@code method} タグに設定する値を構築する。

**パラメータ:**
- `method` - 実行されたメソッド

**戻り値:**
{@code method} タグに設定する値

---

### resolveOutcome

```java
private String resolveOutcome(int statusCode)
```

{@code outcome} タグに設定する値を解決する。

**パラメータ:**
- `statusCode` - レスポンスのステータスコード

**戻り値:**
{@code outcome} タグに設定する値

---

### resolveException

```java
private String resolveException(ExecutionContext context, Throwable thrownThrowable)
```

{@code exception} タグに設定する値を解決する。

**パラメータ:**
- `context` - 実行コンテキスト
- `thrownThrowable` - スローされた例外

**戻り値:**
{@code exception} タグに設定する値

---

### getMetricsName

```java
public String getMetricsName()
```

---

### getMetricsDescription

```java
public String getMetricsDescription()
```

---

### setMetricsName

```java
public void setMetricsName(String metricsName)
```

メトリクス名を設定する。

**パラメータ:**
- `metricsName` - メトリクス名

---

### setMetricsDescription

```java
public void setMetricsDescription(String metricsDescription)
```

メトリクスの説明を設定する。

**パラメータ:**
- `metricsDescription` - メトリクスの説明

---
