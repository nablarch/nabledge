# ユニバーサルDAOとJSR317(JPA2.0)との機能比較

**公式ドキュメント**: [ユニバーサルDAOとJSR317(JPA2.0)との機能比較](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/functional_comparison.html)

## ユニバーサルDAOとJSR317(JPA2.0)との機能比較

> **重要**: ユニバーサルDAOは、JPAで定義されているアノテーションのうち :ref:`universal_dao_jpa_annotations` に記載のあるものだけをサポートする。記載のないアノテーションに関連する機能は使用不可。

| 機能 | ユニバーサルDAO | JSR317 |
|---|---|---|
| リレーションシップに対応 | × [1] | ○ |
| EntityベースのCRUD実行（SQL作成不要） | ○ [解説書へ](libraries-universal_dao.md) | ○ |
| 検索結果をJava Beansオブジェクトとして取得 | ○ [解説書へ](libraries-universal_dao.md) | ○ |
| 任意のSQL文を実行 | ○ [解説書へ](libraries-universal_dao.md) | ○ |
| SQLの動的組み立て | △ [2] [解説書へ](libraries-universal_dao.md) | ○ |
| バッチ実行 | ○ [解説書へ](libraries-universal_dao.md) | × |
| 大量データの遅延ロード（ヒープ圧迫なし） | ○ [解説書へ](libraries-universal_dao.md) | × |
| ページング用範囲指定検索 | ○ [解説書へ](libraries-universal_dao.md) | ○ |
| サロゲートキーの採番 | ○ [解説書へ](libraries-universal_dao.md) | ○ |
| EntityのDB反映時にBean Validationを実行 | × [3] | ○ |
| DBアクセス前後に任意処理（コールバック）を実行 | × [4] | ○ |
| 排他制御 | △ [5] :ref:`解説書へ(楽観ロック) <universal_dao_jpa_optimistic_lock>` :ref:`解説書へ(悲観ロック) <universal_dao_jpa_pessimistic_lock>` | ○ |

[1] リレーションシップのあるテーブルの検索はSQLを作成することで対応可能。登録・更新・削除はテーブル毎に必要な処理を呼び出すことで対応する。
[2] 条件及びソート項目に限り動的な組み立てができる。詳細は [database-variable_condition](libraries-database.md) を参照。
[3] Nablarchでは外部からのデータを受け付けたタイミングでバリデーションを実施し、エラーがない場合のみEntityへ変換してDBに保存する。
[4] 任意の処理が必要な場合は、ユニバーサルDAOを呼び出す側で処理を行うことで対応する。
[5] 楽観的ロックのみサポート。悲観的ロックやJSRで定義されている検索時のロックモードの指定はサポートしない。悲観的ロックは `select for update` などを使用することで実現できる。

<details>
<summary>keywords</summary>

ユニバーサルDAO, JSR317, JPA2.0, 機能比較, リレーションシップ, CRUD, バッチ実行, 遅延ロード, ページング, 排他制御, 楽観的ロック, 悲観的ロック, SQLの動的組み立て, Bean Validation, コールバック, サロゲートキー

</details>
