# バリデータの明示的な呼び出し

## バリデータの明示的な呼び出し

## バリデータの明示的な呼び出し

アノテーションによる精査処理は、遷移元画面やフラグの有無によって精査対象が変わるケースに対応できない。そのような場合は、アクション側で `ValidationUtil.validate()` を明示的に呼び出して精査処理を実装する。

**基本的な呼び出し方法**（条件付きで `Required`、`JapaneseTelNumber` を適用する例）:

```java
if (contactInfoUpdated) {
    ValidationUtil.validate(context, "daytimePhoneNumber", Required.class);
    ValidationUtil.validate(context, "daytimePhoneNumber", JapaneseTelNumber.class);
}
```

上記は以下のアノテーション指定と同等:

```java
@PropertyName("昼間連絡先電話番号")
@Required
@JapaneseTelNumber
public void setDaytimePhoneNumber(String value) { ... }
```

**アノテーションプロパティの指定**: `Map<String, Object>` を第4引数に渡す。

```java
Map<String, Object> params = new HashMap<String, Object>();
params.put("codeId", "1052");
params.put("pattern", "A");
params.put("messageId", "M4865");
ValidationUtil.validate(context, "prefectureCode", CodeValue.class, params);
```

上記は以下のアノテーション指定と同等:

```java
@PropertyName("都道府県")
@Required
@CodeValue(codeId="1052", pattern="A", messageId="M4865")
public void setPrefectureCode(String value) { ... }
```

> **注意**: この方法でバリデータを利用するには、バリデータ側の対応も必要となる。詳細は `implementing_DirectCallable` を参照。

<details>
<summary>keywords</summary>

ValidationUtil, ValidationUtil.validate, @Required, @JapaneseTelNumber, @CodeValue, @PropertyName, Required, JapaneseTelNumber, CodeValue, PropertyName, バリデータの明示的な呼び出し, 条件付きバリデーション, アノテーションプロパティのMap指定, DirectCallable

</details>
