# Form自動生成ツール

## 概要

Form自動生成ツールの概要。以下の3種類の入力ファイルからアプリケーションで使用するFormのひな形を作成するツール。

**入力ファイル**
- テーブル定義書または外部インタフェース設計書
- ドメイン定義書
- コード設計書

**自動化される作業**
- テーブル設計（外部インタフェース設計書）に従い、Formにプロパティを追加する
- ドメイン定義に従い、Formの単項目精査で使用するアノテーションを設定する

特定のプロパティ名に一致するプロパティに対し、共通項目自動設定機能用アノテーションを自動生成時に付与できる。

**クラス**: `nablarch.tool.formgenerator.helper.FieldBlock`, `nablarch.tool.formgenerator.helper.FieldAnnotation`

**アノテーション**: `@UserId`, `@CurrentDateTime`

`FieldBlock` の `fieldAnnotation` プロパティに `FieldAnnotation` コンポーネントを設定し、`annotationMapping` にプロパティ名→アノテーション名のマッピングを定義する。

```xml
<component name="fieldBlock"
           class="nablarch.tool.formgenerator.helper.FieldBlock">
  <property name="templatePath" value="classpath:nablarch/tool/formgenerator/field_template.txt"/>
  <property name="fieldAnnotation">
    <component name="fieldAnnotationBlock"
               class="nablarch.tool.formgenerator.helper.FieldAnnotation">
      <property name="annotationMapping">
        <map>
          <entry key="INSERT_USER_ID" value="@UserId"/>
          <entry key="INSERT_DATE_TIME" value="@CurrentDateTime"/>
          <entry key="UPDATE_USER_ID" value="@UserId"/>
          <entry key="UPDATE_DATE_TIME" value="@CurrentDateTime"/>
        </map>
      </property>
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

Form自動生成ツール, 概要, テーブル定義書, 外部インタフェース設計書, ドメイン定義書, コード設計書, Formひな形, 単項目精査アノテーション, プロパティ自動追加, FieldBlock, FieldAnnotation, nablarch.tool.formgenerator.helper.FieldBlock, nablarch.tool.formgenerator.helper.FieldAnnotation, @UserId, @CurrentDateTime, fieldAnnotation, annotationMapping, templatePath, 共通項目自動設定, アノテーション自動付与, フォームジェネレータ

</details>

## テーブル定義書から自動生成する場合の設定ファイル

テーブル定義書からForm自動生成する場合の設定ファイル。

| ファイル | 説明 |
|---|---|
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromTableDesign.xml` | コンポーネント定義ファイル（設計書のレイアウト等） |
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromTableDesign.config` | 環境設定ファイル（出力ファイルのパス等） |

<details>
<summary>keywords</summary>

formgeneratorFromTableDesign.xml, formgeneratorFromTableDesign.config, コンポーネント定義ファイル, 環境設定ファイル, テーブル定義書, Form自動生成

</details>

## 外部インタフェース設計書から自動生成する場合の設定ファイル

外部インタフェース設計書からForm自動生成する場合の設定ファイル。

| ファイル | 説明 |
|---|---|
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromIFDesign.config` | コンポーネント定義ファイル（設計書のレイアウト等） |
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromIFDesign.xml` | 環境設定ファイル（出力ファイルのパス等） |

<details>
<summary>keywords</summary>

formgeneratorFromIFDesign.config, formgeneratorFromIFDesign.xml, 外部インタフェース設計書, Form自動生成

</details>

## 共通の設定ファイル

自動生成ツールで使用する共通テンプレートファイル。

| ファイル | 説明 |
|---|---|
| `nablarch/tool/formgenerator/class_template.txt` | クラス全体のテンプレート |
| `nablarch/tool/formgenerator/import_template.txt` | インポート部のテンプレート |
| `nablarch/tool/formgenerator/field_template.txt` | フィールド部のテンプレート |
| `nablarch/tool/formgenerator/constructor_assign_template.txt` | コンストラクタ代入部のテンプレート |
| `nablarch/tool/formgenerator/accessor_template.txt` | アクセサ部のテンプレート |

<details>
<summary>keywords</summary>

class_template.txt, import_template.txt, field_template.txt, constructor_assign_template.txt, accessor_template.txt, テンプレートファイル, Form自動生成共通設定

</details>

## 環境設定ファイル

基本的な設定を行うファイル。Nablarch標準のレイアウトを使用している場合、ファイルパス以外は修正不要。

<details>
<summary>keywords</summary>

環境設定ファイル, ファイルパス設定, Nablarch標準レイアウト, Form自動生成設定

</details>

## 入力元となる設計書に関する設定

**テーブル定義書から自動生成する場合** (`formgeneratorFromTableDesign.config`)

| キー名 | 設定内容 |
|---|---|
| `tableDefinitionFilePath` | テーブル定義書のファイルパス |
| `domainDefinitionFilePath` | ドメイン定義書のファイルパス |
| `codeDesignFilePath` | コード設計書のファイルパス |
| `tablePrefix` | テーブル物理名のプレフィックス（例：`T_`を付与する場合は`T_`を指定） |
| `classSuffix` | 生成するJavaクラスに付与するサフィックス（例：`XxxEntity`とする場合は`Entity`を指定） |

**外部インタフェース設計書から自動生成する場合** (`formgeneratorFromIFDesign.config`)

| キー名 | 設定内容 |
|---|---|
| `interfaceFileDir` | 外部インタフェース設計書が置かれているディレクトリ |
| `interfaceFileNamePattern` | 自動生成対象の外部インタフェース設計書を正規表現で指定（例：`.*.xls`で全Excel対象） |
| `domainDefinitionFilePath` | ドメイン定義書のファイルパス |
| `codeDesignFilePath` | コード設計書のファイルパス |
| `classSuffix` | 生成するJavaクラスに付与するサフィックス（例：`XxxForm`とする場合は`Form`を指定） |

<details>
<summary>keywords</summary>

tableDefinitionFilePath, domainDefinitionFilePath, codeDesignFilePath, tablePrefix, classSuffix, interfaceFileDir, interfaceFileNamePattern, 入力元設定, 設計書パス設定

</details>

## ファイル生成に関する設定

| キー名 | 設定内容 |
|---|---|
| `outputDir` | ファイル出力先ディレクトリ |
| `templateEncoding` | テンプレートファイルのエンコーディング |
| `outputEncoding` | 出力ファイルのエンコーディング |
| `lineSeparator` | 出力ファイルの改行コード（`"CR"`, `"LF"`, `"CRLF"` のいずれか） |
| `spaceSizeForIndent` | インデントに使用するスペースの数 |

<details>
<summary>keywords</summary>

outputDir, templateEncoding, outputEncoding, lineSeparator, spaceSizeForIndent, ファイル出力設定, エンコーディング設定

</details>

## コンポーネント定義ファイル

設計書からの情報読み取り設定を記述するファイル。設計書に以下の変更が生じた場合、対応するプロパティを修正する必要がある。

| 変更内容 | 修正対象プロパティ |
|---|---|
| 設計書シート名の変更 | `sheetName` |
| 列の追加（読み取り対象カラムの位置ずれ） | `indexNamePairs` |
| 行の追加（読み取り開始行のずれ） | `startRowIndex` |

<details>
<summary>keywords</summary>

sheetName, indexNamePairs, startRowIndex, コンポーネント定義ファイル, 設計書読み取り設定

</details>

## 入力元ファイル読み取り設定

ドメイン定義書の読み取り設定例（`DomainDefinitionLoader` と `XlsColumnDefs` を使用）。

```xml
<component name="domainDefinitionLoader"
           class="nablarch.tool.formgenerator.loader.poi.DomainDefinitionLoader">
  <property name="pathToBook" value="${inputBasePath}/${domainDefinitionFileName}"/>
  <property name="sheetName" value="ドメイン定義"/>
  <property name="startRowIndex" value="5"/>
  <property name="columnDefs" ref="domainDefinitionColumnDefs"/>
  <property name="dataTypeDefinitionLoader" ref="dataTypeDefinitionLoader"/>
</component>
<component name="domainDefinitionColumnDefs"
           class="nablarch.tool.formgenerator.loader.poi.util.XlsColumnDefs">
  <property name="indexNamePairs">
    <map>
      <entry key="0" value="domainLogicalName"/>
      <entry key="5" value="description"/>
      <entry key="14" value="dataTypeName"/>
      <entry key="17" value="eqOrLe"/>
      <entry key="18" value="precision"/>
      <entry key="20" value="fraction"/>
      <entry key="22" value="dataTypeDetail"/>
    </map>
  </property>
</component>
```

<details>
<summary>keywords</summary>

DomainDefinitionLoader, XlsColumnDefs, pathToBook, columnDefs, domainDefinitionColumnDefs, ドメイン定義書読み取り, Excelレイアウト設定

</details>

## データベースまたは外部インターフェース上の型 - Java型マッピング設定

DBのデータ型または外部インタフェース上の型とJava型のマッピング設定。この設定に基づいて生成されるFormプロパティのデータ型が決定される。プロジェクトで使用するRDBMSや設計書の標準に応じて設定する。

> **注意**: プロジェクトで使用する型のみを記載すればよい。RDBMSがサポートする全型を網羅する必要はない。

DB型マッピング例：

```xml
<component name="dataTypeMapping" class="nablarch.tool.formgenerator.helper.DataTypeMapping">
  <property name="mapping">
    <map>
      <entry key="NCHAR" value="java.lang.String"/>
      <entry key="NVARCHAR2" value="java.lang.String"/>
      <entry key="NUMBER" value="java.math.BigDecimal"/>
      <entry key="TIMESTAMP" value="java.sql.Timestamp"/>
    </map>
  </property>
</component>
```

外部インタフェース設計上の型マッピング例：

```xml
<component name="dataTypeMapping" class="nablarch.tool.formgenerator.helper.DataTypeMapping">
  <property name="mapping">
    <map>
      <entry key="半角数字" value="java.lang.String"/>
      <entry key="半角" value="java.lang.String"/>
      <entry key="符号無ゾーン10進数" value="java.math.BigDecimal"/>
      <entry key="符号無数値" value="java.math.BigDecimal"/>
    </map>
  </property>
</component>
```

<details>
<summary>keywords</summary>

DataTypeMapping, dataTypeMapping, データ型マッピング, DB型, Java型変換, Formプロパティ型

</details>

## テンプレート

テンプレートファイルの個別設定箇所は基本的にクラスヘッダの `@author` のみ。Formのクラス名命名ルールを変更するなどプロジェクト固有のルールがある場合は必要に応じて変更する。

置き換え文字一覧（`$...$` または `#...#` で挟まれた文字が置き換えられる）：

| 置き換え文字 | 置き換えられる文字列 |
|---|---|
| `$TABLE_LNAME$` | Entityに対応するテーブル論理名 |
| `$TABLE_PNAME$` | Entityに対応するテーブル物理名 |
| `$JAVA_CLASS$` | Javaクラス名 |
| `$PROP_LNAME$` | プロパティ論理名 |
| `$PROP_PNAME$` | プロパティ物理名 |
| `$PROP_TYPE$` | プロパティの型 |
| `$GETTER$` | Getterメソッド名 |
| `$SETTER$` | Setterメソッド名 |
| `#PACKAGE#` | パッケージ宣言 |
| `#VALIDATION_IMPORTS#` | 精査アノテーションのimport文 |
| `#FIELDS#` | フィールド定義 |
| `#FIELD_ANNOTATION#` | フィールドに対するアノテーション |
| `#PARAM_TO_FIELD#` | Mapパラメータからフィールドへの代入 |
| `#ACCESSORS#` | アクセサ定義 |
| `#SETTER_ANNOTATIONS#` | Setterに対するアノテーション |

<details>
<summary>keywords</summary>

$TABLE_LNAME$, $TABLE_PNAME$, $JAVA_CLASS$, $PROP_LNAME$, $PROP_PNAME$, $PROP_TYPE$, $GETTER$, $SETTER$, #PACKAGE#, #VALIDATION_IMPORTS#, #FIELDS#, #FIELD_ANNOTATION#, #PARAM_TO_FIELD#, #ACCESSORS#, #SETTER_ANNOTATIONS#, 置き換え文字, テンプレート変数, @author設定

</details>

## 自動生成ツールの実行手順

Antを使ったForm自動生成の実行コマンド：

```bash
# テーブル定義書を入力とする場合
ant -f formgen.xml generate-entity
# 外部IF設計書を入力とする場合
ant -f formgen.xml generate-form
```

<details>
<summary>keywords</summary>

generate-entity, generate-form, ant, formgen.xml, 自動生成実行, Entity自動生成

</details>

## Entity のクラス名とプロパティ名

**テーブル定義書をインプットとする場合**

| 対象 | 命名ルール |
|---|---|
| クラス名 | テーブル名の頭文字および`_`の直後を大文字、それ以外を小文字にし`_`を除いた上で`classSuffix`のサフィックスを付与（例：`ORDER`+`Form`→`OrderForm`、`ORDER_DETAIL`+サフィックスなし→`OrderDetail`） |
| プロパティ名 | カラム物理名の`_`の直後を大文字、それ以外を小文字にし`_`を除いた名称（例：`ID`→`id`、`ITEM_CODE`→`itemCode`） |

**外部インタフェース設計書をインプットとする場合**

| 対象 | 命名ルール |
|---|---|
| クラス名 | ファイルID+レコード名称に`classSuffix`のサフィックスを付与（例：`N21AA001`+`Header`+`Form`→`N21AA001HeaderForm`） |
| プロパティ名 | 項目名称の先頭を小文字に変換（例：`ItemCode`→`itemCode`） |

<details>
<summary>keywords</summary>

クラス名命名ルール, プロパティ名命名ルール, classSuffix, アンダースコア変換, キャメルケース, テーブル名からクラス名, カラム名からプロパティ名

</details>
