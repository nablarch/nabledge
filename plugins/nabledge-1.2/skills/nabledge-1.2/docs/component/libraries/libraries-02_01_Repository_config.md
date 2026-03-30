# 設定ファイルの種類とフレームワークが行うリポジトリの初期化

## 設定ファイルの種類とフレームワークが行うリポジトリの初期化

リポジトリの設定は2種類の設定ファイルで行う。

- **環境設定ファイル**: 文字列による設定値をプロパティファイルに似た形式で記述
- **コンポーネント設定ファイル**: リポジトリに保持するインスタンスを設定（他の章では単に「設定ファイル」と記述）

> **注意**: Webフレームワークやバッチフレームワークはフレームワーク起動時にリポジトリを自動初期化するため、通常のアプリケーションでは初期化処理の実装は不要。

## property 要素の value 属性で設定できる型

`property`要素の`value`属性で文字列表現により設定できる型（プロパティの簡易設定機能）：

1. `java.lang.String`
2. `boolean`
3. `java.lang.Boolean`
4. `int`
5. `java.lang.Integer`
6. `long`
7. `java.lang.Long`
8. `java.lang.String[]`
9. `int[]`
10. `java.lang.Integer[]`

配列型の値はカンマ区切りで指定する（例: `value="abc,def,ghi"`）。

**クラス**: `nablarch.core.repository.di.example.primitivevalue.PrimitiveValueHolder`

```xml
<component name="primitiveValueHolder" class="nablarch.core.repository.di.example.primitivevalue.PrimitiveValueHolder">
    <property name="stringValue" value="string value" />
    <property name="boolValue" value="true" />
    <property name="boolWrapperValue" value="false" />
    <property name="intValue" value="2" />
    <property name="intWrapperValue" value="3" />
    <property name="longValue" value="5" />
    <property name="longWrapperValue" value="6" />
    <property name="stringArrayValue" value="abc,def,ghi" />
    <property name="intArrayValue" value="1,2,3" />
    <property name="integerArrayValue" value="4,5,6" />
</component>
```

```java
PrimitiveValueHolder primitiveValueHolder
    = (PrimitiveValueHolder) SystemRepository.getObject("primitiveValueHolder");
```

コンポーネントのプロパティに環境設定ファイル（`.config`）の値を設定できる。`${key.name}` 構文で参照する。

**使用手順**:
1. 環境設定ファイルを作成（`key = value` 形式）
2. コンポーネント設定ファイルで `<config-file>` 要素でロード
3. `property` 要素の `value` 属性に `${key.name}` 形式で指定

**環境設定ファイル例（hello.config）**:
```bash
hello.message = This is Hello Message!!
```

**コンポーネント設定ファイル例**:
```xml
<config-file file="nablarch/core/repository/di/example/configfile/hello.config"/>

<component name="helloMessageProvider"
    class="nablarch.core.repository.di.example.hello.HelloMessageProvider">
    <property name="helloMessage" value="${hello.message}" />
</component>
```

**実装例（値の取得）**:
```java
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// XMLファイルに書いた"${hello.message}"ではなく、環境設定ファイルに設定した"This is Hello Message!!"が出力される。
helloComponent.printHello();
```
`${hello.message}` という記述は実行時に環境設定ファイルの値 `"This is Hello Message!!"` に解決される。

**`${}` 構文が使用できる箇所**:
- `property` 要素の `value` 属性
- `entry` 要素の `key` 属性
- `entry` 要素の `value` 属性
- `value` 要素の内容

```xml
<map name="testMap">
    <entry key="[${any.key03}]" value="[${any.key04}]"/>
</map>
<list name="testList">
    <value>[${any.key05}]</value>
</list>
```

## component-configuration 要素
ルート要素。属性なし。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| import | 0..* | 他のコンポーネント設定ファイルの読み込みを指定する |
| config-file | 0..* | 環境設定ファイルの読み込みを指定する |
| component | 0..* | Java Beans 形式のクラスをコンポーネントとして定義する |
| list | 0..* | List をコンポーネントとして定義する。エントリには他のコンポーネントや文字列を含めることができる |
| map | 0..* | Map をコンポーネントとして定義する。エントリのキーと値には他のコンポーネントや文字列を含めることができる |

## import 要素
他のコンポーネント設定ファイルの読み込みを指定する。子要素なし。

| 属性名 | 必須 | 説明 |
|---|---|---|
| file | ○ | インポートするファイル名。クラスパス上のファイル、または `file://` プレフィックスでローカルファイルシステム上のファイルを指定。`dir` と組み合わせてワイルドカード(`*`)による複数ファイルのインポートが可能 |
| dir | | インポート対象のディレクトリを、コンポーネント設定ファイルからの相対パスで指定。指定したディレクトリ直下のファイルがインポートされる |

## config-file 要素
環境設定ファイルの読み込みを指定する。子要素なし。

| 属性名 | 必須 | 説明 |
|---|---|---|
| file | ○ | 読み込むファイル名。クラスパス上のファイル、または `file://` プレフィックスでローカルファイルシステム上のファイルを指定。`dir` と組み合わせてワイルドカード(`*`)による複数ファイルの読み込みが可能 |
| dir | | 読み込むファイルのディレクトリを、コンポーネント設定ファイルからの相対パスで指定。指定したディレクトリ直下のファイルが読み込まれる |
| encoding | | 環境設定ファイルの文字エンコーディング。省略時はUTF-8 |

## component 要素
コンポーネントを定義する。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| property | 0..* | コンポーネントのプロパティに設定する値を指定する |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | コンポーネント名 |
| class | ○ | コンポーネントのクラス名 |
| autowireType | | 自動インジェクションの方法。`ByType`（型による）、`ByName`（名前による）、`None`（行わない）。省略時は `ByType` |

## property 要素
コンポーネントのプロパティを設定する。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| component | 0..1 | プロパティに設定するコンポーネントを指定する |
| list | 0..1 | プロパティに設定する List を指定する |
| map | 0..1 | プロパティに設定する Map を指定する |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | プロパティ名 |
| value | | プロパティに設定する値を直接指定する |
| ref | | プロパティに設定するコンポーネントのコンポーネント名 |

## list 要素
List をコンポーネントとして定義する。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| component | 0..* | List の要素とするコンポーネントを直接記述する |
| component-ref | 0..* | List の要素とする、外部で定義したコンポーネントを指定する |
| value | 0..* | List の要素とする文字列を指定する |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | 登録する List のコンポーネント名 |

## component-ref 要素
List の要素となる、他に定義したコンポーネントを指定する。子要素なし。

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | List の要素とする、外部で定義したコンポーネントのコンポーネント名 |

## value 要素
List の要素となる文字列を指定する。この要素に指定した内容がそのまま List の要素となる。文字列には環境設定ファイルの値の埋め込み機能が使用できる（:ref:`repository_use_env_value_at_component_setting` 参照）。属性なし。

## map 要素
Map をコンポーネントとして定義する。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| entry | 0..* | Map に含まれる Entry を定義する |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | 登録する Map のコンポーネント名 |

## entry 要素
Map の Entry を定義する。`key`/`key-name`/`key-component` のいずれか1つと、`value`/`value-name`/`value-component` のいずれか1つを必ず指定する。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| key-component | 0..1 | Entry のキーとなるコンポーネントを直接記述する |
| value-component | 0..1 | Entry の値となるコンポーネントを直接記述する |

| 属性名 | 必須 | 説明 |
|---|---|---|
| key | | Entry のキーとなる文字列。環境設定ファイルの値の埋め込み機能が使用可能（:ref:`repository_use_env_value_at_component_setting` 参照） |
| key-name | | 外部で定義したコンポーネントのコンポーネント名を設定し、そのコンポーネントを Entry のキーとして指定する |
| value | | Entry の値となる文字列。環境設定ファイルの値の埋め込み機能が使用可能（:ref:`repository_use_env_value_at_component_setting` 参照） |
| value-name | | 外部で定義したコンポーネントのコンポーネント名を設定し、そのコンポーネントを Entry の値として指定する |

## key-component 要素
Map の Entry のキーとなるコンポーネントを定義する。:ref:`component <repository_elements_component>` と同じ子要素、属性を持つ。

## value-component 要素
Map の Entry の値となるコンポーネントを定義する。:ref:`component <repository_elements_component>` と同じ子要素、属性を持つ。

<details>
<summary>keywords</summary>

環境設定ファイル, コンポーネント設定ファイル, リポジトリ初期化, SystemRepository, ConfigFileLoader, 設定ファイルの種類, プロパティの簡易設定機能, PrimitiveValueHolder, property要素 value属性, 配列型カンマ区切り, java.lang.String, boolean, java.lang.Boolean, int, java.lang.Integer, long, java.lang.Long, java.lang.String[], int[], java.lang.Integer[], config-file要素, プロパティ値の外部化, ${} 構文, entry要素, value要素, 環境依存設定の分離, 実行時解決, component-configuration, import, config-file, component, property, list, component-ref, value, map, entry, key-component, value-component, autowireType, ByType, ByName, None, file, dir, encoding, class, ref, key, key-name, value-name, name, 自動インジェクション, コンポーネント定義, XMLリファレンス

</details>

## 環境設定ファイルからの読み込み

**クラス**: `ConfigFileLoader`, `SystemRepository`

> **警告**: ConfigFileLoader、XmlComponentDefinitionLoader、SystemRepositoryを使用した初期化処理はWebおよびバッチフレームワークのBootstrap内で行われる。通常のアプリケーション開発者はこれらの実装を行わない。

リポジトリの内部に保持するオブジェクトは `ObjectLoader` で読み込む必要がある。`ObjectLoader` からリポジトリにオブジェクトを読み込む処理には、`SystemRepository.load` メソッドを呼び出す。

環境設定ファイル(sample.config)の記述例:

```bash
sample.value1=example-setting
sample.value2=true
```

環境設定ファイルの読み込み:

```java
ConfigFileLoader loader = new ConfigFileLoader("sample.config");
SystemRepository.load(loader);
```

環境設定ファイルの記述ルールの詳細は :ref:`repository_config_loader_setting` を参照。

## List と Map をコンポーネントとして登録する

`list`要素でListを、`map`要素でMapをコンポーネントとして登録できる。設定の記述方法は :ref:`repository_elements_list` および :ref:`repository_elements_map` を参照。

### list 要素

```xml
<list name="listComponent">
    <!-- 既存コンポーネントの参照 -->
    <component-ref name="valueComponent"/>
    <!-- インラインでコンポーネントを定義 -->
    <component class="nablarch.core.repository.di.example.collection.ComponentB">
        <property name="name" value="compB_1"/>
    </component>
    <!-- 文字列を追加 -->
    <value>String value</value>
</list>
```

`list`要素には`component-ref`（既存コンポーネントの参照）、`component`（インライン定義）、`value`（文字列）を混在できる。挿入順でインデックスアクセスする。要素の型に応じてキャストが必要：

```java
ComponentA compA = (ComponentA) SystemRepository.getObject("compA");
List<?> list = compA.getListProperty();
ComponentB compB_0 = (ComponentB) list.get(0); // component-ref で参照したコンポーネント
ComponentB compB_1 = (ComponentB) list.get(1); // インラインで定義したコンポーネント
String stringValue = (String) list.get(2);      // value で追加した文字列
```

### map 要素

`entry`要素のキー・値の指定方法：
- 文字列キー: `key`属性
- インラインコンポーネントキー: `key-component`子要素
- 文字列値: `value`属性
- コンポーネント参照値: `value-name`属性
- インラインコンポーネント値: `value-component`子要素

```xml
<map name="mapComponent">
    <!-- キー:文字列、値:コンポーネント参照 -->
    <entry key="compB_0" value-name="valueComponent"/>
    <!-- キー:文字列、値:インラインコンポーネント -->
    <entry key="compB_2">
        <value-component class="nablarch.core.repository.di.example.collection.ComponentB">
            <property name="name" value="compB_2"/>
        </value-component>
    </entry>
    <!-- キー:文字列、値:文字列 -->
    <entry key="stringKey" value="String value"/>
    <!-- キー:インラインコンポーネント、値:インラインコンポーネント -->
    <entry>
        <key-component class="nablarch.core.repository.di.example.collection.KeyComponent">
            <property name="id" value="00001"/>
            <property name="lang" value="ja"/>
        </key-component>
        <value-component class="nablarch.core.repository.di.example.collection.ComponentB">
            <property name="name" value="compB_3"/>
        </value-component>
    </entry>
</map>
```

`key-component`で定義したキーで値を取得する場合、同じプロパティ値を持つ新しいインスタンスを生成してルックアップキーとして使用する：

```java
ComponentA compA = (ComponentA) SystemRepository.getObject("compA");
Map<?, ?> map = compA.getMapProperty();

ComponentB compB_0 = (ComponentB) map.get("compB_0");
ComponentB compB_2 = (ComponentB) map.get("compB_2");
String stringValue = (String) map.get("stringKey");

// key-component で定義したキーを使う場合、同じプロパティ値のインスタンスを生成して検索する
KeyComponent key = new KeyComponent();
key.setId("00001");
key.setLang("ja");
ComponentB compB_3 = (ComponentB) map.get(key);
```

`import` 要素および `config-file` 要素の `dir` 属性にディレクトリを指定することで、ディレクトリ内のファイルを一括して読み込める。

`dir` 属性にはコンポーネント設定ファイルが配置されているディレクトリからの相対パスを指定する（例：コンポーネント設定ファイルが `/opt/component.xml` の場合、`/opt/environment_config` を読み込むには `dir="./environment_config"` と指定）。

**コンポーネント設定ファイル例**:
```xml
<!-- environment_config ディレクトリ以下の ".config" ファイルを一括ロード -->
<config-file dir="./environment_config" file="*.config" />

<!-- component_config ディレクトリ以下の ".xml" ファイルを一括ロード -->
<import dir="./component_config/" file="*.xml" />
```

**ディレクトリ指定を使うべき場面**:
- 複数拠点からリリースされた設定ファイルを1つのディレクトリに集約して一括読み込みしたい場合
- 設定ファイルの増減やファイル名変更が頻繁に発生する場合。個別ファイル指定（`import` / `config-file` タグへの直接記述）では、ファイルの追加・削除・リネームのたびに設定を書き直す必要があるが、ディレクトリ指定ではその手間が不要

<details>
<summary>keywords</summary>

ConfigFileLoader, SystemRepository, ObjectLoader, repository_config_loader_setting, 環境設定ファイル読み込み, sample.config, list要素, map要素, ListコンポーネントMap登録, component-ref, entry, value-name, key-component, value-component, ComponentA, ComponentB, KeyComponent, dir属性, ディレクトリ一括読み込み, config-file要素, import要素, ワイルドカード, 設定ファイル増減, 複数拠点

</details>

## 環境設定の取得

`SystemRepository.getString` または `SystemRepository.getBoolean` で設定値を取得する。

```java
String value1 = SystemRepository.getString("sample.value1");
boolean value2 = SystemRepository.getBoolean("sample.value2");
```

> **警告**: 環境設定値取得のキー値にユーザ入力値やDBから取得した値を使用しないこと。キー値は常に固定値とすること。可変キーを使用した場合、設定値が取得できない障害が発生しやすく、障害解析の難易度も上がる。

## コンポーネント設定ファイルからの環境設定ファイル読み込み

`config-file`要素で環境設定ファイルをコンポーネント設定ファイルから読み込める。

```xml
<config-file file="nablarch/core/repository/di/example/configfile/hello.config"/>
```

環境設定ファイル形式（例: hello.config）:
```
hello.message = This is Hello Message!!
```

```java
// hello.configに設定した値を取得
String helloMessage = SystemRepository.getString("hello.message");
```

DIコンテナがプロパティの型を判定して自動的にインジェクションを実行する機能。システムで1つしか必要としないコンポーネントについては `property` 要素によるインジェクション設定が不要となる。

**設定例**:
```xml
<!-- HelloComponentはHelloMessageProvider型のプロパティを持つが、property設定不要 -->
<component name="helloComponent"
    class="nablarch.core.repository.di.example.autowirebytype.HelloComponent"/>

<!-- HelloMessageProviderインタフェースを実装したクラス（名前は不要） -->
<component
    class="nablarch.core.repository.di.example.autowirebytype.BasicHelloMessageProvider"/>
```

DIコンテナが `HelloComponent` の `setHelloMessageProvider(HelloMessageProvider)` セッタを検出し、`BasicHelloMessageProvider`（`HelloMessageProvider` 実装クラス）を自動インジェクションする。

> **※** 互いに疎結合な状態のまま結合できるという利点はDIコンテナの持つ特性であり、**自動インジェクションを使用しない場合でも**DIコンテナを使用することでこのメリットは享受できる。

<details>
<summary>keywords</summary>

getString, getBoolean, 環境設定値取得, 設定値取得, SystemRepository, キー値固定, config-file要素, 環境設定ファイル読み込み, SystemRepository.getString, configファイル, hello.config, 自動インジェクション, HelloMessageProvider, BasicHelloMessageProvider, HelloComponent, 型によるインジェクション, autowire, 疎結合

</details>

## リポジトリに保持するインスタンスの生成(DIコンテナ)

**クラス**: `DiContainer`

DIコンテナの責務:
1. コンポーネントをインスタンス化する
2. インスタンスのプロパティにコンポーネント設定ファイルに記述した値を設定する
3. コンポーネント間を関連付ける

コンポーネントとして登録できるクラスの条件:
- デフォルトコンストラクタを持つこと
- プロパティに対応したセッタメソッドを持つこと

### 登録するクラスのソースコード(HelloMessageProvider)

```java
public class HelloMessageProvider {
    private String helloMessage;

    public void setHelloMessage(String hello) {
        this.helloMessage = hello;
    }

    public String getHelloMessage() {
        return helloMessage;
    }
}
```

### 登録するクラスのソースコード(HelloComponent)

```java
public class HelloComponent {

    private HelloMessageProvider helloMessageProvider;

    public void setHelloMessageProvider(HelloMessageProvider helloProvider) {
        this.helloMessageProvider = helloProvider;
    }

    public void printHello() {
        System.out.println(helloMessageProvider.getHelloMessage());
    }
}
```

## 複数のコンポーネント設定ファイルの読み込み

`import`要素で他のコンポーネント設定ファイルを読み込める。

```xml
<import file="nablarch/core/repository/di/example/imp/imported1.xml"/>
<import file="nablarch/core/repository/di/example/imp/imported2.xml"/>
```

> **注意**: `XmlComponentDefinitionLoader`および`DiContainer`を使用した`SystemRepository.load()`はブートストラップ処理で行うべき処理であり、通常のアプリケーションでは実装する必要がない。

```java
XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/imp/import.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);

HelloImport helloImport1 = (HelloImport) SystemRepository.getObject("helloImport1");
HelloImport helloImport2 = (HelloImport) SystemRepository.getObject("helloImport2");
```

`property` 要素内に `component` 要素をネストして記述できる。1つのコンポーネントからのみ使用されるコンポーネントを簡潔に記述できる。ネストしたコンポーネントのコンポーネント名は `{親コンポーネント名}.{コンポーネント名}` 形式となる。

**コンポーネント設定ファイル例**:
```xml
<component name="helloComponent"
    class="nablarch.core.repository.di.example.autowirebytype.HelloComponent">
    <property name="helloMessageProvider" ref="helloMessageProvider">
        <component name="helloMessageProvider"
            class="nablarch.core.repository.di.example.autowirebytype.BasicHelloMessageProvider"/>
    </property>
</component>
```

ネストしたコンポーネントは `{親名}.{コンポーネント名}` で取得できる:
```java
// "helloComponent.helloMessageProvider" という名前で取得
HelloMessageProvider helloMessageProvider = (HelloMessageProvider) SystemRepository
        .getObject("helloComponent.helloMessageProvider");
```

<details>
<summary>keywords</summary>

DIコンテナ, DiContainer, コンポーネント登録, HelloMessageProvider, HelloComponent, デフォルトコンストラクタ, セッタメソッド, import要素, 複数コンポーネント設定ファイル, XmlComponentDefinitionLoader, HelloImport, ブートストラップ, SystemRepository.load, ネストコンポーネント, property要素のネスト, コンポーネント名の命名規則, BasicHelloMessageProvider

</details>

## コンポーネント設定ファイルの記述

コンポーネント設定ファイルは `component` 要素でコンポーネントを、`property` 要素でプロパティ設定を記述する。

- `component` 要素: `name` 属性にコンポーネント名、`class` 属性にクラスの完全修飾名
- `property` 要素: `name` 属性にプロパティ名、`value` 属性に値または `ref` 属性に参照コンポーネント名

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">
    <component name="helloComponent" class="nablarch.core.repository.di.example.hello.HelloComponent">
        <property name="helloMessageProvider" ref="helloMessageProvider"/>
    </component>
    <component name="helloMessageProvider"
       class="nablarch.core.repository.di.example.hello.HelloMessageProvider">
        <property name="helloMessage" value="hello!" />
    </component>
</component-configuration>
```

コンポーネント設定ファイルの要素・属性の詳細は :ref:`repository_elements` を参照。

IDEでの編集: [component-configuration.xsd](../../../knowledge/component/libraries/assets/libraries-02_01_Repository_config/component-configuration.xsd) をコンポーネント設定ファイルと同一ディレクトリに配置し、`xsi:schemaLocation` を適切に設定するとXMLバリデーション・入力補完が利用できる（推奨）。

> **注意**: リポジトリはフレームワーク提供クラスのみをコンポーネントとして保持することを前提に設計されており、Spring FrameworkやSeasar2といった他のDIコンテナのようにビジネスロジックやデータアクセスオブジェクトを登録することは想定していない。この設計前提により、リポジトリはこれらDIコンテナが持つ**レイジーロードの機能を持っていない**。そのため、DIコンテナにビジネスロジックやデータアクセスオブジェクトを登録すると、アプリケーション起動が遅くなり、ユニットテストやローカル画面テストの効率が悪化する。このような使用方法を行う際は、デメリットが許容範囲にあるか十分に検討すること。

環境設定ファイルはキーと値を `=` で対応付けて記述する。

| 特殊文字 | 説明 |
|---|---|
| `=`（デリミタ） | キーと値の区切り。空白・タブ・`:` はデリミタとみなさない（propertiesファイルとは異なる）。前後の空白はトリミング（例：`" A B "` → `"A B"`）。**キーは大文字・小文字を区別する**（`'A'` と `'a'` は別のキー）。`=` を含めたい場合は `\=` |
| `#`（コメント） | `#` 以降はコメント。**コメント除去は行連結より先に処理されるため、継続行中でも使用可能**。`#` を含めたい場合は `\#` |
| `\`（行継続） | 行末の `\` で次の行と連結。次の行の先頭空白は除去。**`\` を除いた部分の後方の空白は維持される**。`\` を含めたい場合は `\\` |
| `\`（エスケープ） | 直後の1文字を一般文字として扱う |

> **注意**: 行継続文字（`\`）の前にコメントを入れると設定が正しく動作しない。
> ```bash
> # 下記はNG。
> key =   value1,     # comment \
>         value2,     # comment \
>         value3      # comment
> ```

**記述例**:
```bash
# キー＝"key"、値＝"value"
key = value # comment
key = value = comment  # 3つめ以降のトークンは無視

# キー＝"key"、値＝"value1 = value2"
key = value1 \= value2

# キー＝"key"、値＝"value1,value2,value3"
key = value1,\
        value2,\
        value3

# キー＝"key"、値＝"value1,value2,value3"（継続行中のコメントも有効）
key =   value1,\    # comment
        value2,\    # comment
        value3      # comment
```

<details>
<summary>keywords</summary>

component要素, property要素, コンポーネント設定ファイル, XmlComponentDefinitionLoader, repository_elements, xsi:schemaLocation, レイジーロード, Spring Framework, Seasar2, 環境設定ファイル記述ルール, デリミタ文字, コメント文字, 行継続, エスケープ文字, config記述形式, 継続行コメント, 後方空白維持

</details>

## 値を取得する実装例(DIコンテナ直接使用)

記述したコンポーネント設定ファイルを元にしてDIコンテナを使用する手順:

1. コンポーネント設定ファイル名を指定して `XmlComponentDefinitionLoader` のインスタンスを生成
2. 生成した `XmlComponentDefinitionLoader` を引数に `DiContainer` のインスタンスを生成
3. 生成した `DiContainer` からコンポーネントを取得

```java
XmlComponentDefinitionLoader loader
    = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/hello/hello.xml");
DiContainer container = new DiContainer(loader);

// DIコンテナで"helloComponent"と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) container.getComponentByName("helloComponent");

// HelloMessageProviderに設定した"hello"がコンソールに表示される
helloComponent.printHello();
```

> **警告**: 通常、コンポーネントの取得はSystemRepositoryから行う。DIコンテナを直接使用する方法は説明目的であり、通常のアプリケーションでは実装しない。

<details>
<summary>keywords</summary>

DiContainer, XmlComponentDefinitionLoader, getComponentByName, コンポーネント取得

</details>

## DIコンテナを ObjectLoader として使用する

**クラス**: `DiContainer`, `SystemRepository`

`DiContainer` は `ObjectLoader` として使用することで、登録したコンポーネントを `SystemRepository` に登録できる。

> **警告**: 以下の初期化処理はBootstrap処理で行うべき処理であり、通常のアプリケーションでは実装不要。

SystemRepository の初期化:

```java
XmlComponentDefinitionLoader loader
    = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/hello/hello.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);
```

SystemRepository からのコンポーネント取得:

```java
// SystemRepositoryから"helloComponent"と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// HelloMessageProviderに設定した"hello"がコンソールに表示される
helloComponent.printHello();
```

<details>
<summary>keywords</summary>

ObjectLoader, DiContainer, SystemRepository, getObject, コンポーネント取得, SystemRepository初期化

</details>
