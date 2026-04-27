# Form自動生成ツール

## 概要

本ツールは、下記のファイルからアプリケーションで使用するFormのひな形を作成する。

* テーブル定義書または、外部インタフェース設計書
* ドメイン定義書
* コード設計書

本ツールでFormのひな形を自動生成することで、Formの作成に必要な下記の作業が自動化できる。

* テーブル設計(外部インタフェース設計書)に従い、Formにプロパティを追加する。
* ドメイン定義に従い、Form の単項目精査で使用するアノテーションを設定する。

自動生成ツールの詳細な仕様については 自動生成ツールの仕様詳細 を参照。

本ツールを使用することで、データベース上で設計されたカラムを全て持つFormのひな形が生成できる。
また、作成したFormのひな形にはドメイン定義書に従って Form の単項目精査に必要なアノテーションが設定される。

## 利用の準備

自動生成ツールの設定ファイルに、利用に必要な設定を記述する。

設定ファイルとその設定内容は下記の通り。

| ファイル | 設定内容 |
|---|---|
| **テーブル定義書から自動生成する場合の設定ファイル** |  |
| nablarch/tool/formgenerator/loader/poi/formgeneratorFromTableDesign.xml | コンポーネント定義ファイル。設計書のレイアウト等。 |
| nablarch/tool/formgenerator/loader/poi/formgeneratorFromTableDesign.config | 環境設定ファイル。出力ファイルのパス等。 |
| **外部インタフェース設計書から自動生成する場合の設定ファイル** |  |
| nablarch/tool/formgenerator/loader/poi/formgeneratorFromIFDesign.config | コンポーネント定義ファイル。設計書のレイアウト等。 |
| nablarch/tool/formgenerator/loader/poi/formgeneratorFromIFDesign.xml | 環境設定ファイル。出力ファイルのパス等。 |
| **共通の設定ファイル** |  |
| nablarch/tool/formgenerator/class_template.txt | クラス全体のテンプレート |
| nablarch/tool/formgenerator/import_template.txt | インポート部のテンプレート |
| nablarch/tool/formgenerator/field_template.txt | フィールド部のテンプレート |
| nablarch/tool/formgenerator/constructor_assign_template.txt | コンストラクタ代入部のテンプレート |
| nablarch/tool/formgenerator/accessor_template.txt | アクセサ部のテンプレート |

それぞれの設定内容は下記の通り。

### 環境設定ファイル

基本的な設定は、この環境設定ファイルで行う。
設計書のレイアウトも含めNablarch標準のものを使用している場合、
ファイルパス以外は修正する必要はない。

#### 入力元となる設計書に関する設定

* テーブル定義書を元に自動生成する場合(formgeneratorFromTableDesign.config)

| キー名 | 設定内容 |
|---|---|
| tableDefinitionFilePath | テーブル定義書のファイルパス |
| domainDefinitionFilePath | ドメイン定義書のファイルパス |
| codeDesignFilePath | コード設計書のファイルパス |
| tablePrefix | テーブル物理名のプレフィックス（例：テーブル名に一律"T_"を付与する場合は、"T_"を指定） |
| classSuffix | 生成するJavaクラスに付与するサフィックス（例：XxxEntityとする場合は、"Entity"を指定） |

* 外部インタフェース設計書を元に自動生成する場合(formgeneratorFromIFDesign.config)

| キー名 | 設定内容 |
|---|---|
| interfaceFileDir | 外部インタフェース設計書が置かれているディレクトリ |
| interfaceFileNamePattern | 自動生成対象の外部インタフェース設計書を正規表現で指定する。  例:  ``` .*.xls                                       # 全EXCELが対象 外部インターフェース設計書_サンプル1.xls     # ファイル名を完全一致で指定 ``` |
| domainDefinitionFilePath | ドメイン定義書のファイルパス |
| codeDesignFilePath | コード設計書のファイルパス |
| classSuffix | 生成するJavaクラスに付与するサフィックス（例：XxxFormとする場合は、"Form"を指定） |

#### ファイル生成に関する設定

| キー名 | 設定内容 |
|---|---|
| outputDir | ファイル出力先ディレクトリ |
| templateEncoding | テンプレートファイルのファイルエンコーディング |
| outputEncoding | 出力ファイルのファイルエンコーディング |
| lineSeparator | 出力ファイル改行（"CR","LF","CRLF"のいずれか） |
| spaceSizeForIndent | インデントに使用するスペースの数 |

### コンポーネント定義ファイル

#### 入力元ファイル読み取り設定

コンポーネント定義ファイルには、設計書からどのように情報を読み取るかという設定が記載されている。

読み取り対象となる設計書に以下の変更が生じた場合、この定義を修正する必要がある。

| 変更内容 | 修正対象プロパティ名 |
|---|---|
| 設計書シート名 | sheetName |
| 列の追加（読み取り対象カラムの位置がずれた場合） | indexNamePairs |
| 行の追加（読み取り開始行がずれた場合） | startRowIndex |

ドメイン定義書を読み取る設定例を以下に示す。

```xml
<!-- ドメイン定義 -->
<component name="domainDefinitionLoader"
           class="nablarch.tool.formgenerator.loader.poi.DomainDefinitionLoader">
  <!-- 入力元ファイルのパス -->
  <property name="pathToBook" value="${inputBasePath}/${domainDefinitionFileName}"/>
  <!-- 読み込み対象シート名 -->
  <property name="sheetName" value="ドメイン定義"/>
  <!-- 読み取り開始行（0オリジン） -->
  <property name="startRowIndex" value="5"/>
  <!-- Excelファイルのレイアウト -->
  <property name="columnDefs" ref="domainDefinitionColumnDefs"/>
  <!-- データタイプ定義のローダ -->
  <property name="dataTypeDefinitionLoader" ref="dataTypeDefinitionLoader"/>
</component>
<!-- ドメイン定義書のレイアウト -->
<component name="domainDefinitionColumnDefs"
           class="nablarch.tool.formgenerator.loader.poi.util.XlsColumnDefs">
  <property name="indexNamePairs">
    <map>
      <!-- ドメイン名(論理) -->
      <entry key="0" value="domainLogicalName"/>
      <!-- 意味・説明 -->
      <entry key="5" value="description"/>
      <!-- データタイプ -->
      <entry key="14" value="dataTypeName"/>
      <!-- 桁数( '=' or '=<' ) -->
      <entry key="17" value="eqOrLe"/>
      <!-- 桁数 -->
      <entry key="18" value="precision"/>
      <!-- 小数部桁数 -->
      <entry key="20" value="fraction"/>
      <!-- データタイプ詳細 -->
      <entry key="22" value="dataTypeDetail"/>
    </map>
  </property>
</component>
```

#### データベースまたは外部インターフェース上の型 - Java型マッピング設定

DBのデータ型または外部インターフェース上の型とJavaのデータ型の対応関係を設定する。
この設定に基づいて、生成される Form のプロパティのデータ型が決定する。
データベースのデータ型または外部インターフェース上の型は、各プロジェクトで使用するRDBMSや設計書の標準に応じてこの設定を行う必要がある。

記述例を以下に示す。

キーをDBのデータ型または外部インタフェース上の型、値をJavaのデータ型としてMap形式で記載する。

```xml
<!-- Java-DBデータ型対応表の例 -->
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

<!-- Java-外部インタフェース設計上の型対応表 -->
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

> **Note:**
> RDBMSがサポートする全ての型を網羅する必要はなく、そのプロジェクトで使用するものだけを記載すれば良い。

#### テンプレート

自動生成ツールが出力する Form のひな形を設定する。

テンプレートファイルは以下のように分割されている。

| ファイル | 説明 |
|---|---|
| nablarch/tool/formgenerator/class_template.txt | クラス全体のテンプレート |
| nablarch/tool/formgenerator/import_template.txt | インポート部のテンプレート |
| nablarch/tool/formgenerator/field_template.txt | フィールド部のテンプレート |
| nablarch/tool/formgenerator/constructor_assign_template.txt | コンストラクタ代入部のテンプレート |
| nablarch/tool/formgenerator/accessor_template.txt | アクセサ部のテンプレート |

個別に設定すべき個所は、基本的にクラスヘッダの @author のみでよい。
ただし、Formのクラス名の命名ルールを変更するなどのプロジェクト固有のルールが存在する場合、
そのルールに合致するよう必要に応じて変更すること。

以下に @author の設定例と、自動生成されるコードの例を示す。

**@author 設定前**

```none
/**
 * $TABLE_LNAME$テーブルの情報を保持するクラス。
 *
 * $JAVA_CLASS$ クラスは $TABLE_PNAME$ テーブルにマッピングされるテーブルフィールドを保持する。
 *
 * @author Form Generator
 * @since 1.0
 */
```

**@author 設定後(利用者の氏名が "Nabla Taro" の場合)**

```none
/**
 * $TABLE_LNAME$テーブルの情報を保持するクラス。
 *
 * $JAVA_CLASS$ クラスは $TABLE_PNAME$ テーブルにマッピングされるテーブルフィールドを保持する。
 *
 * @author Nabla Taro
 * @since 1.0
 */
```

**自動生成されたソースコード(ID_GENERATEテーブルに対応するFormのクラス)**

```none
/**
 * 採番テーブルの情報を保持するクラス。
 *
 * IdGenerateEntity クラスは ID_GENERATE テーブルにマッピングされるテーブルフィールドを保持する。
 *
 *
 * @author Nabla Taro
 * @since 1.0
 */
```

自動生成ツールは上記の例のように "$TABLE_PNAME$" など "$" または "#" で挟まれた置き換え文字を置き換えてソースコードを自動生成する。
ここで使用できる置き換え文字の一覧を以下に示す。

| 置き換え文字 | 置き換えられる文字列 |
|---|---|
| $TABLE_LNAME$ | Entityに対応するテーブル論理名 |
| $TABLE_PNAME$ | Entityに対応するテーブル物理名 |
| $JAVA_CLASS$ | Javaクラス名 |
| $PROP_LNAME$ | プロパティ論理名 |
| $PROP_PNAME$ | プロパティ物理名 |
| $PROP_TYPE$ | プロパティの型 |
| $GETTER$ | Getterメソッド名 |
| $SETTER$ | Setterメソッド名 |
| #PACKAGE# | パッケージ宣言 |
| #VALIDATION_IMPORTS# | 精査アノテーションのimport文 |
| #FIELDS# | フィールド定義 |
| #FIELD_ANNOTATION# | フィールドに対するアノテーション |
| #PARAM_TO_FIELD# | Mapパラメータからフィールドへの代入 |
| #ACCESSORS# | アクセサ定義 |
| #SETTER_ANNOTATIONS# | Setterに対するアノテーション |

## 自動生成ツールの実行手順

Entityの自動生成を行う手順は下記の通り。

```bash
# テーブル定義書を入力とする場合
ant -f formgen.xml generate-entity
# 外部IF設計書を入力とする場合
ant -f formgen.xml generate-form
```

## 自動生成ツールの仕様詳細

自動生成ツールの仕様の詳細について以下に記載する。

### Entity 出力の仕様

#### Entity のクラス名とプロパティ名

本ツールでは、 Entity のソースコードが自動生成される。
この際、 自動生成ツールは外部インタフェース設計書から下記のルールでクラス名、プロパティ名を命名する。

* テーブル定義書をインプットとする場合

| 対象 | 命名ルール |
|---|---|
| クラス名 | テーブル名の頭文字および "_" (アンダースコア) の直後を大文字、それ以外を全て小文字にし、 "_" (アンダースコア)を除き、 環境設定ファイル で指定したサフィックスを付与したもの。  例:  ``` テーブル名 ORDER , サフィックス Form ⇒ クラス名 OrderForm テーブル名 ORDER_DETAIL, サフィックス <なし> ⇒ クラス名 OrderDetail ``` |
| プロパティ名 | カラム物理名の "_" (アンダースコア) の直後を大文字、 それ以外を全て小文字にし、 "_" (アンダースコア)を除いた名称となる。  例:  ``` カラム名 ID ⇒ プロパティ名 id カラム名 ITEM_CODE ⇒ プロパティ名 itemCode ``` |

* 外部インタフェース設計書をインプットとする場合

| 対象 | 命名ルール |
|---|---|
| クラス名 | ファイルID + レコード名称に 環境設定ファイル で指定したサフィックスを付与したもの。  例:  ``` ファイルID N21AA001 レコード名称 Header サフィックス Form ⇒ クラス名 N21AA001HeaderForm ファイルID N21AA001 レコード名称 UserInfo サフィックス <なし> ⇒ クラス名 N21AA001UserInfo ``` |
| プロパティ名 | 項目名称の先頭を小文字に変換したもの。  例:  ``` 項目名 id ⇒ プロパティ名 id 項目名 ItemCode ⇒ プロパティ名 itemCode ``` |

#### 共通項目自動設定機能で使用するアノテーションの出力

本ツールは、特定のプロパティ名に合致するプロパティに対して、
共通項目自動設定機能で使用するアノテーションを自動生成時に付与できる。

※共通項目自動設定機能の詳細については、アーキテクチャ解説書を参照のこと。

これは、例えばアノテーションを全テーブルの共通項目 UPDATE_USER_ID カラムに対応するフォームのプロパティ updateUser に
対して  @UserId を全て設定するような用途を想定した機能である。

@UserId アノテーションを全てのフォームの updateUserId および insertUserId プロパティに設定し、
@CurrentDateTime アノテーションを全てのフォーム の insertDateTime および updatedDateTime プロパティに設定する場合、
以下のように設定する。

```xml
<!-- フィールド部 -->
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
