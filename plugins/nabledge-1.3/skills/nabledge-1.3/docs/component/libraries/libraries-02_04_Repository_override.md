# 設定値の上書きの対象

**公式ドキュメント**: [設定値の上書きの対象]()

## 環境設定ファイル(test1.conf)

## 環境設定ファイルに記述した文字列の設定値の上書き

環境設定ファイルの設定値は、同じ設定名を2回以上記述した場合、後に記述した設定で上書きされる。同一設定ファイル内だけでなく、`config-file`要素で複数の環境設定ファイルを読み込む場合も同様の動作となる。

```bash
test.message=test1
```

<details>
<summary>keywords</summary>

XmlComponentDefinitionLoader, SystemRepository, config-file, 環境設定ファイル上書き, 設定値優先順位

</details>

## 環境設定ファイル(test2.conf)

test2.confの設定値。test1.confより後に読み込まれるため、`test.message`の最終値は`test2`となる。

```bash
test.message=test2
```

<details>
<summary>keywords</summary>

環境設定ファイル, 設定値上書き, test.message

</details>

## コンポーネント設定ファイルを読み込む

2つの環境設定ファイルを読み込む設定。後に記述したtest2.convの設定値`test2`が有効になる。

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

config-file, コンポーネント設定ファイル, 環境設定ファイル読み込み順序

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

## コンポーネントのプロパティの上書き

同じコンポーネント名で複数定義した場合の動作:
- 後に記述した定義のプロパティが有効になる
- 後の定義に含まれないプロパティは、前の定義の値が維持される
- 上書きが発生した際はワーニングレベルのログが出力される
- 本来の用途: 別ファイルに設定を記述し、状況に応じてコンポーネント設定ファイルを切り替えて使用する

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

OverrideExample, コンポーネントプロパティ上書き, 同名コンポーネント, ワーニングログ, プロパティマージ

</details>

## コンポーネント設定ファイルの例

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
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

コンポーネント設定, property, 上書き設定, nablarch.core.repository.di.example.override.OverrideExample

</details>

## 設定したコンポーネントの取得例

```java
OverrideExample overrideExample = (OverrideExample) SystemRepository.getObject("overrideExample");

System.out.println(overrideExample.getStr1()); // "base value1" (上書き前の値)
System.out.println(overrideExample.getStr2()); // "override value2" (上書き後の値)
System.out.println(overrideExample.getStr3()); // "override value3" (上書き設定の値)
```

<details>
<summary>keywords</summary>

SystemRepository, getObject, OverrideExample, コンポーネント取得

</details>

## 読み込み元の設定ファイル

## コンポーネントのクラスの上書き

同一コンポーネント名で異なるクラスを登録した場合、後に設定したクラスが優先される。テスト時に実クラスをスタブに切り替える用途に使用する（例: `RealConnectionService` → `MockConnectionService`）。テスト時のみ `/opt/testconfig` ディレクトリのXMLが読み込まれるよう配置することで、テスト環境でのみスタブに切り替わる。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- 実アプリケーションで使用する外部接続クラス -->
    <component name="stringResource" class="example.external.RealConnectionService">
        <!-- プロパティの設定は省略 -->
    </component>
    <import dir="/opt/testconfig" file="*.xml"/>
</component-configuration>
```

<details>
<summary>keywords</summary>

RealConnectionService, import, クラス上書き, スタブ置き換え, テスト用設定

</details>

## テスト用の設定ファイル(/opt/testconfig/testconfig.xml)

テスト時に `/opt/testconfig/testconfig.xml` を配置することで `RealConnectionService` を `MockConnectionService` に置き換える。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- テストで使用する外部接続クラスのスタブ -->
    <component name="stringResource" class="example.external.MockConnectionService">
        <!-- プロパティの設定は省略 -->
    </component>
</component-configuration>
```

> **注意**: コンポーネントのクラスを上書きした場合、先に設定されたコンポーネントのプロパティは上書き後のクラスに反映されない。上書き後のクラスが同じプロパティを持っていない可能性があるため。

<details>
<summary>keywords</summary>

MockConnectionService, クラス上書き, テスト設定, プロパティ非継承, スタブ

</details>

## import-example1.xml

## import要素・config-file要素による外部ファイル読み込み時の優先順位

`import`要素や`config-file`要素でファイルを読み込んだ場合、インポートした位置にそのファイルの設定を展開した場合と同じ順序で優先順位が決定する。`helloImport1`の`value`プロパティにはimport-example2.xmlで設定した`"imported2"`が設定される。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- 元の設定 -->
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported1"/>
    </component>
    <import file="import-example2.xml"/>
</component-configuration>
```

<details>
<summary>keywords</summary>

import, config-file, ファイル読み込み優先順位, HelloImport, インポート展開

</details>

## import-example2.xml

import-example1.xmlから`import`された設定ファイル。`helloImport1`の`value`を`"imported2"`に上書きする。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- 上書きする設定 -->
    <component name="helloImport1" class="nablarch.core.repository.di.example.imp.HelloImport">
        <property name="value" value="imported2"/>
    </component>
</component-configuration>
```

<details>
<summary>keywords</summary>

HelloImport, imported2, コンポーネント上書き, import

</details>

## onefile-example.xml(import-example1.xml、import-example2.xmlと等価)

import-example1.xml + import-example2.xmlと等価な単一ファイル構成。

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

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

`dir`属性でファイルを読み込む場合、ファイル名をJavaの文字列としてソートした順序で読み込まれる（:ref:`repository_import_dir_override_priority` 参照）。

```xml
<!-- dir属性を使用: /opt/config/test1.xml → test2.xml → test3.xml の順で読み込まれる -->
<import dir="/opt/config/" file="*.xml"/>
```

上記は以下と等価:

```xml
<import file="/opt/config/test1.xml"/>
<import file="/opt/config/test2.xml"/>
<import file="/opt/config/test3.xml"/>
```

<details>
<summary>keywords</summary>

import, dir属性, ファイルロード順序, Javaソート順, repository_import_dir_override_priority

</details>

## 設定をロードする際の実装例(通常フレームワークのブートストラップ処理で行う)

## 設定値の上書き時の動作設定

`XmlComponentDefinitionLoader`のコンストラクタ第2引数に`DuplicateDefinitionPolicy`を指定して上書き発生時の動作を変更できる（通常はフレームワークのブートストラップ処理で行う）。

| 名称 | 説明 |
|---|---|
| OVERRIDE | 後に記述した設定で上書き（デフォルト動作） |
| DENY | 重複を検出した際に`ConfigurationLoadException`を発生させる |

```java
// ブートストラップ処理で行うべき処理。通常のアプリケーションでは実装不要。
XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader(
        "nablarch/core/repository/di/example/override/hello-override.xml",
        DuplicateDefinitionPolicy.DENY);
try {
    DiContainer container = new DiContainer(loader);
} catch (ConfigurationLoadException e) {
    throw new RuntimeException("コンポーネント設定ファイルの読み込みに失敗しました。", e);
}
```

<details>
<summary>keywords</summary>

XmlComponentDefinitionLoader, DuplicateDefinitionPolicy, OVERRIDE, DENY, ConfigurationLoadException, DiContainer, 設定値重複検出

</details>

## 環境設定ファイル(hello-system-property.config)

## システムプロパティによる設定値の上書き

`java.lang.System.getProperties()`で取得できるシステムプロパティは環境設定ファイルの設定値より優先される。実行時に環境設定ファイルを変更せずに動作を変更する際に使用できる。

```bash
# この設定はシステムプロパティより優先されない
hello.message = This is property file hello message!!
```

<details>
<summary>keywords</summary>

システムプロパティ, 環境設定ファイル上書き, System.getProperties, hello.message, 設定値優先順位

</details>

## コンポーネント設定ファイル(hello-system-property.xml)

```xml
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
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

HelloComponent, HelloMessageProvider, コンポーネント設定, システムプロパティ参照, ${hello.message}

</details>

## 設定値のロードの実装例

```java
// ブートストラップ処理で行うべき処理。通常のアプリケーションでは実装不要。
System.setProperty("hello.message", "This is system property hello message!!");

XmlComponentDefinitionLoader loader = new XmlComponentDefinitionLoader(
        "nablarch/core/repository/di/example/override/hello-system-property.xml");
DiContainer container = new DiContainer(loader);
SystemRepository.load(container);
```

> **注意**: 実際の使用では`java.lang.System.setProperty()`ではなく、javaコマンドの`-D`オプションを使用する（例: `java -Dhello.message="value in system property" ...`）。環境設定ファイルを変更せずに動作確認する際はこの方法を使用する。

<details>
<summary>keywords</summary>

SystemRepository, DiContainer, XmlComponentDefinitionLoader, System.setProperty, -Dオプション, システムプロパティ設定

</details>

## 設定したコンポーネントを取得する実装例

```java
// DIコンテナで "helloComponent" と名付けたコンポーネントを取得
HelloComponent helloComponent = (HelloComponent) SystemRepository.getObject("helloComponent");
// 環境設定ファイルに設定した "This is property file hello message!!" ではなく、
// システムプロパティに設定を記述した "This is system property hello message!!" がコンソールに表示される
helloComponent.printHello();
```

<details>
<summary>keywords</summary>

SystemRepository, HelloComponent, getObject, コンポーネント取得, DIコンテナ, システムプロパティ, 環境設定ファイル

</details>
