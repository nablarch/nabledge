# バリデータの明示的な呼び出し

ここまで述べてきたアノテーションによる精査処理の実装方法は、ソースコードの記述がほとんど不要である一方、
遷移元画面やフラグの有無によって精査対象が変わるような場合に対応することができない。

そのようなケースでは、アクション側で精査処理を実装する必要がある。
以下は、画面から送信された条件フラグに従って、精査処理の有無を判断している例である。

```java
// 連絡先情報が更新されている場合、昼間連絡先電話番号が入力されていることを確認する。
if (contactInfoUpdated) {
  ValidationUtil.validate(context, "daytimePhoneNumber", Required.class);
  ValidationUtil.validate(context, "daytimePhoneNumber", JapaneseTelNumber.class);
}
```

if文の条件に合致した場合に行われる精査処理は、下記のアノテーションと同等のものとなる。

```java
@PropertyName("昼間連絡先電話番号")
@Required
@JapaneseTelNumber
public void setDaytimePhoneNumber(String value) {
    this.value = value;
}
```

アノテーションのプロパティは、以下のように **Map** を引数に渡すことで指定することが可能である。

```java
// 入力値が都道府県コードに含まれていることを検証する。
Map<String, Object> params = new HashMap<String, Object>();
params.put("codeId", "1052");     // 都道府県コード
params.put("pattern", "A");       // 使用するコードパターン名
params.put("messageId", "M4865"); // 精査エラーメッセージのID
ValidationUtil.validate(context, "prefectureCode", CodeValue.class, params);
```

この精査処理は、下記のアノテーションによる処理と同じものとなる。

```java
@PropertyName("都道府県")
@Required
@CodeValue(codeId="1052", pattern="A", messageId="M4865")
public void setPrefectureCode(String value) {
    this.value = value;
}
```

> **Note:**
> ここで述べている方法でバリデータを利用するためには、バリデータ側の対応も必要となる。
> 詳細については、下記の項を参照すること。

> [バリデータを明示的に呼び出す場合](../../component/libraries/libraries-08-05-custom-validator.md#implementing-directcallable)
