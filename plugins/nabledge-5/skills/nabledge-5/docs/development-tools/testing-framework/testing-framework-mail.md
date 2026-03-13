# リクエスト単体テストの実施方法(メール送信)

**公式ドキュメント**: [リクエスト単体テストの実施方法(メール送信)](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/mail.html)

## メール送信処理の構造とテスト範囲

## メール送信処理の構造とテスト範囲

リクエスト単体テストの範囲は、メール送信要求が正常に受け付けられデータベースに格納されることを確認するところまで。業務アプリケーションは [mail](../../component/libraries/libraries-mail.md) が提供するメール送信要求APIを呼び出すだけで、実際のメール送信処理はフレームワークが担当する。

![メール送信処理の処理概要と業務アプリケーションのテスト範囲](../../../knowledge/development-tools/testing-framework/assets/testing-framework-mail/mail_overview.jpg)

<details>
<summary>keywords</summary>

メール送信, リクエスト単体テスト, テスト範囲, メール送信要求API, データベース格納確認

</details>

## テストの実施方法

## テストの実施方法

確認内容: メール送信要求が [mail](../../component/libraries/libraries-mail.md) に記述された以下3テーブルに正しく格納されること。

- メール送信要求テーブル
- メール送信先テーブル
- メール添付ファイルテーブル

テスト方法: 他の単体テストと同様に、期待する上記3テーブルの状態をExcelシートに記述する。

<details>
<summary>keywords</summary>

メール送信要求テーブル, メール送信先テーブル, メール添付ファイルテーブル, Excelシート, テスト実施方法, テーブル状態確認

</details>
