# データベース接続管理ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/database_connection_management_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/DbConnectionManagementHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/ConnectionFactory.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/DbConnectionContext.html)

## ハンドラクラス名

後続ハンドラ及びライブラリで使用するDBへの接続をスレッド上で管理するハンドラ。処理: (1) DB接続の取得 (2) DB接続の解放

> **重要**: このハンドラを使用する場合は、`transaction_management_handler` をセットで設定すること。トランザクション制御ハンドラが未設定の場合、トランザクション制御が行われずDB変更がすべて破棄される。

**クラス名**: `nablarch.common.handler.DbConnectionManagementHandler`

<details>
<summary>keywords</summary>

DbConnectionManagementHandler, nablarch.common.handler.DbConnectionManagementHandler, TransactionManagementHandler, transaction_management_handler, データベース接続管理, スレッド管理, DB接続ハンドラ

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-jdbc</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core-jdbc, nablarch-common-jdbc, com.nablarch.framework, モジュール, Maven依存関係

</details>

## 制約

なし。

<details>
<summary>keywords</summary>

制約, なし

</details>

## データベースの接続先を設定する

`connectionFactory` プロパティに `ConnectionFactory` (`nablarch.core.db.connection.ConnectionFactory`) 実装クラスを設定してDB接続を取得する。

```xml
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory" />
</component>

<component name="connectionFactory"
    class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
  <!-- プロパティの設定は省略 -->
</component>
```

> **重要**: DB接続オブジェクト取得用ファクトリクラスの詳細は `database-connect` を参照。

<details>
<summary>keywords</summary>

connectionFactory, ConnectionFactory, nablarch.core.db.connection.ConnectionFactory, BasicDbConnectionFactoryForDataSource, DB接続設定, 接続先設定, ファクトリクラス

</details>

## アプリケーションで複数のデータベース接続（トランザクション）を使用する

複数のDB接続が必要な場合、ハンドラキューに本ハンドラを複数設定する。

`connectionName` プロパティでDB接続名を設定する（スレッド内で一意）。省略した場合はデフォルトのDB接続となる。よく使うDB接続をデフォルトとし、他の接続に任意の名前を付けること。

```xml
<!-- デフォルトのデータベース接続 -->
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory" />
</component>

<!-- userAccessLogという名前でDB接続を登録 -->
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="userAccessLogConnectionFactory" />
  <property name="connectionName" value="userAccessLog" />
</component>
```

デフォルトのDB接続を使用する場合:
```java
AppDbConnection connection = DbConnectionContext.getConnection();
```

名前付きDB接続（userAccessLog）を使用する場合（`getConnection(String)` の引数には `connectionName` プロパティに設定した値と一致するDB接続名を指定すること）:
```java
AppDbConnection connection = DbConnectionContext.getConnection("userAccessLog");
```

<details>
<summary>keywords</summary>

connectionName, DbConnectionContext, nablarch.core.db.connection.DbConnectionContext, AppDbConnection, 複数DB接続, データベース接続名, マルチトランザクション, getConnection

</details>
