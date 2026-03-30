# 開閉局

## 概要

サービスの提供可否状態をチェックおよび設定する（切り替える）機能。

- サービス提供可否状態の**チェック**: 共通ハンドラ (`ServiceAvailabilityCheckHandler`) およびユーティリティ (`ServiceAvailabilityUtil`) を使用する。
- サービス提供可否状態の**設定**: ユーティリティ (`ServiceAvailabilityUtil`) を使用する。
- 共通ハンドラ・ユーティリティは特定の実行制御基盤に依存しない。ハンドラ構成に組み込むだけで、画面オンライン・バッチ両方の実行制御基盤で開閉局を実現できる。

> **注意**: 「サービス提供可否状態の設定」とはON/OFFの切り替えを指す。状態はデータベースのテーブルに格納される。テーブル構造は :ref:`tableDefinition` を参照すること。

<details>
<summary>keywords</summary>

開閉局, ServiceAvailabilityCheckHandler, ServiceAvailabilityUtil, ServiceAvailability, BasicServiceAvailability, サービス提供可否状態, 共通ハンドラ

</details>

## 特徴

リクエスト、各機能（複数のリクエストの集合）、システム全体の単位で、サービス提供可否状態を設定することが可能。

<details>
<summary>keywords</summary>

開閉局, サービス提供可否状態設定, リクエスト単位, 機能単位, システム全体

</details>

## 要求

**実装済み**
- アクション(リクエスト)単位でサービス提供可否状態をチェックできる。
- 開閉局が必要なすべての実行制御基盤でサービス提供可否状態のチェックができる。

> **注意**: サービス提供可否の切り替え方式として2種類ある。本フレームワークは方式②を採用:
> 1. フレームワーク側が日時情報（開局時間・閉局時間・曜日等）をもとに切り替え→機能豊富だがアーキテクチャが複雑・テーブル構造に制約・柔軟性低下
> 2. 運用JOBスケジューラ側が切り替え、フレームワークはフラグのみ管理→シンプルで柔軟
> ①にも対応可能なインタフェースのため、将来①を取り込む際もインタフェース変更不要。

**未実装**
- アクション(リクエスト)単位でのサービス提供可否状態の設定
- 各機能（複数リクエストの集合）単位でのサービス提供可否状態の設定
- システム全体でのサービス提供可否状態の設定
- 特定のイベントをトリガとしたサービス提供可否状態の設定

**未検討**
- 指定時間でのサービス提供可否切り替え
- 画面項目（メニュー・ボタン等）の表示・非表示切り替え（カスタムタグ等の提供）
- サービス提供不可時の個別画面遷移
  > **注意**: 現時点での設計判断では、サービス提供不可の場合に個別画面へ遷移する要件はないと想定している。

**取り下げ**
- 各機能（複数リクエストの集合）単位でのサービス提供可否状態チェック: 柔軟性確保のためリクエスト単位のみ提供。各機能単位の一括設定機能で代替可能。

<details>
<summary>keywords</summary>

開閉局要求, サービス提供可否チェック, JOBスケジューラ, 実装済み機能, 未実装機能, サービス提供可否切り替え方式

</details>

## 構成

**インタフェース**:
- **インタフェース**: `nablarch.common.availability.ServiceAvailability` — リクエストIDをもとにサービス提供可否状態を判定するインタフェース。独自のサービス提供可否状態判定が必要な場合は本インタフェースを実装することで実現可能。

**実装クラス / その他クラス**:
- **クラス**: `nablarch.common.availability.BasicServiceAvailability` — リクエストIDをもとにサービス提供可否を判定。リクエストテーブルを参照し、テーブル名・カラム名は設定ファイルで変更可能。
- **クラス**: `nablarch.common.handler.ServiceAvailabilityCheckHandler` — サービス提供可否状態の判定をするハンドラ。
- **クラス**: `nablarch.common.availability.ServiceAvailabilityUtil` — サービス提供可否状態判定用ユーティリティ。アプリケーションプログラマが業務アクション等の任意のロジックから直接使用可能。

**処理フロー（画面オンライン時）**:
1. `ServiceAvailabilityCheckHandler` がリクエストIDをもとにサービス提供可否状態を判定する。
2. リクエストIDは `ServiceAvailabilityCheckHandler` より前に処理するハンドラが ThreadContext に設定する必要がある（:ref:`ThreadContextHandler` が行う）。
3. サービス提供不可の場合、一律サービス提供不可エラー画面へ遷移する。

**テーブル定義（例）**

テーブル名・カラム名は任意。Javaの型に変換可能なデータベース型を使用すること。

リクエストテーブル（リクエストごとのサービス提供可否状態を格納）:

| 定義 | Javaの型 | 制約 |
|---|---|---|
| リクエストID | java.lang.String | PK |
| リクエスト名 | java.lang.String | |
| サービス提供可否状態 | java.lang.String | |

- 「リクエスト名」カラムは保守用であり、本機能では使用しない。
- 「サービス提供可否状態」カラム: 標準では"1"がサービス提供可能を表す。設定ファイルで変更可能（詳細は :ref:`basicServiceAvailabilityDetail`）。

<details>
<summary>keywords</summary>

ServiceAvailability, BasicServiceAvailability, ServiceAvailabilityCheckHandler, ServiceAvailabilityUtil, ThreadContextHandler, リクエストテーブル, テーブル定義, サービス提供可否判定, ThreadContext

</details>

## 設定の記述

設定はリポジトリ機能を使用する。

**設定例**:

```xml
<!-- 開閉局機能（BasicServiceAvailability） -->
<component name="serviceAvailability" class="nablarch.common.availability.BasicServiceAvailability">
    <property name="tableName" value="REQUEST"/>
    <property name="requestTableRequestIdColumnName" value="REQUEST_ID"/>
    <property name="requestTableServiceAvailableColumnName" value="SERVICE_AVAILABLE"/>
    <property name="requestTableServiceAvailableOkStatus" value="1"/>
    <property name="dbManager" ref="serviceAvailabilityDbManager"/>
</component>

<component name="dbManager" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
    <property name="dbTransactionName" value="serviceAvailability" />
    <property name="transactionFactory" ref="transactionFactory" />
    <property name="connectionFactory" ref="connectionFactory" />
</component>

<component name="serviceAvailabilityCheckHandler" class="nablarch.common.handler.ServiceAvailabilityCheckHandler">
    <property name="serviceAvailability" ref="serviceAvailability"/>
</component>
```

> **重要**: `BasicServiceAvailability` は初期化が必要（`Initializable` インタフェースを実装）。:ref:`repository_initialize` を参考に、以下のように初期化リストに追加すること:

```xml
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="serviceAvailability"/>
        </list>
    </property>
</component>
```

**`nablarch.common.availability.BasicServiceAvailability` プロパティ**:

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| dbManager | ○ | | `nablarch.core.db.transaction.SimpleDbTransactionManager` のインスタンス。DBへのトランザクション制御を行う。 |
| tableName | ○ | | リクエストテーブルのテーブル名。 |
| requestTableRequestIdColumnName | ○ | | リクエストテーブルのリクエストIDカラム名。 |
| requestTableServiceAvailableColumnName | ○ | | リクエストテーブルのサービス提供可否状態カラム名。 |
| requestTableServiceAvailableOkStatus | | "1" | サービス提供可能を表す値。省略時は"1"。 |

**`nablarch.common.handler.ServiceAvailabilityCheckHandler` プロパティ**:

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| serviceAvailability | ○ | | `ServiceAvailability` インタフェースを実装したクラスを設定する。 |

<details>
<summary>keywords</summary>

BasicServiceAvailability, ServiceAvailabilityCheckHandler, SimpleDbTransactionManager, dbManager, tableName, requestTableRequestIdColumnName, requestTableServiceAvailableColumnName, requestTableServiceAvailableOkStatus, serviceAvailability, 初期化, BasicApplicationInitializer, Initializable

</details>
