# サービス提供可否チェック

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/service_availability.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/availability/BasicServiceAvailability.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/availability/ServiceAvailabilityUtil.html)

## 機能概要

> **重要**: 本機能はアプリケーション要件が合致する場合のみ使用すること。DBを使用してリクエスト単位でサービス提供可否を管理するため、ウェブの登録機能（初期表示/確認/戻る/登録など複数リクエスト構成）では非常に細かいデータ設計が必要となり、開発時の生産性低下やリリース後の運用負荷が高まる可能性がある。

この機能を使うことで以下が実現できる:

- **ウェブ**: 一部機能へのアクセスを遮断し、503エラーを返す。
- **常駐バッチ**: 空回り（処理せずに待機する状態）を行う。

:ref:`ServiceAvailabilityCheckHandler` をハンドラキューに設定することで、ウェブ・常駐バッチの両方でリクエスト単位のサービス提供可否チェックが可能。処理方式（ウェブ/常駐バッチ）に非依存。

<details>
<summary>keywords</summary>

ServiceAvailabilityCheckHandler, サービス提供可否チェック, リクエスト単位, ウェブ, 常駐バッチ, 503, 空回り

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-auth</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-auth-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-common-auth, nablarch-common-auth-jdbc, モジュール, 依存関係

</details>

## 使用方法

DBテーブルレイアウト:

| カラム | 型 | 説明 |
|---|---|---|
| リクエストID (PK) | 文字列 | リクエストを識別する値 |
| サービス提供可否状態 | 文字列 | 可の場合は "1"（設定で値を変更可） |

**クラス**: `nablarch.common.availability.BasicServiceAvailability`

コンポーネント名は `serviceAvailability` で定義し、初期化対象リストへの追加が必要。

```xml
<component name="serviceAvailability" class="nablarch.common.availability.BasicServiceAvailability">
  <property name="tableName" value="REQUEST"/>
  <property name="requestTableRequestIdColumnName" value="REQUEST_ID"/>
  <property name="requestTableServiceAvailableColumnName" value="SERVICE_AVAILABLE"/>
  <property name="requestTableServiceAvailableOkStatus" value="1"/>
  <property name="dbManager" ref="serviceAvailabilityDbManager"/>
</component>

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="serviceAvailability" />
    </list>
  </property>
</component>
```

サービス提供可否チェックには `ServiceAvailabilityUtil` を使用する。

サービス提供可否に応じたボタン・リンクの非表示（非活性）制御は :ref:`tag-submit_display_control` を参照。

<details>
<summary>keywords</summary>

BasicServiceAvailability, BasicApplicationInitializer, ServiceAvailabilityUtil, tableName, requestTableRequestIdColumnName, requestTableServiceAvailableColumnName, requestTableServiceAvailableOkStatus, dbManager, コンポーネント設定, 初期化, 画面表示制御

</details>

## 拡張例

なし。

<details>
<summary>keywords</summary>

拡張例, なし

</details>
