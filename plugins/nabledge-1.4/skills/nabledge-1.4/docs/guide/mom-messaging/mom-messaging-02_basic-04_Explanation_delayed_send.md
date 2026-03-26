# 応答不要メッセージ送信処理のアプリケーション構造

## 概要

共通アクションクラス（一時テーブルから電文を送信）を使用する場合、アプリケーション開発者が作成すべき成果物は以下の4種類のみ:

1. 電文のレイアウトを表すフォーマット定義ファイル
2. SQLファイル（以下3種類のSQL文）:
   - 電文送信テーブルからステータスが未送信のデータを取得するSELECT文（未送信条件を含める必要あり）
   - 電文送信後に該当データのステータスを処理済みに更新するUPDATE文
   - 電文送信失敗時に該当データのステータスを送信失敗（エラー）に更新するUPDATE文
3. 送信用電文を保持するための一時テーブル
4. 一時テーブルの処理ステータス更新用Formクラス

> **注意**: Formクラスに必要なプロパティはステータス更新に必要なテーブル項目のみでよい。一時テーブルのテーブルレイアウトをプロジェクト共通で定義することで、単一のFormクラスを全ての応答不要メッセージ送信処理で使用できる。詳細は :ref:`応答不要メッセージ送信処理のFormクラス実装方法<sendFormSample>` を参照すること。

詳細な実装方法および実装例は :ref:`応答不要メッセージ送信処理の実装方法<mqDelayedSendTitle>` を参照すること。

> **注意**: 電文送信テーブルへのデータ登録は前処理（画面オンライン処理またはバッチ処理）で行われる。詳細は [../../04_Explanation/index](../web-application/web-application-04_Explanation.md) および [../../04_Explanation_batch/index](../nablarch-batch/nablarch-batch-04_Explanation_batch.md) を参照すること。

<details>
<summary>keywords</summary>

応答不要メッセージ送信, 電文送信テーブル, 一時テーブル, 処理ステータス更新, Formクラス, 共通アクションクラス, 未送信データ取得, SQLファイル

</details>

## クラス構造

![クラス構造図](../../../knowledge/guide/mom-messaging/assets/mom-messaging-02_basic-04_Explanation_delayed_send/class.png)

<details>
<summary>keywords</summary>

クラス構造図, 応答不要メッセージ送信, クラス設計

</details>

## 処理の流れ

1. SQLファイルから電文送信用データ取得のSELECT文を取得
2. 一時テーブルから電文送信用データを取得
3. フォーマット定義ファイルを元に送信用電文を生成
4. 電文を送信
5. 一時テーブルのステータス更新用Formクラスを生成
6. ステータス更新用UPDATE文を取得
7. FormクラスおよびUPDATE文を使用して一時テーブルのステータスを更新

> **注意**: ステータスを更新することにより以下を防ぐことができる:
> - 同一電文を複数回送信することを防止する
> - エラーとなったデータ（ポイズンデータ）を繰り返し送信しようとし、繰り返し障害となることを防止する

![シーケンス図](../../../knowledge/guide/mom-messaging/assets/mom-messaging-02_basic-04_Explanation_delayed_send/sequence.png)

<details>
<summary>keywords</summary>

処理の流れ, 電文送信処理, ポイズンデータ防止, 重複送信防止, ステータス更新, シーケンス図, 送信失敗

</details>
