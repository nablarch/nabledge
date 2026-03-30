# DB2やSQLServerでのバイナリ型のカラムへのアクセス方法を教えてください

## DB2およびSQLServerでのバイナリ型カラムアクセス方法

## DB2のBLOB型アクセス

> **バージョン注記**: 回答内容は、バージョン10.1のドキュメントを元に作成しています。他のバージョンでは、異なる動作となることも考えられますので、必ずベンダーから提供されるマニュアルを元に設定及び実装を行うようにしてください。

BLOB型のサイズにより2通りの対応が必要。アーキテクトがどちらがプロジェクトに適しているかを判断し、対応を行うこと。

### サイズが小さい場合（ヒープ展開可）

DB2のDataSourceの`progressiveStreaming`プロパティを`2`に設定することで「Lobはクローズされています。」エラーを回避できる。

> **注記**: この設定はアーキテクトが行うものであり、各開発者が行う必要はありません。

```xml
<component class="com.ibm.db2.jcc.DB2SimpleDataSource">
  <property name="progressiveStreaming" value="2" />
</component>
```

### サイズが大きい場合（ヒープ展開不可）

ロケータを使用してアクセスする必要がある。設定ファイルと実装の両方に影響がある。

`java.sql.ResultSet`がカレントレコードの場合のみBLOBのデータにアクセスできる。このため、`retrieve`ではなく`executeQuery`を使用してカレントレコードのBLOBデータへアクセスする必要がある。`ResultSetIterator#next`でカレントを進めてからBLOBデータにアクセスすること。`retrieve`を使用すると「Lobはクローズされています。」エラーが発生する。

設定:
```xml
<component class="com.ibm.db2.jcc.DB2SimpleDataSource">
  <property name="progressiveStreaming" value="1" />
</component>
```

実装例:
```java
ResultSetIterator rows = statement.executeQuery();
if (rows.next()) {
    SqlRow row = rows.getRow();
    Blob blobColumn = (Blob) row.get("blob_column");
}
```

## SQLServerのLONGVARBINARY(VARBINARY(max))アクセス

> **バージョン注記**: 回答内容は、バージョン2008R2のドキュメントを元に作成しています。他のバージョンでは、異なる動作となることも考えられますので、必ずベンダーから提供されるマニュアルを元に設定及び実装を行うようにしてください。

> **重要**: LONGVARBINARY（VARBINARY(max)と定義したカラム）はストリーム経由でアクセスすること。VARBINARY(max)以外（上限8000）はヒープ展開でも問題ない。

ストリーム経由で取得するには`ResultSetConvertor`の実装クラスを作成してストリームオブジェクトを返却する必要がある。参考実装: `nablarch.core.db.statement.SqlServerResultSetConvertor`

> **注記**: ResultSetConvertorの実装はアーキテクトが行うものであり、各開発者が行う必要はありません。

`java.sql.ResultSet`がカレントレコードの場合のみLONGVARBINARYのデータにアクセスできる。このため、`retrieve`ではなく`executeQuery`を使用してカレントレコードのLONGVARBINARYデータへアクセスする必要がある。`retrieve`を使用すると「ストリームは閉じられています。」エラーが発生する。

> **重要**: LONGVARBINARYと同時に他のバイナリ型（BINARYやVARBINARY）のカラムは取得不可。LONGVARBINARYを取得する際はSELECT句に他のバイナリ型カラムを含めないこと。

実装例:
```java
ResultSetIterator rows = statement.executeQuery();
if (rows.next()) {
    SqlRow row = rows.getRow();
    InputStream binaryColumn = (InputStream) row.get("binary_column");
}
```

<details>
<summary>keywords</summary>

DB2, BLOB型, progressiveStreaming, DB2SimpleDataSource, com.ibm.db2.jcc.DB2SimpleDataSource, SQLServer, LONGVARBINARY, VARBINARY(max), ResultSetConvertor, SqlServerResultSetConvertor, nablarch.core.db.statement.SqlServerResultSetConvertor, ResultSetIterator, executeQuery, retrieve, バイナリ型カラムアクセス, ロケータ, ストリーム経由取得, SqlRow, Blob, InputStream

</details>
