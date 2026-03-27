# バリデータの追加・変更

## アノテーションの作成

アノテーションとバリデータは下記手順で追加できる: (1) アノテーションの作成、(2) バリデータの作成、(3) バリデータを設定ファイルに登録。なお、既存のアノテーションをそのまま使用してバリデータの処理内容を変更する場合は、手順2と3のみ実施すればよい。

カスタムバリデーション用アノテーションの作成条件:
- `@Validation` アノテーションを設定
- `@Target` アノテーションで `ElementType.METHOD` を設定
- `@Retention` アノテーションで `RetentionPolicy.RUNTIME` を設定

```java
@Validation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface SampleCheck {
    boolean allow0001() default false;
}
```

> **注意**: メッセージIDをアノテーションに持たせるかは任意。メッセージIDが必要になった場合のみアノテーションに追加すればよい。

<details>
<summary>keywords</summary>

SampleCheck, @Validation, @Target, @Retention, ElementType.METHOD, RetentionPolicy.RUNTIME, カスタムアノテーション作成, バリデーション拡張

</details>

## バリデータの作成

**クラス**: `Validator` インタフェースを実装して作成する。

実装ポイント:
1. デフォルトのエラーメッセージはバリデータのプロパティとして持つ。バリデーション結果のパターンごとにプロパティを追加することで複数のエラーメッセージに対応できる。特定プロパティのみ別メッセージを使いたい場合はアノテーションにもメッセージを持たせ、設定されている場合はそちらを優先する。
2. `validate` メソッドの引数 `value` には、アノテーションを設定したプロパティの型に合わせた変換後の値が渡される。プロパティの型に合わせてキャストして使用する。
3. バリデーション失敗時は `ValidationContext.addResultMessage(propertyName, messageId, options...)` でエラーメッセージをコンテキストに追加し `false` を返す。成功時は `true` を返す。第3引数以降はオプション。プロパティ名を挿入する場合は `context.getMessage(propertyMessageId)` で取得した `Message` をオプションパラメータとして設定しておく。

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

<details>
<summary>keywords</summary>

SampleCheckValidator, Validator, ValidationContext, addResultMessage, getAnnotationClass, カスタムバリデータ実装, validateメソッド, エラーメッセージ設定, getMessage, Message, allow0001MessageId, deny0001MessageId

</details>

## バリデータを設定ファイルに登録

[validation_sequence](libraries-08_01_validation_architecture.md) と同様に `ValidationManager` の `validators` プロパティのリストにコンポーネントとして追加する。バリデータ特有の設定（メッセージIDなど）はコンポーネントのプロパティとして設定する。

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

FormのSetterメソッドに `@SampleCheck` アノテーションを付けて使用する:

```java
@SampleCheck(allow0001 = false)
public void setParam1(String param1) { this.param1 = param1; }

@SampleCheck(allow0001 = true)
public void setParam2(String param2) { this.param2 = param2; }
```

<details>
<summary>keywords</summary>

ValidationManager, SampleCheckValidator, validators, バリデータ登録, コンポーネント設定, @SampleCheck

</details>

## バリデータを明示的に呼び出す場合

[direct_call_of_validators](libraries-08_06_direct_call_of_validators.md) で述べた業務ロジックからの直接呼び出しに対応するには、`Validator` インタフェースのサブインタフェースである `DirectCallableValidator` インタフェースを実装する必要がある。

追加で実装が必要なメソッド: `validate(ValidationContext, String, Object, Map<String, Object>, Object)` - `Map<String, Object>` 型の `params` として渡された属性値をアノテーションに移し替えて既存の `validate` メソッドに委譲する定型実装。

```java
public class SampleCheckValidator implements DirectCallableValidator {

    // DirectCallableValidatorで追加されたメソッドの実装
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
                return (allow001 == null) ? false : allow001;
            }
        };
        return validate(context, propertyName, propertyDisplayName, annotation, value);
    }
}
```

<details>
<summary>keywords</summary>

DirectCallableValidator, SampleCheckValidator, Validator, 業務ロジックからの直接呼び出し, バリデータ直接呼び出し, Map<String, Object>, params

</details>
