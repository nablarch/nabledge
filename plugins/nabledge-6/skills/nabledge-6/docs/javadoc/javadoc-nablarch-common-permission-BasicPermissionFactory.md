# class BasicPermissionFactory

**パッケージ:** nablarch.common.permission

**実装されたインタフェース:**
- PermissionFactory
- Initializable

---

```java
public class BasicPermissionFactory
implements PermissionFactory, Initializable
```

認可制御グループをベースにした{@link Permission}を生成するクラス。<br>
<br>
このクラスでは、データベース上にユーザ及びユーザが属するグループ毎に使用できる認可単位を保持したテーブル構造から、
ユーザに紐付く認可情報を取得する。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### dbManager

```java
private SimpleDbTransactionManager dbManager
```

データベースへのトランザクション制御を行う{@link SimpleDbTransactionManager}

---

### dbSchema

```java
private Map<String,String> dbSchema
```

認可機能で使用するテーブル名／カラム名

---

### businessDateProvider

```java
private BusinessDateProvider businessDateProvider
```

業務日付を提供する{@link BusinessDateProvider}

---

### selectRequestIdsSql

```java
private String selectRequestIdsSql
```

リクエストIDを取得するSQL

---

## メソッドの詳細

### setDbManager

```java
public void setDbManager(SimpleDbTransactionManager dbManager)
```

データベースへのトランザクション制御を行う{@link SimpleDbTransactionManager}を設定する。

**パラメータ:**
- `dbManager` - データベースへのトランザクション制御を行う{@link SimpleDbTransactionManager}

---

### setGroupTableSchema

```java
public void setGroupTableSchema(GroupTableSchema schema)
```

グループテーブルのスキーマ情報を設定する。

**パラメータ:**
- `schema` - グループテーブルのスキーマ情報

---

### setSystemAccountTableSchema

```java
public void setSystemAccountTableSchema(SystemAccountTableSchema schema)
```

システムアカウントテーブルのスキーマ情報を設定する。

**パラメータ:**
- `schema` - システムアカウントテーブルのスキーマ情報

---

### setGroupSystemAccountTableSchema

```java
public void setGroupSystemAccountTableSchema(GroupSystemAccountTableSchema schema)
```

グループシステムアカウントテーブルのスキーマ情報を設定する。

**パラメータ:**
- `schema` - グループシステムアカウントテーブルのスキーマ情報

---

### setPermissionUnitTableSchema

```java
public void setPermissionUnitTableSchema(PermissionUnitTableSchema schema)
```

認可単位テーブルのスキーマ情報を設定する。

**パラメータ:**
- `schema` - 認可単位テーブルのスキーマ情報

---

### setPermissionUnitRequestTableSchema

```java
public void setPermissionUnitRequestTableSchema(PermissionUnitRequestTableSchema schema)
```

認可単位リクエストテーブルのスキーマ情報を設定する。

**パラメータ:**
- `schema` - 認可単位リクエストテーブルのスキーマ情報

---

### setGroupAuthorityTableSchema

```java
public void setGroupAuthorityTableSchema(GroupAuthorityTableSchema schema)
```

グループ権限テーブルのスキーマ情報を設定する。

**パラメータ:**
- `schema` - グループ権限テーブルのスキーマ情報

---

### setSystemAccountAuthorityTableSchema

```java
public void setSystemAccountAuthorityTableSchema(SystemAccountAuthorityTableSchema schema)
```

システムアカウント権限テーブルのスキーマ情報を設定する。

**パラメータ:**
- `schema` - システムアカウント権限テーブルのスキーマ情報

---

### setBusinessDateProvider

```java
public void setBusinessDateProvider(BusinessDateProvider businessDateProvider)
```

業務日付を提供するクラスのインスタンスを設定する。

**パラメータ:**
- `businessDateProvider` - 業務日付を提供するクラスのインスタンス

---

### getPermission

```java
public Permission getPermission(String userId)
```

{@inheritDoc}

---

### initialize

```java
public void initialize()
```

SQL文を初期化する。

---
