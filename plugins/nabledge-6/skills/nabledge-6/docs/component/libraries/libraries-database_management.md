# データベースアクセス

**公式ドキュメント**: [データベースアクセス](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database_management.html)

## データベースアクセス概要

データベースへの接続やSQL実行機能を提供する。以下の2種類が用意されている。

- :ref:`database`（JDBCのラッパー機能）
- :ref:`universal_dao`（ユニバーサルDAO）

両機能でSQLを実行できるが、以下の理由により :ref:`ユニバーサルDAO <universal_dao>` の使用を推奨する。

- CRUDのSQL文をEntityから自動的に生成しSQLが実行できる
- 検索結果がBeanオブジェクトとして取得できるため、IDEの補完機能が有効活用でき開発効率が良い

> **重要**: :ref:`ユニバーサルDAO <universal_dao>` を使用した場合でも、データベースへの接続やSQL実行は :ref:`JDBCのラッパー機能 <database>` を使用している。このため、:ref:`JDBCのラッパー機能 <database>` を使うための設定は必要になる。

> **補足**: :ref:`universal_dao` とJakarta Persistenceとの機能比較は、:ref:`database-functional_comparison` を参照。

<details>
<summary>keywords</summary>

データベースアクセス, ユニバーサルDAO, JDBCラッパー, SQL実行, データベース接続, universal_dao, database, functional_comparison

</details>
