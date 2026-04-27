# E-mail Thymeleafアダプタ

**目次**

* モジュール一覧
* E-mail Thymeleafアダプタを使用するための設定を行う
* メールのテンプレートを作成する
* メール送信要求を登録する

[Thymeleaf(外部サイト)](https://www.thymeleaf.org) を使用した定型メール送信処理を行うためのアダプタを提供する。

## モジュール一覧

```xml
<!-- E-mail Thymeleafアダプタ -->
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-mail-sender-thymeleaf-adaptor</artifactId>
</dependency>
```

> **Tip:**
> Thymeleafのバージョン3.0.9.RELEASEを使用してテストを行っている。
> バージョンを変更する場合は、プロジェクト側でテストを行い問題ないことを確認すること。

## E-mail Thymeleafアダプタを使用するための設定を行う

本アダプタを使用するためには、コンポーネント設定ファイルで ThymeleafMailProcessor を MailRequester へ設定する。

`ThymeleafMailProcessor` にはThymeleafが提供する `TemplateEngine` を設定する必要がある。

コンポーネント設定ファイルの設定例を以下に示す。

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

<!-- メール送信要求API -->
<component name="mailRequester" class="nablarch.common.mail.MailRequester">
  <property name="templateEngineMailProcessor" ref="templateEngineMailProcessor"/>
  <!-- その他の設定は省略 -->
</component>
```

## メールのテンプレートを作成する

Thymeleafを使用した定型メール処理では件名と本文を1つのテンプレートに記述する。

件名と本文はデリミタと呼ばれる行で分割される。
デフォルトのデリミタは `---` である（半角のハイフンが3つ）。

テンプレートの例を以下に示す。

```none
[(${title})]について[(${option})]
---
[(${title})]は、申請番号[(${requestId})]で申請されました。
[(${approver})]は速やかに[(${title})]を承認してください。[(${option})]
```

より詳しい件名と本文の分割ルールは TemplateEngineProcessedResult#valueOf を参照。

テンプレートファイルを配置する場所は `TemplateEngine` の設定によって異なる。
例えば、前節で示した設定例だとテンプレートファイルはクラスパスからロードされる。
また、 `ClassLoaderTemplateResolver` の `prefix` に `com/example/template/` と設定されているので、クラスパス上の `com/example/template/` ディレクトリにテンプレートファイルを配置することになる。

## メール送信要求を登録する

単に定型メールの送信要求を登録すればよい。
[メール送信要求を登録する](../../component/libraries/libraries-mail.md#mail-request) を参照。
