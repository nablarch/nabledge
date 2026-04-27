# ■定型メール送信要求を5u12までと同じ動作にする方法

5u13から定型メール送信要求にFreeMarkerなどのテンプレートエンジンを使用できるようになりました。
5u12まではNablarchが提供する簡易的なテンプレート処理のみが使えていました。
5u12までと同じ動作にしたい場合、次の手順を行ってください。
1. MailRequesterのtemplateEngineMailProcessorプロパティにTinyTemplateEngineMailProcessorを設定する
2. TinyTemplateEngineMailProcessorのmailTemplateTableプロパティを設定する
※ 5u12まではMailRequester直下にmailTemplateTableプロパティがありましたが、5u13でTinyTemplateEngineMailProcessorに移動しました
5u12までのコンポーネント定義の記述例:
<component name="mailRequester" class="nablarch.common.mail.MailRequester">
<property name="mailTemplateTable" ref="mailTemplateTable" />
<!-- 他の設定は省略 -->
</component>
5u13からののコンポーネント定義の記述例（定型メール送信要求を5u12と同じ動作にする場合）:
<component name="mailRequester" class="nablarch.common.mail.MailRequester">
<property name="templateEngineMailProcessor">
<component class="nablarch.common.mail.TinyTemplateEngineMailProcessor">
<property name="mailTemplateTable" ref="mailTemplateTable" />
</component>
</property>
<!-- 他の設定は省略 -->
</component>
