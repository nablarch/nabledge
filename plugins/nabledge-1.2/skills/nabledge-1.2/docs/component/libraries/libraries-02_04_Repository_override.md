# 設定値の上書きの対象

## 環境設定ファイル(test1.conf)

設定の上書き対象は以下の3つ:
1. 環境設定ファイルに記述した文字列の設定値
2. コンポーネントのプロパティ
3. コンポーネントのクラス

`XmlComponentDefinitionLoader`のコンストラクタに渡すコンポーネント設定ファイルを起点として、より後に記述した設定が優先される。

## 環境設定ファイルの設定値の上書き

同じ設定名を2回以上設定ファイルに記述した場合、後に記述した設定で上書きされる。単一ファイル内での重複だけでなく、`config-file`要素で環境設定ファイルを読み込んだ場合も同様の動作となる。

**環境設定ファイル(test1.conf)**

```bash
test.message=test1
```

`SystemRepository.getObject()` でDIコンテナからコンポーネントを取得する実装例。環境設定ファイルよりシステムプロパティの設定が優先される（環境設定ファイルの値は使われない）。

```java
// DIコンテナで "helloComponent" と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// 環境設定ファイルに設定した "This is property file hello message!!" ではなく、
// システムプロパティに設定を記述した "This is system property hello message!!" がコンソールに表示される
helloComponent.printHello();
```

<details>
<summary>keywords</summary>

XmlComponentDefinitionLoader, SystemRepository, config-file, 設定値の上書き, 環境設定ファイル, 上書き優先順位, HelloComponent, getObject, コンポーネント取得, システムプロパティ上書き, DIコンテナ

</details>

## 環境設定ファイル(test2.conf)

**環境設定ファイル(test2.conf)** — test1.confより後に読み込まれるため、`test.message`の値として`"test2"`が優先される。

```bash
test.message=test2
```

<details>
<summary>keywords</summary>

環境設定ファイル, 設定値の上書き, test.message, 後の記述が優先

</details>

## コンポーネント設定ファイルを読み込む

test1.confとtest2.confを以下の順で読み込んだ場合、`"test.message"`の値はtest2.confの`"test2"`になる（後に記述した`config-file`要素が優先）。

```xml
<component-configuration 
    xmlns="http://tis.co.jp/nablarch/component-configuration" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <config-file file="test1.conv"/>
    <config-file file="test2.conv"/>
</component-configuration>
```

<details>
<summary>keywords</summary>

config-file, コンポーネント設定ファイル, 環境設定ファイルの読み込み順序

</details>

## 設定値の取得例

`SystemRepository.getString()`で設定値を取得すると、より後に記述されたtest2.confの値が返される。

```java
// より後に設定が記述された test2.conf ファイルの設定値 "test2" が取得できる。
String testMessage = SystemRepository.getString("test.message");
```

<details>
<summary>keywords</summary>

SystemRepository, SystemRepository.getString, 設定値取得

</details>

## 使用するクラス

## コンポーネントのプロパティの上書き

同じコンポーネント名で別々にコンポーネントの定義を記述した場合、コンポーネント設定ファイルでより後に記述した設定が有効になる。上書きが発生した際はWARNINGレベルのログが出力される。

> **注意**: 設定上書き機能は、別ファイルに設定を記述して状況に応じてコンポーネント設定ファイルを切り替えて使用する用途を想定している。

```java
public class OverrideExample {
    private String str1;
    private String str2;
    private String str3;
    // setter,getter は省略
}
```

<details>
<summary>keywords</summary>

OverrideExample, コンポーネントプロパティの上書き, WARNINGログ, プロパティ上書き

</details>

## コンポーネント設定ファイルの例

同一コンポーネント名`overrideExample`で2回定義した場合の例。後の定義で`str2`と`str3`が設定される（`str1`は最初の定義のまま保持される）。

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

<details>
<summary>keywords</summary>

OverrideExample, nablarch.core.repository.di.example.override.OverrideExample, component name, property name, 上書き設定

</details>

## 設定したコンポーネントの取得例

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

<details>
<summary>keywords</summary>

SystemRepository, SystemRepository.getObject, OverrideExample, 上書き後の値取得

</details>

## 読み込み元の設定ファイル

## コンポーネントのクラスの上書き

同一コンポーネント名で異なるクラスを登録した場合、より後に設定したクラスが優先される。テスト時に実クラス（`RealConnectionService`）をスタブ（`MockConnectionService`）に置き換える用途で使用する。

> **注意**: コンポーネントのクラスの上書きを行った場合、先に設定されたコンポーネントのプロパティは上書きしたクラスのプロパティに反映されない。先に設定されたコンポーネントが持つプロパティを上書きしたクラスが持っていない可能性があるための制約。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- 元の設定: 実アプリケーションで使用する外部接続クラス -->
    <component name="stringResource" class="example.external.RealConnectionService">
        <!-- プロパティの設定は省略 -->
    </component>
    <import dir="/opt/testconfig" file="*.xml"/>
</component-configuration>
```

<details>
<summary>keywords</summary>

RealConnectionService, MockConnectionService, コンポーネントクラスの上書き, スタブ置換, import dir

</details>

## テスト用の設定ファイル(/opt/testconfig/testconfig.xml)

テスト時のみ`/opt/testconfig/testconfig.xml`をサーバに配置することで、`MockConnectionService`への切り替えが行われる。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- 上書きする設定: テストで使用する外部接続クラスのスタブ -->
    <component name="stringResource" class="example.external.MockConnectionService">
        <!-- プロパティの設定は省略 -->
    </component>
</component-configuration>
```

<details>
<summary>keywords</summary>

MockConnectionService, スタブ, テスト設定ファイル, クラス上書き

</details>

## import-example1.xml

## import/config-file要素による外部ファイル読み込み時の優先順位

`import`要素や`config-file`要素でファイルを読み込んだ場合、その箇所にインポートしたファイルの設定をそのまま展開した場合と同じ順序で優先順位が決定する。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- 元の設定 -->
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported1"/>
    </component>
    <import file="import-example2.xml"/>
</component-configuration>
```

<details>
<summary>keywords</summary>

HelloImport, nablarch.core.repository.di.example.imp.HelloImport, import要素, 外部ファイル読み込み, 優先順位

</details>

## import-example2.xml

import-example1.xmlからimport-example2.xmlをインポートした場合、`helloImport1`のvalueプロパティには後に展開されるimport-example2.xmlの`"imported2"`が設定される。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- 上書きする設定 -->
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported2"/>
    </component>
</component-configuration>
```

<details>
<summary>keywords</summary>

HelloImport, import要素, 上書き設定, imported2

</details>

## onefile-example.xml(import-example1.xml、import-example2.xmlと等価)／dir属性を使用した読み込み時の優先順位

import-example1.xmlとimport-example2.xmlの組み合わせは、以下のonefile-example.xmlと等価（`helloImport1`のvalueには`"imported2"`が設定される）。

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

## dir属性を使用した読み込み時の優先順位

`import`要素・`config-file`要素のdir属性でファイルを読み込む場合（[directory_config](libraries-02_01_Repository_config.md) 参照）、ファイル名をJavaの文字列としてソートした順序で読み込まれる。

例: `/opt/config/`に`test1.xml`、`test2.xml`、`test3.xml`が存在する場合、以下2つの設定は等価:

```xml
<!-- dir属性使用: test1.xml→test2.xml→test3.xmlの順に読み込まれる -->
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <import dir="/opt/config/" file="*.xml"/>
</component-configuration>
```

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <import file="/opt/config/test1.xml"/>
    <import file="/opt/config/test2.xml"/>
    <import file="/opt/config/test3.xml"/>
</component-configuration>
```

<details>
<summary>keywords</summary>

HelloImport, dir属性, ファイル名ソート, import優先順位, directory_config

</details>

## 設定をロードする際の実装例(通常フレームワークのブートストラップ処理で行う)

## 設定値の上書き時の動作設定

上書き発生時の動作は以下2通りを指定できる:

| 名称 | 説明 |
|---|---|
| OVERRIDE | 後に記述したもので上書き（指定なしの場合のデフォルト動作） |
| DENY | 重複した設定を検出した際に例外を発生させる |

`XmlComponentDefinitionLoader`のコンストラクタ第2引数に`DuplicateDefinitionPolicy`を指定して変更する。通常はWebフレームワーク・バッチフレームワークのブートストラップ処理で設定する。

```java
// 注意: ブートストラップ処理で行うべき処理。通常のアプリケーションでは実装不要。

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

<details>
<summary>keywords</summary>

XmlComponentDefinitionLoader, DiContainer, DuplicateDefinitionPolicy, ConfigurationLoadException, OVERRIDE, DENY, 重複検出, ブートストラップ

</details>

## 環境設定ファイル(hello-system-property.config)

## システムプロパティによる設定値の上書き

`java.lang.System.getProperties()`で取得できるシステムプロパティによって環境設定ファイルの設定値を上書きできる。システムプロパティは環境設定ファイルより優先されるため、実行時に環境設定ファイルを変更せずに動作変更できる。

```bash
# この設定はシステムプロパティより優先されない
hello.message = This is property file hello message!!
```

<details>
<summary>keywords</summary>

システムプロパティ, 環境設定ファイル上書き, hello.message

</details>

## コンポーネント設定ファイル(hello-system-property.xml)

`${hello.message}`プロパティに環境設定ファイルの値が注入される設定例。システムプロパティが設定されている場合はそちらが優先される。

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

<details>
<summary>keywords</summary>

HelloComponent, HelloMessageProvider, nablarch.core.repository.di.example.hello.HelloComponent, nablarch.core.repository.di.example.hello.HelloMessageProvider, システムプロパティ, config-file

</details>

## 設定値のロードの実装例

```java
// 注意: ブートストラップ処理で行うべき処理。通常のアプリケーションでは実装不要。

// システムプロパティにキー"hello.message"でメッセージを設定
System.setProperty("hello.message", "This is system property hello message!!");

XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader(
        "nablarch/core/repository/di/example/override/hello-system-property.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);
```

> **注意**: 実際に使用する際はjavaコマンドの`-D`オプションで実行時にシステムプロパティを設定する:
> ```bash
> java -Dhello.message="value in system property" ...
> ```

<details>
<summary>keywords</summary>

SystemRepository, DiContainer, XmlComponentDefinitionLoader, システムプロパティ設定, -Dオプション

</details>
