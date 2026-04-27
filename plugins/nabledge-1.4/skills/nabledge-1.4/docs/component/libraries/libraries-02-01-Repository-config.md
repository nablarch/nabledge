

## 設定ファイルの種類とフレームワークが行うリポジトリの初期化

リポジトリの設定は、文字列による設定値をプロパティファイルに似た形式で記述する、 **環境設定ファイル**
とリポジトリに保持するインスタンスを設定する **コンポーネント設定ファイル** [1] の2種類の設定ファイルで行う。

Web フレームワークやバッチフレームワーク上のアプリケーションでは、設定を読み込む処理を特別に意識する必要はなく、
単純に設定ファイルを記述するだけでリポジトリが使用できる。
これは、これらのフレームワークが起動する際にリポジトリの初期化を自動的に実行しているためである。

以下にこれらフレームワークが行うリポジトリの初期化処理の実装方法と、設定ファイルの記述方法について記述する。

「コンポーネント設定ファイル」は本章で登場する「環境設定ファイル」と区別するために
使用する用語であり、他の章では単に「設定ファイル」と記述する。

## 環境設定ファイルからの読み込み

リポジトリの内部に保持するオブジェクトはObjectLoaderで読み込む必要がある。
ObjectLoaderからリポジトリにオブジェクトを読み込む処理には、SystemRepositoryのloadメソッドを呼び出す。

ConfigFileLoaderを使用して環境設定ファイルに記述した設定を読み込み、リポジトリから設定値を取得する実装例を下記に示す。

> **Warning:**
> 以降の実装例では、 ConfigFileLoader 、 XmlComponentDefinitionLoader 、 SystemRepository 等の使用形態を明確にするために
> これらクラスを使用した初期化処理を示している。

> しかし通常のアプリケーションでは、初期化処理は Web およびバッチフレームワークのブートストラップの処理内で行われるため、
> これらブートストラップの処理の実装者以外はこのような処理の実装は必要ない。

> ここではあくまでこれらのフレームワーク外で使用する際の仕様方法を記載していることに留意すること。

### 読み込む環境設定ファイル(sample.config)の記述例

```bash
sample.value1=example-setting
sample.value2=true
```

> **Note:**
> 環境設定ファイルの記述ルールの詳細については、 [環境設定ファイル記述ルール](../../component/libraries/libraries-02-01-Repository-config.md#repository-config-loader-setting) を参照。

### 環境設定ファイルの読み込み (通常フレームワークの責務)

```java
// ******** 注意 ********
// 直下のコードはブートストラップ処理で行うべき処理であり、通常のアプリケーションでは実装する必要がない。
// 従って、本フレームワークを使用する場合、アプリケーション・プログラマはこのような実装を行わない。

ConfigFileLoader loader = new ConfigFileLoader("sample.config");
// 環境設定ファイルの内容をロード
SystemRepository.load(loader);
// 設定値を取得("example-setting"が取得できる)
```

### 環境設定の取得

環境設定の取得には、 SystemRepository クラスの getString または getBoolean メソッドを使用する。

下記に実装例を示す。

```java
String value1 = SystemRepository.getString("sample.value1");
// 設定値を取得(trueが取得できる)
boolean value2 = SystemRepository.getBoolean("sample.value2");
```

> **Warning:**
> 環境設定値を取得する際に指定するキー値には、ユーザ入力値やデータベースから取得した値を使用しないこと。
> この様なキー値を使用した場合、環境設定値が取得できないことにより、障害が発生する可能性が高くなる。
> また、設定値が取得できずに障害が発生した場合も、キー値が可変では障害解析の難易度が上がる。

> キー値を常に固定値としていた場合、仮に設定値が取得出来なかった場合でも障害発生箇所を元にしておけば、
> キー値を割り出すことが容易であるため、上記のような問題は発生しない。

## リポジトリに保持するインスタンスの生成(DIコンテナ)

リポジトリに保持するインスタンスは、DIコンテナで生成する。
DIコンテナは以下の責務を持つ。

* コンポーネントをインスタンス化する。
* インスタンスのプロパティに、コンポーネント設定ファイルに記述した値を設定する。
* コンポーネント間を関連付ける。

DIコンテナはコンポーネント設定ファイルを読み込み、コンポーネントの生成、登録を行う。
コンポーネントとして登録されるクラスは、下記2つの条件を満たしていればよい。

* クラスにデフォルトコンストラクタを持つこと
* クラスのプロパティに対応したセッタメソッドを持つこと。

画面に Hello メッセージを表示する単純な例で使用方法を説明する。
この例では、 HelloMessageProvider クラス HelloComponent クラスの2つをそれぞれコンポーネントとして登録し、これらのコンポーネントを関連付ける。
この例で使用する HelloMessageProvider クラスは、単にメッセージの文字列を保持するだけの責務を持ち、
getHelloMessage メソッドで保持したメッセージを返す。
HelloComponent クラスは、 HelloMessageProvider クラスを保持しており、 HelloMessageProvider クラスの
getHelloMessage メソッドで取得したメッセージをコンソールに画面を表示する責務を持つ。

以下に登録するクラスのソースコードを示す。

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

### コンポーネント設定ファイルの記述(hello.xml)

DIコンテナはコンポーネント設定ファイルを元にしてコンポーネントの生成を行う。
コンポーネント設定ファイルは、登録するコンポーネントを component 要素、コンポーネントのプロパティに関する設定を property 要素で記述する。

例えば、上記の HelloMessageProvider と HelloComponent の2つのクラスをコンポーネントとして登録し、
コンポーネント間を関連付ける場合、下記のようにコンポーネント設定ファイルを記述する。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">
    <!--
       HelloComponentクラスのインスタンスをコンポーネント名helloComponentで登録する設定。
       name属性にはコンポーネント名、class属性にはクラスの完全修飾名を記述する。
     -->
    <component name="helloComponent" class="nablarch.core.repository.di.example.hello.HelloComponent">
        <!--
        helloMessageProviderコンポーネントへの参照設定。
        name属性にはプロパティ名、ref属性には参照するコンポーネントのコンポーネント名を設定する。
         -->
        <property name="helloMessageProvider" ref="helloMessageProvider"/>
    </component>
    <!--
       HelloMessageProviderクラスのインスタンスをコンポーネント名helloMessageProviderで登録する設定。
       name属性にはコンポーネント名、class属性にはクラスの完全修飾名を記述する。
     -->
    <component name="helloMessageProvider"
       class="nablarch.core.repository.di.example.hello.HelloMessageProvider">
        <!--
         コンポーネントのプロパティに値を設定。
         name属性にはプロパティ名、value属性にはプロパティに設定する値を記述する。
        -->
        <property name="helloMessage" value="hello!" />
    </component>
</component-configuration>
```

コンポーネント設定ファイルの要素、属性については [コンポーネント設定ファイル 要素 リファレンス](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements) に詳細を記述する。

なお、eclipse等のIDEでは、 [component-configuration.xsd ファイル](../../../knowledge/assets/libraries-02-01-Repository-config/component-configuration.xsd)
をコンポーネント設定ファイルと同一ディレクトリに配置し、 component-configuration 要素の xsi:schemaLocation
属性を上記のように適切に設定することで、下記図のようにxsdの定義に書かれたコメントを確認しながらXMLファイルを編集できる。
この他にもXMLのバリデーションや入力補完等のメリットが得られるため、IDEを使用する際は必ず xsi:schemaLocation を
適切に設定することを推奨する。

![eclipse-xml-editing.jpg](../../../knowledge/assets/libraries-02-01-Repository-config/eclipse-xml-editing.jpg)

> **Note:**
> リポジトリは、フレームワークが提供するクラスのみをコンポーネントとして保持することを前提に設計しており、
> Spring Framework や Seasar2 といった他のDIコンテナのようにビジネスロジックやデータアクセスを行うオブジェクトを登録することを想定していない。
> この前提により、リポジトリはこれらDIコンテナが持つレイジーロードの機能を持っていない。
> このため、DIコンテナにビジネスロジックやデータアクセスを行うオブジェクトを登録する使用方法を行うと、
> アプリケーションの起動が遅くなり、ユニットテストやローカルでの画面テストの効率が悪化する。
> このような使用方法を行う際は、このデメリットが許容範囲にあるか十分に検討すること。

### 値を取得する実装例

記述したコンポーネント設定ファイルを元にしてDIコンテナを使用する手順は下記のようになる。

1. コンポーネント設定ファイル名を指定して XmlComponentDefinitionLoader のインスタンスを生成する。
2. 生成した XmlComponentDefinitionLoader のインスタンスを引数にして、DIコンテナのインスタンスを生成する。
3. 生成したDIコンテナのインスタンスからコンポーネントを取得する。

上記手順の実装例を下記に示す。

```java
// ******** 注意 ********
// 直下のコードでは、DIコンテナの動作を説明するために、DIコンテナを直接使用してコンポーネントを取得している。
// しかし通常、コンポーネントの取得は以下で説明するSystemRepository からコンポーネントを取得する方法で実装する。
// 従って、本フレームワークを使用する場合、このような実装は行わない。

XmlComponentDefinitionLoader loader
    = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/hello/hello.xml");
DiContainer container = new DiContainer(loader);

// DIコンテナで"helloComponent"と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) container.getComponentByName("helloComponent");

// HelloMessageProviderに設定した"hello"がコンソールに表示される
helloComponent.printHello();
```

## DIコンテナを ObjectLoader として使用する

前述の通り、 DiContainer は、 ConfigFileLoader と同様に ObjectLoader として使用することで、登録したコンポーネントを SystemReporitory に登録できる。
以下にDIコンテナを使用した SystemRepository の初期化処理と、リポジトリからコンポーネントを取得する実装例を示す。

### SystemRepository の初期化処理

```java
// ******** 注意 ********
// 直下のコードはブートストラップ処理で行うべき処理であり、通常のアプリケーションでは実装する必要がない。
// 従って、本フレームワークを使用する場合、アプリケーション・プログラマはこのような実装を行わない。

XmlComponentDefinitionLoader loader
    = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/hello/hello.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);
```

### SystemRepository からのコンポーネント取得

```java
// SystemRepositoryから"helloComponent"と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// HelloMessageProviderに設定した"hello"がコンソールに表示される
helloComponent.printHello();
```

## property 要素の value 属性で設定できる型

property 要素の value 属性で指定する値は、文字列の他にも、文字列による表現で値を設定できる。
この機能をプロパティの簡易設定機能と呼ぶ。

プロパティの簡易設定機能を使用して設定できるプロパティの型は下記の通り。

1. java.lang.String
2. boolean
3. java.lang.Boolean
4. int
5. java.lang.Integer
6. long
7. java.lang.Long
8. java.lang.String[]
9. int[]
10. java.lang.Integer[]

下記に使用例を示す。

### インジェクション対象のクラス

```java
public class PrimitiveValueHolder {
    private String stringValue;
    private boolean boolValue;
    private Boolean boolWrapperValue;
    private int intValue;
    private Integer intWrapperValue;
    private long longValue;
    private Long longWrapperValue;
    private String[] stringArrayValue;
    private int[] intArrayValue;
    private Integer[] integerArrayValue;

    // setter、getter省略
}
```

### コンポーネント設定ファイル

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">
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
</component-configuration>
```

上記設定により、値が設定された PrimitiveValueHolder のインスタンスが SystemRepository から取得できる。

### コンポーネントを取得する実装例

```java
// DIコンテナで"primitiveValueHolder"と名付けたコンポーネントを取得
PrimitiveValueHolder primitiveValueHolder
    = (PrimitiveValueHolder) SystemRepository.getObject("primitiveValueHolder");

// 設定した"string value"が取得できる
System.out.println(primitiveValueHolder.getStringValue());

// 設定したtrueが取得できる
System.out.println(primitiveValueHolder.isBoolValue());

// 設定したfalseが取得できる
System.out.println(primitiveValueHolder.getBoolWrapperValue());

// 設定した2が取得できる
System.out.println(primitiveValueHolder.getIntValue());

// 設定した3が取得できる
System.out.println(primitiveValueHolder.getIntWrapperValue());

// 設定した5が取得できる
System.out.println(primitiveValueHolder.getLongValue());

// 設定した6が取得できる
System.out.println(primitiveValueHolder.getLongWrapperValue());

// 設定した["abc","def","ghi"]が取得できる
for (String val : primitiveValueHolder.getStringArrayValue()) {
    System.out.println(val);
}

// 設定した[1, 2, 3]が取得できる
for (int val : primitiveValueHolder.getIntArrayValue()) {
    System.out.println(val);
}

// 設定した[4, 5, 6]が取得できる
for (Integer val : primitiveValueHolder.getIntegerArrayValue()) {
    System.out.println(val);
}
```

## List と Map をコンポーネントとして登録する

リポジトリに登録するコンポーネントの一部には、List や Map のプロパティを持たせたいことがある。
これらのプロパティに値を設定できるよう、コンポーネント設定ファイルでは List および Map をコンポーネントとして登録できる要素を提供している。

List をコンポーネントとして登録するには、 list 要素、 Map をコンポーネントとして登録するには、 map 要素を使用する。
設定の記述方法は [list 要素](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-list) および  [map 要素](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-map) を参照。

以下にそれぞれの要素の使用方法について記述する。

### list 要素の使用方法

component-configuration 要素の子要素に記述する例を以下に示す。

```xml
<component-configuration
    xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <component name="valueComponent" class="nablarch.core.repository.di.example.collection.ComponentB">
        <property name="name" value="compB_0"/>
    </component>

    <component name="compA" class="nablarch.core.repository.di.example.collection.ComponentA">
        <!-- list要素で定義した List をコンポーネントとして参照 -->
        <property name="listProperty" ref="listComponent"/>
    </component>

    <!-- list要素で List をコンポーネントとして定義 -->
    <list name="listComponent">
        <!-- コンポーネントの参照を記述 -->
        <component-ref name="valueComponent"/>
        <!-- インラインでコンポーネントを記述 -->
        <component class="nablarch.core.repository.di.example.collection.ComponentB">
            <property name="name" value="compB_1"/>
        </component>
        <!-- リストに文字列を追加 -->
        <value>String value</value>
    </list>
</component-configuration>
```

上記設定により、設定した List が取得できる。

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

### map 要素の使用方法

map 要素を component-configuration 要素の内部に記述する例を以下に示す。

```xml
<component-configuration
    xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <component name="valueComponent" class="nablarch.core.repository.di.example.collection.ComponentB">
        <property name="name" value="compB_0"/>
    </component>

    <component name="compA" class="nablarch.core.repository.di.example.collection.ComponentA">
        <property name="mapProperty" ref="mapComponent"/>
    </component>

    <map name="mapComponent">
        <!--
            エントリの定義
                キー:文字列
                値:コンポーネントの参照
         -->
        <entry key="compB_0" value-name="valueComponent">
        </entry>

        <!--
            エントリの定義
                キー:文字列
                値:インラインのコンポーネント定義
         -->
        <entry key="compB_2">
            <value-component class="nablarch.core.repository.di.example.collection.ComponentB">
                <property name="name" value="compB_2"/>
            </value-component>
        </entry>

        <!--
            エントリの定義
                キー:文字列
                値:文字列
         -->
        <entry key="stringKey" value="String value">
        </entry>

        <!--
            エントリの定義
                キー:インラインのコンポーネント定義
                値:インラインのコンポーネント定義
         -->
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
</component-configuration>
```

上記設定により、下記のように設定した Map が取得できる。

```java
ComponentA compA = (ComponentA) SystemRepository.getObject("compA");
Map<?, ?> map = compA.getMapProperty();

ComponentB compB_0 = (ComponentB) map.get("compB_0");
// "compB_0" が取得できる
System.out.println(compB_0.getName());

ComponentB compB_2 = (ComponentB) map.get("compB_2");
// "compB_2" が取得できる
System.out.println(compB_2.getName());

String stringValue = (String) map.get("stringKey");
// "String value" が取得できる
System.out.println(stringValue);

KeyComponent key = new KeyComponent();
key.setId("00001");
key.setLang("ja");
ComponentB compB_3 = (ComponentB) map.get(key);
// "compB_3" が取得できる
System.out.println(compB_3.getName());
```

## コンポーネント設定ファイルからの環境設定ファイル読み込み

コンポーネント設定ファイルには、環境設定ファイルに記述した設定値の読み込みを指定できる機能がある。
環境設定ファイルの読み込みには、 config-file 要素を使用する。

以下に例を示す。

### 読み込む環境設定ファイル(hello.config)

```bash
hello.message = This is Hello Message!!
```

### コンポーネント設定ファイル

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">

    <!-- 環境設定ファイルのロード設定 -->
    <config-file file="nablarch/core/repository/di/example/configfile/hello.config"/>
</component-configuration>
```

### 設定した値を取得する実装例

```java
// hello.configに設定した "This is Hello Message!!" が取得できる。
String helloMessage = SystemRepository.getString("hello.message");
```

## 複数のコンポーネント設定ファイルの読み込み

コンポーネント設定ファイルにimport要素を記述することで、他のコンポーネント設定ファイルを読み込むことができる。

以下に2つの設定ファイルを読み込む設定ファイルの記述例を示す。

### 読み込まれるコンポーネント設定ファイル(imported1.xml)

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration /home/ssd/workspace/Nablarch/resources/component-configuration.xsd">
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported1"/>
    </component>
</component-configuration>
```

### 読み込まれるコンポーネント設定ファイル(imported2.xml)

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration /home/ssd/workspace/Nablarch/resources/component-configuration.xsd">
    <component name="helloImport2" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported2"/>
    </component>
</component-configuration>
```

### imported1.xmlとimported2.xmlを読み込むコンポーネント設定ファイル

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    >
    <import file="nablarch/core/repository/di/example/imp/imported1.xml"/>
    <import file="nablarch/core/repository/di/example/imp/imported2.xml"/>
</component-configuration>
```

### 設定した値を取得する実装例

```java
// ******** 注意 ********
// 直下のコードはブートストラップ処理で行うべき処理であり、通常のアプリケーションでは実装する必要がない。
// 従って、本フレームワークを使用する場合、アプリケーション・プログラマはこのような実装を行わない。

// 最もrootに近い設定ファイルを読み込み
XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader("nablarch/core/repository/di/example/imp/import.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);

// imported1.xml に記述したクラスの読み込み
HelloImport helloImport1 = (HelloImport) SystemRepository.getObject("helloImport1");
// "imported1" が取得できる。
System.out.println(helloImport1.getValue());

// imported2.xml に記述したクラスの読み込み
HelloImport helloImport2 = (HelloImport) SystemRepository.getObject("helloImport2");
// "imported2" が取得できる。
System.out.println(helloImport2.getValue());
```

## 環境設定ファイルに記述した値をコンポーネント設定ファイルで使用する

コンポーネントのプロパティには、環境設定ファイルに記述した値も設定できる。
データベースへの接続設定など、環境依存する項目を、環境設定ファイルに記述することで、xmlによる設定と分離できる。

プロパティの簡易設定機能を使用するには、下記2種類の設定が必要となる。

1. 読み込む環境設定ファイルを作成する。
2. コンポーネント設定ファイルの property 要素の value 属性に指定する文字列に "${hello.message}" のように環境設定ファイルに記述したキーを${}で囲う文字列を設定する。

以下に [リポジトリに保持するインスタンスの生成(DIコンテナ)](../../component/libraries/libraries-02-01-Repository-config.md#di-container) で示した HelloMessageProvider に設定するメッセージを外部ファイルに持たせる場合の設定例を示す。

### 読み込む環境設定ファイル(hello.config)

```bash
hello.message = This is Hello Message!!
```

### コンポーネント設定ファイル

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
        <!--
        環境設定ファイルに記述した hello.message の値をプロパティhelloMessageに設定する。
         -->
        <property name="helloMessage" value="${hello.message}" />
    </component>
</component-configuration>
```

### 設定した値を取得する実装例

```java
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// XMLファイルに書いた"${hello.message}"ではなく、環境設定ファイルに設定した"This is Hello Message!!"が出力される。
helloComponent.printHello();
```

### 使用できる項目

この設定方法は、コンポーネント設定ファイルの下記に示す箇所で使用できる。

* property 要素の value 属性 ([参照](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-property))
* entry 要素の key 属性 ([参照](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-entry))
* entry 要素の value 属性 ([参照](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-entry))
* value 要素の内容 ([参照](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-value))

entry 要素および list 要素での使用例を下記に示す。

```xml
<map name="testMap">
    <entry key="[${any.key03}]" value="[${any.key04}]"/>
</map>
<list name="testList">
    <value>[${any.key05}]</value>
</list>
```

## ディレクトリに配置された設定ファイルの読み込み

import 要素および config-file 要素では、 dir 属性を設定することでディレクトリに配置されたファイルを一括して読み込める。

dir 属性には、コンポーネント設定ファイルが配置されているディレクトリからの相対パスを指定すること。
たとえば、コンポーネント設定ファイルが /opt/component.xml のパスに配置されている場合に、
/opt/environment_config ディレクトリ以下にある設定ファイルを一括して読み込む場合は、
dir 属性に "./environment_config" と設定する。

以下に設定ファイルの例を示す。

### コンポーネント設定ファイル

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

この機能を使用することで、複数拠点からリリースされた設定ファイルを1つのディレクトリに配置し、一括で読み込むことが可能となる。
例えば、個別のファイル名を指定して読み込む際、ファイル名を直接指定する設定方法を用いると、設定ファイルの増減やファイル名の変更が発生した際に都度 import タグや config-file タグを書き直す必要が出てきてしまう。
このように読み込むファイルが頻繁に変更される場合、上記例のようにディレクトリ指定で読み込む機能を使用することで、個別のファイルの読み込み設定を変更する手間が抑制できる。

また、 [設定値の上書きの対象](../../component/libraries/libraries-02-04-Repository-override.md#reporitoy-config-override)  に記述した方法で、本番用とテスト用で異なる設定を特定のディレクトリに配置して、本番環境とテスト環境の差異を吸収するといった使い方もできる。

なお、別々の設定ファイルに記述された同名の設定は  [import 要素および config-file 要素による外部ファイル読み込み時の優先順位](../../component/libraries/libraries-02-04-Repository-override.md#repository-import-override-priority)
および [dir 属性を使用した読み込み時の優先順位](../../component/libraries/libraries-02-04-Repository-override.md#repository-import-dir-override-priority)  に記述した優先順位で評価される。

## 自動インジェクション

DIコンテナは、 [リポジトリに保持するインスタンスの生成(DIコンテナ)](../../component/libraries/libraries-02-01-Repository-config.md#di-container) で記述したref属性の設定によるインジェクションの他に、クラスの型を判定して
自動的にインジェクションを実行する、自動インジェクションの機能を持つ。
この機能により、システムで1つしか必要としないコンポーネントについては property 要素によるインジェクションの設定が不要となる。

[リポジトリに保持するインスタンスの生成(DIコンテナ)](../../component/libraries/libraries-02-01-Repository-config.md#di-container) で示したサンプルの HelloMessageProvider をインタフェースと実装を下記のように分離した例を使用して、設定例を説明する。

### Helloメッセージを取得するインタフェース

```java
public interface HelloMessageProvider {
    public String getHelloMessage();
}
```

### Helloメッセージを取得するインタフェースを実装したクラス

```java
public class BasicHelloMessageProvider implements HelloMessageProvider {

    public String getHelloMessage() {
        return "Hello autowire!!";
    }
}
```

### Helloメッセージを取得するインタフェースを使用するクラス

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

HelloMessageProvider インタフェースを実装した BasicHelloMessageProvider クラスと、 HelloMessageProvider インタフェース
を使用する HelloComponent クラスは、インタフェースを介して互いに疎結合(クラス間の参照関係がない)な関係にある。
これらのクラスを下記設定を行うことで、DIコンテナにより動的に結合して使用できる。(※)

※互いに疎結合な状態のまま結合できるという利点は、DIコンテナの持つ特性であり、
自動インジェクションを使用しない場合でもDIコンテナを使用することでこのメリットは享受できる。

以下に自動インジェクションの設定例を示す。

### 設定例

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">

    <!--
        HelloComponentクラスはHelloMessageProvider型のプロパティhelloMessageProviderを持つが、
        helloComponentにはインジェクションの設定をしていない。
    -->
    <component name="helloComponent"
        class="nablarch.core.repository.di.example.autowirebytype.HelloComponent"/>

    <!-- HelloMessageProviderインタフェースを実装したクラス -->
    <component
        class="nablarch.core.repository.di.example.autowirebytype.BasicHelloMessageProvider"/>
</component-configuration>
```

上記設定例からわかる通り、自動インジェクションを使用することで、コンポーネント設定ファイルのproperty要素の記述が不要となり、
設定作業が簡略化できる。

### 設定したコンポーネントの取得例

この設定により、下記のように SystemRepository から取得した HelloComponent には、
下記のように自動的に HelloMessageProvider インタフェースを実装した BasicHelloMessageProvider が設定される。

```java
// DIコンテナで"helloComponent"と名付けたコンポーネントを取得
// HelloComponentにはHelloMessageProviderインタフェースのセッタが存在する
HelloComponent helloComponent = (HelloComponent) container.getComponentByName("helloComponent");
// 自動インジェクションされたBasicHelloMessageProviderが返す "Hello autowire!!"が表示される
helloComponent.printHello();
```

## ネストするコンポーネントの設定

コンポーネント設定ファイルの property 要素は、 component 要素をネストして記述できる。
この記述方法により、1つのコンポーネントからのみ使用されるコンポーネントを簡潔に記述できる。

ネストしたコンポーネントのコンポーネント名は、親となるコンポーネントの名称とコンポーネント定義の名称を"."で繋いだ名称となる。

以下に [自動インジェクション](../../component/libraries/libraries-02-01-Repository-config.md#--autowire) で示した例の設定を、ネストした形式で記述するコンポーネント設定ファイルの例を示す。

### コンポーネント設定ファイル

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

### 設定したコンポーネントの取得例

```java
// DIコンテナで"helloComponent"と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) SystemRepository
        .getObject("helloComponent");
// HelloMessageProviderに設定した"hello"がコンソールに表示される
helloComponent.printHello();

// helloComponent.helloMessageProvider というコンポーネント名でhelloComponentに
// ネストしたhelloMessageProviderコンポーネントが取得できる。
HelloMessageProvider helloMessageProvider = (HelloMessageProvider) SystemRepository
        .getObject("helloComponent.helloMessageProvider");

// 直接 HelloMessageProvider.getHelloMessageメソッドを呼び出す。
System.out.println(helloMessageProvider.getHelloMessage());
```

## 環境設定ファイル記述ルール

環境設定ファイルは、基本的にキーと値を '=' で対応付けて記述する。

設定の記述には、キーと値以外にコメントを記述するためや、設定値を読み易くするために特殊な意味を持つ文字を使用する。
これら特殊な意味を持つ文字について、以下に記述する。

### デリミタ文字（'='）

デリミタ文字は'='のみで、空白（タブを含む）や":"も文字列の一部とみなす。 (いわゆるpropertiesファイルとは異なる。） 但し、キー及び値はそれぞれ前後の空白（タブを含む）をトリミングする。 (" A B "(スペースAスペースBスペース)という文字列は "A B"(AスペースB)となる。キーの'A'と'a'は区別される。) デリミタ文字'='で区切られた３つめ以降のトークンは無視する。
'='をキーまたは値に含めたい場合は前に'\'を付加する。

### コメント文字（'#'）

コメント文字'#'を使用するとその行の以降の文字列はコメントとみなす。 '#'によるコメントを除去する処理は行連結の前に行われるので、 継続行中でも使用可能（下記「使用例」参照）。
'#'をキーまたは値に含めたい場合は前に'\'を付加する。

### 改行文字（'\'）

キーと値のセットは行末に'\'を指定することによって行をまたがることが可能。 その場合'\'を除いた文字列と次の行の先頭の空白（タブを含む）を除いた 文字列を連結する。（'\'を除いた文字列の後方の空白は維持する。）
キーまたは値の行末に'\'を含めたい場合は前に'\'を付加する。

### エスケープ文字（'\'）

'\'を記述すると次の１文字を特殊文字ではなく一般文字として扱う。
'\'をキーまたは値に含めたい場合は前に''を付加する。

読み込むファイルの記述例：

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

> **Note:**
> 下記のように改行文字の前にコメントを入れた場合、設定は正しく動作しないため、注意すること。

> ```bash
> # 下記はNG。
> key =   value1,     # comment \
>         value2,     # comment \
>         value3      # comment
> ```

## コンポーネント設定ファイル 要素 リファレンス

コンポーネント設定ファイルで使用できるそれぞれの要素について、以下に記述する。

### component-configuration 要素

コンポーネント設定ファイルのルート要素

この要素が持つ子要素を下記表に示す。

| 要素名 | 出現回数 | 説明 |
|---|---|---|
| [import](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-import) | 0..* | 他のコンポーネント設定ファイルの読み込みを指定する。 |
| [config-file](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-config-file) | 0..* | 環境設定ファイルの読み込みを指定する。 |
| [component](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-component) | 0..* | Java Beans 形式のクラスをコンポーネントとして定義する。 |
| [list](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-list) | 0..* | List をコンポートとして定義する。 List のエントリには、他のコンポーネントや文字列を含めることができる。 |
| [map](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-map) | 0..* | Map をコンポーネントとして定義する。 Map のエントリのキーと値には、他のコンポーネントや文字列を含めることができる。 |

この要素は属性を持たない。

### import 要素

他のコンポーネント設定ファイルの読み込みを指定する。

この要素は子要素を持たない。

この要素が持つ属性を下記表に示す。

| 属性名 | 説明 |
|---|---|
| file(必須) | インポートするファイル名を指定する。 単純にパスを記述した場合、クラスパスにあるファイルをインポートする。 "[file://](file://)" から始まるパスの場合、ローカルファイルシステム上のファイルをインポートする。 また、 dir を指定した場合には "*" を使用してワイルドカードを使用した複数ファイルのインポートが行える。 |
| dir | インポート対象のディレクトリを、本属性が記述されているコンポーネント設定ファイルからの相対パスで指定する。 この指定を行った場合、指定したディレクトリ直下のファイルがインポートされる。 |

### config-file 要素

環境設定ファイルの読み込みを指定する。

この要素は子要素を持たない。

この要素が持つ属性を下記表に示す。

| 属性名 | 説明 |
|---|---|
| file(必須) | 読み込むファイル名を指定する。 単純にパスを記述した場合、クラスパスにあるファイルを読み込む。 "[file://](file://)" から始まるパスの場合、ローカルファイルシステム上のファイルを読み込む。 また、 dir を指定した場合には "*" を使用してワイルドカードを使用した複数ファイルの読み込みが行える。 |
| dir | 読み込むファイルのディレクトリを、本属性が記述されているコンポーネント設定ファイルからの相対パスで指定する。 この指定を行った場合、指定したディレクトリ直下のファイルが読み込まれる。 |
| encoding | 環境設定ファイルの文字エンコーディングを指定する。 省略した場合、UTF-8エンコーディングが使用される。 |

### component 要素

コンポーネントを定義する。

この要素が持つ子要素を下記表に示す。

| 要素名 | 出現回数 | 説明 |
|---|---|---|
| [property](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-property) | 0..* | コンポーネントのプロパティに設定する値を指定する。 |

この要素が持つ属性を下記表に示す。

| 属性名 | 説明 |
|---|---|
| name | コンポーネント名を指定する。 |
| class(必須) | コンポーネントのクラス名を指定する。 |
| autowireType | コンポーネントに対する自動インジェクションの方法を指定する。 指定できる値は下記いずれか。  * ByType: 型による自動インジェクションを行う。 * ByName: 名前による自動インジェクションを行う。 * None: 自動インジェクションを行わない。  省略した場合、ByType。 |

### property 要素

コンポーネントのプロパティを設定する。

この要素が持つ子要素を下記表に示す。

| 要素名 | 出現回数 | 説明 |
|---|---|---|
| [component](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-component) | 0..1 | プロパティに設定するコンポーネントを指定する。 |
| [list](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-list) | 0..1 | プロパティに設定する List を指定する。 |
| [map](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-map) | 0..1 | プロパティに設定する Map を指定する。 |

この要素が持つ属性を下記表に示す。

| 属性名 | 説明 |
|---|---|
| name | プロパティ名を指定する。 |
| value | プロパティに設定する値を直接指定する。 |
| ref | プロパティに設定するコンポーネントの、コンポーネント名を指定する。 |

### list 要素

List をコンポーネントとして定義する。

この要素が持つ子要素を下記表に示す。

| 要素名 | 出現回数 | 説明 |
|---|---|---|
| [component](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-component) | 0..* | List の要素とするコンポーネントを直接記述する。 |
| [component-ref](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-component-ref) | 0..* | List の要素とする、この要素の外で定義したコンポーネントを指定する。 |
| [value](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-value) | 0..* | List の要素とする文字列を指定する。 |

この要素が持つ属性を下記表に示す。

| 属性名 | 説明 |
|---|---|
| name | 登録する List のコンポーネント名。 |

### component-ref 要素

List の要素となる、他に定義したコンポーネントを指定する。

この要素は子要素を持たない。

この要素が持つ属性を下記表に示す。

| 属性名 | 説明 |
|---|---|
| name | List の要素とする、この要素の外で定義したコンポーネントのコンポーネント名を指定する。 |

### value 要素

List の要素となる文字列を指定する。
この要素に指定した内容が、そのまま List の要素となる。

文字列には、環境設定ファイルに記述した値の埋め込み機能が使用できる。
埋め込みの方法は [環境設定ファイルに記述した値をコンポーネント設定ファイルで使用する](../../component/libraries/libraries-02-01-Repository-config.md#repository-use-env-value-at-component-setting) を参照。

この要素は属性を持たない。

### map 要素

Map をコンポーネントとして定義する。

この要素が持つ子要素を下記表に示す。

| 要素名 | 出現回数 | 説明 |
|---|---|---|
| [entry](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-entry) | 0..* | Map に含まれる Entry を定義する。 |

この要素が持つ属性を下記表に示す。

| 属性名 | 説明 |
|---|---|
| name | 登録する Map のコンポーネント名。 |

### entry 要素

Map の Entry を定義する。

この要素には、 key属性、key-name属性、key-component要素、 のいずれか1つと value属性、value-name属性、value-component要素 のいずれか1つを必ず指定する。

この要素が持つ子要素を下記表に示す。

| 要素名 | 出現回数 | 説明 |
|---|---|---|
| [key-component](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-key-component) | 0..1 | Entry のキーとなるコンポーネントを直接記述する。 |
| [value-component](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-value-component) | 0..1 | Entry の値となるコンポーネントを直接記述する。 |

この要素が持つ属性を下記表に示す。

| 属性名 | 説明 |
|---|---|
| key | Entry のキーとなる文字列を直接記述する。 文字列には、環境設定ファイルに記述した値の埋め込み機能が使用できる。 埋め込みの方法は [環境設定ファイルに記述した値をコンポーネント設定ファイルで使用する](../../component/libraries/libraries-02-01-Repository-config.md#repository-use-env-value-at-component-setting) を参照。 |
| key-name | 要素の外で定義したコンポーネントのコンポーネント名を設定し、 そのコンポーネントを Entry のキーとして指定する。 |
| value | Entry の値となる文字列を直接記述する。 文字列には、環境設定ファイルに記述した値の埋め込み機能が使用できる。 埋め込みの方法は [環境設定ファイルに記述した値をコンポーネント設定ファイルで使用する](../../component/libraries/libraries-02-01-Repository-config.md#repository-use-env-value-at-component-setting) を参照。 |
| value-name | 要素の外で定義したコンポーネントのコンポーネント名を設定し、 そのコンポーネントを Entry の値として指定する。 |

### key-component 要素

Map の Entry のキーとなるコンポーネントを定義する。

この要素は、 [component](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-component) と同じ子要素、属性を持つ。

### value-component 要素

Map の Entry の値となるコンポーネントを定義する。

この要素は、 [component](../../component/libraries/libraries-02-01-Repository-config.md#repository-elements-component) と同じ子要素、属性を持つ。
