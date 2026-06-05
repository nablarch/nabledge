# interface DaoContext

**パッケージ:** nablarch.common.dao

---

```java
public interface DaoContext
```

{@link UniversalDao}の実行コンテキスト。
<p/>
ページネーションのためのページ数などを状態としてもつ必要があるので、
このコンテキストを介してSQLの実行処理が行われる。

**作成者:** kawasima  
**作成者:** Hisaaki Shioiri  

---

## メソッドの詳細

### findById

```java
T findById(Class<T> entityClass, Object id)
```

プライマリーキーによる検索を行う。

**パラメータ:**
- `<T>` - エンティティクラスの型
- `entityClass` - エンティティクラス
- `id` - プライマリーキー (複合キーの場合は定義順)

**戻り値:**
エンティティオブジェクト

---

### findByIdOrNull

```java
T findByIdOrNull(Class<T> entityClass, Object id)
```

プライマリーキーによる検索を行う。

**パラメータ:**
- `<T>` - エンティティクラスの型
- `entityClass` - エンティティクラス
- `id` - プライマリーキー (複合キーの場合は定義順)

**戻り値:**
エンティティオブジェクト。0件の場合はnull。

---

### findAll

```java
EntityList<T> findAll(Class<T> entityClass)
```

全件の検索を行う。

**パラメータ:**
- `<T>` - エンティティクラスの型
- `entityClass` - エンティティクラス

**戻り値:**
検索結果リスト。0件の場合は空リスト。

---

### findAllBySqlFile

```java
EntityList<T> findAllBySqlFile(Class<T> entityClass, String sqlId, Object params)
```

SQL_IDをもとにバインド変数を展開して検索処理を行う。

**パラメータ:**
- `<T>` - 検索結果をマッピングするBeanクラスの型
- `entityClass` - 検索結果をマッピングするBeanクラス
- `sqlId` - SQL_ID
- `params` - バインド変数

**戻り値:**
検索結果リスト。0件の場合は空リスト。

---

### findAllBySqlFile

```java
EntityList<T> findAllBySqlFile(Class<T> entityClass, String sqlId)
```

SQL_IDをもとに検索を行う。

**パラメータ:**
- `<T>` - 検索結果をマッピングするBeanクラスの型
- `entityClass` - 検索結果をマッピングするBeanクラス
- `sqlId` - SQL_ID

**戻り値:**
検索結果リスト。0件の場合は空リスト。

---

### findBySqlFile

```java
T findBySqlFile(Class<T> entityClass, String sqlId, Object params)
```

SQL_IDをもとに1件検索を行う。

**パラメータ:**
- `<T>` - 検索結果をマッピングするBeanクラスの型
- `entityClass` - 検索結果をマッピングするBeanクラス
- `sqlId` - SQL_ID
- `params` - バインド変数

**戻り値:**
エンティティオブジェクト

---

### findBySqlFileOrNull

```java
T findBySqlFileOrNull(Class<T> entityClass, String sqlId, Object params)
```

SQL_IDをもとに1件検索を行う。

**パラメータ:**
- `<T>` - 検索結果をマッピングするBeanクラスの型
- `entityClass` - 検索結果をマッピングするBeanクラス
- `sqlId` - SQL_ID
- `params` - バインド変数

**戻り値:**
エンティティオブジェクト。0件の場合はnull。

---

### countBySqlFile

```java
long countBySqlFile(Class<T> entityClass, String sqlId, Object params)
```

SQL_IDをもとに結果件数を取得する。

**パラメータ:**
- `<T>` - エンティティクラスの型
- `entityClass` - エンティティクラス
- `sqlId` - SQL_ID
- `params` - バインド変数

**戻り値:**
件数

---

### update

```java
int update(T entity)
           throws OptimisticLockException
```

エンティティオブジェクトを元に更新処理を行う。
<p/>
エンティティの主キーが更新条件となる。

**パラメータ:**
- `<T>` - エンティティクラスの型
- `entity` - エンティティオブジェクト

**戻り値:**
更新件数

**例外:**
- `OptimisticLockException` - バージョン不一致で更新対象が存在しない場合

---

### batchUpdate

```java
void batchUpdate(List<T> entities)
```

エンティティオブジェクトの情報を元に一括更新を行う。
<p/>
{@link #update(Object)}とは異なり、一括更新処理ではバージョン不一致チェックは行わない。
例えば、バージョン番号が変更になっていた場合はそのレコードのみ更新されずに処理は正常に終了する。
バージョン番号のチェックを必要とする場合には、{@link #update(Object)}を使用すること。

**パラメータ:**
- `entities` - 更新対象のエンティティリスト
- `<T>` - エンティティクラスの型

---

### insert

```java
void insert(T entity)
```

エンティティオブジェクトを元に登録処理を行う。

**パラメータ:**
- `<T>` - エンティティクラスの型
- `entity` - エンティティオブジェクト

---

### batchInsert

```java
void batchInsert(List<T> entities)
```

エンティティオブジェクトの情報を一括で登録する。

**パラメータ:**
- `entities` - エンティティリスト
- `<T>` - エンティティクラスの型

---

### delete

```java
int delete(T entity)
```

エンティティオブジェクトを元に削除処理を行う。
<p/>
エンティティの主キーが削除条件となる。

**パラメータ:**
- `<T>` - エンティティクラスの型
- `entity` - エンティティオブジェクト

**戻り値:**
削除件数

---

### batchDelete

```java
void batchDelete(List<T> entities)
```

エンティティオブジェクトを元に一括削除処理を行う。
<p/>
エンティティの主キーが削除条件となる。

**パラメータ:**
- `entities` - エンティティリスト
- `<T>` - エンティティクラスの型

---

### page

```java
DaoContext page(long page)
```

ページングの何ページ目を検索するかを指定する。

**パラメータ:**
- `page` - ページ番号(1-origin)

**戻り値:**
DaoContextがそのまま返る。

---

### per

```java
DaoContext per(long per)
```

ページングの1ページにつき何件表示するかを指定する。

**パラメータ:**
- `per` - ページ内表示件数

**戻り値:**
DaoContextがそのまま返る。

---

### defer

```java
DaoContext defer()
```

検索結果の取得を遅延させる。

**戻り値:**
DaoContextがそのまま返る。

---
