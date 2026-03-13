# E-mail Velocityアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/mail_sender_velocity_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/mail/velocity/VelocityMailProcessor.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailRequester.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/ComponentFactory.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/TemplateEngineProcessedResult.html)

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-mail-sender-velocity-adaptor</artifactId>
</dependency>
```

> **補足**: Velocityバージョン2.0でテスト済み。バージョンを変更する場合は、プロジェクト側でテストを行い問題ないことを確認すること。

<details>
<summary>keywords</summary>

nablarch-mail-sender-velocity-adaptor, com.nablarch.integration, Velocity, メールアダプタ, モジュール依存関係, Velocityバージョン

</details>

## E-mail Velocityアダプタを使用するための設定を行う

`VelocityMailProcessor` を `MailRequester` へ設定する。

`VelocityMailProcessor` には `VelocityEngine` を設定する必要がある。`VelocityEngine` は `ComponentFactory` 実装クラス経由で設定することを推奨。理由: (1) VelocityEngineへの設定はJavaコードの方がやりやすい (2) `VelocityEngine` 設定後に `init` メソッドを呼ぶ必要がある。

`VelocityEngine` を作成する `ComponentFactory` 実装クラスの例:

```java
public class VelocityEngineFactory implements ComponentFactory<VelocityEngine> {
    @Override
    public VelocityEngine createObject() {
        VelocityEngine velocityEngine = new VelocityEngine();
        velocityEngine.setProperty("resource.loader", "classloader");
        velocityEngine.setProperty("classloader.resource.loader.class",
                ClasspathResourceLoader.class.getName());
        //必要に応じてVelocityEngineへその他の設定を行う
        velocityEngine.init();
        return velocityEngine;
    }
}
```

コンポーネント設定ファイルの例:

```xml
<component name="templateEngineMailProcessor"
           class="nablarch.integration.mail.velocity.VelocityMailProcessor" autowireType="None">
  <property name="velocityEngine">
    <component class="com.example.VelocityEngineFactory"/>
  </property>
</component>

<component name="mailRequester" class="nablarch.common.mail.MailRequester">
  <property name="templateEngineMailProcessor" ref="templateEngineMailProcessor"/>
</component>
```

<details>
<summary>keywords</summary>

VelocityMailProcessor, MailRequester, ComponentFactory, VelocityEngine, VelocityEngineFactory, nablarch.integration.mail.velocity.VelocityMailProcessor, nablarch.common.mail.MailRequester, nablarch.core.repository.di.ComponentFactory, templateEngineMailProcessor, Velocity設定, コンポーネント設定, ClasspathResourceLoader

</details>

## メールのテンプレートを作成する

件名と本文を1つのテンプレートに記述する。件名と本文はデリミタ行で分割され、デフォルトのデリミタは `---`（半角ハイフン3つ）。

テンプレートの例:

```
$titleについて$option
---
$titleは、申請番号$requestIdで申請されました。
$approverは速やかに$titleを承認してください。$option
```

件名と本文の分割ルールの詳細は `TemplateEngineProcessedResult#valueOf` を参照。

テンプレートファイルの配置場所は `VelocityEngine` の設定に依存する（例: `ClasspathResourceLoader` を使用する場合はクラスパス上のディレクトリに配置）。

<details>
<summary>keywords</summary>

TemplateEngineProcessedResult, VelocityEngine, デリミタ, 件名本文分割, テンプレート作成, ClasspathResourceLoader

</details>

## メール送信要求を登録する

定型メールの送信要求を登録する。:ref:`mail-request` を参照。

<details>
<summary>keywords</summary>

mail-request, 定型メール送信, メール送信要求登録

</details>
