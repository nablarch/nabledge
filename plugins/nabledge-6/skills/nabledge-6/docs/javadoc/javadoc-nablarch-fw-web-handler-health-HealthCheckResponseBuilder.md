# class HealthCheckResponseBuilder

**パッケージ:** nablarch.fw.web.handler.health

---

```java
public class HealthCheckResponseBuilder
```

ヘルスチェック結果からレスポンスを作成するビルダ。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### healthyStatusCode

```java
private int healthyStatusCode
```

---

### healthyStatus

```java
private String healthyStatus
```

---

### unhealthyStatusCode

```java
private int unhealthyStatusCode
```

---

### unhealthyStatus

```java
private String unhealthyStatus
```

---

### writeBody

```java
private boolean writeBody
```

---

## メソッドの詳細

### build

```java
public HttpResponse build(HttpRequest request, ExecutionContext context, HealthCheckResult result)
```

ヘルスチェック結果からレスポンスを作成する。

デフォルトではJSONのレスポンスを作成する。

ヘルスチェックが成功した場合
{"status":"UP","targets":[{"name":"DB","status":"UP"},{"name":"Redis","status":"UP"}]}

ヘルスチェックが失敗した場合
{"status":"DOWN","targets":[{"name":"DB","status":"UP"},{"name":"Redis","status":"DOWN"}]}

**パラメータ:**
- `request` - リクエスト
- `context` - コンテキスト
- `result` - ヘルスチェック結果

**戻り値:**
レスポンス

---

### getContentType

```java
protected String getContentType()
```

コンテンツタイプを取得する。

**戻り値:**
コンテンツタイプ

---

### buildResponseBody

```java
protected String buildResponseBody(HttpRequest request, ExecutionContext context, HealthCheckResult result)
```

レスポンスボディを作成する。

**パラメータ:**
- `request` - リクエスト
- `context` - コンテキスト
- `result` - ヘルスチェック結果

**戻り値:**
レスポンスボディ

---

### targets

```java
private String targets(List<HealthCheckResult.Target> targets)
```

---

### getStatus

```java
protected String getStatus(boolean isHealthy)
```

ヘルスチェック結果に応じたステータスの表現を取得する。

**パラメータ:**
- `isHealthy` - ヘルスチェック結果。成功した場合はtrue

**戻り値:**
ヘルスチェック結果に応じたステータスの表現

---

### setHealthyStatusCode

```java
public void setHealthyStatusCode(int healthyStatusCode)
```

ヘルスチェックが成功した場合のステータスコードを設定する。

デフォルトは"200"。

**パラメータ:**
- `healthyStatusCode` - ヘルスチェックが成功した場合のステータスコード

---

### setHealthyStatus

```java
public void setHealthyStatus(String healthyStatus)
```

ヘルスチェックが成功した場合のステータスの表現を設定する。

デフォルトは"UP"。

**パラメータ:**
- `healthyStatus` - ヘルスチェックが成功した場合のステータスの表現

---

### setUnhealthyStatusCode

```java
public void setUnhealthyStatusCode(int unhealthyStatusCode)
```

ヘルスチェックが失敗した場合のステータスコードを設定する。

デフォルトは"503"。

**パラメータ:**
- `unhealthyStatusCode` - ヘルスチェックが失敗した場合のステータスコード

---

### setUnhealthyStatus

```java
public void setUnhealthyStatus(String unhealthyStatus)
```

ヘルスチェックが失敗した場合のステータスの表現を設定する。

デフォルトは"DOWN"。

**パラメータ:**
- `unhealthyStatus` - ヘルスチェックが失敗した場合のステータスの表現

---

### setWriteBody

```java
public void setWriteBody(boolean writeBody)
```

レスポンスボディを書き込むか否かを設定する。

デフォルトは"true"。
ステータスコードだけでよい場合は"false"を指定する。

**パラメータ:**
- `writeBody` - レスポンスボディを書き込む場合はtrue

---
