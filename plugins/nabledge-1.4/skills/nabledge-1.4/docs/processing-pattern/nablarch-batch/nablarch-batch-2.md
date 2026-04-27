# データベースをインプットとするバッチ処理の場合で、精査が不要な場合でもEntityは作成する必要はありますか？

> **question:**
> データベースをインプットとして処理を行う場合で、インプットデータが処理済みの場合の処理の流れは以下のようになると思います。

> 1. >   入力データを受け取る。
> 2. >   データを出力する。(テーブルへのINSERTやUPDATE)

> このようなケースの場合、INSERTやUPDATE時にEntityは使用せずに1項目ずつsetStringやsetObjectを呼び出す想定でいます。
> イメージ的には、以下のような実装を想定しています。

> これは、実装方法として正しいのでしょうか？

> ```java
> @Override
> public Result handle(SqlRow inputData, ExecutionContext ctx) {
> 
>     // Entityは使用せずに1項目ずつ値をバインドする。
>     SqlPStatement statement = getSqlPStatement("INSERT_SQL");
>     statement.setString(1, inputData.getString("id"));
>     statement.setString(2, inputData.getString("name"));
>     statement.setString(3, inputData.getString("kana_name"));
>     statement.setString(4, inputData.getString("tel"));
>     statement.executeUpdate();
> 
>     return new Success();
> }
> ```

> **answer:**
> 精査が不要な場合でも、基本的にはEntityを生成してデータベースへのINSERTやUPDATE処理を行うようにしてください。

> なぜなら、保守性や生産性の面で1項目ずつ値を設定するよりもEntityを使用したデータベース更新(INSERTやUPDATE)のほうがメリットが大きいからです。
> また、1項目ずつ値を設定した場合、Nablarchのデータベースアクセス機能が提供する共通項目の設定機能も使用することができなくなってしまいます。

> 上記の **question** にある実装を、Entityを使用した実装に置き換えると以下のようになります。

> ```java
> @Override
> public Result handle(SqlRow inputData, ExecutionContext ctx) {
> 
>     // Entityを生成して、データベースの更新を行う。
>     ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_SQL");
>     statement.executeUpdateByObject(new SampleEntity(inputData));
> 
>     return new Success();
> }
> ```

> **related information:**
> * >   [データベースをインプットとするバッチ処理でも、画面処理と同じようにFormは必要ですか？](../../processing-pattern/nablarch-batch/nablarch-batch-6.md)
