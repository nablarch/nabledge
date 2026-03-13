# システムリポジトリ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/ExternalizedComponentDefinitionLoader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/SystemPropertyExternalizedLoader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/OsEnvironmentVariableExternalizedLoader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/ComponentFactory.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/annotation/SystemRepositoryComponent.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/AnnotationComponentDefinitionLoader.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/annotation/ConfigValue.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/externalize/annotation/ComponentRef.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/config/ConstructorInjectionComponentCreator.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/ComponentCreator.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DelegateFactory.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DispatchHandler.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/initialization/Initializable.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/initialization/BasicApplicationInitializer.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/Disposable.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/BasicApplicationDisposer.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/DisposableAdaptor.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/SystemRepository.html)

## 機能概要

DIコンテナ機能でできること（構築されるオブジェクトはシングルトン）:
- setterインジェクション（[repository-definition_bean](#s3)）
- 文字列・数値・真偽値の使用（[repository-property_type](#s5)）
- List/Mapのインジェクション（[repository-map_list](#s6)）
- 型・名前一致による自動インジェクション（[repository-autowired](#s7)）
- ファクトリインジェクション（[repository-factory_injection](#)）
- アノテーション付与クラスのオブジェクト構築（[repository-inject-annotation-component](#)）
- 環境依存値の管理（[repository-environment_configuration](#)）

アプリケーションからはDIコンテナに直接アクセスせず、システムリポジトリ経由でアクセスする（[repository-use_system_repository](#) 参照）。

オブジェクト構築後に任意の初期化処理を実行できる。依存関係による初期化順の制約があるため、初期化順を指定できる（[repository-initialize_object](#) 参照）。

`component`要素の`autowireType`属性で自動インジェクションタイプを指定できる。

> **重要**: 自動インジェクション機能には以下の問題があるため、`autowireType`属性には明示的に`None`を指定することを推奨する。
> - 生成されるオブジェクトの状態がXML(コンポーネント設定ファイル)から読み取れない
> - 任意項目のproperty定義を省略した場合、想定外のオブジェクトが自動インジェクションされる可能性がある
> - 型による自動インジェクション使用時、派生開発で同一型のオブジェクト設定が増えるとpropertyの定義が必要になりメンテナンス性が悪い

`autowireType`に指定可能なタイプ:

| タイプ | 説明 |
|---|---|
| `ByType` | DIコンテナ上にそのプロパティの型が1つのみ存在する場合に自動インジェクション（デフォルト） |
| `ByName` | プロパティ名と一致する名称のコンポーネントが存在する場合に自動インジェクション。型不一致はエラー |
| `None` | 自動インジェクションを行わない |

ByType（デフォルト）の設定例:

```java
public interface SampleComponent {}
public class BasicSampleComponent implements SampleComponent {}

public class SampleClient {
  private SampleComponent component;
  public void setSampleComponent(SampleComponent component) {
    this.component = component;
  }
}
```

```xml
<component name="sampleComponent" class="sample.BasicSampleComponent" />
<component name="sampleClient" class="sample.SampleClient" />
<!-- SampleComponentを実装したクラスが1つのため、sampleComponentプロパティにBasicSampleComponentが自動設定される -->
```

上記は以下の明示的なproperty定義と同等:

```xml
<component name="sampleComponent" class="sample.BasicSampleComponent" />
<component name="sampleClient" class="sample.SampleClient">
  <property name="sampleComponent" ref="sampleComponent" />
</component>
```

**アノテーション**: `@SystemRepositoryComponent`, `@ConfigValue`, `@ComponentRef`

`SystemRepositoryComponent` が付与されたクラスにコンストラクタインジェクションが実行される条件:
- コンストラクタが1つだけ定義されている
- コンストラクタが引数をもつ

インジェクション仕様:
- `ConfigValue` 付与の引数 → 設定値がインジェクションされる
- `ComponentRef` 付与の引数 → DIコンテナ登録のコンポーネントがインジェクションされる
- アノテーションなしの場合:
  - 型一致コンポーネントがDIコンテナ上に1つのみ → 自動インジェクション
  - 型一致コンポーネントが0または複数 → 何もインジェクションしない

`@ConfigValue`: アノテーションの `value` に設定した値がインジェクションされる。環境依存値は `${キー}` 形式で指定可能。使用可能な型は [repository-property_type](#s5) に準ずる。

```java
@SystemRepositoryComponent
public class ExampleService {

    private final String errorMessageId;

    public ExampleService(@ConfigValue("${example.service.errorMessageId}") String errorMessageId) {
        this.errorMessageId = errorMessageId;
    }
```

`@ComponentRef`: アノテーションの `value` に設定した名前のコンポーネントがインジェクションされる。

```java
@SystemRepositoryComponent
public class ExampleService {

  private LettuceRedisClient client;

  public ExampleService(@ComponentRef("lettuceRedisClientProvider") LettuceRedisClient client) {
      this.client = client;
  }
}
```

> **補足**: コンストラクタインジェクションは `ConstructorInjectionComponentCreator` で実現。`AnnotationComponentDefinitionLoader` の `newComponentCreator` をオーバーライドすることで任意の `ComponentCreator` 実装に差し替え可能。

```java
public class ExampleComponentDefinitionLoader extends AnnotationComponentDefinitionLoader {
    @Override
    protected String getBasePackage() {
        return "com.example";
    }

    @Override
    protected ComponentCreator newComponentCreator() {
        // 任意のComponentCreator実装クラスに変更する。
        return new ExampleComponentCreator();
    }
}
```

<details>
<summary>keywords</summary>

DIコンテナ, システムリポジトリ, シングルトン, setterインジェクション, オブジェクト初期化, 自動インジェクション, ファクトリインジェクション, 環境依存値管理, autowireType, ByType, ByName, None, コンポーネント自動注入, SystemRepositoryComponent, ConfigValue, ComponentRef, ConstructorInjectionComponentCreator, AnnotationComponentDefinitionLoader, ComponentCreator, @SystemRepositoryComponent, @ConfigValue, @ComponentRef, コンストラクタインジェクション, 設定値インジェクション, コンポーネントインジェクション

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

`import`要素でxmlファイルを分割して読み込むことができる。xmlファイルを分割する際には、機能単位などある程度の粒度でファイルを分割すると良い。

```xml
<import file="library/database.xml" />
<import file="library/validation.xml" />
<import file="handler/multipart.xml" />
```

ActionクラスにアノテーションをつけることでDIコンテナ管理可能になる。[router_adaptor](../adapters/adapters-router_adaptor.md)、[request_path_java_package_mapping](../handlers/handlers-request_path_java_package_mapping.md)、[http_request_java_package_mapping](../handlers/handlers-http_request_java_package_mapping.md) などのディスパッチハンドラではディスパッチ先クラスはハンドラ内でインスタンス化される。ActionクラスをDIコンテナに登録する場合は、`DelegateFactory` を差し替える必要がある。

`DispatchHandler#setDelegateFactory` で設定する:

```xml
<component name="packageMapping" class="nablarch.integration.router.RoutesMapping">
  <property name="delegateFactory">
    <component class="nablarch.fw.handler.SystemRepositoryDelegateFactory"/>
  </property>
</component>
```

<details>
<summary>keywords</summary>

nablarch-core, nablarch-core-repository, モジュール, Maven依存関係, import要素, XMLファイル分割, コンポーネント設定ファイル分割, DelegateFactory, SystemRepositoryDelegateFactory, DispatchHandler, ActionクラスDI管理, ディスパッチハンドラ, DelegateFactory差し替え

</details>

## xmlにルートノードを定義する

コンポーネント設定ファイル(xml)のルートノードは `component-configuration` とする。`schemaLocation` を正しく設定するとIDEで各要素や属性のドキュメント参照・補完機能が使える。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration /component-configuration.xsd">
</component-configuration>
```

環境設定ファイルはシンプルなkey-value形式で記述する。詳細は[repository-environment_configuration_file_rule](#)を参照。

```
database.url = jdbc:h2:mem:sample
database.user = sa
database.password = sa
```

> **重要**: 環境設定値のキー値が重複していた場合、後に定義されたものが有効となる。

**クラス**: `nablarch.core.repository.initialization.Initializable`, `nablarch.core.repository.initialization.BasicApplicationInitializer`

手順:
1. `Initializable` インタフェースを実装し、`initialize()` で初期化処理を行う
2. コンポーネント設定ファイルで `BasicApplicationInitializer` に初期化対象を設定する

```java
public class SampleComponent implements Initializable {
    public void initialize() {
        // 初期化処理
    }
}
```

> **重要**: `BasicApplicationInitializer` のコンポーネント名は必ず **initializer** とすること。

初期化順を制御する場合、先に初期化したいオブジェクトをリストの上に設定する。

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

component-configuration, XMLルートノード, schemaLocation, コンポーネント設定ファイル, IDE補完, 環境設定ファイル, 依存値設定, key-value, propertiesファイル, 環境依存値, Initializable, BasicApplicationInitializer, initialize, オブジェクト初期化, 初期化順序, initializer

</details>

## Java Beansオブジェクトを設定する

`component`要素でJava Beansオブジェクトを定義する:
- `class`属性: DIコンテナで管理するクラスのFQCN
- `name`属性: 任意の名前
- `property`子要素: setterインジェクション。`ref`属性で他のcomponentを参照、または`property`の子要素に直接`component`を定義することもできる
- `value`属性: リテラル値のインジェクション

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

> **重要**: 生成されるインスタンスはシングルトン（プロトタイプではない）。アプリケーション終了まで破棄されない。コンポーネントの状態を変更・共有する場合はスレッドセーフにすること。シングルトンをプロトタイプと誤解すると、あるリクエストで設定したユーザーAの値が別ユーザーBのリクエストで使われるなどの重大な不具合が発生する。

> **補足**: インスタンスはcomponent要素単位に生成される。同じクラスを2つのcomponent要素で定義した場合、別々のインスタンスが生成される。

> **補足**: ネストして定義したcomponentもリポジトリ上はグローバル領域に保持されるため、名前を指定してオブジェクトを取得できる（[repository-get_object](#) 参照）。

> **補足**: staticなプロパティ（staticなsetterメソッド）へのインジェクションは行われない。インジェクション対象がstaticの場合、DIコンテナ構築時に例外が送出される。

コンポーネント設定ファイル(xml)から環境設定ファイルを読み込み、`${キー値}`形式で環境依存値を参照できる。

- `config-file`要素で環境設定ファイルを読み込む（ファイル名指定または特定ディレクトリ配下の一括読み込みが可能）
- 環境設定ファイルにはconfigファイルとpropertiesファイルの2種類があり、**propertiesファイルを推奨**（configファイルはNablarch独自仕様のため）
- 環境設定ファイル内では`${}`記法は使用不可（他の環境依存値は参照できない）
- 環境設定ファイルの仕様は[repository-environment_configuration_file_rule](#)を参照

```xml
<!-- database.propertiesファイルの読み込み -->
<config-file file="database.properties" />

<component class="org.h2.jdbcx.JdbcDataSource">
  <property name="url" value="${database.url}" />
</component>
```

> **重要**: 環境設定ファイルで定義されていない環境依存値のキーをコンポーネント設定ファイルに記載した場合、`ConfigurationLoadException`が送出される。

**クラス**: `nablarch.core.repository.disposal.Disposable`, `nablarch.core.repository.disposal.BasicApplicationDisposer`, `nablarch.core.repository.disposal.DisposableAdaptor`

手順:
1. `Disposable` インタフェースを実装し、`dispose()` で廃棄処理を行う
2. コンポーネント設定ファイルで `BasicApplicationDisposer` に廃棄対象を設定する

```java
public class SampleComponent implements Disposable {
    public void dispose() throws Exception {
        // リソース解放処理
    }
}
```

> **重要**: `BasicApplicationDisposer` のコンポーネント名は必ず **disposer** とすること。

廃棄順を制御する場合、先に廃棄したいオブジェクトをリストの**下に設定**する。`BasicApplicationDisposer` は `disposableList` に設定した順序の逆順で廃棄処理を実行する。

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

`addDisposable` メソッドでコンポーネント生成後に任意の `Disposable` を追加できる。`addDisposable` で追加される `Disposable` はインスタンスが生成された順番で追加されることが予想される。その場合、廃棄処理はインスタンス生成とは逆の順序で行うことが望ましい（例：JDBCの `Connection`、`Statement`、`ResultSet`）。このため、`BasicApplicationDisposer` では `disposableList` に設定されている順序とは逆の順序で廃棄処理を呼ぶようになっている。

`java.io.Closeable` を実装したコンポーネントは `DisposableAdaptor` を用いて廃棄対象リストに設定できる:

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

component要素, Java Beans, setterインジェクション, FQCN, シングルトン, スレッドセーフ, staticプロパティ, property要素, ref属性, ConfigurationLoadException, config-file, 環境依存値参照, propertiesファイル推奨, configファイル, ${key}記法, Disposable, BasicApplicationDisposer, DisposableAdaptor, dispose, addDisposable, オブジェクト廃棄, 廃棄順序, disposer, Closeable廃棄

</details>

## Java Beansオブジェクトの設定を上書きする

`component`タグの`name`属性が同じオブジェクトを登録すると、後に読み込まれたオブジェクトの設定が優先される。テスト時にプロダクション環境用オブジェクトをモックに置き換える際に使用できる。

```xml
<component name="sample" class="sample.SampleBean">
  <property name="prop" value="message" />
</component>

<!-- 同じ名前でコンポーネントを定義して上書きする -->
<component name="sample" class="sample.MockSampleBean" />
```

> **重要**: 異なるクラスを設定した場合、上書き前のpropertyへの設定は全て破棄される（同じインタフェースを実装していても同じpropertyを持つとは限らないため）。同じクラスを設定した場合、上書き前のpropertyが全て引き継がれるため、特定propertyの設定を削除することはできない。

同じクラスで上書きした場合のproperty引き継ぎの例:

```xml
<component name="sample" class="sample.SampleBean">
  <property name="prop" value="message" />
</component>

<!-- propertyを設定していないが、上書き前のpropの値が引き継がれる -->
<component name="sample" class="sample.SampleBean" />
```

上の例では、上書き後のcomponentにproperty要素を記述していないが、上書き前の`prop=message`の値が引き継がれるため、`prop`には`message`が設定された状態となる。

システムプロパティ（`java.lang.System#getProperties()`で取得できる値）で環境依存値を上書きできる。システムプロパティは環境設定ファイルの値より優先される。

javaコマンドの`-D`オプションで上書きする例（`message`の値が「上書きするメッセージ」となる）:

```
java -Dmessage=上書きするメッセージ
```

**クラス**: `nablarch.core.repository.SystemRepository`

```java
XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader("web-boot.xml");
SystemRepository.load(new DiContainer(loader));
```

> **重要**: DIコンテナの情報をシステムリポジトリへ登録する処理はNablarchが提供する以下のクラスで実施される。個別に実装することは基本的にない。
> - ServletContextListenerの実装クラス
> - 独立型アプリケーションの起動クラス

<details>
<summary>keywords</summary>

コンポーネント上書き, name属性, モック置き換え, テスト, property引き継ぎ, MockSampleBean, システムプロパティ, 環境依存値上書き, -Dオプション, java.lang.System#getProperties, SystemRepository, XmlComponentDefinitionLoader, DiContainer, システムリポジトリ設定, DIコンテナロード

</details>

## 文字列や数値、真偽値を設定値として使う

プロパティの型が以下の場合、`value`属性にリテラル表記で設定できる:

| 型 | 設定方法 |
|---|---|
| `java.lang.String` | `value`属性にリテラルで設定 |
| `java.lang.String[]` | `value`属性にカンマ(`,`)区切りで設定。カンマ自体は要素として設定不可 |
| `java.lang.Integer`(int) | `value`属性に設定。`Integer#valueOf`で変換できる値 |
| `java.lang.Integer[]`(int[]) | カンマ区切りで設定。各要素は`Integer#valueOf`で変換できる値 |
| `java.lang.Long`(long) | `value`属性に設定。`Long#valueOf`で変換できる値 |
| `java.lang.Boolean`(boolean) | `value`属性に設定。`Boolean#valueOf`で変換できる値 |

```xml
<property name="str" value="あいうえお" />
<property name="array" value="あ,い,う,え,お" />
<property name="num" value="12345" />
<property name="bool" value="true" />
```

`ExternalizedComponentDefinitionLoader`インタフェースの実装クラスによって環境依存値の上書きが実現される。このクラスは`java.util.ServiceLoader`でロードされる。

- デフォルト実装: `SystemPropertyExternalizedLoader`（システムプロパティによる上書き）
- OS環境変数による上書きには`OsEnvironmentVariableExternalizedLoader`を使用する

**設定手順**:
1. クラスパス直下に`META-INF/services`ディレクトリを作成する
2. `nablarch.core.repository.di.config.externalize.ExternalizedComponentDefinitionLoader`という名前のテキストファイルを作成する
3. 使用する実装クラスの完全修飾名を改行区切りで列挙する

`OsEnvironmentVariableExternalizedLoader`単体使用例:

```
nablarch.core.repository.di.config.externalize.OsEnvironmentVariableExternalizedLoader
```

複数指定（上から順に上書きが行われ、下に記述したクラスによる上書きが最終的に採用される）:

```
nablarch.core.repository.di.config.externalize.OsEnvironmentVariableExternalizedLoader
nablarch.core.repository.di.config.externalize.SystemPropertyExternalizedLoader
```

上記例ではシステムプロパティの値がOS環境変数の値より優先される。

**OS環境変数の命名規則**: Linuxでは`.`や`-`をOS環境変数名に使用できないため、Nablarchは環境依存値の名前を以下のとおり変換してOS環境変数を検索する:
1. `.`と`-`を`_`に置換する
2. アルファベットを大文字に変換する

例: `example.error-message` → `EXAMPLE_ERROR_MESSAGE`（Windowsでも同様の変換が実行時OSに関係なく行われる）

**クラス**: `nablarch.core.repository.SystemRepository`

`SystemRepository` クラスの `get` メソッドでname属性の値を指定してオブジェクトを取得する。事前に [repository-use_system_repository](#) でDIコンテナの情報を設定しておく必要がある。

コンポーネント定義:
```xml
<component name="sampleComponent" class="sample.SampleComponent" />

<component name="component" class="sample.Component">
  <property name="component2">
    <component name="component2" class="sample.Component2" />
  </property>
</component>
```

取得例:
```java
SampleComponent sample = SystemRepository.get("sampleComponent");

// ネストしたcomponentは親の名前と自身の名前を"."で連結して取得する
Component2 component2 = SystemRepository.get("component.component2");
```

<details>
<summary>keywords</summary>

プロパティ型, String, Integer, Long, Boolean, value属性, リテラル値, String配列, int配列, ExternalizedComponentDefinitionLoader, SystemPropertyExternalizedLoader, OsEnvironmentVariableExternalizedLoader, OS環境変数, META-INF/services, ServiceLoader, 環境変数命名規則, SystemRepository, システムリポジトリ取得, コンポーネント取得, ネストコンポーネント

</details>

## ListやMapを設定値として使う

`list`要素や`map`要素を使ってList/Mapを受け取るpropertyへのsetterインジェクションが行える。

**list要素**: 文字列または任意のJava Beansオブジェクトを設定できる。

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

list要素にも任意の名前を設定でき、`property`要素で名前参照ができる（上の例と同じ設定）:

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

`component-ref`要素で名前参照ができる:

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

**map要素**: `entry`にkey/valueを設定できる。

```xml
<property name="map">
  <map>
    <entry key="key1" value="1" />
    <entry key="key2" value="2" />
    <entry key="key3" value="3" />
  </map>
</property>
```

map要素にも任意の名前を設定でき、`property`要素で名前参照ができる（上の例と同じ設定）:

```xml
<map name="map">
  <entry key="key1" value="1" />
  <entry key="key2" value="2" />
  <entry key="key3" value="3" />
</map>

<component class="sample.ListSample">
  <!-- mapという名前のMapを設定する -->
  <property name="map" ref="map" />
</component>
```

`value-component`要素でMapの値に任意のBeanを設定できる:

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

> **重要**: mapやlistで`name`属性が同じものを複数定義した場合、先に定義されたものが有効（[repository-override_bean](#s4) とは逆の挙動）。環境毎にmap/listを変更したい場合は、環境毎に読み込むファイルを変えること。

**クラス**: `ComponentFactory`

Java Beansとして実装されていないオブジェクト（ベンダー提供やOSSなど）をシステムリポジトリで管理するには、`ComponentFactory`インタフェースを実装したファクトリクラスを作成する。

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
  <!-- sampleObjectプロパティにファクトリクラスで生成したオブジェクトが設定される -->
  <property name="sampleObject" ref="sampleComponent" />
</component>
```

> **重要**: ファクトリクラスの入れ子は非対応。ファクトリクラスのプロパティに他のファクトリクラスを指定できない。代替策: 1つのファクトリクラス内で入れ子のオブジェクトも含めて構築する、またはCreator/Builder/Providerといったクラスを作成してコンポーネントとしてインジェクションする。

環境設定ファイルはconfigファイルとpropertiesファイルの2種類。

**propertiesファイル**: JavaのPropertiesの仕様に基づいて解析される。

**configファイル仕様**:
- キーと値を `=` で区切る
- `#` を用いた行コメントのみサポート（行中でも有効）
- 行末 `\` で複数行に値を記述できる（行末コメントも可能）
- 予約語 (`#`, `=`, `\`) を一般文字として使う場合は `\` でエスケープ

```bash
key1=value1
key2=value2
# コメントです
key = value   # コメントです
key2 = value,\
value2
key = a\=a
key2 = \#コメントではない
key3 = あ\\い
```

> **補足**: 半角スペースのみの値はconfigファイルでは対応していないが、propertiesファイルでは `\u0020` の数値参照文字で扱える。

> **補足**: 値が空の場合の挙動の違い:
> - configファイル: キーごと読み込まれず、`${config.value}` 参照時に例外が送出される（5u18以前はWARNINGログが出力されプレースホルダ文字列がそのまま設定される）
> - propertiesファイル: 空文字として扱われる

<details>
<summary>keywords</summary>

list要素, map要素, List設定, Map設定, component-ref, value-component, setterインジェクション, entry要素, ComponentFactory, ファクトリクラス, createObject, 非JavaBeans, ファクトリクラス入れ子不可, 環境設定ファイル, configファイル, propertiesファイル, 設定値記述ルール, 行コメント, 複数行設定値, 予約語エスケープ, 空値挙動

</details>

## アノテーションを付与したクラスのオブジェクトを構築する

**アノテーション**: `SystemRepositoryComponent`

`@SystemRepositoryComponent`アノテーションをクラスに付与することで、XMLへの設定なしでDIコンテナの管理対象にできる。

> **重要**: クラスパス配下のリソースを独自のファイルシステムで管理している一部のウェブアプリケーションサーバ（JBoss、Wildflyなど、vfsと呼ばれるバーチャルファイルシステムを使用するサーバ）では使用できない。そのようなサーバを使用する場合はコンポーネントの定義を従来通り[repository-definition_bean](#s3)に従いXMLで定義すること。

<details>
<summary>keywords</summary>

SystemRepositoryComponent, @SystemRepositoryComponent, JBoss, Wildfly, vfs, XML設定省略, DIコンテナ管理

</details>

## 使用方法

**クラス**: `AnnotationComponentDefinitionLoader`

1. `AnnotationComponentDefinitionLoader`を継承し、`getBasePackage()`をオーバーライドして収集対象の基点パッケージを返すクラスを作成する。

```java
public class ExampleComponentDefinitionLoader extends AnnotationComponentDefinitionLoader {
    @Override
    protected String getBasePackage() {
        return "com.example";
    }
}
```

2. [repository-overwrite_environment_configuration_by_os_env_var](#)と同様に、`nablarch.core.repository.di.config.externalize.ExternalizedComponentDefinitionLoader`ファイルに作成したクラスの完全修飾名を記述してサービスプロバイダとして設定する。

3. DIコンテナで管理したいクラスに`@SystemRepositoryComponent`を付与する。

```java
@SystemRepositoryComponent
public class ExampleAction {
}
```

<details>
<summary>keywords</summary>

AnnotationComponentDefinitionLoader, getBasePackage, サービスプロバイダ設定, @SystemRepositoryComponent, ExampleComponentDefinitionLoader, パッケージ収集

</details>
