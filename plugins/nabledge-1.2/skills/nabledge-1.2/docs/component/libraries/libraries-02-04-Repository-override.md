## 設定値の上書きの対象

設定の上書きは、下記対象に対して実施できる。

1. 環境設定ファイルに記述した文字列の設定値
2. コンポーネントのプロパティ
3. コンポーネントのクラス

それぞれの設定値は、 XmlComponentDefinitionLoader クラスのコンストラクタに渡すコンポーネント設定ファイルを起点として、より後に記述した設定が優先される。

以下にそれぞれの対象ごとの設定方法と例を示す。

## 環境設定ファイルに記述した文字列の設定値の上書き

環境設定ファイルに記述した設定値は、同じ設定名を2回以上設定ファイルに記述した場合に後に記述した設定で上書きされる。
これは、単に同一設定ファイル内に記述した場合だけでなく、コンポーネント設定ファイルの config-file 要素で環境設定ファイルを読み込んだ場合でも同様の動作となる。

下記の test1.conf と test2.conf の2種類の環境設定ファイルをコンポーネント設定ファイルで読み込む場合を考える。

### 環境設定ファイル(test1.conf)

```bash
test.message=test1
```

### 環境設定ファイル(test2.conf)

```bash
test.message=test2
```

これら2つのファイルを下記のコンポーネント設定ファイルで読み込んだ場合、リポジトリから "test.message" をキーにして取得した設定値は test2.conf に記述した "test2" となる。

### コンポーネント設定ファイルを読み込む

```xml
<component-configuration
    xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <config-file file="test1.conv"/>
    <config-file file="test2.conv"/>
</conponent-configuration>
```

### 設定値の取得例

```java
// より後に設定が記述された test2.conf ファイルの設定値 "test2" が取得できる。
String testMessage = SystemRepository.getString("test.message");
```

## コンポーネントのプロパティの上書き

同じコンポーネント名で別々にコンポーネントの定義を記述した場合、コンポーネント設定ファイルでより後に記述した設定が有効になる。
これはベースとなる設定値を別のファイルで記述した設定で上書きするという用途を意図している。
ただし、この動作が意図しないものであった場合を考慮し、上書きが発生した際はワーニングレベルのログ出力を行う。

上書き設定を行った場合のコンポーネント設定ファイルと実装例を下記に示す。

> **Note:**
> この例では説明のために上書きされる設定と上書きする設定を続けて記述しているが、
> 本来設定上書きの機能は別のファイルに設定を記述して状況に応じてコンポーネント設定ファイルを
> 切り替えて使用する用途を想定している。

### 使用するクラス

```java
public class OverrideExample {

    private String str1;
    private String str2;
    private String str3;

    // setter,getter は省略
}
```

### コンポーネント設定ファイルの例

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">

        <!-- 元の設定 -->
    <component name="overrideExample" class="nablarch.core.repository.di.example.override.OverrideExample">
        <property name="str1" value="base value1" />
        <property name="str2" value="base value2" />
    </component>

        <!-- 上書き設定 -->
    <component name="overrideExample" class="nablarch.core.repository.di.example.override.OverrideExample">
        <property name="str2" value="override value2" />
        <property name="str3" value="override value3" />
    </component>
</component-configuration>
```

### 設定したコンポーネントの取得例

```java
// コンポーネントを取得
OverrideExample overrideExample = (OverrideExample) SystemRepository.getObject("overrideExample");

// 上書きする前の "base value1" が出力される
System.out.println(overrideExample.getStr1());
// 上書きされた "override value2" が出力される
System.out.println(overrideExample.getStr2());
// 上書き設定で設定された "override value3" が出力される
System.out.println(overrideExample.getStr3());
```

## コンポーネントのクラスの上書き

コンポーネント設定ファイルに、同一のコンポーネント名で異なるクラスを登録した場合、より後に設定したクラスの設定が優先される。
この上書きは、フレームワークがテスト時に使用するクラスを、実際のアプリケーションで使用するものからスタブに変更したい場合などに使用する。

スタブを用いたテストは、外部システム連携を行うクラスでしばしば必要になる。
外部連携を行う RealConnectionService クラスをスタブによるテスト時のみ MockConnectionService クラスに置き換えるような用途であれば、
下記のように読み込み元の設定ファイルとテスト用の設定ファイルを用意し、テスト時のみテスト用の設定ファイルが読み込まれるように配置すればよい。

### 読み込み元の設定ファイル

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!--
        元の設定
        実アプリケーションで使用する外部接続クラス
     -->
    <component name="stringResource" class="example.external.RealConnectionService">
        <!-- プロパティの設定は省略 -->
    </component>
    <import dir="/opt/testconfig" file="*.xml"/>
</component-configuration>
```

### テスト用の設定ファイル(/opt/testconfig/testconfig.xml)

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!--
        上書きする設定
        テストで使用する外部接続クラスのスタブ
        テスト時は、この設定ファイルをサーバの /opt/testconfig に配置する
     -->
    <component name="stringResource" class="example.external.MockConnectionService">
        <!-- プロパティの設定は省略 -->
    </component>
</component-configuration>
```

> **Note:**
> コンポーネントのクラスの上書きを行った場合、先に設定されたコンポーネントに設定したプロパティは上書きしたクラスのプロパティに反映されないため、注意すること。
> これは、先に設定されたコンポーネントが持つプロパティを上書きしたクラスが持っていない可能性があるために発生した制約である。

## import 要素および config-file 要素による外部ファイル読み込み時の優先順位

import 要素や config-file 要素を使用して他のファイルの読み込みを行った場合、その属性の箇所にインポートしたファイルに記述した設定をそのまま展開した場合と同じ順序で設定の優先順位が決定する。

例えば下記の import-example1.xml と import-example2.xml は、onefile-example.xml と同様の順序で評価され、コンポーネント  helloImport1 の value プロパティには
import-example2.xml に設定した "imported2" が設定される。

### import-example1.xml

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- 元の設定 -->
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported1"/>
    </component>
    <import file="import-example2.xml"/>
</component-configuration>
```

### import-example2.xml

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- 上書きする設定 -->
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported2"/>
    </component>
</component-configuration>
```

### onefile-example.xml(import-example1.xml、import-example2.xmlと等価)

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- 元の設定 -->
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported1"/>
    </component>

    <!-- 上書きする設定 -->
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported2"/>
    </component>
</component-configuration>
```

## dir 属性を使用した読み込み時の優先順位

import 要素、config-file 要素の dir 属性を使用した読み込み [1] を使用した場合は、インポートするファイル名を java の文字列としてソートした順序で読み込まれる。

[ディレクトリに配置された設定ファイルの読み込み](../../component/libraries/libraries-02-01-Repository-config.md#directory-config) を参照

例えば、 /opt/config/ ディレクトリ以下に下記のファイルが存在していた場合を考える。

/opt/config/ ディレクトリに存在するファイル

* test1.xml
* test2.xml
* test3.xml
* environment.config

この場合、下記2つの設定は等価となる。

```xml
<!--
    dir属性を使用した設定
    ファイルは /opt/config/test1.xml 、 /opt/config/test2.xml 、 /opt/config/test3.xml の順に読み込まれる。
-->
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <import dir="/opt/config/" file="*.xml"/>
</component-configuration>
```

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!--
        dir属性を使用しない設定
        上記設定と同じ動作となる
    -->
    <import file="/opt/config/test1.xml"/>
    <import file="/opt/config/test2.xml"/>
    <import file="/opt/config/test3.xml"/>
</component-configuration>
```

## 設定値の上書き時の動作設定

設定値の上書きは、テストに便利であるなど利点がある反面、使用者が誤って行った設定値の上書きの検出が煩雑となる問題がある。
このような場合を考慮し、DIコンテナは設定値の上書きが発生した際の動作を変更できる機能を持つ。

設定値の上書きを行った際の動作は、下記2通りを指定できる。

| 名称 | 説明 |
|---|---|
| OVERRIDE | 設定値を後に記述したもので上書きする。指定がない場合のデフォルト動作。 |
| DENY | 重複した設定を検出した際に例外を発生させる。 |

通常この動作の変更は、 Web フレームワークやバッチフレームワークの起動時に行われるブートストラップ処理の設定で行う。

もしこれらブートストラップの処理以外で動作を変更したい場合、 XmlComponentDefinitionLoader のコンストラクタ2番目の引数を指定する。

例えば設定値の重複があった際に例外を発生には下記のように実装する。

### 設定をロードする際の実装例(通常フレームワークのブートストラップ処理で行う)

```java
// ******** 注意 ********
// 直下のコードはブートストラップ処理で行うべき処理であり、通常のアプリケーションでは実装する必要がない。
// 従って、本フレームワークを使用する場合、アプリケーション・プログラマはこのような実装を行わない。

// XmlComponentDefinitionLoader のコンストラクタ第2引数に DuplicateDefinitionPolicy.DENY を指定
XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader(
        "nablarch/core/repository/di/example/override/hello-override.xml",
        DuplicateDefinitionPolicy.DENY);
try {
    DiContainer container = new DiContainer(loader);

} catch (ConfigurationLoadException e) {
    // 重複した設定を行なった場合、例外が発生する。
    throw new RuntimeException("コンポーネント設定ファイルの読み込みに失敗しました。", e);
}
```

## システムプロパティによる設定値の上書き

環境設定ファイルに記述する設定値は、前述の環境設定ファイルによる上書きの他に、
java.lang.System.getProperties() メソッドで取得できるシステムプロパティによって上書きできる。
システムプロパティによる上書きは、環境設定ファイルよりも優先されるため、実行時に環境設定ファイルを変更することなく動作を変更する際に使用できる。

以下に使用例を示す。

### 環境設定ファイル(hello-system-property.config)

```bash
# この設定はシステムプロパティより優先されない
hello.message = This is property file hello message!!
```

### コンポーネント設定ファイル(hello-system-property.xml)

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">
    <config-file file="nablarch/core/repository/di/example/override/hello-system-property.config"/>

    <component name="helloComponent" class="nablarch.core.repository.di.example.hello.HelloComponent">
        <property name="helloMessageProvider" ref="helloMessageProvider"/>
    </component>

    <component name="helloMessageProvider" class="nablarch.core.repository.di.example.hello.HelloMessageProvider">
        <property name="helloMessage" value="${hello.message}" />
    </component>

</component-configuration>
```

### 設定値のロードの実装例

```java
// ******** 注意 ********
// 直下のコードはブートストラップ処理で行うべき処理であり、通常のアプリケーションでは実装する必要がない。
// 従って、本フレームワークを使用する場合、アプリケーション・プログラマはこのような実装を行わない。

// システムプロパティにキー"hello.message"でメッセージを設定
System.setProperty("hello.message", "This is system property hello message!!");

XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader(
        "nablarch/core/repository/di/example/override/hello-system-property.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);
```

> **Note:**
> 例では説明のために java.lang.System.setProperty() を使用した方法を示しているが、実際に使用する際はjavaコマンドのオプション-Dによる
> 指定を用いて下記のように実行時のオプションとしてシステムプロパティを設定できる。
> 環境設定ファイルを変更せずに動作確認を行う際は、通常この方法を使用する。

> ```bash
> > java -Dhello.message="value in system property" ...
> ```

### 設定したコンポーネントを取得する実装例

```java
// DIコンテナで "helloComponent" と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// 環境設定ファイルに設定した "This is property file hello message!!" ではなく、
// システムプロパティに設定を記述した "This is system property hello message!!" がコンソールに表示される
helloComponent.printHello();
```
