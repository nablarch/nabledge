# リクエスト単体テストの実施方法(同期応答メッセージ送信処理)

## 出力ライブラリ(同期応答メッセージ送信処理)の構造とテスト範囲

同期応答メッセージ送信処理のリクエスト単体テストは、リクエストID単位で行う。

> **注意**: ここで扱うリクエストIDはメッセージ送信先システムの機能を一意に識別するIDであり、画面オンライン処理やバッチ処理で使用するリクエストIDとは意味が異なる。このリクエストIDに基づき、要求電文・応答電文のフォーマット、送信キュー名、受信キュー名が決定する。

テスト実施時のフロー:
1. 自動テストFWがNablarch Application Frameworkを起動
2. Nablarch AFがActionの入力パラメータ（画面:リクエスト、バッチ:ファイル/DB）を読み込みActionを起動
3. ActionがNablarch AFのメッセージ同期送信処理を実行し、パラメータを要求電文に変換
4. 自動テストFWがテストデータを元に要求電文をアサート（キューにはPUTしない）
5. 自動テストFWがテストデータを元に応答電文を生成しActionへ返却（キューからはGETしない）

> **注意**: 自動テストFWは実際の「送信キュー」「受信キュー」を使用せず、キューの手前で要求電文アサートおよび応答電文生成を行う。特別なミドルウェアのインストールや環境設定は不要。

テストの特徴:
- Excelファイルを使用し、外部インターフェース設計書のフォーマット定義に沿ってテストデータを記載可能
- 要求電文のアサートおよび応答電文の返却は自動テストFWが自動的に行うため、テストコードを別途記述する必要がない
- 提供されるスーパークラスを継承するだけでテスト準備・実行・結果確認が可能

<details>
<summary>keywords</summary>

同期応答メッセージ送信処理, リクエスト単体テスト, テストフレームワーク概要, キューを使わない自動テスト, Excelテストデータ, ミドルウェア不要

</details>

## テストデータの書き方

テストデータExcelファイルはテストソースコードと同じディレクトリに同じ名前で格納する（拡張子のみ異なる）。

## 要求電文の期待値と応答電文の準備

リクエストIDごとに要求電文・応答電文のヘッダ部とボディ部のフォーマットおよびデータを定義する。

テストケースの`expectedMessage`・`responseMessage`フィールドに記載されたグループIDが、対応する識別子を持つ表と対応する。

> **警告**: テストケース一覧に`expectedMessage`/`responseMessage`欄がない場合は検証が行われない。欄が空欄でメッセージ同期送信処理が実行された場合はテストが失敗する。メッセージ同期送信処理を行う場合は`expectedMessage`と`responseMessage`を必ず記載すること。

1テストケースで同一グループID・同一リクエストIDを持つ電文が複数件送信される場合は、件数分のデータ行を記載する。`no`列の順番（連番）は送信順序に対応する。

識別子の書式:
- 要求電文ヘッダの期待値: `EXPECTED_REQUEST_HEADER_MESSAGES[グループID]=リクエストID`
- 要求電文ボディの期待値: `EXPECTED_REQUEST_BODY_MESSAGES[グループID]=リクエストID`
- 応答電文ヘッダ: `RESPONSE_HEADER_MESSAGES[グループID]=リクエストID`
- 応答電文ボディ: `RESPONSE_BODY_MESSAGES[グループID]=リクエストID`

| 項目 | 説明 |
|---|---|
| 識別子 | 上記書式で記載。テストケースのグループIDと紐付く |
| ディレクティブ行 | ディレクティブ名と設定値（複数行指定可） |
| no | ディレクティブ行の直下に必ず「no」を記載 |
| フィールド名称 | フィールドの数だけ記載（重複不可） |
| データ型 | フィールドごとに記載 |
| フィールド長 | フィールドごとに記載 |
| データ | 複数レコードは次の行に続けて記載 |

> **警告**: フィールド名称に重複した名称は許容されない。

> **注意**: Nablarch標準の同期応答メッセージ送信機能では、要求電文と応答電文のヘッダ部は共通フォーマットを使用する。ヘッダ部フォーマット定義はリクエスト単位で統一すること。ボディ部は要求電文と応答電文で異なるフォーマットを定義可能。

> **ヒント**: フィールド名称、データ型、フィールド長の記述は、外部インタフェース設計書からコピー＆ペーストすることで効率良く作成できる。ペーストする際は「**行列を入れ替える**」オプションにチェックすること。

要求電文ヘッダの期待値および応答電文の本文・ヘッダについても、識別子を除く部分については要求電文の本文の期待値と同様の記載方法となる。つまり4種類の表（`EXPECTED_REQUEST_HEADER_MESSAGES`、`EXPECTED_REQUEST_BODY_MESSAGES`、`RESPONSE_HEADER_MESSAGES`、`RESPONSE_BODY_MESSAGES`）はすべて同じ書式であり、識別子のみが異なる。

![要求電文テストデータのExcel記載例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-send_sync-02_RequestUnitTest/send_sync_example.png)

<details>
<summary>keywords</summary>

テストデータ書き方, expectedMessage, responseMessage, グループID, EXPECTED_REQUEST_HEADER_MESSAGES, EXPECTED_REQUEST_BODY_MESSAGES, RESPONSE_HEADER_MESSAGES, RESPONSE_BODY_MESSAGES, 要求電文期待値, 応答電文, 外部インタフェース設計書, 行列を入れ替える

</details>

## 障害系のテスト

応答電文の表の最初のフィールドに`errorMode:`から始まる特定の値を設定することで障害系のテストが行える。

| 設定値 | 障害内容 | 自動テストFWの動作 |
|---|---|---|
| `errorMode:timeout` | メッセージ送信中にタイムアウトエラーが発生するケース | `MessageSendSyncTimeoutException`（`MessagingException`のサブクラス）を送出 |
| `errorMode:msgException` | メッセージ送受信エラーが発生するケース | `MessagingException`をスロー |

この値は応答電文の表の**ヘッダおよび本文両方**の、`no`を除く最初のフィールドに記載すること。

> **注意**: 業務アクション内で明示的に`MessagingException`の制御を行っていない場合、個別のリクエスト単体テストで障害系テストを行う必要はない。

<details>
<summary>keywords</summary>

障害系テスト, errorMode:timeout, errorMode:msgException, MessageSendSyncTimeoutException, MessagingException

</details>

## テスト結果検証

要求電文の期待値を定義した場合、自動テストFWが以下を検証する:

- 要求電文の内容
- 要求電文の送信件数

<details>
<summary>keywords</summary>

テスト結果検証, 要求電文アサート, 送信件数検証

</details>
