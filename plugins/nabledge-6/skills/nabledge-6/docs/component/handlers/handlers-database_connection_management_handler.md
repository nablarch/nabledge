# データベース接続管理ハンドラ

## ハンドラクラス名

後続ハンドラおよびライブラリで使用するDBへの接続をスレッド上で管理するハンドラ。

> **重要**: このハンドラを使用する場合は `:ref:transaction_management_handler` をセットで設定すること。トランザクション制御ハンドラが未設定の場合、トランザクション制御が行われず後続のDB変更が全て破棄される。

処理フロー:
1. データベース接続の取得
2. データベース接続の解放

**クラス名**: `nablarch.common.handler.DbConnectionManagementHandler`

**制約**: なし。

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

## データベースの接続先を設定する

`connectionFactory` プロパティ（`DbConnectionManagementHandler.setConnectionFactory(ConnectionFactory)`）に `ConnectionFactory` 実装クラスを設定してDBに接続する。

```xml
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory" />
</component>

<component name="connectionFactory"
    class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
  <!-- プロパティの設定は省略 -->
</component>
```

> **注意**: ファクトリクラスの詳細は `:ref:database-connect` を参照。

## アプリケーションで複数のデータベース接続（トランザクション）を使用する

複数のDB接続が必要な場合、このハンドラをハンドラキュー上に複数設定する。各接続は `connectionName` プロパティ（`DbConnectionManagementHandler.setConnectionName(String)`）で命名管理する（スレッド内で一意）。`connectionName` 省略時はデフォルト接続となる。最もよく使う接続をデフォルトにし、それ以外に名前を付けると良い。

```xml
<!-- デフォルトのデータベース接続 -->
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory" />
</component>

<!-- userAccessLogという名前でデータベース接続を登録 -->
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="userAccessLogConnectionFactory" />
  <property name="connectionName" value="userAccessLog" />
</component>
```

デフォルト接続を使用（引数なし）:
```java
AppDbConnection connection = DbConnectionContext.getConnection();
```

`userAccessLog` 接続を使用（引数にデータベース接続名を指定）:
```java
AppDbConnection connection = DbConnectionContext.getConnection("userAccessLog");
```

> **注意**: `DbConnectionContext.getConnection(String)` に渡す接続名は、`connectionName` プロパティに設定した値と一致させる必要がある。
