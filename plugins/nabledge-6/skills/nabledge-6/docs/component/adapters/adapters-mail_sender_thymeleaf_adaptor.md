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

> **補足**: Thymeleaf 3.1.1.RELEASEでテスト済み。バージョンを変更する場合はプロジェクト側でテストを行うこと。

<details>
<summary>keywords</summary>

nablarch-mail-sender-thymeleaf-adaptor, Thymeleaf, メール送信アダプタ, モジュール設定, 依存関係

</details>

## E-mail Thymeleafアダプタを使用するための設定を行う

`ThymeleafMailProcessor` を `MailRequester` に設定する。`ThymeleafMailProcessor` にはThymeleafの `TemplateEngine` を設定する必要がある。

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
</component>
```

<details>
<summary>keywords</summary>

ThymeleafMailProcessor, nablarch.integration.mail.thymeleaf.ThymeleafMailProcessor, MailRequester, nablarch.common.mail.MailRequester, TemplateEngine, ClassLoaderTemplateResolver, コンポーネント設定, メール処理設定

</details>

## メールのテンプレートを作成する

件名と本文を1つのテンプレートに記述する。デリミタ行（デフォルト: `---`、半角ハイフン3つ）で件名と本文を分割する。

```
[(${title})]について[(${option})]
---
[(${title})]は、申請番号[(${requestId})]で申請されました。
[(${approver})]は速やかに[(${title})]を承認してください。[(${option})]
```

詳細な分割ルールは `TemplateEngineProcessedResult#valueOf` を参照。

テンプレートファイルの配置場所は `TemplateEngine` の設定に依存する。上記設定例では `ClassLoaderTemplateResolver` の `prefix` に `com/example/template/` を設定しているため、クラスパス上の `com/example/template/` ディレクトリにテンプレートファイルを配置する。

<details>
<summary>keywords</summary>

TemplateEngineProcessedResult, nablarch.common.mail.TemplateEngineProcessedResult, ClassLoaderTemplateResolver, TemplateEngine, デリミタ, テンプレート, 件名, 本文

</details>

## メール送信要求を登録する

定型メールの送信要求を登録するだけでよい。詳細は :ref:`mail-request` を参照。

<details>
<summary>keywords</summary>

メール送信要求, 定型メール送信, mail-request

</details>
