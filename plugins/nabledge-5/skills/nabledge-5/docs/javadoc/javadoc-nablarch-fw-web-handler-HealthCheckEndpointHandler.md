# class HealthCheckEndpointHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class HealthCheckEndpointHandler
implements HttpRequestHandler
```

ヘルスチェックを行うエンドポイントとなるハンドラ。

DBやRedisなどの対象ごとのヘルスチェックは{@link HealthChecker}が行う。
ヘルスチェック結果からレスポンスの作成は{@link HealthCheckResponseBuilder}が行う。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### healthCheckers

```java
private List<HealthChecker> healthCheckers
```

---

### healthCheckResponseBuilder

```java
private HealthCheckResponseBuilder healthCheckResponseBuilder
```

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

---

### setHealthCheckers

```java
public void setHealthCheckers(List<HealthChecker> healthCheckers)
```

DBやRedisなどの対象ごとのヘルスチェックを行う{@link HealthChecker}を設定する。

**パラメータ:**
- `healthCheckers` - DBやRedisなどの対象ごとのヘルスチェックを行う{@link HealthChecker}

---

### setHealthCheckResponseBuilder

```java
public void setHealthCheckResponseBuilder(HealthCheckResponseBuilder healthCheckResponseBuilder)
```

ヘルスチェック結果からレスポンスを作成する{@link HealthCheckResponseBuilder}を設定する。

**パラメータ:**
- `healthCheckResponseBuilder` - ヘルスチェック結果からレスポンスを作成する{@link HealthCheckResponseBuilder}

---
