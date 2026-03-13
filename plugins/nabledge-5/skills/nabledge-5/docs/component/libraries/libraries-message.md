# メッセージ管理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/message.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/java/text/MessageFormat.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/PropertiesStringResourceLoader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Locale.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/ThreadContext.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/ApplicationException.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/MessageUtil.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/Message.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Properties.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Map.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/MessageLevel.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/WebUtil.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/BasicStringResourceLoader.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/MessageFormatter.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/BasicMessageFormatter.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/JavaMessageFormatBaseMessageFormatter.html)

## 機能概要

メッセージとは、画面の固定文言（項目タイトルなど）やエラーメッセージのことを指す。国際化の要件がなければJSPに直接埋め込んでも問題ない。

> **補足**: メッセージは安易に共通化せずに個別に定義すること。共通化すると、他業務の仕様変更でメッセージが変更された際に無関係なメッセージが表示される問題が発生する。

## メッセージの定義場所

データベースまたはプロパティファイルで管理できる。デフォルトはプロパティファイル。

> **補足**: アプリケーション実行中にメッセージを更新する機能は提供していない。メッセージ更新にはアプリケーションの再起動が必要。

## メッセージのフォーマット

`java.text.MessageFormat` の拡張機能を使用してフォーマットする。

### プロパティファイル名や格納場所を変更する

`PropertiesStringResourceLoader` にはファイル名やディレクトリパスを変更するプロパティが用意されている。デフォルト構成を変更する場合はこれらのプロパティを使用すること。

<details>
<summary>keywords</summary>

メッセージ管理, メッセージ定義場所, プロパティファイル管理, メッセージフォーマット, MessageFormat, メッセージ共通化, PropertiesStringResourceLoader, プロパティファイル設定変更, ファイル名変更, ディレクトリパス変更

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

### メッセージをデータベースで管理する

`BasicStringResourceLoader` を使用してメッセージをロードする。

```xml
<!-- データベースからメッセージをロードするコンポーネント -->
<component name="stringResourceLoader" class="nablarch.core.message.BasicStringResourceLoader">
  <property name="dbManager" ref="defaultDbManager"/>
  <property name="tableName" value="MESSAGE"/>
  <property name="idColumnName" value="ID"/>
  <property name="langColumnName" value="LANG"/>
  <property name="valueColumnName" value="MESSAGE"/>
</component>

<!-- ロードしたメッセージをキャッシュするコンポーネント -->
<component name="stringResourceCache" class="nablarch.core.cache.BasicStaticDataCache">
  <!-- ローダーには、データベースからメッセージをロードするクラスを指定する -->
  <property name="loader" ref="stringResourceLoader"/>
  <!-- 起動時に一括でロードする -->
  <property name="loadOnStartup" value="true"/>
</component>

<!-- コンポーネント名はstringResourceHolderとすること -->
<component name="stringResourceHolder" class="nablarch.core.message.StringResourceHolder">
  <!-- メッセージをキャッシュするコンポーネントを指定する -->
  <property name="stringResourceCache" ref="stringResourceCache"/>
</component>
```

<details>
<summary>keywords</summary>

nablarch-core, nablarch-core-message, nablarch-common-jdbc, モジュール依存関係, Maven, BasicStringResourceLoader, BasicStaticDataCache, StringResourceHolder, stringResourceLoader, stringResourceCache, stringResourceHolder, データベースメッセージ管理, dbManager, tableName, loadOnStartup

</details>

## プロパティファイルの作成単位

アプリケーション単位に作成する。1システムでも社内向けとコンシューマ向けが別アプリの場合は各々作成する。これによりメッセージの影響範囲をアプリケーション内に限定できる。

例:
- コンシューマ向け: `consumer/main/resources/messages.properties`
- 社員向け: `intra/main/resources/messages.properties`

### メッセージのフォーマット方法を変更する

`MessageFormatter` の実装クラスを作成し、コンポーネント名 `messageFormatter` でコンポーネント定義することでフォーマット方法を変更できる。

MessageFormatterの実装クラス:

```java
public class SampleMessageFormatter implements MessageFormatter {
    @Override
    public String format(final String template, final Object[] options) {
        return String.format(template, options);
    }
}
```

コンポーネント設定ファイル:

```xml
<!-- コンポーネント名をmessageFormatterとして定義する。 -->
<component name="messageFormatter" class="sample.SampleMessageFormatter" />
```

提供されている `MessageFormatter` 実装クラス:

- `BasicMessageFormatter`: [埋め込み文字の仕様](#) に従いフォーマット。`MessageFormatter` の実装クラスがコンポーネント定義されていない場合はこのクラスが使用される。
- `JavaMessageFormatBaseMessageFormatter`: `MessageFormat` を使用してフォーマット。

<details>
<summary>keywords</summary>

messages.properties, プロパティファイル作成単位, アプリケーション単位, メッセージ影響範囲, MessageFormatter, BasicMessageFormatter, JavaMessageFormatBaseMessageFormatter, messageFormatter, メッセージフォーマット変更, SampleMessageFormatter, MessageFormat

</details>

## プロパティファイルへのメッセージ定義

デフォルトパス: `classpath:messages.properties`。`java.util.Properties` を使用してロード。**UTF-8**で作成すればよくユニコード変換（native2ascii）は不要。

```properties
label.user.register.title=ユーザ登録画面
errors.login.alreadyExist=入力されたログインIDは既に登録されています。別のログインIDを入力してください。
errors.compare.date={0}は{1}より後の日付を入力してください。
success.delete.project=プロジェクトの削除が完了しました。
```

<details>
<summary>keywords</summary>

messages.properties, Properties, UTF-8, native2ascii, プロパティファイル定義, classpath

</details>

## 多言語化対応

言語ごとのプロパティファイルを用意し、`PropertiesStringResourceLoader.locales` にサポート言語を設定する。なお、デフォルトのロケールに対応する言語については、サポートする言語に追加しなくても良い。

> **重要**: `PropertiesStringResourceLoader.defaultLocale` を必ず設定すること。未設定の場合 `Locale.getDefault().getLanguage()` が使われるが、OS設定に依存するため実行環境によって値が変わり障害の原因になる。

メッセージ取得時のロケールは `ThreadContext#getLanguage` の値を使用する。取得できない場合は `Locale.getDefault()` を使用。

XML設定例（en/zh/deをサポート、デフォルトja）:
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

ファイル名: `messages_言語.properties`（例: `messages_en.properties`）。デフォルトロケール用は `messages.properties`（言語なし）。`messages.properties` が存在しない場合はエラーで処理終了。

```
main/resources/messages.properties       # デフォルトの言語に対応したファイル
               messages_en.properties    # enに対応したファイル
               messages_zh.properties    # zhに対応したファイル
               messages_de.properties    # deに対応したファイル
```

<details>
<summary>keywords</summary>

PropertiesStringResourceLoader, 多言語化, locales, defaultLocale, ThreadContext, StringResourceHolder, BasicStaticDataCache, BasicApplicationInitializer

</details>

## 業務例外の送出

`MessageUtil` でメッセージを取得し、`ApplicationException` を生成して送出する。

プロパティファイル:
```properties
errors.login.alreadyExist=入力されたログインIDは既に登録されています。別のログインIDを入力してください。
```

実装例:
```java
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "errors.login.alreadyExist");
throw new ApplicationException(message);
```

<details>
<summary>keywords</summary>

ApplicationException, MessageUtil, MessageLevel, 業務例外

</details>

## 埋め込み文字

`java.text.MessageFormat` 形式に対応。埋め込み値に `Map` **のみ**を指定した場合は、Mapのキー名を `{キー名}` 形式で記述する拡張機能を使用する。

> **重要**: 複数のMapや、Map以外の値とセットで指定した場合は `java.text.MessageFormat` を使用した値の埋め込み処理を行う（拡張機能は使われない）。

Map以外（`{0}` 形式）:
```properties
success.upload.project={0}件のプロジェクトを登録しました。
```
```java
MessageUtil.createMessage(MessageLevel.INFO, "success.upload.project", projects.size());
```

Mapのみ（`{キー名}` 形式）:
```properties
success.upload.project={projectCount}件のプロジェクトを登録しました。
```
```java
Map<String, Object> options = new HashMap<>();
options.put("projectCount", projects.size());
MessageUtil.createMessage(MessageLevel.INFO, "success.upload.project", options);
```

<details>
<summary>keywords</summary>

MessageUtil, MessageFormat, Map, 埋め込み文字, パターン文字列, message-format-spec

</details>

## 画面固定文言の取得

カスタムタグライブラリの `message` タグ（`tag-write_message` 参照）でメッセージ値を出力する。

プロパティファイル:
```properties
login.title=ログイン
```

JSP:
```jsp
<div class="title-nav">
  <span><n:message messageId="login.title" /></span>
</div>
```

プロパティファイルに定義したメッセージが固定文言として表示される。

<details>
<summary>keywords</summary>

messageタグ, 固定文言, n:message, tag-write_message, JSP

</details>

## メッセージレベル

`MessageLevel` に定義される `INFO`、`WARN`、`ERROR` の3種類。

> **重要**: errorsタグによるメッセージレベルのスタイル切り替えは以下の問題があるため非推奨: (1) CSSフレームワークとの相性が悪い (2) メッセージレベルが3種類のみで細かい分類ができない (3) JSP以外のテンプレートエンジンで使用不可。推奨実装: サーバサイドでメッセージ文字列を構築しINFOレベルでリクエストスコープに設定し、View側で `write` タグで出力する。

推奨実装例:
```java
// サーバサイド
context.setRequestScopedVar("message",
    MessageUtil.createMessage(MessageLevel.INFO, "login.message").formatMessage());
```
```jsp
<div class="alert alert-success" role="alert">
  <n:write name="message" />
</div>
```

errorsタグ使用時のCSSクラス（非推奨）:
- `INFO` → `nablarch_info`
- `WARN` → `nablarch_warn`
- `ERROR` → `nablarch_error`

`errors` タグで出力するメッセージは、`WebUtil.notifyMessages` を使ってリクエストスコープに格納する。

```java
WebUtil.notifyMessages(context, MessageUtil.createMessage(MessageLevel.INFO, "info"));
WebUtil.notifyMessages(context, MessageUtil.createMessage(MessageLevel.WARN, "warn"));
WebUtil.notifyMessages(context, MessageUtil.createMessage(MessageLevel.ERROR, "error"));
```

> **補足**: バリデーション機能から送出される `ApplicationException` のメッセージは全て `ERROR` レベル。

<details>
<summary>keywords</summary>

MessageLevel, INFO, WARN, ERROR, errorsタグ, WebUtil, nablarch_info, nablarch_warn, nablarch_error, notifyMessages

</details>
