# リクエスト単体テストの実施方法(同期応答メッセージ受信処理)

**公式ドキュメント**: [リクエスト単体テストの実施方法(同期応答メッセージ受信処理)]()

## テストクラスの書き方

テストクラス作成ルール: (1) テスト対象Actionと同一パッケージ (2) クラス名は`{Action名}RequestTest` (3) `nablarch.test.core.http.MessagingRequestTestSupport`を継承

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, テストクラス作成ルール, リクエスト単体テスト, クラス命名規則, パッケージ設定

</details>

## テストメソッド分割

1テストクラスにつき1テストメソッド、1テストシートが原則。ケースが複雑またはデータ量が多い場合はメソッドやシートを分割しても良い。

<details>
<summary>keywords</summary>

テストメソッド分割, テストシート分割, 1テストクラス1テストメソッド

</details>

## テストデータの書き方

テストデータファイルは、テストソースコードと同じディレクトリに同じ名前で格納する（拡張子のみ異なる）。

## テストショット一覧

LIST_MAPのデータタイプで１テストメソッド分のテストショット表を記載する。IDは`testShots`固定。

| カラム名 | 説明 | 必須 |
|---|---|---|
| no | テストケース番号（1からの連番） | ○ |
| description | テストケースの説明 | ○ |
| expectedStatusCode | 期待するステータスコード | ○ |
| setUpTable | 各ケース実行前にDBに登録するデータの:ref:`グループID<tips_groupId>` | |
| expectedTable | DB比較時の期待テーブルの:ref:`グループID<tips_groupId>` | |
| expectedLog | 期待するログメッセージのID | |
| diConfig | 常駐プロセスのコンポーネント設定ファイルパス（:ref:`about_commandline_argument`参照） | ○ |
| requestPath | 常駐プロセスのリクエストパス（:ref:`about_commandline_argument`参照） | ○ |
| userId | 常駐プロセス実行ユーザID（:ref:`about_commandline_argument`参照） | ○ |

グループIDを使わない場合は`default`と記載。デフォルトと個別グループを併用可能で、両方のデータが有効になる。「常駐プロセス」はメッセージ送受信を行うプロセスのこと。

## データベースの準備

グループIDで対応付けを行う。`setUpTable`が空欄または項目なしの場合、DB準備は行われない。

## リクエストメッセージ

要求電文の名前は`MESSAGE=setUpMessages`固定。構成:

1. **共通情報**: ディレクティブ、フレームワーク制御ヘッダをkey-value形式で記載（全メッセージ共通）
2. **メッセージボディ**: フレームワーク制御ヘッダ以降のメッセージ

メッセージボディの行構成:

| 行 | 記述内容 | 備考 |
|---|---|---|
| 1行目 | フィールド名称 | 先頭セルは"no" |
| 2行目 | データタイプ | 先頭セルは空白 |
| 3行目 | フィールド長 | 先頭セルは空白 |
| 4行目以降 | データ | 先頭セルは1からの通番 |

> **警告**: フィールド名称に重複した名称は許容されない（同一フィールド名が2つ以上存在してはならない）。

テストショット一覧のnoと対応: テストショットno1の要求電文 → 本表の1行目（no 1）のデータ。

## 各種期待値

**レスポンスメッセージ**: リクエストメッセージと同じ構造。名前は`MESSAGE=expectedMessages`固定。

**期待するデータベースの状態**: データベースの準備と同様に、テストケース一覧とグループIDでリンクさせる。

<details>
<summary>keywords</summary>

testShots, setUpTable, expectedTable, expectedLog, diConfig, requestPath, userId, MESSAGE=setUpMessages, MESSAGE=expectedMessages, テストショット一覧, リクエストメッセージ, レスポンスメッセージ, グループID, テストデータ書き方

</details>

## テストメソッドの書き方

`MessagingRequestTestSupport`を継承する。テストメソッド内でスーパクラスの以下のいずれかのメソッドを呼び出す:

- `void execute()` — テストメソッド名をシート名として使用（`execute("testRegisterUser")` と等価）
- `void execute(String sheetName)` — テストデータのシート名を明示指定

通常、テストシート名とテストメソッド名は同一であるため、引数なしの`execute()`を使用する。

<details>
<summary>keywords</summary>

execute, MessagingRequestTestSupport, テストメソッド作成, シート名指定, void execute

</details>

## テスト起動方法

クラス単体テストと同様。通常のJUnitテストと同じように実行する。

<details>
<summary>keywords</summary>

JUnit, テスト起動, テスト実行

</details>

## テスト結果検証

自動テストフレームワークにより以下の結果検証が行われる:

- レスポンスメッセージの結果検証（必須）
- データベースの結果検証
- ログの結果検証

データベースとログの結果検証は、テストショット一覧に期待値の記載が無い場合（空欄）はスキップされる。

<details>
<summary>keywords</summary>

レスポンスメッセージ検証, データベース検証, ログ検証, テスト結果検証, expectedMessages

</details>
