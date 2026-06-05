# class BasicExclusiveControlManager

**パッケージ:** nablarch.common.exclusivecontrol

**実装されたインタフェース:**
- ExclusiveControlManager

---

```java
public class BasicExclusiveControlManager
implements ExclusiveControlManager
```

{@link ExclusiveControlManager}の基本実装クラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### INITIAL_VERSION

```java
private static final long INITIAL_VERSION
```

バージョン番号の初期値

---

### exclusiveControlTableSchemaAndSqlHolderCache

```java
private static Map<String,ExclusiveControlTable> exclusiveControlTableSchemaAndSqlHolderCache
```

SQL文のキャッシュ

---

### optimisticLockErrorMessageId

```java
private String optimisticLockErrorMessageId
```

楽観ロックエラーメッセージID

---

## メソッドの詳細

### setOptimisticLockErrorMessageId

```java
public void setOptimisticLockErrorMessageId(String optimisticLockErrorMessageId)
```

楽観ロックエラーメッセージIDを設定する。

**パラメータ:**
- `optimisticLockErrorMessageId` - 楽観ロックエラーメッセージID

---

### getVersion

```java
public Version getVersion(ExclusiveControlContext context)
```

{@inheritDoc}

---

### checkVersions

```java
public void checkVersions(List<Version> versions)
```

{@inheritDoc}

---

### getOptimisticLockErrorMessage

```java
protected Message getOptimisticLockErrorMessage()
```

楽観的ロックエラー発生時のメッセージを取得する。

**戻り値:**
楽観的ロックエラー発生時のメッセージ。メッセージIDが設定されていない場合はnull

---

### updateVersionsWithCheck

```java
public void updateVersionsWithCheck(List<Version> versions)
```

{@inheritDoc}

---

### updateVersion

```java
public void updateVersion(ExclusiveControlContext context)
```

{@inheritDoc}

---

### getInitialVersion

```java
protected Long getInitialVersion()
```

初期バージョン番号を取得する。
<p/>
このメソッドは、バージョン番号追加時に使用される。
デフォルト実装では、"1"を返す。

**戻り値:**
初期バージョン番号

---

### addVersion

```java
public void addVersion(ExclusiveControlContext context)
```

{@inheritDoc}

---

### removeVersion

```java
public void removeVersion(ExclusiveControlContext context)
```

{@inheritDoc}

---

### getExclusiveControlTableHolder

```java
protected ExclusiveControlTable getExclusiveControlTableHolder(ExclusiveControlContext context)
```

排他制御用テーブルに対応した{@link ExclusiveControlTable}を取得する。
<p/>
{@link #getExclusiveControlTableHolder(String, String, String...)}に処理を委譲する。

**パラメータ:**
- `context` - 排他制御コンテキスト

**戻り値:**
排他制御用テーブルに対応した{@link ExclusiveControlTable}

---

### getExclusiveControlTableHolder

```java
protected ExclusiveControlTable getExclusiveControlTableHolder(Version version)
```

排他制御用テーブルに対応した{@link ExclusiveControlTable}を取得する。
<p/>
{@link #getExclusiveControlTableHolder(String, String, String...)}に処理を委譲する。

**パラメータ:**
- `version` - バージョン番号

**戻り値:**
排他制御用テーブルに対応した{@link ExclusiveControlTable}

---

### getExclusiveControlTableHolder

```java
protected ExclusiveControlTable getExclusiveControlTableHolder(String tableName, String versionColumnName, String primaryKeyColumnNames)
```

排他制御用テーブルに対応した{@link ExclusiveControlTable}を取得する。
<p/>
一度生成した{@link ExclusiveControlTable}は、メモリ上にキャッシュしている。
このため、キャッシュに存在する場合は、キャッシュしているものを返し、
キャッシュに存在しない場合は、{@link ExclusiveControlTable}を生成し、キャッシュに追加したものを返す。
{@link ExclusiveControlTable}の生成では、排他制御用テーブルのスキーマ情報からSQL文を作成する。

**パラメータ:**
- `tableName` - 排他制御用テーブルのテーブル名
- `versionColumnName` - バージョン番号カラム名
- `primaryKeyColumnNames` - 主キーのカラム名

**戻り値:**
排他制御用テーブルに対応した{@link ExclusiveControlTable}

---

### createExclusiveControlTableSchemaAndSqlHolder

```java
protected ExclusiveControlTable createExclusiveControlTableSchemaAndSqlHolder(String tableName, String versionColumnName, String primaryKeyColumnNames)
```

排他制御用テーブルのスキーマ情報から{@link ExclusiveControlTable}を生成する。
<p/>
下記のメソッドから各SQL文のテンプレートを取得し、プレースホルダを置換することでSQL文を作成する。
SQL文を変更したい場合は、下記メソッドをオーバライドして対応する。
<ul>
<li>{@link #getSelectSqlTemplate()}</li>
<li>{@link #getSelectAndCheckSqlTemplate()}</li>
<li>{@link #getInsertSqlTemplate()}</li>
<li>{@link #getUpdateSqlTemplate()}</li>
<li>{@link #getUpdateAndCheckSqlTemplate()}</li>
<li>{@link #getDeleteSqlTemplate()}</li>
</ul>
デフォルト実装で作成されるSQL文は下記のとおり。
<pre>
排他制御用テーブルのスキーマ情報を下記に示す。

排他制御用テーブルのテーブル名: USER_TBL
バージョン番号カラム名    : VERSION
主キーのカラム名          : USER_ID, PK2, PK3

バージョン番号を取得するSQL文(バージョン番号の更新チェックなし)

    "SELECT VERSION FROM USER_TBL WHERE USER_ID = :user_id AND PK2 = :pk2 AND PK3 = :pk3"

バージョン番号を取得するSQL文(バージョン番号の更新チェックあり)

    "SELECT VERSION FROM USER_TBL WHERE USER_ID = :user_id AND PK2 = :pk2 AND PK3 = :pk3 AND VERSION = :version"

バージョン番号を追加するSQL文

    "INSERT INTO USER_TBL (USER_ID, PK2, PK3) VALUES (:user_id, :pk2, :pk3)"

バージョン番号を更新するSQL文(バージョン番号の更新チェックなし)

    "UPDATE USER_TBL SET VERSION = (VERSION + 1) WHERE USER_ID = :user_id AND PK2 = :pk2 AND PK3 = :pk3"

バージョン番号を更新するSQL文(バージョン番号の更新チェックあり)

    "UPDATE USER_TBL SET VERSION = (VERSION + 1) WHERE USER_ID = :user_id AND PK2 = :pk2 AND PK3 = :pk3 AND VERSION = :version"

バージョン番号を削除するSQL文

    "DELETE FROM USER_TBL WHERE WHERE USER_ID = :user_id AND PK2 = :pk2 AND PK3 = :pk3"

</pre>

**パラメータ:**
- `tableName` - 排他制御用テーブルのテーブル名
- `versionColumnName` - バージョン番号カラム名
- `primaryKeyColumnNames` - 主キーのカラム名

**戻り値:**
{@link ExclusiveControlTable}

---

### getSelectSqlTemplate

```java
protected String getSelectSqlTemplate()
```

バージョン番号を取得するSQL文(バージョン番号の更新チェックなし)のテンプレートを取得する。
<pre>
下記のプレースホルダを使用してテンプレートを作成する。

$VERSION$: バージョン番号カラム名
$TABLE_NAME$: 排他制御用テーブルのテーブル名
$PRIMARY_KEYS_CONDITION$: 主キーの条件(例: "PK1 = :pk1 AND PK2 = :pk2")

デフォルト実装では、下記のテンプレートを返す。

"SELECT $VERSION$ FROM $TABLE_NAME$ WHERE $PRIMARY_KEYS_CONDITION$"

変換例を下記に示す。

テーブル定義

    CREATE TABLE EXCLUSIVE_USER (
        USER_ID CHAR(6) NOT NULL,
        VERSION NUMBER(10) NOT NULL,
        PRIMARY KEY(USER_ID)
    )

テンプレートから作成されるSQL文

    "SELECT VERSION FROM EXCLUSIVE_USER WHERE USER_ID = :user_id"

</pre>

**戻り値:**
バージョン番号を取得するSQL文(バージョン番号の更新チェックなし)のテンプレート

---

### getSelectAndCheckSqlTemplate

```java
protected String getSelectAndCheckSqlTemplate()
```

バージョン番号を取得するSQL文(バージョン番号の更新チェックあり)のテンプレートを取得する。
<pre>
下記のプレースホルダを使用してテンプレートを作成する。

$VERSION$: バージョン番号カラム名
$TABLE_NAME$: 排他制御用テーブルのテーブル名
$PRIMARY_KEYS_CONDITION$: 主キーの条件(例: "PK1 = :pk1 AND PK2 = :pk2")
$VERSION_CONDITION$: バージョン番号の条件(例: "VERSION = :version")

デフォルト実装では、下記のテンプレートを返す。

"SELECT $VERSION$ FROM $TABLE_NAME$ WHERE $PRIMARY_KEYS_CONDITION$ AND $VERSION_CONDITION$"

変換例を下記に示す。

テーブル定義

    CREATE TABLE EXCLUSIVE_USER (
        USER_ID CHAR(6) NOT NULL,
        VERSION NUMBER(10) NOT NULL,
        PRIMARY KEY(USER_ID)
    )

テンプレートから作成されるSQL文

    "SELECT VERSION FROM EXCLUSIVE_USER WHERE USER_ID = :user_id AND VERSION = :version"

</pre>

**戻り値:**
バージョン番号を取得するSQL文(バージョン番号の更新チェックあり)のテンプレート

---

### getInsertSqlTemplate

```java
protected String getInsertSqlTemplate()
```

バージョン番号を追加するSQL文のテンプレートを取得する。
<pre>
下記のプレースホルダを使用してテンプレートを作成する。

$TABLE_NAME$: 排他制御用テーブルのテーブル名
$COLUMNS_AND_VALUES$: INSERT文のカラム名と値(例: "(PK1, PK2, VERSION) VALUES (:pk1, :pk2, :version)")

デフォルト実装では、下記のテンプレートを返す。

"INSERT INTO $TABLE_NAME$ $COLUMNS_AND_VALUES$"

変換例を下記に示す。

テーブル定義

    CREATE TABLE EXCLUSIVE_USER (
        USER_ID CHAR(6) NOT NULL,
        VERSION NUMBER(10) NOT NULL,
        PRIMARY KEY(USER_ID)
    )

テンプレートから作成されるSQL文

    "INSERT INTO EXCLUSIVE_USER (USER_ID, VERSION) VALUES (:user_id, :version)"

</pre>

**戻り値:**
バージョン番号を追加するSQL文のテンプレート

---

### getUpdateSqlTemplate

```java
protected String getUpdateSqlTemplate()
```

バージョン番号を更新するSQL文(バージョン番号の更新チェックなし)のテンプレートを取得する。
<pre>
下記のプレースホルダを使用してテンプレートを作成する。

$VERSION$: バージョン番号カラム名
$TABLE_NAME$: 排他制御用テーブルのテーブル名
$PRIMARY_KEYS_CONDITION$: 主キーの条件(例: "PK1 = :pk1 AND PK2 = :pk2")

デフォルト実装では、下記のテンプレートを返す。

"UPDATE $TABLE_NAME$ SET $VERSION$ = ($VERSION$ + 1) WHERE $PRIMARY_KEYS_CONDITION$"

変換例を下記に示す。

テーブル定義

    CREATE TABLE EXCLUSIVE_USER (
        USER_ID CHAR(6) NOT NULL,
        VERSION NUMBER(10) NOT NULL,
        PRIMARY KEY(USER_ID)
    )

テンプレートから作成されるSQL文

    "UPDATE EXCLUSIVE_USER SET VERSION = (VERSION + 1) WHERE USER_ID = :user_id"

</pre>

**戻り値:**
バージョン番号を更新するSQL文(バージョン番号の更新チェックなし)のテンプレート

---

### getUpdateAndCheckSqlTemplate

```java
protected String getUpdateAndCheckSqlTemplate()
```

バージョン番号を更新するSQL文(バージョン番号の更新チェックあり)のテンプレートを取得する。
<pre>
下記のプレースホルダを使用してテンプレートを作成する。

$VERSION$: バージョン番号カラム名
$TABLE_NAME$: 排他制御用テーブルのテーブル名
$PRIMARY_KEYS_CONDITION$: 主キーの条件(例: "PK1 = :pk1 AND PK2 = :pk2")
$VERSION_CONDITION$: バージョン番号の条件(例: "VERSION = :version")

デフォルト実装では、下記のテンプレートを返す。

"UPDATE $TABLE_NAME$ SET $VERSION$ = ($VERSION$ + 1) WHERE $PRIMARY_KEYS_CONDITION$ AND $VERSION_CONDITION$"

変換例を下記に示す。

テーブル定義

    CREATE TABLE EXCLUSIVE_USER (
        USER_ID CHAR(6) NOT NULL,
        VERSION NUMBER(10) NOT NULL,
        PRIMARY KEY(USER_ID)
    )

テンプレートから作成されるSQL文

    "UPDATE EXCLUSIVE_USER SET VERSION = (VERSION + 1) WHERE USER_ID = :user_id AND VERSION = :version"

</pre>

**戻り値:**
バージョン番号を更新するSQL文(バージョン番号の更新チェックあり)のテンプレート

---

### getDeleteSqlTemplate

```java
protected String getDeleteSqlTemplate()
```

バージョン番号を削除するSQL文のテンプレートを取得する。
<pre>
下記のプレースホルダを使用してテンプレートを作成する。

$TABLE_NAME$: 排他制御用テーブルのテーブル名
$PRIMARY_KEYS_CONDITION$: 主キーの条件(例: "PK1 = :pk1 AND PK2 = :pk2")

デフォルト実装では、下記のテンプレートを返す。

"DELETE FROM $TABLE_NAME$ WHERE $PRIMARY_KEYS_CONDITION$"

変換例を下記に示す。

テーブル定義

    CREATE TABLE EXCLUSIVE_USER (
        USER_ID CHAR(6) NOT NULL,
        VERSION NUMBER(10) NOT NULL,
        PRIMARY KEY(USER_ID)
    )

テンプレートから作成されるSQL文

    "DELETE FROM EXCLUSIVE_USER WHERE USER_ID = :user_id"

</pre>

**戻り値:**
バージョン番号を削除するSQL文のテンプレート

---

### getInsertColumnsAndValues

```java
protected String getInsertColumnsAndValues(String[] primaryKeyColumnNames, String versionColumnName)
```

INSERT文のカラムと値を取得する。

**パラメータ:**
- `primaryKeyColumnNames` - 主キーカラム名
- `versionColumnName` - バージョン番号カラム名

**戻り値:**
INSERT文のカラムと値

---

### getPrimaryKeysCondition

```java
protected String getPrimaryKeysCondition(String[] columnNames)
```

主キー条件を取得する。

**パラメータ:**
- `columnNames` - カラム名

**戻り値:**
主キー条件

---

### putVersionNo

```java
private static void putVersionNo(Map<String,Object> data, ExclusiveControlTable exclusiveControlTableHolder, Version version)
```

バージョン番号をデータオブジェクトに追加する。

**パラメータ:**
- `data` - データオブジェクト
- `exclusiveControlTableHolder` - 排他制御テーブルの情報
- `version` - バージョン情報

---
