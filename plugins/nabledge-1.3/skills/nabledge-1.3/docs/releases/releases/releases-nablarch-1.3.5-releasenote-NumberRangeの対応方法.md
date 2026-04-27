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
※アクセス時にtias認証が必要になります。
http://adc.intra.tis.co.jp/nablarchDoc/nablarch1.3.5/nablarch/app_exe_env/fw_doc/doc/02_FunctionDemandSpecifications/01_Core/08/08_05_custom_validator.html
