# プロセス多重起動防止ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.DuplicateProcessCheckHandler`

DB上のプロセス管理テーブルを参照し、同一リクエストIDのプロセスが実行中でないことを確認する。実行中であればエラー終了させることで、バッチの多重起動を防止する。

**プロセス管理テーブルの構造**

| 論理名 | データ型 | 備考 |
|---|---|---|
| リクエストID | VARCHAR PK | プロセスを特定するためのID |
| アクティブフラグ | CHAR(1) | "0": 未実行、"1": 実行中 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| ThreadContextHandler | スレッドコンテキスト上のリクエストIDを使用して同一プロセス判定を行うため、必ず本ハンドラの上位に設置すること |

<details>
<summary>keywords</summary>

DuplicateProcessCheckHandler, nablarch.fw.handler.DuplicateProcessCheckHandler, ThreadContextHandler, プロセス多重起動防止, バッチ多重起動防止, プロセス管理テーブル, アクティブフラグ

</details>

## ハンドラ処理フロー

**[往路処理]**

1. スレッドコンテキストからリクエストIDを取得する
2. 取得したリクエストIDがチェック対象外リスト（`permitRequestIds`）に含まれる場合、何もせず後続ハンドラに委譲してリターンする（1a）
3. プロセス管理テーブルに対して更新処理を実行する（FW用DB接続使用）
   - 更新条件: リクエストID = 取得したID AND 実行中フラグ = "0"（未実行）
   - 更新内容: 実行中フラグ = "1"（実行中）
4. 更新対象が0件の場合、多重起動と判断し `Result.InternalError` を送出する（終了コード20）（2a）
5. 後続ハンドラに処理を委譲する

**[復路処理]**

4. プロセス管理テーブルを更新する
   - 更新条件: リクエストID = 取得したID AND 実行中フラグ = "1"（実行中）
   - 更新内容: 実行中フラグ = "0"（未実行）

**[例外処理]**

3a. 後続ハンドラで例外が発生した場合でも、必ず実行中フラグを"0"（未実行）に更新する

<details>
<summary>keywords</summary>

多重起動チェック, Result.InternalError, 往路処理, 復路処理, 例外処理, 実行中フラグ, チェック対象外リクエストID

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| tableName | String | ○ | | プロセス管理テーブル名 |
| requestIdColumnName | String | ○ | | リクエストIDカラム名 |
| processActiveFlgColumnName | String | ○ | | アクティブフラグカラム名 |
| dbTransactionManager | SimpleDbTransactionManager | ○ | | DBトランザクションマネージャ |
| exitCode | Integer | | 127 | 多重起動エラー時の終了コード |
| permitRequestIds | List<String> | | | チェック対象外リクエストID |

**基本設定**

```xml
<component name="duplicateProcessCheckHandler"
  class="nablarch.fw.handler.DuplicateProcessCheckHandler">
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <property name="processActiveFlgColumnName" value="PROCESS_ACTIVE_FLG" />
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />
</component>
```

**任意設定を含む例**

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

tableName, requestIdColumnName, processActiveFlgColumnName, dbTransactionManager, exitCode, permitRequestIds, SimpleDbTransactionManager, 設定項目, チェック対象外リクエストID

</details>
