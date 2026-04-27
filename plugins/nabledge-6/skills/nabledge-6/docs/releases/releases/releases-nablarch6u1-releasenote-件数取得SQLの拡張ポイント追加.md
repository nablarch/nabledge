# ■件数取得SQLの拡張ポイント追加

【変更点】
ページング処理で使用する件数取得SQLを変更するための拡張ポイントを追加しました。
これにより、性能劣化への対応等で件数取得SQLを変更したい場合に、自動生成されるSQLから任意のSQLに差し替えることが可能になりました。
この対応を行うため、以下の変更を実施しています。
●DialectインタフェースにconvertCountSql(String, Object, StatementFactory)メソッドを追加
（参考）https://nablarch.github.io/docs/6u1/doc/application_framework/application_framework/libraries/database/database.html#database-dialect
●DefaultDialectクラスに、上記メソッドの実装を追加
【変更による影響有無の確認方法】
プロジェクトで独自にダイアレクトを作成しているか、確認してください。
独自のダイアレクトを作成していない場合は、影響ありません。
独自のダイアレクトを作成している場合でも、解説書に記載の通りDefaultDialectを継承して実装していれば、影響ありません。
（参考）https://nablarch.github.io/docs/6u1/doc/application_framework/application_framework/libraries/database/database.html#database-add-dialect
一方、DeafultDialectを継承せずにDialectインタフェースを直接実装して独自のダイアレクトを作成している場合は、
Dialectインタフェースに追加したメソッドの実装が存在しないため、コンパイルエラーが発生します。
【影響があった場合の対応方法】
プロジェクトで独自に作成したダイアレクトで、以下の通りconvertCountSql(String, Object, StatementFactory)メソッドを実装してください。
@Override
public String convertCountSql(String sqlId, Object condition, StatementFactory statementFactory) {
return convertCountSql(statementFactory.getVariableConditionSqlBySqlId(sqlId, condition));
}
これによりコンパイルエラーが解消され、件数取得SQLはバージョンアップ前と同じになります。
件数取得SQLを差し替えたい場合は、解説書を参考に上記メソッドの実装を変更してください。
