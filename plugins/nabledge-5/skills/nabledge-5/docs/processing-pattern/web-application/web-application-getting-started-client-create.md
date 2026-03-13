# 登録機能の作成(ハンズオン形式)

**公式ドキュメント**: [登録機能の作成(ハンズオン形式)](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/client_create/index.html)

## 作成する機能の説明

## 作成する機能の説明

顧客登録機能は以下の操作フローで動作する:

1. ヘッダメニューの「顧客登録」リンクを押下する。
2. 顧客登録画面が表示される。
3. 顧客名に全角文字列を入力し、業種プルダウンで任意の値を選択して「登録」ボタンを押下する。
4. 登録確認画面が表示される。
5. 「確定」ボタンを押下し、データベースに顧客を登録して完了画面を表示する。

<details>
<summary>keywords</summary>

顧客登録, 入力画面, 確認画面, 完了画面, 入力確認パターン, 画面遷移フロー, 登録フロー, 全角文字, 業種プルダウン

</details>

## 顧客登録機能の仕様

## 顧客登録機能の仕様

顧客登録機能のURL・アクションメソッドマッピング:

| No. | 処理名 | URL | Action | HTTPメソッド |
|---|---|---|---|---|
| 1 | 初期表示 | /action/client/ | ClientAction#input | GET |
| 2 | 登録内容の確認 | /action/client/confirm | ClientAction#confirm | POST |
| 3 | 登録画面に戻る | /action/client/back | ClientAction#back | POST |
| 4 | 登録処理の実行 | /action/client/create | ClientAction#create | POST |

使用するテーブル定義: ![テーブル定義](../../../knowledge/processing-pattern/web-application/assets/web-application-getting-started-client-create/client_table.png)

<details>
<summary>keywords</summary>

ClientAction, 登録機能, 入力確認画面パターン, URLマッピング, アクションメソッド, 初期表示, 登録内容確認, 登録処理実行

</details>
