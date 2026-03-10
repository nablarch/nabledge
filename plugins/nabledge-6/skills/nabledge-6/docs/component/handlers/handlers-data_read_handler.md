# データリードハンドラ

## 概要

実行コンテキスト上の `DataReader` を使用し、業務処理に対する入力データを1件ずつ読み込み、それを引数として後続ハンドラに処理を委譲する。`DataReader` の終端に達した場合は、**後続のハンドラを実行せずに**、データの終端に達したことを示す `NoMoreRecord` を返却する。

本ハンドラでは以下の処理を行う。

- データリーダを使用して入力データの読み込み
- 実行時IDの採番

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.DataReadHandler`

データリーダを使用して入力データの順次読み込みを行うスタンドアロンバッチ向けハンドラ。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

## 制約

本ハンドラより手前のハンドラにて、`ExecutionContext` に `DataReader` を設定する必要がある。本ハンドラ呼び出し時に `DataReader` が未設定の場合、処理対象データ無しとして `NoMoreRecord` を返却して処理を終了する。

## 最大処理件数の設定

`maxCount` プロパティで最大処理件数を設定できる。設定件数分のデータを処理し終わると `NoMoreRecord` を返却する。大量データを複数日に分割処理するバッチなどに使用する（例: 100万件のバッチを日次10万件ずつ10日で処理）。

```xml
<component class="nablarch.fw.handler.DataReadHandler">
  <!-- 処理する件数は、最大1万レコード -->
  <property name="maxCount" value="10000" />
</component>
```
