# IBM MQアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/webspheremq_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/javax/sql/XADataSource.html)

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-wmq-adaptor</artifactId>
</dependency>
```

> **重要**: テストではIBM MQ 9.3のライブラリを使用している。バージョンを変更する際には、プロジェクト側でテストを行い問題ないことを確認すること。

<details>
<summary>keywords</summary>

nablarch-wmq-adaptor, WmqMessagingProvider, IBM MQアダプタ, モジュール設定, Maven依存関係, IBM MQ 9.3

</details>

## 本アダプタを使用するための設定

[messaging_context_handler](../handlers/handlers-messaging_context_handler.md) にIBM MQを使用するためのコンポーネント設定手順:

1. `nablarch.integration.messaging.wmq.provider.WmqMessagingProvider` をコンポーネント設定ファイルに定義する。
2. `WmqMessagingProvider` を [messaging_context_handler](../handlers/handlers-messaging_context_handler.md) の `messagingProvider` プロパティに設定する。

```xml
<component name="wmqMessagingProvider"
    class="nablarch.integration.messaging.wmq.provider.WmqMessagingProvider">
  <!-- 設定値はJavadocを参照 -->
</component>

<component class="nablarch.fw.messaging.handler.MessagingContextHandler">
  <property name="messagingProvider" ref="wmqMessagingProvider" />
</component>
```

<details>
<summary>keywords</summary>

WmqMessagingProvider, MessagingContextHandler, nablarch.integration.messaging.wmq.provider.WmqMessagingProvider, nablarch.fw.messaging.handler.MessagingContextHandler, IBM MQアダプタ設定, MOMメッセージング, コンポーネント定義

</details>

## 分散トランザクションを使用する

外部システムとのメッセージ送受信における取り込み漏れや2重取り込みを防止する目的で使用する。

分散トランザクション設定手順:

1. `XADataSource` を実装したXA対応データソースを定義する。
2. `nablarch.integration.messaging.wmq.xa.WmqXADbConnectionFactoryForXADataSource` を定義する。
3. `WmqXADbConnectionFactoryForXADataSource` を [database_connection_management_handler](../handlers/handlers-database_connection_management_handler.md) に設定する。
4. `nablarch.integration.messaging.wmq.xa.WmqXATransactionFactory` を定義する。
5. `WmqXATransactionFactory` を [transaction_management_handler](../handlers/handlers-transaction_management_handler.md) に設定する。

```xml
<!-- XA用データソース（例: Oracle） -->
<component name="xaDataSource" class="oracle.jdbc.xa.client.OracleXADataSource" />

<component name="xaConnectionFactory"
    class="nablarch.integration.messaging.wmq.xa.WmqXADbConnectionFactoryForXADataSource">
  <property name="xaDataSource" ref="xaDataSource" />
</component>

<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="xaConnectionFactory" />
</component>

<component name="xaTransactionFactory"
    class="nablarch.integration.messaging.wmq.xa.WmqXATransactionFactory" />

<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="xaTransactionFactory" />
</component>
```

> **重要**: 分散トランザクションを使用するためには、IBM MQに対するXAリソース・マネージャーの設定や、データベースに対する権限付与が必要となる。詳細は使用する製品のマニュアルを参照すること。

<details>
<summary>keywords</summary>

WmqXADbConnectionFactoryForXADataSource, WmqXATransactionFactory, javax.sql.XADataSource, DbConnectionManagementHandler, TransactionManagementHandler, 分散トランザクション, XAトランザクション, 2重取り込み防止, 取り込み漏れ防止

</details>
