# 応答不要電文受信処理用アクションハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.action.AsyncMessageReceiveAction`

[../architectural_pattern/messaging_receive](../../processing-pattern/mom-messaging/mom-messaging-messaging_receive.md) における典型的な業務アクションハンドラ。受信電文内のデータレコードを指定テーブルに保存する。保存データは後続バッチで処理されることを想定。

**受信電文保存テーブルの構造**

| 項目 | 内容 |
|---|---|
| 受信電文連番 | 主キー。受信電文を一意に識別するID。`generateReceivedSequence()`で採番。桁数任意。 |
| 業務電文部 | 電文の種類に応じた各項目のカラムを定義。 |
| 共通項目部 | 登録情報(ユーザID、タイムスタンプ、リクエストID、実行時ID)、更新情報(ユーザID、タイムスタンプ)など。 |

> **重要**: 本クラスは1電文を1レコードとして受信テーブルに保存することを前提とする。1電文を複数レコード登録する場合や複数テーブルに保存する場合は、本クラスを継承した業務アクションハンドラクラスを別途作成する必要がある。

<details>
<summary>keywords</summary>

AsyncMessageReceiveAction, nablarch.fw.messaging.action.AsyncMessageReceiveAction, 応答不要電文受信, 受信電文保存テーブル, 非同期メッセージ受信, 受信電文連番, generateReceivedSequence

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 要求電文の業務データ領域全体をデフォルトのフォーマッタで解析し、データレコードを取得。
2. 以下のパターンでフォームクラスをロード。
   ```
   [フォームクラス配置パッケージ設定値] + "." + [受信電文のリクエストIDヘッダ値] + "Form"
   ```
3. 採番モジュールで受信電文通番を取得。
4. 以下コンストラクタでフォームインスタンスを生成。引数は受信電文通番と受信電文オブジェクト。
   ```java
   public フォームクラス名(String 受信電文通番, RequestMessage 受信電文オブジェクト)
   ```
5. 以下のSQLファイルからプリペアドステートメントを作成し、フォームインスタンスを埋め込みパラメータとして実行。
   ```
   [SQLファイル配置パッケージ設定値] + "." + [受信電文のリクエストIDヘッダ値] + "#INSERD_MESSAGE"
   ```

**[正常終了]**

`Result.Success` をリターンして終了。後続ハンドラへの処理移譲は行わない。

**[例外処理]**

- フォームクラスがクラスパス上に存在しない場合: 実行時例外を送出。
- フォームクラスのコンストラクタが存在しない、またはコンストラクタ実行中にエラーが発生した場合: 実行時例外を送出。

<details>
<summary>keywords</summary>

RequestMessage, Result.Success, フォームクラスロード, 受信電文連番採番, ハンドラ処理フロー, 往路処理, 例外処理

</details>

## 設定項目・拡張ポイント

設定値は `AsyncMessageReceiveActionSettings` に集約されている。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| sqlFilePackage | String | ○ | | SQL定義ファイルを格納するパッケージ名 |
| formClassPackage | String | ○ | | フォームクラスのパッケージ名 |
| formClassSuffix | String | | "Form" | フォームクラスのサフィックス |
| receivedSequenceGenerator | IdGenerator | | | 受信電文連番発番用オブジェクト。デバッグや障害解析用に無効化することができる。 |
| receivedSequenceFormatter | IdFormatter | ○ | | 受信電文連番採番時のフォーマッタクラス |
| targetGenerateId | String | ○ | | 受信電文連番採番時に使用するID |
| dbTransactionName | String | | "transaction" | 受信テーブル登録処理で使用するトランザクション識別名 |

<details>
<summary>keywords</summary>

AsyncMessageReceiveActionSettings, sqlFilePackage, formClassPackage, formClassSuffix, receivedSequenceGenerator, receivedSequenceFormatter, targetGenerateId, dbTransactionName, IdGenerator, IdFormatter

</details>
