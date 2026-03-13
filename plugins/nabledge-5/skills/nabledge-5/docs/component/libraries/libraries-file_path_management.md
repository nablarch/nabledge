# ファイルパス管理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/file_path_management.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/util/FilePathSetting.html)

## 機能概要

ディレクトリや拡張子を論理名で管理する機能。ファイルの入出力機能では、論理名を指定するだけでそのディレクトリ配下のファイルへの入出力が実現できる。

<details>
<summary>keywords</summary>

FilePathSetting, ファイルパス管理, 論理名管理, ディレクトリ管理, 拡張子管理

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core, com.nablarch.framework, モジュール依存関係

</details>

## 使用方法

`FilePathSetting` をコンポーネント設定ファイルに定義する。

設定ポイント:
- コンポーネント名は `filePathSetting` とすること
- `basePathSettings` にディレクトリを設定する
- `fileExtensions` に拡張子を設定する
- 1つのディレクトリに複数の拡張子を設定する場合は論理名を複数設定する
- 拡張子なしのファイルはその論理名の拡張子設定を省略する
- スキームは `file` または `classpath` が使用可能。省略時は `classpath`
- `classpath` スキームはパスがディレクトリとして存在している必要がある（jarなどのアーカイブ内のパスは指定不可）
- パスにスペースを含めない

> **重要**: classpathスキームは一部のWebアプリケーションサーバでは使用できない。JBoss/Wildflyではvfsというバーチャルファイルシステムが使用されるためclasspathスキームは使用不可。**fileスキームの使用を推奨する**。

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

<details>
<summary>keywords</summary>

FilePathSetting, basePathSettings, fileExtensions, fileスキーム, classpathスキーム, コンポーネント設定, ファイルパス設定, filePathSetting

</details>

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

<details>
<summary>keywords</summary>

FilePathSetting, getFileWithoutCreate, getBaseDirectory, ファイルパス取得, 論理名

</details>
