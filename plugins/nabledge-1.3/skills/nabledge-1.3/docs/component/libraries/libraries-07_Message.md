# メッセージ管理

## 概要

メッセージ管理機能はユーザに通知するメッセージを取り扱う。リポジトリに登録して使用し、初期化処理は :ref:`repository` が実行する。アプリケーションプログラマは画面表示に使用するメッセージの取得に使用する（詳細は :ref:`message_get_message` 以降を参照）。

**クラス**: `nablarch.core.message.StringResourceHolder`, `nablarch.core.message.BasicStringResourceLoader`, `nablarch.core.cache.BasicStaticDataCache`

メッセージ使用時は、リポジトリに `messageResource` というコンポーネント名で `MessageResource` クラスを登録する必要がある。

```xml
<component name="messageDbManager" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
  <property name="dbTransactionName" value="message"/>
</component>

<component name="stringResourceLoader" class="nablarch.core.message.BasicStringResourceLoader">
  <property name="dbManager" ref="messageDbManager"/>
  <property name="tableName" value="TEST_MESSAGE"/>
  <property name="idColumnName" value="MESSAGE_ID"/>
  <property name="langColumnName" value="LANG"/>
  <property name="valueColumnName" value="MESSAGE"/>
</component>

<component name="stringResourceHolder" class="nablarch.core.message.StringResourceHolder">
  <property name="stringResourceCache">
    <component class="nablarch.core.cache.BasicStaticDataCache">
      <!-- true: 初期化時一括ロード / false: オンデマンドロード -->
      <property name="loadOnStartup" value="true"/>
      <property name="loader" ref="stringResourceLoader"/>
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

メッセージ管理, メッセージ取得, リポジトリ登録, message_get_message, StringResourceHolder, BasicStringResourceLoader, BasicStaticDataCache, SimpleDbTransactionManager, messageResource, MessageResource, メッセージ設定, コンポーネント設定例, loadOnStartup

</details>

## 特徴

## 主な特徴

- **メッセージの取得**: メッセージIDを指定してユーザ通知メッセージを取得できる
- **国際化**: メッセージID1つに対して言語ごとに異なるメッセージを設定できる
- **メッセージのフォーマット**: `java.text.MessageFormat` 形式で可変文字をフォーマットして取得できる
- **メッセージのキャッシュ**: [./05_StaticDataCache](libraries-05_StaticDataCache.md) の機能を使用するため高速にアクセスできる。アプリケーションからキャッシュを意識する必要はない

## インタフェース定義

**インタフェース**: `nablarch.core.message.StringResource`  
ユーザ通知メッセージの元となる文字列リソースを保持する。文字列リソースはメッセージIDという単位で管理され、国際化アプリケーションでは1つのメッセージIDに言語ごとの複数の文字列が存在する。

## クラス定義

| クラス名 | 概要 |
|---|---|
| `nablarch.core.message.BasicStringResource` | StringResourceの基本実装クラス。各言語ごとの文字列リソースをMapに保持する |
| `nablarch.core.message.StringResourceHolder` | 文字列リソースを管理するクラス。キャッシュには [05_StaticDataCache](libraries-05_StaticDataCache.md) の機構を使用する |
| `nablarch.core.message.BasicStringResourceLoader` | キャッシュに必要な文字列リソースをデータベースから取得するクラス |
| `nablarch.core.message.MessageLevel` | メッセージの通知レベルを表す列挙型 |
| `nablarch.core.message.Message` | メッセージに必要な情報を保持しフォーマットを行うクラス。`StringResource`・`MessageLevel`・optionパラメータを持つ |
| `nablarch.core.message.ApplicationException` | 処理結果メッセージを通知する際に使用する例外クラス。`Message`のリストを持つ |
| `nablarch.core.message.MessageUtil` | アプリケーションがメッセージを取得する際に使用するユーティリティクラス |

**クラス**: `nablarch.core.message.StringResourceHolder`

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| stringResourceCache | ○ | StringResourceインタフェースを実装したクラスを保持するStaticDataCacheを設定する |

<details>
<summary>keywords</summary>

nablarch.core.message.StringResource, nablarch.core.message.BasicStringResource, nablarch.core.message.StringResourceHolder, nablarch.core.message.BasicStringResourceLoader, nablarch.core.message.MessageLevel, nablarch.core.message.Message, nablarch.core.message.ApplicationException, nablarch.core.message.MessageUtil, StringResource, BasicStringResource, StringResourceHolder, BasicStringResourceLoader, MessageLevel, Message, ApplicationException, MessageUtil, 国際化, メッセージフォーマット, メッセージキャッシュ, StaticDataCache, stringResourceCache, メッセージリソース設定

</details>

## メッセージテーブル

`BasicStringResourceLoader` は以下のデータベーステーブルから文字列リソースをロードする。テーブル名・カラム名は任意。データベースの型はJavaの型に変換可能な型を選択する。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| メッセージID | `java.lang.String` | プライマリキー |
| 言語 | `java.lang.String` | プライマリキー |
| メッセージ | `java.lang.String` | |

**クラス**: `nablarch.core.cache.BasicStaticDataCache`

設定内容は [./05_StaticDataCache](libraries-05_StaticDataCache.md) を参照。

> **警告**: このプロパティに設定する StaticDataLoader は、必ず `BasicStringResourceLoader` クラスのように、`StringResource` インタフェースを実装したクラスを読み込むように実装すること。

<details>
<summary>keywords</summary>

BasicStringResourceLoader, メッセージテーブル, テーブル定義, データベース, 文字列リソース, メッセージID, BasicStaticDataCache, nablarch.core.cache.BasicStaticDataCache, StaticDataLoader, StringResource, 静的データキャッシュ設定, メッセージキャッシュ

</details>

## テーブル定義の例

![テーブル定義の例](../../../knowledge/component/libraries/assets/libraries-07_Message/07_Message_DatabaseDiagram.jpg)

**クラス**: `nablarch.core.message.BasicStringResourceLoader`

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| dbManager | ○ | メッセージのロード時に使用する `SimpleDbTransactionManager` クラスを指定する |
| tableName | ○ | メッセージを永続化したテーブル名を指定する |
| idColumnName | ○ | メッセージを永続化したテーブルのメッセージIDのカラム名を指定する |
| langColumnName | ○ | メッセージを永続化したテーブルの言語のカラム名を指定する |
| valueColumnName | ○ | メッセージを永続化したテーブルのメッセージのカラム名を指定する |

<details>
<summary>keywords</summary>

テーブル定義の例, メッセージテーブル, データベース図, BasicStringResourceLoader, nablarch.core.message.BasicStringResourceLoader, dbManager, tableName, idColumnName, langColumnName, valueColumnName, メッセージローダー設定

</details>

## メッセージの取得

メッセージは `MessageUtil` を通じて取得する。

```java
// Message ID "MSG0001"の結果メッセージを取得
Message message = MessageUtil.createMessage(MessageLevel.INFO, "MSG0001");
```

<details>
<summary>keywords</summary>

MessageUtil, createMessage, MessageLevel, メッセージ取得, message_get_message

</details>

## メッセージのフォーマット

メッセージは `java.text.MessageFormat` の形式で埋め込み文字をフォーマットして出力できる。この機能を使用する場合、データベース上のメッセージカラムにはメッセージを埋め込み文字の状態で登録しておく。

メッセージテーブル例:

| メッセージID | 言語 | メッセージ |
|---|---|---|
| MSG0001 | ja | {0} は {1} から {2} の間で指定してください。 |

```java
// "price は 1 から 10 の間で指定してください。" が取得できる。
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001", "price", 1, 10);
String messageStr = message.formatMessage();
```

<details>
<summary>keywords</summary>

MessageFormat, formatMessage, メッセージフォーマット, 埋め込み文字, java.text.MessageFormat

</details>

## 国際化

データベースのメッセージテーブルに言語ごとに異なるメッセージを設定することで、言語に合わせたメッセージが取得できる。

- `Message.formatMessage()` を引数なしで呼び出した場合、`ThreadContext` に保持した言語のメッセージが取得できる
- 通常、`ThreadContext` にはフレームワークが適切な言語をセットするため、アプリケーション実装時に言語を意識する必要はない
- 画面上に複数言語を同時出力したい場合は、`formatMessage(Locale)` の引数に取得したい言語を指定する

> **注意**: ThreadContextの値はWebフレームワークまたはBatchフレームワークで初期化・クリアされる。詳細は [thread-context-label](libraries-thread_context.md) を参照。

メッセージテーブル例:

| メッセージID | 言語 | メッセージ |
|---|---|---|
| MSG0001 | en | User id is already registered. |
| MSG0001 | ja | そのユーザIDは既に登録されています。 |

```java
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");

ThreadContext.setLanguage(Locale.ENGLISH);
String messageStr1 = message.formatMessage(); // "User id is already registered."

ThreadContext.setLanguage(Locale.JAPANESE);
String messageStr2 = message.formatMessage(); // "そのユーザIDは既に登録されています。"

// 特定の言語を指定
String messageStr3 = message.formatMessage(Locale.ENGLISH); // "User id is already registered."
```

<details>
<summary>keywords</summary>

ThreadContext, formatMessage, Locale, 国際化, 多言語化, setLanguage

</details>

## オプションパラメータの国際化

メッセージのフォーマット時に使用するオプションパラメータについても、`StringResource` または `Message` をオプションパラメータに配置することで国際化できる。

メッセージテーブル例:

| メッセージID | 言語 | メッセージ |
|---|---|---|
| MSG0001 | en | value of {0} is not valid. |
| MSG0001 | ja | {0}の値が不正です。 |
| MSG0002 | en | unknown error occur. error message:"{0}". |
| MSG0002 | ja | 原因不明のエラーが発生しました。 エラーメッセージ:「{0}」。 |
| PRP0001 | en | name |
| PRP0001 | ja | 名前 |

**StringResourceを使用する実装例**:

```java
StringResource propertyStringResource = MessageUtil.getStringResource("PRP0001");
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001", propertyStringResource);

ThreadContext.setLanguage(Locale.ENGLISH);
String message1 = message.formatMessage(); // "value of name is not valid."

ThreadContext.setLanguage(Locale.JAPANESE);
String message2 = message.formatMessage(); // "名前の値が不正です。"

String message3 = message.formatMessage(Locale.ENGLISH); // "value of name is not valid."
```

**Messageを使用する実装例（Messageのネスト）**:

```java
StringResource propertyStringResource = MessageUtil.getStringResource("PRP0001");
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001", propertyStringResource);

ThreadContext.setLanguage(Locale.JAPANESE);
Message errorMessage =  = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0002", message);
String errorMessage1 = errorMessage.formatMessage(); // "原因不明のエラーが発生しました。 エラーメッセージ:「名前の値が不正です。」。"
```

<details>
<summary>keywords</summary>

StringResource, Message, getStringResource, オプションパラメータ, 国際化, Messageのネスト

</details>

## 例外によるメッセージの通知

業務的なエラーが発生した際のメッセージ通知には `ApplicationException` を使用する。`ApplicationException` またはそのサブクラスを使用することで、フレームワークが提供する例外処理機構が使用できる。

**例外を送出する側**:

```java
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");
throw new ApplicationException(message);
```

**例外からエラーメッセージを受け取る側**（フレームワークが処理）:

```java
try {
    anyBussinessLogic();
} catch (ApplicationException e) {
    List<Message> messages = e.getMessages();
    showErrorMessage(messages);
}
```

<details>
<summary>keywords</summary>

ApplicationException, getMessages, 例外処理, エラーメッセージ通知

</details>
