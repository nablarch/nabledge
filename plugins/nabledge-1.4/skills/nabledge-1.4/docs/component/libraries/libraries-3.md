# カンマ編集された値を数値型として精査することは出来ますか?

## カンマ編集された値の数値型精査（@Digits）

`@Digits` アノテーションの `commaSeparated` プロパティを設定することで、カンマ編集された値を数値型として精査できる。

- `commaSeparated = true`（デフォルト）: カンマ編集を許容。カンマなしの値も精査OK。
- `commaSeparated = false`: カンマを不許容。

**アノテーション**: `@Digits`, `@PropertyName`

```java
// カンマ許容（デフォルト動作、commaSeparated未設定と同じ）
@PropertyName("数値")
@Digits(integer = 8, commaSeparated = true)
public void setIntVal(Integer intVal) {
    this.intVal = intVal;
}
```

```java
// カンマ不許容
@PropertyName("数値")
@Digits(integer = 8, commaSeparated = false)
public void setIntVal(Integer intVal) {
    this.intVal = intVal;
}
```

関連: [1](libraries-1-FAQ.md)

<details>
<summary>keywords</summary>

@Digits, @PropertyName, commaSeparated, カンマ編集, 数値バリデーション, Digitsアノテーション, カンマ区切り入力

</details>
