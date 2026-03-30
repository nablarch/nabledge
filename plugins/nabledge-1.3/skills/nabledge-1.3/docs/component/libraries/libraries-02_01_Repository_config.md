# 設定ファイルの種類とフレームワークが行うリポジトリの初期化

## 設定ファイルの種類とフレームワークが行うリポジトリの初期化

リポジトリの設定は2種類の設定ファイルで行う。

- **環境設定ファイル**: 文字列の設定値をプロパティファイル形式で記述
- **コンポーネント設定ファイル**: リポジトリに保持するインスタンスを設定するXMLファイル（他の章では単に「設定ファイル」と呼ぶ）

> **注意**: WebフレームワークやバッチフレームワークではBootstrap時にリポジトリの初期化が自動的に実行されるため、アプリケーション開発者が初期化処理を実装する必要はない。

`property`要素の`value`属性に文字列で設定できる型（プロパティの簡易設定機能）:

1. `java.lang.String`
2. `boolean`
3. `java.lang.Boolean`
4. `int`
5. `java.lang.Integer`
6. `long`
7. `java.lang.Long`
8. `java.lang.String[]`（カンマ区切り、例: `"abc,def,ghi"`）
9. `int[]`（カンマ区切り、例: `"1,2,3"`）
10. `java.lang.Integer[]`（カンマ区切り、例: `"4,5,6"`）

**設定例（XML）**:
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

**取得例（Java）**:
```java
PrimitiveValueHolder primitiveValueHolder =
    (PrimitiveValueHolder) SystemRepository.getObject("primitiveValueHolder");
System.out.println(primitiveValueHolder.getStringValue()); // "string value"
for (String val : primitiveValueHolder.getStringArrayValue()) {
    System.out.println(val); // "abc", "def", "ghi"
}
```

コンポーネントのプロパティに環境設定ファイルの値を設定できる。データベース接続設定など環境依存する項目を環境設定ファイルに記述することで、XML設定から分離できる。

**使用に必要な設定**:
1. 読み込む環境設定ファイルを作成する
2. コンポーネント設定ファイルの `property` 要素の `value` 属性に `${hello.message}` のように環境設定ファイルに記述したキーを `${}` で囲った文字列を設定する

**使用可能箇所**:
- `property` 要素の `value` 属性（:ref:`参照<repository_elements_property>`）
- `entry` 要素の `key` 属性（:ref:`参照<repository_elements_entry>`）
- `entry` 要素の `value` 属性（:ref:`参照<repository_elements_entry>`）
- `value` 要素の内容（:ref:`参照<repository_elements_value>`）

**設定例**:

環境設定ファイル（hello.config）:
```bash
hello.message = This is Hello Message!!
```

コンポーネント設定ファイル:
```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">

    <!-- 環境設定ファイルのロード設定 -->
    <config-file file="nablarch/core/repository/di/example/configfile/hello.config"/>

    <component name="helloComponent" class="nablarch.core.repository.di.example.hello.HelloComponent">
        <property name="helloMessageProvider" ref="helloMessageProvider"/>
    </component>

    <component name="helloMessageProvider"
        class="nablarch.core.repository.di.example.hello.HelloMessageProvider">
        <!-- 環境設定ファイルに記述した hello.message の値をプロパティhelloMessageに設定する -->
        <property name="helloMessage" value="${hello.message}" />
    </component>
</component-configuration>
```

**設定した値を取得する実装例**:
```java
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// XMLファイルに書いた"${hello.message}"ではなく、環境設定ファイルに設定した"This is Hello Message!!"が出力される。
helloComponent.printHello();
```

`entry` 要素および `list` 要素での使用例:
```xml
<map name="testMap">
    <entry key="[${any.key03}]" value="[${any.key04}]"/>
</map>
<list name="testList">
    <value>[${any.key05}]</value>
</list>
```

## component-configuration 要素

コンポーネント設定ファイルのルート要素。属性なし。

| 子要素名 | 出現回数 | 説明 |
|---|---|---|
| :ref:`import<repository_elements_import>` | 0..* | 他のコンポーネント設定ファイルの読み込みを指定 |
| :ref:`config-file<repository_elements_config-file>` | 0..* | 環境設定ファイルの読み込みを指定 |
| :ref:`component<repository_elements_component>` | 0..* | Java Beans形式のクラスをコンポーネントとして定義 |
| :ref:`list<repository_elements_list>` | 0..* | Listをコンポーネントとして定義。エントリには他コンポーネントや文字列を含められる |
| :ref:`map<repository_elements_map>` | 0..* | Mapをコンポーネントとして定義。エントリのキーと値には他コンポーネントや文字列を含められる |

## import 要素

他のコンポーネント設定ファイルの読み込みを指定する。子要素なし。

| 属性名 | 必須 | 説明 |
|---|---|---|
| file | ○ | インポートするファイル名。単純パスの場合クラスパス上のファイル、`file://`始まりの場合ローカルファイルシステム上のファイル。`dir`指定時は`*`ワイルドカードで複数ファイルのインポート可。 |
| dir | | インポート対象ディレクトリを、本設定ファイルからの相対パスで指定。指定ディレクトリ直下のファイルがインポートされる。 |

## config-file 要素

環境設定ファイルの読み込みを指定する。子要素なし。

| 属性名 | 必須 | 説明 |
|---|---|---|
| file | ○ | 読み込むファイル名。単純パスの場合クラスパス上のファイル、`file://`始まりの場合ローカルファイルシステム上のファイル。`dir`指定時は`*`ワイルドカードで複数ファイルの読み込み可。 |
| dir | | 読み込むファイルのディレクトリを相対パスで指定。指定ディレクトリ直下のファイルが読み込まれる。 |
| encoding | | 環境設定ファイルの文字エンコーディング。省略時はUTF-8。 |

## component 要素

コンポーネントを定義する。

| 子要素名 | 出現回数 | 説明 |
|---|---|---|
| :ref:`property<repository_elements_property>` | 0..* | コンポーネントのプロパティに設定する値を指定 |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | コンポーネント名 |
| class | ○ | コンポーネントのクラス名 |
| autowireType | | 自動インジェクションの方法。`ByType`（型による）/ `ByName`（名前による）/ `None`（自動インジェクションなし）。省略時は`ByType`。 |

## property 要素

コンポーネントのプロパティを設定する。

| 子要素名 | 出現回数 | 説明 |
|---|---|---|
| :ref:`component<repository_elements_component>` | 0..1 | プロパティに設定するコンポーネントを指定 |
| :ref:`list<repository_elements_list>` | 0..1 | プロパティに設定するListを指定 |
| :ref:`map<repository_elements_map>` | 0..1 | プロパティに設定するMapを指定 |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | プロパティ名 |
| value | | プロパティに設定する値を直接指定 |
| ref | | プロパティに設定するコンポーネントのコンポーネント名を指定 |

## list 要素

Listをコンポーネントとして定義する。

| 子要素名 | 出現回数 | 説明 |
|---|---|---|
| :ref:`component<repository_elements_component>` | 0..* | Listの要素とするコンポーネントを直接記述 |
| :ref:`component-ref<repository_elements_component-ref>` | 0..* | この要素の外で定義したコンポーネントをListの要素として参照 |
| :ref:`value<repository_elements_value>` | 0..* | Listの要素とする文字列を指定 |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | 登録するListのコンポーネント名 |

## component-ref 要素

Listの要素となる、他に定義したコンポーネントを指定する。子要素なし。

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | Listの要素とする、この要素の外で定義したコンポーネントのコンポーネント名 |

## value 要素

Listの要素となる文字列を指定する。この要素に指定した内容がそのままListの要素となる。属性なし。文字列には環境設定ファイルに記述した値の埋め込み機能が使用できる（:ref:`repository_use_env_value_at_component_setting` 参照）。

## map 要素

Mapをコンポーネントとして定義する。

| 子要素名 | 出現回数 | 説明 |
|---|---|---|
| :ref:`entry<repository_elements_entry>` | 0..* | Mapに含まれるEntryを定義 |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | 登録するMapのコンポーネント名 |

## entry 要素

MapのEntryを定義する。key属性・key-name属性・key-component要素のいずれか1つと、value属性・value-name属性・value-component要素のいずれか1つを必ず指定する。

| 子要素名 | 出現回数 | 説明 |
|---|---|---|
| :ref:`key-component<repository_elements_key-component>` | 0..1 | Entryのキーとなるコンポーネントを直接記述 |
| :ref:`value-component<repository_elements_value-component>` | 0..1 | Entryの値となるコンポーネントを直接記述 |

| 属性名 | 必須 | 説明 |
|---|---|---|
| key | | Entryのキーとなる文字列を直接記述。環境設定ファイルの値の埋め込み可（:ref:`repository_use_env_value_at_component_setting` 参照）。 |
| key-name | | 外部定義コンポーネントのコンポーネント名を設定し、そのコンポーネントをEntryのキーとして指定 |
| value | | Entryの値となる文字列を直接記述。環境設定ファイルの値の埋め込み可（:ref:`repository_use_env_value_at_component_setting` 参照）。 |
| value-name | | 外部定義コンポーネントのコンポーネント名を設定し、そのコンポーネントをEntryの値として指定 |

## key-component 要素

MapのEntryのキーとなるコンポーネントを定義する。:ref:`component <repository_elements_component>` と同じ子要素・属性を持つ。

## value-component 要素

MapのEntryの値となるコンポーネントを定義する。:ref:`component <repository_elements_component>` と同じ子要素・属性を持つ。

<details>
<summary>keywords</summary>

環境設定ファイル, コンポーネント設定ファイル, リポジトリ初期化, Bootstrap自動初期化, SystemRepository, ConfigFileLoader, XmlComponentDefinitionLoader, DIコンテナ, ObjectLoader, プロパティ簡易設定機能, プリミティブ型注入, String配列, int配列, カンマ区切り設定, PrimitiveValueHolder, java.lang.String[], java.lang.Integer[], java.lang.Boolean, java.lang.Long, config-file要素, ${キー名}プレースホルダ, プロパティ値の外部化, property要素のvalue属性, entry要素のkey属性, entry要素のvalue属性, value要素, 環境依存設定の分離, HelloComponent, HelloMessageProvider, component-configuration, import, config-file, component, property, list, map, entry, component-ref, value, key-component, value-component, autowireType, encoding, key-name, value-name, ref, コンポーネント定義, 自動インジェクション, 環境設定ファイル読み込み, DI設定

</details>

## 環境設定ファイルからの読み込み

リポジトリの内部に保持するオブジェクトはObjectLoaderで読み込む必要がある。ObjectLoaderからリポジトリにオブジェクトを読み込む処理には、`SystemRepository.load` メソッドを呼び出す。

> **警告**: `ConfigFileLoader`、`XmlComponentDefinitionLoader`、`SystemRepository`の初期化処理はWebおよびバッチフレームワークのBootstrapで行われるため、通常のアプリケーション開発者が実装する必要はない。フレームワーク外での使用時のみ参照。

`list`要素でListを、`map`要素でMapをコンポーネントとして登録できる。設定方法は :ref:`repository_elements_list` および :ref:`repository_elements_map` を参照。

## list 要素の使用方法

`list`要素の子要素:
- `component-ref name="..."`: 既存コンポーネントへの参照
- `component class="..."`: インラインのコンポーネント定義
- `value`: 文字列値

**設定例**:
```xml
<component name="compA" class="nablarch.core.repository.di.example.collection.ComponentA">
    <property name="listProperty" ref="listComponent"/>
</component>

<list name="listComponent">
    <component-ref name="valueComponent"/>
    <component class="nablarch.core.repository.di.example.collection.ComponentB">
        <property name="name" value="compB_1"/>
    </component>
    <value>String value</value>
</list>
```

**取得例（Java）**:

親コンポーネントを`SystemRepository.getObject()`で取得し、リストプロパティを取得後、`list.get(インデックス)`で各要素を位置指定で取得する:

```java
ComponentA compA = (ComponentA) SystemRepository.getObject("compA");
List<?> list = compA.getListProperty();

ComponentB compB_0 = (ComponentB) list.get(0);
// "compB_0" が取得できる
System.out.println(compB_0.getName());

ComponentB compB_1 = (ComponentB) list.get(1);
// "compB_1" が取得できる
System.out.println(compB_1.getName());

String stringValue = (String) list.get(2);
// 文字列 "String value" が取得できる
System.out.println(stringValue);
```

## map 要素の使用方法

`map`要素の`entry`子要素でエントリを定義。キー・値の組み合わせ:
- 文字列キー（`key`属性）+ コンポーネント参照（`value-name`属性）
- 文字列キー（`key`属性）+ インラインコンポーネント（`value-component`子要素）
- 文字列キー（`key`属性）+ 文字列値（`value`属性）
- インラインコンポーネントキー（`key-component`子要素）+ インラインコンポーネント値（`value-component`子要素）

**設定例**:
```xml
<map name="mapComponent">
    <!-- 文字列キー + コンポーネント参照 -->
    <entry key="compB_0" value-name="valueComponent"/>
    <!-- 文字列キー + インラインコンポーネント -->
    <entry key="compB_2">
        <value-component class="nablarch.core.repository.di.example.collection.ComponentB">
            <property name="name" value="compB_2"/>
        </value-component>
    </entry>
    <!-- 文字列キー + 文字列値 -->
    <entry key="stringKey" value="String value"/>
    <!-- インラインコンポーネントキー + インラインコンポーネント値 -->
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

**取得例（Java）**:

文字列キーのエントリは`map.get("キー文字列")`で取得できる。`key-component`で定義したエントリを取得するには、同じプロパティ値を持つ`KeyComponent`インスタンスを生成して`map.get(key)`に渡す:

```java
ComponentA compA = (ComponentA) SystemRepository.getObject("compA");
Map<?, ?> map = compA.getMapProperty();

// 文字列キーによる取得
ComponentB compB_0 = (ComponentB) map.get("compB_0"); // "compB_0" が取得できる
String stringValue = (String) map.get("stringKey");   // "String value" が取得できる

// key-component による取得: 同じプロパティ値を持つインスタンスをキーとして渡す
KeyComponent key = new KeyComponent();
key.setId("00001");
key.setLang("ja");
ComponentB compB_3 = (ComponentB) map.get(key); // "compB_3" が取得できる
```

`import` 要素および `config-file` 要素の `dir` 属性を設定することで、ディレクトリに配置されたファイルを一括して読み込める。

`dir` 属性には、コンポーネント設定ファイルが配置されているディレクトリからの**相対パス**を指定する。例えば、コンポーネント設定ファイルが `/opt/component.xml` に配置されている場合に `/opt/environment_config` 以下を一括読み込みする場合は `dir` 属性に `"./environment_config"` と設定する。

**設定例**:
```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">
    <!-- environment_config ディレクトリ以下にある ".config" で終わるファイル名の環境設定ファイルを一括で読み込む -->
    <config-file dir="./environment_config" file="*.config" />

    <!-- component_config ディレクトリ以下にある ".xml" で終わるファイル名のコンポーネント設定ファイルを一括で読み込む -->
    <import dir="./component_config/" file="*.xml" />
</component-configuration>
```

読み込むファイルが頻繁に変更される場合（設定ファイルの増減やファイル名変更が発生する場合）、個別ファイル指定では `import` タグや `config-file` タグを都度書き直す必要があるが、ディレクトリ指定を使用することでその手間を省ける。

:ref:`reporitoy_config_override` に記述した方法で、本番用とテスト用で異なる設定を特定のディレクトリに配置し、本番環境とテスト環境の差異を吸収する使い方もできる。

別々の設定ファイルに記述された同名の設定は :ref:`repository_import_override_priority` および :ref:`repository_import_dir_override_priority` に記述した優先順位で評価される。

<details>
<summary>keywords</summary>

ObjectLoader, SystemRepository, load, ConfigFileLoader, Bootstrap, 環境設定ファイル読み込み, list要素, map要素, component-ref, value-component, key-component, entry, Listコンポーネント登録, Mapコンポーネント登録, ComponentA, ComponentB, KeyComponent, dir属性, import要素, config-file要素, ディレクトリ一括読み込み, ワイルドカード指定, 相対パス, repository_import_dir_override_priority

</details>

## 読み込む環境設定ファイルの記述例

環境設定ファイル（例: sample.config）の形式:
```bash
sample.value1=example-setting
sample.value2=true
```

> 環境設定ファイルの記述ルールの詳細については、:ref:`repository_config_loader_setting` を参照。

`config-file`要素で環境設定ファイル（`key = value`形式）をコンポーネント設定ファイルから読み込める。

**環境設定ファイル例（hello.config）**:
```
hello.message = This is Hello Message!!
```

**コンポーネント設定ファイル設定例**:
```xml
<config-file file="nablarch/core/repository/di/example/configfile/hello.config"/>
```

**値の取得**:
```java
String helloMessage = SystemRepository.getString("hello.message");
```

DIコンテナは、`ref` 属性による明示的なインジェクションに加えて、**クラスの型を判定して自動的にインジェクションを実行する自動インジェクション**機能を持つ。システムで1つしか必要としないコンポーネントについては `property` 要素によるインジェクション設定が不要となる。

**クラス例**:
```java
public interface HelloMessageProvider {
    public String getHelloMessage();
}

public class BasicHelloMessageProvider implements HelloMessageProvider {
    public String getHelloMessage() {
        return "Hello autowire!!";
    }
}

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

**設定例**（`helloComponent` には `property` 要素によるインジェクション設定なし）:
```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">

    <!-- HelloComponentクラスはHelloMessageProvider型のプロパティを持つが、インジェクション設定なし -->
    <component name="helloComponent"
        class="nablarch.core.repository.di.example.autowirebytype.HelloComponent"/>

    <!-- HelloMessageProviderインタフェースを実装したクラス -->
    <component
        class="nablarch.core.repository.di.example.autowirebytype.BasicHelloMessageProvider"/>
</component-configuration>
```

この設定により、`SystemRepository` から取得した `HelloComponent` には自動的に `BasicHelloMessageProvider` が設定される:
```java
HelloComponent helloComponent = (HelloComponent) container.getComponentByName("helloComponent");
// 自動インジェクションされたBasicHelloMessageProviderが返す "Hello autowire!!"が表示される
helloComponent.printHello();
```

<details>
<summary>keywords</summary>

環境設定ファイル, sample.config, プロパティ形式, 設定値記述, config-file要素, SystemRepository.getString, .configファイル, 外部設定値読み込み, 自動インジェクション, autowire, 型によるインジェクション, HelloComponent, HelloMessageProvider, BasicHelloMessageProvider, property要素不要, インタフェース実装クラスの自動解決

</details>

## 環境設定ファイルの読み込み (通常フレームワークの責務)

環境設定ファイルの読み込み（Bootstrapの責務）:
```java
ConfigFileLoader loader = new ConfigFileLoader("sample.config");
// 環境設定ファイルの内容をロード
SystemRepository.load(loader);
// 設定値を取得("example-setting"が取得できる)
```

`import`要素でコンポーネント設定ファイル内に他の設定ファイルを読み込める。

**設定例（2ファイルをインポートする設定ファイル）**:
```xml
<import file="nablarch/core/repository/di/example/imp/imported1.xml"/>
<import file="nablarch/core/repository/di/example/imp/imported2.xml"/>
```

読み込まれたコンポーネントは`SystemRepository.getObject("componentName")`で取得可能。

> **注意**: 以下のブートストラップ処理（`XmlComponentDefinitionLoader`によるDIコンテナ初期化）は通常のアプリケーションでは実装する必要がない。本フレームワークを使用するアプリケーション・プログラマはこのような実装を行わない。

ブートストラップ処理では`XmlComponentDefinitionLoader`で最上位の設定ファイルを指定する:
```java
XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/imp/import.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);
```

`property` 要素には `component` 要素をネストして記述できる。1つのコンポーネントからのみ使用されるコンポーネントを簡潔に記述できる。

**ネストしたコンポーネントのコンポーネント名**: 親コンポーネントの名称と子コンポーネント定義の名称を `"."` で繋いだ名称（例: `helloComponent.helloMessageProvider`）

**設定例**:
```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">
    <component name="helloComponent"
        class="nablarch.core.repository.di.example.autowirebytype.HelloComponent">
        <property name="helloMessageProvider" ref="helloMessageProvider">
            <component name="helloMessageProvider"
                class="nablarch.core.repository.di.example.autowirebytype.BasicHelloMessageProvider"/>
        </property>
    </component>
</component-configuration>
```

**コンポーネントの取得例**:
```java
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
helloComponent.printHello();

// "helloComponent.helloMessageProvider" というコンポーネント名でネストしたコンポーネントを取得できる
HelloMessageProvider helloMessageProvider = (HelloMessageProvider) SystemRepository
        .getObject("helloComponent.helloMessageProvider");
System.out.println(helloMessageProvider.getHelloMessage());
```

<details>
<summary>keywords</summary>

ConfigFileLoader, SystemRepository, load, Bootstrap, 環境設定ファイル読み込み, import要素, 設定ファイル分割, 設定ファイルインポート, XmlComponentDefinitionLoader, 複数設定ファイル読み込み, DiContainer, ネストコンポーネント, component要素のネスト, コンポーネント名のドット結合, property要素ネスト, 親コンポーネント名.子コンポーネント名

</details>

## 環境設定の取得

環境設定の取得には、`SystemRepository` クラスの `getString` または `getBoolean` メソッドを使用する。

```java
String value1 = SystemRepository.getString("sample.value1");
// 設定値を取得(trueが取得できる)
boolean value2 = SystemRepository.getBoolean("sample.value2");
```

> **警告**: 環境設定値取得時のキー値にユーザー入力値やDBから取得した値を使用しないこと。キー値が可変の場合、設定値未取得による障害発生時に障害解析が困難になる。キー値は常に固定値とすること。

環境設定ファイルはキーと値を `=` で対応付けて記述する。

**デリミタ文字（`=`）**:
- デリミタは `=` のみ。空白（タブ含む）や `:` は文字列の一部とみなす（いわゆる `.properties` ファイルとは異なる）
- キーおよび値は前後の空白（タブ含む）をトリミングする（`" A B "` → `"A B"`。キーの `'A'` と `'a'` は区別される）
- `=` で区切られた3つめ以降のトークンは無視する
- `=` をキーまたは値に含める場合は前に `\` を付加する（`\=`）

**コメント文字（`#`）**:
- `#` 以降の文字列をコメントとみなす（行連結の前に処理されるため継続行中でも使用可能）
- `#` をキーまたは値に含める場合は前に `\` を付加する（`\#`）

**改行文字（`\`）**:
- 行末に `\` を指定することで行をまたがる記述が可能。`\` を除いた文字列と次の行の先頭の空白を除いた文字列を連結する（`\` 前の後方空白は維持）
- `\` をキーまたは値に含める場合は前に `\` を付加する（`\\`）

> **注意**: 改行文字（`\`）の前にコメントを入れると設定が正しく動作しない。
> ```bash
> # NG例
> key =   value1,     # comment \
>         value2,     # comment \
>         value3      # comment
> ```

**エスケープ文字（`\`）**:
- `\` に続く1文字を特殊文字ではなく一般文字として扱う
- `\` をキーまたは値に含める場合は前に `\` を付加する

**記述例**:
```bash
# キー＝"key"、値＝"value"の場合
key = value # commnet
key = value = commnet

# キー＝"key"、値＝"value1 = value2"の場合
key = value1 \= value2  #comment
key = \
    value1 \= value2

# キー＝"key"、値＝"value1,value2,value3"の場合
key =   value1,value2,value3    # comment
key =   value1,\
        value2,\
        value3 # comment
key =   value1,\    # comment
        value2,\    # comment
        value3      # comment
```

<details>
<summary>keywords</summary>

getString, getBoolean, SystemRepository, キー値, 固定値, 設定値取得, 環境設定ファイル記述ルール, デリミタ文字, コメント文字, 行連結, エスケープ, propertiesファイルとの違い, \=エスケープ, 行末バックスラッシュ

</details>

## リポジトリに保持するインスタンスの生成(DIコンテナ)

DIコンテナの責務:
1. コンポーネントをインスタンス化する
2. インスタンスのプロパティにコンポーネント設定ファイルに記述した値を設定する
3. コンポーネント間を関連付ける

コンポーネントとして登録できるクラスの条件:
- デフォルトコンストラクタを持つこと
- プロパティに対応したセッタメソッドを持つこと

使用例として、`HelloMessageProvider` クラスと `HelloComponent` クラスの2つをコンポーネントとして登録・関連付ける例を説明する。
- `HelloMessageProvider`: メッセージ文字列を保持し、`getHelloMessage` メソッドでメッセージを返す
- `HelloComponent`: `HelloMessageProvider` を保持し、`printHello` メソッドでメッセージをコンソールに表示する

<details>
<summary>keywords</summary>

DIコンテナ, コンポーネント登録, インスタンス生成, デフォルトコンストラクタ, セッタメソッド, HelloMessageProvider, HelloComponent, プロパティ設定

</details>

## 登録するクラスのソースコード(HelloMessageProvider)

**HelloMessageProvider**のソースコード:
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

<details>
<summary>keywords</summary>

HelloMessageProvider, setHelloMessage, getHelloMessage, helloMessage, コンポーネント登録

</details>

## 登録するクラスのソースコード(HelloComponent)

**HelloComponent**のソースコード:
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

<details>
<summary>keywords</summary>

HelloComponent, setHelloMessageProvider, printHello, HelloMessageProvider, コンポーネント登録

</details>

## コンポーネント設定ファイルの記述(hello.xml)

DIコンテナはコンポーネント設定ファイルを元にコンポーネントの生成を行う。
- `component`要素: `name`属性にコンポーネント名、`class`属性にクラスの完全修飾名を記述
- `property`要素: `name`属性にプロパティ名、`value`属性にプロパティに設定する値（文字列）、`ref`属性に参照先コンポーネント名を記述

`HelloMessageProvider` と `HelloComponent` を登録・関連付けるコンポーネント設定ファイル（hello.xml）の例:
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

コンポーネント設定ファイルの要素・属性詳細: :ref:`repository_elements`

IDEでXSD補完を使用する場合、`component-configuration.xsd` ファイルをコンポーネント設定ファイルと同一ディレクトリに配置し、`xsi:schemaLocation`を適切に設定すること。

> **注意**: リポジトリはフレームワーク提供クラスのみをコンポーネントとして保持することを前提に設計されており、Spring FrameworkやSeasar2といった他のDIコンテナが持つレイジーロードの機能を持っていない。そのため、ビジネスロジックやデータアクセスを行うオブジェクトを登録すると、アプリケーションの起動が遅くなり、ユニットテストやローカルでの画面テストの効率が悪化する。このような使用方法を行う際は、このデメリットが許容範囲にあるか十分に検討すること。

<details>
<summary>keywords</summary>

コンポーネント設定ファイル, XmlComponentDefinitionLoader, component要素, property要素, ref属性, name属性, class属性, value属性, xsi:schemaLocation, component-configuration.xsd, レイジーロード

</details>

## 値を取得する実装例

コンポーネント設定ファイルを元にしてDIコンテナを使用する手順:
1. コンポーネント設定ファイル名を指定して `XmlComponentDefinitionLoader` のインスタンスを生成する
2. 生成した `XmlComponentDefinitionLoader` のインスタンスを引数にして、DIコンテナのインスタンスを生成する
3. 生成したDIコンテナのインスタンスからコンポーネントを取得する

```java
XmlComponentDefinitionLoader loader
    = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/hello/hello.xml");
DiContainer container = new DiContainer(loader);

// DIコンテナで"helloComponent"と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) container.getComponentByName("helloComponent");

// HelloMessageProviderに設定した"hello"がコンソールに表示される
helloComponent.printHello();
```

> **注意**: 通常、コンポーネントの取得はSystemRepositoryから取得する方法で実装する。DIコンテナを直接使用する上記の方法は、DIコンテナの動作説明のための例であり、通常のアプリケーションでは実装しない。

<details>
<summary>keywords</summary>

DiContainer, XmlComponentDefinitionLoader, getComponentByName, コンポーネント取得, 値取得

</details>

## DIコンテナを ObjectLoader として使用する

`DiContainer` は、`ConfigFileLoader` と同様に `ObjectLoader` として使用することで、登録したコンポーネントを `SystemRepository` に登録できる。以下にDIコンテナを使用した `SystemRepository` の初期化処理と、リポジトリからコンポーネントを取得する実装例を示す。

<details>
<summary>keywords</summary>

DiContainer, ObjectLoader, SystemRepository, ConfigFileLoader

</details>

## SystemRepository の初期化処理

SystemRepositoryの初期化処理（Bootstrapの責務）:
```java
XmlComponentDefinitionLoader loader
    = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/hello/hello.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);
```

<details>
<summary>keywords</summary>

DiContainer, XmlComponentDefinitionLoader, SystemRepository, load, SystemRepository初期化

</details>

## SystemRepository からのコンポーネント取得

SystemRepositoryからのコンポーネント取得（通常の実装方法）:
```java
// SystemRepositoryから"helloComponent"と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// HelloMessageProviderに設定した"hello"がコンソールに表示される
helloComponent.printHello();
```

<details>
<summary>keywords</summary>

SystemRepository, getObject, コンポーネント取得

</details>
