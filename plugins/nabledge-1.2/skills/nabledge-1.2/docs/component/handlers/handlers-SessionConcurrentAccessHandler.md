# セッション並行アクセスハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.SessionConcurrentAccessHandler`

セッションスコープに対する並行アクセス制御をフレームワークレベルで実装するハンドラ。

> **警告**: 同期方式のMANUALとSERIALIZEは廃止された。本ハンドラを使用する場合は排他ロックによる同期制御が必要なオブジェクトをセッションに格納しないこと。

現バージョンではCONCURRENT同期ポリシーのみサポート。

**CONCURRENTポリシー**:
- リクエストスレッドがセッションスコープ変数にアクセスした時点で、スナップショット（ディープコピー）をスレッドローカル変数上に作成。
- 以降の当該リクエストスレッドからのアクセスはスナップショットに対して行われる。
- スナップショットに変更を加えた場合、リクエスト終了時にセッションスコープに反映される。
- セッションスコープが既に他のリクエストスレッドによって変更されていれば、変更反映は行わずワーニングメッセージを登録する。
- ラッパークラス: `nablarch.core.util.map.CopyOnReadMap`

> **注意**: セッションスコープの変更反映に失敗した場合でも、DBのトランザクションは正常にコミットされる。**@ErrorOnSessionWriteConflict** をリクエストハンドラに付与することで、セッションへの書込み失敗時に実行時例外を送出させDBトランザクションをロールバックさせることができる。

**アノテーション**: `@ErrorOnSessionWriteConflict`

```java
public class SampleHandler implements Handler<HttpRequest, HttpResponse> {
    @ErrorOnSessionWriteConflict
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

SessionConcurrentAccessHandler, nablarch.fw.handler.SessionConcurrentAccessHandler, CopyOnReadMap, nablarch.core.util.map.CopyOnReadMap, @ErrorOnSessionWriteConflict, セッション並行アクセス制御, CONCURRENTポリシー, 楽観ロック, セッションスナップショット

</details>

## ハンドラ処理フロー

**往路処理**:
1. セッション同期ポリシー(CONCURRENT)に対応したセッションスコープのラッパーオブジェクト(`nablarch.core.util.map.CopyOnReadMap`)を作成し実行コンテキストに設定。
2. 後続ハンドラに処理を委譲し結果を取得。

**復路処理**:
3. 同期ポリシーがCONCURRENTの場合、セッションスコープへの変更内容をセッションスコープ本体に反映。
4. 実行コンテキスト上のセッションスコープをもとのスコープに差し替え。
5. 2.で取得した処理結果をリターンして終了。

**例外処理**:
- 2a. 後続ハンドラ処理中に例外が発生した場合でも、3.と4.の処理を実行した後、例外を再送出する。
- 3a. CONCURRENTポリシーで、セッション変更反映時に並行スレッドによる同一セッション変更が既に反映されていた場合、リクエストスコープ上にワーニングメッセージを登録する。業務アクションに`@ErrorOnSessionWriteConflict`が付与されていた場合は実行時例外を送出する。

<details>
<summary>keywords</summary>

SessionConcurrentAccessHandler, @ErrorOnSessionWriteConflict, ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, セッション変更反映

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

SessionConcurrentAccessHandler, concurrentAccessPolicy, conflictWarningMessageId, セッション並行アクセスポリシー, セッション書込エラーメッセージID

</details>
