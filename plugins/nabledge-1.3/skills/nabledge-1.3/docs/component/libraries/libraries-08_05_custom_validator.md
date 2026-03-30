# バリデータの追加・変更

## アノテーションの作成

カスタムアノテーション＋バリデータの追加手順:
1. アノテーションの作成
2. バリデータの作成
3. バリデータを設定ファイルに登録

既存アノテーションを使いバリデータの処理内容のみ変更する場合は、手順2と3のみ実施する。

カスタムアノテーションの作成要件:
- `@Validation` アノテーションを付与すること
- `@Target(ElementType.METHOD)` を設定すること
- `@Retention(RetentionPolicy.RUNTIME)` を設定すること

```java
@Validation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface SampleCheck {
    boolean allow0001() default false;
}
```

> **注意**: メッセージIDは必要な場合のみアノテーションに持たせればよい（フレームワーク提供アノテーションは汎用性のためメッセージIDを持つが、通常アプリでは任意）。

<details>
<summary>keywords</summary>

@Validation, @Target, @Retention, ElementType.METHOD, RetentionPolicy.RUNTIME, SampleCheck, カスタムアノテーション作成, バリデータ追加手順, バリデーション拡張

</details>

## バリデータの作成

**インターフェース**: `Validator`

バリデータ実装のポイント:
1. デフォルトエラーメッセージをバリデータのプロパティとして持つ。複数プロパティ間でエラーメッセージをシステムとして統一できる。バリデーションパターンごとに別プロパティを追加可能（例: `allow0001MessageId`、`deny0001MessageId`）。
2. `validate` メソッドの引数 `value` はアノテーションを設定したプロパティの型に変換済みの値が渡される。プロパティの型に合わせてキャストしてバリデーションを行う。
3. バリデーション失敗時は `ValidationContext.addResultMessage(propertyName, messageId, options...)` でエラーメッセージを追加し `false` を返す。成功時は `true` を返す。第3引数以降のオプションパラメータには通常 `ValidationContext.getMessage(propertyMessageId)` で取得した `Message` を設定する（プロパティ名をエラーメッセージの置き換え文字として挿入するため）。

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

Validator, ValidationContext, SampleCheckValidator, addResultMessage, getAnnotationClass, getMessage, カスタムバリデータ実装, エラーメッセージ設定, バリデーション失敗

</details>

## バリデータを設定ファイルに登録

[validation_sequence](libraries-08_01_validation_architecture.md) と同様に `ValidationManager` の `validators` プロパティのリストにバリデータコンポーネントを追加することで使用可能になる。バリデータ固有のプロパティ（メッセージIDなど）も同時に設定する。

```xml
<property name="validators">
    <list>
        <!-- 追加 -->
        <component class="nablarch.core.validation.sample.create.SampleCheckValidator">
            <property name="allow0001MessageId" value="MSG00051"/>
            <property name="deny0001MessageId" value="MSG00052"/>
        </component>
    </list>
</property>
```

フォームの setter メソッドに `@SampleCheck` アノテーションを付与する:

```java
@SampleCheck(allow0001 = false)
public void setParam1(String param1) { ... }

@SampleCheck(allow0001 = true)
public void setParam2(String param2) { ... }
```

<details>
<summary>keywords</summary>

ValidationManager, SampleCheckValidator, validators, @SampleCheck, バリデータ登録, 設定ファイル

</details>

## バリデータを明示的に呼び出す場合

業務ロジックからのバリデータ直接呼び出し（[direct_call_of_validators](libraries-08_06_direct_call_of_validators.md)）に対応するには、`Validator` のサブインターフェースである `DirectCallableValidator` を実装する必要がある。

追加実装メソッド: `validate(ValidationContext<T> context, String propertyName, Object propertyDisplayName, Map<String, Object> params, Object value)`

`params` に `Map` として渡された属性値をアノテーションオブジェクトに移し替えて、既存の `validate` メソッドに委譲する。属性値が未設定（`null`）の場合はアノテーションのデフォルト値を返す。

```java
public class SampleCheckValidator implements DirectCallableValidator {

    public <T> boolean validate(ValidationContext<T> context,
                                String              propertyName,
                                Object              propertyDisplayName,
                                final Map<String, Object> params,
                                Object              value) {

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

DirectCallableValidator, ValidationContext, SampleCheckValidator, annotationType, バリデータ直接呼び出し, 業務ロジックからの呼び出し, DirectCallable

</details>
