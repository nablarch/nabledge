## プロセス多重起動防止ハンドラ

**クラス名:** `nablarch.fw.handler.DuplicateProcessCheckHandler`

-----

-----

### 概要

このハンドラでは、DB上のテーブル(プロセス管理テーブル)を参照し、
同一のリクエストIDを持ったプロセスが実行されていないことを確認する。
もし、そのようなプロセスが存在していれば、起動処理をエラー終了させる。

これにより、運用時の手違いなどによって同一のバッチが複数起動してしまう事態を防止することができる。

**プロセス管理テーブルの構造**

各プロセスの実行状態は、データベース上の **プロセス管理テーブル** 上に格納する。
このハンドラでは **プロセス管理テーブル** 内の以下のカラムを使用する。

| 論理名 | データ型 | 備考 |
|---|---|---|
| リクエストID | VARCHAR PK | プロセスを特定するためのID |
| アクティブフラグ | CHAR(1) | "0": 未実行、"1": 実行中 |

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| スレッドコンテキスト変数設定ハンドラ(メインスレッド) | nablarch.common.handler.threadcontext.ThreadContextHandler_main | Object | Object | 起動引数の内容からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。 | - | - |
| プロセス多重起動防止ハンドラ | nablarch.fw.handler.DuplicateProcessCheckHandler | Object | Object | スレッドコンテキスト上のリクエストIDを用いて、リクエスト管理テーブル上の一致するレコードの実行ステータスを参照し、実行中であった場合は例外を送出する。 | - | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) | 本ハンドラではスレッドコンテキスト上に保持されたリクエストIDを使用して 同一プロセスの判定を行う。そのため、必ず [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) を本ハンドラの上位に 設置する必要がある。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (リクエストIDの取得)**

スレッドコンテキストからリクエストIDを取得する。

**1a. (多重起動チェック対象外プロセス)**

取得したリクエストIDが、本ハンドラに設定されたチェック対象外のIDリストに含まれていた場合、
このハンドラでは何もせず、後続ハンドラに処理を委譲した結果をリターンする。

**2.  (多重起動チェック)**

後述の **プロセス管理テーブル** に対して更新処理を行なう。(FW用DB接続を使用)

リクエストID = (1.で取得したリクエストID) AND 実行中フラグ = "0" (未実行)

実行中フラグ = "1" (実行中)

**2a. (多重起動エラー)**

1. での更新対象が0件であった場合、多重起動と判断し `Result.InternalError` を送出する。(終了コード20)

**3. (後続ハンドラの実行)**

ハンドラキュー上の後続のハンドラに処理を委譲する。

**[復路処理]**

**4. (実行中フラグの更新)**

**プロセス管理テーブル** に対して更新処理を行なう。

リクエストID = (1.で取得したリクエストID) AND 実行中フラグ = "1" (実行中)

実行中フラグ = "0" (未実行)

**[例外処理]**

**3a. (実行中フラグの更新)**

後続ハンドラの処理中に例外が送出された場合でも、必ず実行中フラグを"0"(未実行)に更新する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| プロセス管理テーブル名 | tableName | String | 必須指定 |
| リクエストIDカラム名 | requestIdColumnName | String | 必須指定 |
| アクティブフラグカラム名 | processActiveFlgColumnName | String | 必須指定 |
| DBトランザクションマネージャ | dbTransactionManager | SimpleDbTransactionManager | 必須指定 |
| 多重起動エラー時の終了コード | exitCode | Integer | 任意指定(デフォルト = 127) |
| チェック対象外リクエストID | permitRequestIds | List<String> | 任意指定 |

**基本設定**

```xml
<component
  name="duplicateProcessCheckHandler"
  class="nablarch.fw.handler.DuplicateProcessCheckHandler">
  <!--プロセス管理テーブル名-->
  <property name="tableName" value="BATCH_REQUEST" />
  <!--プロセス管理テーブル上のリクエストIDカラム名-->
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <!--プロセス管理テーブル上のアクティブフラグカラム名-->
  <property name="processActiveFlgColumnName" value="PROCESS_ACTIVE_FLG" />
  <!--トランザクション管理-->
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />
</component>
```

**任意の設定項目も含めた例**

```xml
<component
  name="duplicateProcessCheckHandler"
  class="nablarch.fw.handler.DuplicateProcessCheckHandler">

  <property name="tableName" value="BATCH_REQUEST" />
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <property name="processActiveFlgColumnName" value="PROCESS_ACTIVE_FLG" />
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />

  <!--多重起動エラー時のプロセス終了コード-->
  <property name="exitCode" value="27" />

  <!--多重起動を認めるリクエストIDの一覧-->
  <property name="permitRequestIds" value="BC0010,BC0011" />
</component>
```
