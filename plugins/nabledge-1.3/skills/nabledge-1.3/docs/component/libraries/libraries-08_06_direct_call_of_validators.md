# バリデータの明示的な呼び出し

## バリデータの明示的な呼び出し

アノテーションによる精査処理は、遷移元画面やフラグの有無によって精査対象が変わる場合に対応できない。そのようなケースではアクション側で `ValidationUtil.validate()` を使って明示的にバリデータを呼び出す。

条件に応じてバリデーションを実行する例:

```java
if (contactInfoUpdated) {
    ValidationUtil.validate(context, "daytimePhoneNumber", Required.class);
    ValidationUtil.validate(context, "daytimePhoneNumber", JapaneseTelNumber.class);
}
```

上記は以下のアノテーションと同等:

```java
@PropertyName("昼間連絡先電話番号")
@Required
@JapaneseTelNumber
public void setDaytimePhoneNumber(String value) { ... }
```

アノテーションのプロパティは `Map` を引数に渡して指定できる:

```java
Map<String, Object> params = new HashMap<String, Object>();
params.put("codeId", "1052");
params.put("pattern", "A");
params.put("messageId", "M4865");
ValidationUtil.validate(context, "prefectureCode", CodeValue.class, params);
```

上記は以下のアノテーションと同等:

```java
@PropertyName("都道府県")
@Required
@CodeValue(codeId="1052", pattern="A", messageId="M4865")
public void setPrefectureCode(String value) { ... }
```

> **注意**: この方法でバリデータを利用するには、バリデータ側の対応も必要。詳細は :ref:`implementing_DirectCallable` を参照。

<details>
<summary>keywords</summary>

ValidationUtil, Required, JapaneseTelNumber, CodeValue, PropertyName, バリデータの明示的な呼び出し, 条件付きバリデーション, ValidationUtil.validate

</details>
