# ファイルパス管理

## 機能概要

システムで使用するファイルの入出力先ディレクトリや拡張子を論理名で管理する機能。論理名を指定するだけで、そのディレクトリ配下のファイルに対する入出力を実現できる。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

## 使用方法

**クラス**: `nablarch.core.util.FilePathSetting`

設定のポイント:
- コンポーネント名は `filePathSetting` とすること
- `basePathSettings` にディレクトリを設定する
- `fileExtensions` に拡張子を設定する
- 1つのディレクトリに複数の拡張子を設定する場合は、論理名を複数設定する
- 拡張子のないファイルの場合は、その論理名の拡張子設定を省略する
- スキームは `file` と `classpath` が使用できる。省略した場合は `classpath` となる
- `classpath` スキームの場合、パスがディレクトリとして存在している必要がある（jarなどのアーカイブ内のパスは指定不可）
- パスにスペースを含めない

> **重要**: classpathスキームを使用した場合、一部のウェブアプリケーションサーバ（JBoss/Wildflyなど）では使用できない。これらはvfsなどの独自ファイルシステムでクラスパス配下のリソースを管理しているため。fileスキームの使用を推奨する。

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
      <!-- fixed-file-inputは拡張子が存在しないので設定しない -->
    </map>
  </property>
</component>
```

## 論理名が示すファイルパスを取得する

`FilePathSetting` を使用して論理名に対応するファイルパスを取得する。

```java
// /var/nablarch/input/users.csv
File users = filePathSetting.getFileWithoutCreate("csv-input", "users")

// /var/nablarch/output
File csvOutputDir = filePathSetting.getBaseDirectory("csv-output");

// /var/nablarch/input/users
File users = filePathSetting.getFileWithoutCreate("fixed-file-input", "users")
```
