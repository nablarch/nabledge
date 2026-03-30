# 応答不要メッセージ送信処理のアプリケーション構造

## 概要

## 概要

Nablarchは、データベースの一時テーブル（送信する電文データを保持するテーブル）から送信対象データを取得し、電文の作成・送信を行う共通アクションクラスを提供する。開発者は以下の成果物を作成するだけでよい：

- **フォーマット定義ファイル**: 電文のレイアウトを定義
- **SQLファイル**（3種類）:
  - 一時テーブルから未送信データを取得するSELECT文（条件に未送信ステータスを含めること）
  - 送信後に処理済みステータスへ更新するUPDATE文
  - 送信失敗時にエラーステータスへ更新するUPDATE文
- **一時テーブル**: 送信用電文データを保持
- **Formクラス**: 一時テーブルのステータス更新用

> **注意**: Formクラスに必要なプロパティは、ステータス更新に必要なテーブル項目に対応するもののみでよい。一時テーブルのレイアウトをプロジェクト共通で定義することで、単一のFormクラスを全ての応答不要メッセージ送信処理で使用できる。

> **注意**: 電文送信テーブルへのデータ登録は、前処理（画面オンライン処理やバッチ処理）で行われる。詳細は[../../04_Explanation/index](../web-application/web-application-04_Explanation.md)、[../../04_Explanation_batch/index](../nablarch-batch/nablarch-batch-04_Explanation_batch.md)を参照。

<details>
<summary>keywords</summary>

応答不要メッセージ送信, 一時テーブル, 共通アクションクラス, フォーマット定義ファイル, SQLファイル, Formクラス, ステータス管理, 電文送信テーブル

</details>

## クラス構造

## クラス構造

![クラス構造](../../../knowledge/guide/mom-messaging/assets/mom-messaging-02_basic-04_Explanation_delayed_send/class.png)

<details>
<summary>keywords</summary>

クラス構造, 応答不要メッセージ送信, アーキテクチャ

</details>

## 処理の流れ

## 処理の流れ

1. SQLファイルから電文送信用データを取得するSELECT文を取得
2. 一時テーブルから電文送信用データを取得
3. フォーマット定義ファイルをもとに送信用電文を生成
4. 電文を送信
5. 一時テーブルのステータスを更新するFormクラスを生成
6. ステータス更新用UPDATE文を取得
7. FormクラスとUPDATE文を使用して一時テーブルのステータスを更新

> **注意**: ステータスを更新することで以下を防止できる：(1) 同一電文の複数回送信、(2) エラーデータ（ポイズンデータ）の繰り返し送信による繰り返し障害

![シーケンス図](../../../knowledge/guide/mom-messaging/assets/mom-messaging-02_basic-04_Explanation_delayed_send/sequence.png)

<details>
<summary>keywords</summary>

処理の流れ, ポイズンデータ, 二重送信防止, ステータス更新, 電文送信シーケンス, SELECT文, UPDATE文

</details>
