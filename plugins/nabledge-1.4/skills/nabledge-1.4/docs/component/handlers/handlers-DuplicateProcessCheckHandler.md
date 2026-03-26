# プロセス多重起動防止ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.DuplicateProcessCheckHandler`

DB上のプロセス管理テーブルを参照し、同一リクエストIDを持つプロセスが実行中でないことを確認する。実行中のプロセスが存在する場合、起動処理をエラー終了させる。運用時の手違いによる同一バッチの多重起動を防止する。

**プロセス管理テーブル構造**

| 論理名 | データ型 | 備考 |
|---|---|---|
| リクエストID | VARCHAR PK | プロセスを特定するためのID |
| アクティブフラグ | CHAR(1) | "0": 未実行、"1": 実行中 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | スレッドコンテキスト上のリクエストIDを使用して同一プロセス判定を行うため、必ず本ハンドラの上位に設置すること |

<details>
<summary>keywords</summary>

DuplicateProcessCheckHandler, nablarch.fw.handler.DuplicateProcessCheckHandler, プロセス多重起動防止, プロセス管理テーブル, 多重起動チェック, バッチ多重起動防止, ThreadContextHandler

</details>

## ハンドラ処理フロー

**[往路処理]**

1. スレッドコンテキストからリクエストIDを取得する
2. (1a) 取得したリクエストIDがチェック対象外IDリストに含まれる場合、後続ハンドラに処理を委譲してリターン
3. プロセス管理テーブルを更新（FW用DB接続を使用）
   - 更新条件: リクエストID = (1.で取得したID) AND アクティブフラグ = "0"（未実行）
   - 更新内容: アクティブフラグ = "1"（実行中）
4. (2a) 更新対象が0件の場合、多重起動と判断し `Result.InternalError` を送出（終了コード20）
5. 後続ハンドラに処理を委譲

**[復路処理]**

6. プロセス管理テーブルを更新
   - 更新条件: リクエストID = (1.で取得したID) AND アクティブフラグ = "1"（実行中）
   - 更新内容: アクティブフラグ = "0"（未実行）

**[例外処理]**

> **重要**: 後続ハンドラの処理中に例外が発生した場合でも、必ずアクティブフラグを"0"（未実行）に更新する

<details>
<summary>keywords</summary>

DuplicateProcessCheckHandler, Result.InternalError, 往路処理, 復路処理, 例外処理, 多重起動エラー, アクティブフラグ更新, チェック対象外リクエストID

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| tableName | String | ○ | | プロセス管理テーブル名 |
| requestIdColumnName | String | ○ | | リクエストIDカラム名 |
| processActiveFlgColumnName | String | ○ | | アクティブフラグカラム名 |
| dbTransactionManager | SimpleDbTransactionManager | ○ | | DBトランザクションマネージャ |
| exitCode | Integer | | 127 | 多重起動エラー時のプロセス終了コード |
| permitRequestIds | List\<String\> | | | チェック対象外リクエストIDリスト |

**基本設定例**:
```xml
<component name="duplicateProcessCheckHandler"
           class="nablarch.fw.handler.DuplicateProcessCheckHandler">
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <property name="processActiveFlgColumnName" value="PROCESS_ACTIVE_FLG" />
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />
</component>
```

**任意設定を含む例**:
```xml
<component name="duplicateProcessCheckHandler"
           class="nablarch.fw.handler.DuplicateProcessCheckHandler">
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <property name="processActiveFlgColumnName" value="PROCESS_ACTIVE_FLG" />
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />
  <property name="exitCode" value="27" />
  <property name="permitRequestIds" value="BC0010,BC0011" />
</component>
```

<details>
<summary>keywords</summary>

DuplicateProcessCheckHandler, tableName, requestIdColumnName, processActiveFlgColumnName, dbTransactionManager, exitCode, permitRequestIds, SimpleDbTransactionManager, XML設定例

</details>
