# 同期応答型メッセージ受信処理のアプリケーション構造

## 概要

同期応答型メッセージ受信処理の主な特徴：

- **実装スタイルの統一**: バッチ・オンライン処理と同じ「要求を受け取って応答を返却する」スタイルでコーディング可能
- **イベントコールバック**: 開始時・エラー発生時・終了時の各イベントで対応メソッドが起動される。業務アプリケーションでのエラー処理漏れやリソース解放漏れを抑止できる
- **電文読み取り/書き込みの簡易化**: フォーマット定義ファイルにより物理的なレイアウトを意識したプログラミング不要。フィールド名指定で取得可能。Entityに変換することで型安全なプログラミングが可能
- **障害発生時の処理**: フレームワーク側で対処するため、業務処理はビジネスロジックに注力できる

<details>
<summary>keywords</summary>

MessagingAction, DbAccessSupport, 同期応答型メッセージ受信処理, イベントコールバック, 電文受信, 型安全なプログラミング, Entity

</details>

## 電文フォーマット定義ファイル

標準的なアプリケーションでは以下の3つのフォーマット定義ファイルを使用する。

1. **ヘッダーフォーマット定義**: アプリケーション制御情報を含む共通データ領域のフォーマット。リポジトリ定義ファイルにファイル名を指定。要求・応答双方で同じファイルを使用。

2. **要求電文フォーマット定義**: 要求電文中の業務データ領域のフォーマット。ファイル名: `(リクエストID)_RECEIVE.fmt`

3. **応答電文フォーマット定義**: 応答電文中の業務データ領域のフォーマット。ファイル名: `(リクエストID)_SEND.fmt`

<details>
<summary>keywords</summary>

_RECEIVE.fmt, _SEND.fmt, ヘッダーフォーマット定義, 要求電文フォーマット定義, 応答電文フォーマット定義, リクエストID

</details>

## クラス構造

**クラス**: `MessagingAction`を継承し、以下のメソッドを実装する。

> **補足**: `MessagingAction`は`DbAccessSupport`を継承しているため、サブクラスでも`DbAccessSupport`の機能を使ってデータベースアクセスが可能。

| メソッド | 概要 | 起動タイミング | 要否 |
|---|---|---|---|
| `ResponseMessage onReceive(RequestMessage request, ExecutionContext context)` | 電文受信時の処理 | 電文受信時 | 必須 |
| `ResponseMessage onError(Throwable e, RequestMessage request, ExecutionContext context)` | エラー発生時の処理 | `onReceive`メソッドでエラー発生時 | 必須 |

> **注意**: エラー発生時の処理はメイン処理とは別のトランザクションで実行される。メイン処理でエラーが発生した場合、そのトランザクションはロールバックされて終了するため。

<details>
<summary>keywords</summary>

MessagingAction, DbAccessSupport, onReceive, onError, RequestMessage, ExecutionContext, ResponseMessage, Throwable, クラス構造

</details>

## メソッド詳細

### 電文受信時のコールバック (`onReceive`)

`onReceive`メソッドを実装する（必須）。処理対象リクエストIDの要求電文受信時にフレームワークにより起動される。要求電文を引数として受け取り、処理結果の応答電文を戻り値として返却する。

### エラー発生時のコールバック (`onError`)

`onError`メソッドを実装する（必須）。メイン処理でエラー発生時のみ呼び出される。エラーが発生しなかった場合は起動されない。メイン処理で発生した例外またはエラー（`Throwable`）は本メソッドの引数で渡される。

> **注意**: `onError`の実装例:
> - エラーが発生したレコードのステータスを異常終了に更新する
> - 相手先システムにエラーを通知するためエラー電文を作成する

<details>
<summary>keywords</summary>

onReceive, onError, RequestMessage, ResponseMessage, ExecutionContext, Throwable, 電文受信コールバック, エラーコールバック

</details>

## 処理の流れ

Nablarch Application Frameworkは常駐して受信キューを監視する。要求電文が到達するたびに以下の処理が実行される：

1. フレームワーク制御ヘッダのリクエストIDをもとに業務アクションクラスを起動する
2. 業務アクションは要求電文を受け取り業務処理を実行し、応答電文を戻り値として返却する
3. Nablarch Application Frameworkは返却された応答電文を送信キューにPUTする

<details>
<summary>keywords</summary>

受信キュー監視, 送信キュー, リクエストID, 業務アクション, メッセージング処理フロー

</details>
