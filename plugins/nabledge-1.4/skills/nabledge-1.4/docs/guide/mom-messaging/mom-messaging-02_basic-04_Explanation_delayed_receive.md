# 応答不要型メッセージ受信処理のアプリケーション構造

## 概要

受信した電文をデータベースの一時テーブル（電文受信テーブル）に保存するための共通アクションを提供する。開発者は以下の成果物のみ作成すればよい。

- 電文のレイアウトを表すフォーマット定義ファイル
- データベースへ電文を登録するためのINSERT文（SQLファイル）
- データベースへ電文を登録する際に使用するFormクラス
- 電文を登録するための一時テーブル

> **注意**: 共通アクションで保存した電文は、後続処理（常駐バッチ）で処理すること。

<details>
<summary>keywords</summary>

応答不要型メッセージ受信, 電文受信テーブル, 共通アクション, フォーマット定義ファイル, Formクラス, 電文保存, 一時テーブル

</details>

## クラス構造

![クラス構造](../../../knowledge/guide/mom-messaging/assets/mom-messaging-02_basic-04_Explanation_delayed_receive/class.png)

<details>
<summary>keywords</summary>

クラス構造, 応答不要型共通受信アクション, クラス図

</details>

## 処理の流れ

1. Nablarch Application Frameworkが受信した電文ごとに応答不要型共通受信アクションを起動する。
2. 応答不要型共通受信アクションが、フォーマット定義ファイルを元に電文を解析する。
3. 解析した電文からFormクラスを生成する。
4. SQLファイルから一時テーブルへ電文を登録するINSERT文を取得する。
5. FormクラスおよびINSERT文を使用して一時テーブルへ電文を保存する。

![シーケンス図](../../../knowledge/guide/mom-messaging/assets/mom-messaging-02_basic-04_Explanation_delayed_receive/sequence.png)

<details>
<summary>keywords</summary>

処理の流れ, 電文解析, Formクラス生成, INSERT文, 一時テーブル保存, シーケンス図

</details>
