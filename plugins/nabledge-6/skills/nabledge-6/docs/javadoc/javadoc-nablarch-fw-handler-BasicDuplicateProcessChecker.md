# class BasicDuplicateProcessChecker

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- DuplicateProcessChecker
- Initializable

---

```java
public class BasicDuplicateProcessChecker
implements DuplicateProcessChecker, Initializable
```

データベースのテーブルを用いてプロセスの多重起動防止を行う{@link DuplicateProcessChecker}の実装クラス。
<p/>
２重起動チェックは、データベースのテーブルを用いて行う。
データベースのテーブルには、予めプロセスを識別するための値を設定しておく必要がある。
プロセスを識別する値が設定さていない場合は、２重起動チェックが正しく行えないが、
２重起動の可能性もあるため２重起動であることを示す例外を送出する。
<p/>
２重起動チェック用テーブルレイアウト例を以下に示す。
<pre>
----------------------------------   ------------------------------------------------------
カラム名                             説明
----------------------------------   ------------------------------------------------------
プロセス識別子                       プロセスを一意に識別するための値を格納する。

                                     例えばジョブIDなど

プロセスアクティブフラグ             プロセスの現在の状態を格納する。

                                     * 0:非アクティブ(実行されていない状態)
                                     * 1:アクティブ(実行されている状態)
----------------------------------   ------------------------------------------------------
</pre>

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### dbTransactionManager

```java
private SimpleDbTransactionManager dbTransactionManager
```

データベーストランザクションマネージャ

---

### tableName

```java
private String tableName
```

テーブル名

---

### processIdentifierColumnName

```java
private String processIdentifierColumnName
```

リクエストIDの物理カラム名

---

### processActiveFlgColumnName

```java
private String processActiveFlgColumnName
```

アクティブフラグの物理カラム名

---

### activeSql

```java
private String activeSql
```

チェック用SQL文

---

### inactiveSql

```java
private String inactiveSql
```

アクティブフラグを非アクティブに更新するSQL文

---

### permitProcessIdentifier

```java
private List<String> permitProcessIdentifier
```

２重起動を許可するリクエストID

---

## メソッドの詳細

### initialize

```java
public void initialize()
```

２重起動チェック用のSQL文を構築する。

---

### buildActiveSql

```java
private String buildActiveSql()
```

プロセスをアクティブ化するSQLを構築する。

**戻り値:**
構築したSQL文

---

### buildInactiveSql

```java
private String buildInactiveSql()
```

プロセスを非アクティブ化するSQL文を構築する。

**戻り値:**
構築したSQL文

---

### setDbTransactionManager

```java
public void setDbTransactionManager(SimpleDbTransactionManager dbTransactionManager)
```

データベーストランザクションマネージャを設定する。

**パラメータ:**
- `dbTransactionManager` - データベーストランザクションマネージャ

---

### setTableName

```java
public void setTableName(String tableName)
```

テーブル名を設定する。

**パラメータ:**
- `tableName` - テーブル名

---

### setProcessIdentifierColumnName

```java
public void setProcessIdentifierColumnName(String processIdentifierColumnName)
```

プロセスを特定するための識別子が格納されるカラムの物理名を設定する。

**パラメータ:**
- `processIdentifierColumnName` - プロセスを識別する値のカラム物理名

---

### setProcessActiveFlgColumnName

```java
public void setProcessActiveFlgColumnName(String processActiveFlgColumnName)
```

プロセスが起動中であることを示すフラグが格納されるカラムの物理名を設定する。

**パラメータ:**
- `processActiveFlgColumnName` - プロセス起動中フラグのカラム物理名

---

### setPermitProcessIdentifier

```java
public void setPermitProcessIdentifier(String[] permitProcessIdentifier)
```

２重起動を許可するプロセスの識別子リストを設定する。

**パラメータ:**
- `permitProcessIdentifier` - 許可リクエストIDのリスト

---

### checkAndActive

```java
public void checkAndActive(String processIdentifier)
                    throws AlreadyProcessRunningException
```

---

### isDuplicateProcess

```java
private boolean isDuplicateProcess(String processIdentifier)
```

２重起動チェックと現在のプロセスのアクティブ化を行う。

**パラメータ:**
- `processIdentifier` - チェック対象のリクエストID

**戻り値:**
２重起動の場合はtrue

---

### inactive

```java
public void inactive(String processIdentifier)
```

---

### isPermitProcess

```java
private boolean isPermitProcess(String processIdentifier)
```

２重起動が許可されたプロセスか否か

**パラメータ:**
- `processIdentifier` - プロセスを識別する値

**戻り値:**
２重起動が許可されている場合は{@code true}

---
