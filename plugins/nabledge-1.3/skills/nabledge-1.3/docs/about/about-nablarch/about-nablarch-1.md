# SqlRow等のMap実装クラスからEntityやFormを生成する方法を教えてください

> **question:**
> SqlRow等のMap実装クラスからEntityやFormを生成する方法は、
> 以下の2種類の実装があると思いますがどちらの実装方法が推奨されるのでしょうか？

> * >   Mapインタフェースを引数にとるコンストラクタを使用してMap実装クラスからEntity(Form)を生成する。
> * >   項目ごとsetterを呼び出してMap実装クラスからEntity(Form)を生成する。

> **answer:**
> 基本的にMapインタフェースを引数に取るコンストラクタを使用して、Entity(Form)を生成することを推奨します。
> なぜなら、Mapインタフェースを引数に取るコンストラクタ自体がMapからEnity(Form)への変換責務を持っているためであり、
> 全く同じ責務を持つロジックを新たに作り込む必要はないからです。

> ただし、業務仕様として編集しなければならない項目等は、Entity(Form)を生成する側がその責務を有するため、
> コンストラクタではなく個別にsetterを呼び出して値を設定する必要があります。

> 以下にバッチアクションの本処理を例に実装例を示します。

> ```java
> @Override
> public Result handle(SqlRow inputData, ExecutionContext ctx) {
> 
>     // SqlRowからEntityの生成
>     SampleEntity entity = new SampleEntity(inputData);
> 
>     // 編集が必要な項目は個別設定
>     entity.setDate(DateUtil.addDay(inputData.getString("date"), 1));
> 
>     return new Success();
> }
> ```
