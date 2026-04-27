# ■NumberRangeの対応方法

NumberRangeは整数専用となります。
このため、NumberRangeのminまたはmax属性に小数部ありの値を使用している箇所は
DecimalRangeを使用するよう変更する必要があります。
NumberRangeの該当箇所はコンパイルエラーにより検知可能です。
変更例:
変更前:@NumberRange(min=0.0001, max=0.9999)
変更後:@DecimalRange(min="0.0001", max="0.9999")
メッセージ定義については、NumberRangeValidatorで使用していたメッセージと同じものを、
DecimalRangeValidatorに設定することで、今までと同じメッセージが画面上に表示されるようになります。
なお、DecimalRangeを使用するためには、ValidationManagerにDecimalRangeValidatorの追加が必要となります。
設定方法は、解説書(下のリンク)を参照してください。
https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/nablarch_validation.html#nablarch-validation-definition-validator-convertor
