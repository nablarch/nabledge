# セッション並行アクセスハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.SessionConcurrentAccessHandler`

セッションスコープは複数のリクエストスレッドから並行アクセスされる可能性がある。セッション変数単体の読み書きについてはスレッドセーフであることが保証されるものの、セッションオブジェクト全体の整合性については保証されない。本ハンドラはセッションスコープへの並行アクセス制御をフレームワークレベルで実装することで、この整合性を保証する。現バージョンはCONCURRENT同期ポリシーのみサポート。

> **警告**: MANUALとSERIALIZEは廃止。排他ロックによる同期制御が必要なオブジェクトはセッションに格納しないこと。

**CONCURRENTポリシー**: スレッド毎にセッションスコープのスナップショット（ディープコピー）をスレッドローカルに作成し、一貫読み取りと楽観ロック書き込みを行う。リクエスト終了時にスナップショットをセッションスコープ本体に反映。他スレッドが既に変更していた場合は反映せずワーニングメッセージを登録。

> **注意**: セッション変更反映失敗時もDBトランザクションは正常コミットされる。**@ErrorOnSessionWriteConflict** アノテーションをリクエストハンドラに付与することで、セッション書込失敗時に実行時例外を送出してDBトランザクションをロールバックさせることができる。

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

SessionConcurrentAccessHandler, nablarch.fw.handler.SessionConcurrentAccessHandler, @ErrorOnSessionWriteConflict, セッション並行アクセス制御, CONCURRENTポリシー, 楽観ロック, セッションスコープ, スレッドセーフ, セッションオブジェクト整合性

</details>

## ハンドラ処理フロー

**往路処理**

1. セッションスコープラッパーの作成: 同期ポリシーに対応したラッパーを作成し実行コンテキストに設定。CONCURRENT → `nablarch.core.util.map.CopyOnReadMap`
2. 後続ハンドラの実行

**復路処理**

3. (CONCURRENT) スナップショットの変更内容をセッションスコープ本体に反映
4. 実行コンテキスト上のセッションスコープを元のスコープに差し替え
5. 処理結果をリターンして終了

**例外処理**

2a. 後続ハンドラで例外が送出された場合も、上記3・4の処理を実行した後、例外を再送出
3a. (CONCURRENT) 並行スレッドが同一セッションを既に変更していた場合、リクエストスコープにワーニングメッセージを登録。業務アクションに **@ErrorOnSessionWriteConflict** が付与されていれば実行時例外を送出する。

<details>
<summary>keywords</summary>

CopyOnReadMap, nablarch.core.util.map.CopyOnReadMap, ハンドラ処理フロー, 往路処理, 復路処理, セッションスコープラッパー, @ErrorOnSessionWriteConflict

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

concurrentAccessPolicy, conflictWarningMessageId, ハンドラ設定, セッション書込エラーメッセージ

</details>
