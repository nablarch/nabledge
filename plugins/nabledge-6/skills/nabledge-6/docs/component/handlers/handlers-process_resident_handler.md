# プロセス常駐化ハンドラ

## 概要

後続のハンドラキューの内容を一定間隔毎に繰り返し実行するハンドラ。特定のデータソース上の入力データを定期的に監視してバッチ処理を行う、いわゆる常駐起動型のバッチ処理で用いられる。

本ハンドラでは、以下の処理を行う。

- 一定間隔（データの監視間隔）毎に後続ハンドラを呼び出す
- 後続ハンドラで例外発生時に、このハンドラの継続有無などを判断する（詳細は「後続ハンドラで発生した例外の扱い」参照）

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.ProcessResidentHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

## 制約

> **重要**: 本ハンドラは :ref:`retry_handler` よりも後ろに設定すること。実行時例外を捕捉した場合、`RetryableException` でラップして再送出し、プロセスの継続制御を :ref:`retry_handler` に委譲するため。

## データの監視間隔を設定する

`dataWatchInterval` プロパティにミリ秒で設定する。デフォルト値は1000ミリ秒（1秒）。

```xml
<component name="settingsProcessResidentHandler"
    class="nablarch.fw.handler.ProcessResidentHandler">
  <property name="dataWatchInterval" value="5000" />
</component>
```

## プロセス常駐化ハンドラの終了方法

プロセスの正常終了を示す例外が送出された場合、後続ハンドラの呼び出しを止め処理を終了する。

デフォルトの正常終了例外: `ProcessStop` とそのサブクラス（ :ref:`process_stop_handler` が送出）。

正常終了例外を変更する場合は `normalEndExceptions` プロパティに例外クラスリストを設定する。

> **重要**: 例外リストを設定するとデフォルト設定が上書きされるため、 `ProcessStop` の設定を忘れずに行うこと。

```xml
<component name="settingsProcessResidentHandler"
    class="nablarch.fw.handler.ProcessResidentHandler">
  <property name="normalEndExceptions">
    <list>
      <value>nablarch.fw.handler.ProcessStopHandler$ProcessStop</value>
      <value>sample.CustomProcessStop</value>
    </list>
  </property>
</component>
```

## 後続ハンドラで発生した例外の扱い

後続ハンドラで発生した例外の種類に応じた処理内容:

| 例外の種類 | 処理内容 |
|---|---|
| `ServiceUnavailable` | データ監視間隔分待機後に後続ハンドラを再実行 |
| リトライ可能例外（ `RetryUtil#isRetryable()` が真） | 捕捉した例外をそのまま再送出 |
| プロセス異常終了例外（ `abnormalEndExceptions` プロパティで設定、デフォルトは `ProcessAbnormalEnd` とそのサブクラス） | 捕捉した例外をそのまま再送出 |
| プロセス正常終了例外（ :ref:`process_resident_handler-normal_end` 参照） | 後続ハンドラの戻り値をそのまま返し処理終了 |
| 上記以外 | ログ記録後、 `RetryableException` でラップして再送出 |
