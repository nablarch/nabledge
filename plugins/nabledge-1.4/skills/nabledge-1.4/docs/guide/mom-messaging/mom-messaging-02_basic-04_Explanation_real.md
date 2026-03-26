# 同期応答型メッセージ受信処理のアプリケーション構造

## クラス構造

## クラス構造

`MessagingAction` を継承し、以下のメソッドを実装する。

| メソッド | 概要 | 起動タイミング | 要否 |
|---|---|---|---|
| `ResponseMessage onReceive(RequestMessage request, ExecutionContext context)` | 電文受信時の処理を行う。 | 電文受信時 | 必須 |
| `ResponseMessage onError(Throwable e, RequestMessage request, ExecutionContext context)` | エラー発生時の処理を行う。 | onReceiveメソッドでエラー発生時 | 必須 |

> **注**: MessagingAction は `DbAccessSupport` を継承しているため、サブクラスでも DbAccessSupport の機能を用いてデータベースアクセスを行うことができる。

<details>
<summary>keywords</summary>

MessagingAction, DbAccessSupport, onReceive, onError, ResponseMessage, RequestMessage, ExecutionContext, Throwable, クラス構造, 継承

</details>

## 電文フォーマット定義ファイル

## 電文フォーマット定義ファイル

標準的なアプリケーションでは、以下の3つのフォーマット定義ファイルを使用する。

1. **ヘッダーフォーマット定義** — アプリケーション制御情報を含む共通データ領域のデータフォーマットを定義する。リポジトリ定義ファイルにファイル名を指定する。なお、ヘッダーフォーマット定義ファイルは要求・応答双方で同じものを使用する。

2. **要求電文フォーマット定義** — 要求電文中の業務データ領域のデータフォーマットを定義する。定義ファイルの名称は **(リクエストID) + `_RECEIVE.fmt`** となる。

3. **応答電文フォーマット定義** — 応答電文中の業務データ領域のデータフォーマットを定義する。定義ファイルの名称は **(リクエストID) + `_SEND.fmt`** となる。

<details>
<summary>keywords</summary>

_RECEIVE.fmt, _SEND.fmt, リクエストID, ヘッダーフォーマット定義, 要求電文フォーマット定義, 応答電文フォーマット定義, 電文フォーマット定義

</details>

## 処理の流れ

## 処理の流れ

Nablarch Application Framework は常駐して受信キューを監視する。要求電文が到達するたびに、以下の処理が実行される。

1. Nablarch Application Framework はフレームワーク制御ヘッダのリクエストIDをもとに、業務アクションクラスを起動する。
2. 業務アクションは、要求電文を受け取り業務処理を実行し、応答電文を戻り値として返却する。
3. Nablarch Application Framework は、返却された応答電文を送信キューにPUTする。

<details>
<summary>keywords</summary>

リクエストID, 業務アクション, 送信キュー, 受信キュー, 処理の流れ, フレームワーク制御ヘッダ

</details>

## 電文受信時のコールバック

## 電文受信時のコールバック

`onReceive` メソッドを実装する（必須）。

**メソッド**: `ResponseMessage onReceive(RequestMessage request, ExecutionContext context)`

処理対象リクエストIDの要求電文受信時にフレームワークにより起動される。要求電文を引数として受け取り、処理結果の応答電文を戻り値として返却する。

<details>
<summary>keywords</summary>

onReceive, RequestMessage, ResponseMessage, ExecutionContext, MessagingAction, 電文受信コールバック, 同期応答型メッセージ受信

</details>

## エラー発生時のコールバック

## エラー発生時のコールバック

`onError` メソッドを実装する（必須）。

**メソッド**: `ResponseMessage onError(Throwable e, RequestMessage request, ExecutionContext context)`

メイン処理でエラー発生時のみ呼び出される。エラーが発生しなかった場合は起動されない。メイン処理で発生した例外またはエラーは引数で渡される。

エラー発生時の処理はメイン処理とは別のトランザクションで実行される（メイン処理でエラーが発生した場合、そのトランザクションはロールバックされて終了するため）。

> **注意**: 実装すべき処理の例:
> - エラーが発生したレコードのステータスを異常終了に更新する
> - 相手先システムにエラーを通知するためのエラー電文を作成する

<details>
<summary>keywords</summary>

onError, RequestMessage, ResponseMessage, ExecutionContext, Throwable, エラーコールバック, トランザクションロールバック, エラー電文

</details>

## 概要

## 概要

Nablarch Application Framework では、複雑になりがちなメッセージング処理を簡潔かつ堅牢に作成できるように以下の機能を備えている。

- **Nablarch共通の実装方法** — 通常、メッセージング処理の実装では MessageDrivenBean に代表されるように、バッチやオンライン処理とは全く異なる業務実装が要求されることが多い。Nablarch ではこのような差異が抽象化されており、バッチやオンライン処理と同様に「要求を受け取って応答を返却する」という同一のスタイルでコーディングができる。

- **開始時・エラー発生時・終了時の各イベント時のコールバック** — 各イベント発生時にフレームワーク側から対応するメソッドが起動される。これにより、業務アプリケーションでのエラー処理漏れやリソース解放漏れを抑止できる。

- **電文読み取り・書き込みの簡易化** — 設計書から自動生成されたフォーマット定義ファイルを使用することで、物理的なレイアウトを意識したプログラミングが不要になる。「レコード先頭xバイト目からxバイト分を半角数字として取得」するような処理をプログラム上で記述する必要がなく、単に引数で与えられた入力データからフィールド名を指定して取得するだけでよい。また、Entity に変換することで型安全なプログラミングが可能となる。

- **障害発生時の処理** — 障害発生時の考慮がフレームワーク側で行われているため、業務処理ではビジネスロジックに注力できる。

<details>
<summary>keywords</summary>

Nablarch共通の実装方法, バッチ, オンライン処理, コールバック, エラー処理漏れ, リソース解放漏れ, 電文読み取り, 電文書き込み, フィールド名, Entity, 型安全, 障害発生, ビジネスロジック, メッセージング処理

</details>
