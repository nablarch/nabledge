# リクエスト単体テストの実施方法(メール送信)

## メール送信処理の構造とテスト範囲

## メール送信処理の構造とテスト範囲

[../../04_Explanation_other/04_Explanation_mail/02_basic](../../guide/libraries/libraries-02_basic.md) で説明の通り、業務アプリケーションはメール送信要求APIを呼び出すだけである。

リクエスト単体テストの範囲は、メール送信要求が正常に受け付けられデータベースに格納されることを確認するところまでとなる。

![メール送信処理の概要](../../../knowledge/development-tools/testing-framework/assets/testing-framework-mail/mail_overview.jpg)

<details>
<summary>keywords</summary>

リクエスト単体テスト, メール送信テスト範囲, メール送信要求API, メール送信処理, テスト範囲

</details>

## テストの実施方法

## テストの実施方法

リクエスト単体テストで確認すべきことは、メール送信要求が :ref:`各テーブル（メール送信要求テーブル、メール送信先テーブル、メール添付ファイルテーブル）<mailTables>` に正しく格納されることである。

他の単体テストと同様に、期待する上記3テーブルの状態をExcelシートに記述する。

<details>
<summary>keywords</summary>

メール送信要求テーブル, メール送信先テーブル, メール添付ファイルテーブル, Excelシート, mailTables

</details>
