# バリデータの追加・変更

## バリデータの追加・変更の手順概要

バリデーションに使用するアノテーションとバリデータは、必要に応じて追加・変更を行うことができる。

アノテーションとバリデータは下記手順で追加できる:
1. アノテーションの作成
2. バリデータの作成
3. バリデータを設定ファイルに登録

既存のアノテーションをそのまま使用して、バリデータの処理内容を変更する場合は、手順2と3のみ実施すればよい。

サンプル要求例:
- 入力した文字列が "0001", "0002", "0003" のいずれかであることがチェックできること
- アノテーションで "0001" の入力を許可しない設定にできること

<details>
<summary>keywords</summary>

バリデータ追加, バリデータ変更, カスタムバリデータ, バリデータ追加手順, アノテーション追加, バリデータ登録手順, 既存アノテーション変更

</details>

## アノテーションの作成

バリデータの条件を指定するアノテーションは、下記条件を満たす必要がある:
- `@Validation` アノテーションを設定すること
- `@Target` アノテーションで `ElementType.METHOD` を設定すること
- `@Retention` アノテーションで `RetentionPolicy.RUNTIME` を設定すること

```java
@Validation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface SampleCheck {
    boolean allow0001() default false;
}
```

> **注意**: アノテーションにメッセージIDを持たせるかどうかは任意。メッセージIDが必要な場合のみアノテーションに持たせればよい。

<details>
<summary>keywords</summary>

@Validation, @Target, @Retention, SampleCheck, ElementType.METHOD, RetentionPolicy.RUNTIME, バリデーションアノテーション作成, カスタムバリデータ追加

</details>

## バリデータの作成

**インターフェース**: `Validator`

```java
public class SampleCheckValidator implements Validator {

    private String allow0001MessageId;
    private String deny0001MessageId;

    public void setAllow0001MessageId(String messageId) {
        this.allow0001MessageId = messageId;
    }

    public void setDeny0001MessageId(String deny0001MessageId) {
        this.deny0001MessageId = deny0001MessageId;
    }

    public Class<? extends Annotation> getAnnotationClass() {
        return SampleCheck.class;
    }

    public <T> boolean validate(ValidationContext<T> context,
            String propertyName, String propertyMessageId,
            Annotation annotation, Object value) {

        SampleCheck check = (SampleCheck) annotation;
        String strValue = (String) value;
        if (check.allow0001()) {
            if ("0001".equals(strValue) || "0002".equals(strValue) || "0003".equals(strValue)) {
                return true;
            } else {
                context.addResultMessage(propertyName, allow0001MessageId, context.getMessage(propertyMessageId));
                return false;
            }
        } else {
            if ("0002".equals(strValue) || "0003".equals(strValue)) {
                return true;
            } else {
                context.addResultMessage(propertyName, deny0001MessageId, context.getMessage(propertyMessageId));
                return false;
            }
        }
    }
}
```

バリデータの実装ポイント:
1. デフォルトのエラーメッセージはバリデータのプロパティとして持つ。複数プロパティに対するエラーメッセージをシステムとして統一できる。特定プロパティのみ別のメッセージを設定したい場合は、アノテーションにエラーメッセージを設定し、設定されている場合に優先使用する実装にする。バリデーション結果のパターンごとに異なるメッセージが必要な場合は、パターン数だけエラーメッセージ用プロパティを追加する（例: `allow0001MessageId` と `deny0001MessageId`）。
2. `validate` メソッドの引数 `value` にはアノテーションを設定したプロパティの型に合わせた変換後の値が渡される。プロパティの型に合わせてキャストしてバリデーションを行う。
3. バリデーション結果が正しくない場合は `ValidationContext.addResultMessage(propertyName, messageId, optionParams...)` でエラーメッセージをコンテキストに追加して `false` を返す。正しい場合は `true` を返す。`addResultMessage` の第1引数は `propertyName`、第2引数はメッセージID、第3引数以降はオプションパラメータ（通常 `ValidationContext.getMessage(propertyMessageId)` で取得した `Message` を渡す）。

<details>
<summary>keywords</summary>

SampleCheckValidator, Validator, ValidationContext, addResultMessage, getMessage, getAnnotationClass, バリデータ実装, カスタムバリデーション

</details>

## バリデータを設定ファイルに登録

[validation_sequence](libraries-08_01_validation_architecture.md) と同様に設定ファイルに追加することで使用可能。`ValidationManager` の `validators` プロパティのリストに追加する。バリデータ特有の追加設定は不要。

```xml
<property name="validators">
    <list>
        <component class="nablarch.core.validation.validator.RequiredValidator">
            <property name="messageId" value="MSG00011"/>
        </component>
        <component class="nablarch.core.validation.validator.NumberRangeValidator">
            <property name="maxMessageId" value="MSG00051"/>
            <property name="maxAndMinMessageId" value="MSG00052"/>
            <property name="minMessageId" value="MSG00053"/>
        </component>
        <component class="nablarch.core.validation.validator.LengthValidator">
            <property name="maxMessageId" value="MSG00021"/>
            <property name="maxAndMinMessageId" value="MSG00022"/>
        </component>
        <!-- 追加 -->
        <component class="nablarch.core.validation.sample.create.SampleCheckValidator">
            <property name="allow0001MessageId" value="MSG00051"/>
            <property name="deny0001MessageId" value="MSG00052"/>
        </component>
    </list>
</property>
```

**アノテーション**: `@SampleCheck` をFormのsetterメソッドに付けてバリデーションを行う:

```java
@SampleCheck(allow0001 = false)
public void setParam1(String param1) {
    this.param1 = param1;
}

@SampleCheck(allow0001 = true)
public void setParam2(String param2) {
    this.param2 = param2;
}
```

<details>
<summary>keywords</summary>

ValidationManager, validators, SampleCheckValidator, @SampleCheck, バリデータ設定登録

</details>

## バリデータを明示的に呼び出す場合

[direct_call_of_validators](libraries-08_06_direct_call_of_validators.md) で述べた業務ロジックからの直接呼び出しに対応するには、`Validator` インターフェースのサブインターフェースである `DirectCallableValidator` インターフェースを実装する必要がある。

追加で実装するメソッド: `validate(ValidationContext<T>, String, Object, Map<String, Object>, Object)` — Mapとして渡された属性値をアノテーションに移し替えて `validate` を呼び出す（定型的な実装）。

```java
public class SampleCheckValidator implements DirectCallableValidator {

    // Validator の既存メソッド実装は変更なし

    public <T> boolean validate(ValidationContext<T> context,
                                String propertyName,
                                Object propertyDisplayName,
                                final Map<String, Object> params,
                                Object value) {
        SampleCheck annotation = new SampleCheck() {
            public Class<? extends Annotation> annotationType() {
                return SampleCheck.class;
            }
            public boolean allow001() {
                String allow001 = (Boolean) params.get("allow001");
                // 属性値が設定されていない場合はアノテーションのデフォルト値を返す
                return (allow001 == null) ? false : allow001;
            }
        };
        return validate(context, propertyName, propertyDisplayName, annotation, value);
    }
}
```

<details>
<summary>keywords</summary>

DirectCallableValidator, SampleCheckValidator, ValidationContext, バリデータ直接呼び出し, 業務ロジックからのバリデーション

</details>
