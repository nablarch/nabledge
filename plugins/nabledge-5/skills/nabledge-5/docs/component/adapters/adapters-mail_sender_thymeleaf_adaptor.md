# E-mail Thymeleafアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/mail_sender_thymeleaf_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/mail/thymeleaf/ThymeleafMailProcessor.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailRequester.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/TemplateEngineProcessedResult.html)

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-mail-sender-thymeleaf-adaptor</artifactId>
</dependency>
```

> **補足**: Thymeleaf 3.0.9.RELEASEでテスト済み。バージョンを変更する場合はプロジェクト側でテストを行い問題ないことを確認すること。

<details>
<summary>keywords</summary>

nablarch-mail-sender-thymeleaf-adaptor, com.nablarch.integration, メール送信Thymeleafアダプタ依存関係, Thymeleafバージョン

</details>

## E-mail Thymeleafアダプタを使用するための設定を行う

`ThymeleafMailProcessor` を `MailRequester` の `templateEngineMailProcessor` プロパティに設定する。`ThymeleafMailProcessor` にはThymeleafが提供する `TemplateEngine` を設定する必要がある。

```xml
<component name="templateEngine" class="org.thymeleaf.TemplateEngine" autowireType="None">
  <property name="templateResolver">
    <component class="org.thymeleaf.templateresolver.ClassLoaderTemplateResolver" autowireType="None">
      <property name="prefix" value="com/example/template/" />
    </component>
  </property>
</component>

<component name="templateEngineMailProcessor"
  class="nablarch.integration.mail.thymeleaf.ThymeleafMailProcessor" autowireType="None">
  <property name="templateEngine" ref="templateEngine" />
</component>

<component name="mailRequester" class="nablarch.common.mail.MailRequester">
  <property name="templateEngineMailProcessor" ref="templateEngineMailProcessor"/>
  <!-- その他の設定は省略 -->
</component>
```

<details>
<summary>keywords</summary>

ThymeleafMailProcessor, nablarch.integration.mail.thymeleaf.ThymeleafMailProcessor, MailRequester, nablarch.common.mail.MailRequester, TemplateEngine, templateEngineMailProcessor, ThymeleafMailProcessor設定, コンポーネント設定

</details>

## メールのテンプレートを作成する

件名と本文を1つのテンプレートファイルに記述する。件名と本文はデリミタ行で分割される。デフォルトのデリミタは `---`（半角ハイフン3つ）。

テンプレート例:
```
[(${title})]について[(${option})]
---
[(${title})]は、申請番号[(${requestId})]で申請されました。
[(${approver})]は速やかに[(${title})]を承認してください。[(${option})]
```

件名・本文の分割ルールの詳細は `TemplateEngineProcessedResult#valueOf` を参照。

テンプレートファイルの配置場所は `TemplateEngine` の設定に依存する。上記設定例では `ClassLoaderTemplateResolver` の `prefix` が `com/example/template/` のため、クラスパス上の `com/example/template/` ディレクトリにテンプレートファイルを配置する。

<details>
<summary>keywords</summary>

TemplateEngineProcessedResult, nablarch.common.mail.TemplateEngineProcessedResult, ClassLoaderTemplateResolver, テンプレートデリミタ, メール件名本文テンプレート, テンプレートファイル配置

</details>

## メール送信要求を登録する

定型メールの送信要求を登録するだけでよい。登録方法は :ref:`mail-request` を参照。

<details>
<summary>keywords</summary>

メール送信要求登録, 定型メール送信, mail-request

</details>
