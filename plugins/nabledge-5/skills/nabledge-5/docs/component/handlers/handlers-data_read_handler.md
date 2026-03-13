# データリードハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/data_read_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.NoMoreRecord.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DataReadHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.DataReadHandler`

[データリーダ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md) を使用して入力データを1件ずつ読み込み、後続ハンドラに処理を委譲するハンドラ。`DataReader` の終端到達時は後続ハンドラを実行せず `NoMoreRecord` を返却する。

処理内容:
1. データリーダを使用して入力データの読み込み
2. [実行時ID](../libraries/libraries-log.md) の採番

<details>
<summary>keywords</summary>

DataReadHandler, nablarch.fw.handler.DataReadHandler, NoMoreRecord, データリードハンドラ, 入力データ読み込み, 実行時ID採番

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-standalone, com.nablarch.framework, モジュール依存関係

</details>

## 制約

本ハンドラより手前で `ExecutionContext` に `DataReader` を設定する必要がある。未設定の場合、処理対象データ無しとして `NoMoreRecord` を返却し処理を終了する。

<details>
<summary>keywords</summary>

ExecutionContext, DataReader, nablarch.fw.ExecutionContext, nablarch.fw.DataReader, NoMoreRecord, DataReader設定制約, 処理対象データなし

</details>

## 最大処理件数の設定

`maxCount` プロパティで最大処理件数を設定できる。最大件数到達後は `NoMoreRecord` を返却する。大量データを数日に分けて処理する場合に使用（例: 100万件を日次10万件ずつ10日間で処理）。

```xml
<component class="nablarch.fw.handler.DataReadHandler">
  <!-- 処理する件数は、最大1万レコード -->
  <property name="maxCount" value="10000" />
</component>
```

<details>
<summary>keywords</summary>

maxCount, NoMoreRecord, 最大処理件数, バッチ分割処理, DataReadHandler

</details>
