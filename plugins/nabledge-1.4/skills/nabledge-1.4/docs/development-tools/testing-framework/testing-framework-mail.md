# リクエスト単体テストの実施方法(メール送信)

## メール送信処理の構造とテスト範囲

リクエスト単体テストの範囲: メール送信要求が正常に受け付けられ、データベースに格納されることを確認するまで（業務アプリはフレームワークが提供するメール送信要求APIを呼び出すだけ）。

![メール送信処理の概要とテスト範囲](../../../knowledge/development-tools/testing-framework/assets/testing-framework-mail/mail_overview.jpg)

<details>
<summary>keywords</summary>

メール送信処理, リクエスト単体テスト, テスト範囲, メール送信要求API, データベース格納

</details>

## テストの実施方法

テストで確認すること: メール送信要求が :ref:`各テーブル（メール送信要求テーブル、メール送信先テーブル、メール添付ファイルテーブル）<mailTables>` に正しく格納されること。

テスト方法: 期待する上記3テーブルの状態をExcelシートに記述する。

<details>
<summary>keywords</summary>

メール送信要求テーブル, メール送信先テーブル, メール添付ファイルテーブル, Excelシート, テーブル状態確認

</details>
