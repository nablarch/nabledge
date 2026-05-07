# ファイルパス管理

**目次**

* 機能概要

  * ディレクトリや拡張子を論理名で管理できる
* モジュール一覧
* 使用方法

  * ディレクトリと拡張子を設定する
* 論理名が示すファイルパスを取得する

システムで使用するファイルの入出力先のディレクトリや拡張子を管理するための機能を提供する。

## 機能概要

### ディレクトリや拡張子を論理名で管理できる

ディレクトリや拡張子を論理名で管理することが出来る。

ファイルの入出力などを行う機能では、論理名を指定するだけでそのディレクトリ配下のファイルに対する入出力が実現出来る。

詳細は、 [ディレクトリと拡張子を設定する](../../component/libraries/libraries-file-path-management.md#file-path-management-definition) を参照

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

## 使用方法

### ディレクトリと拡張子を設定する

FilePathSetting にディレクトリ及び拡張子を設定し、
コンポーネント設定ファイルに定義する。

以下に例を示す。

ポイント

* FilePathSetting のコンポーネント名は `filePathSetting` とすること
* basePathSettings にディレクトリを設定する
* fileExtensions に拡張子を設定する
* 1つのディレクトリに対して複数の拡張子を設定する場合には、論理名を複数設定する
* 拡張子のないファイルの場合には、その論理名の拡張子設定を省略する
* スキームは `file` と `classpath` が使用できる。省略した場合は、 `classpath` となる
* `classpath` スキームの場合、そのパスがディレクトリとして存在している必要がある。(jarなどのアーカイブされたファイル内のパスは指定できない)
* パスにはスペースを含めない。（スペースが含まれているパスは指定できない）

> **Important:**
> classpathスキームを使用した場合、一部のウェブアプリケーションサーバでは本機能を使用できない。
> これは、ウェブアプリケーションサーバが独自のファイルシステムを使用して、
> クラスパス配下のリソースなどを管理していることに起因する。

> 例えば、JbossやWildflyでは、vfsと呼ばれるバーチャルファイルシステムで、
> クラスパス配下のリソースが管理されるため、classpathスキームは使用できない。

> このため、classpthスキームではなくfileスキームを使用することを推奨する。

```xml
<component name="filePathSetting" class="nablarch.core.util.FilePathSetting">
  <!-- ディレクトリの設定 -->
  <property name="basePathSettings">
    <map>
      <entry key="csv-input" value="file:/var/nablarch/input" />
      <entry key="csv-output" value="file:/var/nablarch/output" />

      <entry key="dat-input" value="file:/var/nablarch/input" />
      <entry key="fixed-file-input" value="file:/var/nablarch/input" />
    </map>
  </property>

  <!-- 拡張子の設定 -->
  <property name="fileExtensions">
    <map>
      <entry key="csv-input" value="csv" />
      <entry key="csv-output" value="csv" />

      <entry key="dat-input" value="dat" />

      <!-- fixed-file-inputは拡張子が存在しないので、拡張子の設定は行わない -->
    </map>
  </property>

</component>
```

## 論理名が示すファイルパスを取得する

FilePathSetting を使用して、論理名に対応するファイルパスを取得する。

以下に幾つかの使用例を示す。

```java
// /var/nablarch/input/users.csv
File users = filePathSetting.getFileWithoutCreate("csv-input", "users")

//  /var/nablarch/output
File csvOutputDir = filePathSetting.getBaseDirectory("csv-output");

// /var/nablarch/input/users
File users = filePathSetting.getFileWithoutCreate("fixed-file-input", "users")
```
