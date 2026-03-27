# DB2やSQLServerでのバイナリ型のカラムへのアクセス方法を教えてください

## DB2およびSQLServerでのバイナリ型カラムアクセス方法

DB2およびSQLServerでバイナリ型カラムへアクセスする際の問題と対処方法。

> **注意**: DB2の情報はバージョン10.1、SQLServerの情報はバージョン2008R2のドキュメントを元にしています。他のバージョンでは動作が異なる場合があります。必ずベンダーのマニュアルを参照してください。

## DB2 BLOB型へのアクセス

「Lobはクローズされています。」エラーの回避方法はBLOBサイズにより異なる。

### BLOBサイズが小さい場合（ヒープに展開しても問題ない場合）

`com.ibm.db2.jcc.DB2SimpleDataSource`の`progressiveStreaming`プロパティに`2`を設定する。この設定はアーキテクトが行うものであり、各開発者が行う必要はない。

```xml
<component class="com.ibm.db2.jcc.DB2SimpleDataSource">
  <property name="progressiveStreaming" value="2" />
</component>
```

### BLOBサイズが大きい場合（ヒープ展開するとメモリ不足の可能性がある場合）

ロケータを使用してアクセスする必要がある。設定ファイルと実装の両方に影響がある。

**設定**:
```xml
<component class="com.ibm.db2.jcc.DB2SimpleDataSource">
  <property name="progressiveStreaming" value="1" />
</component>
```

> **重要**: `retrieve`ではなく`executeQuery`を使用すること。`retrieve`を使用すると「Lobはクローズされています。」エラーが発生する。`java.sql.ResultSet`がカレントレコードの場合のみBLOBデータにアクセス可能。

**実装例**:
```java
ResultSetIterator rows = statement.executeQuery();
if (rows.next()) {
    SqlRow row = rows.getRow();
    Blob blobColumn = (Blob) row.get("blob_column");
}
```

## SQLServer LONGVARBINARY（VARBINARY(max)）へのアクセス

VARBINARY(max)で定義されたカラムはストリーム経由でアクセスすることを推奨する。VARBINARY(max)以外（上限8000）はヒープ展開でも問題ない。

> **重要**: `retrieve`ではなく`executeQuery`を使用すること。`retrieve`を使用すると「ストリームは閉じられています。」エラーが発生する。`java.sql.ResultSet`がカレントレコードの場合のみLONGVARBINARYデータにアクセス可能。

> **重要**: LONGVARBINARYと同時に他のバイナリ型（BINARYやVARBINARY）カラムを取得することはできない。LONGVARBINARY取得時はSELECT句に他のバイナリ型カラムを含めないこと。

ストリーム経由で取得するには`ResultSetConvertor`の実装クラスを作成してストリームオブジェクトを返却する。実装サンプル: `nablarch.core.db.statement.SqlServerResultSetConvertor`。ResultSetConvertorの実装はアーキテクトが行うものであり、各開発者が行う必要はない。

**実装例**:
```java
ResultSetIterator rows = statement.executeQuery();
if (rows.next()) {
    SqlRow row = rows.getRow();
    InputStream binaryColumn = (InputStream) row.get("binary_column");
}
```

<details>
<summary>keywords</summary>

DB2, SQLServer, BLOB, LONGVARBINARY, VARBINARY, バイナリ型, progressiveStreaming, DB2SimpleDataSource, ResultSetConvertor, SqlServerResultSetConvertor, executeQuery, ResultSetIterator, Lob, InputStream, バイナリ型カラムアクセス, LOBエラー回避, ストリームアクセス, SqlRow, Blob

</details>
