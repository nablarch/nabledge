# バリデーション機能の構造

## クラス図

**インタフェース**:

| インタフェース名 | 概要 |
|---|---|
| `nablarch.core.validation.Convertor` | 入力値から対応するプロパティの型に変換するインタフェース。実装クラスをコンバータと呼ぶ。 |
| `nablarch.core.validation.Validator` | プロパティの値のバリデーションを行うインタフェース。実装クラスをバリデータと呼ぶ。 |
| `nablarch.core.validation.Validatable` | ValidationUtil でバリデーション可能なオブジェクトが実装するインタフェース。 |

**クラス**:

| クラス名 | 概要 |
|---|---|
| `nablarch.core.validation.ValidationManager` | バリデーションおよび変換の処理を実行するクラス。 |
| `nablarch.core.validation.ValidationContext` | バリデーションの処理に必要な情報を保持するクラス。 |
| `nablarch.core.validation.ValidationResultMessage` | バリデーション結果のメッセージ表示に必要な情報を保持するクラス。 |
| `nablarch.core.validation.ValidationUtil` | システムリポジトリから ValidationManager を取得し、呼び出しを行うユーティリティクラス。 |

<details>
<summary>keywords</summary>

ValidationManager, ValidationContext, ValidationResultMessage, ValidationUtil, Convertor, Validator, Validatable, nablarch.core.validation, バリデーション クラス構造, インタフェース定義

</details>

## バリデーションの処理の流れ

処理フロー:

1. ValidationUtil がリポジトリから ValidationManager を取得し、処理を委譲する。
2. ValidationManager がコンバータ（Convertor実装クラス）を呼び出し、入力値を型変換する。
3. ValidationManager がバリデータ（Validator実装クラス）を呼び出し、バリデーションを実行する。

コンバータは `convertors` プロパティ、バリデータは `validators` プロパティに設定することで、ValidationManager から Form に対応付けて自動的に呼び出される。

<details>
<summary>keywords</summary>

ValidationManager, ValidationUtil, Convertor, Validator, convertors, validators, Form, バリデーション処理フロー, シーケンス

</details>

## 設定例

> **重要**: ValidationManager は、リポジトリ上で必ず `validationManager` というコンポーネント名で登録する必要がある。

**ValidationManager 設定例**:

```xml
<component name="validationManager" class="nablarch.core.validation.ValidationManager">
    <property name="convertors">
        <list>
            <component class="nablarch.core.validation.convertor.StringConvertor">
                <property name="conversionFailedMessageId" value="MSG00001"/>
            </component>
            <component class="nablarch.core.validation.convertor.StringArrayConvertor"/>
            <component class="nablarch.core.validation.convertor.LongConvertor">
                <property name="invalidDigitsIntegerMessageId" value="MSG00031"/>
                <property name="multiInputMessageId" value="MSG00001"/>
            </component>
            <component class="nablarch.core.validation.convertor.BigDecimalConvertor">
                <property name="invalidDigitsIntegerMessageId" value="MSG00031"/>
                <property name="invalidDigitsFractionMessageId" value="MSG00032"/>
                <property name="multiInputMessageId" value="MSG00001"/>
            </component>
        </list>
    </property>
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
                <property name="fixLengthMessageId" value="MSG00023"/>
            </component>
        </list>
    </property>
    <property name="formDefinitionCache" ref="formDefinitionCache"/>
</component>

<component name="formDefinitionCache" class="nablarch.core.cache.BasicStaticDataCache">
    <property name="loader">
        <component class="nablarch.core.validation.FormValidationDefinitionLoader"/>
    </property>
</component>
```

ValidationManager は Initializable を実装しているため、:ref:`repository_initialize` に従い初期化設定が必要。

**初期化設定例**:

```xml
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="formDefinitionCache"/>
            <component-ref name="validationManager"/>
        </list>
    </property>
</component>
```

<details>
<summary>keywords</summary>

validationManager, ValidationManager, StringConvertor, StringArrayConvertor, LongConvertor, BigDecimalConvertor, RequiredValidator, NumberRangeValidator, LengthValidator, formDefinitionCache, BasicStaticDataCache, FormValidationDefinitionLoader, BasicApplicationInitializer, Initializable, 初期化設定, バリデーション XML設定

</details>

## 設定内容詳細

**クラス**: `nablarch.core.validation.ValidationManager` の設定プロパティ:

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| convertors | ○ | 使用するコンバータ（`nablarch.core.validation.Convertor` 実装クラス）をListで設定する。 |
| validators | ○ | 使用するバリデータ（`nablarch.core.validation.Validator` 実装クラス）をListで設定する。 |
| formDefinitionCache | ○ | FormValidationDefinitionのStaticDataCacheを設定する。通常は `BasicStaticDataCache` と `FormValidationDefinitionLoader` を使用する。 |
| invalidSizeKeyMessageId | ○ | ValidationTargetアノテーションのsizeKeyに不正な長さを指定した際のエラーメッセージID。詳細は :ref:`form_array_validation` を参照。 |
| stringResourceHolder | ○ | `nablarch.core.message.StringResourceHolder` のインスタンス。バリデーションエラーメッセージの取得元。通常は :ref:`__autowire` により自動設定されるため設定ファイルへの記載不要。 |
| useFormPropertyNameAsMessageId | | :ref:`validation_use_form_name_as_message_id` を使用するか否か。未設定時は `false`。 |
| formArraySizeValueMaxLength | | Formの配列サイズ文字列の最大長。未設定時は `3`（999個まで許容）。配列の最大値ではなく添え字の文字列長を指定する（例：999個まで許容する場合は `3` を設定）。 |
| invalidSizeKeyMessageId | ○ | `formArraySizeValueMaxLength` を超えた配列の添え字がリクエストとして送られた際のメッセージID。 |

<details>
<summary>keywords</summary>

ValidationManager, convertors, validators, formDefinitionCache, invalidSizeKeyMessageId, stringResourceHolder, useFormPropertyNameAsMessageId, formArraySizeValueMaxLength, StringResourceHolder, プロパティ設定

</details>
