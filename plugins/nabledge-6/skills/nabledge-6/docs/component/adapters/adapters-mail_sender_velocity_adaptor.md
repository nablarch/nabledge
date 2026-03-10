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

> **補足**: Velocityのバージョン2.0を使用してテストを行っている。バージョンを変更する場合は、プロジェクト側でテストを行い問題ないことを確認すること。

<details>
<summary>keywords</summary>

nablarch-mail-sender-velocity-adaptor, Velocityアダプタ, メール送信モジュール, Maven依存関係, Velocity 2.0

</details>

## E-mail Velocityアダプタを使用するための設定を行う

`VelocityMailProcessor` を `MailRequester` の `templateEngineMailProcessor` プロパティに設定する。

`VelocityEngine` の設定には `ComponentFactory` の実装クラスを作成してコンポーネントを設定することを推奨する。理由:
- コンポーネント設定ファイルよりJavaコードで設定する方がやりやすい
- `VelocityEngine` を設定した後に `init` メソッドを呼ぶ必要がある

`VelocityEngineFactory` 実装例:
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

コンポーネント設定ファイル例:
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

VelocityMailProcessor, MailRequester, ComponentFactory, VelocityEngine, VelocityEngineFactory, ClasspathResourceLoader, 定型メール設定, コンポーネント設定, VelocityEngine初期化, templateEngineMailProcessor

</details>

## メールのテンプレートを作成する

件名と本文を1つのテンプレートファイルに記述する。デリミタ（デフォルト: `---`、半角ハイフン3つ）の行で件名と本文を分割する。

テンプレート例:
```
$titleについて$option
---
$titleは、申請番号$requestIdで申請されました。
$approverは速やかに$titleを承認してください。$option
```

件名と本文の分割ルール詳細は `TemplateEngineProcessedResult#valueOf` を参照。

テンプレートファイルの配置場所は `VelocityEngine` の設定に依存する。クラスパスローダを使用する設定例の場合、テンプレートファイルはクラスパス上のディレクトリに配置する。

<details>
<summary>keywords</summary>

TemplateEngineProcessedResult, メールテンプレート, 件名, 本文, デリミタ, Velocityテンプレート, テンプレートファイル配置

</details>

## メール送信要求を登録する

定型メールの送信要求の登録方法は :ref:`mail-request` を参照。

<details>
<summary>keywords</summary>

メール送信要求, 定型メール登録, mail-request

</details>
