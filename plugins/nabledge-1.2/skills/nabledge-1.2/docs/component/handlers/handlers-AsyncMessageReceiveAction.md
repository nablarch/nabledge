# 応答不要電文受信処理用アクションハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.action.AsyncMessageReceiveAction`

[../architectural_pattern/messaging_receive](../../processing-pattern/mom-messaging/mom-messaging-messaging_receive.md) における典型的な業務アクションハンドラの実装。受信電文内のデータレコードを指定されたテーブルに保存する。保存されたデータは後続のバッチによって処理される。

**受信電文保存テーブルの構造**

| 項目 | 内容 |
|---|---|
| 受信電文連番 | 主キー。受信電文を一意に識別するID。値は `generateReceivedSequence()` で採番。カラムの桁数は任意。 |
| 業務電文部 | 電文の種類に応じた業務電文の各項目に対するカラム |
| 共通項目部 | プロジェクトの方式に応じたカラム（登録情報・更新情報など） |

> **重要**: 本クラスは1電文を1レコードとして受信テーブルに保存することを前提とする。1電文を複数レコードとして登録する場合や複数テーブルに保存する場合は、本クラスを継承した業務アクションハンドラクラスを別途作成すること。

<details>
<summary>keywords</summary>

AsyncMessageReceiveAction, nablarch.fw.messaging.action.AsyncMessageReceiveAction, generateReceivedSequence, 応答不要電文受信, 受信電文保存テーブル, メッセージング, 受信テーブル

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 要求電文の業務データ領域全体をデフォルトのフォーマッタで解析し、データレコードを取得
2. フォームクラスのロード: `[formClassPackage].[リクエストIDヘッダ値]Form`
3. 設定された採番モジュールを使用して受信電文連番を採番
4. フォームインスタンスを以下のコンストラクタで生成: `public フォームクラス名(String 受信電文通番, RequestMessage 受信電文オブジェクト)`
5. SQLファイルからプリペアードステートメントを作成してフォームインスタンスを埋め込みパラメータとして実行: `[SQLファイル配置パッケージ].[リクエストIDヘッダ値]#INSERD_MESSAGE`
6. `Result.Success` を返して終了（後続ハンドラへの処理移譲は行わない）

**[例外処理]**

- **2a（フォームクラスロードエラー）**: フォームクラスがクラスパス上に存在しない場合 → 実行時例外を送出
- **3a（フォームインスタンス生成エラー）**: コンストラクタが存在しない、またはコンストラクタ実行中にエラーが発生した場合 → 実行時例外を送出

<details>
<summary>keywords</summary>

Result.Success, RequestMessage, ハンドラ処理フロー, フォームクラスロード, 受信電文連番採番, SQL実行, 往路処理, 例外処理

</details>

## 設定項目・拡張ポイント

設定値は `AsyncMessageReceiveActionSettings` に集約されている。

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| formClassPackage | String | ○ | 電文データ登録の際に使用するフォームクラスのパッケージ名 |
| receivedSequenceGenerator | IdGenerator | | 受信電文連番発番用オブジェクト（任意指定）。デバッグや障害解析用に無効化する。デフォルトはtrue（自動削除を実施） |

<details>
<summary>keywords</summary>

AsyncMessageReceiveActionSettings, IdGenerator, formClassPackage, receivedSequenceGenerator, 設定項目, フォームクラスパッケージ, 採番モジュール

</details>
