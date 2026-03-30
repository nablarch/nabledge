# セッション並行アクセスハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.SessionConcurrentAccessHandler`

セッションスコープに対する並行アクセス制御をフレームワークレベルで実装するハンドラ。現バージョンではCONCURRENT同期ポリシーのみサポート。

> **警告**: 同期方式のMANUALとSERIALIZEは廃止。本ハンドラを使用する場合は排他ロックによる同期制御が必要なオブジェクトをセッションに格納しないこと。

**CONCURRENTポリシー**: スレッド毎のスナップショット（ディープコピー）をスレッドローカル変数に作成し、一貫読み取りと楽観ロック方式による書き込みを行う。リクエスト終了時にスナップショットの変更をセッションスコープに反映。セッションスコープが既に他スレッドによって変更されていた場合、変更を反映せずワーニングメッセージを登録する。

> **注意**: セッション変更反映失敗時もDBトランザクションは正常にコミットされる。`@ErrorOnSessionWriteConflict` アノテーションをリクエストハンドラに付与することで、セッション書込み失敗時に実行時例外を送出してDBトランザクションをロールバックさせることができる。

```java
public class SampleHandler implements Handler<HttpRequest, HttpResponse> {
    @ErrorOnSessionWriteConflict // セッションへの書込みに失敗した場合に実行時例外を送出する。
    public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
        SampleForm form = validate(req);
        Map<String, Object> results = doBusiness(form);
        ctx.setSessionScopedVar("results", results);
        return new HttpResponse("servlet://success.jsp");
    }
}
```

<details>
<summary>keywords</summary>

SessionConcurrentAccessHandler, nablarch.fw.handler.SessionConcurrentAccessHandler, @ErrorOnSessionWriteConflict, CopyOnReadMap, nablarch.core.util.map.CopyOnReadMap, セッション並行アクセス制御, CONCURRENTポリシー, 楽観ロック, セッションスナップショット

</details>

## ハンドラ処理フロー

**往路処理:**

1. セッション同期ポリシーに対応したセッションスコープのラッパーオブジェクトを作成し、実行コンテキストに設定する。
   - CONCURRENTポリシー: `nablarch.core.util.map.CopyOnReadMap`
2. 後続ハンドラに処理を委譲し結果を取得する。

**復路処理:**

3. （CONCURRENT）後続処理でセッションスコープへの変更があった場合、スナップショットをセッションスコープ本体に反映する。
4. 実行コンテキスト上のセッションスコープをもとのスコープに差し替える。
5. 処理結果をリターンして終了。

**例外処理:**

- 後続ハンドラ処理でエラー発生時も、3.と4.の処理を実行した後、例外を再送出する。
- （CONCURRENT）並行スレッドによって同一セッションの変更が既に反映されていた場合（論理排他エラー）、リクエストスコープ上にワーニングメッセージを登録する。`@ErrorOnSessionWriteConflict` アノテーションが付与されていた場合は実行時例外を送出する。

<details>
<summary>keywords</summary>

CopyOnReadMap, セッションスコープラッパー, 往路処理, 復路処理, 例外処理, 論理排他エラー, ハンドラ処理フロー, @ErrorOnSessionWriteConflict

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| concurrentAccessPolicy | String | | CONCURRENT | セッションスコープ並行アクセスポリシー |
| conflictWarningMessageId | String | | | セッション書込エラーメッセージID |

```xml
<component
  name="sessionConcurrentAccessHandler"
  class="nablarch.fw.handler.SessionConcurrentAccessHandler">
  <property
    name="concurrentAccessPolicy"
    value="CONCURRENT" />
</component>
```

<details>
<summary>keywords</summary>

concurrentAccessPolicy, conflictWarningMessageId, セッション並行アクセスポリシー, セッション書込エラーメッセージID, ハンドラ設定, SessionConcurrentAccessHandler, nablarch.fw.handler.SessionConcurrentAccessHandler

</details>
