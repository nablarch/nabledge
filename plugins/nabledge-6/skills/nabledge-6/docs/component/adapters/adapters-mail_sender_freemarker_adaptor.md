# E-mail FreeMarkerアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/mail_sender_freemarker_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/mail/freemarker/FreeMarkerMailProcessor.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailRequester.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/ComponentFactory.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/TemplateEngineProcessedResult.html)

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-mail-sender-freemarker-adaptor</artifactId>
</dependency>
```

> **補足**: FreeMarkerのバージョン2.3.27-incubatingを使用してテストを行っている。バージョンを変更する場合は、プロジェクト側でテストを行い問題ないことを確認すること。

<details>
<summary>keywords</summary>

nablarch-mail-sender-freemarker-adaptor, FreeMarkerメールアダプタ, モジュール依存関係, FreeMarker 2.3.27-incubating

</details>

## E-mail FreeMarkerアダプタを使用するための設定を行う

`FreeMarkerMailProcessor` を `MailRequester` に設定する。`FreeMarkerMailProcessor` には FreeMarker の `Configuration` を設定する必要がある。

`Configuration` は `ComponentFactory` の実装クラスを作成してコンポーネントを設定することを推奨する。理由:
- `Configuration` のデフォルトコンストラクタは非推奨
- `Configuration` への設定はコンポーネント設定ファイルよりもJavaコードで行う方がやりやすい

`ConfigurationFactory` 実装例:

```java
public class ConfigurationFactory implements ComponentFactory<Configuration> {
    private String basePackagePath;
    private String encoding;

    @Override
    public Configuration createObject() {
        Configuration cfg = new Configuration(Configuration.getVersion());
        cfg.setClassLoaderForTemplateLoading(getClass().getClassLoader(), basePackagePath);
        cfg.setDefaultEncoding(encoding);
        //必要に応じてConfigurationへその他の設定を行う
        return cfg;
    }

    public void setBasePackagePath(String basePackagePath) { this.basePackagePath = basePackagePath; }
    public void setEncoding(String encoding) { this.encoding = encoding; }
}
```

コンポーネント設定ファイルの例:

```xml
<component name="templateEngineMailProcessor"
           class="nablarch.integration.mail.freemarker.FreeMarkerMailProcessor" autowireType="None">
  <property name="configuration">
    <component class="com.example.ConfigurationFactory">
      <property name="basePackagePath" value="com/example/template/"/>
      <property name="encoding" value="UTF-8"/>
    </component>
  </property>
</component>

<component name="mailRequester" class="nablarch.common.mail.MailRequester">
  <property name="templateEngineMailProcessor" ref="templateEngineMailProcessor"/>
</component>
```

<details>
<summary>keywords</summary>

FreeMarkerMailProcessor, MailRequester, ComponentFactory, Configuration, ConfigurationFactory, basePackagePath, encoding, nablarch.integration.mail.freemarker.FreeMarkerMailProcessor, nablarch.common.mail.MailRequester, nablarch.core.repository.di.ComponentFactory, FreeMarkerアダプタ設定, コンポーネント設定, テンプレートエンジン設定

</details>

## メールのテンプレートを作成する

件名と本文を1つのテンプレートに記述する。件名と本文はデリミタと呼ばれる行で分割され、デフォルトのデリミタは `---`（半角ハイフン3つ）。

テンプレート例:

```
${title}について${option}
---
${title}は、申請番号${requestId}で申請されました。
${approver}は速やかに${title}を承認してください。${option}
```

件名と本文の詳細な分割ルールは `TemplateEngineProcessedResult#valueOf` を参照。

テンプレートファイルの配置場所は `Configuration` の設定による。前節の設定例ではクラスパスからロードされ、`basePackagePath` に `com/example/template/` を設定した場合、クラスパス上の `com/example/template/` ディレクトリにテンプレートファイルを配置する。

<details>
<summary>keywords</summary>

TemplateEngineProcessedResult, nablarch.common.mail.TemplateEngineProcessedResult, テンプレート作成, デリミタ, 件名と本文分割

</details>

## メール送信要求を登録する

定型メールの送信要求を登録するだけでよい。詳細は :ref:`mail-request` を参照。

<details>
<summary>keywords</summary>

メール送信要求登録, 定型メール送信, mail-request

</details>
