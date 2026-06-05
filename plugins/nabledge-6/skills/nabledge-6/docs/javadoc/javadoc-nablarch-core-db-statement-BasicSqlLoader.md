# class BasicSqlLoader

**パッケージ:** nablarch.core.db.statement

**実装されたインタフェース:**
- StaticDataLoader<Map<String,String>>

---

```java
public class BasicSqlLoader
implements StaticDataLoader<Map<String,String>>
```

SQL文をクラスパス上のリソース(SQLファイル)からロードするクラス。<br/>
<p/>
本クラスでは、下記ルールに従いSQL文をロードする。<br/>
<p/>
a) SQL_IDとSQL文の1グループは、空行で区切られて記述されている。
<p/>
1つのSQL文の中に空行はいれてはならない。
また、異なるSQL文との間には必ず空行を入れなくてはならない。
コメント行は、空行とはならない。
<p/>
b) 1つのSQL文の最初の「=」までがSQL_IDとなる。
<p/>
SQL_IDとは、SQLファイル内でSQL文を一意に特定するためのIDである。
SQL_IDには、任意の値を設定することが可能となっている。
<p/>
c) コメントは、「--」で開始されている必要がある。
<p/>
「--」以降の値は、コメントとして扱い読み込まない。<br/>
※コメントは、行コメントとして扱う。複数行に跨るブロックコメントはサポートしない。
<p/>
d) SQL文の途中で改行を行っても良い。また、可読性を考慮してスペースやtabなどで桁揃えを行っても良い。

**作成者:** Hisaaki Sioiri  

---

## フィールドの詳細

### fileEncoding

```java
private String fileEncoding
```

ファイルエンコーディング

---

### COMMENT

```java
private static final String COMMENT
```

コメント開始文字

---

### extension

```java
private String extension
```

SQLファイルの拡張子(デフォルトは、.sql)

---

### sqlLoaderCallbackList

```java
private List<SqlLoaderCallback> sqlLoaderCallbackList
```

コールバッククラス

---

## メソッドの詳細

### setSqlLoaderCallback

```java
public void setSqlLoaderCallback(List<SqlLoaderCallback> sqlLoaderCallbackList)
```

コールバッククラスを設定する。
コールバッククラスはリストの順序で実行される。

**パラメータ:**
- `sqlLoaderCallbackList` - SQLプリプロセッサのリスト

---

### setFileEncoding

```java
public void setFileEncoding(String fileEncoding)
```

ファイルエンコーディングを設定する。<br/>
<p/>
ここで設定されたエンコーディングを使用してSQLファイルを読み込む。
本設定を行わない場合は、JVMのデフォルトエンコーディングを使用してSQLファイルが読み込まれる。

**パラメータ:**
- `fileEncoding` - ファイルエンコーディング

---

### setExtension

```java
public void setExtension(String extension)
```

拡張子を設定する。<br/>
ここで設定された拡張子を付加したファイルをSQLファイルとして読み込む。
指定がない場合は、デフォルトで拡張子はsqlとなる。

**パラメータ:**
- `extension` - 拡張子

---

### getValue

```java
public Map<String,String> getValue(Object id)
```

SQL文をロードする。

**パラメータ:**
- `id` - データのID(SQL文が書かれたファイルのリソース名)

**戻り値:**
ロードしたSQL文
        <br/>
        KEY->SQL_ID<br/>
        VALUE->SQL文

---

### registerSql

```java
private void registerSql(String sqlResource, String line, Map<String,String> holder)
```

1SQLをSQL_IDとSQL文に分割し、保持する。

**パラメータ:**
- `sqlResource` - SQLリソース名
- `line` - 1SQL
- `holder` - SQL文を保持するMap

---

### processOnAfterLoad

```java
private String processOnAfterLoad(String before, String sqlId)
```

SQL文ロード後の加工処理を行う。
{@link #setSqlLoaderCallback(List)}で設定されたコールバッククラスが順次適用される。

**パラメータ:**
- `before` - 元のSQL文
- `sqlId` - 元SQLのSQL_ID

**戻り値:**
処理後のSQL文

---

### getValues

```java
public List<Map<String,String>> getValues(String indexName, Object key)
```

{@inheritDoc}
<br/>
本メソッドは、サポートしない。

---

### loadAll

```java
public List<Map<String,String>> loadAll()
```

{@inheritDoc}
<br/>
本メソッドはサポートしない。

---

### getIndexNames

```java
public List<String> getIndexNames()
```

{@inheritDoc}
<br/>
本メソッドはサポートしない。

---

### getId

```java
public Object getId(Map<String,String> value)
```

{@inheritDoc}
<br/>
本メソッドはサポートしない。

---

### generateIndexKey

```java
public Object generateIndexKey(String indexName, Map<String,String> value)
```

{@inheritDoc}
<br/>
本メソッドはサポートしない。

---

### trimWhiteSpaceAndUnEscape

```java
private String trimWhiteSpaceAndUnEscape(String sql)
```

SQL文から不要なスペース(スペースの定義は、{@link Character#isWhitespace(char)})を削除する。<br/>
<br/>
前後のスペースだけではなく、見た目を整えるために挿入されているSQL文中のスペースも削除する。<br/>
また、アンエスケープ処理を行う。

**パラメータ:**
- `sql` - SQL文

**戻り値:**
スペースを除去したSQL文

---

### trimComment

```java
private String trimComment(String line)
```

ファイルから読み込んだ１行データからコメントを削除する。

**パラメータ:**
- `line` - 1行データ

**戻り値:**
コメントを削除したデータ

---
