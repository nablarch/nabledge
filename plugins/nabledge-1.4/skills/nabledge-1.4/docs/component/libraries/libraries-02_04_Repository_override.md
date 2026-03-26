# 設定値の上書きの対象

## 設定値の上書き対象の概要と環境設定ファイル(test1.conf)

設定値の上書き対象は以下の3種類:
1. 環境設定ファイルに記述した文字列の設定値
2. コンポーネントのプロパティ
3. コンポーネントのクラス

後に記述した設定が優先される（`XmlComponentDefinitionLoader`のコンストラクタに渡すコンポーネント設定ファイルを起点として）。

**環境設定ファイルに記述した文字列設定値の上書き**: 同じ設定名を2回以上記述した場合、後に記述した設定で上書きされる。単一ファイル内だけでなく、`config-file`要素で複数の環境設定ファイルを読み込む場合も同様。

```bash
test.message=test1
```

`SystemRepository.getObject("コンポーネント名")` でDIコンテナからコンポーネントを取得する。システムプロパティに設定した値は環境設定ファイルの値より優先される。

```java
// DIコンテナで "helloComponent" と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// 環境設定ファイルの値ではなく、システムプロパティの値が使用される
helloComponent.printHello();
```

<details>
<summary>keywords</summary>

XmlComponentDefinitionLoader, SystemRepository, config-file, 環境設定ファイル上書き, 文字列設定値上書き, 上書き対象, 設定上書き対象, コンポーネントプロパティ上書き, コンポーネントクラス上書き, 後優先, HelloComponent, getObject, コンポーネント取得, システムプロパティ優先, DIコンテナ

</details>

## 環境設定ファイル(test2.conf)

2つ目の環境設定ファイル。test1.confと同じキー`test.message`に`test2`を設定しており、test1.confより後に読み込まれるためtest1.confの設定値を上書きする。

```bash
test.message=test2
```

<details>
<summary>keywords</summary>

環境設定ファイル, test.message, 設定値上書き, 後優先

</details>

## コンポーネント設定ファイルを読み込む

test1.confとtest2.confをこの順で読み込んだ場合、`"test.message"`の値はtest2.confに記述した`"test2"`となる。

```xml
<component-configuration 
    xmlns="http://tis.co.jp/nablarch/component-configuration" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <config-file file="test1.conv"/>
    <config-file file="test2.conv"/>
</conponent-configuration>
```

<details>
<summary>keywords</summary>

config-file要素, コンポーネント設定ファイル, 設定読み込み順序, 上書き優先順位

</details>

## 設定値の取得例

```java
// より後に設定が記述された test2.conf ファイルの設定値 "test2" が取得できる。
String testMessage = SystemRepository.getString("test.message");
```

<details>
<summary>keywords</summary>

SystemRepository, getString, 設定値取得

</details>

## 使用するクラス

コンポーネントのプロパティ上書きルール:
- 同じコンポーネント名で複数回定義した場合、後に記述した設定が有効になる
- 上書きが発生した際はワーニングレベルのログ出力が行われる
- 用途: ベース設定を別ファイルに記述し、状況に応じてコンポーネント設定ファイルを切り替えて使用する

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

OverrideExample, コンポーネントプロパティ上書き, ワーニングログ, 同名コンポーネント定義

</details>

## コンポーネント設定ファイルの例

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

component要素, property上書き, base value, override value, OverrideExample

</details>

## 設定したコンポーネントの取得例

`overrideExample`コンポーネント取得時の各プロパティ値:
- `str1`: 上書きされず元の設定`"base value1"`が返る
- `str2`: 上書きされた`"override value2"`が返る
- `str3`: 上書き設定で設定された`"override value3"`が返る

```java
OverrideExample overrideExample = (OverrideExample) SystemRepository.getObject("overrideExample");
System.out.println(overrideExample.getStr1()); // "base value1"
System.out.println(overrideExample.getStr2()); // "override value2"
System.out.println(overrideExample.getStr3()); // "override value3"
```

<details>
<summary>keywords</summary>

SystemRepository, getObject, プロパティ上書き結果, OverrideExample

</details>

## 読み込み元の設定ファイル

コンポーネントのクラス上書きルール:
- 同一コンポーネント名で異なるクラスを登録した場合、後に設定したクラスが優先される
- 用途: テスト時にスタブクラスに差し替える場合（外部システム連携クラスを`MockConnectionService`等に変更する）

> **注意**: コンポーネントのクラスを上書きした場合、先に設定されたコンポーネントのプロパティは上書きしたクラスのプロパティに反映されない。上書き先クラスが該当プロパティを持っていない可能性があるため。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- 実アプリケーションで使用する外部接続クラス -->
    <component name="stringResource" class="example.external.RealConnectionService">
        <!-- プロパティの設定は省略 -->
    </component>
    <import dir="/opt/testconfig" file="*.xml"/>
</component-configuration>
```

<details>
<summary>keywords</summary>

RealConnectionService, import dir, クラス上書き, テスト用スタブ, 外部接続クラス差し替え

</details>

## テスト用の設定ファイル(/opt/testconfig/testconfig.xml)

テスト時はこの設定ファイルを`/opt/testconfig`に配置することで`RealConnectionService`が`MockConnectionService`に置き換えられる。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- テストで使用する外部接続クラスのスタブ -->
    <component name="stringResource" class="example.external.MockConnectionService">
        <!-- プロパティの設定は省略 -->
    </component>
</component-configuration>
```

<details>
<summary>keywords</summary>

MockConnectionService, スタブ, テスト設定, クラス差し替え

</details>

## import-example1.xml

`import`要素・`config-file`要素で外部ファイルを読み込む場合の優先順位: importした位置にそのファイルの設定をそのまま展開した場合と同じ順序で評価される。

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

import要素, 外部ファイル読み込み優先順位, HelloImport, インポート展開順序

</details>

## import-example2.xml

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

import要素, 上書き設定, HelloImport, imported2

</details>

## onefile-example.xml(import-example1.xml、import-example2.xmlと等価)、およびdir属性を使用した読み込み時の優先順位

import-example1.xmlとimport-example2.xmlを読み込んだ場合と等価。`helloImport1`の`value`プロパティには`"imported2"`が設定される。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported1"/>
    </component>
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported2"/>
    </component>
</component-configuration>
```

**`dir`属性を使用した読み込み時の優先順位**: `import`要素・`config-file`要素の`dir`属性を使用した場合、ファイル名をJavaの文字列としてソートした順序で読み込まれる。

例: `/opt/config/`に`test1.xml`、`test2.xml`、`test3.xml`が存在する場合、以下の2つの設定は等価:

```xml
<!-- dir属性を使用: test1.xml, test2.xml, test3.xmlの順に読み込まれる -->
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

dir属性, ファイル読み込み順序, Javaソート順, import要素等価, config-file dir属性

</details>

## 設定をロードする際の実装例(通常フレームワークのブートストラップ処理で行う)

設定値の上書き時の動作設定:

| 名称 | 説明 |
|---|---|
| OVERRIDE | 設定値を後に記述したもので上書き（デフォルト） |
| DENY | 重複した設定を検出した際に例外を発生 |

`XmlComponentDefinitionLoader`のコンストラクタ第2引数に`DuplicateDefinitionPolicy`を指定して動作を変更できる（通常はブートストラップ処理で設定）。

```java
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

<details>
<summary>keywords</summary>

DuplicateDefinitionPolicy, DENY, OVERRIDE, XmlComponentDefinitionLoader, ConfigurationLoadException, 重複設定検出

</details>

## 環境設定ファイル(hello-system-property.config)

システムプロパティによる上書きルール:
- `java.lang.System.getProperties()`で取得できるシステムプロパティで環境設定ファイルの設定値を上書きできる
- システムプロパティによる上書きは環境設定ファイルより優先される（実行時に環境設定ファイルを変更せずに動作を変更できる）

```bash
# この設定はシステムプロパティより優先されない
hello.message = This is property file hello message!!
```

<details>
<summary>keywords</summary>

システムプロパティ, 環境設定ファイル優先順位, System.getProperties, 上書き優先度

</details>

## コンポーネント設定ファイル(hello-system-property.xml)

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

HelloComponent, HelloMessageProvider, ${hello.message}, システムプロパティ参照

</details>

## 設定値のロードの実装例

```java
// システムプロパティにキー"hello.message"でメッセージを設定
System.setProperty("hello.message", "This is system property hello message!!");

XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader(
        "nablarch/core/repository/di/example/override/hello-system-property.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);
```

> **注意**: 実際の使用時は`java`コマンドの`-D`オプションを使用する。環境設定ファイルを変更せずに動作確認する際は通常この方法を使用する。
>
> ```bash
> java -Dhello.message="value in system property" ...
> ```

<details>
<summary>keywords</summary>

System.setProperty, -Dオプション, DiContainer, SystemRepository, システムプロパティ設定方法

</details>
