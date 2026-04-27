# 画面項目定義データ自動生成ツール

## 概要

本ツールは、下記のファイルからUI開発基盤の画面項目定義で使用する定義データを生成する。

* テーブル定義書
* ドメイン定義書
* コード設計書
* メッセージ設計書
* 外部インターフェース設計書

自動生成ツールの詳細な仕様については 自動生成ツールの仕様 を参照。

定義データとして出力する情報は 出力形式 を参照。

## ツール配置場所

本ツールはチュートリアルプロジェクトの `tool/definitioninfogenerator` ディレクトリに配置されている。

配下のファイル/ディレクトリ構成を以下に示す。

| ファイル/ディレクトリ | 説明 |
|---|---|
| doc | テーブル定義書等の入力ファイル配置場所（ 環境設定ファイル を参照） |
| resources | 本ツールの設定ファイル配置場所（ 利用の準備 を参照） |
| definfogen.xml | 本ツールを実行するためのAntビルドファイル( 自動生成ツールの実行手順 を参照) |
| definfogen.properties | Antビルドファイルのプロパティファイル（通常、変更の必要なし） |

## 利用の準備

自動生成ツールの設定ファイルに、利用に必要な設定を記述する。

設定ファイルとその設定内容は下記の通り。

| ファイル | 設定内容 |
|---|---|
| **出力ファイル毎の設定ファイル** |  |
| resources/definitioninfogenerator/tableinfogenerator.xml | テーブル定義取得用のコンポーネント定義ファイル。定義書のレイアウト等。 |
| resources/definitioninfogenerator/domaininfogenerator.xml | ドメイン定義取得用のコンポーネント定義ファイル。定義書のレイアウト等。 |
| resources/definitioninfogenerator/validationinfogenerator.xml | 精査処理定義取得用のコンポーネント定義ファイル。定義書のレイアウト等。 |
| resources/definitioninfogenerator/datatypeinfogenerator.xml | データタイプ定義取得用のコンポーネント定義ファイル。定義書のレイアウト等。 |
| resources/definitioninfogenerator/messageifogenerator.xml | メッセージ設計取得用のコンポーネント定義ファイル。設計書のレイアウト等。 |
| resources/definitioninfogenerator/codeinfogenerator.xml | コード設計取得用のコンポーネント定義ファイル。設計書のレイアウト等。 |
| resources/definitioninfogenerator/interfaceinfogenerator.xml | 外部インターフェース設計取得用のコンポーネント定義ファイル。設計書のレイアウト等。 |
| **共通の設定ファイル** |  |
| resources/definitioninfogenerator/definitioninfogenerator.config | 環境設定ファイル。定義書/設計書へのパス等。 |

それぞれの設定内容は下記の通り。

### 環境設定ファイル

基本的な設定は、この環境設定ファイルで行う。
設計書のレイアウトも含めNablarch標準を使用している場合、
ファイルパス以外は修正する必要はない。

#### 入力となる設計書に関する設定

| キー名 | 設定内容 |
|---|---|
| tableDefinitionFilePath | テーブル定義書のファイルパス |
| domainDefinitionFilePath | ドメイン定義書のファイルパス |
| codeDesignFilePath | コード設計書のファイルパス |
| messageDesignFilePath | メッセージ設計書のファイルパス |
| interfaceDesignFilePath | 外部インターフェース設計書のファイルパス |
| interfaceFileDir | 外部インタフェース設計書が置かれているディレクトリ |
| interfaceFileNamePattern | 自動生成対象の外部インタフェース設計書を正規表現で指定する。  例:  ``` .*.xls                                       # 全EXCELが対象 外部インターフェース設計書_サンプル1.xls     # ファイル名を完全一致で指定 ``` |

#### ファイル生成に関する設定

| キー名 | 設定内容 |
|---|---|
| outputDir | ファイル出力先ディレクトリ |
| lineSeparator | 出力ファイル改行（"CR","LF","CRLF"のいずれか） |

### コンポーネント定義ファイル

#### 入力ファイル読み取り設定

コンポーネント定義ファイルには、設計書からどのように情報を読み取るかという設定が記載されている。

読み取り対象となる設計書に以下の変更が生じた場合、この定義を修正する必要がある。

| 変更内容 | 修正対象プロパティ名 |
|---|---|
| 列の追加（読み取り対象カラムの位置がずれた場合） | indexNamePairs |
| 行の追加（読み取り開始行がずれた場合） | startRowIndex |

> **Note:**
> excludedSheetsプロパティには取込対象外のシートを指定する。
> そのため、メッセージ設計書に言語シートを追加するなど、取込が不要なシートを追加した場合、
> excludedSheetsプロパティの指定を追加すること。

メッセージ設計書、コード設計書、テーブル定義書、外部インターフェース設計書を読み取る設定例を以下に示す。

ドメイン定義、精査処理定義、データタイプ定義を読み取る設定は、メッセージ設計書と設定項目が同じため省略する。

#### メッセージ設計書の読込設定

```xml
<!-- メッセージ設計 -->
<component name="messageDesignLoader"
           class="nablarch.tool.definitioninfogenerator.loader.poi.DefinitionFileLoader">
  <property name="pathToBook" value="${messageDesignFilePath}"/>
  <!-- データ読み取り開始行 -->
  <property name="startRowIndex" value="6"/>

  <!-- 取得用keyは、<property name="indexNamePairs">のvalue値と合わせること -->
  <!-- メッセージID取得用key -->
  <property name="keyName" value="messageId"/>
  <property name="columnDefs" ref="messageDesignColumnDefs"/>
  <!-- 取得対象外のシート名 -->
  <property name="excludedSheets">
    <list>
      <value>表紙</value>
      <value>変更履歴</value>
      <value>目次</value>
      <value>en</value>
      <value>ch</value>
    </list>
  </property>
</component>

<!-- 設計書から取得する際の定義 -->
<component name="messageDesignColumnDefs"
           class="nablarch.tool.util.poi.XlsColumnDefs">
  <property name="indexNamePairs">
    <map>
      <!-- key：Excelの列位置（0オリジン）、
           value：データを取得する際のkey -->
      <entry key="0" value="messageId"/>
      <entry key="5" value="message"/>
    </map>
  </property>
</component>
```

#### テーブル定義書の読込設定

```xml
<!-- テーブル定義 -->
<component name="tableDefinitionLoader"
           class="nablarch.tool.definitioninfogenerator.loader.poi.TableDefinitionFileLoader">
  <property name="pathToBook" value="${tableDefinitionFilePath}"/>
  <!-- データ読み取り開始行 -->
  <property name="startRowIndex" value="10"/>

  <!-- 取得用keyは、<property name="indexNamePairs">のvalue値と合わせること -->
  <!-- カラム物理名称取得用key -->
  <property name="keyName" value="physicalColumnName"/>

  <!-- テーブル論理名を記載したセル位置（0オリジン） -->
  <property name="logicalTableNameRowIndex" value="4"/>
  <property name="logicalTableNameColumnIndex" value="5"/>
  <!-- テーブル物理名を記載したセル位置（0オリジン） -->
  <property name="physicalTableNameRowIndex" value="4"/>
  <property name="physicalTableNameColumnIndex" value="22"/>
  <!-- テーブル説明を記載したセル位置（0オリジン） -->
  <property name="tableDescriptionRowIndex" value="5"/>
  <property name="tableDescriptionColumnIndex" value="5"/>

  <property name="columnDefs" ref="tableDefinitionColumnDefs"/>
  <!-- 取得対象外のシート名 -->
  <property name="excludedSheets">
    <list>
      <value>表紙</value>
      <value>変更履歴</value>
      <value>目次</value>
      <value>データ</value>
    </list>
  </property>
</component>

<!-- 設計書から取得する際の定義 -->
<component name="tableDefinitionColumnDefs"
           class="nablarch.tool.util.poi.XlsColumnDefs">
  <property name="indexNamePairs">
    <map>
      <!-- key：Excelの列位置（0オリジン）、
           value：データを取得する際のkey -->
      <entry key="1" value="logicalColumnName"/>
      <entry key="6" value="physicalColumnName"/>
      <entry key="11" value="domainName"/>
      <entry key="16" value="dataType"/>
      <entry key="19" value="length"/>
      <entry key="21" value="primaryKeyOrder"/>
      <entry key="22" value="required"/>
      <entry key="30" value="columnDefinition"/>
      <entry key="40" value="initialValue"/>
      <entry key="42" value="encryptionTarget"/>
      <entry key="44" value="note"/>
    </map>
  </property>
</component>
```

#### コード設計書の読込設定

```xml
<!-- コード設計 -->
<component name="codeDefinitionLoader"
           class="nablarch.tool.definitioninfogenerator.loader.poi.CodeDefinitionFileLoader">
  <property name="pathToBook" value="${codeDesignFilePath}"/>
  <!-- データ読み取り開始行 -->
  <property name="startRowIndex" value="11"/>

  <!-- 取得用keyは、<property name="indexNamePairs">のvalue値と合わせること -->
  <!-- コードID取得用key -->
  <property name="keyName" value="codeId"/>
  <!-- コード名称取得用key
  <property name="indexNamePairs">のvalue値と合わせること -->
  <property name="codeNameKey" value="codeName"/>
  <!-- コード説明取得用key
  <property name="indexNamePairs">のvalue値と合わせること -->
  <property name="codeDescriptionKey" value="codeDescription"/>
  <!-- コード値に紐づく各種データの取得用key
  <property name="indexNamePairs">のvalue値と合わせること -->
  <property name="valueKeys">
    <list>
      <value>codeValue</value>
      <value>sortOrder</value>
      <value>codeValueName</value>
      <value>SHORT_NAME</value>
      <value>OPTIONAL_NAME01</value>
      <value>OPTIONAL_NAME02</value>
      <value>OPTIONAL_NAME03</value>
      <value>OPTIONAL_NAME04</value>
      <value>OPTIONAL_NAME05</value>
      <value>OPTIONAL_NAME06</value>
      <value>OPTIONAL_NAME07</value>
      <value>OPTIONAL_NAME08</value>
      <value>OPTIONAL_NAME09</value>
      <value>OPTIONAL_NAME10</value>
      <value>PATTERN01</value>
      <value>PATTERN02</value>
      <value>PATTERN03</value>
      <value>PATTERN04</value>
      <value>PATTERN05</value>
      <value>PATTERN06</value>
      <value>PATTERN07</value>
      <value>PATTERN08</value>
      <value>PATTERN09</value>
      <value>PATTERN10</value>
      <value>PATTERN11</value>
      <value>PATTERN12</value>
      <value>PATTERN13</value>
      <value>PATTERN14</value>
      <value>PATTERN15</value>
      <value>PATTERN16</value>
      <value>PATTERN17</value>
      <value>PATTERN18</value>
      <value>PATTERN19</value>
      <value>PATTERN20</value>
    </list>
  </property>

  <property name="columnDefs" ref="codeDesignColumnDefs"/>
  <!-- 取得対象外のシート名 -->
  <property name="excludedSheets">
    <list>
      <value>表紙</value>
      <value>変更履歴</value>
      <value>目次</value>
      <value>en</value>
    </list>
  </property>
</component>

<!-- 設計書から取得する際の定義 -->
<component name="codeDesignColumnDefs"
           class="nablarch.tool.util.poi.XlsColumnDefs">
  <property name="indexNamePairs">
    <map>
      <!-- key：Excelの列位置（0オリジン）、
           value：データを取得する際のkey -->
      <entry key="0" value="codeId"/>
      <entry key="2" value="codeName"/>
      <entry key="6" value="codeDescription"/>
      <entry key="12" value="codeValue"/>
      <entry key="13" value="sortOrder"/>
      <entry key="14" value="codeValueName"/>
      <entry key="17" value="SHORT_NAME"/>
      <entry key="19" value="OPTIONAL_NAME01"/>
      <entry key="22" value="OPTIONAL_NAME02"/>
      <entry key="25" value="OPTIONAL_NAME03"/>
      <entry key="28" value="OPTIONAL_NAME04"/>
      <entry key="31" value="OPTIONAL_NAME05"/>
      <entry key="34" value="OPTIONAL_NAME06"/>
      <entry key="37" value="OPTIONAL_NAME07"/>
      <entry key="40" value="OPTIONAL_NAME08"/>
      <entry key="43" value="OPTIONAL_NAME09"/>
      <entry key="46" value="OPTIONAL_NAME10"/>
      <entry key="49" value="PATTERN01"/>
      <entry key="50" value="PATTERN02"/>
      <entry key="51" value="PATTERN03"/>
      <entry key="52" value="PATTERN04"/>
      <entry key="53" value="PATTERN05"/>
      <entry key="54" value="PATTERN06"/>
      <entry key="55" value="PATTERN07"/>
      <entry key="56" value="PATTERN08"/>
      <entry key="57" value="PATTERN09"/>
      <entry key="58" value="PATTERN10"/>
      <entry key="59" value="PATTERN11"/>
      <entry key="60" value="PATTERN12"/>
      <entry key="61" value="PATTERN13"/>
      <entry key="62" value="PATTERN14"/>
      <entry key="63" value="PATTERN15"/>
      <entry key="64" value="PATTERN16"/>
      <entry key="65" value="PATTERN17"/>
      <entry key="66" value="PATTERN18"/>
      <entry key="67" value="PATTERN19"/>
      <entry key="68" value="PATTERN20"/>
    </map>
  </property>
</component>
```

#### 外部インターフェース設計書の読込設定

```xml
<!-- 外部インターフェース設計 -->
<component name="interfaceDesignLoader"
           class="nablarch.tool.definitioninfogenerator.loader.poi.IFDefinitionFileLoader">
  <!-- IFファイル配置ディレクトリ -->
  <property name="interfaceFileDir" value="${interfaceFileDir}" />
  <!-- IF設計書の名前パターン -->
  <property name="interfaceFileNamePattern" value="${interfaceFileNamePattern}" />

  <!-- データ読み取り開始行 -->
  <property name="startRowIndex" value="8"/>

  <!-- レコード名を記載した列 -->
  <property name="columnDefs">
    <component class="nablarch.tool.util.poi.XlsColumnDefs">
      <property name="indexNamePairs">
        <map>
          <entry key="1" value="logicalRecordName" />
          <entry key="6" value="physicalRecordName" />
          <entry key="9" value="recordCondition" />
        </map>
      </property>
    </component>
  </property>

  <!-- ID/ファイル名記載セルの定義 -->
  <property name="idNameColumnNo" value="18" />
  <property name="idNameRowNo" value="2" />

  <!-- レコード構成を記載したシートのシート名 -->
  <property name="sheetName" value="レコード構成" />
</component>

<!-- レコードローダのファクトリ定義 -->
<component name="ifRecordDefinitionLoaderFactory" class="nablarch.tool.definitioninfogenerator.loader.IFRecordDefinitionLoaderFactory">
  <!-- 階層レコードマーカー文字列 -->
  <property name="multiLayerMarker" value="階層構造" />
</component>

<!-- レコード定義を読み込むための定義 -->
<component name="ifRecordDefinition" class="nablarch.tool.definitioninfogenerator.loader.poi.IFRecordDefinitionLoader">
  <!-- レコード定義の開始行 -->
  <property name="startRowIndex" value="8" />
  <!--論理名（項目名）の列数-->
  <property name="logicalNameColumnLength" value="6" />
  <!-- 除外する項目のプレフィックス -->
  <property name="excludePrefix" value="ex_" />
  <!-- 項目ID取得用key -->
  <property name="keyName" value="itemPhysicalName"/>
  <property name="columnDefs">
    <component class="nablarch.tool.util.poi.XlsColumnDefs">
      <property name="indexNamePairs">
        <map>
          <!-- 項目名は、上記で定義した列数分連番で定義する -->
          <entry key="1" value="itemLogicalName_1" />
          <entry key="2" value="itemLogicalName_2" />
          <entry key="3" value="itemLogicalName_3" />
          <entry key="4" value="itemLogicalName_4" />
          <entry key="5" value="itemLogicalName_5" />
          <entry key="6" value="itemLogicalName_6" />

          <entry key="7" value="itemPhysicalName" />
          <entry key="13" value="domainName" />
          <entry key="18" value="required" />
          <entry key="19" value="dataTypeName" />
          <entry key="21" value="byte" />
          <entry key="23" value="startPosition" />
          <entry key="25" value="defaultValue" />
          <entry key="27" value="padding" />
          <entry key="29" value="floatPointPosition" />
          <entry key="31" value="formatSpec" />
          <entry key="34" value="replacementChar" />
          <entry key="36" value="note" />
        </map>
      </property>
    </component>
  </property>
  <!-- valueとして出力する項目のkey名 -->
  <property name="valueKeyNames" ref="valueKeyNames"/>
</component>

<!-- 階層構造型レコード定義の読込設定は省略 -->

<!-- valueとして出力する項目のkey名 -->
<list name="valueKeyNames">
  <value>itemLogicalName</value>
  <value>domainName</value>
  <value>dataTypeName</value>
  <value>defaultValue</value>
  <value>note</value>
  <value>required</value>
  <value>byte</value>
  <value>startPosition</value>
  <value>padding</value>
  <value>floatPointPosition</value>
  <value>formatSpec</value>
  <value>replacementChar</value>
  <value>attribute</value>
  <value>multiplicity</value>
</list>
```

機能追加したら、コンポーネント定義を張る

## 自動生成ツールの実行手順

定義データの自動生成を行う手順は下記の通り。

```bash
# 全定義情報ファイルを生成する場合
ant -f definitioninfogenerator.xml generate
# メッセージ設計情報ファイルを生成する場合
ant -f definitioninfogenerator.xml generate-messageDef
# ドメイン定義情報ファイルを生成する場合
ant -f definitioninfogenerator.xml generate-domainDef
# 精査処理定義情報ファイルを生成する場合
ant -f definitioninfogenerator.xml generate-validationDef
# データタイプ定義情報ファイルを生成する場合
ant -f definitioninfogenerator.xml generate-dataTypeDef
# コード設計情報ファイルを生成する場合
ant -f definitioninfogenerator.xml generate-codeDef
# テーブル定義情報ファイルを生成する場合
ant -f definitioninfogenerator.xml generate-tableDef
# 外部インターフェース設計情報ファイルを生成する場合
ant -f definitioninfogenerator.xml generate-interfaceDef
```

## 自動生成ツールの仕様

### 出力形式

自動生成ツールでは、各定義データをJSON形式で出力する。
出力する情報は下記の通り。

#### メッセージ設計

```javascript
define(function(){ return {"":""

, "メッセージID": ["メッセージ内容"]

};});
```

#### ドメイン定義

```javascript
define(function(){ return {"":""

, "ドメイン名（物理）": ["ドメイン名（論理）", "データタイプ", "桁数（数値）", "小数部桁数", "データ型", "ドメイン定義"]

};});
```

#### 精査処理定義

```javascript
define(function(){ return {"":""

, "精査処理名": ["アノテーション名(物理名)", "引数1", "引数2", "引数3", "引数4", "引数5", "アノテーション完全修飾名", "備考"]

};});
```

#### データタイプ定義

```javascript
define(function(){ return {"":""

, "データタイプ": ["長さ精査", "データタイプ精査", "引数1（引数名）", "引数1（設定値）", "引数2（引数名）", "引数2（設定値）", "引数3（引数名）", "引数3（設定値）", "引数4（引数名）", "引数4（設定値）", "引数5（引数名）", "引数5（設定値）", "備考"]

};});
```

#### テーブル定義

```javascript
define(function(){ return {"":""

// 【説明】テーブル情報
, "物理テーブル名": ["論理テーブル名", "テーブル説明"]

// 【説明】カラム情報
, "物理テーブル名.物理名称": ["論理名称", "ドメイン名", "データ型", "桁数", "PK", "必須", "項目定義", "初期値", "暗号化対象", "備考"]

// 【説明】以下、生成対象の全テーブルについてテーブル情報とカラム情報を出力する。

};});
```

#### コード設計

```javascript
define(function(){ return {"":""

// 【説明】コードID情報
, "コードID": ["コード名称", "説明"]

// 【説明】コード定義情報は、コードIDに対応する各セルの値を"|"で結合して出力する。（コード値の場合、"C8100001.codeValue": ["00|01|02"]）
// 【説明】コード設計情報の場合、キーに含まれる"."以下の文字列は固定。（codeValue、sortOrderなど）
, "コードID.codeValue": ["コード値"]
, "コードID.sortOrder": ["ソート順"]
, "コードID.codeValueName": ["名称"]
, "コードID.SHORT_NAME": ["略称"]
, "コードID.OPTIONAL_NAME01": ["オプション名称1"]

// 【説明】OPTIONAL_NAME02～OPTIONAL_NAME09は省略

, "コードID.OPTIONAL_NAME10": ["オプション名称10"]
, "コードID.PATTERN01": ["パターン1"]

// 【説明】PATTERN02～PATTERN19は省略

, "コードID.PATTERN20": ["パターン20"]

// 【説明】以下、生成対象の全コードについてコード情報を出力する。

};});
```

> **Note:**
> 設計書ごとに出力する情報は、キャメル変換などは行わずにApache POIで取得した値をそのまま出力する。

> そのため、セルの書式が数値型の場合に整数を指定しても自動的に".0"が付与される。

> 整数をそのまま取得したい場合、当該セルの書式を標準や文字列にすること。

#### 外部インターフェース設計

外部インターフェース設計書は、階層構造型レコード用のものとそれ以外のものがあるが、
どちらの設計書が入力の場合にも同一のフォーマットでデータを出力する。

ただし、入力となる設計書に存在しない項目の場合、対応する項目を空文字で出力する。

```javascript
define(function(){ return {"":""

// 【説明】外部インターフェース仕様情報
, "ファイルIDまたは電文ID": ["相手先", "入出力取引ID/名称"]

// 【説明】データレイアウト情報
// 【説明】プロパティ定義行（項目IDが[]で囲まれていない行）のデータのみ出力する

// 【説明】親要素名は、以下のルールで設定する。
// 【説明】レコードが階層構造型でない場合  : レコードタイプ名
// 【説明】レコードが階層構造型の場合      : 親要素となるオブジェクト定義行（項目IDが[]で囲まれている行）の項目IDから"["と"]"を除去した値
, "ファイルIDまたは電文ID.親要素名.項目ID": ["項目名", "ドメイン名", "データタイプ", "デフォルト値", "備考", "必須", "Byte", "開始位置", "パディング", "小数点位置", "フォーマット仕様", "寄せ字", "属性", "多重度"]

// 【説明】以下、生成対象の全設計書について、外部インターフェース情報とデータレイアウト情報を出力する。

};});
```

### 定義データの出力仕様

#### エスケープ処理

本ツールでは定義データをJSON形式で出力するため、出力時に以下の文字に対してエスケープ処理を行う。

* \
* "
* /
* \b
* \f
* \t
* \n
* \r

> **Note:**
> \rと\nは除去される。
