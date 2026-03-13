# Nablarch 5u17 リリースノート

**公式ドキュメント**: [Nablarch 5u17 リリースノート](https://nablarch.github.io/docs/5u17/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html)

## 5u17 変更内容（5u16からの変更点）

## 5u17 変更内容（5u16からの変更点）

### アプリケーションフレームワーク

| No. | 分類 | リリース区分 | タイトル | 修正後バージョン | システムへの影響 |
|---|---|---|---|---|---|
| 1 | CSRF対策 | 変更 | CSRF対策機能を追加 | nablarch-fw-web 1.7.0 / nablarch-fw-web-tag 1.2.0 / nablarch-example-web 5u17 | なし |

**CSRF対策機能の追加（No.1）**

- 5u16で追加したデータベースを使用した二重サブミット防止機能は、ユーザーを識別せずにトークンをDBに格納するため、CSRF対策には使用できない。
- データベースを使用した二重サブミット防止機能を使用する場合は、CSRF対策として本機能（新規追加のCSRF対策機能）を使用すること。
- セッションを使用した二重サブミット防止機能を使っている場合は、そのままでもCSRF対策の効果があるため、移行は不要。
- Exampleのウェブアプリケーションも本機能を使用するよう変更済み。

参照: [CSRF対策ハンドラ](https://nablarch.github.io/docs/5u17/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html)

<details>
<summary>keywords</summary>

CSRF対策, CSRF対策機能, 二重サブミット防止, nablarch-fw-web, nablarch-fw-web-tag, セキュリティ, トークン, セッション, データベース

</details>

## バージョンアップ手順

## バージョンアップ手順

1. `pom.xml` の `<dependencyManagement>` セクションに指定されている `nablarch-bom` のバージョンを `5u17` に書き換える。
2. Mavenのビルドを再実行する。

<details>
<summary>keywords</summary>

バージョンアップ, nablarch-bom, pom.xml, dependencyManagement, Maven, 5u17

</details>
