# class ServiceAvailabilityCheckHandler

**パッケージ:** nablarch.common.availability

**実装されたインタフェース:**
- Handler<Object,Object>
- InboundHandleable

---

```java
public class ServiceAvailabilityCheckHandler
implements Handler<Object,Object>, InboundHandleable
```

WEBサービス提供可否状態判定処理実施ハンドラ。
<br>
{@link nablarch.core.ThreadContext}から取得したリクエストIDがサービス提供可能かどうか判定する。

**作成者:** Masayuki Fujikuma  
**作成者:** Masato Inoue  
**関連項目:** nablarch.common.availability.ServiceAvailability  

---

## フィールドの詳細

### serviceAvailability

```java
private ServiceAvailability serviceAvailability
```

サービス提供可否状態判定オブジェクト。

---

### usesInternalRequestId

```java
private boolean usesInternalRequestId
```

サービス提供可否判定を行う際に内部リクエストIDを使用するかどうか

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## メソッドの詳細

### handle

```java
public Object handle(Object inputData, ExecutionContext context)
```

{@link nablarch.core.ThreadContext}からリクエストIDを取得し、サービス提供可否を判定する。<br>
判定結果が可の場合、処理を後続に受け渡し、判定結果が不可の場合、例外を送出する。

**パラメータ:**
- `inputData` - 入力パラメータ
- `context` - サービスハンドラチェイン

**戻り値:**
レスポンスオブジェクト

---

### setServiceAvailability

```java
public void setServiceAvailability(ServiceAvailability serviceAvailability)
```

サービス提供可否状態判定オブジェクトを設定する。

**パラメータ:**
- `serviceAvailability` - サービス提供可否状態判定オブジェクト

---

### setUsesInternalRequestId

```java
public ServiceAvailabilityCheckHandler setUsesInternalRequestId(boolean usesInternal)
```

開閉局状態の判定を内部リクエストIDを用いて行うか否かを設定する。

明示的に設定しなかった場合のデフォルトは true (内部リクエストIDを使用する。)

**パラメータ:**
- `usesInternal` - 内部リクエストIDを使用して判定を行う場合は true
                     常に外部から送信されたリクエストIDを使って判定を行う場合は false

**戻り値:**
このハンドラインスタンス自体

---

### handleInbound

```java
public Result handleInbound(ExecutionContext context)
```

---
