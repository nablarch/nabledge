# データリードハンドラ

## 概要

:ref:`データリーダ<nablarch_batch-data_reader>` を使用して、入力データの順次読み込みを行うハンドラ。

実行コンテキスト上の :ref:`データリーダ<nablarch_batch-data_reader>` から入力データを1件ずつ読み込み、それを引数として後続ハンドラに処理を委譲する。データ終端に達した場合、後続ハンドラを実行せず `NoMoreRecord` を返却する。

**本ハンドラの処理**:
1. データリーダを使用した入力データの読み込み
2. :ref:`実行時ID<log-execution_id>` の採番

## ハンドラクラス名

**クラス**: `nablarch.fw.handler.DataReadHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

## 制約

本ハンドラより手前のハンドラにて、`ExecutionContext` に `DataReader` を設定する必要がある。`DataReader` が未設定の場合、処理対象データ無しとして `NoMoreRecord` を返却し処理を終了する。

## 最大処理件数の設定

最大処理件数を設定可能。最大件数分の処理後、`NoMoreRecord` を返却して終了する。

用途: 大量データのバッチを数日に分けて処理（例: 100万件を日次10万件ずつ10日間で処理）

**設定例**:
```xml
<component class="nablarch.fw.handler.DataReadHandler">
  <!-- 処理する件数は、最大1万レコード -->
  <property name="maxCount" value="10000" />
</component>
```
