# class DatabaseMetaDataExtractor

**パッケージ:** nablarch.common.dao

---

```java
public class DatabaseMetaDataExtractor
```

JDBCの{@link DatabaseMetaData}からメタ情報を取得するクラス。
<p/>
JDBCの{@link DatabaseMetaData}から情報を取得できないデータベース構成の場合には、
本クラスを継承し実装を差し替えること。

**作成者:** Hisaaki Shioiri  

---

## メソッドの詳細

### getPrimaryKeys

```java
public Map<String,Short> getPrimaryKeys(String tableName)
```

主キー情報を{@link DatabaseMetaData}から取得する。

**パラメータ:**
- `tableName` - テーブル名

**戻り値:**
主キー情報(key: カラム名, value: カラムポジション)

---

### toPrimaryKeyMap

```java
private static Map<String,Short> toPrimaryKeyMap(ResultSet resultSet)
                                  throws SQLException
```

主キー情報をキーがカラム名、値がカラムポジションのMapに変換する。

**パラメータ:**
- `resultSet` - 主キー情報({@link DatabaseMetaData#getPrimaryKeys(String, String, String)}の結果

**戻り値:**
変換した値

**例外:**
- `SQLException` - データベース例外

---
