# ■データベースアクセス機能の変更内容

|  |  | No | 変更点 | 変更内容 | 対応内容 | 参照先 |
|---|---|---|---|---|---|---|
|  |  | 1 | 設定追加 | RDBMSの差異を吸収するDialectクラスの設定が必須になりました。使用するDBに応じたDialectクラスを設定してください。 | 使用しているDbConnectionFactoryのクラスに、Dialectクラスの設定を追加します。 DbConnectionFactoryのクラス BasicDbConnectionFactoryForDataSource BasicDbConnectionFactoryForJndi | ■Dialect一覧 データベースアクセス(検索、更新、登録、削除)機能：データベース方言(Dialect)：Dialect一覧 ■Dialectの設定例 データベースアクセス(検索、更新、登録、削除)機能：データベース接続部品の構造：設定ファイル例(DataSourceを使用してデータベース接続を行う場合) データベースアクセス(検索、更新、登録、削除)機能：データベース接続部品の構造：設定ファイル例(JNDIを使用してデータベース接続を行う場合) |
|  |  | 2 | 設定削除 | Dialectクラスの追加に伴い、既存の設定内容のうち、Dialectクラスと重複する設定項目を削除しました。設定が残っていると、アプリケーションの起動時に、対象プロパティが存在しないためエラーとなります。削除された設定項目を設定ファイルから削除してください。 | ResultSetから値を取得するための変換クラスの設定を削除します。 クラス BasicStatementFactory プロパティ resultSetConvertor ※プロジェクト独自のResultSetConvertorをバージョンアップ後も使い続けるためには、以下の修正をあわせて行う必要があります。 以下の手順を参考にし、対応を実施してください。 ①プロジェクト独自のDialect実装クラスの作成 プロジェクトで使用するデータベース製品に対応したDialectを継承したプロジェクト用のDialect実装を作成します。(Oracleの場合は、OracleDialectを継承します） ②getResultSetConvertorをOverrideし、プロジェクトで使用しているResultSetConvertorのインスタンスを返します。 | なし |
|  |  | 3 |  |  | トランザクションタイムアウトと判定するSQLエラーコードの設定を削除します。 クラス JdbcTransactionFactory プロパティ transactionTimeoutErrorCodeList | なし |
|  |  | 4 |  |  | データベース接続チェックに使用するSQL文の設定を削除します。 クラス BasicDbAccessExceptionFactory プロパティ sql | なし |
|  |  | 5 |  |  | 一意制約違反のSQLState、一意制約違反のベンダー固有エラーコードの設定を削除します。 クラス BasicSqlStatementExceptionFactory プロパティ duplicateErrorSqlState duplicateErrorErrCode | なし |
|  |  | 6 | アーキテクト向け公開APIのインタフェース変更 ※データベースアクセス機能を拡張していない場合は対応不要です。 | Dialectをデータベースアクセス機能に横断的に適用するため、必要最小限の範囲で、アーキテクト向けに公開していたインタフェースを変更しました。 変更したインタフェースを実装している場合は、Nablarchが提供する基本実装クラスを参考に、修正してください。 | 変更したインタフェース ConnectionFactory ConnectionFactorySupport StatementFactory SqlStatementExceptionFactory TransactionManagerConnection DbAccessExceptionFactory | Javadocを参照しください。 |
