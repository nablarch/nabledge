# class BasicServiceAvailability

**パッケージ:** nablarch.common.availability

**実装されたインタフェース:**
- ServiceAvailability
- Initializable

---

```java
public class BasicServiceAvailability
implements ServiceAvailability, Initializable
```

{@link nablarch.common.availability.ServiceAvailability}の基本実装クラス。
<br>
リクエストIDを元にサービス提供可否状態を判定する。
<br>

**作成者:** Masayuki Fujikuma  
**作成者:** Masato Inoue  
**関連項目:** nablarch.common.availability.ServiceAvailability  

---

## フィールドの詳細

### dbManager

```java
private SimpleDbTransactionManager dbManager
```

データロードに使用するSimpleDbTransactionManagerのインスタンス。

---

### query

```java
private String query
```

リクエストテーブル検索クエリ。

---

### tableName

```java
private String tableName
```

リクエストIDを管理するリクエストテーブル名称。

---

### requestTableRequestIdColumnName

```java
private String requestTableRequestIdColumnName
```

リクエストテーブルに格納されているリクエストIDを保持する項目名称。

---

### requestTableServiceAvailableColumnName

```java
private String requestTableServiceAvailableColumnName
```

リクエストテーブルに格納されているサービス提供可否状態を保持する項目名称。

---

### requestTableServiceAvailableOkStatus

```java
private String requestTableServiceAvailableOkStatus
```

リクエストテーブルに格納されているサービス提供可否状態項目の状態：提供可を表す文字列。

---

## メソッドの詳細

### setDbManager

```java
public void setDbManager(SimpleDbTransactionManager dbManager)
```

データベースへの検索に使用するSimpleDbTransactionManagerインスタンスを設定する。

**パラメータ:**
- `dbManager` - SimpleDbTransactionManagerのインスタンス

---

### setTableName

```java
public void setTableName(String tableName)
```

リクエストに紐付くリクエストテーブル名称を設定する。

**パラメータ:**
- `tableName` - リクエストテーブル名称

---

### setRequestTableRequestIdColumnName

```java
public void setRequestTableRequestIdColumnName(String requestTableRequestIdColumnName)
```

リクエストテーブルのリクエストID項目名称を設定する。

**パラメータ:**
- `requestTableRequestIdColumnName` - リクエストID項目名称

---

### setRequestTableServiceAvailableColumnName

```java
public void setRequestTableServiceAvailableColumnName(String requestTableServiceAvailableColumnName)
```

リクエストテーブルのサービス提供可否状態項目名称を設定する。

**パラメータ:**
- `requestTableServiceAvailableColumnName` - サービス提供可否状態項目名称

---

### setRequestTableServiceAvailableOkStatus

```java
public void setRequestTableServiceAvailableOkStatus(String requestTableServiceAvailableOkStatus)
```

リクエストテーブルのサービス提供可否状態項目の状態：提供可を表す文字列を設定する。

**パラメータ:**
- `requestTableServiceAvailableOkStatus` - サービス提供可否状態項目の状態：提供可を表す文字列

---

### isAvailable

```java
public boolean isAvailable(String requestId)
```

パラメータのリクエストIDのサービス提供可否状態を判定し、結果を返却する。<br>

**パラメータ:**
- `requestId` - リクエストID

**戻り値:**
サービス提供可否状態を表すboolean （提供可の場合、TRUE）

---

### initialize

```java
public void initialize()
```

SQL文を初期化する。

---

### buildQuery

```java
protected String buildQuery()
```

リクエストテーブル検索クエリを生成する。

**戻り値:**
リクエストテーブル検索クエリ

---
