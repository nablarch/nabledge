# SqlRow等のMap実装クラスからEntityやFormを生成する方法を教えてください

## SqlRow等のMap実装クラスからEntityやFormを生成する方法

MapインタフェースからEntity(Form)を生成する場合、**Mapインタフェースを引数に取るコンストラクタを使用することを推奨**。

理由: コンストラクタ自体がMapからEntity(Form)への変換責務を持つため、同一責務のロジックを新たに作り込む必要がない。

ただし、業務仕様として編集が必要な項目は、コンストラクタではなく個別にsetterを呼び出して値を設定する必要がある。

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

SqlRow, SampleEntity, MapインタフェースからEntity生成, Mapコンストラクタ推奨, setter呼び出し, Entity生成方法, Form生成方法, DateUtil

</details>
