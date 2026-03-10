# セッション並行アクセスハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/session_concurrent_access_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/SessionConcurrentAccessHandler.html)

## ハンドラクラス名

> **重要**: 新規プロジェクトにおける本ハンドラの使用は推奨しない。セッション変数保存ハンドラを使用すること。

セッションごとにリクエスト処理の並行同時アクセスに対してスレッド間の処理不整合を防ぐ。

処理内容:
1. セッションに保持した情報のコピーを作成する
2. 処理終了後、他のスレッドによってセッションが更新されていないかチェックし、更新済みであればエラーとする
3. 処理終了後、セッション情報のコピーをセッションに反映する

**クラス名**: `nablarch.fw.web.handler.SessionConcurrentAccessHandler`

<details>
<summary>keywords</summary>

SessionConcurrentAccessHandler, nablarch.fw.web.handler.SessionConcurrentAccessHandler, セッション並行アクセス制御, スレッド処理不整合防止, セッション排他制御, 並行アクセス制御, 非推奨ハンドラ

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, com.nablarch.framework, モジュール依存関係

</details>

## 制約

なし。

<details>
<summary>keywords</summary>

制約なし, 使用制限なし

</details>
