# バリデータの明示的な呼び出し

## バリデータの明示的な呼び出し

アノテーションによる精査では、遷移元画面やフラグの有無によって精査対象が変わるケースに対応できない。そのようなケースではアクション側で `ValidationUtil.validate()` を直接呼び出して精査処理を実装する。

**基本的な使い方（フラグによる条件付き呼び出し）**:

```java
// 連絡先情報が更新されている場合、昼間連絡先電話番号が入力されていることを確認する。
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

**アノテーションプロパティの指定（Mapを使用）**:

```java
// 入力値が都道府県コードに含まれていることを検証する。
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

ValidationUtil, ValidationUtil.validate, Required, JapaneseTelNumber, CodeValue, PropertyName, バリデータの明示的呼び出し, 条件付きバリデーション, Mapによるアノテーションプロパティ指定, implementing_DirectCallable

</details>
