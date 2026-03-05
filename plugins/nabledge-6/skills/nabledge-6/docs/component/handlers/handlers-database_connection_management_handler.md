# データベース接続管理ハンドラ

## 概要

後続のハンドラ及びライブラリで使用するためのデータベース接続を、スレッド上で管理するハンドラ。

データベースアクセスの詳細は、:ref:`database`を参照。

## 重要な要件

> **重要**: このハンドラを使用する場合は、:ref:`transaction_management_handler`をセットで設定すること。
>
> トランザクション制御ハンドラが設定されていない場合、トランザクション制御が実施されないため後続で行ったデータベースへの変更は全て破棄される。

## 処理の流れ

本ハンドラでは、以下の処理を行う:

- **データベース接続の取得**
- **データベース接続の解放**

処理の流れの詳細は、公式ドキュメントの処理フロー図（DbConnectionManagementHandler_flow.png）を参照。

## ハンドラクラス名

**クラス名**: `nablarch.common.handler.DbConnectionManagementHandler`

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

## 制約

なし

## データベースの接続先を設定する

`connectionFactory`プロパティに`ConnectionFactory`実装クラスを設定。

**設定例**:
```xml
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory" />
</component>

<component name="connectionFactory"
    class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
  <!-- プロパティの設定は省略 -->
</component>
```

> **重要**: データベース接続オブジェクトを取得するためのファクトリクラスの詳細は、:ref:`database-connect`を参照。

## アプリケーションで複数のデータベース接続（トランザクション）を使用する

複数のデータベース接続を使用する場合、このハンドラをハンドラキュー上に複数設定する。

`connectionName`プロパティでデータベース接続名を指定（省略時はデフォルト接続）。データベース接続名はスレッド内で一意とする必要がある。最もよく使う接続をデフォルトとし、それ以外に任意の名前をつけることを推奨。

**設定例**:
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

**デフォルト接続の使用**:

引数なしで`DbConnection#getConnection`を呼び出し。

```java
AppDbConnection connection = DbConnectionContext.getConnection();
```

**名前付き接続の使用**:

`DbConnection#getConnection(String)`に接続名を指定。接続名は`connectionName`プロパティの値と一致させる。

```java
AppDbConnection connection = DbConnectionContext.getConnection("userAccessLog");
```
