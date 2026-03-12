# データベースアクセス

**公式ドキュメント**: [データベースアクセス](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database_management.html)

## データベースアクセス概要

データベースへの接続やSQL実行機能を提供する。以下の2種類が用意されている。

- [database](libraries-database.md)（JDBCのラッパー機能）
- [universal_dao](libraries-universal_dao.md)（ユニバーサルDAO）

両機能でSQLを実行できるが、以下の理由により [ユニバーサルDAO](libraries-universal_dao.md) の使用を推奨する。

- CRUDのSQL文をEntityから自動的に生成しSQLが実行できる
- 検索結果がBeanオブジェクトとして取得できるため、IDEの補完機能が有効活用でき開発効率が良い

> **重要**: [ユニバーサルDAO](libraries-universal_dao.md) を使用した場合でも、データベースへの接続やSQL実行は [JDBCのラッパー機能](libraries-database.md) を使用している。このため、[JDBCのラッパー機能](libraries-database.md) を使うための設定は必要になる。

> **補足**: [universal_dao](libraries-universal_dao.md) とJakarta Persistenceとの機能比較は、:ref:`database-functional_comparison` を参照。

<details>
<summary>keywords</summary>

データベースアクセス, ユニバーサルDAO, JDBCラッパー, SQL実行, データベース接続, universal_dao, database, functional_comparison

</details>
