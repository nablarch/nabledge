# カンマ編集された値を数値型として精査することは出来ますか?

## カンマ編集された値を数値型として精査する方法

**アノテーション**: `@Digits`

`@Digits` アノテーションの `commaSeparated` 属性でカンマ編集された数値の精査を制御できる。

- `commaSeparated = true`（デフォルト）: カンマ編集を許容する。カンマなしの入力でも精査OK。
- `commaSeparated = false`: カンマを許容しない。

カンマ許容（デフォルト動作）:
```java
@PropertyName("数値")
@Digits(integer = 8, commaSeparated = true)
public void setIntVal(Integer intVal) {
    this.intVal = intVal;
}
```

カンマ不許容:
```java
@PropertyName("数値")
@Digits(integer = 8, commaSeparated = false)
public void setIntVal(Integer intVal) {
    this.intVal = intVal;
}
```

関連: [1](libraries-1.md)

<details>
<summary>keywords</summary>

@Digits, @PropertyName, commaSeparated, カンマ編集, 数値型バリデーション, Digitsアノテーション

</details>
