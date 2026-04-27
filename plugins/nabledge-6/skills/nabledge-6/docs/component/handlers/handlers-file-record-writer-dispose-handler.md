# 出力ファイル開放ハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* ハンドラキューへの設定について

業務アクションやハンドラで開いた出力ファイルを閉じる(リソースの解放)ハンドラ。

> **Important:**
> このハンドラで解放対象となるのは、 FileRecordWriterHolder を使用して開いた出力ファイルとなる。
> それ以外のAPI(例えば、 java.io パッケージ)を使って開いたリソースについては、個別にクローズ処理を行うこと。

処理の流れは以下のとおり。

![flow.png](../../../knowledge/assets/handlers-file-record-writer-dispose-handler/flow.png)

## ハンドラクラス名

* nablarch.common.io.FileRecordWriterDisposeHandler

## モジュール一覧

```xml
<!-- 汎用データフォーマット -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-dataformat</artifactId>
</dependency>
```

## 制約

なし。

## ハンドラキューへの設定について

このハンドラは、ハンドラキュー上に設定するだけで、後続のハンドラや業務アクションで開いた出力ファイルを自動的にクローズする。
このため、ファイルを出力する全てのハンドラより手前に設定する必要がある。
