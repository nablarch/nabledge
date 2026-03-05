# ファイルパス管理

## 機能概要

ディレクトリや拡張子を論理名で管理できる。ファイル入出力機能では、論理名を指定するだけでそのディレクトリ配下のファイルに対する入出力が可能。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

## 使用方法

**クラス**: `FilePathSetting`にディレクトリ及び拡張子を設定し、コンポーネント設定ファイルに定義する。

**設定ルール**:
- コンポーネント名は`filePathSetting`とすること
- `basePathSettings`にディレクトリを設定
- `fileExtensions`に拡張子を設定
- 1つのディレクトリに対して複数の拡張子を設定する場合には、論理名を複数設定する
- 拡張子のないファイルの場合には、その論理名の拡張子設定を省略する
- スキームは`file`と`classpath`が使用可能。省略時は`classpath`
- `classpath`スキームの場合、そのパスがディレクトリとして存在している必要がある（jarなどのアーカイブされたファイル内のパスは指定不可）
- パスにはスペースを含めない

> **重要**: classpathスキームを使用した場合、一部のウェブアプリケーションサーバ（JBoss、WildFly等）では本機能を使用できない。これらはvfsと呼ばれるバーチャルファイルシステムでクラスパス配下のリソースを管理するため。fileスキームの使用を推奨。

**設定例**:
```xml
<component name="filePathSetting" class="nablarch.core.util.FilePathSetting">
  <property name="basePathSettings">
    <map>
      <entry key="csv-input" value="file:/var/nablarch/input" />
      <entry key="csv-output" value="file:/var/nablarch/output" />
      <entry key="dat-input" value="file:/var/nablarch/input" />
      <entry key="fixed-file-input" value="file:/var/nablarch/input" />
    </map>
  </property>
  <property name="fileExtensions">
    <map>
      <entry key="csv-input" value="csv" />
      <entry key="csv-output" value="csv" />
      <entry key="dat-input" value="dat" />
    </map>
  </property>
</component>
```

## 論理名が示すファイルパスを取得する

`FilePathSetting`を使用して、論理名に対応するファイルパスを取得する。

**使用例**:
```java
// /var/nablarch/input/users.csv
File users = filePathSetting.getFileWithoutCreate("csv-input", "users")

// /var/nablarch/output
File csvOutputDir = filePathSetting.getBaseDirectory("csv-output");

// /var/nablarch/input/users
File users = filePathSetting.getFileWithoutCreate("fixed-file-input", "users")
```
