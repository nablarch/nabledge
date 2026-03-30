# SqlRow等のMap実装クラスからEntityやFormを生成する方法を教えてください

## SqlRow等のMap実装クラスからEntityやFormを生成する方法

## SqlRow等のMap実装クラスからEntityやFormを生成する方法

Mapインタフェースを引数に取るコンストラクタを使用してEntity(Form)を生成することを推奨する。コンストラクタ自体がMapからEntity(Form)への変換責務を持つため、同じ責務を持つロジックを別途作り込む必要はない。

ただし、業務仕様として編集が必要な項目はEntity(Form)を生成する側が責務を持つため、コンストラクタではなく個別にsetterを呼び出して値を設定すること。

```java
@Override
public Result handle(SqlRow inputData, ExecutionContext ctx) {

    // SqlRowからEntityの生成
    SampleEntity entity = new SampleEntity(inputData);

    // 編集が必要な項目は個別設定
    entity.setDate(DateUtil.addDay(inputData.getString("date"), 1));

    return new Success();
}
```

<details>
<summary>keywords</summary>

SqlRow, Entity生成, Form生成, Mapコンストラクタ, setter, MapからEntityへの変換, SampleEntity, ExecutionContext, DateUtil, Result, Success

</details>
