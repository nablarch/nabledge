# カンマ編集された値を数値型として精査することは出来ますか?

## カンマ編集された値を数値型として精査することは出来ますか?

**アノテーション**: `@Digits`

`@Digits` の `commaSeparated = true`（デフォルト）を設定すると、カンマ編集された値（例: `123,123`）を数値項目として精査でき、精査後のエンティティには `123123` が設定される。カンマ編集は必須ではなく、カンマなしの値も精査OK。

```java
// commaSeparated = true（デフォルト）: カンマ編集を許容
@PropertyName("数値")
@Digits(integer = 8, commaSeparated = true)
public void setIntVal(Integer intVal) {
    this.intVal = intVal;
}
```

カンマを許容しない場合は `commaSeparated = false` を設定する。

```java
@PropertyName("数値")
@Digits(integer = 8, commaSeparated = false)
public void setIntVal(Integer intVal) {
    this.intVal = intVal;
}
```

関連情報: [1](libraries-1-FAQ.md)

<details>
<summary>keywords</summary>

@Digits, @PropertyName, commaSeparated, カンマ編集, 数値型バリデーション, Digitsアノテーション, 数値精査

</details>
