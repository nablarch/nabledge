# Form自動生成ツール

## 概要

Form自動生成ツールは、以下のファイルからアプリケーションで使用するFormのひな形を作成する。

- テーブル定義書または外部インタフェース設計書
- ドメイン定義書
- コード設計書

Formのひな形を自動生成することで、以下の作業が自動化できる。

- テーブル設計（外部インタフェース設計書）に従い、Formにプロパティを追加する。
- ドメイン定義に従い、Formの単項目精査で使用するアノテーションを設定する。

> **注意**: 外部インタフェース設計書は、データ形式が階層構造（XML形式またはJSON形式）かどうかでフォーマットが異なる。

## インプット別の命名ルール

### テーブル定義書をインプットとする場合

| 対象 | 命名ルール |
|---|---|
| クラス名 | テーブル名の頭文字および `_` の直後を大文字、それ以外を全て小文字にし、`_` を除いた名称に `環境設定ファイル`_ で指定したサフィックスを付与する |
| プロパティ名 | カラム物理名の `_` の直後を大文字、それ以外を全て小文字にし、`_` を除いた名称 |

例:
- テーブル名 `ORDER`、サフィックス `Entity` → クラス名 `OrderEntity`
- テーブル名 `ORDER_DETAIL`、サフィックスなし → クラス名 `OrderDetail`
- カラム名 `ID` → プロパティ名 `id`
- カラム名 `ITEM_CODE` → プロパティ名 `itemCode`

### 外部インタフェース設計書をインプットとする場合（階層構造型でない場合）

| 対象 | 命名ルール |
|---|---|
| クラス名 | ファイルIDまたは電文ID + レコード名称に `環境設定ファイル`_ で指定したサフィックスを付与する |
| プロパティ名 | 項目名称の先頭を小文字に変換したもの |

例:
- ファイルID `N21AA001`、レコード名称 `Header`、サフィックス `FormBase` → クラス名 `N21AA001HeaderFormBase`
- 電文ID `N21AA00S`、レコード名称 `UserInfo`、サフィックスなし → クラス名 `N21AA00SUserInfo`
- 項目名 `ItemCode` → プロパティ名 `itemCode`

### 外部インタフェース設計書をインプットとする場合（階層構造型の場合）

| 対象 | 命名ルール |
|---|---|
| クラス名（ルート） | ファイルIDまたは電文ID + レコード名称（1文字目を大文字に変換）に `環境設定ファイル`_ で指定したサフィックスを付与する |
| クラス名（ルート以外） | ファイルIDまたは電文ID + 項目ID（`[` と `]` を除去し1文字目を大文字に変換）にサフィックスを付与する |
| プロパティ名 | 非階層構造型と同じ |

例:
- ファイルID `N21AB001`、レコード名称 `header`、サフィックス `FormBase` → クラス名 `N21AB001HeaderFormBase`
- ファイルID `N21AB001`、項目ID `[data]`、サフィックス `FormBase` → クラス名 `N21AB001DataFormBase`

> **注意**: データタイプがオブジェクトの項目に対応するプロパティは本ツールで出力しない。クラス内に出力するプロパティがない場合、そのクラスは生成しない。

> **注意**: 階層構造型（XML形式）で項目IDに名前空間が指定される場合、`:` を除去し直後の文字を大文字にして読み替える。例: 項目ID `xml:record` → クラス名の一部として `XmlRecord`、項目ID `xml:name` → プロパティ名 `xmlName`

<details>
<summary>keywords</summary>

Form自動生成ツール, テーブル定義書, 外部インタフェース設計書, ドメイン定義書, コード設計書, Formひな形, プロパティ自動追加, バリデーションアノテーション, 階層構造, XML形式, JSON形式, クラス名命名規則, プロパティ名命名規則, 階層構造型, サフィックス, camelCase変換, アンダースコア除去, 名前空間

</details>

## ツール配置場所

本ツールはチュートリアルプロジェクトの `tool/formgenerator` ディレクトリに配置されている。

| ファイル/ディレクトリ | 説明 |
|---|---|
| `doc` | テーブル定義書等の配置場所（変更可能。環境設定ファイルを参照） |
| `resources` | 本ツールの設定ファイル配置場所 |
| `formgen.xml` | 本ツールを実行するためのAntビルドファイル |
| `formgen.properties` | Antビルドファイルのプロパティファイル（通常、変更の必要なし） |

特定のプロパティ名に合致するプロパティに対して、共通項目自動設定機能で使用するアノテーションを自動生成時に付与できる。

`FieldBlock` コンポーネントに `fieldAnnotation` プロパティとして `FieldAnnotation` を設定し、`annotationMapping` に特定のプロパティ名とアノテーションのマッピングを定義する。

**クラス**: `nablarch.tool.formgenerator.helper.FieldBlock`, `nablarch.tool.formgenerator.helper.FieldAnnotation`

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

tool/formgenerator, チュートリアルプロジェクト, formgen.xml, formgen.properties, doc, resources, Antビルドファイル, ツール配置, FieldBlock, FieldAnnotation, nablarch.tool.formgenerator.helper.FieldBlock, nablarch.tool.formgenerator.helper.FieldAnnotation, annotationMapping, templatePath, fieldAnnotation, @UserId, @CurrentDateTime, アノテーション自動付与, 共通項目自動設定

</details>

## テーブル定義書から自動生成する場合の設定ファイル

テーブル定義書を元にFormを自動生成する場合に使用する設定ファイル。

| ファイル | 説明 |
|---|---|
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromTableDesign.xml` | コンポーネント定義ファイル（設計書のレイアウト等） |
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromTableDesign.config` | 環境設定ファイル（出力ファイルのパス等） |
| `nablarch/tool/formgenerator/class_template.txt` | クラス全体のテンプレート |
| `nablarch/tool/formgenerator/accessor_template.txt` | アクセサ部のテンプレート |

<details>
<summary>keywords</summary>

formgeneratorFromTableDesign.xml, formgeneratorFromTableDesign.config, class_template.txt, accessor_template.txt, テーブル定義書, Form自動生成, 設定ファイル一覧

</details>

## 外部インタフェース設計書から自動生成する場合の設定ファイル

外部インタフェース設計書を元にFormを自動生成する場合に使用する設定ファイル。

| ファイル | 説明 |
|---|---|
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromIFDesign.config` | コンポーネント定義ファイル（設計書のレイアウト等） |
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromIFDesign.xml` | 環境設定ファイル（出力ファイルのパス等） |
| `nablarch/tool/formgenerator/if_class_template.txt` | クラス全体のテンプレート |
| `nablarch/tool/formgenerator/if_accessor_template.txt` | アクセサ部のテンプレート |
| `nablarch/tool/formgenerator/if_toMap_template.txt` | フィールドをMapに変換するメソッド部のテンプレート |
| `nablarch/tool/formgenerator/if_property_name_annotation_template.txt` | アクセサ部に付与するプロパティ名用アノテーションのテンプレート（単項目精査エラーメッセージのプレースホルダーとして利用） |

<details>
<summary>keywords</summary>

formgeneratorFromIFDesign.config, formgeneratorFromIFDesign.xml, if_class_template.txt, if_accessor_template.txt, if_toMap_template.txt, if_property_name_annotation_template.txt, 外部インタフェース設計書, Form自動生成, 設定ファイル一覧

</details>

## 共通の設定ファイル

テーブル定義書・外部インタフェース設計書共通の設定ファイル。

| ファイル | 説明 |
|---|---|
| `nablarch/tool/formgenerator/import_template.txt` | インポート部のテンプレート |
| `nablarch/tool/formgenerator/field_template.txt` | フィールド部のテンプレート |
| `nablarch/tool/formgenerator/constructor_assign_template.txt` | コンストラクタ代入部のテンプレート |

<details>
<summary>keywords</summary>

import_template.txt, field_template.txt, constructor_assign_template.txt, 共通設定ファイル, Form自動生成

</details>

## 環境設定ファイル

自動生成ツールの基本設定はこの環境設定ファイルで行う。設計書のレイアウトも含めNablarch標準のものを使用している場合、ファイルパス以外の設定変更は不要。

<details>
<summary>keywords</summary>

環境設定ファイル, ファイルパス設定, Nablarch標準レイアウト, Form自動生成設定, formgeneratorFromTableDesign.config, formgeneratorFromIFDesign.config

</details>

## 入力元となる設計書に関する設定

テーブル定義書の場合と外部インタフェース設計書の場合で設定キーが異なる。

**テーブル定義書を元に自動生成する場合**（formgeneratorFromTableDesign.config）:

| キー名 | 設定内容 |
|---|---|
| tableDefinitionFilePath | テーブル定義書のファイルパス |
| domainDefinitionFilePath | ドメイン定義書のファイルパス |
| codeDesignFilePath | コード設計書のファイルパス |
| tablePrefix | テーブル物理名のプレフィックス（例：一律`T_`を付与する場合は`T_`を指定） |
| classSuffix | 生成するJavaクラスのサフィックス（例：`XxxEntity`とする場合は`Entity`を指定） |

**外部インタフェース設計書を元に自動生成する場合**（formgeneratorFromIFDesign.config）:

| キー名 | 設定内容 |
|---|---|
| interfaceFileDir | 外部インタフェース設計書が置かれているディレクトリ |
| interfaceFileNamePattern | 自動生成対象の外部インタフェース設計書を正規表現で指定（例：`.*.xls`で全EXCELが対象、ファイル名完全一致指定も可） |
| domainDefinitionFilePath | ドメイン定義書のファイルパス |
| codeDesignFilePath | コード設計書のファイルパス |
| classSuffix | 生成するJavaクラスのサフィックス（例：`XxxForm`とする場合は`Form`を指定） |

<details>
<summary>keywords</summary>

tableDefinitionFilePath, domainDefinitionFilePath, codeDesignFilePath, tablePrefix, classSuffix, interfaceFileDir, interfaceFileNamePattern, 設計書パス設定, テーブル定義書設定, 外部インタフェース設計書設定

</details>

## ファイル生成に関する設定

ファイル生成に関する設定（環境設定ファイルに記述）:

| キー名 | 設定内容 |
|---|---|
| outputDir | ファイル出力先ディレクトリ |
| templateEncoding | テンプレートファイルのファイルエンコーディング |
| outputEncoding | 出力ファイルのファイルエンコーディング |
| lineSeparator | 出力ファイル改行（`CR`、`LF`、`CRLF`のいずれか） |
| spaceSizeForIndent | インデントに使用するスペースの数 |

<details>
<summary>keywords</summary>

outputDir, templateEncoding, outputEncoding, lineSeparator, spaceSizeForIndent, ファイル出力設定, エンコーディング設定, 改行コード設定

</details>

## コンポーネント定義ファイル

コンポーネント定義ファイルには、設計書からどのように情報を読み取るかの設定が記載されている。

読み取り対象の設計書に以下の変更が生じた場合、コンポーネント定義ファイルの修正が必要:

| 変更内容 | 修正対象プロパティ名 |
|---|---|
| 設計書シート名の変更 | sheetName |
| 列の追加（読み取り対象カラムの位置がずれた場合） | indexNamePairs |
| 行の追加（読み取り開始行がずれた場合） | startRowIndex |

<details>
<summary>keywords</summary>

sheetName, indexNamePairs, startRowIndex, コンポーネント定義, 設計書読み取り設定, シート設定, カラム位置設定

</details>

## 入力元ファイル読み取り設定

ドメイン定義書を読み取る設定例（`nablarch.tool.formgenerator.loader.poi.DomainDefinitionLoader` および `nablarch.tool.formgenerator.loader.poi.util.XlsColumnDefs` を使用）:

```xml
<component name="domainDefinitionLoader"
           class="nablarch.tool.formgenerator.loader.poi.DomainDefinitionLoader">
  <!-- 入力元ファイルのパス -->
  <property name="pathToBook" value="${inputBasePath}/${domainDefinitionFileName}"/>
  <!-- 読み込み対象シート名 -->
  <property name="sheetName" value="ドメイン定義"/>
  <!-- 読み取り開始行（0オリジン） -->
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

DomainDefinitionLoader, nablarch.tool.formgenerator.loader.poi.DomainDefinitionLoader, XlsColumnDefs, nablarch.tool.formgenerator.loader.poi.util.XlsColumnDefs, domainDefinitionLoader, domainDefinitionColumnDefs, ドメイン定義書読み取り, columnDefs, pathToBook, indexNamePairs

</details>

## データベースまたは外部インターフェース上の型 - Java型マッピング設定

DBデータ型または外部インタフェース上の型とJavaデータ型の対応関係を設定する。この設定に基づいて生成されるFormのプロパティのデータ型が決定する。各プロジェクトで使用するRDBMSや設計書の標準に応じて設定する。

> **注意**: RDBMSがサポートする全ての型を網羅する必要はなく、プロジェクトで使用するものだけを記載すれば良い。

**クラス**: `nablarch.tool.formgenerator.helper.DataTypeMapping`

キーをDB型または外部インタフェース上の型、値をJava型としてMap形式で記載する。

テーブル定義書の場合の設定例:
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

外部インタフェース設計書の場合の設定例:
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

DataTypeMapping, nablarch.tool.formgenerator.helper.DataTypeMapping, dataTypeMapping, データ型マッピング, DB型とJava型の対応, NCHAR, NVARCHAR2, NUMBER, TIMESTAMP, 型対応表, 半角数字, 半角, 符号無ゾーン10進数, 符号無数値

</details>

## テンプレート

自動生成ツールが出力するFormのひな形のテンプレートファイル。`$` または `#` で囲まれた置き換え文字を置き換えてソースコードを自動生成する。

| ファイル | 説明 |
|---|---|
| `nablarch/tool/formgenerator/class_template.txt` | クラス全体のテンプレート |
| `nablarch/tool/formgenerator/import_template.txt` | インポート部のテンプレート |
| `nablarch/tool/formgenerator/field_template.txt` | フィールド部のテンプレート |
| `nablarch/tool/formgenerator/constructor_assign_template.txt` | コンストラクタ代入部のテンプレート |
| `nablarch/tool/formgenerator/toMap_template.txt` | フィールドをMapに変換するメソッド部のテンプレート |
| `nablarch/tool/formgenerator/accessor_template.txt` | アクセサ部のテンプレート |
| `nablarch/tool/formgenerator/property_name_annotation_template.txt` | PropertyNameアノテーションのテンプレート |

個別に設定が必要な箇所はクラスヘッダの `@author` のみ。Formのクラス名の命名ルールを変更するなどのプロジェクト固有のルールがある場合は必要に応じて変更する。

使用できる置き換え文字:

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
| `#FIELD_TO_MAP#` | フィールドからMapへの代入 |
| `#ACCESSORS#` | アクセサ定義 |
| `#SETTER_ANNOTATIONS#` | Setterに対するアノテーション |
| `#PROPERTY_NAME_ANNOTATION#` | PropertyNameアノテーション |

<details>
<summary>keywords</summary>

class_template.txt, import_template.txt, field_template.txt, constructor_assign_template.txt, accessor_template.txt, property_name_annotation_template.txt, toMap_template.txt, $TABLE_LNAME$, $TABLE_PNAME$, $JAVA_CLASS$, $PROP_LNAME$, $PROP_PNAME$, $PROP_TYPE$, $GETTER$, $SETTER$, #PACKAGE#, #VALIDATION_IMPORTS#, #FIELDS#, #FIELD_ANNOTATION#, #PARAM_TO_FIELD#, #FIELD_TO_MAP#, #ACCESSORS#, #SETTER_ANNOTATIONS#, #PROPERTY_NAME_ANNOTATION#, テンプレート置き換え文字, @author設定

</details>

## 自動生成ツールの実行手順

Entityの自動生成を行うAntコマンド:

```bash
# テーブル定義書を入力とする場合
ant -f formgen.xml generate-entity
# 外部IF設計書を入力とする場合
ant -f formgen.xml generate-form
```

<details>
<summary>keywords</summary>

ant -f formgen.xml, generate-entity, generate-form, Ant実行, 自動生成実行, テーブル定義書入力, 外部IF設計書入力

</details>

## Entity 出力の仕様

なし

<details>
<summary>keywords</summary>

Entity出力, 自動生成仕様詳細, Form自動生成ツール仕様

</details>
