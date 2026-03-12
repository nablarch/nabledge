# メッセージ管理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/message.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/java/text/MessageFormat.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Properties.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/PropertiesStringResourceLoader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Locale.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/MessageUtil.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/ApplicationException.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/Message.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Map.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/MessageLevel.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/WebUtil.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/BasicStringResourceLoader.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/MessageFormatter.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/BasicMessageFormatter.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/JavaMessageFormatBaseMessageFormatter.html)

## 機能概要

国際化の要件がなければ、画面の固定文言はJSPに直接埋め込んでも問題ない。

> **補足**: メッセージは安易に共通化せず、個別に定義すること。共通化すると他業務の仕様変更で無関係なメッセージが表示される問題が発生する。

メッセージはデータベースまたはプロパティファイルで管理できる。デフォルトはプロパティファイル。プロパティファイルはメッセージの追加・変更・確認が容易なため。

> **補足**: アプリケーション実行中のメッセージ更新機能は提供していない。メッセージを更新する場合はアプリケーションの再起動が必要。

メッセージのフォーマットには `java.text.MessageFormat` の拡張機能を使用する。実行時の値を埋め込む場合は [message-format-spec](#) のパターン文字列を定義する。

## プロパティファイル名や格納場所を変更する

`PropertiesStringResourceLoader` にはファイル名やディレクトリのパスを変更するためのプロパティが用意されている。デフォルト構成を変更したい場合はこれらのプロパティを使用すること。

## メッセージをデータベースで管理する

メッセージをデータベースで管理するには `BasicStringResourceLoader` を使用する。

```xml
<component name="stringResourceLoader" class="nablarch.core.message.BasicStringResourceLoader">
  <property name="dbManager" ref="defaultDbManager"/>
  <property name="tableName" value="MESSAGE"/>
  <property name="idColumnName" value="ID"/>
  <property name="langColumnName" value="LANG"/>
  <property name="valueColumnName" value="MESSAGE"/>
</component>

<component name="stringResourceCache" class="nablarch.core.cache.BasicStaticDataCache">
  <property name="loader" ref="stringResourceLoader"/>
  <property name="loadOnStartup" value="true"/>
</component>

<!-- コンポーネント名はstringResourceHolderとすること -->
<component name="stringResourceHolder" class="nablarch.core.message.StringResourceHolder">
  <property name="stringResourceCache" ref="stringResourceCache"/>
</component>
```

## メッセージのフォーマット方法を変更する

`MessageFormatter` の実装クラスを作成しコンポーネント名 `messageFormatter` でコンポーネント定義することでフォーマット方法を変更できる。実装クラスが未定義の場合は `BasicMessageFormatter` が使用される。

```java
public class SampleMessageFormatter implements MessageFormatter {
    @Override
    public String format(final String template, final Object[] options) {
        return String.format(template, options);
    }
}
```

```xml
<component name="messageFormatter" class="sample.SampleMessageFormatter" />
```

提供されている実装クラス:

- `BasicMessageFormatter`: [埋め込み文字の仕様](#) に従いフォーマット。実装クラスが未定義の場合はこのクラスが使用される。
- `JavaMessageFormatBaseMessageFormatter`: `MessageFormat` を使用してフォーマット。

<details>
<summary>keywords</summary>

メッセージ管理, プロパティファイル, データベース管理, メッセージフォーマット, java.text.MessageFormat, MessageFormat, 実行中更新不可, PropertiesStringResourceLoader, BasicStringResourceLoader, BasicStaticDataCache, StringResourceHolder, MessageFormatter, BasicMessageFormatter, JavaMessageFormatBaseMessageFormatter, プロパティファイル設定変更, データベースメッセージ管理, メッセージフォーマット変更

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-message</artifactId>
</dependency>

<!-- メッセージをデータベースで管理する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core, nablarch-core-message, nablarch-common-jdbc, Maven依存関係, モジュール

</details>

## プロパティファイルの作成単位

プロパティファイルはアプリケーション単位に作成する。1つのシステムで社内向けとコンシューマ向けのアプリケーションがある場合は、それぞれにプロパティファイルを作成する。これによりメッセージの影響範囲をアプリケーション内に限定できる。

例:
- コンシューマ向け: `consumer/main/resources/messages.properties`
- 社員向け: `intra/main/resources/messages.properties`

<details>
<summary>keywords</summary>

プロパティファイル作成単位, アプリケーション単位, messages.properties, 影響範囲, メッセージ管理

</details>

## プロパティファイルにメッセージを定義する

デフォルトのプロパティファイルパスは `classpath:messages.properties`。

`java.util.Properties` でロードする。Nablarch 6はJava 17以上を前提とするため、**UTF-8**で作成すればよい。unicode変換(native2ascii)は不要。

```properties
label.user.register.title=ユーザ登録画面
errors.login.alreadyExist=入力されたログインIDは既に登録されています。別のログインIDを入力してください。
errors.compare.date={0}は{1}より後の日付を入力してください。
success.delete.project=プロジェクトの削除が完了しました。
success.update.project=プロジェクトの更新が完了しました。
```

<details>
<summary>keywords</summary>

messages.properties, classpath, UTF-8, java.util.Properties, プロパティファイル定義, native2ascii

</details>

## 多言語化対応

多言語化するには言語ごとのプロパティファイルを作成し、`PropertiesStringResourceLoader.locales` にサポート言語を設定する。デフォルトロケールに対応する言語はサポート言語に追加しなくても良い。

> **重要**: デフォルトロケールは `PropertiesStringResourceLoader.defaultLocale` で必ず設定すること。未設定の場合は `Locale.getDefault().getLanguage()` が使われるが、この値はOS設定によって変化するため障害の原因になる。

メッセージ取得時の言語は `ThreadContext#getLanguage` が返すロケールで決定される。取得できない場合は `Locale.getDefault()` が使用される。

**XML設定例** (`en`、`zh`、`de` をサポートし `ja` をデフォルトとする場合):

```xml
<component class="nablarch.core.cache.BasicStaticDataCache" name="messageCache">
  <property name="loader">
    <component class="nablarch.core.message.PropertiesStringResourceLoader">
      <property name="locales">
        <list>
          <value>en</value>
          <value>zh</value>
          <value>de</value>
        </list>
      </property>
      <property name="defaultLocale" value="ja" />
    </component>
  </property>
</component>

<component name="stringResourceHolder" class="nablarch.core.message.StringResourceHolder">
  <property name="stringResourceCache" ref="messageCache" />
</component>

<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="messageCache" />
    </list>
  </property>
</component>
```

**プロパティファイルのファイル名規則**:
- デフォルトロケール: `messages.properties`
- 言語別: `messages_{言語}.properties`（例: `messages_en.properties`）
- `messages.properties` が存在しない場合はエラーになる

<details>
<summary>keywords</summary>

PropertiesStringResourceLoader, 多言語化, defaultLocale, ThreadContext, locales, 言語設定, BasicStaticDataCache, StringResourceHolder, BasicApplicationInitializer

</details>

## メッセージを持つ業務例外を送出する

`MessageUtil` でメッセージを取得し、`ApplicationException` を生成して送出する。

```properties
errors.login.alreadyExist=入力されたログインIDは既に登録されています。別のログインIDを入力してください。
```

```java
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "errors.login.alreadyExist");
throw new ApplicationException(message);
```

<details>
<summary>keywords</summary>

ApplicationException, MessageUtil, 業務例外, MessageLevel, createMessage, メッセージ送出, Message, nablarch.core.message.Message

</details>

## 埋め込み文字を使用する

`java.text.MessageFormat` 形式の埋め込み文字に対応。埋め込み文字に `Map` **のみ**を指定した場合は、Mapのキー値を使う拡張機能が使用される。

**Map以外を使う場合** (MessageFormat仕様):

```properties
success.upload.project={0}件のプロジェクトを登録しました。
```

```java
MessageUtil.createMessage(MessageLevel.INFO, "success.upload.project", projects.size());
```

**Mapのみを使う場合** (キー名で埋め込み):

```properties
success.upload.project={projectCount}件のプロジェクトを登録しました。
```

```java
Map<String, Object> options = new HashMap<>();
options.put("projectCount", projects.size());
MessageUtil.createMessage(MessageLevel.INFO, "success.upload.project", options);
```

> **重要**: キー名埋め込みはMapのみを指定した場合のみ有効。複数のMapや、Map以外の値と組み合わせた場合はMessageFormatが使われる。

フォーマット方法を変更する場合は [message-change_formatter](#) を参照。

<details>
<summary>keywords</summary>

MessageFormat, java.text.MessageFormat, java.util.Map, 埋め込み文字, MessageUtil, パターン文字

</details>

## 画面の固定文言をメッセージから取得する

画面の固定文言にメッセージを出力するには、カスタムタグライブラリの `message` タグを使用する。詳細は :ref:`tag-write_message` を参照。

```properties
login.title=ログイン
```

```jsp
<div class="title-nav">
  <span><n:message messageId="login.title" /></span>
</div>
```

<details>
<summary>keywords</summary>

messageタグ, 固定文言, JSP, n:message, tag-write_message, カスタムタグ

</details>

## メッセージレベルを使い分ける

メッセージレベルは `MessageLevel` に `INFO`、`WARN`、`ERROR` の3種類が定義されている。

> **重要**: errorsタグによるスタイル切り替えは非推奨。理由: (1) カスタムタグのDOM構造がCSSフレームワークと相性が悪い (2) メッセージレベルが3種類のみで細分類不可 (3) JSP以外のテンプレートエンジンで使用不可。代わりに以下を推奨:
> - サーバサイドで `MessageUtil.createMessage(MessageLevel.INFO, "key").formatMessage()` でメッセージ文字列を生成しリクエストスコープに設定する
> - Viewでは [write](libraries-tag_reference.md) タグでリクエストスコープのメッセージを出力する

errorsタグを使う場合、メッセージレベルに応じたCSSクラス（詳細: :ref:`tag-write_error`）:

| メッセージレベル | CSSクラス |
|---|---|
| INFO | nablarch_info |
| WARN | nablarch_warn |
| ERROR | nablarch_error |

> **補足**: [バリデーション機能](libraries-validation.md) から送出される `ApplicationException` のメッセージは全てERRORレベル。

errorsタグで出力するメッセージは `WebUtil.notifyMessages` でリクエストスコープに格納する。

```java
WebUtil.notifyMessages(context, MessageUtil.createMessage(MessageLevel.INFO, "info"));
WebUtil.notifyMessages(context, MessageUtil.createMessage(MessageLevel.WARN, "warn"));
WebUtil.notifyMessages(context, MessageUtil.createMessage(MessageLevel.ERROR, "error"));
```

JSPでは `errors` タグを使用して、WebUtilに格納したメッセージを画面表示する。

```jsp
<n:errors />
```

<details>
<summary>keywords</summary>

MessageLevel, nablarch_info, nablarch_warn, nablarch_error, errorsタグ, WebUtil, ApplicationException, INFO, WARN, ERROR, notifyMessages

</details>
