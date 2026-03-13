# サービス提供可否チェック

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/service_availability.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/availability/BasicServiceAvailability.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/availability/ServiceAvailabilityUtil.html)

## 機能概要

アプリケーションが提供する機能に対してサービス提供可否をチェックする機能。この機能を使うことで以下が実現できる。

- **ウェブ**: 一部機能へのアクセスを遮断し、503エラーを返す
- **常駐バッチ**: 空回り（処理せずに待機する状態）を行う

:ref:`ServiceAvailabilityCheckHandler` をハンドラキューに設定することで、ウェブ・常駐バッチでリクエスト単位のサービス提供可否チェックが可能。この機能は処理方式（ウェブ・常駐バッチ）に依存しない。

> **重要**: 本機能はアプリケーションの要件が合致する場合に限り使用すること。DBでサービス提供可否の状態をリクエスト単位で管理するため、非常に細かいデータ設計が必要となり、開発時の生産性低下やリリース後の運用負荷が高まる可能性がある。

<details>
<summary>keywords</summary>

ServiceAvailabilityCheckHandler, サービス提供可否チェック, リクエスト単位チェック, ウェブ・常駐バッチ対応, サービス遮断, 503エラー, 空回り

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

nablarch-common-auth, nablarch-common-auth-jdbc, サービス提供可否モジュール, Maven依存関係

</details>

## 使用方法

**サービス提供可否チェックを使うための設定**

テーブルレイアウト:

| カラム | 型 | 説明 |
|---|---|---|
| リクエストID (PK) | 文字列 | リクエストを識別するための値 |
| サービス提供可否状態 | 文字列 | 可の場合は"1"。設定で値を変更可能 |

コンポーネント名は **serviceAvailability** と指定する。

**クラス**: `BasicServiceAvailability`

```xml
<component name="serviceAvailability" class="nablarch.common.availability.BasicServiceAvailability">
  <property name="tableName" value="REQUEST"/>
  <property name="requestTableRequestIdColumnName" value="REQUEST_ID"/>
  <property name="requestTableServiceAvailableColumnName" value="SERVICE_AVAILABLE"/>
  <property name="requestTableServiceAvailableOkStatus" value="1"/>
  <property name="dbManager" ref="serviceAvailabilityDbManager"/>
</component>
```

**サービス提供可否をチェックする**

**クラス**: `ServiceAvailabilityUtil`

**サービス提供可否に応じて画面表示を制御する**

サービス提供可否に応じてボタンやリンクの非表示（非活性）を制御する場合はカスタムタグを使用する。:ref:`tag-submit_display_control` を参照。

<details>
<summary>keywords</summary>

BasicServiceAvailability, ServiceAvailabilityUtil, serviceAvailability, tableName, requestTableRequestIdColumnName, requestTableServiceAvailableColumnName, requestTableServiceAvailableOkStatus, dbManager, tag-submit_display_control, テーブル設定, コンポーネント設定, 画面表示制御, カスタムタグ

</details>

## 拡張例

なし。

<details>
<summary>keywords</summary>

拡張例なし, サービス提供可否拡張

</details>
