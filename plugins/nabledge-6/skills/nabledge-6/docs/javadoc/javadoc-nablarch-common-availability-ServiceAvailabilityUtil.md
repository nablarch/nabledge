# class ServiceAvailabilityUtil

**パッケージ:** nablarch.common.availability

---

```java
public final class ServiceAvailabilityUtil
```

サービス提供可否状態を判定するユーティリティ。
<p/>
 サービス提供可否状態を判定する処理は{@link ServiceAvailability}によって提供される。
{@link ServiceAvailability}の実装は、{@link nablarch.core.repository.SystemRepository}からコンポーネント名 serviceAvailability で取得される。

**作成者:** Masato Inoue  
**関連項目:** nablarch.common.availability.ServiceAvailability  

---

## フィールドの詳細

### SERVICE_AVAILABILITY_NAME

```java
private static final String SERVICE_AVAILABILITY_NAME
```

リポジトリ上のServiceAvailabilityの名称。

---

## コンストラクタの詳細

### ServiceAvailabilityUtil

```java
private ServiceAvailabilityUtil()
```

プライベートコンストラクタ。

---

## メソッドの詳細

### getServiceAvailability

```java
private static ServiceAvailability getServiceAvailability()
```

システムリポジトリからServiceAvailabilityを取得する。

**戻り値:**
システムリポジトリから取得したServiceAvailability

---

### isAvailable

```java
public static boolean isAvailable(String requestId)
```

パラメータのリクエストIDを元に、サービス提供可否状態を判定し結果を返却する。

**パラメータ:**
- `requestId` - リクエストID

**戻り値:**
サービス提供可否状態を表すboolean （提供可の場合、TRUE）

---
