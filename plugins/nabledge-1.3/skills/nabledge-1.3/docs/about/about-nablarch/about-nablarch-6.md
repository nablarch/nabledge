# DB2やSQLServerでのバイナリ型のカラムへのアクセス方法を教えてください

> **question:**
> DB2のBLOB型のデータへアクセスすると「操作が無効です: Lob はクローズされています。」エラーが発生します。
> このエラーを回避する方法はありますか？

> SQLServerのLONGVARBINARY(VARBINARY(max)で定義されたカラム)にアクセスすると、
> ヒープが大量に消費されますが、回避方法はありますか？

> **answer:**
> * >   DB2の場合

>   **回答内容は、バージョン10.1のドキュメントを元に作成しています。
>   他のバージョンでは、異なる動作となることも考えられますので、必ずベンダーから提供されるマニュアルを元に
>   設定及び実装を行うようにしてください。**

>   BLOB型に格納されるサイズにより、以下の2通りの対応方法があります。
>   それぞれに対して対応案を例示しますので、アーキテクトの方はどちらがプロジェクトに適しているかを判断し、対応を行なってください。

>   1. >     BLOBに格納される値のサイズが小さい場合（ヒープに展開されても問題ない場合）
>   2. >     BLOBに格納される値のサイズが大きい場合（ヒープに展開されるとメモリが不足する可能性がある場合）

>   * >     BLOBに格納されるサイズが小さい場合

>   BLOB型のカラムに格納されるデータサイズが小さい(ヒープサイズから見てメモリ上に展開されても問題ないサイズ)場合は、
>   DB2のDataSourceのプロパティへの設定でバイナリデータをヒープに展開されるようにしてください。
>   これにより、「Lobはクローズされています。」エラーを回避することができます。

>   なお、この設定はアーキテクトが行うものであり、各開発者が行う必要はありません。

>   以下に設定例を示します。

>   ```xml
>   <component class="com.ibm.db2.jcc.DB2SimpleDataSource">
>     <!-- 接続先情報などは省略 -->
>   
>     <!-- progressiveStreamingには、「2」を設定する。 -->
>     <property name="progressiveStreaming" value="2" />
>   </component>
>   ```

>   * >     BLOBに格納されるサイズが大きい場合

>   BLOB型のカラムに格納されるデータサイズが大きい(ヒープサイズから見てメモリ上に展開されることが好ましくない)場合は、
>   ロケータを使用してアクセスする必要があります。
>   なお、この場合は設定ファイルと実装の両方へ影響があります。

>   * >     設定ファイルの例

>     ```xml
>     <component class="com.ibm.db2.jcc.DB2SimpleDataSource">
>       <!-- 接続先情報などは省略 -->
>     
>       <!-- progressiveStreamingには、「1」を設定する。 -->
>       <property name="progressiveStreaming" value="1" />
>     </component>
>     ```
>   * >     実装例

>     java.sql.ResultSetがカレントレコードの場合のみBLOBのデータにアクセスできます。
>     このため、retrieveではなくexecuteQueryを使用してカレントレコードのBLOBデータへアクセスする必要があります。

>     ```java
>     // retrieveではなく、executeQueryを使用する。
>     // retrieveを使用すると、「Lobはクローズされています。」エラーが発生します。
>     ResultSetIterator rows = statement.executeQuery();
>     
>     // ResultSetIterator#nextを使って次のレコードへカレントを進めてからBLOBのデータにアクセスします。
>     if (rows.next()) {
>         // データが取得できている場合は、BLOBのデータを取得する。
>         SqlRow row = rows.getRow();
>         Blob blobColumn = (Blob) row.get("blob_column");
>     
>         // Blobのデータにアクセスする処理は省略
>     }
>     ```
> * >   SQLServerの場合

>   **回答内容は、バージョン2008R2のドキュメントを元に作成しています。
>   他のバージョンでは、異なる動作となることも考えられますので、必ずベンダーから提供されるマニュアルを元に
>   設定及び実装を行うようにしてください。**

>   LONGVARBINARY(VARBINARY(max)と定義したカラム)の場合には、ストリーム経由でデータへアクセスすることを推奨します。
>   VARBINARY(max)以外の場合は、指定できる上限が8000であることからストリーム経由ではなく、ヒープ上にデータを展開する実装でも問題ないでしょう。

>   LONGVARBINARYをストリーム経由で取得するためには、ResultSetConvertorの実装クラスを作成しストリームオブジェクトを返却する必要があります。
>   アプリケーションプログラムでは、ストリームオブジェクトからデータを読み込む必要があります。

>   * >     ResultSetConvertorの実装

>     実装サンプルとして提供される、nablarch.core.db.statement.SqlServerResultSetConvertorを参考にしてください。
>     必要に応じてパッケージの変更や実装変更を行ってください。

>     なお、ResultSetConvertorの実装はアーキテクトが行うものであり、各開発者が行う必要はありません。
>   * >     アプリケーション実装

>     java.sql.ResultSetがカレントレコードの場合のみLONGVARBINARYのデータにアクセスできます。
>     このため、retrieveではなくexecuteQueryを使用してカレントレコードのLONGVARBINARYデータへアクセスする必要があります。

>     また、LONGVARBINARYと同時にその他のバイナリ型(BINARYやVARBINARY)のカラムを取得することはできないので、
>     LONGVARBINARY型のカラムを取得する際は、その他のバイナリ型のカラムをSELECT句に含めないようにしてください。

>     ```java
>     // retrieveではなく、executeQueryを使用する。
>     // retrieveを使用すると、「ストリームは閉じられています。」エラーが発生します。
>     ResultSetIterator rows = statement.executeQuery();
>     
>     // ResultSetIterator#nextを使って次のレコードへカレントを進めてからLONGVARBINARYのデータにアクセスします。
>     if (rows.next()) {
>         // データが取得できている場合は、BLOBのデータを取得する。
>         SqlRow row = rows.getRow();
>         InputStream binaryColumn = (InputStream) row.get("binary_column");
>     
>         // InputStreamにアクセスする処理は省略
>     }
>     ```
