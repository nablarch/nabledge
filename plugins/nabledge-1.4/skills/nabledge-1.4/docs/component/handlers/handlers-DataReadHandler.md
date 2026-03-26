# データリードハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.DataReadHandler`

実行コンテキスト上のデータリーダを使用し、業務処理に対する入力データを1件ずつ読み込み、後続ハンドラに処理を委譲する。データリーダの終端に達した場合は、後続ハンドラを実行せずに `DataReader.NoMoreRecord` を返却する。読み込み件数の上限を設定することが可能。

> **注意**: データを読み出す媒体や一回の読み込みで取得するデータの型・内容は、このハンドラに設定されたデータリーダの仕様に依存する。

<details>
<summary>keywords</summary>

DataReadHandler, nablarch.fw.handler.DataReadHandler, DataReader.NoMoreRecord, データリーダ, 入力データ読み込み, 読み込み件数上限

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(読み込み回数のカウントアップ)**: 読み込み回数上限値が設定されている場合、現在の読み込み回数に1を加える（同期ブロック内）。上限値が未設定または0以下の場合はカウントアップしない。
2. **(データ読み込み)**: 実行コンテキスト上のデータリーダからデータを1件読み込む。読み込まれたデータはリクエストスコープにも設定される（キー名: `nablarch_request-data`）。
3. **(実行時IDの採番)**: 読み込まれたデータに対する [実行時ID](../libraries/libraries-01_Log.md) を採番し、スレッドコンテキストに保存する。採番は本ハンドラに設定された採番用モジュールが行う。
4. **(後続ハンドラへの処理委譲)**: 読み込んだ入力データを引数として後続ハンドラに処理を委譲し結果を取得する。

**分岐処理**

- **1a. (読み込み回数超過)**: カウントアップの結果、読み込み回数が上限値を超過した場合、実行コンテキスト上のデータリーダおよびデータリーダファクトリを除去する。次回ループ開始判定で処理が停止する（現在実行中の処理は継続）。
- **2a. (データ終端)**: データリーダの戻り値がnullの場合、`DataReader.NoMoreRecord` を返却し、後続ハンドラの処理は実行しない。

**[復路処理]**

5. **(正常終了)**: 取得した結果をそのままリターンして終了する。

**[例外処理]**

- **4a. (入力データをログ出力)**: 後続ハンドラの処理中に例外が発生した場合、入力データの内容と例外の内容をワーニングレベルでログ出力した後、再送出する。

<details>
<summary>keywords</summary>

DataReadHandler, DataReader.NoMoreRecord, nablarch_request-data, 実行時ID, データ読み込み処理フロー, 読み込み回数上限超過

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

[./ThreadContextHandler](handlers-ThreadContextHandler.md) に設定したものと同じモジュールをこのハンドラにも設定すること。

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

DataReadHandler, maxCount, executionIdAttribute, ThreadContextAttribute, ExecutionIdAttribute, ThreadContextHandler, 読み込み件数上限設定, 実行時ID採番カスタマイズ

</details>
