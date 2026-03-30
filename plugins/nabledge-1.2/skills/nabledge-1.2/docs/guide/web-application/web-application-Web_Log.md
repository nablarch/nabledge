# ログ出力の設定方法とログの見方(画面オンライン処理編)

## 開発時のログ出力の設定方法

画面オンライン処理の開発時に出力するログの種類:

| ログの種類 | 説明 |
|---|---|
| HTTPアクセスログ | 実行状況・性能測定・負荷測定に必要な情報を出力。全リクエスト/レスポンス情報を出力する証跡ログとしても使用。詳細は :ref:`HttpAccessLog` 参照。 |
| SQLログ | SQL文の実行時間とSQL文を出力（パフォーマンスチューニング用）。詳細は :ref:`SqlLog` 参照。 |
| 開発ログ | アプリケーションプログラマが開発時に必要な情報をDEBUGレベルで出力。 |

開発時のログ出力設定で指定すべき項目（標準出力＝EclipseのConsoleビューへの出力）:

1. 出力先として標準出力を追加する
2. 開発時にデバッグ用に埋め込んだログを標準出力に出力する
3. HTTPアクセスログを標準出力に出力する
4. SQLログを標準出力に出力する
5. 開発ログを標準出力に出力する

![ログ出力設定例](../../../knowledge/guide/web-application/assets/web-application-Web_Log/Web_Log_LogProp.jpg)

<details>
<summary>keywords</summary>

HTTPアクセスログ, SQLログ, 開発ログ, 標準出力設定, ログ出力設定, DEBUGレベル, EclipseのConsoleビュー, 証跡ログ, パフォーマンスチューニング

</details>

## 開発時のログの見方

> **注意**: 上記ケースでエラーが発生するものについては、あくまで一例であり、全てのケースを網羅しているわけではない。実際の開発時は、:ref:`Web_Log_NormalLog` を参考に、デバッグ作業に必要な情報を収集する。

### 正常完了時（ログイン処理の例）

1リクエスト処理のログ出力順序: アクション実行前 → アクション実行中 → アクション実行後。デバッグ作業に必要な情報収集の基本となる。

> **注意**: HTTPアクセスログとSQLログのフォーマットはデフォルトフォーマットを使用した場合の出力例。

ログイン処理の画面遷移: ![ログイン画面遷移](../../../knowledge/guide/web-application/assets/web-application-Web_Log/Web_Log_LoginWindow.jpg)

- アクション実行前のログ: ![アクション実行前](../../../knowledge/guide/web-application/assets/web-application-Web_Log/Web_Log_LoginLogBefore.jpg)
- アクション実行中のログ: ![アクション実行中](../../../knowledge/guide/web-application/assets/web-application-Web_Log/Web_Log_LoginLogRunning.jpg)
- アクション実行後のログ: ![アクション実行後](../../../knowledge/guide/web-application/assets/web-application-Web_Log/Web_Log_LoginLogAfter.jpg)

### JSPで例外が発生した場合

「リクエスト処理の終了（END）」の後にスタックトレースが出力される。

![JSPエラーログ](../../../knowledge/guide/web-application/assets/web-application-Web_Log/Web_Log_JspErrorLog.jpg)

### リクエストURLに対応するアクションが見つからない場合

「ディスパッチ先クラス（DISPATCHING CLASS）」の後にスタックトレースが出力される。

![アクションなしログ](../../../knowledge/guide/web-application/assets/web-application-Web_Log/Web_Log_NoActionLog.jpg)

### リクエストURLに対応するアクションのメソッドが見つからない場合

「ディスパッチ先メソッド（DISPATCHING METHOD）」にエラーメッセージが出力される。

```bash
method not found. class = [nablarch.sample.management.user.UserSearchAction], method signature = [HttpResponse dousers00101(HttpRequest, ExecutionContext)]
```

![アクションメソッドなしログ](../../../knowledge/guide/web-application/assets/web-application-Web_Log/Web_Log_NoActionMethodLog.jpg)

<details>
<summary>keywords</summary>

ログの見方, スタックトレース, DISPATCHING CLASS, DISPATCHING METHOD, JSP例外, アクション未検出, method not found, ログ出力順序, リクエスト処理, HttpResponse, HttpRequest, ExecutionContext

</details>
