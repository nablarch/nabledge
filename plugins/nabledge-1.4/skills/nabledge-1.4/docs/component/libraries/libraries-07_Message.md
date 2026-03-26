# メッセージ管理

## 概要

メッセージ管理機能はリポジトリに登録して使用する。初期化処理は :ref:`repository` が実行する。アプリケーションプログラマはメッセージ取得（画面表示用）に使用する。

リポジトリに `messageResource` というコンポーネント名で `MessageResource` クラスを登録する必要がある。

**設定例**:

```xml
<!-- SimpleDbTransactionManager の設定 -->
<component name="messageDbManager" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
    <property name="dbTransactionName" value="message"/>
</component>

<component name="stringResourceLoader"
    class="nablarch.core.message.BasicStringResourceLoader">
  <property name="dbManager" ref="messageDbManager"/>
  <property name="tableName" value="TEST_MESSAGE"/>
  <property name="idColumnName" value="MESSAGE_ID"/>
  <property name="langColumnName" value="LANG"/>
  <property name="valueColumnName" value="MESSAGE"/>
</component>

<component name="stringResourceHolder" class="nablarch.core.message.StringResourceHolder">
  <property name="stringResourceCache">
    <component class="nablarch.core.cache.BasicStaticDataCache">
      <!-- loadOnStartup: true=起動時一括ロード, false=オンデマンドロード -->
      <property name="loadOnStartup" value="true"/>
      <property name="loader" ref="stringResourceLoader"/>
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

メッセージ管理, リポジトリ登録, 初期化, メッセージ取得, messageResource, MessageResource, BasicStringResourceLoader, StringResourceHolder, BasicStaticDataCache, SimpleDbTransactionManager, loadOnStartup, メッセージ設定, コンポーネント登録

</details>

## 特徴

## 特徴

- メッセージIDを指定してメッセージを取得できる
- 国際化: メッセージID1つに対して言語ごとに異なるメッセージを設定できる
- `java.text.MessageFormat` 形式で可変文字をフォーマット可能
- メッセージは [./05_StaticDataCache](libraries-05_StaticDataCache.md) の機能を使用してキャッシュされる（アプリ側でキャッシュを意識する必要はない）

## インタフェース/クラス定義

**インタフェース**: `nablarch.core.message.StringResource`
- ユーザに通知するメッセージの元となる文字列リソースを保持。メッセージIDという単位で管理。国際化アプリではメッセージID1つに言語ごとの複数の文字列が存在する。

| クラス名 | 概要 |
|---|---|
| `nablarch.core.message.BasicStringResource` | StringResourceの基本実装。各言語の文字列リソースをMapで保持 |
| `nablarch.core.message.StringResourceHolder` | 文字列リソースを管理するクラス。キャッシュに [05_StaticDataCache](libraries-05_StaticDataCache.md) を使用 |
| `nablarch.core.message.BasicStringResourceLoader` | DBから文字列リソースを取得するローダー。StringResourceにはBasicStringResourceを使用 |
| `nablarch.core.message.MessageLevel` | メッセージの通知レベルを表す列挙型 |
| `nablarch.core.message.Message` | メッセージ情報（StringResource、MessageLevel、optionパラメータ）を保持しフォーマットを行う |
| `nablarch.core.message.ApplicationException` | 処理結果メッセージ通知に使用する例外クラス。Messageのリストを持つ |
| `nablarch.core.message.MessageUtil` | アプリケーションがメッセージを取得する際に使用するユーティリティクラス |

**クラス**: `nablarch.core.message.StringResourceHolder`

| プロパティ名 | 設定内容 |
|---|---|
| stringResourceCache (必須) | StringResourceインタフェースを実装したクラスを保持するStaticDataCacheを設定する |

<details>
<summary>keywords</summary>

メッセージID, 国際化, MessageFormat, StaticDataCache, StringResource, BasicStringResource, StringResourceHolder, BasicStringResourceLoader, MessageLevel, Message, ApplicationException, MessageUtil, キャッシュ, stringResourceCache, nablarch.core.message.StringResourceHolder, メッセージリソース設定

</details>

## メッセージテーブル

`BasicStringResourceLoader` がDBから文字列リソースをロードするテーブル。テーブル名・カラム名は任意。DBの型はJavaの型に変換可能な型を選択する。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| メッセージID | java.lang.String | プライマリキー |
| 言語 | java.lang.String | プライマリキー |
| メッセージ | java.lang.String | |

**クラス**: `nablarch.core.cache.BasicStaticDataCache`

詳細は `05_StaticDataCache` を参照。

> **警告**: このプロパティに設定する StaticDataLoader は、必ず `BasicStringResourceLoader` クラスのように、`StringResource` インタフェースを実装したクラスを読み込むように実装すること。

<details>
<summary>keywords</summary>

メッセージテーブル, BasicStringResourceLoader, テーブル定義, メッセージID, 言語, 文字列リソース, BasicStaticDataCache, StringResource, StaticDataLoader, nablarch.core.cache.BasicStaticDataCache, キャッシュ設定, StaticDataCache

</details>

## テーブル定義の例

メッセージテーブルのデータベース設計例。

![テーブル定義の例](../../../knowledge/component/libraries/assets/libraries-07_Message/07_Message_DatabaseDiagram.jpg)

**クラス**: `nablarch.core.message.BasicStringResourceLoader`

| プロパティ名 | 設定内容 |
|---|---|
| dbManager (必須) | メッセージのロード時に使用するSimpleDbTransactionManagerクラスを指定する |
| tableName (必須) | メッセージを永続化したテーブル名を指定する |
| idColumnName (必須) | メッセージを永続化したテーブルのメッセージIDのカラム名を指定する |
| langColumnName (必須) | メッセージを永続化したテーブルの言語のカラム名を指定する |
| valueColumnName (必須) | メッセージを永続化したテーブルのメッセージのカラム名を指定する |

<details>
<summary>keywords</summary>

テーブル定義の例, データベース設計, メッセージテーブル構造, BasicStringResourceLoader, dbManager, tableName, idColumnName, langColumnName, valueColumnName, nablarch.core.message.BasicStringResourceLoader, メッセージテーブル設定

</details>

## メッセージの取得

`MessageUtil` を使用してメッセージを取得する。

```java
// Message ID "MSG0001"の結果メッセージを取得
Message message = MessageUtil.createMessage(MessageLevel.INFO, "MSG0001");
```

<details>
<summary>keywords</summary>

MessageUtil, createMessage, MessageLevel, メッセージ取得

</details>

## メッセージのフォーマット

`java.text.MessageFormat` 形式で埋め込み文字をフォーマットできる。DBのメッセージカラムには埋め込み文字の状態で登録しておく。

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

MessageFormat, メッセージフォーマット, createMessage, formatMessage, 埋め込み文字, オプションパラメータ

</details>

## 国際化

DBのメッセージテーブルに言語ごとに異なるメッセージを設定することで国際化できる。

- `formatMessage()` 引数なし → ThreadContextに保持した言語のメッセージを取得
- ThreadContextへの言語設定は通常フレームワークが行うため、アプリで意識する必要はない（[thread-context-label](libraries-thread_context.md) 参照）
- 特定言語を指定する場合: `formatMessage(Locale.ENGLISH)` のように引数で言語を指定

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

国際化, formatMessage, ThreadContext, Locale, 多言語化, 言語指定

</details>

## オプションパラメータの国際化

メッセージフォーマット時のオプションパラメータに `StringResource` または `Message` を使用することで、オプションパラメータも国際化できる。

メッセージテーブル例:

| メッセージID | 言語 | メッセージ |
|---|---|---|
| MSG0001 | en | value of {0} is not valid. |
| MSG0001 | ja | {0}の値が不正です。 |
| MSG0002 | en | unknown error occur. error message:"{0}". |
| MSG0002 | ja | 原因不明のエラーが発生しました。 エラーメッセージ:「{0}」。 |
| PRP0001 | en | name |
| PRP0001 | ja | 名前 |

**StringResourceを使用する場合**: `MessageUtil.getStringResource(id)` でStringResourceを取得し、`createMessage` のオプションに設定する。

```java
StringResource propertyStringResource = MessageUtil.getStringResource("PRP0001");
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001", propertyStringResource);

ThreadContext.setLanguage(Locale.ENGLISH);
String message1 = message.formatMessage(); // "value of name is not valid."

ThreadContext.setLanguage(Locale.JAPANESE);
String message2 = message.formatMessage(); // "名前の値が不正です。"

String message3 = message.formatMessage(Locale.ENGLISH); // "value of name is not valid."
```

**Messageをネストする場合**: `createMessage` のオプションに `Message` を設定することでメッセージをネストできる。

```java
StringResource propertyStringResource = MessageUtil.getStringResource("PRP0001");
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001", propertyStringResource);

ThreadContext.setLanguage(Locale.JAPANESE);
Message errorMessage = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0002", message);
String errorMessage1 = errorMessage.formatMessage();
// "原因不明のエラーが発生しました。 エラーメッセージ:「名前の値が不正です。」。"
```

<details>
<summary>keywords</summary>

オプションパラメータ, 国際化, StringResource, Message, getStringResource, メッセージネスト, MessageUtil

</details>

## 例外によるメッセージの通知

業務エラーのメッセージ通知には `ApplicationException` クラスを使用する。`ApplicationException` またはそのサブクラスを使用することで、フレームワークが提供する例外処理機構が利用できる。

**例外の送出**:

```java
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");
throw new ApplicationException(message);
```

**例外からメッセージを取得**:

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

ApplicationException, 例外, getMessages, 業務エラー, メッセージ通知, throw

</details>
