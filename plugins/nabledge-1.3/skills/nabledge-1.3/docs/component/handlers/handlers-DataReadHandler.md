# データリードハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.DataReadHandler`

実行コンテキスト上のデータリーダを使用し、入力データを1件ずつ読み込み後続ハンドラに委譲するハンドラ。

- データリーダの終端に達した場合は、後続ハンドラを実行せずに `DataReader.NoMoreRecord` を返却する
- 読み込み件数の上限を設定可能

> **注意**: データを読み出す媒体や一回の読み込みで取得するデータの型・内容は、設定されたデータリーダの仕様に依存する。

<details>
<summary>keywords</summary>

DataReadHandler, nablarch.fw.handler.DataReadHandler, データリーダ, 入力データ読み込み, NoMoreRecord, DataReader.NoMoreRecord, データリードハンドラ

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(読み込み回数のカウントアップ)**: `maxCount` が設定されている場合、現在の読み込み回数に1を加える（同期ブロック内）。上限値未設定または0以下の場合はカウントアップしない。
   - **1a. (読み込み回数超過)**: 上限超過時は実行コンテキスト上のデータリーダおよびデータリーダファクトリを除去。次回ループ開始判定で処理停止（現在実行中の処理は継続）。
2. **(データ読み込み)**: データリーダからデータを1件読み込む。読み込みデータはリクエストスコープに設定される（キー名: `nablarch_request-data`）。
   - **2a. (データ終端)**: 戻り値がnullの場合、`DataReader.NoMoreRecord` を返却し後続ハンドラの処理は実行しない。
3. **(実行時IDの採番)**: 読み込みデータに対する [実行時ID](../../about/about-nablarch/about-nablarch-concept.md) を採番しスレッドコンテキストに保存。採番は設定された採番用モジュールで行う。
4. **(後続ハンドラへの処理委譲)**: 読み込んだ入力データを引数として後続ハンドラに処理を委譲し結果を取得。

**[復路処理]**

5. **(正常終了)**: 取得した結果をそのままリターンし終了。

**[例外処理]**

- **4a. (入力データをログ出力)**: 後続ハンドラの処理中に例外が発生した場合、入力データと例外内容をワーニングレベルでログ出力後、再送出する。

<details>
<summary>keywords</summary>

DataReadHandler, ハンドラ処理フロー, maxCount, nablarch_request-data, 実行時ID, DataReader.NoMoreRecord, データ読み込み, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| maxCount | int | | 0（無制限） | データ読み込み件数上限 |
| executionIdAttribute | ThreadContextAttribute | | ExecutionIdAttribute | 実行時ID採番モジュール |

**基本設定**

```xml
<component class="nablarch.fw.handler.DataReadHandler" />
```

**読み込み回数上限を設定する場合**

> **補足**: 読み込み件数の上限値は運用時に変更される可能性があるため、外部パラメータ化しておくことを推奨する。

```xml
<component class="nablarch.fw.handler.DataReadHandler">
  <property name="maxCount" value="${maxCount}" />
</component>
```

**実行時IDの採番体系をカスタマイズする場合**

実行時IDをPJ固有の形式で採番している場合は [./ThreadContextHandler](handlers-ThreadContextHandler.md) に設定したものと同じモジュールをこのハンドラにも設定すること。

```xml
<component
  name="executionIdAttribute"
  class="com.example.nablarch.ext.CustomExecutionIdAttribute"
/>

<component class="nablarch.fw.handler.DataReadHandler">
  <property name="executionIdAttribute" ref="executionIdAttribute" />
</component>
```

<details>
<summary>keywords</summary>

maxCount, executionIdAttribute, ThreadContextAttribute, ExecutionIdAttribute, DataReadHandler, 設定項目, 外部パラメータ化, 実行時ID採番モジュール, ThreadContextHandler

</details>
