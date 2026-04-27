# IBM MQアダプタ

**目次**

* モジュール一覧
* 本アダプタを使用するための設定
* 分散トランザクションを使用する

[NablarchのMOMメッセージング機能](../../processing-pattern/mom-messaging/mom-messaging-mom.md#mom-messaging) で [IBM MQ(外部サイト、英語)](https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mq-about) を使用するためのアダプタを提供する。

IBM MQの仕様及び構築手順などは、IBM社のオフィシャルサイト及びマニュアルを参照すること。

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-wmq-adaptor</artifactId>
</dependency>
```

> **Important:**
> テストでは、IBM MQ 9.3のライブラリを使用している。
> バージョンを変更する際には、プロジェクト側でテストを行い問題ないことを確認すること。

## 本アダプタを使用するための設定

本アダプタは、以下の手順にてコンポーネントを定義することで有効になる。

1. `nablarch.integration.messaging.wmq.provider.WmqMessagingProvider` をコンポーネント設定ファイルに定義を追加する。
2. `1` で設定した、 `WmqMessagingProvider` を [メッセージングコンテキスト管理ハンドラ](../../component/handlers/handlers-messaging-context-handler.md#messaging-context-handler) に設定する。

以下に設定例を示す。

```xml
<!-- IBM MQアダプタ用のプロバイダ実装 -->
<component name="wmqMessagingProvider"
    class="nablarch.integration.messaging.wmq.provider.WmqMessagingProvider">
  <!-- 設定値はJavadocを参照 -->
</component>

<!--
メッセージコンテキスト管理ハンドラ

上で定義したWmqMessagingProviderを、messagingProviderプロパティに設定する。
-->
<component class="nablarch.fw.messaging.handler.MessagingContextHandler">
  <property name="messagingProvider" ref="wmqMessagingProvider" />
</component>
```

## 分散トランザクションを使用する

本アダプタには、IBM MQをトランザクションマネージャとして、分散トランザクションを実現する機能が含まれている。

この機能は、外部システムとメッセージの送受信を行う際に、取り込み漏れや2重取り込みを防止する目的で使用する。

分散トランザクションを使用するための手順を以下に示す。

1. 分散トランザクションに対応したデータソース( javax.sql.XADataSource を実装したクラス)を定義する。
2. 分散トランザクションに対応したデータベース接続を生成するファクトリクラスを定義する。 
  
  (`nablarch.integration.messaging.wmq.xa.WmqXADbConnectionFactoryForXADataSource` を定義する。)
3. `2` で定義したファクトリクラスを、 [データベース接続管理ハンドラ](../../component/handlers/handlers-database-connection-management-handler.md#database-connection-management-handler) に設定する。
4. 分散トランザクション用のトランザクションのオブジェクトを生成するファクトリクラスを定義する。 
  
  (`nablarch.integration.messaging.wmq.xa.WmqXATransactionFactory` を定義する。)
5. `4` で定義したファクトリクラスを [トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#transaction-management-handler) に設定する。

以下に設定例を示す。

```xml
<!--
XA用のデータソースの設定
使用するデータベース製品のJDBC実装内のXA用のデータソースを設定する。

この例では、Oracleデータベース用の設定となる。
-->
<component name="xaDataSource" class="oracle.jdbc.xa.client.OracleXADataSource">
  <!-- プロパティへの設定は省略 -->
</component>

<!-- XA用のデータベース接続を生成するクラスの設定-->
<component name="xaConnectionFactory"
    class="nablarch.integration.messaging.wmq.xa.WmqXADbConnectionFactoryForXADataSource">

  <!-- xaDataSourceプロパティにXA用のデータソースを設定する。-->
  <property name="xaDataSource" ref="xaDataSource" />

  <!-- 上記以外のプロパティは省略 -->
</component>

<!-- 分散トランザクション用のDB接続ハンドラの設定 -->
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <!-- DB接続ファクトリには、上記で設定したXA用のデータベース接続を生成するクラスを設定する。 -->
  <property name="connectionFactory" ref="xaConnectionFactory" />

  <!-- 上記以外のプロパティは省略 -->
</component>

<!-- XA用のトランザクション制御オブジェクトを生成するクラスの設定 -->
<component name="xaTransactionFactory"
    class="nablarch.integration.messaging.wmq.xa.WmqXATransactionFactory" />

<!-- 分散トランザクション用のトランザクションハンドラの設定 -->
<component class="nablarch.common.handler.TransactionManagementHandler">
  <!-- トランザクションファクトリには、上記で設定した
  XA用のトランザクション制御オブジェクトを生成するクラスを設定する。
  -->
  <property name="transactionFactory" ref="xaTransactionFactory" />

  <!-- 上記以外のプロパティは省略 -->
</component>
```

> **Important:**
> 分散トランザクションを使用するためには、IBM MQに対するXA リソース・マネージャーの設定や、データベースに対する権限付与が必要となる。
> 詳細な設定方法や必要な権限などは、使用する製品のマニュアルを参照すること。
