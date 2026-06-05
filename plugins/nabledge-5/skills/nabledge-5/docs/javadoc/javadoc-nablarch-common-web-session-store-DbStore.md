# class DbStore

**パッケージ:** nablarch.common.web.session.store

**継承階層:**
```
java.lang.Object
  └─ SessionStore
      └─ nablarch.common.web.session.store.DbStore
```

**実装されたインタフェース:**
- Initializable

---

```java
public class DbStore
extends SessionStore
implements Initializable
```

セッションの内容をDBに格納/読み込みする{@link DbStore}。
<p/>
デフォルトのストア名は"db"。

**作成者:** TIS  

---

## フィールドの詳細

### dbManager

```java
private SimpleDbTransactionManager dbManager
```

SimpleDbTransactionManagerのインスタンス。

---

### userSessionSchema

```java
private UserSessionSchema userSessionSchema
```

ユーザセッションテーブルのスキーマ。

---

### selectUserSessionSql

```java
private String selectUserSessionSql
```

ユーザセッションテーブルを取得するSQL

---

### insertUserSessionSql

```java
private String insertUserSessionSql
```

ユーザセッションテーブルを追加するSQL

---

### updateUserSessionSql

```java
private String updateUserSessionSql
```

ユーザセッションテーブルを更新するSQL

---

### deleteUserSessionSql

```java
private String deleteUserSessionSql
```

ユーザセッションテーブルを削除するSQL

---

## コンストラクタの詳細

### DbStore

```java
public DbStore()
```

コンストラクタ。

---

## メソッドの詳細

### setDbManager

```java
public void setDbManager(SimpleDbTransactionManager dbManager)
```

DbManagerのインスタンスをセットする。

**パラメータ:**
- `dbManager` - SimpleDbTransactionManagerのインスタンス

---

### setUserSessionSchema

```java
public void setUserSessionSchema(UserSessionSchema userSessionSchema)
```

ユーザセッションテーブルのスキーマをセットする。

**パラメータ:**
- `userSessionSchema` - ユーザセッションテーブルのスキーマ

---

### load

```java
public List<SessionEntry> load(String sessionId, ExecutionContext executionContext)
```

---

### save

```java
public void save(String sessionId, List<SessionEntry> entries, ExecutionContext executionContext)
```

ユーザセッションテーブルにセッション情報を保存する。
<p>
新規でセッション情報を保存する場合で複数スレッドから同時に本処理が呼び出された場合、
登録処理(insert)が同時実行され片方の処理が一意制約違反となる。
このため、一意制約違反が発生した場合には、1回だけリトライを実施する。

---

### delete

```java
public void delete(String sessionId, ExecutionContext executionContext)
```

---

### invalidate

```java
public void invalidate(String sessionId, ExecutionContext executionContext)
```

---

### saveSession

```java
private void saveSession(String sessionId, List<SessionEntry> entries)
```

ユーザセッションテーブルにセッション情報を登録する。
<p>
保存対象のセッション情報が空の場合は、テーブルからレコードを削除する。
それ以外の場合は、更新処理を行う。更新対象が存在しない場合には、新規にセッションが追加された場合なので、レコードの追加を行う。

**パラメータ:**
- `sessionId` - セッションID
- `entries` - セッションに保存する情報

---

### updateUserSession

```java
private int updateUserSession(String sessionId, List<SessionEntry> entries, AppDbConnection connection)
```

ユーザセッションを更新する。

**パラメータ:**
- `sessionId` - セッションID
- `entries` - セッションエントリ
- `connection` - {@link AppDbConnection}

**戻り値:**
更新件数

---

### insertUserSession

```java
private void insertUserSession(String sessionId, List<SessionEntry> entries, AppDbConnection connection)
```

ユーザセッションテーブルにセッションの内容を挿入する。

**パラメータ:**
- `sessionId` - セッションID
- `entries` - セッションエントリ
- `connection` - {@link AppDbConnection}

---

### deleteUserSession

```java
private void deleteUserSession(String sessionId, AppDbConnection connection)
```

ユーザセッションテーブルからセッションの内容を削除する。

**パラメータ:**
- `sessionId` - セッションID
- `connection` - {@link AppDbConnection}

---

### initialize

```java
public void initialize()
```

初期化処理。

---
