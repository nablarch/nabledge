# データベースアクセス

データベースへの接続や、SQLを実行する機能を提供する。

Nablarchでは、以下の2種類のデータベースアクセス機能を提供している。

* [データベースアクセス(JDBCラッパー)](../../component/libraries/libraries-database.md)
* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md)

上記のどちらの機能を使用した場合でも、SQLを実行できるが、
以下の理由により [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao) を使用することを推奨する。

* CRUDのSQL文をEntityから自動的に生成しSQLが実行できる
* 検索結果がBeanオブジェクトとして取得できるため、IDEの補完機能が有効活用でき開発効率が良い

> **Important:**
> [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao) を使用した場合でも、
> データベースへの接続やSQL実行は [JDBCのラッパー機能](../../component/libraries/libraries-database.md#データベースアクセスjdbcラッパー) を使用している。
> このため、 [JDBCのラッパー機能](../../component/libraries/libraries-database.md#データベースアクセスjdbcラッパー) を使うための設定などは必要になる。

> **Tip:**
> [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao) とJSR317(JPA2.0)との機能比較は、 [ユニバーサルDAOとJSR317(JPA2.0)との機能比較](../../component/libraries/libraries-database-functional-comparison.md#ユニバーサルdaoとjsr317jpa20との機能比較) を参照。

* [ユニバーサルDAOとJSR317(JPA2.0)との機能比較](../../component/libraries/libraries-database-functional-comparison.md)
