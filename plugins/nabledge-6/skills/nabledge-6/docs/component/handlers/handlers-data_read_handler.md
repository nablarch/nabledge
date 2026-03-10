# データリードハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/data_read_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DataReadHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.NoMoreRecord.html)

## 概要

実行コンテキスト上の `DataReader` を使用し、業務処理に対する入力データを1件ずつ読み込み、それを引数として後続ハンドラに処理を委譲する。`DataReader` の終端に達した場合は、**後続のハンドラを実行せずに**、データの終端に達したことを示す `NoMoreRecord` を返却する。

本ハンドラでは以下の処理を行う。

- データリーダを使用して入力データの読み込み
- 実行時IDの採番

<details>
<summary>keywords</summary>

データリードハンドラ, DataReadHandler, DataReader, NoMoreRecord, 入力データ読み込み, 実行時ID, 後続ハンドラ, データ終端

</details>

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.DataReadHandler`

データリーダを使用して入力データの順次読み込みを行うスタンドアロンバッチ向けハンドラ。

<details>
<summary>keywords</summary>

DataReadHandler, nablarch.fw.handler.DataReadHandler, データリードハンドラ, ハンドラクラス

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

nablarch-fw-standalone, com.nablarch.framework, モジュール依存関係, スタンドアロンバッチ

</details>

## 制約

本ハンドラより手前のハンドラにて、`ExecutionContext` に `DataReader` を設定する必要がある。本ハンドラ呼び出し時に `DataReader` が未設定の場合、処理対象データ無しとして `NoMoreRecord` を返却して処理を終了する。

<details>
<summary>keywords</summary>

DataReader, ExecutionContext, NoMoreRecord, nablarch.fw.DataReader, nablarch.fw.ExecutionContext, DataReader設定制約, 処理終了条件, NoMoreRecord返却

</details>

## 最大処理件数の設定

`maxCount` プロパティで最大処理件数を設定できる。設定件数分のデータを処理し終わると `NoMoreRecord` を返却する。大量データを複数日に分割処理するバッチなどに使用する（例: 100万件のバッチを日次10万件ずつ10日で処理）。

```xml
<component class="nablarch.fw.handler.DataReadHandler">
  <!-- 処理する件数は、最大1万レコード -->
  <property name="maxCount" value="10000" />
</component>
```

<details>
<summary>keywords</summary>

maxCount, DataReadHandler, NoMoreRecord, 最大処理件数, バッチ分割処理, 件数制限, nablarch.fw.handler.DataReadHandler

</details>
