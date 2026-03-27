# 画面項目定義データ自動生成ツール

## 概要

## 概要

本ツールは、下記のファイルからUI開発基盤の画面項目定義で使用する定義データを生成する。

- テーブル定義書
- ドメイン定義書
- コード設計書
- メッセージ設計書
- 外部インターフェース設計書

**クラス**: `nablarch.tool.definitioninfogenerator.loader.poi.IFDefinitionFileLoader`

| プロパティ名 | 説明 |
|---|---|
| interfaceFileDir | IFファイル配置ディレクトリ |
| interfaceFileNamePattern | IF設計書の名前パターン |
| startRowIndex | データ読み取り開始行（例: 8） |
| columnDefs | 列定義（`nablarch.tool.util.poi.XlsColumnDefs`を設定） |
| idNameColumnNo | ID/ファイル名記載セルの列番号 |
| idNameRowNo | ID/ファイル名記載セルの行番号 |
| sheetName | レコード構成を記載したシートのシート名 |

`columnDefs` の `indexNamePairs` に列番号→項目名マッピングを定義する（例: 列1=logicalRecordName, 列6=physicalRecordName, 列9=recordCondition）。

**クラス**: `nablarch.tool.definitioninfogenerator.loader.IFRecordDefinitionLoaderFactory`

| プロパティ名 | 説明 |
|---|---|
| multiLayerMarker | 階層レコードマーカー文字列（例: "階層構造"） |

**クラス**: `nablarch.tool.definitioninfogenerator.loader.poi.IFRecordDefinitionLoader`

| プロパティ名 | 説明 |
|---|---|
| startRowIndex | レコード定義の開始行（例: 8） |
| logicalNameColumnLength | 論理名（項目名）の列数（この数だけ itemLogicalName_1, _2, ... の連番カラムを `indexNamePairs` に定義する） |
| excludePrefix | 除外する項目のプレフィックス（例: "ex_"） |
| keyName | 項目ID取得用key（例: "itemPhysicalName"） |
| columnDefs | 列定義（`XlsColumnDefs`） |
| valueKeyNames | valueとして出力する項目のkey名リスト（list refで参照） |

標準 `valueKeyNames` リスト: `itemLogicalName`, `domainName`, `dataTypeName`, `defaultValue`, `note`, `required`, `byte`, `startPosition`, `padding`, `floatPointPosition`, `formatSpec`, `replacementChar`, `attribute`, `multiplicity`

<details>
<summary>keywords</summary>

概要, 画面項目定義データ自動生成ツール, UI開発基盤, 定義データ生成, テーブル定義書, ドメイン定義書, コード設計書, メッセージ設計書, 外部インターフェース設計書, 入力ファイル種別, IFDefinitionFileLoader, IFRecordDefinitionLoaderFactory, IFRecordDefinitionLoader, XlsColumnDefs, interfaceFileDir, interfaceFileNamePattern, startRowIndex, columnDefs, indexNamePairs, idNameColumnNo, idNameRowNo, sheetName, multiLayerMarker, logicalNameColumnLength, excludePrefix, valueKeyNames, 外部インターフェース設計書読込, レコード定義読込, 階層構造型レコード

</details>

## ツール配置場所

## ツール配置場所

本ツールはチュートリアルプロジェクトの `tool/definitioninfogenerator` ディレクトリに配置されている。

| ファイル/ディレクトリ | 説明 |
|---|---|
| `doc` | テーブル定義書等の入力ファイル配置場所 |
| `resources` | 本ツールの設定ファイル配置場所 |
| `definfogen.xml` | 本ツールを実行するためのAntビルドファイル |
| `definfogen.properties` | Antビルドファイルのプロパティファイル（通常、変更の必要なし） |

antコマンドで各定義情報ファイルを生成する。

```bash
# 全定義情報ファイルを生成
ant -f definitioninfogenerator.xml generate
# メッセージ設計情報ファイルを生成
ant -f definitioninfogenerator.xml generate-messageDef
# ドメイン定義情報ファイルを生成
ant -f definitioninfogenerator.xml generate-domainDef
# 精査処理定義情報ファイルを生成
ant -f definitioninfogenerator.xml generate-validationDef
# データタイプ定義情報ファイルを生成
ant -f definitioninfogenerator.xml generate-dataTypeDef
# コード設計情報ファイルを生成
ant -f definitioninfogenerator.xml generate-codeDef
# テーブル定義情報ファイルを生成
ant -f definitioninfogenerator.xml generate-tableDef
# 外部インターフェース設計情報ファイルを生成
ant -f definitioninfogenerator.xml generate-interfaceDef
```

<details>
<summary>keywords</summary>

ツール配置場所, tool/definitioninfogenerator, チュートリアルプロジェクト, doc, resources, definfogen.xml, definfogen.properties, Antビルドファイル, プロパティファイル, definitioninfogenerator.xml, ant generate, generate-messageDef, generate-domainDef, generate-validationDef, generate-dataTypeDef, generate-codeDef, generate-tableDef, generate-interfaceDef, 定義データ自動生成, antコマンド実行

</details>

## 出力ファイル毎の設定ファイル

## 出力ファイル毎の設定ファイル

| ファイル | 設定内容 |
|---|---|
| `resources/definitioninfogenerator/tableinfogenerator.xml` | テーブル定義取得用のコンポーネント定義ファイル。定義書のレイアウト等。 |
| `resources/definitioninfogenerator/domaininfogenerator.xml` | ドメイン定義取得用のコンポーネント定義ファイル。定義書のレイアウト等。 |
| `resources/definitioninfogenerator/validationinfogenerator.xml` | 精査処理定義取得用のコンポーネント定義ファイル。定義書のレイアウト等。 |
| `resources/definitioninfogenerator/datatypeinfogenerator.xml` | データタイプ定義取得用のコンポーネント定義ファイル。定義書のレイアウト等。 |
| `resources/definitioninfogenerator/messageifogenerator.xml` | メッセージ設計取得用のコンポーネント定義ファイル。設計書のレイアウト等。 |
| `resources/definitioninfogenerator/codeinfogenerator.xml` | コード設計取得用のコンポーネント定義ファイル。設計書のレイアウト等。 |
| `resources/definitioninfogenerator/interfaceinfogenerator.xml` | 外部インターフェース設計取得用のコンポーネント定義ファイル。設計書のレイアウト等。 |

各定義データをJSON形式で出力する。設計書種別ごとの出力フォーマットは、メッセージ設計・ドメイン定義・精査処理定義・データタイプ定義・テーブル定義・コード設計・外部インターフェース設計の各セクションを参照。

<details>
<summary>keywords</summary>

出力ファイル毎の設定ファイル, tableinfogenerator.xml, domaininfogenerator.xml, validationinfogenerator.xml, datatypeinfogenerator.xml, messageifogenerator.xml, codeinfogenerator.xml, interfaceinfogenerator.xml, コンポーネント定義ファイル一覧, JSON出力, define関数, 出力フォーマット, 定義データ出力形式

</details>

## 共通の設定ファイル

## 共通の設定ファイル

| ファイル | 設定内容 |
|---|---|
| `resources/definitioninfogenerator/definitioninfogenerator.config` | 環境設定ファイル。定義書/設計書へのパス等。 |

メッセージ設計情報の出力フォーマット:

```javascript
define(function(){ return {"": ""

, "メッセージID": ["メッセージ内容"]

};});
```

<details>
<summary>keywords</summary>

共通の設定ファイル, definitioninfogenerator.config, 環境設定ファイル, 定義書パス設定, メッセージID, メッセージ内容, メッセージ設計出力形式

</details>

## 環境設定ファイル

## 環境設定ファイル

基本的な設定はこの環境設定ファイルで行う。設計書のレイアウトも含めNablarch標準を使用している場合、ファイルパス以外は修正不要。

ドメイン定義情報の出力フォーマット:

```javascript
define(function(){ return {"": ""

, "ドメイン名（物理）": ["ドメイン名（論理）", "データタイプ", "桁数（数値）", "小数部桁数", "データ型", "ドメイン定義"]

};});
```

<details>
<summary>keywords</summary>

環境設定ファイル, Nablarch標準設定, ファイルパス設定, 設計書レイアウト, ドメイン名, データタイプ, ドメイン定義出力形式, 小数部桁数

</details>

## 入力となる設計書に関する設定

## 入力となる設計書に関する設定

| キー名 | 設定内容 |
|---|---|
| `tableDefinitionFilePath` | テーブル定義書のファイルパス |
| `domainDefinitionFilePath` | ドメイン定義書のファイルパス |
| `codeDesignFilePath` | コード設計書のファイルパス |
| `messageDesignFilePath` | メッセージ設計書のファイルパス |
| `interfaceDesignFilePath` | 外部インターフェース設計書のファイルパス |
| `interfaceFileDir` | 外部インタフェース設計書が置かれているディレクトリ |
| `interfaceFileNamePattern` | 自動生成対象の外部インタフェース設計書を正規表現で指定。例: `.*.xls`（全Excel対象）、`外部インターフェース設計書_サンプル1.xls`（完全一致） |

精査処理定義情報の出力フォーマット:

```javascript
define(function(){ return {"": ""

, "精査処理名": ["アノテーション名(物理名)", "引数1", "引数2", "引数3", "引数4", "引数5", "アノテーション完全修飾名", "備考"]

};});
```

<details>
<summary>keywords</summary>

入力設計書設定, tableDefinitionFilePath, domainDefinitionFilePath, codeDesignFilePath, messageDesignFilePath, interfaceDesignFilePath, interfaceFileDir, interfaceFileNamePattern, テーブル定義書, 外部インターフェース設計書, 精査処理名, アノテーション名, アノテーション完全修飾名, 精査処理定義出力形式, バリデーション定義

</details>

## ファイル生成に関する設定

## ファイル生成に関する設定

| キー名 | 設定内容 |
|---|---|
| `outputDir` | ファイル出力先ディレクトリ |
| `lineSeparator` | 出力ファイル改行（`"CR"`, `"LF"`, `"CRLF"` のいずれか） |

データタイプ定義情報の出力フォーマット:

```javascript
define(function(){ return {"": ""

, "データタイプ": ["長さ精査", "データタイプ精査", "引数1（引数名）", "引数1（設定値）", "引数2（引数名）", "引数2（設定値）", "引数3（引数名）", "引数3（設定値）", "引数4（引数名）", "引数4（設定値）", "引数5（引数名）", "引数5（設定値）", "備考"]

};});
```

<details>
<summary>keywords</summary>

ファイル生成設定, outputDir, lineSeparator, 出力先ディレクトリ, 改行コード, データタイプ, 長さ精査, データタイプ精査, データタイプ定義出力形式

</details>

## コンポーネント定義ファイル

## コンポーネント定義ファイル

設計書からどのように情報を読み取るかという設定を記載するファイル。設計書のレイアウト変更時（列追加・行追加など）に修正が必要。

テーブル定義情報の出力フォーマット:

```javascript
define(function(){ return {"": ""

// テーブル情報
, "物理テーブル名": ["論理テーブル名", "テーブル説明"]

// カラム情報
, "物理テーブル名.物理名称": ["論理名称", "ドメイン名", "データ型", "桁数", "PK", "必須", "項目定義", "初期値", "暗号化対象", "備考"]

};});
```

<details>
<summary>keywords</summary>

コンポーネント定義ファイル, 設計書読み取り設定, レイアウト設定, 定義情報生成ツール設定, 物理テーブル名, 論理テーブル名, カラム情報, テーブル定義出力形式

</details>

## 入力ファイル読み取り設定

## 入力ファイル読み取り設定

設計書のレイアウトに以下の変更が生じた場合、コンポーネント定義ファイルを修正する。

| 変更内容 | 修正対象プロパティ |
|---|---|
| 列の追加（読み取り対象カラムの位置がずれた場合） | `indexNamePairs` |
| 行の追加（読み取り開始行がずれた場合） | `startRowIndex` |

> **注意**: `excludedSheets` プロパティには取込対象外のシートを指定する。メッセージ設計書に言語シートを追加するなど、取込が不要なシートを追加した場合、`excludedSheets` プロパティの指定を追加すること。

**ドメイン定義、精査処理定義、データタイプ定義**を読み取る設定は、メッセージ設計書（`DefinitionFileLoader`）と設定項目が同じであるため、それぞれのコンポーネント定義ファイルではメッセージ設計書の読込設定と同じクラスおよびプロパティ構成を使用する。

コード設計情報の出力フォーマット。コード定義情報は、コードIDに対応する各セルの値を "|" で結合して出力する。キーに含まれる "." 以下の文字列（codeValue、sortOrderなど）は固定。

```javascript
define(function(){ return {"": ""

// コードID情報
, "コードID": ["コード名称", "説明"]

// コード定義情報
, "コードID.codeValue": ["コード値"]
, "コードID.sortOrder": ["ソート順"]
, "コードID.codeValueName": ["名称"]
, "コードID.SHORT_NAME": ["略称"]
, "コードID.OPTIONAL_NAME01": ["オプション名称1"]
// OPTIONAL_NAME02〜09は省略
, "コードID.OPTIONAL_NAME10": ["オプション名称10"]
, "コードID.PATTERN01": ["パターン1"]
// PATTERN02〜19は省略
, "コードID.PATTERN20": ["パターン20"]

};});
```

> **注意**: セルの書式が数値型の場合、整数を指定しても自動的に ".0" が付与される。整数をそのまま取得したい場合は、セルの書式を標準または文字列にすること。

<details>
<summary>keywords</summary>

入力ファイル読み取り設定, indexNamePairs, startRowIndex, excludedSheets, 列位置変更, 開始行変更, シート除外設定, ドメイン定義, 精査処理定義, データタイプ定義, DefinitionFileLoader, メッセージ設計書と同じ設定, コードID, codeValue, sortOrder, codeValueName, SHORT_NAME, OPTIONAL_NAME, PATTERN, コード設計出力形式, Apache POI, 数値型セル書式

</details>

## メッセージ設計書の読込設定

## メッセージ設計書の読込設定

```xml
<component name="messageDesignLoader"
           class="nablarch.tool.definitioninfogenerator.loader.poi.DefinitionFileLoader">
  <property name="pathToBook" value="${messageDesignFilePath}"/>
  <property name="startRowIndex" value="6"/>
  <property name="keyName" value="messageId"/>
  <property name="columnDefs" ref="messageDesignColumnDefs"/>
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

<component name="messageDesignColumnDefs"
           class="nablarch.tool.util.poi.XlsColumnDefs">
  <property name="indexNamePairs">
    <map>
      <!-- key：Excelの列位置（0オリジン）、value：データを取得する際のkey -->
      <entry key="0" value="messageId"/>
      <entry key="5" value="message"/>
    </map>
  </property>
</component>
```

外部インターフェース設計情報の出力フォーマット。階層構造型とそれ以外の設計書、どちらが入力の場合も同一フォーマットで出力する。入力設計書に存在しない項目は空文字で出力。

親要素名の設定ルール:
- 非階層構造型レコード: レコードタイプ名
- 階層構造型レコード: オブジェクト定義行（項目IDが `[]` で囲まれた行）の項目IDから `[` と `]` を除去した値

```javascript
define(function(){ return {"": ""

// 外部インターフェース仕様情報
, "ファイルIDまたは電文ID": ["相手先", "入出力取引ID/名称"]

// データレイアウト情報（プロパティ定義行のみ出力）
, "ファイルIDまたは電文ID.親要素名.項目ID": ["項目名", "ドメイン名", "データタイプ", "デフォルト値", "備考", "必須", "Byte", "開始位置", "パディング", "小数点位置", "フォーマット仕様", "寄せ字", "属性", "多重度"]

};});
```

<details>
<summary>keywords</summary>

メッセージ設計書読込設定, DefinitionFileLoader, nablarch.tool.definitioninfogenerator.loader.poi.DefinitionFileLoader, messageDesignLoader, XlsColumnDefs, nablarch.tool.util.poi.XlsColumnDefs, messageDesignColumnDefs, messageId, ファイルID, 電文ID, 親要素名, 項目ID, 階層構造型レコード, 外部インターフェース設計出力形式, データレイアウト情報

</details>

## テーブル定義書の読込設定

## テーブル定義書の読込設定

```xml
<component name="tableDefinitionLoader"
           class="nablarch.tool.definitioninfogenerator.loader.poi.TableDefinitionFileLoader">
  <property name="pathToBook" value="${tableDefinitionFilePath}"/>
  <property name="startRowIndex" value="10"/>
  <property name="keyName" value="physicalColumnName"/>
  <property name="logicalTableNameRowIndex" value="4"/>
  <property name="logicalTableNameColumnIndex" value="5"/>
  <property name="physicalTableNameRowIndex" value="4"/>
  <property name="physicalTableNameColumnIndex" value="22"/>
  <property name="tableDescriptionRowIndex" value="5"/>
  <property name="tableDescriptionColumnIndex" value="5"/>
  <property name="columnDefs" ref="tableDefinitionColumnDefs"/>
  <property name="excludedSheets">
    <list>
      <value>表紙</value>
      <value>変更履歴</value>
      <value>目次</value>
      <value>データ</value>
    </list>
  </property>
</component>

<component name="tableDefinitionColumnDefs"
           class="nablarch.tool.util.poi.XlsColumnDefs">
  <property name="indexNamePairs">
    <map>
      <!-- key：Excelの列位置（0オリジン）、value：データを取得する際のkey -->
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

自動生成ツールの出力に関する仕様を定義するセクション。各設計書のJSONフォーマット（出力形式）と定義データ出力時のエスケープ処理規則（定義データの出力仕様）を含む。

<details>
<summary>keywords</summary>

テーブル定義書読込設定, TableDefinitionFileLoader, nablarch.tool.definitioninfogenerator.loader.poi.TableDefinitionFileLoader, tableDefinitionLoader, XlsColumnDefs, tableDefinitionColumnDefs, physicalColumnName, logicalColumnName, domainName, dataType, length, primaryKeyOrder, required, columnDefinition, initialValue, encryptionTarget, note, 定義情報ジェネレータ仕様, 自動生成ツール出力仕様, JSON出力仕様

</details>

## コード設計書の読込設定

## コード設計書の読込設定

```xml
<component name="codeDefinitionLoader"
           class="nablarch.tool.definitioninfogenerator.loader.poi.CodeDefinitionFileLoader">
  <property name="pathToBook" value="${codeDesignFilePath}"/>
  <property name="startRowIndex" value="11"/>
  <property name="keyName" value="codeId"/>
  <property name="codeNameKey" value="codeName"/>
  <property name="codeDescriptionKey" value="codeDescription"/>
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
  <property name="excludedSheets">
    <list>
      <value>表紙</value>
      <value>変更履歴</value>
      <value>目次</value>
      <value>en</value>
    </list>
  </property>
</component>

<component name="codeDesignColumnDefs"
           class="nablarch.tool.util.poi.XlsColumnDefs">
  <property name="indexNamePairs">
    <map>
      <!-- key：Excelの列位置（0オリジン）、value：データを取得する際のkey -->
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

定義データをJSON形式で出力する際の仕様。エスケープ処理の規則は「エスケープ処理」セクションを参照。設計書ごとにキャメル変換などは行わず、Apache POIで取得した値をそのまま出力する。

<details>
<summary>keywords</summary>

コード設計書読込設定, CodeDefinitionFileLoader, nablarch.tool.definitioninfogenerator.loader.poi.CodeDefinitionFileLoader, codeDefinitionLoader, XlsColumnDefs, codeDesignColumnDefs, codeId, codeName, codeValue, PATTERN01, 定義データ出力仕様, エスケープ処理, JSON出力仕様, Apache POI, キャメル変換

</details>

## エスケープ処理

定義データをJSON形式で出力する際、以下の文字をエスケープ処理する:

- `\`（バックスラッシュ）
- `"`（ダブルクォート）
- `/`（スラッシュ）
- `\b`（バックスペース）
- `\f`（フォームフィード）
- `\t`（タブ）
- `\n`（改行LF）
- `\r`（改行CR）

> **注意**: `\r` と `\n` は除去される（エスケープ後の文字列から削除）。

<details>
<summary>keywords</summary>

エスケープ処理, JSON文字エスケープ, バックスラッシュ, 改行除去, \r, \n

</details>
