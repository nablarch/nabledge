## データリードハンドラ

**クラス名:** `nablarch.fw.handler.DataReadHandler`

-----

-----

### 概要

データリーダを使用して、入力データの順次読み込みを行なうハンドラ。

このハンドラは、実行コンテキスト上のデータリーダを使用し、
業務処理に対する入力データを1件ずつ読み込み、それを引数として後続ハンドラに処理を委譲する。
データリーダの終端に達した場合は、後続のハンドラを実行せずに、マーカーオブジェクトとして
[DataReader.NoMoreRecord](../../javadoc/nablarch/fw/DataReader.NoMoreRecord.html) を返却する。

また、読み込み件数の上限を設定することが可能である。

> **Note:**
> データを読み出す媒体や一回の読み込みで取得するデータの型、その内容
> については、このハンドラに設定されたデータリーダの仕様に依存する。

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| データリードハンドラ | nablarch.fw.handler.DataReadHandler | Object | Result | 業務アクションハンドラが決定したデータリーダを使用してレコードを1件読み込み、後続ハンドラの引数として渡す。また実行時IDを採番する。 | - | 読み込んだレコードをログ出力した後、元例外を再送出する。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (読み込み回数のカウントアップ)**

本ハンドラに読み込み回数上限値が設定されている場合は、現在の読み込み回数に1を加える。
(カウントアップは同期ブロック内で行なう。)
上限値が未設定、もしくは0以下の値が設定されている場合、このカウントアップは行なわない。

**1a. (読み込み回数超過)**

カウントアップの結果、現在の読み込み回数が上限値を超過した場合は、実行コンテキスト上の
データリーダおよびデータリーダファクトリを除去する。
これにより、次回のループ開始判定のところで処理が停止する。
(現在実行中の処理についてはそのまま継続する。)

**2. (データ読み込み)**

実行コンテキスト上のデータリーダから、データを1件読み込む。
読み込まれたデータはリクエストスコープにも設定される。 (キー名 **"nablarch_request-data"** )

**2a. (データ終端)**

データリーダの戻り値がnullであった場合、データリーダの終端に達したと判断し
[DataReader.NoMoreRecord](../../javadoc/nablarch/fw/DataReader.NoMoreRecord.html) を返却する。
この際、後続ハンドラの処理は実行されない。

**3. (実行時IDの採番)**

**2.** で読み込まれたデータに対する [実行時ID](../../component/libraries/libraries-01-Log.md#execution-id) を採番し
スレッドコンテキストに保存する。
実行時IDの採番は、本ハンドラに設定された採番用モジュールによって行う。

**4. (後続ハンドラへの処理委譲)**

**2.** で読み込んだ入力データを引数として、後続ハンドラに処理を委譲しその結果を取得する。

**[復路処理]**

**5. (正常終了)**

**4.** で取得した結果をそのままリターンし終了する。

**[例外処理]**

**4a. (入力データをログ出力)**

後続ハンドラの処理中に例外が発生した場合は、入力データの内容と
例外の内容をワーニングレベルでログ出力した後、再送出する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| データ読み込み件数上限 | maxCount | int | 任意指定(デフォルト = 0:無制限) |
| 実行時ID採番モジュール | executionIdAttribute | ThreadContextAttribute | 任意指定(デフォルト = ExecutionIdAttribute) |

**基本設定**

```xml
<component class="nablarch.fw.handler.DataReadHandler" />
```

**読み込み回数上限を設定する場合**

読み込み件数の上限値は運用時に変更される可能性があるため、外部パラメータ化しておくことを推奨する。

```xml
<!-- データリードハンドラ -->
<component class="nablarch.fw.handler.DataReadHandler">
  <property name="maxCount" value="${maxCount}" />
</component>
```

**実行時IDの採番体系をカスタマイズする場合**

実行時IDをPJ固有の形式で採番している場合は [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) に設定したものと同じモジュールをこのハンドラにも設定すること。

```xml
<!-- 実行時ID採番モジュール -->
<component
  name="executionIdAttribute"
  class="com.example.nablarch.ext.CustomExecutionIdAttribute"
/>

<!-- データリードハンドラ -->
<component class="nablarch.fw.handler.DataReadHandler">
  <property name="executionIdAttribute" ref="executionIdAttribute" />
</component>
```
