# DB2やSQLServerでのバイナリ型のカラムへのアクセス方法を教えてください

## DB2やSQLServerでのバイナリ型のカラムへのアクセス方法

## DB2 BLOB型へのアクセス

> **注意**: 以下はバージョン10.1のドキュメントを元にしています。他のバージョンでは動作が異なる場合があります。

BLOBに格納されるサイズにより対応方法が2通りある。

### BLOBサイズが小さい場合（ヒープ展開が問題ない場合）

`com.ibm.db2.jcc.DB2SimpleDataSource`の`progressiveStreaming`プロパティに`2`を設定する。これにより「Lobはクローズされています。」エラーを回避できる。

> **注意**: この設定はアーキテクトが行うものであり、各開発者が行う必要はない。

```xml
<component class="com.ibm.db2.jcc.DB2SimpleDataSource">
  <property name="progressiveStreaming" value="2" />
</component>
```

### BLOBサイズが大きい場合（ヒープ展開を避けたい場合）

ロケータを使用してアクセスする必要がある。設定ファイルと実装の両方に影響あり。

`progressiveStreaming`に`1`を設定:

```xml
<component class="com.ibm.db2.jcc.DB2SimpleDataSource">
  <property name="progressiveStreaming" value="1" />
</component>
```

> **重要**: `ResultSet`がカレントレコードの場合のみBLOBデータにアクセスできる。`retrieve`ではなく`executeQuery`を使用すること。`retrieve`を使用すると「Lobはクローズされています。」エラーが発生する。

```java
// retrieveではなく、executeQueryを使用する。
ResultSetIterator rows = statement.executeQuery();
if (rows.next()) {
    SqlRow row = rows.getRow();
    Blob blobColumn = (Blob) row.get("blob_column");
}
```

## SQLServer LONGVARBINARY型へのアクセス

> **注意**: 以下はバージョン2008R2のドキュメントを元にしています。他のバージョンでは動作が異なる場合があります。

`LONGVARBINARY`（`VARBINARY(max)`と定義したカラム）はストリーム経由でアクセスすること。`VARBINARY(max)`以外（上限8000）はヒープ上展開でも問題ない。

`ResultSetConvertor`の実装クラスを作成しストリームオブジェクトを返却する必要がある。実装サンプルとして`nablarch.core.db.statement.SqlServerResultSetConvertor`を参照すること。

> **注意**: ResultSetConvertorの実装はアーキテクトが行うものであり、各開発者が行う必要はない。

> **重要**: `ResultSet`がカレントレコードの場合のみLONGVARBINARYデータにアクセスできる。`retrieve`ではなく`executeQuery`を使用すること。`retrieve`を使用すると「ストリームは閉じられています。」エラーが発生する。

> **重要**: LONGVARBINARYと同時にその他のバイナリ型（BINARYやVARBINARY）のカラムを取得できない。LONGVARBINARY取得時はSELECT句にその他のバイナリ型カラムを含めないこと。

```java
// retrieveではなく、executeQueryを使用する。
ResultSetIterator rows = statement.executeQuery();
if (rows.next()) {
    SqlRow row = rows.getRow();
    InputStream binaryColumn = (InputStream) row.get("binary_column");
}
```

<details>
<summary>keywords</summary>

DB2, SQLServer, BLOB型, LONGVARBINARY, VARBINARY(max), progressiveStreaming, DB2SimpleDataSource, SqlServerResultSetConvertor, ResultSetConvertor, ResultSetIterator, executeQuery, SqlRow, バイナリ型カラムアクセス, Lobはクローズされています, ストリームは閉じられています, Blob, InputStream

</details>
