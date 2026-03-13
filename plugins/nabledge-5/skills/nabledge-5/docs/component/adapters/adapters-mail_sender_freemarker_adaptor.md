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

nablarch-mail-sender-freemarker-adaptor, FreeMarker, メール送信, モジュール依存関係, バージョン確認

</details>

## E-mail FreeMarkerアダプタを使用するための設定を行う

`FreeMarkerMailProcessor` をコンポーネント設定ファイルで `MailRequester` の `templateEngineMailProcessor` プロパティに設定する。

`FreeMarkerMailProcessor` にはFreeMarkerの `Configuration` を設定する必要がある。`Configuration` の設定には `ComponentFactory` 実装クラスを作成して使用することを推奨。理由: (1) `Configuration` のデフォルトコンストラクタが非推奨 (2) Javaコードで設定する方がコンポーネント設定ファイルより容易。

`ConfigurationFactory` 実装例:
```java
package com.example;

import freemarker.template.Configuration;
import nablarch.core.repository.di.ComponentFactory;

public class ConfigurationFactory implements ComponentFactory<Configuration> {

    private String basePackagePath;
    private String encoding;

    @Override
    public Configuration createObject() {
        Configuration cfg = new Configuration(Configuration.getVersion());
        ClassLoader classLoader = getClass().getClassLoader();
        cfg.setClassLoaderForTemplateLoading(classLoader, basePackagePath);
        cfg.setDefaultEncoding(encoding);
        //必要に応じてConfigurationへその他の設定を行う
        return cfg;
    }

    public void setBasePackagePath(String basePackagePath) {
        this.basePackagePath = basePackagePath;
    }

    public void setEncoding(String encoding) {
        this.encoding = encoding;
    }
}
```

コンポーネント設定ファイル例:
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

<!-- メール送信要求API -->
<component name="mailRequester" class="nablarch.common.mail.MailRequester">
  <property name="templateEngineMailProcessor" ref="templateEngineMailProcessor"/>
  <!-- その他の設定は省略 -->
</component>
```

<details>
<summary>keywords</summary>

FreeMarkerMailProcessor, MailRequester, ComponentFactory, Configuration, ConfigurationFactory, コンポーネント設定, templateEngineMailProcessor, 定型メール設定

</details>

## メールのテンプレートを作成する

FreeMarkerを使用した定型メール処理では件名と本文を1つのテンプレートに記述する。件名と本文はデリミタ行で分割される。デフォルトのデリミタは `---`（半角ハイフン3つ）。

テンプレート例:
```
${title}について${option}
---
${title}は、申請番号${requestId}で申請されました。
${approver}は速やかに${title}を承認してください。${option}
```

詳細な件名と本文の分割ルールは `TemplateEngineProcessedResult#valueOf` を参照。

テンプレートファイルの配置場所は `Configuration` の設定によって異なる。`basePackagePath` に `com/example/template/` を設定した場合、クラスパス上の `com/example/template/` ディレクトリにテンプレートファイルを配置する。

<details>
<summary>keywords</summary>

FreeMarker, テンプレート, 件名, 本文, デリミタ, TemplateEngineProcessedResult, basePackagePath

</details>

## メール送信要求を登録する

FreeMarkerアダプタを使用した定型メール送信要求の登録方法は通常の定型メール送信要求と同様。:ref:`mail-request` を参照。

<details>
<summary>keywords</summary>

メール送信要求, 定型メール, mail-request

</details>
