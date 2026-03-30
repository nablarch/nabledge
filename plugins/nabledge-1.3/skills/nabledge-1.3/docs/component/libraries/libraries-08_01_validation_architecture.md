# バリデーション機能の構造

## クラス図（インタフェース・クラス定義）

**インタフェース**:

| インタフェース名 | 概要 |
|---|---|
| `nablarch.core.validation.Convertor` | 入力値を対応するプロパティの型に変換するインタフェース（コンバータ）。 |
| `nablarch.core.validation.Validator` | プロパティの値のバリデーションを行うインタフェース（バリデータ）。 |
| `nablarch.core.validation.Validatable` | `ValidationUtil` でバリデーション可能なオブジェクトが実装するインタフェース。 |

**クラス**:

| クラス名 | 概要 |
|---|---|
| `nablarch.core.validation.ValidationManager` | バリデーションおよび変換の処理を実行するクラス。 |
| `nablarch.core.validation.ValidationContext` | バリデーションの処理に必要な情報を保持するクラス。 |
| `nablarch.core.validation.ValidationResultMessage` | バリデーション結果のメッセージ表示に必要な情報を保持するクラス。 |
| `nablarch.core.validation.ValidationUtil` | システムリポジトリから `ValidationManager` を取得して呼び出しを行うユーティリティクラス。 |

> **注意**: `Convertor` インタフェースおよび `Validator` インタフェースを実装したクラスは数が多いため、上記クラス図では一部省略している。利用可能なコンバータ・バリデータの一覧は `validator_and_convertor` を参照。

<details>
<summary>keywords</summary>

Convertor, Validator, Validatable, ValidationManager, ValidationContext, ValidationResultMessage, ValidationUtil, nablarch.core.validation.Convertor, nablarch.core.validation.Validator, nablarch.core.validation.Validatable, nablarch.core.validation.ValidationManager, nablarch.core.validation.ValidationContext, nablarch.core.validation.ValidationResultMessage, nablarch.core.validation.ValidationUtil, バリデーション, インタフェース定義, クラス定義, コンバータ, バリデータ

</details>

## バリデーションの処理の流れ

`ValidationManager` が中心となり、コンバータ（`Convertor` 実装クラス）とバリデータ（`Validator` 実装クラス）を呼び出してバリデーション処理を実現する。

![バリデーション処理シーケンス図](../../../knowledge/component/libraries/assets/libraries-08_01_validation_architecture/ConceptualValidationSequeceDiagram.jpg)

`ValidationUtil` はリポジトリから取得した `ValidationManager` に処理を委譲するユーティリティクラス。

コンバータとバリデータは `ValidationManager` の `convertors` プロパティおよび `validators` プロパティに設定することで、Formに対応付けて自動的に呼び出される。

<details>
<summary>keywords</summary>

ValidationManager, ValidationUtil, Convertor, Validator, convertors, validators, バリデーション処理, 処理フロー, シーケンス

</details>

## 設定例

`ValidationManager` のインスタンスは、リポジトリ上で必ず **`validationManager`** というコンポーネント名で登録すること。

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

`ValidationManager` は初期化が必要（`Initializable` 実装）。:ref:`repository_initialize` を参照し、初期化リストに追加すること。

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

validationManager, ValidationManager, StringConvertor, StringArrayConvertor, LongConvertor, BigDecimalConvertor, RequiredValidator, NumberRangeValidator, LengthValidator, BasicStaticDataCache, FormValidationDefinitionLoader, BasicApplicationInitializer, formDefinitionCache, nablarch.core.validation.convertor.StringConvertor, nablarch.core.validation.convertor.StringArrayConvertor, nablarch.core.validation.convertor.LongConvertor, nablarch.core.validation.convertor.BigDecimalConvertor, nablarch.core.validation.validator.RequiredValidator, nablarch.core.validation.validator.NumberRangeValidator, nablarch.core.validation.validator.LengthValidator, Initializable, コンポーネント設定, 初期化設定

</details>

## ValidationManager 設定項目詳細

**クラス**: `nablarch.core.validation.ValidationManager`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| convertors | List | ○ | | `nablarch.core.validation.Convertor` 実装クラスのリスト。 |
| validators | List | ○ | | `nablarch.core.validation.Validator` 実装クラスのリスト。 |
| formDefinitionCache | StaticDataCache | ○ | | `FormValidationDefinition` の `StaticDataCache` を設定する。通常は `BasicStaticDataCache` クラスと `FormValidationDefinitionLoader` クラスの組み合わせを設定すればよい。 |
| invalidSizeKeyMessageId | String | ○ | | `ValidationTarget` アノテーションの `sizeKey` に不正な長さ指定時、または `formArraySizeValueMaxLength` を超える配列添え字のリクエスト受信時のエラーメッセージID。:ref:`form_array_validation` 参照。 |
| stringResourceHolder | StringResourceHolder | ○ | | バリデーションエラーメッセージ取得元の `nablarch.core.message.StringResourceHolder` インスタンス。 |
| useFormPropertyNameAsMessageId | boolean | | false | :ref:`validation_use_form_name_as_message_id` を使用するか否か。 |
| formArraySizeValueMaxLength | int | | 3 | Formの配列サイズ文字列の最大長。デフォルト3（999個まで許容）。 |

> **注意**: `formArraySizeValueMaxLength` は配列の最大数ではなく添え字の文字列長。例えば999個まで許容するには3を設定する。

> **注意**: `stringResourceHolder` は通常システムで1つのみのため、:ref:`__autowire` を利用することで設定ファイルへの記述を省略できる。

<details>
<summary>keywords</summary>

ValidationManager, convertors, validators, formDefinitionCache, invalidSizeKeyMessageId, stringResourceHolder, useFormPropertyNameAsMessageId, formArraySizeValueMaxLength, StringResourceHolder, ValidationTarget, nablarch.core.message.StringResourceHolder, BasicStaticDataCache, FormValidationDefinitionLoader, 設定項目, プロパティ詳細

</details>
