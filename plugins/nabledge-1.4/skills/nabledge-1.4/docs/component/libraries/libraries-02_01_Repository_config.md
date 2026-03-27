# 設定ファイルの種類とフレームワークが行うリポジトリの初期化

## 設定ファイルの種類とフレームワークが行うリポジトリの初期化

リポジトリの設定には2種類の設定ファイルを使用する。

- **環境設定ファイル**: 文字列による設定値をプロパティファイルに似た形式で記述
- **コンポーネント設定ファイル**: リポジトリに保持するインスタンスを設定（DIコンテナ用XML）

> **注意**: Webフレームワークやバッチフレームワークはリポジトリの初期化を自動的に行うため、通常のアプリケーションでは初期化処理の実装は不要。設定ファイルを記述するだけでリポジトリが使用できる。

`property` 要素の `value` 属性で設定できる型（プロパティの簡易設定機能）:

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

配列型は `,` 区切りの文字列で設定する（例: `value="abc,def,ghi"`、`value="1,2,3"`）。

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

設定後は `SystemRepository.getObject("primitiveValueHolder")` でインスタンスを取得できる。

コンポーネントのプロパティには環境設定ファイルに記述した値を設定できる。データベース接続設定など環境依存する項目を環境設定ファイルに記述することで、XMLによる設定と分離できる。

**必要な設定（2種類）:**
1. 読み込む環境設定ファイルを作成する
2. コンポーネント設定ファイルの`property`要素の`value`属性に`${hello.message}`のように`${キー名}`形式で値を設定する

**環境設定ファイル（hello.config）:**
```bash
hello.message = This is Hello Message!!
```

**コンポーネント設定ファイル:**
```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">

    <config-file file="nablarch/core/repository/di/example/configfile/hello.config"/>

    <component name="helloComponent" class="nablarch.core.repository.di.example.hello.HelloComponent">
        <property name="helloMessageProvider" ref="helloMessageProvider"/>
    </component>

    <component name="helloMessageProvider"
        class="nablarch.core.repository.di.example.hello.HelloMessageProvider">
        <property name="helloMessage" value="${hello.message}" />
    </component>
</component-configuration>
```

**設定した値を取得する実装例:**
```java
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// XMLファイルに書いた"${hello.message}"ではなく、環境設定ファイルに設定した"This is Hello Message!!"が出力される。
helloComponent.printHello();
```

**`${}`形式が使用できる箇所:**
- `property`要素の`value`属性 (:ref:`参照<repository_elements_property>`)
- `entry`要素の`key`属性 (:ref:`参照<repository_elements_entry>`)
- `entry`要素の`value`属性 (:ref:`参照<repository_elements_entry>`)
- `value`要素の内容 (:ref:`参照<repository_elements_value>`)

**`entry`/`list`要素での使用例:**
```xml
<map name="testMap">
    <entry key="[${any.key03}]" value="[${any.key04}]"/>
</map>
<list name="testList">
    <value>[${any.key05}]</value>
</list>
```

## component-configuration / import / config-file 要素

### component-configuration 要素

コンポーネント設定ファイルのルート要素。属性なし。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| import | 0..* | 他のコンポーネント設定ファイルの読み込みを指定する |
| config-file | 0..* | 環境設定ファイルの読み込みを指定する |
| component | 0..* | Java Beans形式のクラスをコンポーネントとして定義する |
| list | 0..* | Listをコンポーネントとして定義する。エントリには他のコンポーネントや文字列を含めることができる |
| map | 0..* | Mapをコンポーネントとして定義する。エントリのキーと値には他のコンポーネントや文字列を含めることができる |

### import 要素

他のコンポーネント設定ファイルの読み込みを指定する。子要素なし。

| 属性名 | 必須 | 説明 |
|---|---|---|
| file | ○ | インポートするファイル名。単純パス→クラスパス上のファイル、`file://`始まり→ローカルFS上のファイル。`dir`と組み合わせてワイルドカード（`*`）による複数ファイルインポート可 |
| dir | | インポート対象ディレクトリを本ファイルからの相対パスで指定。指定ディレクトリ直下のファイルがインポートされる |

### config-file 要素

環境設定ファイルの読み込みを指定する。子要素なし。

| 属性名 | 必須 | 説明 |
|---|---|---|
| file | ○ | 読み込むファイル名。単純パス→クラスパス上のファイル、`file://`始まり→ローカルFS上のファイル。`dir`と組み合わせてワイルドカード（`*`）による複数ファイル読み込み可 |
| dir | | 読み込むファイルのディレクトリを本ファイルからの相対パスで指定。指定ディレクトリ直下のファイルが読み込まれる |
| encoding | | 環境設定ファイルの文字エンコーディング。省略時はUTF-8 |

<details>
<summary>keywords</summary>

環境設定ファイル, コンポーネント設定ファイル, リポジトリ初期化, SystemRepository, ConfigFileLoader, DIコンテナ, プロパティの簡易設定機能, PrimitiveValueHolder, java.lang.String[], int[], java.lang.Integer[], プリミティブ型のインジェクション, 配列型のプロパティ設定, value属性による型変換, ${} プレースホルダー, config-file要素, 環境依存設定の分離, property要素 value属性, entry要素 key value属性, value要素, getObject, component-configuration, import, config-file, file, dir, encoding, ワイルドカードインポート, 環境設定ファイル読み込み

</details>

## 環境設定ファイルからの読み込み

**クラス**: `ConfigFileLoader`, `SystemRepository`

リポジトリの内部に保持するオブジェクトはObjectLoaderで読み込む必要がある。ObjectLoaderからリポジトリにオブジェクトを読み込む処理には、`SystemRepository.load()`を呼び出す。

環境設定ファイルの形式（プロパティファイルに似た形式）:

```bash
sample.value1=example-setting
sample.value2=true
```

初期化処理（ブートストラップの責務）:

```java
ConfigFileLoader loader = new ConfigFileLoader("sample.config");
SystemRepository.load(loader);
```

環境設定の取得には `SystemRepository.getString(key)` または `SystemRepository.getBoolean(key)` を使用する。

```java
String value1 = SystemRepository.getString("sample.value1");
boolean value2 = SystemRepository.getBoolean("sample.value2");
```

> **警告**: 環境設定値取得時のキー値にはユーザー入力値やDBから取得した値を使用しないこと。取得失敗時にキー値が可変だと障害解析が困難になる。キー値は常に固定値にすること。

> **注意**: 環境設定ファイルの記述ルール詳細は :ref:`repository_config_loader_setting` を参照。

`List` や `Map` のプロパティを持つコンポーネントは、`list` 要素・`map` 要素でコンポーネントとして登録する。詳細仕様は :ref:`repository_elements_list` および :ref:`repository_elements_map` を参照。

## list 要素

`list` 要素の子要素:
- `component-ref`: 登録済みコンポーネントへの参照
- `component`: インラインのコンポーネント定義
- `value`: 文字列値

```xml
<list name="listComponent">
    <component-ref name="valueComponent"/>
    <component class="nablarch.core.repository.di.example.collection.ComponentB">
        <property name="name" value="compB_1"/>
    </component>
    <value>String value</value>
</list>
```

## map 要素

`entry` 要素でキーと値を定義する。キー・値にはそれぞれ文字列属性・コンポーネント参照・インラインコンポーネントが使用可能。

```xml
<map name="mapComponent">
    <!-- キー:文字列, 値:コンポーネント参照 -->
    <entry key="compB_0" value-name="valueComponent"/>
    <!-- キー:文字列, 値:インラインコンポーネント -->
    <entry key="compB_2">
        <value-component class="nablarch.core.repository.di.example.collection.ComponentB">
            <property name="name" value="compB_2"/>
        </value-component>
    </entry>
    <!-- キー:文字列, 値:文字列 -->
    <entry key="stringKey" value="String value"/>
    <!-- キー:インラインコンポーネント, 値:インラインコンポーネント -->
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

コンポーネントキーを使って値を取得するには、同じプロパティ値を持つ新しいインスタンスをキーとして `map.get()` に渡す。

```java
ComponentA compA = (ComponentA) SystemRepository.getObject("compA");
Map<?, ?> map = compA.getMapProperty();

// 文字列キーの場合
ComponentB compB_0 = (ComponentB) map.get("compB_0");

// コンポーネントキーの場合: key-component で設定したプロパティ値と一致するインスタンスを生成してキーに使用する
KeyComponent key = new KeyComponent();
key.setId("00001");
key.setLang("ja");
ComponentB compB_3 = (ComponentB) map.get(key);
// "compB_3" が取得できる
System.out.println(compB_3.getName());
```

`import`要素および`config-file`要素では`dir`属性を設定することでディレクトリに配置されたファイルを一括して読み込める。

`dir`属性には、コンポーネント設定ファイルが配置されているディレクトリからの相対パスを指定すること。例えば、コンポーネント設定ファイルが`/opt/component.xml`の場合に`/opt/environment_config`以下の設定ファイルを一括読み込みするには`dir`属性に`"./environment_config"`と設定する。

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

読み込むファイルが頻繁に変更される場合（増減やファイル名変更が発生するケース）、ディレクトリ指定で読み込む機能を使用することで、`import`タグや`config-file`タグを都度書き直す手間が抑制できる。

:ref:`reporitoy_config_override` の方法で本番用とテスト用で異なる設定を特定のディレクトリに配置し、本番環境とテスト環境の差異を吸収するといった使い方もできる。

別々の設定ファイルに記述された同名の設定は :ref:`repository_import_override_priority` および :ref:`repository_import_dir_override_priority` に記述した優先順位で評価される。

## component / property 要素

### component 要素

コンポーネントを定義する。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| property | 0..* | コンポーネントのプロパティに設定する値を指定する |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | コンポーネント名 |
| class | ○ | コンポーネントのクラス名 |
| autowireType | | 自動インジェクション方式。`ByType`（型による自動インジェクション）/`ByName`（名前による自動インジェクション）/`None`（自動インジェクションなし）。省略時は`ByType` |

### property 要素

コンポーネントのプロパティを設定する。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| component | 0..1 | プロパティに設定するコンポーネントを直接記述 |
| list | 0..1 | プロパティに設定するListを指定 |
| map | 0..1 | プロパティに設定するMapを指定 |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | プロパティ名 |
| value | | プロパティに設定する値を直接指定 |
| ref | | プロパティに設定するコンポーネントのコンポーネント名を指定 |

<details>
<summary>keywords</summary>

ConfigFileLoader, SystemRepository, ObjectLoader, getString, getBoolean, 環境設定の取得, 設定値取得, repository_get_config, list要素, map要素, component-ref, value-component, key-component, entry, ListコンポーネントのDI設定, MapコンポーネントのDI設定, コレクション型プロパティの設定, KeyComponent, コンポーネントキーによるMap取得, ComponentA, ComponentB, dir属性, import要素, config-file要素, ディレクトリ一括読み込み, ワイルドカード設定, repository_import_override_priority, repository_import_dir_override_priority, reporitoy_config_override, component, property, class, autowireType, ByType, ByName, None, ref, 自動インジェクション, DIコンテナ設定

</details>

## リポジトリに保持するインスタンスの生成(DIコンテナ) — コンポーネント登録条件とクラス例

## DIコンテナの責務

- コンポーネントをインスタンス化
- インスタンスのプロパティに設定ファイルの値を設定
- コンポーネント間を関連付け

## コンポーネント登録条件

コンポーネントとして登録するクラスは以下の2条件を満たす必要がある:

1. デフォルトコンストラクタを持つこと
2. プロパティに対応したセッタメソッドを持つこと

## コンポーネントクラスの実装例

`HelloMessageProvider`: メッセージ文字列を保持し、`getHelloMessage()`で返す。

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

`HelloComponent`: `HelloMessageProvider`を保持し、`printHello()`でメッセージをコンソール出力する。

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

`config-file` 要素を使用すると、環境設定ファイル（`.config` 形式）の設定値をコンポーネント設定ファイルから読み込める。

```xml
<config-file file="nablarch/core/repository/di/example/configfile/hello.config"/>
```

読み込んだ設定値は `SystemRepository.getString("key")` で取得できる。

```java
String helloMessage = SystemRepository.getString("hello.message");
```

DIコンテナはクラスの型を判定して自動的にインジェクションを実行する自動インジェクションの機能を持つ。システムで1つしか必要としないコンポーネントについては`property`要素によるインジェクションの設定が不要となる。

**インターフェースと実装クラスの例:**

`HelloMessageProvider`インターフェース:
```java
public interface HelloMessageProvider {
    public String getHelloMessage();
}
```

実装クラス `BasicHelloMessageProvider`:
```java
public class BasicHelloMessageProvider implements HelloMessageProvider {
    public String getHelloMessage() {
        return "Hello autowire!!";
    }
}
```

`HelloComponent`（`HelloMessageProvider`を使用するクラス）:
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

`HelloMessageProvider`インターフェースを実装した`BasicHelloMessageProvider`クラスと、`HelloMessageProvider`インターフェースを使用する`HelloComponent`クラスは、インターフェースを介して互いに疎結合（クラス間の参照関係がない）な関係にある。これらのクラスをDIコンテナにより動的に結合して使用できる。

> **注記**: 互いに疎結合な状態のまま結合できるという利点はDIコンテナの持つ特性であり、自動インジェクションを使用しない場合でもDIコンテナを使用することでこのメリットは享受できる。

**自動インジェクション設定例（`property`要素のインジェクション設定が不要）:**
```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">

    <!-- helloComponentにはインジェクションの設定をしていない -->
    <component name="helloComponent"
        class="nablarch.core.repository.di.example.autowirebytype.HelloComponent"/>

    <!-- HelloMessageProviderインタフェースを実装したクラス -->
    <component
        class="nablarch.core.repository.di.example.autowirebytype.BasicHelloMessageProvider"/>
</component-configuration>
```

**コンポーネント取得例:**
```java
HelloComponent helloComponent = (HelloComponent) container.getComponentByName("helloComponent");
// 自動インジェクションされたBasicHelloMessageProviderが返す "Hello autowire!!"が表示される
helloComponent.printHello();
```

## list / component-ref / value 要素

### list 要素

Listをコンポーネントとして定義する。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| component | 0..* | Listの要素とするコンポーネントを直接記述 |
| component-ref | 0..* | Listの要素とする、外部定義のコンポーネントを参照 |
| value | 0..* | Listの要素とする文字列を指定 |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | 登録するListのコンポーネント名 |

### component-ref 要素

Listの要素となる、他に定義したコンポーネントを指定する。子要素なし。

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | Listの要素とする、外部定義コンポーネントのコンポーネント名 |

### value 要素

Listの要素となる文字列を指定する。この要素に指定した内容がそのままListの要素となる。環境設定ファイルに記述した値の埋め込みが使用できる。属性なし。

<details>
<summary>keywords</summary>

DIコンテナ, コンポーネント登録, デフォルトコンストラクタ, セッタメソッド, HelloMessageProvider, HelloComponent, setHelloMessage, setHelloMessageProvider, config-file要素, 環境設定ファイルの読み込み, SystemRepository.getString, 設定値の取得, .configファイル, 自動インジェクション, autowire, BasicHelloMessageProvider, property要素不要, 型による自動インジェクション, getComponentByName, 疎結合, list, component-ref, value, XMLコンポーネント定義

</details>

## コンポーネント設定ファイルの記述とDIコンテナの使用例

## コンポーネント設定ファイル（XML）

- `component`要素: 登録するコンポーネントを定義。`name`属性=コンポーネント名、`class`属性=完全修飾名
- `property`要素: プロパティ設定。`name`=プロパティ名、`value`=設定値、`ref`=参照コンポーネント名

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

IDEでのXSD活用: [component-configuration.xsd](../../../knowledge/component/libraries/assets/libraries-02_01_Repository_config/component-configuration.xsd) をコンポーネント設定ファイルと同一ディレクトリに配置し`xsi:schemaLocation`を設定することで、XMLバリデーション・入力補完・コメント確認が利用できる。

## DIコンテナの直接使用例

```java
XmlComponentDefinitionLoader loader
    = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/hello/hello.xml");
DiContainer container = new DiContainer(loader);
HelloComponent helloComponent = (HelloComponent) container.getComponentByName("helloComponent");
helloComponent.printHello();
```

> **注意**: リポジトリはフレームワーク提供クラスのみをコンポーネントとして保持することを前提としており、Spring FrameworkやSeasar2といった他のDIコンテナのようにビジネスロジックやデータアクセスを行うオブジェクトの登録は想定していない。この前提により、リポジトリはこれらDIコンテナが持つレイジーロードの機能を持っていない。このため、DIコンテナにビジネスロジックやデータアクセスを行うオブジェクトを登録するとアプリケーション起動が遅くなり、ユニットテストやローカルテストの効率が悪化する。このような使用方法を行う際は、このデメリットが許容範囲にあるか十分に検討すること。

`import` 要素を使用すると、他のコンポーネント設定ファイルを読み込める。

```xml
<import file="nablarch/core/repository/di/example/imp/imported1.xml"/>
<import file="nablarch/core/repository/di/example/imp/imported2.xml"/>
```

> **注意**: 以下のブートストラップ処理は通常のアプリケーションでは実装不要。フレームワーク使用時、アプリケーション・プログラマはこのような実装を行わない。

```java
XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/imp/import.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);
```

読み込まれた各設定ファイルのコンポーネントは `SystemRepository.getObject("name")` で取得できる。

```java
HelloImport helloImport1 = (HelloImport) SystemRepository.getObject("helloImport1");
HelloImport helloImport2 = (HelloImport) SystemRepository.getObject("helloImport2");
```

コンポーネント設定ファイルの`property`要素は`component`要素をネストして記述できる。1つのコンポーネントからのみ使用されるコンポーネントを簡潔に記述できる。

ネストしたコンポーネントのコンポーネント名は「親コンポーネントの名称 + "." + コンポーネント定義の名称」となる。

**設定例:**
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

**コンポーネント取得例（ネストしたコンポーネントへのアクセス）:**
```java
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
helloComponent.printHello();

// "helloComponent.helloMessageProvider" というコンポーネント名でネストしたコンポーネントを取得できる
HelloMessageProvider helloMessageProvider = (HelloMessageProvider) SystemRepository
        .getObject("helloComponent.helloMessageProvider");
System.out.println(helloMessageProvider.getHelloMessage());
```

## map / entry / key-component / value-component 要素

### map 要素

Mapをコンポーネントとして定義する。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| entry | 0..* | Mapに含まれるEntryを定義する |

| 属性名 | 必須 | 説明 |
|---|---|---|
| name | | 登録するMapのコンポーネント名 |

### entry 要素

MapのEntryを定義する。`key`属性・`key-name`属性・`key-component`要素のいずれか1つと、`value`属性・`value-name`属性・`value-component`要素のいずれか1つを必ず指定する。

| 子要素 | 出現回数 | 説明 |
|---|---|---|
| key-component | 0..1 | Entryのキーとなるコンポーネントを直接記述 |
| value-component | 0..1 | Entryの値となるコンポーネントを直接記述 |

| 属性名 | 必須 | 説明 |
|---|---|---|
| key | | Entryのキーとなる文字列。環境設定ファイルの値埋め込み可 |
| key-name | | 外部定義コンポーネントのコンポーネント名を設定し、そのコンポーネントをEntryのキーとして指定 |
| value | | Entryの値となる文字列。環境設定ファイルの値埋め込み可 |
| value-name | | 外部定義コンポーネントのコンポーネント名を設定し、そのコンポーネントをEntryの値として指定 |

### key-component 要素

MapのEntryのキーとなるコンポーネントを定義する。component要素と同じ子要素・属性を持つ。

### value-component 要素

MapのEntryの値となるコンポーネントを定義する。component要素と同じ子要素・属性を持つ。

<details>
<summary>keywords</summary>

XmlComponentDefinitionLoader, DiContainer, component要素, property要素, コンポーネント設定ファイル, hello.xml, getComponentByName, ビジネスロジック登録, import要素, SystemRepository.load, 複数コンポーネント設定ファイルのインポート, ブートストラップ処理, HelloImport, ネストしたコンポーネント, コンポーネント名ドット記法, property要素のネスト, component要素のネスト, HelloComponent, BasicHelloMessageProvider, SystemRepository, HelloMessageProvider, map, entry, key-component, value-component, key-name, value-name

</details>

## DIコンテナを ObjectLoader として使用する

**クラス**: `DiContainer`, `SystemRepository`

`DiContainer`は`ConfigFileLoader`と同様にObjectLoaderとして`SystemRepository.load()`に渡すことで、登録コンポーネントをSystemRepositoryに登録できる。

SystemRepositoryの初期化（ブートストラップ処理）:

```java
XmlComponentDefinitionLoader loader
    = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/hello/hello.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);
```

SystemRepositoryからのコンポーネント取得:

```java
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
helloComponent.printHello();
```

環境設定ファイルは基本的にキーと値を`=`で対応付けて記述する。

**特殊文字の仕様:**

| 文字 | 説明 |
|---|---|
| `=`（デリミタ） | デリミタ文字は`=`のみ。空白（タブ含む）や`:`も文字列の一部とみなす（propertiesファイルとは異なる）。キー・値はそれぞれ前後の空白をトリミングする（例：`" A B "`は`"A B"`となる）。**キーは大文字・小文字を区別する**（`A`と`a`は別キー）。`=`で区切られた3つ目以降のトークンは無視する（`key = value = comment`の場合、値は`value`）。`=`を含めたい場合は`\=`と記述。 |
| `#`（コメント） | `#`以降の文字列はコメントとみなす。継続行中でも使用可能。`#`を含めたい場合は`\#`と記述。 |
| `\`（改行継続） | 行末に`\`を指定することで行をまたがることが可能。`\`を除いた文字列と次行先頭の空白を除いた文字列を連結する。（`\`を除いた文字列の後方の空白は維持する。） |
| `\`（エスケープ） | `\`を記述すると次の1文字を特殊文字ではなく一般文字として扱う。 |

**記述例:**
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

> **注意**: 改行文字の前にコメントを入れると設定が正しく動作しないため注意すること。以下はNG:
> ```bash
> key =   value1,     # comment \
>         value2,     # comment \
>         value3      # comment
> ```

<details>
<summary>keywords</summary>

DiContainer, SystemRepository, ObjectLoader, getObject, SystemRepositoryへのコンポーネント登録, XmlComponentDefinitionLoader, 環境設定ファイル記述ルール, デリミタ文字, コメント文字, 改行継続, エスケープ文字, キー値形式, configファイル構文, 大文字小文字区別, 3つめ以降トークン無視

</details>
