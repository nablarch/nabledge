# リクエスト単体テストの実施方法(同期応答メッセージ受信処理)

## テストクラスの書き方

テストクラス作成ルール: (1) テスト対象Actionクラスと同一パッケージ (2) クラス名は`{Action名}RequestTest` (3) `nablarch.test.core.http.MessagingRequestTestSupport` を継承

**クラス**: `nablarch.test.core.http.MessagingRequestTestSupport`

<details>
<summary>keywords</summary>

MessagingRequestTestSupport, テストクラス作成ルール, リクエスト単体テスト, 同期応答メッセージ受信処理テスト

</details>

## テストメソッド分割

原則として１テストクラスにつき１テストメソッド・１テストシートとする。ケースが複雑またはデータ量が多い場合はメソッドやシートを分割してよい。

<details>
<summary>keywords</summary>

テストメソッド分割, テストシート分割, テストケース数

</details>

## テストデータの書き方（概要・共通DB初期値）

テストデータはExcelファイルに記載し、テストソースコードと同じディレクトリ・同じ名前（拡張子のみ異なる）で格納する。詳細は :ref:`how_to_write_excel` を参照。

### テストクラスで共通のデータベース初期値

画面オンラインの場合と同様。:ref:`request_test_setup_db` を参照。

<details>
<summary>keywords</summary>

テストデータ, Excelファイル, テストクラスで共通, データベース初期値, request_test_setup_db, how_to_write_excel

</details>

## テストショット一覧

LIST_MAPのデータタイプで記載する。IDは `testShots` 固定。

| カラム名 | 説明 | 必須 |
|---|---|---|
| no | テストケース番号（1からの連番） | ○ |
| description | テストケースの説明 | ○ |
| expectedStatusCode | 期待するステータスコード | ○ |
| setUpTable | 事前DB登録データのグループID（:ref:`tips_groupId` 参照） | |
| expectedTable | 期待するテーブルのグループID（:ref:`tips_groupId` 参照） | |
| expectedLog | 期待するログメッセージID | |
| diConfig | 常駐プロセスを実行する際のコンポーネント設定ファイルへのパス（:ref:`about_commandline_argument` 参照） | ○ |
| requestPath | 常駐プロセスを実行する際のリクエストパス（:ref:`about_commandline_argument` 参照） | ○ |
| userId | 常駐プロセス実行ユーザID（:ref:`about_commandline_argument` 参照） | ○ |

「常駐プロセス」とは、メッセージ送受信を行うプロセスのこと（diConfig・requestPath・userId カラムに適用）。

setUpTable・expectedTableに `default` と記載するとデフォルトグループIDを使用。デフォルトと個別グループIDの併用も可能（両方のデータが有効になる）。

<details>
<summary>keywords</summary>

testShots, LIST_MAP, テストショット一覧, diConfig, requestPath, userId, setUpTable, expectedTable, expectedLog, 常駐プロセス, tips_groupId, about_commandline_argument

</details>

## 各種準備データ

**データベースの準備**: :ref:`オンライン<request_test_testcases>` と同様にグループIDで対応付けする。テストショット一覧にてsetUpTableの欄がない場合、または空欄の場合、DB準備は行われない。

**リクエストメッセージ**: 要求電文の名前は `MESSAGE=setUpMessages` 固定。

構成:
1. 共通情報（ディレクティブ・フレームワーク制御ヘッダ）: key-value形式で全メッセージ共通の値を記載
2. メッセージボディ:

| 行 | 記述内容 | 備考 |
|---|---|---|
| 1行目 | フィールド名称 | 先頭セルは`no` |
| 2行目 | データタイプ | 先頭セルは空白 |
| 3行目 | フィールド長 | 先頭セルは空白 |
| 4行目以降 | データ | 先頭セルは1からの通番 |

> **警告**: フィールド名称に重複した名称は許容されない（同一名称のフィールドが複数存在してはならない）。

テストショット一覧のnoとメッセージボディのnoは対応する（no1のテストショットはno1行のデータを使用）。

<details>
<summary>keywords</summary>

各種準備データ, データベースの準備, setUpTable欄がない, setUpMessages, リクエストメッセージ, グループID, フィールド名称

</details>

## 各種期待値

**レスポンスメッセージ**: リクエストメッセージと同形式。名前は `MESSAGE=expectedMessages` 固定。

**期待するデータベースの状態**: データベースの準備と同様にグループIDでテストケース一覧とリンクさせる。

<details>
<summary>keywords</summary>

各種期待値, expectedMessages, レスポンスメッセージ, 期待するデータベース

</details>

## テストメソッドの書き方

**クラス**: `nablarch.test.core.http.MessagingRequestTestSupport`

テストメソッド内でスーパクラスの以下のいずれかのメソッドを呼び出す:

- `void execute()` — テストメソッド名と同名のシートを使用（`execute(テストメソッド名)` と等価）
- `void execute(String sheetName)` — シート名を明示指定

通常はシート名とメソッド名が同一のため `execute()` を使用する。

```java
@Test
public void testRegisterUser() {
    execute();   // execute("testRegisterUser") と等価
}
```

<details>
<summary>keywords</summary>

execute, MessagingRequestTestSupport, テストメソッド作成, execute(String sheetName), シート名指定

</details>

## テスト起動方法・テスト結果検証

**テスト起動方法**: クラス単体テストと同様。通常のJUnitテストと同じように実行する。

**テスト結果検証**: 自動テストフレームワークによる結果検証:

- レスポンスメッセージの検証（必須・常に実施）
- データベースの検証（テストショット一覧に期待値記載がある場合のみ）
- ログの検証（テストショット一覧に期待値記載がある場合のみ）

<details>
<summary>keywords</summary>

JUnit, テスト実行, テスト起動方法, レスポンスメッセージ検証, データベース検証, ログ検証, テスト結果確認, 自動テストフレームワーク

</details>
