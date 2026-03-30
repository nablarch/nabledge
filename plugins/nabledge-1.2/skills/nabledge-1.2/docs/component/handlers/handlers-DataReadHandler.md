# データリードハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.DataReadHandler`

データリーダを使用して入力データを1件ずつ読み込み、後続ハンドラに処理を委譲するハンドラ。データリーダの終端に達した場合は後続ハンドラを実行せず、マーカーオブジェクトとして `DataReader.NoMoreRecord` を返却する。読み込み件数の上限設定が可能。

データを読み出す媒体や一回の読み込みで取得するデータの型、その内容については、このハンドラに設定されたデータリーダの仕様に依存する。

<details>
<summary>keywords</summary>

DataReadHandler, nablarch.fw.handler.DataReadHandler, DataReader.NoMoreRecord, データリーダ, 入力データ読み込み, 読み込み件数上限

</details>

## ハンドラ処理フロー

**[往路処理]**
1. 読み込み回数のカウントアップ: 上限値設定時、現在の読み込み回数に1を加える（同期ブロック内）。上限値が未設定または0以下の場合は行わない。
   - 1a. 上限超過時: 実行コンテキスト上のデータリーダおよびデータリーダファクトリを除去し、次回ループ開始判定で処理停止（現在実行中の処理は継続）。
2. データリーダから1件読み込み、リクエストスコープに設定（キー: `nablarch_request-data`）。
   - 2a. データ終端: 戻り値がnullの場合 `DataReader.NoMoreRecord` を返却し、後続ハンドラは実行されない。
3. 読み込んだデータに対する [実行時ID](../../about/about-nablarch/about-nablarch-concept.md) を採番し、スレッドコンテキストに保存。採番は本ハンドラに設定された採番用モジュールによる。
4. 読み込んだ入力データを引数として後続ハンドラに処理委譲。

**[復路処理]**
5. 取得した結果をそのままリターン。

**[例外処理]**
- 4a. 後続ハンドラ処理中に例外発生時、入力データと例外内容をWARNINGレベルでログ出力後、再送出。

<details>
<summary>keywords</summary>

DataReadHandler, nablarch_request-data, 実行時ID, ハンドラ処理フロー, NoMoreRecord, 読み込み回数上限, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| maxCount | int | | 0（無制限） | データ読み込み件数上限 |
| executionIdAttribute | ThreadContextAttribute | | ExecutionIdAttribute | 実行時ID採番モジュール |

**基本設定**:
```xml
<component class="nablarch.fw.handler.DataReadHandler" />
```

**読み込み件数上限設定**（上限値は運用時に変更される可能性があるため外部パラメータ化を推奨）:
```xml
<component class="nablarch.fw.handler.DataReadHandler">
  <property name="maxCount" value="${maxCount}" />
</component>
```

**実行時ID採番体系カスタマイズ**（PJ固有の形式で採番する場合、`ThreadContextHandler` に設定したものと同じモジュールをこのハンドラにも設定すること）:
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

DataReadHandler, maxCount, executionIdAttribute, ThreadContextAttribute, ExecutionIdAttribute, ThreadContextHandler, XML設定, 読み込み件数上限設定

</details>
