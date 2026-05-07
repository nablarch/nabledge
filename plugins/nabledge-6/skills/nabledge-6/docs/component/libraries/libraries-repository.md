# システムリポジトリ

**目次**

* 機能概要

  * DIコンテナによるオブジェクトの構築ができる
  * オブジェクトの初期化ができる
* モジュール一覧
* 使用方法

  * xmlにルートノードを定義する
  * Java Beansオブジェクトを設定する
  * Java Beansオブジェクトの設定を上書きする
  * 文字列や数値、真偽値を設定値として使う
  * ListやMapを設定値として使う
  * コンポーネントを自動的にインジェクションする
  * コンポーネント設定ファイル(xml)を分割する
  * 依存値を設定する
  * コンポーネント設定ファイルから環境依存値を参照する
  * システムプロパティを使って環境依存値を上書きする
  * OS環境変数を使って環境依存値を上書きする
  * ファクトリクラスで生成したオブジェクトをインジェクションする
  * アノテーションを付与したクラスのオブジェクトを構築する

    * 使用方法
    * コンストラクタインジェクションを使用する
    * ActionクラスをDIコンテナで管理する
  * オブジェクトの初期化処理を行う
  * オブジェクトの廃棄処理を行う
  * DIコンテナの情報をシステムリポジトリに設定する
  * システムリポジトリからオブジェクトを取得する
* 環境設定ファイルの記述ルール

アプリケーションを実装する際に様々な箇所で使用されるオブジェクトや、設定値などを管理する機能を提供する。

この機能では、以下の事ができる。

* 環境毎に異なる可能性のあるロジック(生成されるクラスやプロパティの値)を、 外部ファイルに定義できる。
* 外部ファイルの定義を元に、オブジェクト間の関連を構築できる。(DIコンテナ機能を持つ)

## 機能概要

### DIコンテナによるオブジェクトの構築ができる

DIコンテナ機能を使うことで、 [xml](../../component/libraries/libraries-repository.md#xmlにルートノードを定義する) に定義されたコンポーネントの定義または
[アノテーションを付与したクラス](../../component/libraries/libraries-repository.md#アノテーションを付与したクラスのオブジェクトを構築する) を元にオブジェクトを構築できる。
構築されるオブジェクトは **シングルトン** となる。

DIコンテナ機能では、以下のことができる。

* [setterインジェクションができる。](../../component/libraries/libraries-repository.md#java-beansオブジェクトを設定する)
* [文字列や数値、真偽値を使用できる。](../../component/libraries/libraries-repository.md#文字列や数値真偽値を設定値として使う)
* [ListやMapをインジェクションできる。](../../component/libraries/libraries-repository.md#listやmapを設定値として使う)
* [型や名前が一致するsetterへの自動インジェクションができる。](../../component/libraries/libraries-repository.md#コンポーネントを自動的にインジェクションする)
* [ファクトリインジェクションができる。](../../component/libraries/libraries-repository.md#ファクトリクラスで生成したオブジェクトをインジェクションする)
* [アノテーションを付与したクラスのオブジェクトが構築できる。](../../component/libraries/libraries-repository.md#アノテーションを付与したクラスのオブジェクトを構築する)
* [環境依存値を管理できる。](../../component/libraries/libraries-repository.md#依存値を設定する)

アプリケーションからはDIコンテナに直接アクセスするのではなく、システムリポジトリ経由でアクセスする。
詳細は、 [DIコンテナの情報をシステムリポジトリに設定する](../../component/libraries/libraries-repository.md#diコンテナの情報をシステムリポジトリに設定する) を参照。

### オブジェクトの初期化ができる

オブジェクト構築後に任意の初期化処理を実行できる。

オブジェクトの依存関係によっては、初期化順に制約が発生することが考えられるため、
この機能ではオブジェクトの初期化順が指定できる。

詳細は、 [オブジェクトの初期化処理を行う](../../component/libraries/libraries-repository.md#オブジェクトの初期化処理を行う) を参照。

## モジュール一覧

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

## 使用方法

### xmlにルートノードを定義する

コンポーネント設定ファイル(xml)のルートノードは、 component-configuration とする。
schemaLocation を正しく設定すると、IDEで各要素や属性のドキュメントが参照できたり、補完機能が有効活用できる。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration /component-configuration.xsd">

</component-configuration>
```

xmlへのコンポーネント定義方法の詳細は、以下を参照。

* [Java Beansオブジェクトを設定する](../../component/libraries/libraries-repository.md#java-beansオブジェクトを設定する)
* [Java Beansオブジェクトの設定を上書きする](../../component/libraries/libraries-repository.md#java-beansオブジェクトの設定を上書きする)
* [文字列や数値、真偽値を設定値として使う](../../component/libraries/libraries-repository.md#文字列や数値真偽値を設定値として使う)
* [ListやMapを設定値として使う](../../component/libraries/libraries-repository.md#listやmapを設定値として使う)
* [コンポーネントを自動的にインジェクションする](../../component/libraries/libraries-repository.md#コンポーネントを自動的にインジェクションする)
* [依存値を設定する](../../component/libraries/libraries-repository.md#依存値を設定する)
* [コンポーネント設定ファイルから環境依存値を参照する](../../component/libraries/libraries-repository.md#コンポーネント設定ファイルから環境依存値を参照する)
* [ファクトリクラスで生成したオブジェクトをインジェクションする](../../component/libraries/libraries-repository.md#ファクトリクラスで生成したオブジェクトをインジェクションする)
* [オブジェクトの初期化処理を行う](../../component/libraries/libraries-repository.md#オブジェクトの初期化処理を行う)
* [コンポーネント設定ファイル(xml)を分割する](../../component/libraries/libraries-repository.md#コンポーネント設定ファイルxmlを分割する)

### Java Beansオブジェクトを設定する

Java Beansオブジェクトは、component要素を用いて定義する。

* class属性にDIコンテナで管理するクラスのFQCNを設定する。
* name属性を使って任意の名前を設定できる。
* property子要素を使って、setterインジェクションができる。
* propertyの子要素にcomponentを定義できる。
* propertyのref属性を使って、他で定義したcomponentをsetterインジェクションできる。

以下に例を示す。

```xml
<!-- component要素を使ってJava Beansオブジェクトを設定する -->
<component name="sample" class="sample.SampleBean" />

<component name="component" class="sample.SampleComponent">
  <!--
   property要素を使ってsetterインジェクションを行う
   この例では、sampleという名前でcomponent定義されたオブジェクトがインジェクションされる
   -->
  <property name="sample" ref="sample" />

  <!-- ref属性を使わずに、propertyの子要素にcomponentを定義することもできる -->
  <property name="obj">
    <component class="sample.SampleObject" />
  </property>

  <!-- リテラル値をsetterインジェクションする -->
  <property name="limit" value="100" />
</component>
```

> **Important:**
> 生成されるインスタンスはシングルトンとなる。このため、以下の点に注意すること。

> * >   インスタンスはシングルトンとなるため、取得の度に生成されるのではない（プロトタイプでない）。
> * >   アプリケーションが終了するまでインスタンスは破棄されない。

> この理解を誤ると、深刻な不具合を埋め込むこととなるので特に注意が必要である。
> 例えば、生成されるインスタンスをプロトタイプと勘違いした場合、あるリクエストでユーザAの入力値をコンポーネントに設定し、
> 別のユーザBのリクエストでその値を使用してしまう、というような重大な不具合を起こす可能性がある。

> 意図的にアプリケーション全体でコンポーネントの状態を変更、共有する場合は、そのコンポーネントはスレッドセーフでなければならない。

> **Tip:**
> オブジェクトはcomponent要素単位にインスタンスが生成される。例えば、以下のように2箇所でcomponentを定義した場合別々のインスタンスが生成される。

> ```xml
> <!-- SampleBeanのインスタンスが2つリポジトリに登録される -->
> <component name="sample1" class="sample.SampleBean" />
> <component name="sample2" class="sample.SampleBean" />
> ```

> **Tip:**
> ネストして定義したcomponentについても、リポジトリ上はグローバル領域に保持されるため、名前を指定してオブジェクトを取得できる。
> オブジェクトの取得方法は、 [システムリポジトリからオブジェクトを取得する](../../component/libraries/libraries-repository.md#システムリポジトリからオブジェクトを取得する) を参照。

> **Tip:**
> staticなプロパティ(staticなsetterメソッド)に対するインジェクションは行われない。
> インジェクション対象となるプロパティがstaticであった場合には、DIコンテナの構築時に例外が送出される。

### Java Beansオブジェクトの設定を上書きする

componentタグのname属性が同じオブジェクトを登録することで、前に読み込まれたオブジェクトの設定を上書きできる。
この機能は、テスト時にプロダクション環境用のオブジェクトをテスト用のオブジェクト(モック)に置き換える際に使用できる。

オブジェクトを上書きする場合は、同じ名前のオブジェクトを登録するだけで自動的に後で読み込まれたオブジェクトが優先される。

以下に例を示す。

```xml
<component name="sample" class="sample.SampleBean">
  <property name="prop" value="message" />
</component>

<!-- 同じ名前でコンポーネントを定義して上書きする -->
<component name="sample" class="sample.MockSampleBean" />
```

> **Important:**
> 上の例のように異なるクラスを設定すると、上書き前のpropertyへの設定は全て破棄される。
> これは、同じインタフェースを実装していても、同じpropertyを持っているとは限らないためである。

> ただし、同じクラスを設定した場合、上書き前のpropertyへの設定が上書き後のクラスに全て引き継がれる。
> このため、上書き後の設定で特定propertyへの設定は削除できない。
> 例えば、以下の様な上書き設定をした場合、上書き後の設定にはproperty要素は存在していないが、
> 上書き前のpropの値が引き継がれるため、propにはmessageが設定された状態となる。

> ```xml
> <component name="sample" class="sample.SampleBean">
>   <property name="prop" value="message" />
> </component>
> 
> <!--
> propertyを設定していないが、上書き前のpropの値が引き継がれる
>  -->
> <component name="sample" class="sample.SampleBean" />
> ```

### 文字列や数値、真偽値を設定値として使う

プロパティの型が以下の型の場合、リテラル表記で値を簡易的に設定できる。

* java.lang.String
* java.lang.String[]
* java.lang.Integer(int)
* java.lang.Integer[](int[])
* java.lang.Long(long)
* java.lang.Boolean(boolean)

以下に設定例を示す。

java.lang.String

java.lang.String型に値を設定する場合、value属性にリテラルで設定する値を記述する。

この例では、strプロパティに対して「あいうえお」が設定される。

```xml
<property name="str" value="あいうえお" />
```

java.lang.String[]

java.lang.String[]型に値を設定する場合、value属性に値をカンマ(,)区切りで設定する。
カンマで区切られた値が、配列の1つの要素となる。

この例では、arrayプロパティに対して「[あ, い, う, え, お]」が設定される。
なお、区切り文字である `,` は要素として設定できない。

```xml
<property name="array" value="あ,い,う,え,お" />
```

java.lang.Integer(int)

java.lang.Integer型及びint型に値を設定する場合、value属性に設定する値を記述する。
設定できる値は、 Integer#valueOf により変換できる値。

この例では、Integer(int)型のnumプロパティに対して「12345」が設定される。

```xml
<property name="num" value="12345" />
```

java.lang.Integer[](int[])

java.lang.String[]と同じように、value属性に値をカンマ(,)区切りで設定する。
各要素に設定できる値は、 Integer#valueOf により変換できる値。

java.lang.Long(long)

java.lang.Integer(int)と同じように、value属性に設定する値を記述する。
設定できる値は、 Long#valueOf により変換できる値。

java.lang.Boolean(boolean)

java.lang.Boolean型に値を設定する場合、value属性にリテラルで設定する値を記述する。
設定できる値は、 Boolean#valueOf により変換できる値。

この例では、Boolean(boolean)型のboolプロパティに対して「true」が設定される。

```xml
<property name="bool" value="true" />
```

### ListやMapを設定値として使う

list要素やmap要素を使ってコンポーネント設定をすることで、ListやMapを受け取るpropertyに対するsetterインジェクションが行える。

list要素を使ったListの設定

list要素には、文字列または任意のJava Beansオブジェクトを設定できる。

この例では、SampleBeanのstringListプロパティに対して、[string1, string2, string3]を持つ文字列のListが設定される。

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

list要素にも任意の名前を設定でき、property要素で名前参照ができる。
この例は、上の例と同じ設定となる。

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

この例では、handlersプロパティに対して、 SampleHandler1 、 SampleHandler2 、 SampleHandler3 を持つJava BeansオブジェクトのListが設定される。
なお、下の例にもあるがcomponent-ref要素を使用することで、名前参照ができる。

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

map要素を使ったMapの設定

この例では、mapプロパティに対してentryに「{key1=1, key2=2, key3=3}」を持つMapが設定される。

```xml
<property name="map">
  <map>
    <entry key="key1" value="1" />
    <entry key="key2" value="2" />
    <entry key="key3" value="3" />
  </map>
</property>
```

mapにも任意の名前を設定でき、property要素で名前参照ができる。
この例は、上の例と同じ設定となる。

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

value-component要素を使用することで、Mapの値として任意のBeanも設定できる。

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

> **Important:**
> mapやlistのname属性が同じものを複数定義した場合は、先に定義されたものが有効となる。
> これは、 [beanの上書き](../../component/libraries/libraries-repository.md#java-beansオブジェクトの設定を上書きする) と異なる挙動であるため注意すること。

> もし、環境毎にmapやlistの情報を変更したい場合には、環境毎読み込むファイルを変えることで対応すること。

### コンポーネントを自動的にインジェクションする

コンポーネントのpropertyタグの定義を省略した場合でも、自動的にコンポーネントをインジェクションする機能を提供する。
この機能ではcomponent要素のautowireType属性を使用することで、自動インジェクションタイプを指定できる。

> **Important:**
> 自動インジェクション機能を使用すると以下の問題があるため、autowireType属性には明示的に None を指定することを推奨する。

> * >   最終的に生成されるオブジェクトの状態が、コンポーネント設定ファイル(xml)から読み取れない。
> * >   任意項目のプロパティ定義を省略した場合に、想定していないオブジェクトが自動的にインジェクションされてしまう可能性がある。
> * >   型による自動インジェクションを使用し、派生開発で同一の型のオブジェクトの設定が増えた場合、
>   propertyの定義が必要になるためメンテナンス性が悪い。

autowireType属性に指定可能なタイプは以下の通り。

ByType

DIコンテナ上にそのプロパティの型が1つしか存在しない場合に、そのコンポーネントを自動的にインジェクションする。
デフォルトではこのタイプが使用される。

ByName

プロパティ名と一致する名称のコンポーネントが存在する場合に、そのコンポーネントを自動的にインジェクションする。
なお、プロパティとコンポーネントの型が一致しない場合はエラーとなる。

None

自動インジェクションを行わない。

デフォルト(ByType)の設定で自動インジェクションする例を以下に示す。

インジェクション対象のクラスを作成する

インジェクション対象のインタフェース及び実装クラスを作成する。
この例では、インタフェースを作成しているが、インタフェースの作成は必須ではない。

```java
public interface SampleComponent {
}

public class BasicSampleComponent implements SampleComponent {
}
```

インジェクション対象のオブジェクトを使用するクラスを作成する

上記で作成したクラスを使って処理を行うクラスを作成する。
このクラスは、setterインジェクションで上記のクラスを受け取る。

```java
public class SampleClient {
  private SampleComponent component;

  public void setSampleComponent(SampleComponent component) {
    this.component = component;
  }
}
```

コンポーネント設定ファイルにコンポーネントを定義する

この例では、 SampleClient に sampleComponent propertyを定義していないが、 SampleComponent を実装したクラスの設定が1つだけなので、
sampleComponent propertyには自動的に BasicSampleComponent が設定される。

```xml
<component name="sampleComponent" class="sample.BasicSampleComponent" />

<component name="sampleClient" class="sample.SampleClient" />
```

上記の設定は、以下のように明示的にpropertyを定義した場合と同じ動作となる。

```xml
<component name="sampleComponent" class="sample.BasicSampleComponent" />

<component name="sampleClient" class="sample.SampleClient">
  <property name="sampleComponent" ref="sampleComponent" />
</component>
```

### コンポーネント設定ファイル(xml)を分割する

全ての定義を1つのコンポーネント設定ファイルに定義するとxmlが巨大となり、メンテナンス性が悪くなる問題がある。
このため、xmlファイルを複数ファイルに分割できる機能を提供している。

xmlファイルを分割する際には、機能単位などある程度の粒度でファイルを分割すると良い。
分割したxmlファイルは、import要素で読み込む事ができる。

以下に例を示す。

この例では、3つのxmlファイルがロードされる。

```xml
<import file="library/database.xml" />
<import file="library/validation.xml" />
<import file="handler/multipart.xml" />
```

### 依存値を設定する

テスト環境や本番環境で異なる値(データベースの接続情報やディレクトリのパスなど)は、環境設定ファイルで管理できる。

環境設定ファイルは、以下のようにシンプルなkey-value形式で記述する。
詳細な記述ルールは、 [環境設定ファイルの記述ルール](../../component/libraries/libraries-repository.md#環境設定ファイルの記述ルール) を参照。

```bash
database.url = jdbc:h2:mem:sample
database.user = sa
database.password = sa
```

> **Important:**
> 環境設定値のキー値が重複していた場合、後に定義されたものが有効となるため注意すること。

以下に例を示す。

環境依存値

```bash
database.url = jdbc:h2:mem:sample
database.user = sa
database.password = sa
```

### コンポーネント設定ファイルから環境依存値を参照する

コンポーネント設定ファイル(xml)から環境設定ファイルを読み込み、Java Beansオブジェクトの設定値として使用できる。

DIコンテナで管理するオブジェクトに対して環境依存値を設定(インジェクション)する場合は、
コンポーネント設定ファイルに環境依存値のキー値を `${` と `}` で囲んで記述する。

なお、この記法を環境設定ファイルでは使用できない。(環境設定ファイル内では、他の環境依存値は参照できない。)

以下に例を示す。

環境設定ファイル

```bash
database.url = jdbc:h2:mem:sample
database.user = sa
database.password = sa
```

コンポーネント設定ファイル

環境設定ファイルを読み込む場合には、config-file要素を使用する。
この例のようにファイル名指定で読み込んだり、特定ディレクトリ配下のファイルを一括で読み込むことができる。

上記の環境設定ファイルの名前が「database.properties」の場合、 JdbcDataSource の url には、「jdbc:h2:mem:sample」が設定される。

```xml
<!-- database.propertiesファイルの読み込み -->
<config-file file="database.properties" />

<component class="org.h2.jdbcx.JdbcDataSource">
  <property name="url" value="${database.url}" />
</component>
```

環境設定ファイルにはconfigファイルとpropertiesファイルの二種類があり、configファイルはNablarchの独自仕様によりパースされ、
propertiesファイルはjava.util.Propertiesによりパースされる。configファイルはNablarchの独自仕様であることから
環境設定ファイルにはpropertiesファイルを推奨する。

環境設定ファイルの仕様は、 [環境設定ファイルの記述ルール](../../component/libraries/libraries-repository.md#環境設定ファイルの記述ルール) を参照。

> **Important:**
> 環境設定ファイルで定義されていない環境依存値のキーをコンポーネント設定ファイルに記載した場合、ConfigurationLoadExceptionが送出される。

### システムプロパティを使って環境依存値を上書きする

環境依存値は、システムプロパティ( java.lang.System#getProperties() で取得できる値)で上書きできる。
システムプロパティは、環境設定ファイルに設定した値より優先されるため、vmオプションで容易に設定値を上書きできる。

例えば、特定のバッチアプリケーションだけ設定値を変えたいといった場合に、システムプロパティを使用して環境依存値を上書きするといったことができる。

以下に例を示す。

環境設定ファイル

```bash
message=上書きされるメッセージ
```

システムプロパティで値を上書きする

javaコマンドの `-D` オプションでシステムプロパティを設定することで、環境設定ファイルの値を上書きできる。
この例の場合、 message の値は「上書きするメッセージ」となる。

java -Dmessage=上書きするメッセージ

### OS環境変数を使って環境依存値を上書きする

以下の説明に沿って設定することで、環境依存値をOS環境変数で上書きできるようになる。

OS環境変数による上書きを有効にするための設定方法

環境依存値を上書きする仕組みは、 ExternalizedComponentDefinitionLoader インタフェースを実装したクラスによって実現されている。

この実装クラスは、 `java.util.ServiceLoader` を使ってロードされる。
サービスプロバイダを何も設定していない場合は、デフォルトで SystemPropertyExternalizedLoader が使用される。
このクラスはシステムプロパティで上書きするクラスとなっており、前節で説明したシステムプロパティによる上書きはこのクラスによって実現されている。

OS環境変数で環境依存値を上書きする場合は、実装クラスとして OsEnvironmentVariableExternalizedLoader を使用する。

具体的な設定は、次のようにして行う。

1. クラスパス直下に `META-INF/services` というディレクトリを作成する
2. 上で作成したディレクトリの中に、 `nablarch.core.repository.di.config.externalize.ExternalizedComponentDefinitionLoader` という名前のテキストファイルを作成する
3. ファイルの中に、使用する実装クラスの完全修飾名を改行区切りで列挙する

例えば、 OsEnvironmentVariableExternalizedLoader を使用する場合は、 `nablarch.core.repository.di.config.externalize.ExternalizedComponentDefinitionLoader` の中身を以下のように記述する。

```text
nablarch.core.repository.di.config.externalize.OsEnvironmentVariableExternalizedLoader
```

複数の実装クラスを組み合わせる場合は、以下のように改行区切りで列挙できる。

```text
nablarch.core.repository.di.config.externalize.OsEnvironmentVariableExternalizedLoader
nablarch.core.repository.di.config.externalize.SystemPropertyExternalizedLoader
```

複数の実装クラスを指定した場合は、上から順番に上書きが行われる。
したがって、同じ名前の環境依存値をそれぞれの方法で上書きした場合は、一番下に記述したクラスによる上書きが最終的に採用されることになる。
上記例の場合は、OS環境変数で設定した値よりもシステムプロパティで設定した値の方が優先されることになる。

OS環境変数の名前について

Linuxでは、OS環境変数の名前に `.` や `-` を使用できない。
したがって、 `example.error-message` のような名前の環境依存値があった場合に、これを上書きするためのOS環境変数をそのままの名前で定義できない。

Nablarchではこの問題を回避するために、環境依存値の名前を以下のとおり変換したうえでOS環境変数を検索するようにしている。

1. `.` と `-` を `_` に置換する
2. アルファベットを大文字に変換する

つまり、 `example.error-message` という名前の環境依存値は、 `EXAMPLE_ERROR_MESSAGE` という名前でOS環境変数を定義することで上書きできる。

Windows ではOS環境変数に `.` や `-` を使用できるが、上記変換処理は実行時のOSに関係なく行っている。
したがって、 `example.error-message` を上書きするためのOS環境変数は、Windowsでも `EXAMPLE_ERROR_MESSAGE` という名前で定義しなければならない。

### ファクトリクラスで生成したオブジェクトをインジェクションする

Java Beansとして実装されているクラスであれば、setterインジェクションを使用して値を設定しオブジェクトを生成できる。
しかし、ベンダー提供やOSSなどのJava Beansとして実装されていないオブジェクトをシステムリポジトリで管理したい場合がある。

この場合は、ファクトリクラスを作成しファクトリクラス経由でオブジェクトを生成することで、これらのクラスをシステムリポジトリで管理できるようになる。

以下に手順を示す。

ファクトリクラスを作成する

ファクトリクラスは、 ComponentFactory インタフェースを実装し作成する。

実装例

```java
public class SampleComponentFactory implements ComponentFactory<SampleComponent> {
  // 生成するオブジェクトへの設定値
  private String configValue;

  public void setConfigValue(String configValue) {
    this.configValue = configValue;
  }

  public SampleComponent createObject() {
    // オブジェクトを生成する。
    // この例では、このクラスにsetterインジェクションした値を使ってオブジェクトを生成する。
    return new SampleComponent(configValue);
  }
}
```

コンポーネント設定ファイルにファクトリクラスを設定する

ファクトリクラスを通常のコンポーネントと同じように設定することで、
自動的にファクトリクラスが生成したオブジェクトが設定される。

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

> **Important:**
> Nablarchではファクトリクラスの入れ子に対応していない。
> つまり、ファクトリクラスのプロパティに他のファクトリクラスを指定できない。

> ```xml
> <component name="sampleComponent" class="sample.SampleComponentFactory">
>   <!-- ファクトリクラスの入れ子 -->
>   <property name="property">
>     <component class="sample.OtherSampleComponentFactory">
>   </property>
> </component>
> ```

> この場合は、1つのファクトリクラス内で入れ子のファクトリクラスで構築するオブジェクトも含めてオブジェクトを構築するか、
> 入れ子のファクトリクラスで構築するオブジェクトを生成するCreator/Builder/Providerといったクラスを作成し、
> コンポーネントとしてインジェクションすることで対応すること。

### アノテーションを付与したクラスのオブジェクトを構築する

SystemRepositoryComponent を
クラスに付与することで、 [XMLに設定](../../component/libraries/libraries-repository.md#java-beansオブジェクトを設定する) を書かなくともDIコンテナの管理対象にできる。

> **Important:**
> 本機能は、クラスパス配下のリソースを独自のファイルシステムで管理している一部のウェブアプリケーションサーバでは使用できない。

> 例えば、JbossやWildflyでは、vfsと呼ばれるバーチャルファイルシステムで
> クラスパス配下のリソースが管理されるため、 `SystemRepositoryComponent` アノテーションで注釈されたクラスの検索ができない。

> そのようなウェブアプリケーションサーバを使用する場合は、コンポーネントの定義は従来通り [XMLに定義](../../component/libraries/libraries-repository.md#java-beansオブジェクトを設定する) すること。

#### 使用方法

収集対象のパッケージを特定するクラスを作成する。

SystemRepositoryComponent が付与された
クラスの収集は ExternalizedComponentDefinitionLoader インタフェースを実装したクラスで行っている。
このクラスは AnnotationComponentDefinitionLoader という抽象クラスで、収集対象の基点となるパッケージを返す
getBasePackage という抽象メソッドを持っている。

各プロジェクトのパッケージ名に合わせて収集が行われるよう上記の抽象メソッドをオーバーライドする。

```java
public class ExampleComponentDefinitionLoader extends AnnotationComponentDefinitionLoader {
    @Override
    protected String getBasePackage() {
        return "com.example";
    }
}
```

作成したクラスをサービスプロバイダとして設定する。

`java.util.ServiceLoader` でロードされるよう [OS環境変数による上書きを有効にするための設定方法](../../component/libraries/libraries-repository.md#os環境変数を使って環境依存値を上書きする) と同様
`nablarch.core.repository.di.config.externalize.ExternalizedComponentDefinitionLoader` というファイルを作成し上記のクラスの完全修飾名を記述する。

DIコンテナで管理したいクラスにアノテーションを付与する。

SystemRepositoryComponent を付与することでDIコンテナで管理される。

```java
@SystemRepositoryComponent
public class ExampleAction {
```

#### コンストラクタインジェクションを使用する

SystemRepositoryComponent が付与されたクラスは構築時に以下の条件を満たすことでコンストラクタインジェクションが実行される。

* コンストラクタが1つだけ定義されている
* コンストラクタが引数をもつ

条件を満たす場合、以下の仕様でインジェクションされる。

* ConfigValue が付与されている引数には設定値がインジェクションされる
* ComponentRef が付与されている引数にはDIコンテナに登録されたコンポーネントがインジェクションされる
* 上記いずれのアノテーションも付与されていない場合は

  * 引数の型に一致するコンポーネントがDIコンテナ上に1つしか存在しない場合は、そのコンポーネントを自動的にインジェクションする
  * 引数の型に一致するコンポーネントがDIコンテナ上に存在しないまたは複数存在する場合は、何もインジェクションしない

設定値をインジェクションする

コンストラクタ引数に ConfigValue を
付与することでアノテーションの `value` に設定した値がインジェクションされる。
使用可能な設定値の型は [文字列や数値、真偽値を設定値として使う](../../component/libraries/libraries-repository.md#文字列や数値真偽値を設定値として使う) に準ずる。

[コンポーネント設定ファイルから環境依存値を参照する](../../component/libraries/libraries-repository.md#コンポーネント設定ファイルから環境依存値を参照する) 場合同様
環境依存値のキー値を `${` と `}` で囲んで記述できる。

```java
@SystemRepositoryComponent
public class ExampleService {

    private final String errorMessageId;

    public ExampleService(@ConfigValue("${example.service.errorMessageId}") String errorMessageId) {
        this.errorMessageId = errorMessageId;
    }
```

コンポーネントをインジェクションする

コンストラクタ引数に ComponentRef を
付与することでアノテーションの `value` に設定した名前のコンポーネントがインジェクションされる。

以下の例では `lettuceRedisClientProvider` という名前で定義されたコンポーネントがインジェクションされる。

```java
@SystemRepositoryComponent
public class ExampleService {

  private LettuceRedisClient client;

  public ExampleService(@ComponentRef("lettuceRedisClientProvider") LettuceRedisClient client) {
      this.client = client;
  }
```

> **Tip:**
> コンストラクタインジェクションは ConstructorInjectionComponentCreator というクラスで実現している。
> `AnnotationComponentDefinitionLoader` の newComponentCreator
> をオーバーライドすることで、アノテーションを付与したクラスのオブジェクト構築時に任意の処理を行う ComponentCreator 実装に差し替えることができる。

> ```java
> public class ExampleComponentDefinitionLoader extends AnnotationComponentDefinitionLoader {
>   @Override
>   protected String getBasePackage() {
>       return "com.example";
>   }
> 
>   @Override
>   protected ComponentCreator newComponentCreator() {
>     // 任意のComponentCreator実装クラスに変更する。
>     return new ExampleComponentCreator();
>   }
> }
> ```

#### ActionクラスをDIコンテナで管理する

アノテーションをActionクラスに付与することでDIコンテナで管理可能となる。
Nablarchで用意されたディスパッチハンドラ（ [ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#ルーティングアダプタ) 、 [リクエストディスパッチハンドラ](../../component/handlers/handlers-request-path-java-package-mapping.md#リクエストディスパッチハンドラ) 、
[HTTPリクエストディスパッチハンドラ](../../component/handlers/handlers-http-request-java-package-mapping.md#httpリクエストディスパッチハンドラ) ）では
ディスパッチ先のクラスはディスパッチハンドラ内でインスタンス化される。
そのため、ActionクラスをDIコンテナに登録する場合は、ディスパッチ先のクラスをシステムリポジトリから取得するよう DelegateFactory を
差し替える必要がある。差し替えは以下のように DispatchHandler#setDelegateFactory にて設定する。

```xml
<component name="packageMapping" class="nablarch.integration.router.RoutesMapping">
  <!-- ディスパッチ先をシステムリポジトリから取得するDelegateFactory -->
  <property name="delegateFactory">
      <component class="nablarch.fw.handler.SystemRepositoryDelegateFactory"/>
  </property>
  <!-- その他のプロパティは省略 -->
</component>
```

### オブジェクトの初期化処理を行う

オブジェクトの初期化処理を行うためには、以下の手順が必要となる。

1. Initializable インタフェースを実装する。
2. コンポーネント設定ファイルに初期化対象のリストを設定する。

以下に詳細な手順を示す。

Initializableインタフェースを実装する

initialize で初期化処理を行う。

```java
public class SampleComponent implements Initializable {
  public void initialize() {
    // プロパティにインジェクションされた値などを元に初期化処理を行う
  }
}
```

コンポーネント設定ファイルに初期化対象のリストを設定する

初期化対象のオブジェクトを BasicApplicationInitializer に設定する。

初期化対象のオブジェクトの初期化順を意識する必要がある場合は、先に初期化を行いたいオブジェクトをより上に設定する。
下の設定例の場合、以下の順で初期化が行われる。

1. sampleObject1
2. sampleObject2
3. sampleObject3

> **Important:**
> BasicApplicationInitializer のコンポーネント名は、 必ず **initializer** とすること。

```xml
<!-- 初期化対象のオブジェクトの設定 -->
<component name="sampleObject1" class="sample.SampleComponent1" />
<component name="sampleObject2" class="sample.SampleComponent2" />
<component name="sampleObject3" class="sample.SampleComponent3" />

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">

  <!-- initializeListプロパティにlist要素で初期化対象のオブジェクトを列挙する -->
  <property name="initializeList">
    <list>
      <component-ref name="sampleObject1" />
      <component-ref name="sampleObject2" />
      <component-ref name="sampleObject3" />
    </list>
  </property>

</component>
```

### オブジェクトの廃棄処理を行う

オブジェクトの廃棄処理を行うためには、以下の手順が必要となる。

1. Disposable インタフェースを実装する。
2. コンポーネント設定ファイルに廃棄対象のリストを設定する。

以下に詳細な手順を示す。

Disposableインタフェースを実装する

dispose で廃棄処理を行う。

```java
public class SampleComponent implements Disposable {
  public void dispose() throws Exception{
    // リソースの解放など、廃棄処理を行う
  }
}
```

コンポーネント設定ファイルに廃棄対象のリストを設定する

廃棄対象のオブジェクトを BasicApplicationDisposer に設定する。

廃棄対象のオブジェクトの廃棄順を意識する必要がある場合は、先に廃棄したいオブジェクトをより **下に設定する** 。
下の設定例の場合、以下の順で廃棄処理が行われる。

1. sampleObject1
2. sampleObject2
3. sampleObject3

> **Important:**
> BasicApplicationDisposer のコンポーネント名は、 必ず **disposer** とすること。

```xml
<!-- 廃棄対象のオブジェクトの設定 -->
<component name="sampleObject1" class="sample.SampleComponent1" />
<component name="sampleObject2" class="sample.SampleComponent2" />
<component name="sampleObject3" class="sample.SampleComponent3" />

<component name="disposer"
    class="nablarch.core.repository.disposal.BasicApplicationDisposer">

  <!-- disposableListプロパティにlist要素で廃棄対象のオブジェクトを列挙する -->
  <property name="disposableList">
    <list>
      <component-ref name="sampleObject3" />
      <component-ref name="sampleObject2" />
      <component-ref name="sampleObject1" />
    </list>
  </property>

</component>
```

`BasicApplicationDisposer` には addDisposable というメソッドが用意されており、コンポーネント生成後に任意の Disposable を追加できる。

この addDisposable で追加される Disposable は、そのインスタンスが生成された順番で追加されることが予想される。
その場合、廃棄処理はインスタンス生成とは逆の順序で行うことが望ましい（例：JDBCの `Connection`, `Statement`, `ResultSet`）。

このため、 BasicApplicationDisposer では `disposableList` に設定されている順序とは逆の順序で廃棄処理を呼ぶようになっている。

Closeableオブジェクトを廃棄対象リストに設定する

`java.io.Closeable` を実装したコンポーネントであれば、 DisposableAdaptor を用いることで、次のように廃棄対象リストに簡単に設定できる。

```xml
<!-- java.io.Closeable を実装したコンポーネント -->
<component name="closeableComponent" class="sample.CloseableComponent" />

<component name="disposer"
    class="nablarch.core.repository.disposal.BasicApplicationDisposer">

  <property name="disposableList">
    <list>
      <component class="nablarch.core.repository.disposal.DisposableAdaptor">
        <!-- DisposableAdaptor の target プロパティに、 Closeable を実装したコンポーネントを設定する -->
        <property name="target" ref="closeableComponent" />
      </component>
    </list>
  </property>

</component>
```

### DIコンテナの情報をシステムリポジトリに設定する

DIコンテナの情報をシステムリポジトリにロードすることで、アプリケーション内の全ての箇所からDIコンテナ上のオブジェクトにアクセスできる。

コンポーネント設定ファイルをロードし、システムリポジトリに設定する例を以下に示す。

この例では、 `web-boot.xml` を元に構築されたDIコンテナの情報がシステムリポジトリに設定される。

```java
XmlComponentDefinitionLoader loader
    = new XmlComponentDefinitionLoader("web-boot.xml");
SystemRepository.load(new DiContainer(loader));
```

> **Important:**
> DIコンテナの情報をシステムリポジトリへ登録する処理は、Nablarchが提供する以下のクラスで実施される。
> このため、個別に実装することは基本的にない。

> * >   ServletContextListenerの実装クラス
> * >   独立型アプリケーションの起動クラス

### システムリポジトリからオブジェクトを取得する

システムリポジトリ上からオブジェクトを取得する場合には、 SystemRepository クラスを使用する。

なお、システムリポジトリには事前にDIコンテナの情報を設定しておく必要がある。
詳細は、 [DIコンテナの情報をシステムリポジトリに設定する](../../component/libraries/libraries-repository.md#diコンテナの情報をシステムリポジトリに設定する) を参照。

以下のように、component要素(listやmap要素を含む)に設定したname属性の値を指定して、オブジェクトを取得できる。

コンポーネント定義

```xml
<component name="sampleComponent" class="sample.SampleComponent" />

<component name="component" class="sample.Component" >
  <property name="component2">
    <component name="component2" class="sample.Component2" />
  </property>
</component>
```

取得例

```java
// SystemRepository#getを使用して取得する。
SampleComponent sample = SystemRepository.get("sampleComponent");

// ネストしたcomponentは、親の名前と自身の名前を"."で連結し取得する。
Component2 component2 = SystemRepository.get("component.component2");
```

## 環境設定ファイルの記述ルール

環境設定ファイルにはconfigファイルとpropertiesファイルの二種類があり、ここでは各環境設定ファイルの記述ルールについて説明する。

propertisファイルの仕様

JavaのPropertiesの仕様に基づいて解析される。

configファイルの仕様

以下、configファイルの仕様について説明する。

設定値の記述形式

設定値は、 キーと値を `=` で区切って記述する。

```bash
key1=value1
key2=value2
```

コメントの記述

コメントは、 `#` を用いた行コメントのみサポートする。
行中に `#` が存在した場合は、それ以降をコメントとして扱う。

```bash
# コメントです
key = value   # コメントです
```

複数行にまたがった設定値の記述

行末に `\` を記述することで、複数行にまたがって設定値を記述できる。

下の例の場合、設定値の組み合わせは以下のようになる。

* key -> value
* key2 -> value,value2
* key3 -> abcdefg

```bash
key = value
key2 = value,\
value2
key3 = abcd\    # ここにコメントを定義できる
efg
```

予約語のエスケープ

以下の予約語を一般文字として扱う場合は、 `\` を用いてエスケープする。

* `#`
* `=`
* `\`

下の例の場合、設定値の組み合わせは以下のようになる。

* key -> a=a
* key2 -> #コメントではない
* key3 -> あ\い

```bash
key = a\=a
key2 = \#コメントではない
key3 = あ\\い
```

> **Tip:**
> 半角スペースについて、configファイルでは半角スペースのみの値には対応していないが、propertiesファイルでは数値参照文字を設定することで扱うことができる。

> ```bash
> key = \u0020
> ```

> **Tip:**
> 値が空の場合の挙動について、configファイルでは値が空の場合キーごと読み込まれないが、propertiesファイルでは空文字として扱われる。
> そのため、コンポーネント設定ファイルから環境依存値を参照する際の挙動が異なるため注意が必要となる。

> 以下のようなコンポーネント設定と環境設定ファイルを定義した場合の挙動は下記の通り。

> * >   環境設定ファイルがconfigファイルの場合 `config.value` は存在しないため例外が送出される。(※)
> * >   環境設定ファイルがpropertiesファイルの場合、コンポーネントの `property` には空文字が設定される。

> ```xml
> <property name="property" value="${config.value}" />
> ```

> ```bash
> # 値が空の設定値
> config.value=
> ```

> ※5u18までのNablarchでは設定値が存在しない場合は例外は送出されず、WARNINGレベルのログが出力され `property` に"${config.value}"という文字列が設定される。
