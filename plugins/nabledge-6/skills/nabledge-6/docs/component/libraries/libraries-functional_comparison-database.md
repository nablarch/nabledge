# ユニバーサルDAOとJakarta Persistenceとの機能比較

## ユニバーサルDAOとJakarta Persistenceとの機能比較

> **重要**: ユニバーサルDAOでは、JPAで定義されているアノテーションのうち、:ref:`universal_dao_jpa_annotations` に記載のあるものだけをサポートしている。ここに記載のないアノテーションに関連する機能については、使用できない。

機能比較（○：提供あり　△：一部提供あり　×：提供なし　－：対象外）

| 機能 | ユニバーサルDAO | Jakarta Persistence |
|---|---|---|
| リレーションシップに対応できる | × [1] | ○ |
| Entityを元にCRUDが実行できる（SQLを作成することなく） | ○ :ref:`解説書へ <universal_dao-execute_crud_sql>` | ○ |
| 検索結果をJava Beansオブジェクトとして取得できる | ○ :ref:`解説書へ <universal_dao-bean_mapping>` | ○ |
| 任意のSQL文を実行できる | ○ :ref:`解説書へ <universal_dao-sql_file>` | ○ |
| SQLの動的組み立てができる | △ [2] :ref:`解説書へ <universal_dao-sql_file>` | ○ |
| バッチ実行ができる | ○ :ref:`解説書へ <universal_dao-batch_execute>` | × |
| 大量データを取得する際に遅延ロードができる（ヒープを圧迫せずに大量データを処理できる） | ○ :ref:`解説書へ <universal_dao-lazy_load>` | × |
| ページング用の範囲指定の検索ができる | ○ :ref:`解説書へ <universal_dao-paging>` | ○ |
| サロゲートキーの値を採番できる | ○ :ref:`解説書へ <universal_dao-generate_surrogate_key>` | ○ |
| EntityをDBに反映時にJakarta Bean Validationが実行できる | × [3] | ○ |
| データベースアクセス前後に任意の処理（コールバック）を実行できる | × [4] | ○ |
| 排他制御ができる | △ [5] :ref:`解説書へ(楽観ロック) <universal_dao_jpa_optimistic_lock>` / :ref:`解説書へ(悲観ロック) <universal_dao_jpa_pessimistic_lock>` | ○ |

[1] リレーションシップがあるテーブルの検索はSQLを作成することで対応できる。登録、更新、削除については、テーブル毎に必要な処理を呼び出すことで対応する。
[2] ユニバーサルDAOでは、条件及びソート項目に限り動的な組み立てができる。詳細は :ref:`SQLの動的組み立て <database-variable_condition>` を参照。
[3] Nablarchでは、外部からのデータを受け付けたタイミングでバリデーションを実施し、バリデーションエラーがない場合のみEntityへ変換しデータベースへ保存する。
[4] 任意の処理が必要となる場合は、ユニバーサルDAOを呼び出す側で処理を行うことで対応する。
[5] ユニバーサルDAOでは、楽観的ロックのみサポートする。悲観的ロックやJakarta Persistenceで定義されている検索時のロックモードの指定などはサポートしない。悲観的ロックは `select for update` などを使用することで実現できる。
