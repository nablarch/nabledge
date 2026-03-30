# リクエスト単体テストの実施方法(メール送信)

## リクエスト単体テストの実施方法(メール送信)

**テスト範囲**: メール送信要求が正常に受け付けられ、DBに格納されることを確認するところまで。

![メール送信処理概要](../../../knowledge/development-tools/testing-framework/assets/testing-framework-mail/mail_overview.jpg)

**確認対象**: :ref:`mailTables`（メール送信要求テーブル、メール送信先テーブル、メール添付ファイルテーブル）の3テーブルに正しく格納されることを確認する。

**テスト実施方法**: 期待する上記3テーブルの状態をExcelシートに記述する。

<details>
<summary>keywords</summary>

メール送信リクエスト単体テスト, メール送信要求テーブル, メール送信先テーブル, メール添付ファイルテーブル, Excelシートによるテスト期待値記述, テスト範囲, mailTables

</details>
