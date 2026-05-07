# E-mail FreeMarkerアダプタ

**目次**

* モジュール一覧
* E-mail FreeMarkerアダプタを使用するための設定を行う
* メールのテンプレートを作成する
* メール送信要求を登録する

[FreeMarker(外部サイト)](https://freemarker.apache.org/) を使用した定型メール送信処理を行うためのアダプタを提供する。

## モジュール一覧

```xml
<!-- E-mail FreeMarkerアダプタ -->
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-mail-sender-freemarker-adaptor</artifactId>
</dependency>
```

> **Tip:**
> FreeMarkerのバージョン2.3.27-incubatingを使用してテストを行っている。
> バージョンを変更する場合は、プロジェクト側でテストを行い問題ないことを確認すること。

## E-mail FreeMarkerアダプタを使用するための設定を行う

本アダプタを使用するためには、コンポーネント設定ファイルで FreeMarkerMailProcessor を MailRequester へ設定する。

`FreeMarkerMailProcessor` にはFreeMarkerが提供する `Configuration` を設定する必要がある。
`Configuration` は以下の理由により ComponentFactory の実装クラスを作成してコンポーネントを設定することを推奨する。

* `Configuration` はデフォルトコンストラクタが非推奨である
* `Configuration` への設定はコンポーネント設定ファイルよりもJavaコードで行う方がやりやすい

`Configuration` を作成する `ComponentFactory` 実装クラスの例を以下に示す。

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

この `ConfigurationFactory` を使用するコンポーネント設定ファイルの設定例を以下に示す。

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

## メールのテンプレートを作成する

FreeMarkerを使用した定型メール処理では件名と本文を1つのテンプレートに記述する。

件名と本文はデリミタと呼ばれる行で分割される。
デフォルトのデリミタは `---` である（半角のハイフンが3つ）。

テンプレートの例を以下に示す。

```none
${title}について${option}
---
${title}は、申請番号${requestId}で申請されました。
${approver}は速やかに${title}を承認してください。${option}
```

より詳しい件名と本文の分割ルールは TemplateEngineProcessedResult#valueOf を参照。

テンプレートファイルを配置する場所は `Configuration` の設定によって異なる。
例えば、前節で示した設定例だとテンプレートファイルはクラスパスからロードされる。
また、 `basePackagePath` に `com/example/template/` と設定されているので、クラスパス上の `com/example/template/` ディレクトリにテンプレートファイルを配置することになる。

## メール送信要求を登録する

単に定型メールの送信要求を登録すればよい。
[メール送信要求を登録する](../../component/libraries/libraries-mail.md#メール送信要求を登録する) を参照。
