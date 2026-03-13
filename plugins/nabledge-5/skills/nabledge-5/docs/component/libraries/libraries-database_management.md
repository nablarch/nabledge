# データベースアクセス

**公式ドキュメント**: [データベースアクセス](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database_management.html)

## データベースアクセス概要

## データベースアクセス概要

Nablarchは2種類のDBアクセス機能を提供している:
- [JDBCのラッパー機能](libraries-database.md)
- [ユニバーサルDAO](libraries-universal_dao.md)

[ユニバーサルDAO](libraries-universal_dao.md) の使用を推奨する。理由:
- CRUDのSQL文をEntityから自動生成できる
- 検索結果がBeanオブジェクトとして取得でき、IDEの補完機能が活用できる

> **重要**: [ユニバーサルDAO](libraries-universal_dao.md) を使用した場合でも、DB接続・SQL実行は [JDBCのラッパー機能](libraries-database.md) を使用している。このため、[JDBCのラッパー機能](libraries-database.md) を使うための設定は必要になる。

> **補足**: [universal_dao](libraries-universal_dao.md) とJSR317(JPA2.0)との機能比較は、:ref:`database-functional_comparison` を参照。

<details>
<summary>keywords</summary>

データベースアクセス, ユニバーサルDAO, JDBCラッパー, universal_dao, database, データベース接続, SQL実行, CRUD自動生成, JSR317, JPA2.0

</details>
