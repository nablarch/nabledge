# IBM MQアダプタ

**公式ドキュメント**: [IBM MQアダプタ](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/webspheremq_adaptor.html)

## モジュール一覧

NablarchのMOMメッセージング機能でIBM MQを使用するためのアダプタを提供する。

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-wmq-adaptor</artifactId>
</dependency>
```

> **重要**: テストではIBM MQ 9.3ライブラリを使用。バージョン変更時はプロジェクト側でテストを実施すること。

<details>
<summary>keywords</summary>

nablarch-wmq-adaptor, com.nablarch.integration, IBM MQアダプタ, Maven依存設定, IBM MQ 9.3, MOMメッセージング機能, mom_messaging, IBM MQ

</details>

## 本アダプタを使用するための設定

本アダプタを有効にする手順:

1. `nablarch.integration.messaging.wmq.provider.WmqMessagingProvider`をコンポーネント設定ファイルに定義する。
2. 手順1で設定した`WmqMessagingProvider`を[messaging_context_handler](../handlers/handlers-messaging_context_handler.md)に設定する。
3. `WmqMessagingProvider`は初期化が必要なため、初期化対象のリストに設定する。

```xml
<component name="wmqMessagingProvider"
    class="nablarch.integration.messaging.wmq.provider.WmqMessagingProvider">
  <!-- 設定値はJavadocを参照 -->
</component>

<component class="nablarch.fw.messaging.handler.MessagingContextHandler">
  <property name="messagingProvider" ref="wmqMessagingProvider" />
</component>

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="wmqMessagingProvider" />
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

WmqMessagingProvider, MessagingContextHandler, BasicApplicationInitializer, nablarch.integration.messaging.wmq.provider.WmqMessagingProvider, nablarch.fw.messaging.handler.MessagingContextHandler, nablarch.core.repository.initialization.BasicApplicationInitializer, IBM MQ設定, メッセージングプロバイダ設定, コンポーネント初期化

</details>

## 分散トランザクションを使用する

IBM MQをトランザクションマネージャとして分散トランザクションを実現する機能。外部システムとのメッセージ送受信での取り込み漏れや2重取り込みを防止する目的で使用する。

設定手順:

1. 分散トランザクション対応データソース（`javax.sql.XADataSource`を実装したクラス）を定義する。
2. `nablarch.integration.messaging.wmq.xa.WmqXADbConnectionFactoryForXADataSource`を定義する。
3. 手順2のファクトリクラスを[database_connection_management_handler](../handlers/handlers-database_connection_management_handler.md)に設定する。
4. `nablarch.integration.messaging.wmq.xa.WmqXATransactionFactory`を定義する。
5. 手順4のファクトリクラスを[transaction_management_handler](../handlers/handlers-transaction_management_handler.md)に設定する。

```xml
<component name="xaDataSource" class="oracle.jdbc.xa.client.OracleXADataSource">
  <!-- プロパティへの設定は省略 -->
</component>

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

> **重要**: 分散トランザクションを使用するにはIBM MQに対するXAリソース・マネージャーの設定と、データベースへの権限付与が必要。詳細は使用製品のマニュアルを参照すること。

<details>
<summary>keywords</summary>

WmqXADbConnectionFactoryForXADataSource, WmqXATransactionFactory, XADataSource, DbConnectionManagementHandler, TransactionManagementHandler, OracleXADataSource, nablarch.integration.messaging.wmq.xa.WmqXADbConnectionFactoryForXADataSource, nablarch.integration.messaging.wmq.xa.WmqXATransactionFactory, nablarch.common.handler.DbConnectionManagementHandler, nablarch.common.handler.TransactionManagementHandler, oracle.jdbc.xa.client.OracleXADataSource, 分散トランザクション, 取り込み漏れ防止, 2重取り込み防止, XAリソース・マネージャー

</details>
