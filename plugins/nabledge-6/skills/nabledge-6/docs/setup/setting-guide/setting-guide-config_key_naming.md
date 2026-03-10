# 環境設定値の項目名ルール

**公式ドキュメント**: [環境設定値の項目名ルール](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/setting_guide/CustomizingConfigurations/config_key_naming.html)

## 全般的なルール

設定項目の命名ルール:

- 項目名はlowerCamelCaseで記述する
- 区切り文字に`.`（ドット）を使用する

<details>
<summary>keywords</summary>

設定項目名ルール, lowerCamelCase, ドット区切り, 命名規則

</details>

## 共通プレフィックス

Nablarchがデフォルトで用意する設定項目の項目名には、プレフィックス`nablarch.`が付与される。これにより名前空間となり、適用PJとの項目名重複を防止できる。また、ある設定項目がNablarchデフォルトのものか、PJで個別に作成したものかを判別できる。

> **補足**: PJが個別に作成する項目についても、所定のプレフィックスを付与することを推奨する。これはPJ個別の項目を検索しやすくするためである。

<details>
<summary>keywords</summary>

nablarch., 共通プレフィックス, 名前空間, プレフィックス規則, 項目名重複防止

</details>

## 単一のコンポーネント内でのみ使用される設定項目

単一のコンポーネント内でのみ使用される設定項目の命名ルール:

```
nablarch.<コンポーネント名>.<プロパティ名>
```

**例**:

```bash
# コードを起動時に読み込むかどうか
nablarch.codeCache.loadOnStartUp=true
```

この設定項目は、実際は以下のコンポーネント定義で使用される。

```xml
<!-- コンポーネント名は 'codeCache' -->
<component name="codeCache"
           class="nablarch.core.cache.BasicStaticDataCache">

  <!-- プロパティ名は 'loadOnStartUp' -->
  <property name="loadOnStartup" value="${nablarch.codeCache.loadOnStartUp}"/>

  <!-- 中略 -->
</component>
```

この場合、`codeCache`がコンポーネント名、`loadOnStartUp`がそのコンポーネントのプロパティ名であり、共通プレフィックス`nablarch.`が付与されるので、`nablarch.codeCache.loadOnStartUp`となる。このルールにより、ある項目がどのコンポーネントで使用されるものかを調査しやすくなる。

<details>
<summary>keywords</summary>

nablarch.<コンポーネント名>.<プロパティ名>, コンポーネント設定項目, 単一コンポーネント命名, nablarch.codeCache.loadOnStartUp, BasicStaticDataCache

</details>

## 複数のコンポーネント定義に跨る設定項目

複数のコンポーネント定義に跨る設定項目の命名ルール:

```
nablarch.commonProperty.<項目名>
```

<details>
<summary>keywords</summary>

nablarch.commonProperty, 複数コンポーネント共通プロパティ, commonProperty命名

</details>

## DBテーブルのスキーマ情報

Nablarch Application Frameworkが使用するテーブルのスキーマ情報の命名ルール:

```
nablarch.<Nablarchデフォルトのテーブル名>Table.<各種設定値>
```

**例**（メッセージ機能のデフォルトテーブル名`MESSAGE`の場合）:

```bash
# メッセージテーブルのテーブル物理名
nablarch.messageTable.tableName=MESSAGE
# メッセージテーブルのIDカラム物理名
nablarch.messageTable.idColumnName=MESSAGE_ID
# メッセージテーブルの言語カラム物理名
nablarch.messageTable.langColumnName=LANG
# メッセージテーブルのメッセージカラム物理名
nablarch.messageTable.valueColumnName=MESSAGE
```

> **補足**: Nablarch Application Frameworkが使用するテーブルをデフォルト値のまま使用する場合は、この設定値を意識する必要はない。

<details>
<summary>keywords</summary>

nablarch.<テーブル名>Table.<設定値>, DBテーブルスキーマ設定, nablarch.messageTable.tableName, テーブル物理名設定, スキーマ情報命名

</details>
