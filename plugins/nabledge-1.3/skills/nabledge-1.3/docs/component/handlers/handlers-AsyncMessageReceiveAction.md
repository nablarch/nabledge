# 応答不要電文受信処理用アクションハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.action.AsyncMessageReceiveAction`

[../architectural_pattern/messaging_receive](../../processing-pattern/mom-messaging/mom-messaging-messaging_receive.md) における典型的な業務アクションハンドラ実装。受信電文のデータレコードを指定テーブルに保存する。保存されたデータは後続バッチで処理される。

**受信電文保存テーブル構造**

| 項目 | 内容 |
|---|---|
| 受信電文連番 | 主キー。`generateReceivedSequence()` で採番。桁数は任意。 |
| 業務電文部 | 電文の種類に応じた各項目のカラムを定義する。 |
| 共通項目部 | プロジェクト方式に応じたカラム（登録情報・更新情報など）。 |

> **注意**: 1電文を1レコードとして保存する前提。複数レコード登録や複数テーブル保存の場合は本クラスを継承した業務アクションハンドラクラスを別途作成すること。

<details>
<summary>keywords</summary>

AsyncMessageReceiveAction, nablarch.fw.messaging.action.AsyncMessageReceiveAction, generateReceivedSequence, 応答不要電文受信, 受信電文保存テーブル, 電文データ登録, 受信テーブル保存

</details>

## ハンドラ処理フロー

**往路処理**

1. デフォルトフォーマッタで要求電文の業務データ領域を解析し、データレコードを取得。
2. フォームクラスをロード: `[formClassPackage].[受信電文のリクエストIDヘッダ値]Form`
3. 設定された採番モジュールで受信電文連番を取得。
4. 下記コンストラクタでフォームインスタンスを生成:
   ```java
   public フォームクラス名(String 受信電文通番, RequestMessage 受信電文オブジェクト)
   ```
5. 下記SQLリソースのプリペアドステートメントをフォームインスタンスを埋め込みパラメータとして実行:
   `[SQLファイル配置パッケージ設定値].[受信電文のリクエストIDヘッダ値]#INSERD_MESSAGE`

**往路処理**

`Result.Success` を返して終了（後続ハンドラへの処理移譲なし）。

**例外処理**

- フォームクラスがクラスパス上に存在しない場合: 実行時例外を送出。
- コンストラクタが存在しない、またはコンストラクタ実行中にエラーが発生した場合: 実行時例外を送出。

<details>
<summary>keywords</summary>

RequestMessage, Result.Success, 往路処理, 例外処理, フォームクラスロード, 受信電文連番採番, INSERD_MESSAGE

</details>

## 設定項目・拡張ポイント

設定値は `AsyncMessageReceiveActionSettings` に集約されている。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| formClassPackage | String | ○ | | 電文データ登録に使用するフォームクラスのパッケージ名。 |
| receivedSequenceGenerator | IdGenerator | | | 受信電文連番発番用オブジェクト。デバッグや障害解析用に無効化可能。デフォルトはtrue（自動削除を実施）。 |

<details>
<summary>keywords</summary>

AsyncMessageReceiveActionSettings, formClassPackage, receivedSequenceGenerator, IdGenerator, 設定項目, 採番モジュール

</details>
