# 環境設定値の項目名ルール

## 全般的なルール

設定項目の命名ルール:

- 項目名はlowerCamelCaseで記述する
- 区切り文字に`.`（ドット）を使用する

## 共通プレフィックス

Nablarchがデフォルトで用意する設定項目の項目名には、プレフィックス`nablarch.`が付与される。これにより名前空間となり、適用PJとの項目名重複を防止できる。また、ある設定項目がNablarchデフォルトのものか、PJで個別に作成したものかを判別できる。

> **補足**: PJが個別に作成する項目についても、所定のプレフィックスを付与することを推奨する。これはPJ個別の項目を検索しやすくするためである。

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

## 複数のコンポーネント定義に跨る設定項目

複数のコンポーネント定義に跨る設定項目の命名ルール:

```
nablarch.commonProperty.<項目名>
```

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
