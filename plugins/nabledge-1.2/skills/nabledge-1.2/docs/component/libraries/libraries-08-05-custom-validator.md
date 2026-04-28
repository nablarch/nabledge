# バリデータの追加・変更

バリデーションに使用するアノテーションとバリデータは、必要に応じて追加・変更を行うことができる。

アノテーションとバリデータは下記手順で追加できる。

1. アノテーションの作成
2. バリデータの作成
3. バリデータを設定ファイルに登録

また、既存のアノテーションをそのまま使用して、バリデータの処理内容を変更する場合は、
上記手順の2と3を実施すればよい。

例えば下記要求を満たすサンプルのバリデータの作成する例を考える。

* 入力した文字列が "0001" , "0002" , "0003" のいずれかであることがチェックできること。
* アノテーションで "0001" の入力を許可しない設定にできること。

このサンプルのバリデータの作成手順は以下のようになる。

## アノテーションの作成

バリデータの条件を指定するアノテーションは、下記条件を満たす必要がある。

* @Validation アノテーションを設定すること。
* @Target アノテーションでElementType.METHODを設定すること。
* @Retention アノテーションでRetentionPolicy.RUNTIMEを設定すること。

ここで示す例では、「0001を許可するかしないか？」をアノテーションで指定する必要があるため、
この条件をアノテーションに持たせればよい。

実際のアノテーションは下記のような実装になる。

```java
// ******** 注意 ********
// 下記のコードはプロジェクトのアーキテクトが作成するものである。
// 通常、各アプリケーション・プログラマはこのような実装を行わない。

@Validation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface SampleCheck {
    boolean allow0001() default false;
}
```

> **Note:**
> 本フレームワークが提供するアノテーションには、必ずメッセージIDが指定できるよう
> になっているが、これはバリデータの使用方法に汎用性を持たせるためである。
> 通常のアプリケーションでは、メッセージIDが必要になった場合のみアノテーションに持た
> せるようにすればよい。

## バリデータの作成

バリデータは、 Validator インタフェースを実装して作成する。

実装例を下記に示す。

```java
// ******** 注意 ********
// 下記のコードはプロジェクトのアーキテクトが作成するものである。
// 通常、各アプリケーション・プログラマはこのような実装を行わない。

public class SampleCheckValidator implements Validator {

    private String allow0001MessageId;
    private String deny0001MessageId;

    // ポイント1
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

        // ポイント2
        String strValue = (String) value;
        if (check.allow0001()) {
            if ("0001".equals(strValue)
                    || "0002".equals(strValue)
                    || "0003".equals(strValue)) {
                return true;
            } else {
                // ポイント3
                context.addResultMessage(propertyName, allow0001MessageId, context.getMessage(propertyMessageId));
                return false;
            }
        } else {
            if ("0002".equals(strValue)
                    || "0003".equals(strValue)) {
                return true;
            } else {
                context.addResultMessage(propertyName, deny0001MessageId, context.getMessage(propertyMessageId));
                return false;
            }
        }
    }

}
```

バリデータの実装ポイントは下記の通りである。

1. デフォルトのエラーメッセージをプロパティに持つ。

バリデーション結果のデフォルトのエラーメッセージは、バリデータのプロパティとして持つ。
こうすることで、複数のプロパティに対するバリデーション結果のエラーメッセージをシステムとして統一できる。
もし特定のプロパティのみ別のエラーメッセージを設定したい場合、別途アノテーションにエラーメッセージを設定できるようにし、
アノテーションにエラーメッセージが設定されていた場合にはそちらを優先的に使用するように実装すればよい。

また、本サンプルでは0001を許す場合と許さない場合で異なるエラーメッセージを設定可能としている。
このように、バリデーション結果に合わせてエラーメッセージを変更したい場合には、本サンプルの allow0001MessageId と
deny0001MessageId のように、エラーメッセージのパターンだけエラーメッセージ用のプロパティを追加すればよい。

1. validateメソッド内では引数の value に対してバリデーションを行う。

validateメソッドは、アノテーションを設定したプロパティの型に合わせた変換後の値が引数 value で渡される。
このため、アノテーションを設定するプロパティの型に合わせてバリデーションの処理を記述すればよい。

この例ではアノテーションを文字列のプロパティに対して設定することのみを想定しているため、 value を
Stringにキャストしてチェックを行っている。

1. validateメソッドで、バリデーション結果を正しくないと判定した場合は引数の context にメッセージを追加して false を返す。

入力値のバリデーション結果を正しくないと判定した場合、 ValidationContext の addResultMessage メソッドを使用してエラーメッセージ
をコンテキストに追加し、 false を返す。
反対にバリデーション結果が正しいと判断した場合には、単に true を返せばよい。

addResultMessage メソッドには第1引数に validate メソッドに渡される propertyName 、第2引数にエラーメッセージの
メッセージID、第3引数以降にエラーメッセージのオプションパラメータを渡す。
オプションパラメータは指定しなくてもかまわないが、通常エラーメッセージの置き換え文字にプロパティ名を挿入することが多い。
このような場合、サンプルのように ValidationContext の getMessage メソッドで取得した Message を
オプションパラメータとして設定しておく。

## バリデータを設定ファイルに登録

作成したバリデータは、 [バリデーションの処理の流れ](../../component/libraries/libraries-08-01-validation-architecture.md#validation-sequence) と同様に設定ファイルに追加しておくことで使用できる。

サンプルの設定を追加した ValidationManager の validators プロパティの設定は下記のようになる。
ここでは ValidationManager の validators プロパティのリストに追加する以外にバリデータ特有の設定は不要である。

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

以上の設定を行うことで、下記のように Form のプロパティに @SampleCheck アノテーションを付けたバリデーションが可能となる。

```xml
private static class TestEntity {

    private String param1;
    private String param2;
    public TestEntity(Map<String, Object> params) {

    }
    public String getParam1() {
        return param1;
    }

    @SampleCheck(allow0001 = false)
    public void setParam1(String param1) {
        this.param1 = param1;
    }
    public String getParam2() {
        return param2;
    }
    @SampleCheck(allow0001 = true)
    public void setParam2(String param2) {
        this.param2 = param2;
    }

}
```

## バリデータを明示的に呼び出す場合

[バリデータの明示的な呼び出し](../../component/libraries/libraries-08-06-direct-call-of-validators.md#direct-call-of-validators) で述べたように、業務ロジックからの直接呼び出しに対応する為には
**Validator** インターフェースのサブインタフェースである **DirectCallableValidator** インターフェース
を実装する必要がある。

次のコードは、先の **SampleCheckValidator** これに対応するように拡張したものである。
(実装する内容は、コード中のコメントにもあるように定型的なものである。)

```java
// ******** 注意 ********
// 下記のコードはプロジェクトのアーキテクトが作成するものである。
// 通常、各アプリケーション・プログラマはこのような実装を行わない。

public class SampleCheckValidator implements DirectCallableValidator {

    // 実装するインターフェース名と、追加されたメソッド以外の実装は元のソースコードと同じ

    // DirectCallableValidator で追加されたメソッドの実装
    public <T> boolean validate(ValidationContext<T>      context,
                                String                    propertyName,
                                Object                    propertyDisplayName,
                                final Map<String, Object> params,
                                Object                    value) {

        // Mapとして渡された属性値を、アノテーションに移し替える。
        SampleCheck annotation = new SampleCheck() {
            public Class<? extends Annotation> annotationType() {
                return SampleCheck.class;
            }
            public boolean allow001() {
                String allow001 = (Boolean) params.get("allow001");
                // 属性値が設定されていない場合は、アノテーションに指定されているデフォルト値を返す。
                return (allow001 == null) ? false
                                          : allow001;
            }
        };
        return validate(context, propertyName, propertyDisplayName, annotation, value);
    }
}
```
