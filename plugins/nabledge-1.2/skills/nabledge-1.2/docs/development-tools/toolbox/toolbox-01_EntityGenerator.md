# Form自動生成ツール

## テーブル定義書から自動生成する場合の設定ファイル

テーブル定義書からFormを自動生成する際に使用する設定ファイル:

| ファイル | 説明 |
|---|---|
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromTableDesign.xml` | コンポーネント定義ファイル（設計書のレイアウト等） |
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromTableDesign.config` | 環境設定ファイル（出力ファイルのパス等） |

実行コマンド: `ant -f formgen.xml generate-entity`

特定のプロパティ名に合致するプロパティに対して、共通項目自動設定機能で使用するアノテーションを自動生成時に付与できる。

例: 全フォームの `updateUserId`・`insertUserId` に `@UserId`、`insertDateTime`・`updatedDateTime` に `@CurrentDateTime` を付与する場合、`FieldBlock` に `FieldAnnotation` を設定し、`annotationMapping` でカラム名とアノテーションのマッピングを定義する。

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

formgeneratorFromTableDesign.xml, formgeneratorFromTableDesign.config, テーブル定義書, Form自動生成, 設定ファイル, generate-entity, FieldBlock, FieldAnnotation, fieldAnnotation, annotationMapping, 共通項目自動設定, アノテーション自動付与, フォームジェネレータ, @UserId, @CurrentDateTime, INSERT_USER_ID, UPDATE_USER_ID, INSERT_DATE_TIME, UPDATE_DATE_TIME

</details>

## 外部インタフェース設計書から自動生成する場合の設定ファイル

外部インタフェース設計書からFormを自動生成する際に使用する設定ファイル:

| ファイル | 説明 |
|---|---|
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromIFDesign.config` | コンポーネント定義ファイル（設計書のレイアウト等） |
| `nablarch/tool/formgenerator/loader/poi/formgeneratorFromIFDesign.xml` | 環境設定ファイル（出力ファイルのパス等） |

実行コマンド: `ant -f formgen.xml generate-form`

<details>
<summary>keywords</summary>

formgeneratorFromIFDesign.config, formgeneratorFromIFDesign.xml, 外部インタフェース設計書, Form自動生成, 設定ファイル, generate-form

</details>

## 共通の設定ファイル

共通テンプレートファイル（入力元設計書の種類によらず使用）:

| ファイル | 説明 |
|---|---|
| `nablarch/tool/formgenerator/class_template.txt` | クラス全体のテンプレート |
| `nablarch/tool/formgenerator/import_template.txt` | インポート部のテンプレート |
| `nablarch/tool/formgenerator/field_template.txt` | フィールド部のテンプレート |
| `nablarch/tool/formgenerator/constructor_assign_template.txt` | コンストラクタ代入部のテンプレート |
| `nablarch/tool/formgenerator/accessor_template.txt` | アクセサ部のテンプレート |

<details>
<summary>keywords</summary>

class_template.txt, import_template.txt, field_template.txt, constructor_assign_template.txt, accessor_template.txt, テンプレートファイル, 共通設定

</details>

## 環境設定ファイル

Nablarch標準の設計書レイアウトを使用している場合、環境設定ファイル（`formgeneratorFromTableDesign.config` / `formgeneratorFromIFDesign.config`）はファイルパス以外は修正不要。

<details>
<summary>keywords</summary>

環境設定ファイル, formgeneratorFromTableDesign.config, formgeneratorFromIFDesign.config, ファイルパス設定, Nablarch標準

</details>

## 入力元となる設計書に関する設定

**テーブル定義書（formgeneratorFromTableDesign.config）の設定キー**:

| キー名 | 設定内容 |
|---|---|
| `tableDefinitionFilePath` | テーブル定義書のファイルパス |
| `domainDefinitionFilePath` | ドメイン定義書のファイルパス |
| `codeDesignFilePath` | コード設計書のファイルパス |
| `tablePrefix` | テーブル物理名のプレフィックス（例: `T_`） |
| `classSuffix` | 生成クラスのサフィックス（例: `Entity`→`XxxEntity`） |

**外部インタフェース設計書（formgeneratorFromIFDesign.config）の設定キー**:

| キー名 | 設定内容 |
|---|---|
| `interfaceFileDir` | 外部インタフェース設計書が置かれているディレクトリ |
| `interfaceFileNamePattern` | 対象ファイルを正規表現で指定（例: `.*.xls`） |
| `domainDefinitionFilePath` | ドメイン定義書のファイルパス |
| `codeDesignFilePath` | コード設計書のファイルパス |
| `classSuffix` | 生成クラスのサフィックス（例: `Form`→`XxxForm`） |

<details>
<summary>keywords</summary>

tableDefinitionFilePath, domainDefinitionFilePath, codeDesignFilePath, tablePrefix, classSuffix, interfaceFileDir, interfaceFileNamePattern, 入力元設計書設定

</details>

## ファイル生成に関する設定

| キー名 | 設定内容 |
|---|---|
| `outputDir` | ファイル出力先ディレクトリ |
| `templateEncoding` | テンプレートファイルのエンコーディング |
| `outputEncoding` | 出力ファイルのエンコーディング |
| `lineSeparator` | 出力ファイルの改行コード（`CR`/`LF`/`CRLF`） |
| `spaceSizeForIndent` | インデントのスペース数 |

<details>
<summary>keywords</summary>

outputDir, templateEncoding, outputEncoding, lineSeparator, spaceSizeForIndent, ファイル生成設定, 出力設定

</details>

## コンポーネント定義ファイル

設計書からの情報読み取り方法を定義するファイル。設計書に以下の変更が生じた場合、対応するプロパティを修正する:

| 変更内容 | 修正対象プロパティ名 |
|---|---|
| 設計書シート名 | `sheetName` |
| 列の追加（読み取り対象カラムの位置がずれた場合） | `indexNamePairs` |
| 行の追加（読み取り開始行がずれた場合） | `startRowIndex` |

<details>
<summary>keywords</summary>

sheetName, indexNamePairs, startRowIndex, コンポーネント定義, 設計書レイアウト変更, 読み取り設定

</details>

## 入力元ファイル読み取り設定

ドメイン定義書読み取り設定例（**クラス**: `nablarch.tool.formgenerator.loader.poi.DomainDefinitionLoader`）:

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

DomainDefinitionLoader, XlsColumnDefs, domainDefinitionLoader, domainDefinitionColumnDefs, ドメイン定義書読み取り, columnDefs, startRowIndex

</details>

## データベースまたは外部インターフェース上の型 - Java型マッピング設定

DBのデータ型または外部インタフェース上の型とJavaのデータ型の対応を設定する。これに基づいて生成FormのプロパティのJava型が決定する。プロジェクトで使用する型のみ記載すればよい（全型網羅不要）。

**クラス**: `nablarch.tool.formgenerator.helper.DataTypeMapping`

DBデータ型マッピング例:
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

外部インタフェース設計上の型マッピング例:
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

DataTypeMapping, dataTypeMapping, データ型マッピング, Java型対応, DB型設定, nablarch.tool.formgenerator.helper.DataTypeMapping

</details>

## テンプレート

自動生成ツールが出力するFormのひな形テンプレート。`@author`のカスタマイズ以外は、プロジェクト固有の命名ルールがない限り変更不要。

テンプレート内の置き換え文字（`$...$` または `#...#` で囲む）:

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

TABLE_LNAME, TABLE_PNAME, JAVA_CLASS, PROP_LNAME, PROP_PNAME, PROP_TYPE, GETTER, SETTER, PACKAGE, VALIDATION_IMPORTS, FIELDS, FIELD_ANNOTATION, PARAM_TO_FIELD, ACCESSORS, SETTER_ANNOTATIONS, テンプレート置き換え文字

</details>

## 自動生成ツールの実行手順

Form自動生成ツールの実行コマンド:
- テーブル定義書を入力とする場合: `ant -f formgen.xml generate-entity`
- 外部IF設計書を入力とする場合: `ant -f formgen.xml generate-form`

<details>
<summary>keywords</summary>

generate-entity, generate-form, ant, Form自動生成実行, Entity生成, formgen.xml

</details>

## Entity のクラス名とプロパティ名

**テーブル定義書をインプットとする場合**:

| 対象 | 命名ルール | 例 |
|---|---|---|
| クラス名 | テーブル名の頭文字と`_`直後を大文字、他は小文字、`_`除去 + サフィックス | `ORDER` + サフィックス`Form` → `OrderForm`、`ORDER_DETAIL` + サフィックスなし → `OrderDetail` |
| プロパティ名 | カラム物理名の`_`直後を大文字、他は小文字、`_`除去 | `ID` → `id`、`ITEM_CODE` → `itemCode` |

**外部インタフェース設計書をインプットとする場合**:

| 対象 | 命名ルール | 例 |
|---|---|---|
| クラス名 | ファイルID + レコード名称 + サフィックス（`classSuffix`は省略可） | `N21AA001` + `Header` + サフィックス`Form` → `N21AA001HeaderForm`、`N21AA001` + `UserInfo` + サフィックスなし → `N21AA001UserInfo` |
| プロパティ名 | 項目名称の先頭を小文字に変換 | `ItemCode` → `itemCode` |

<details>
<summary>keywords</summary>

クラス名命名規則, プロパティ名命名規則, テーブル名変換, カラム名変換, Entity命名, classSuffix, アンダースコア変換

</details>
