# システムリポジトリ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/ExternalizedComponentDefinitionLoader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/SystemPropertyExternalizedLoader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/OsEnvironmentVariableExternalizedLoader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/ComponentFactory.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/annotation/SystemRepositoryComponent.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/AnnotationComponentDefinitionLoader.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/annotation/ConfigValue.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/annotation/ComponentRef.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/ConstructorInjectionComponentCreator.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/ComponentCreator.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DelegateFactory.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DispatchHandler.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/initialization/Initializable.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/initialization/BasicApplicationInitializer.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/Disposable.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/BasicApplicationDisposer.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/DisposableAdaptor.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/SystemRepository.html)

## 機能概要

システムリポジトリは、アプリケーションを実装する際に様々な箇所で使用されるオブジェクトや、設定値などを管理する機能を提供する。

この機能では、以下のことができる。
- 環境毎に異なる可能性のあるロジック（生成されるクラスやプロパティの値）を、外部ファイルに定義できる。
- 外部ファイルの定義を元に、オブジェクト間の関連を構築できる。（DIコンテナ機能を持つ）

DIコンテナ機能により、XML（:ref:`repository-root_node` 参照）または :ref:`アノテーションを付与したクラス <repository-inject-annotation-component>` を元にオブジェクトを構築できる。構築されるオブジェクトは**シングルトン**となる。

DIコンテナ機能でできること:
- :ref:`setterインジェクション <repository-definition_bean>`
- :ref:`文字列・数値・真偽値の使用 <repository-property_type>`
- :ref:`ListやMapのインジェクション <repository-map_list>`
- :ref:`型や名前が一致するsetterへの自動インジェクション <repository-autowired>`
- :ref:`ファクトリインジェクション <repository-factory_injection>`
- :ref:`アノテーション付与クラスのオブジェクト構築 <repository-inject-annotation-component>`
- :ref:`環境依存値の管理 <repository-environment_configuration>`

アプリケーションからはDIコンテナに直接アクセスせず、システムリポジトリ経由でアクセスする（:ref:`repository-use_system_repository` 参照）。

オブジェクト構築後に任意の初期化処理を実行でき、オブジェクトの依存関係に基づく初期化順を指定できる（:ref:`repository-initialize_object` 参照）。

<details>
<summary>keywords</summary>

DIコンテナ, シングルトン, setterインジェクション, オブジェクト初期化, システムリポジトリ, DIコンテナ機能, オブジェクト管理, 設定値管理, 外部ファイル, 環境依存

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
  <artifactId>nablarch-core-repository</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core, nablarch-core-repository, Maven依存関係, モジュール

</details>

## xmlにルートノードを定義する

コンポーネント設定ファイル(XML)のルートノードは `component-configuration` とする。`schemaLocation` を正しく設定するとIDEで各要素や属性のドキュメント参照や補完機能が使用できる。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration /component-configuration.xsd">
</component-configuration>
```

<details>
<summary>keywords</summary>

component-configuration, ルートノード, schemaLocation, XMLコンポーネント設定, IDE補完

</details>

## Java Beansオブジェクトを設定する

`component` 要素でJava Beansオブジェクトを定義する。

- `class` 属性: DIコンテナで管理するクラスのFQCN
- `name` 属性: 任意の名前
- `property` 子要素: setterインジェクション（`ref` 属性で他のcomponentを参照、`value` 属性でリテラル値設定、子要素に `component` を定義することも可能）

```xml
<component name="sample" class="sample.SampleBean" />

<component name="component" class="sample.SampleComponent">
  <property name="sample" ref="sample" />
  <property name="obj">
    <component class="sample.SampleObject" />
  </property>
  <property name="limit" value="100" />
</component>
```

> **重要**: 生成されるインスタンスはシングルトンとなる（プロトタイプでない）。アプリケーション終了まで破棄されない。プロトタイプと勘違いした場合、あるリクエストでユーザAの入力値をコンポーネントに設定し、別ユーザBのリクエストでその値を使用してしまう重大な不具合が発生しうる。コンポーネントの状態を変更・共有する場合はスレッドセーフでなければならない。

> **補足**: `component` 要素単位でインスタンスが生成される。同じクラスを複数の `component` 要素で定義すると、それぞれ別のインスタンスが生成される。

> **補足**: ネストして定義したcomponentもリポジトリのグローバル領域に保持されるため、名前を指定してオブジェクトを取得できる（:ref:`repository-get_object` 参照）。

> **補足**: staticなプロパティ（staticなsetterメソッド）へのインジェクションは行われない。インジェクション対象がstaticの場合、DIコンテナ構築時に例外が送出される。

<details>
<summary>keywords</summary>

component要素, setterインジェクション, シングルトン, スレッドセーフ, property要素, FQCN, SampleBean

</details>

## Java Beansオブジェクトの設定を上書きする

同じ `name` 属性のコンポーネントを複数定義することで上書きできる。後で読み込まれたオブジェクトが優先される。テスト時にプロダクション環境用オブジェクトをモック（テスト用オブジェクト）に置き換える際に使用できる。

```xml
<component name="sample" class="sample.SampleBean">
  <property name="prop" value="message" />
</component>

<!-- 同じ名前でコンポーネントを定義して上書きする -->
<component name="sample" class="sample.MockSampleBean" />
```

> **重要**: 異なるクラスを設定すると、上書き前のpropertyへの設定は全て破棄される（同じインタフェースを実装していても同じpropertyを持つとは限らないため）。同じクラスを設定した場合は上書き前のpropertyが全て引き継がれるため、特定propertyの設定を削除できない。以下の例では上書き後にproperty要素を記述していないが、上書き前のpropの値（message）が引き継がれる。

```xml
<component name="sample" class="sample.SampleBean">
  <property name="prop" value="message" />
</component>

<!-- propertyを設定していないが、上書き前のpropの値が引き継がれる -->
<component name="sample" class="sample.SampleBean" />
```

<details>
<summary>keywords</summary>

コンポーネント上書き, モック置換, テスト用オブジェクト, property引き継ぎ, MockSampleBean

</details>

## 文字列や数値、真偽値を設定値として使う

プロパティの型が以下の型の場合、`value` 属性にリテラルで値を設定できる。

| 型 | 設定方法 |
|---|---|
| `java.lang.String` | リテラル値をそのまま設定 |
| `java.lang.String[]` | カンマ(`,`)区切りで複数値設定。`,` 自体は要素として設定不可 |
| `java.lang.Integer`(`int`) | `Integer#valueOf` で変換できる値 |
| `java.lang.Integer[]`(`int[]`) | カンマ区切り。各要素は `Integer#valueOf` で変換できる値 |
| `java.lang.Long`(`long`) | `Long#valueOf` で変換できる値 |
| `java.lang.Boolean`(`boolean`) | `Boolean#valueOf` で変換できる値 |

```xml
<property name="str" value="あいうえお" />
<property name="array" value="あ,い,う,え,お" />
<property name="num" value="12345" />
<property name="bool" value="true" />
```

<details>
<summary>keywords</summary>

String, Integer, Long, Boolean, int, long, boolean, int[], リテラル値設定, value属性, String配列, カンマ区切り

</details>

## ListやMapを設定値として使う

`list` 要素または `map` 要素でListやMapをsetterインジェクションできる。

**List設定**: `list` 要素に `value`（文字列）または `component`（Java Beans）を設定する。`list` 要素には任意の名前を設定でき、`ref` 属性で名前参照できる。`component-ref` 要素でコンポーネントの名前参照も可能。

```xml
<component class="sample.SampleBean">
  <property name="stringList">
    <list>
      <value>string1</value>
      <value>string2</value>
      <value>string3</value>
    </list>
  </property>
</component>
```

list要素に名前を設定し、`ref` 属性で名前参照することもできる（上の例と同じ設定）。

```xml
<list name="strList">
  <value>string1</value>
  <value>string2</value>
  <value>string3</value>
</list>

<component class="sample.ListSample">
  <!-- strListという名前のListを設定する -->
  <property name="stringList" ref="strList" />
</component>
```

```xml
<component name="sampleHandler3" class="sample.SampleHandler3" />

<component class="sample.ListSample">
  <property name="handlers">
    <list>
      <component class="sample.SampleHandler1" />
      <component class="sample.SampleHandler2" />
      <component-ref name="sampleHandler3" />
    </list>
  </property>
</component>
```

**Map設定**: `map` 要素に `entry` 要素（`key`/`value` 属性）を設定する。`map` 要素にも任意の名前を設定でき、`ref` 属性で名前参照できる。`value-component` 要素でMapの値にBeanを設定できる。

```xml
<property name="map">
  <map>
    <entry key="key1" value="1" />
    <entry key="key2" value="2" />
    <entry key="key3" value="3" />
  </map>
</property>
```

map要素に名前を設定し、`ref` 属性で名前参照することもできる（上の例と同じ設定）。

```xml
<map name="map">
  <entry key="key1" value="1" />
  <entry key="key2" value="2" />
  <entry key="key3" value="3" />
</map>

<component class="sample.ListSample">
  <!-- mapという名前のMapを設定する -->
<property name="map" ref="map">
</component>
```

```xml
<property name="settings">
  <map>
    <entry key="sample1">
      <value-component class="sample.SampleBean1" />
    </entry>
    <entry key="sample2">
      <value-component class="sample.SampleBean2" />
    </entry>
  </map>
</property>
```

> **重要**: `map` や `list` の `name` 属性が同じものを複数定義した場合、**先に定義されたものが有効**となる（:ref:`repository-override_bean` のbeanの上書きと異なる挙動）。環境毎にmapやlistを変更したい場合は、環境毎に読み込むファイルを変えること。

<details>
<summary>keywords</summary>

list要素, map要素, Listインジェクション, Mapインジェクション, component-ref, value-component, entry要素

</details>

## コンポーネントを自動的にインジェクションする

`component`要素の`autowireType`属性で自動インジェクションタイプを指定できる。デフォルトは`ByType`。

> **重要**: 自動インジェクション機能は以下の問題があるため、`autowireType`属性には明示的に`None`を指定することを推奨する。(1) 生成オブジェクトの状態がコンポーネント設定ファイル(XML)から読み取れない (2) 任意項目のプロパティ定義を省略した場合に想定外のオブジェクトが自動的にインジェクションされる可能性がある (3) ByType使用時、派生開発で同一型のオブジェクトの設定が増えるとpropertyの定義が必要になりメンテナンス性が悪い

| autowireType値 | 動作 |
|---|---|
| ByType | DIコンテナ上にプロパティの型が1つしか存在しない場合に自動インジェクション（デフォルト） |
| ByName | プロパティ名と一致する名称のコンポーネントが存在する場合に自動インジェクション。型不一致の場合はエラー |
| None | 自動インジェクションなし |

ByType（デフォルト）で自動インジェクションする例:

インジェクション対象のインタフェースと実装クラスを作成する（インタフェースの作成は必須ではない）:

```java
public interface SampleComponent {
}

public class BasicSampleComponent implements SampleComponent {
}
```

上記クラスをsetterインジェクションで受け取るクラスを作成する:

```java
public class SampleClient {
  private SampleComponent component;

  public void setSampleComponent(SampleComponent component) {
    this.component = component;
  }
}
```

`SampleClient`に`sampleComponent`プロパティを明示定義していないが、`SampleComponent`を実装したクラスの設定が1つだけなので、`sampleComponent`プロパティには自動的に`BasicSampleComponent`が設定される:

```xml
<component name="sampleComponent" class="sample.BasicSampleComponent" />

<component name="sampleClient" class="sample.SampleClient" />
```

上記の設定は、以下のように明示的に`property`を定義した場合と同じ動作となる:

```xml
<component name="sampleComponent" class="sample.BasicSampleComponent" />

<component name="sampleClient" class="sample.SampleClient">
  <property name="sampleComponent" ref="sampleComponent" />
</component>
```

<details>
<summary>keywords</summary>

autowireType, ByType, ByName, None, 自動インジェクション, DIコンテナ, component要素, SampleComponent, BasicSampleComponent, SampleClient

</details>

## コンポーネント設定ファイル(xml)を分割する

`import`要素を使用してコンポーネント設定ファイル(XML)を複数ファイルに分割できる。XMLが巨大になるとメンテナンス性が悪くなるため、機能単位などある程度の粒度でファイルを分割すると良い。

```xml
<import file="library/database.xml" />
<import file="library/validation.xml" />
<import file="handler/multipart.xml" />
```

<details>
<summary>keywords</summary>

import要素, コンポーネント設定ファイル分割, XML分割, repository-split_xml

</details>

## 依存値を設定する

テスト環境や本番環境で異なる値（データベースの接続情報やディレクトリのパスなど）はシンプルなkey-value形式の環境設定ファイルで管理できる。

```bash
database.url = jdbc:h2:mem:sample
database.user = sa
database.password = sa
```

> **重要**: 環境設定値のキー値が重複していた場合、後に定義されたものが有効となる。

詳細な記述ルールは :ref:`repository-environment_configuration_file_rule` を参照。

<details>
<summary>keywords</summary>

環境設定ファイル, key-value形式, 環境依存値, キー値重複, repository-environment_configuration

</details>

## コンポーネント設定ファイルから環境依存値を参照する

コンポーネント設定ファイル(XML)から環境依存値を参照するには、キー値を`${`と`}`で囲んで記述する。

> **重要**: `${key}`記法は環境設定ファイル内では使用できない（環境設定ファイル内で他の環境依存値は参照不可）。

`config-file`要素で環境設定ファイルを読み込む。ファイル名指定または特定ディレクトリ配下のファイルを一括で読み込める。

```xml
<!-- database.propertiesファイルの読み込み -->
<config-file file="database.properties" />

<component class="org.h2.jdbcx.JdbcDataSource">
  <property name="url" value="${database.url}" />
</component>
```

環境設定ファイルには`config`ファイル（Nablarch独自仕様でパース）と`properties`ファイル（`java.util.Properties`でパース）の2種類がある。`config`ファイルはNablarch独自仕様のため`properties`ファイルを推奨する。

> **重要**: 環境設定ファイルで定義されていない環境依存値のキーをコンポーネント設定ファイルに記載した場合、`ConfigurationLoadException`が送出される。

環境設定ファイルの仕様は :ref:`repository-environment_configuration_file_rule` を参照。

<details>
<summary>keywords</summary>

config-file要素, ConfigurationLoadException, propertiesファイル, 環境依存値参照, ${}, JdbcDataSource

</details>

## システムプロパティを使って環境依存値を上書きする

環境依存値はシステムプロパティ（`java.lang.System#getProperties()`で取得できる値）で上書きできる。システムプロパティは環境設定ファイルに設定した値より優先される。

例として、以下のような環境設定ファイルがある場合:

```bash
message=上書きされるメッセージ
```

javaコマンドの`-D`オプションでシステムプロパティを設定することで環境設定ファイルの値を上書きできる。この例の場合、`message`の値は「上書きするメッセージ」となる。

```
java -Dmessage=上書きするメッセージ
```

<details>
<summary>keywords</summary>

システムプロパティ, 環境依存値上書き, -Dオプション, java.lang.System

</details>

## OS環境変数を使って環境依存値を上書きする

`ExternalizedComponentDefinitionLoader` インタフェースを実装したクラスで環境依存値の上書き方法を制御する。サービスプロバイダを何も設定していない場合は、デフォルトで `SystemPropertyExternalizedLoader` が使用される（システムプロパティによる上書き）。

OS環境変数で上書きする場合は `OsEnvironmentVariableExternalizedLoader` を使用する。

**設定手順**:
1. クラスパス直下に`META-INF/services`ディレクトリを作成する
2. `nablarch.core.repository.di.config.externalize.ExternalizedComponentDefinitionLoader`という名前のテキストファイルを作成する
3. 使用する実装クラスの完全修飾名を改行区切りで列挙する

```text
nablarch.core.repository.di.config.externalize.OsEnvironmentVariableExternalizedLoader
```

複数の実装クラスを組み合わせる場合は改行区切りで列挙できる。上から順番に上書きが行われ、一番下に記述したクラスの上書きが最終的に採用される。

```text
nablarch.core.repository.di.config.externalize.OsEnvironmentVariableExternalizedLoader
nablarch.core.repository.di.config.externalize.SystemPropertyExternalizedLoader
```

上記の場合、OS環境変数より下に記述したシステムプロパティの上書きが優先される。

**OS環境変数の名前について**: Linuxでは`.`や`-`をOS環境変数名に使用できないため、Nablarchは環境依存値の名前を以下のルールで変換してOS環境変数を検索する。
1. `.`と`-`を`_`に置換する
2. アルファベットを大文字に変換する

例: `example.error-message` → `EXAMPLE_ERROR_MESSAGE`

この変換は実行時のOSに関係なく行われるため、Windowsでも`example.error-message`を上書きするOS環境変数は`EXAMPLE_ERROR_MESSAGE`という名前で定義しなければならない。

<details>
<summary>keywords</summary>

ExternalizedComponentDefinitionLoader, OsEnvironmentVariableExternalizedLoader, SystemPropertyExternalizedLoader, OS環境変数, ServiceLoader, META-INF/services, 環境変数命名規則, EXAMPLE_ERROR_MESSAGE

</details>

## ファクトリクラスで生成したオブジェクトをインジェクションする

Java Beansとして実装されていないクラス（ベンダー提供・OSSなど）をシステムリポジトリで管理する場合は、 `ComponentFactory` インタフェースを実装したファクトリクラスを作成する。

```java
public class SampleComponentFactory implements ComponentFactory<SampleComponent> {
  private String configValue;

  public void setConfigValue(String configValue) {
    this.configValue = configValue;
  }

  public SampleComponent createObject() {
    return new SampleComponent(configValue);
  }
}
```

```xml
<!-- ファクトリクラスの定義 -->
<component name="sampleComponent" class="sample.SampleComponentFactory">
  <property name="configValue" value="設定値" />
</component>

<!-- ファクトリクラスで生成したオブジェクトを設定するクラス -->
<component class="sample.SampleBean">
  <property name="sampleObject" ref="sampleComponent" />
</component>
```

> **重要**: Nablarchはファクトリクラスの入れ子に対応していない（ファクトリクラスのプロパティに他のファクトリクラスを指定できない）。代替策: (1) 1つのファクトリクラス内で入れ子のファクトリクラスで構築するオブジェクトも含めて構築する (2) 入れ子のファクトリクラスで構築するオブジェクトを生成するCreator/Builder/Providerクラスを作成してコンポーネントとしてインジェクションする

<details>
<summary>keywords</summary>

ComponentFactory, createObject, ファクトリクラス, ファクトリ入れ子不可, repository-factory_injection, SampleComponentFactory, SampleBean

</details>

## アノテーションを付与したクラスのオブジェクトを構築する

`SystemRepositoryComponent` アノテーションをクラスに付与することで、 :ref:`repository-definition_bean` へのXML設定なしにDIコンテナの管理対象にできる。

> **重要**: JBossやWildflyなど、vfs（バーチャルファイルシステム）でクラスパス配下のリソースを管理するウェブアプリケーションサーバでは`SystemRepositoryComponent`アノテーションが付与されたクラスの検索ができないため使用不可。そのようなサーバを使用する場合は :ref:`repository-definition_bean` に従ってXMLで定義すること。

<details>
<summary>keywords</summary>

SystemRepositoryComponent, ExternalizedComponentDefinitionLoader, AnnotationComponentDefinitionLoader, JBoss, Wildfly, vfs, アノテーションDI, ExampleAction

</details>

## 使用方法

1. **収集対象パッケージを特定するクラスを作成する**: `AnnotationComponentDefinitionLoader` を継承し、`getBasePackage` 抽象メソッドをオーバーライドしてプロジェクトのパッケージ名を返す。

```java
public class ExampleComponentDefinitionLoader extends AnnotationComponentDefinitionLoader {
    @Override
    protected String getBasePackage() {
        return "com.example";
    }
}
```

2. **作成したクラスをサービスプロバイダとして設定する**: :ref:`repository-overwrite_environment_configuration_by_os_env_var` と同様に`META-INF/services/nablarch.core.repository.di.config.externalize.ExternalizedComponentDefinitionLoader`ファイルを作成し、上記クラスの完全修飾名を記述する。

3. **DIコンテナで管理したいクラスにアノテーションを付与する**: `SystemRepositoryComponent` を付与する。

```java
@SystemRepositoryComponent
public class ExampleAction {
}
```

<details>
<summary>keywords</summary>

AnnotationComponentDefinitionLoader, getBasePackage, SystemRepositoryComponent, サービスプロバイダ設定, アノテーションコンポーネント収集, ExampleComponentDefinitionLoader

</details>

## コンストラクタインジェクションを使用する

`SystemRepositoryComponent` が付与されたクラスは、以下の条件を満たす場合にコンストラクタインジェクションが実行される。

- コンストラクタが1つだけ定義されている
- コンストラクタが引数をもつ

**インジェクション仕様**:

- `ConfigValue` が付与された引数: 設定値がインジェクション
- `ComponentRef` が付与された引数: DIコンテナのコンポーネントがインジェクション
- いずれのアノテーションも付与されていない場合:
  - 型に一致するコンポーネントがDIコンテナ上に1つ: 自動インジェクション
  - 0個または複数: 何もインジェクションしない

**設定値のインジェクション**: `@ConfigValue` の `value` に設定した値がインジェクションされる。環境依存値のキーは `${` と `}` で囲む。使用可能な型は :ref:`repository-property_type` に準ずる。

```java
@SystemRepositoryComponent
public class ExampleService {
    private final String errorMessageId;

    public ExampleService(@ConfigValue("${example.service.errorMessageId}") String errorMessageId) {
        this.errorMessageId = errorMessageId;
    }
```

**コンポーネントのインジェクション**: `ComponentRef` の `value` に設定した名前のコンポーネントがインジェクションされる。

```java
@SystemRepositoryComponent
public class ExampleService {
    private LettuceRedisClient client;

    public ExampleService(@ComponentRef("lettuceRedisClientProvider") LettuceRedisClient client) {
        this.client = client;
    }
```

> **補足**: コンストラクタインジェクションは `ConstructorInjectionComponentCreator` で実現。`AnnotationComponentDefinitionLoader` の `newComponentCreator()` をオーバーライドして `ComponentCreator` 実装を差し替え可能。

```java
public class ExampleComponentDefinitionLoader extends AnnotationComponentDefinitionLoader {
    @Override
    protected String getBasePackage() {
        return "com.example";
    }

    @Override
    protected ComponentCreator newComponentCreator() {
        return new ExampleComponentCreator();
    }
}
```

<details>
<summary>keywords</summary>

SystemRepositoryComponent, ConfigValue, ComponentRef, ConstructorInjectionComponentCreator, AnnotationComponentDefinitionLoader, ComponentCreator, newComponentCreator, @SystemRepositoryComponent, @ConfigValue, @ComponentRef, コンストラクタインジェクション, DIコンテナ, 設定値インジェクション, コンポーネントインジェクション

</details>

## ActionクラスをDIコンテナで管理する

アノテーションをActionクラスに付与するとDIコンテナで管理可能になる。

Nablarchのディスパッチハンドラ（:ref:`router_adaptor`、:ref:`request_path_java_package_mapping`、:ref:`http_request_java_package_mapping`）ではディスパッチ先クラスはハンドラ内でインスタンス化される。ActionクラスをDIコンテナに登録する場合は `DelegateFactory` を差し替え、`DispatchHandler#setDelegateFactory` で設定する必要がある。

```xml
<component name="packageMapping" class="nablarch.integration.router.RoutesMapping">
  <property name="delegateFactory">
      <component class="nablarch.fw.handler.SystemRepositoryDelegateFactory"/>
  </property>
</component>
```

<details>
<summary>keywords</summary>

DelegateFactory, DispatchHandler, SystemRepositoryDelegateFactory, setDelegateFactory, ActionクラスDI管理, ディスパッチハンドラ

</details>

## オブジェクトの初期化処理を行う

オブジェクトの初期化処理は以下の手順で設定する。

1. `Initializable` インタフェースを実装し、`initialize()` で初期化処理を記述する。
2. コンポーネント設定ファイルで `BasicApplicationInitializer` に初期化対象を設定する。

```java
public class SampleComponent implements Initializable {
    public void initialize() {
        // プロパティにインジェクションされた値などを元に初期化処理を行う
    }
}
```

初期化順は `initializeList` の上から順に実行される。

> **重要**: `BasicApplicationInitializer` のコンポーネント名は必ず **initializer** とすること。

```xml
<component name="sampleObject1" class="sample.SampleComponent1" />
<component name="sampleObject2" class="sample.SampleComponent2" />
<component name="sampleObject3" class="sample.SampleComponent3" />

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="sampleObject1" />
      <component-ref name="sampleObject2" />
      <component-ref name="sampleObject3" />
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

Initializable, BasicApplicationInitializer, initialize, initializeList, オブジェクト初期化, 初期化順序

</details>

## オブジェクトの廃棄処理を行う

オブジェクトの廃棄処理は以下の手順で設定する。

1. `Disposable` インタフェースを実装し、`dispose()` で廃棄処理を記述する。
2. コンポーネント設定ファイルで `BasicApplicationDisposer` に廃棄対象を設定する。

```java
public class SampleComponent implements Disposable {
    public void dispose() throws Exception {
        // リソースの解放など、廃棄処理を行う
    }
}
```

廃棄順: `disposableList` に設定した**逆順**で廃棄処理が実行される。先に廃棄したいオブジェクトはより**下に設定**する。

> **重要**: `BasicApplicationDisposer` のコンポーネント名は必ず **disposer** とすること。

```xml
<component name="sampleObject1" class="sample.SampleComponent1" />
<component name="sampleObject2" class="sample.SampleComponent2" />
<component name="sampleObject3" class="sample.SampleComponent3" />

<component name="disposer"
    class="nablarch.core.repository.disposal.BasicApplicationDisposer">
  <property name="disposableList">
    <list>
      <component-ref name="sampleObject3" />
      <component-ref name="sampleObject2" />
      <component-ref name="sampleObject1" />
    </list>
  </property>
</component>
```

`addDisposable` メソッドでコンポーネント生成後に `Disposable` を追加できる。このメソッドで追加される `Disposable` はインスタンスが生成された順番で追加されることが予想される。その場合、`BasicApplicationDisposer` は `disposableList` に設定されている順序とは逆の順序で廃棄処理を呼ぶため、廃棄処理はインスタンス生成とは逆の順序で行われることが望ましい（例：JDBCの `Connection`、`Statement`、`ResultSet`）。

**`java.io.Closeable` 実装コンポーネントの廃棄設定**: `DisposableAdaptor` を使用することで廃棄対象リストに設定できる。

```xml
<component name="closeableComponent" class="sample.CloseableComponent" />

<component name="disposer"
    class="nablarch.core.repository.disposal.BasicApplicationDisposer">
  <property name="disposableList">
    <list>
      <component class="nablarch.core.repository.disposal.DisposableAdaptor">
        <property name="target" ref="closeableComponent" />
      </component>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

Disposable, BasicApplicationDisposer, DisposableAdaptor, dispose, disposableList, addDisposable, オブジェクト廃棄, リソース解放, Closeable廃棄

</details>

## DIコンテナの情報をシステムリポジトリに設定する

コンポーネント設定ファイルをロードし、`SystemRepository` に設定する。

```java
XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader("web-boot.xml");
SystemRepository.load(new DiContainer(loader));
```

> **重要**: DIコンテナの情報をシステムリポジトリへ登録する処理はNablarchが提供する以下のクラスで実施されるため、個別に実装することは基本的にない。
> - ServletContextListenerの実装クラス
> - 独立型アプリケーションの起動クラス

<details>
<summary>keywords</summary>

XmlComponentDefinitionLoader, SystemRepository, SystemRepository.load, DiContainer, システムリポジトリ設定, DIコンテナロード

</details>

## システムリポジトリからオブジェクトを取得する

`SystemRepository` クラスを使用してオブジェクトを取得する。事前にDIコンテナの情報を設定しておく必要がある（:ref:`repository-use_system_repository` 参照）。

以下のように、`component` 要素(`list`や`map`要素を含む)に設定した `name` 属性の値を指定してオブジェクトを取得できる。

コンポーネント定義:

```xml
<component name="sampleComponent" class="sample.SampleComponent" />

<component name="component" class="sample.Component" >
  <property name="component2">
    <component name="component2" class="sample.Component2" />
  </property>
</component>
```

取得例:

```java
// SystemRepository#get を使用して取得する
SampleComponent sample = SystemRepository.get("sampleComponent");

// ネストしたcomponentは、親の名前と自身の名前を"."で連結して取得する
Component2 component2 = SystemRepository.get("component.component2");
```

<details>
<summary>keywords</summary>

SystemRepository, SystemRepository.get, システムリポジトリ取得, コンポーネント取得, ネストコンポーネント取得

</details>

## 環境設定ファイルの記述ルール

環境設定ファイルには `config` ファイルと `properties` ファイルの2種類がある。

**propertiesファイル**: JavaのPropertiesの仕様に基づいて解析される。

**configファイルの仕様**:

- 記述形式: `key=value`
- コメント: `#` による行コメントのみ（行中の `#` 以降はコメント）
- 複数行: 行末に `\` を記述
- 予約語（`#`、`=`、`\`）を一般文字として使う場合は `\` でエスケープ

```bash
key1=value1
key2=value2

# コメントです
key = value   # コメントです
```

**複数行にまたがった設定値の記述**: 行末に `\` を記述することで複数行にまたがって設定値を記述できる。下の例の場合、設定値の組み合わせは以下のようになる。

- key -> value
- key2 -> value,value2
- key3 -> abcdefg

```bash
key = value
key2 = value,\
value2
key3 = abcd\    # ここにコメントを定義できる
efg
```

**予約語のエスケープ**: 下の例の場合、設定値の組み合わせは以下のようになる。

- key -> a=a
- key2 -> #コメントではない
- key3 -> あ\\い

```bash
key = a\=a
key2 = \#コメントではない
key3 = あ\\い
```

> **補足**: 半角スペースのみの値はconfigファイルでは対応していないが、propertiesファイルでは `\u0020` で扱える。

> **補足**: 空値の挙動の違い:
> - configファイル: 空値のキーは読み込まれず、`${config.value}` 参照時に例外が送出される（5u18以前はWARNINGのみでプレースホルダがそのまま設定）
> - propertiesファイル: 空文字として扱われ、`property` に空文字が設定される

<details>
<summary>keywords</summary>

環境設定ファイル, configファイル, propertiesファイル, 複数行設定, 予約語エスケープ, 空値挙動

</details>
