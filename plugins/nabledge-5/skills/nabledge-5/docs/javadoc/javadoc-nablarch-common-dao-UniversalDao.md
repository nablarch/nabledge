# class UniversalDao

**パッケージ:** nablarch.common.dao

---

```java
public final class UniversalDao
```

汎用的なDAO機能を提供するクラス。
<p/>
以下の機能を提供する。
<p/>
<ul>
<li>主キーを条件にしたSELECT・UPDATE・DELETE文と、INSERT文をEntityクラスから自動生成して実行する。</li>
<li>SQLを実行する</li>
<li>検索結果をBeanにマッピングする</li>
<li>ページングのための検索を行う</li>
<li>検索時に遅延ロードを行う</li>
</ul>
<p/>
EntityはJPA2.0のアノテーションに準拠する。
<p/>
サポートしているものは、以下である。
<p/>
<ul>
<li>{@link javax.persistence.Entity}</li>
<li>{@link javax.persistence.Table}</li>
<li>{@link javax.persistence.Column}</li>
<li>{@link javax.persistence.Id}</li>
<li>{@link javax.persistence.Version}</li>
<li>{@link javax.persistence.Temporal}</li>
<li>{@link javax.persistence.GeneratedValue}</li>
<li>{@link javax.persistence.SequenceGenerator}</li>
<li>{@link javax.persistence.TableGenerator}</li>
</ul>
<p/>

**作成者:** kawasima  
**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### DAO_CONTEXT_FACTORY

```java
private static final String DAO_CONTEXT_FACTORY
```

{@link DaoContextFactory}を{@link SystemRepository}からルックアップする際の名前

---

### EMPTY_PARAM

```java
private static final Object[] EMPTY_PARAM
```

空のパラメータを表す定数値

---

## コンストラクタの詳細

### UniversalDao

```java
private UniversalDao()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### daoContext

```java
private static DaoContext daoContext()
```

{@link DaoContext}を取得する。

{@link #DAO_CONTEXT_FACTORY}で{@link SystemRepository}上に{@link DaoContextFactory}実装が登録されている場合はそのクラスを、
登録されていない場合には{@link BasicDaoContextFactory}を用いて{@link DaoContext}を生成する。

**戻り値:**
DaoContext

---

### findById

```java
public static T findById(Class<T> entityClass, Object id)
```

主キーを指定して、1件だけエンティティを取得する。

**パラメータ:**
- `<T>` - エンティティクラス(戻り値の型)
- `entityClass` - エンティティクラスオブジェクト
- `id` - 条件項目(複数のキーを使う場合は、対象テーブルでのキーの定義順に引き渡す)

**戻り値:**
取得したエンティティ

**例外:**
- `NoDataException` - 検索条件に該当するレコードが存在しない場合
- `IllegalArgumentException` - 主キーのカラム数と指定した条件数が一致しない場合
- `IllegalStateException` - 対象テーブルから主キーの定義順を取得できなかった場合

---

### findByIdOrNull

```java
public static T findByIdOrNull(Class<T> entityClass, Object id)
```

主キーを指定して、1件だけエンティティを取得する。0件の場合はnullを返す。

**パラメータ:**
- `<T>` - エンティティクラス(戻り値の型)
- `entityClass` - エンティティクラスオブジェクト
- `id` - 条件項目(複数のキーを使う場合は、対象テーブルでのキーの定義順に引き渡す)

**戻り値:**
取得したエンティティ。0件の場合はnull。

**例外:**
- `IllegalArgumentException` - 主キーのカラム数と指定した条件数が一致しない場合
- `IllegalStateException` - 対象テーブルから主キーの定義順を取得できなかった場合

---

### findAll

```java
public static EntityList<T> findAll(Class<T> entityClass)
```

すべてのエンティティを取得する。

**パラメータ:**
- `<T>` - エンティティクラス(戻り値の型)
- `entityClass` - エンティティクラスオブジェクト

**戻り値:**
取得したエンティティのリスト(該当0件の場合は空リスト)

---

### findAllBySqlFile

```java
public static EntityList<T> findAllBySqlFile(Class<T> entityClass, String sqlId, Object params)
```

SQL_IDをもとにバインド変数を展開した上で検索し、結果Beanのリストに格納して取得する。
<pre>
{@code
// 検索条件を引き渡すためのBeanを設定する
// SQL「FIND_BY_AUTHOR」にBookエンティティのAUTHORカラムがバインド変数として記述されている場合を想定する
Book condition = new Book();
condition.setAuthor("Martin Fowler");

EntityList<Book> books = UniversalDao.findAllBySqlFile(Book.class, "FIND_BY_AUTHOR", condition);
}</pre>
<p/>
結合した表のカラムを含めて射影する場合は、単一の表とマッピングされたEntityでは結果を格納できない。
そのような場合は、射影したカラムと対応するプロパティを定義したBeanを引き渡す。

**パラメータ:**
- `<T>` - 検索結果をマッピングするBeanクラス
- `entityClass` - 検索結果をマッピングするBeanクラスオブジェクト
- `sqlId` - SQL_ID
- `params` - バインド変数(SQLファイル内のバインド変数に対応するBeanを作成し引き渡すこともできる)

**戻り値:**
取得したBeanのリスト(該当0件の場合は空リスト)

---

### findAllBySqlFile

```java
public static EntityList<T> findAllBySqlFile(Class<T> entityClass, String sqlId)
```

SQL_IDをもとに検索し、結果Beanのリストに格納して取得する。
<p/>
検索の詳細は{@link #findAllBySqlFile(Class, String, Object)}を参照すること。

**パラメータ:**
- `<T>` - 検索結果をマッピングするBeanクラス
- `entityClass` - 検索結果をマッピングするBeanクラスオブジェクト
- `sqlId` - SQL_ID

**戻り値:**
取得したBeanのリスト(該当0件の場合は空リスト)

---

### findBySqlFile

```java
public static T findBySqlFile(Class<T> entityClass, String sqlId, Object params)
```

SQL_IDをもとにバインド変数を展開して検索し、結果を格納したBeanを一件取得する。
<pre>
{@code
// 検索条件を引き渡すためのBeanを設定する
// FIND_BY_IDにBookエンティティのIDカラムがバインド変数として記述されている場合を想定
Book condition = new Book();
condition.setId(1L);

Book book = UniversalDao.findBySqlFile(Book.class, "FIND_BY_ID", condition);
}</pre>
<p/>
検索条件に該当するレコードが複数存在する場合、例外の送出は行わず、検索結果の先頭行を取得して返却する。
確実に一行のレコードを取得する検索条件を設定すること。
<p/>

**パラメータ:**
- `<T>` - 検索結果をマッピングするBeanクラス
- `entityClass` - 検索結果をマッピングするBeanクラスオブジェクト
- `sqlId` - SQL_ID
- `params` - バインド変数

**戻り値:**
1件のBean

**例外:**
- `NoDataException` - (検索条件に該当するレコードが存在しない場合)

---

### findBySqlFileOrNull

```java
public static T findBySqlFileOrNull(Class<T> entityClass, String sqlId, Object params)
```

SQL_IDをもとにバインド変数を展開して検索し、結果を格納したBeanを一件取得する。0件の場合はnullを返す。
<p/>
検索結果が0件の場合に{@link NoDataException}ではなくnull返す以外については、{@link #findBySqlFile(Class, String, Object)}
と同じである。

**パラメータ:**
- `<T>` - 検索結果をマッピングするBeanクラス
- `entityClass` - 検索結果をマッピングするBeanクラスオブジェクト
- `sqlId` - SQL_ID
- `params` - バインド変数

**戻り値:**
1件のBean。0件の場合はnull。

---

### countBySqlFile

```java
public static long countBySqlFile(Class<T> entityClass, String sqlId)
```

SQL_IDをもとに検索し、件数を取得する。
<p/>
検索の詳細は{@link #countBySqlFile(Class, String, Object)}を参照すること。

**パラメータ:**
- `entityClass` - エンティティクラス
- `sqlId` - SQL_ID
- `<T>` - エンティティクラス

**戻り値:**
件数

---

### countBySqlFile

```java
public static long countBySqlFile(Class<T> entityClass, String sqlId, Object params)
```

SQL_IDをもとにバインド変数を展開して検索し、件数を取得する。
<p/>
検索用のSQLを件数取得用のSQLへと変換して実行されるため、個別に件数取得用のSQLを作成する必要はない。

**パラメータ:**
- `entityClass` - エンティティクラス
- `sqlId` - SQL_ID
- `params` - バインド変数
- `<T>` - エンティティクラス

**戻り値:**
件数

---

### exists

```java
public static boolean exists(Class<T> entityClass, String sqlId)
```

SQL_IDをもとに検索し、データが存在するか否かを確認する。
<p/>
検索の詳細は{@link #exists(Class, String, Object)}を参照すること。
<p/>

**パラメータ:**
- `entityClass` - エンティティクラス
- `sqlId` - SQL_ID
- `<T>` - エンティティ型

**戻り値:**
存在すればtrue

---

### exists

```java
public static boolean exists(Class<T> entityClass, String sqlId, Object params)
```

SQL_IDをもとにバインド変数を展開して検索し、データが存在するか否かを確認する。
<p/>
検索用のSQLを変換して使用する。
<p/>

**パラメータ:**
- `entityClass` - エンティティクラス
- `sqlId` - SQL_ID
- `params` - バインド変数
- `<T>` - エンティティ型

**戻り値:**
存在すればtrue

---

### update

```java
public static int update(T entity)
```

与えられたエンティティオブジェクトからアップデート文を生成し実行する。
<p/>
エンティティオブジェクトにてnullであるプロパティに対応するカラムは、そのままnullで更新される。
<p/>
更新対象のエンティティに{@link javax.persistence.Version}が付与されたプロパティが存在する場合には、
対象レコードは排他制御の対象となり、更新処理実行時に自動で排他制御が実行される。
<p/>
排他制御の対象であるエンティティを更新する際は、以下の場合に{@link javax.persistence.OptimisticLockException}を送出する。
<ul>
<li>バージョン番号の不一致で、更新対象が存在しない場合</li>
<li>更新条件に合致する更新対象が存在しない場合</li>
</ul>
<p/>

**パラメータ:**
- `<T>` - エンティティクラス
- `entity` - エンティティオブジェクト

**戻り値:**
更新件数

**例外:**
- `javax.persistence.OptimisticLockException` - 更新対象が存在しない場合

---

### batchUpdate

```java
public static void batchUpdate(List<T> entities)
```

与えられたエンティティ情報からアップデート文を生成し一括実行する。
<p/>
バージョン番号を用いた排他制御処理は行わない。
排他制御を必要とする場合には、{@link #update(Object)}を使用すること。
もし、更新時にバージョン番号が不一致のエンティティオブジェクトが存在した場合、
そのレコードは更新されずに処理が正常に終了する。

**パラメータ:**
- `entities` - エンティティオブジェクトリスト
- `<T>` - エンティティクラス

---

### insert

```java
public static void insert(T entity)
```

与えられたエンティティオブジェクトからインサート文を生成し実行する。
<p/>
エンティティオブジェクトにてnullであるプロパティに対応するカラムは、そのままnullで登録される。
<p/>
{@link javax.persistence.GeneratedValue}が付与されているプロパティは採番された値が登録される。
<p/>
{@link javax.persistence.Version}が付与されたversionカラムに対して明示的に値を設定していたとしても、
「0」で上書きされてinsertされる。

**パラメータ:**
- `<T>` - エンティティクラス
- `entity` - エンティティオブジェクト

---

### batchInsert

```java
public static void batchInsert(List<T> entities)
```

与えられたエンティティリストオブジェクトからインサート文を生成し一括実行する。
<p/>
エンティティオブジェクトにてnullであるプロパティに対応するカラムは、そのままnullで登録される。
<p/>
{@link javax.persistence.GeneratedValue}が付与されているプロパティは採番された値が登録される。
<p/>
{@link javax.persistence.Version}が付与されたversionカラムに対して明示的に値を設定していたとしても、
「0」で上書きされてinsertされる。

**パラメータ:**
- `<T>` - エンティティクラス
- `entities` - エンティティリスト

---

### delete

```java
public static int delete(T entity)
```

与えられたエンティティオブジェクトからデリート文を生成し実行する。
<p/>
エンティティの主キーが削除条件となるため、主キー値以外のフィールドの値の有無は動作に影響しない。
<p/>

**パラメータ:**
- `<T>` - エンティティクラス
- `entity` - エンティティオブジェクト

**戻り値:**
削除件数

---

### batchDelete

```java
public static void batchDelete(List<T> entities)
```

与えられたエンティティオブジェクトからデリート文を生成し一括実行する。
<p/>
エンティティの主キーが削除条件となるため、主キー値以外のフィールドの値の有無は動作に影響しない。
<p/>

**パラメータ:**
- `entities` - エンティティリスト
- `<T>` - エンティティクラス

---

### page

```java
public static DaoContext page(long page)
```

ページ数を指定する。
<pre>
{@code
 // pageメソッドに「1」が与えられている場合に返却される件数は以下のようになる。
 // perメソッドに「10」を与える→1～10件目を返す
 // perメソッドに「20」を与える→1～20件目を返す
EntityList<Book> books = UniversalDao.page(1)
                  .per(20)
                  .findAllBySqlFile(Book.class, "FIND_ALL");

 // pageメソッドに「2」が与えられている場合に返却される件数は以下のようになる。
 // perメソッドに「10」を与える→11～20件目を返す
 // perメソッドに「20」を与える→21～40件目を返す
EntityList<Book> books = UniversalDao.page(2)
                  .per(20)
                  .findAllBySqlFile(Book.class, "FIND_ALL");
}</pre>
<p/>
表示対象のページ数におけるレコード件数が、perメソッドで与えたページ区切りに満たない場合は、取得可能な件数分を返却する。
<ul>
<li>perメソッドに10を与えていて、総件数が5件である場合、pageメソッドに1を与えた場合は1～5件目を返却する。</li>
<li>perメソッドに10を与えていて、総件数が15件である場合、pageメソッドに2を与えた場合は11～15件目を返却する。</li>
</ul>
<p/>
ページ変更の度に検索処理を行うことになるため、ソートを使用して検索結果の出力順を固定すること。

**パラメータ:**
- `page` - ページ数

**戻り値:**
DaoContext

---

### per

```java
public static DaoContext per(long per)
```

1ページにつき何件取得するかを指定する。
<pre>
{@code
 // perメソッドに「10」が与えられている場合は、返却される件数は以下のようになる。
 // pageメソッドに「1」を与える→1～10件目を返す
 // pageメソッドに「2」を与える→11～20件目を返す
EntityList<Book> books = UniversalDao.page(1)
                  .per(10)
                  .findAllBySqlFile(Book.class, "FIND_ALL");

 // perメソッドに「20」が与えられている場合は、返却される件数は以下のようになる。
 // pageメソッドに「1」を与える→1～20件目を返す
 // pageメソッドに「2」を与える→21～40件目を返す
EntityList<Book> books = UniversalDao.page(1)
                  .per(20)
                  .findAllBySqlFile(Book.class, "FIND_ALL");
}</pre>
<p/>
表示対象のページ数におけるレコード件数が、perメソッドで与えたページ区切りに満たない場合は、取得可能な件数分を返却する。
perメソッドに10を与えていて、総件数が5件である場合、pageメソッドに1を与えた場合は1～5件目を返却する。
perメソッドに10を与えていて、総件数が15件である場合、pageメソッドに2を与えた場合は11～15件目を返却する。
<p/>

**パラメータ:**
- `per` - 取得する件数

**戻り値:**
DaoContext

---

### defer

```java
public static DaoContext defer()
```

検索結果の取得を遅延させる。
<p/>
大量データを検索する場合でもヒープを圧迫することなく安全に検索結果を扱うことができる。
<pre>
{@code
// サーバサイドカーソルを利用するためclose処理を行う必要がある
try (DeferredEntityList<Project> searchList =  (DeferredEntityList<Project>) UniversalDao
        .defer()
        .findAllBySqlFile(Project.class, "SEARCH_PROJECT",searchCondition)) {
    for (Project project : searchList) {
        // projectを利用した処理
    }
}
}</pre>
<p/>

**戻り値:**
DaoContext

---
