# SqlRow等のMap実装クラスからEntityやFormを生成する方法を教えてください

## SqlRow等のMap実装クラスからEntityやFormを生成する方法

## SqlRow等のMap実装クラスからEntityやFormを生成する方法

**推奨**: Mapインタフェースを引数に取るコンストラクタを使用してEntity(Form)を生成する。コンストラクタ自体がMapからEntity(Form)への変換責務を持っているため、同一責務のロジックを別途実装する必要はない。

**例外**: 業務仕様として編集が必要な項目は、Entity(Form)を生成する側が責務を持つため、コンストラクタではなく個別にsetterを呼び出して値を設定する。

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

SqlRow, SampleEntity, Map実装クラスからEntity生成, Mapコンストラクタ使用推奨, setter個別呼び出し, バッチアクション本処理, ExecutionContext, DateUtil, Success, Result

</details>
