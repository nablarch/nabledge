# 環境設定値の項目名ルール

**公式ドキュメント**: [環境設定値の項目名ルール](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/setting_guide/CustomizingConfigurations/config_key_naming.html)

## 全般的なルール

項目名の命名ルール:
- 項目名はlowerCamelCaseで記述する
- 区切り文字に `.`（ドット）を使用する

<details>
<summary>keywords</summary>

lowerCamelCase, 区切り文字, ドット区切り, 命名ルール, 環境設定値, 項目名ルール

</details>

## 共通プレフィックス

Nablarchデフォルトの設定項目には `nablarch.` プレフィックスが付与される。これにより名前空間となり、適用PJと項目名が重複することを防止し、Nablarchデフォルト項目かPJ個別項目かを判別できる。

```bash
# コードを起動時に読み込むかどうか
nablarch.codeCache.loadOnStartUp=true
```

> **補足**: PJ個別に作成する項目にも所定のプレフィックスを付与することを推奨する（PJ個別の項目を検索しやすくするため）。

<details>
<summary>keywords</summary>

nablarch.プレフィックス, 名前空間, 項目名重複防止, Nablarchデフォルト設定, PJ個別設定, 設定項目識別

</details>

## 単一のコンポーネント内でのみ使用される設定項目

命名ルール: `nablarch.<コンポーネント名>.<プロパティ名>`

```bash
# コードを起動時に読み込むかどうか
nablarch.codeCache.loadOnStartUp=true
```

```xml
<!-- コンポーネント名は 'codeCache' -->
<component name="codeCache"
           class="nablarch.core.cache.BasicStaticDataCache">
  <!-- プロパティ名は 'loadOnStartUp' -->
  <property name="loadOnStartup" value="${nablarch.codeCache.loadOnStartUp}"/>
</component>
```

この命名ルールにより、ある項目がどのコンポーネントで使用されるものか調査が容易になる。

<details>
<summary>keywords</summary>

nablarch.<コンポーネント名>.<プロパティ名>, コンポーネント名, プロパティ名, codeCache, loadOnStartUp, BasicStaticDataCache, 単一コンポーネント設定

</details>

## 複数のコンポーネント定義に跨る設定項目

複数のコンポーネント定義に跨る設定項目の命名ルール: `nablarch.commonProperty.<項目名>`

<details>
<summary>keywords</summary>

nablarch.commonProperty, 共通プロパティ, 複数コンポーネント, 共通設定項目

</details>

## DBテーブルのスキーマ情報

Nablarch Application Frameworkが使用するテーブルのスキーマ情報の命名ルール: `nablarch.<Nablarchデフォルトのテーブル名>Table.<各種設定値>`

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

nablarch.<テーブル名>Table, スキーマ情報, messageTable, tableName, idColumnName, langColumnName, valueColumnName, テーブルスキーマ設定

</details>
