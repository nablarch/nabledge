# コード管理

## 概要

コード値とコード名称を管理する機能。性別区分・年代区分など「コード値とコード名称の関係が静的なコード」のみが対象。

> **重要**: 商品コードや企業コードのような動的なデータのキー値は対象外。これらはマスタテーブルで対処すること。

> **重要**: コード名称テーブルとコード値テーブルにRDBMSの参照整合性制約は設定できない。このようなチェックには :ref:`code_manager_validation` を使用すること。

リポジトリに登録して使用する。初期化処理は :ref:`repository` が実行する。

コード管理を使用する際は、リポジトリに `codeManager` というコンポーネント名で `CodeManager` インタフェースを実装したクラスを登録する必要がある。

**デフォルト実装**: `nablarch.common.code.BasicCodeManager`（CodeManagerインタフェースのデフォルト実装）

<details>
<summary>keywords</summary>

コード管理, コード値, コード名称, CodeManager, 静的コード, リポジトリ登録, code_manager_validation, 参照整合性制約, BasicCodeManager, BasicCodeLoader, BasicStaticDataCache, CodePatternSchema, CodeNameSchema, SimpleDbTransactionManager, BasicApplicationInitializer, codeManager, コード管理設定, リポジトリ設定

</details>

## 特徴

- **国際化**: 言語ごとに異なるコード名称を取得できる。
- **パターン指定**: コード値の一部のみをパターン指定で取得できる。入力チェックや特定コード値のみのコンボボックス作成に活用。
- **高速アクセス**: :ref:`static_data_cache` でコード値・名称をキャッシュ。DBへの繰り返しアクセスを防ぐ。

キャッシュロードタイミングの推奨:

| アプリケーション種類 | キャッシュロードタイミング |
|---|---|
| Webアプリケーション | 一括ロード（起動中にほぼ全コードが使用されるため） |
| バッチアプリケーション | オンデマンドロード（全コードを使用しないため） |

> **注意**: 本機能はアプリケーション再起動なしのキャッシュリロードを想定していない（静的コードを前提とした設計のため）。ただし :ref:`static_data_cache` にはリロード機能が実装されており技術的には可能。使用はプロジェクトの責任で行うこと。

`BasicCodeManager` クラスを使用したコード管理の設定例:

```xml
<!-- DbManagerの設定 -->
<component name="codeDbManager" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
    <property name="dbTransactionName" value="code"/>
</component>

<component name="codeLoader"
           class="nablarch.common.code.BasicCodeLoader">

    <property name="dbManager" ref="codeDbManager"/>

    <!-- コードパターンテーブルのスキーマ情報 -->
    <property name="codePatternSchema">
        <component class="nablarch.common.code.schema.CodePatternSchema">
            <property name="tableName" value="CODE_PATTERN"/>
            <property name="idColumnName" value="ID"/>
            <property name="valueColumnName" value="VALUE"/>
            <property name="patternColumnNames" value="PATTERN1,PATTERN2,PATTERN3"/>
        </component>
    </property>

    <!-- コード名称テーブルのスキーマ情報 -->
    <property name="codeNameSchema">
        <component class="nablarch.common.code.schema.CodeNameSchema">
            <property name="tableName" value="CODE_NAME"/>
            <property name="idColumnName" value="ID"/>
            <property name="valueColumnName" value="VALUE"/>
            <property name="langColumnName" value="LANG"/>
            <property name="sortOrderColumnName" value="SORT_ORDER"/>
            <property name="nameColumnName" value="NAME"/>
            <property name="shortNameColumnName" value="SHORT_NAME"/>
            <property name="optionNameColumnNames" value="NAME_WITH_VALUE,OPTION01"/>
        </component>
    </property>
</component>

<component name="codeCache"
           class="nablarch.core.cache.BasicStaticDataCache" >

    <property name="loader" ref="codeLoader"/>

    <property name="loadOnStartup" value="false"/>
</component>

<component name="codeManager"
    class="nablarch.common.code.BasicCodeManager" autowireType="None">
    <property name="codeDefinitionCache" ref="codeCache"/>
</component>

<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="codeCache"/>
        </list>
    </property>
</component>
```

<details>
<summary>keywords</summary>

国際化, パターン指定, キャッシュ, static_data_cache, 一括ロード, オンデマンドロード, 高速アクセス, キャッシュリロード, BasicCodeManager, BasicCodeLoader, BasicStaticDataCache, SimpleDbTransactionManager, CodePatternSchema, CodeNameSchema, BasicApplicationInitializer, codeManager, 設定ファイル例, XML設定

</details>

## インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| `nablarch.common.code.CodeManager` | コード値・名称取得と存在チェックメソッドを持つインタフェース |
| `nablarch.common.code.Code` | 単一コードデータ（コードIDに紐づく）へのアクセスインタフェース |

**クラス**: `nablarch.common.code.BasicCodeManager`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| codeDefinitionCache | StaticDataCache | ○ | | CodeインタフェースのStaticDataCacheを設定する |

<details>
<summary>keywords</summary>

CodeManager, Code, nablarch.common.code.CodeManager, nablarch.common.code.Code, インタフェース定義, BasicCodeManager, codeDefinitionCache, コード管理, StaticDataCache

</details>

## クラス定義

| クラス名 | 概要 |
|---|---|
| `nablarch.common.code.BasicCodeManager` | コード値・名称を取り扱うクラス |
| `nablarch.common.code.BasicCodeLoader` | DBからコードをロードするクラス |
| `nablarch.common.code.BasicCode` | Codeの基本実装。BasicCodeLoaderの内部クラス |
| `nablarch.common.code.CodeUtil` | コード値・名称取り扱いのユーティリティクラス |

**クラス**: `nablarch.core.cache.BasicStaticDataCache`

[../01_Core/05_StaticDataCache](libraries-05_StaticDataCache.md) を参照。

> **警告**: このプロパティに設定するStaticDataLoaderは、`BasicCodeLoader`クラスのように `StaticDataLoader<Code>` を実装すること。

<details>
<summary>keywords</summary>

BasicCodeManager, BasicCodeLoader, BasicCode, CodeUtil, nablarch.common.code.BasicCodeManager, nablarch.common.code.BasicCodeLoader, nablarch.common.code.BasicCode, nablarch.common.code.CodeUtil, BasicStaticDataCache, StaticDataLoader, StaticDataCache設定, Code

</details>

## コードパターンテーブルの定義

コードの値とパターンを持つテーブル。テーブル名・カラム名は設定で任意に指定可能。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| コードID | java.lang.String | ユニークキー |
| コード値 | java.lang.String | ユニークキー |
| パターン（複数可） | java.lang.String | パターンに含める場合 "1"、含めない場合 "0" |

複数パターンを使用する場合、パターン数分の別カラムをテーブルに定義する。パターンカラム名は任意に設定可能。

**クラス**: `nablarch.common.code.BasicCodeLoader`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| dbManager | SimpleDbTransactionManager | ○ | | コードのロード時に使用するSimpleDbTransactionManagerを指定する |
| codePatternSchema | CodePatternSchema | ○ | | コードパターンテーブルのスキーマ情報。CodePatternSchemaクラスのインスタンス |
| codeNameSchema | CodeNameSchema | ○ | | コード名称テーブルのスキーマ情報。CodeNameSchemaクラスのインスタンス |

<details>
<summary>keywords</summary>

コードパターンテーブル, パターン, コードID, コード値, テーブル定義, BasicCodeLoader, SimpleDbTransactionManager, CodePatternSchema, CodeNameSchema, dbManager, codePatternSchema, codeNameSchema, コードローダー設定

</details>

## コード名称テーブルの定義

コード名称を持つテーブル。テーブル名・カラム名は設定で任意に指定可能。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| コードID | java.lang.String | ユニークキー |
| コード値 | java.lang.String | ユニークキー |
| 言語 | java.lang.String | ユニークキー |
| ソート順 | java.lang.String | |
| 名称 | java.lang.String | コードの名称 |
| 略称 | java.lang.String | コードの略称 |
| オプション名称（複数可） | java.lang.String | 1コード値に複数持てる。数・カラム名は任意 |

**クラス**: `nablarch.common.code.schema.CodePatternSchema`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| tableName |  | ○ | | テーブル名 |
| idColumnName |  | ○ | | コードIDカラムの名前 |
| valueColumnName |  | ○ | | コード値カラムの名前 |
| patternColumnNames | String[] | | | パターンに使用するカラム名（複数指定可）。パターン機能を使用する場合は設定必須 |

<details>
<summary>keywords</summary>

コード名称テーブル, 言語, ソート順, 略称, オプション名称, テーブル定義, CodePatternSchema, tableName, idColumnName, valueColumnName, patternColumnNames, コードパターンテーブル, パターン機能, スキーマ設定

</details>

## テーブル定義の例

![テーブル定義例](../../../knowledge/component/libraries/assets/libraries-02_CodeManager/02_CodeManager_DatabaseDiagram.jpg)

この例では、1コードIDにつき3パターン（PATTERN1〜PATTERN3）を設定。コード名称テーブルには名称（NAME）、略称（SHORT_NAME）、オプション名称（NAME_WITH_VALUE）のカラムを持つ。

**クラス**: `nablarch.common.code.schema.CodeNameSchema`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| tableName |  | ○ | | テーブル名 |
| idColumnName |  | ○ | | コードIDカラムの名前 |
| valueColumnName |  | ○ | | コード値カラムの名前 |
| langColumnName |  | ○ | | 言語カラムの名前 |
| sortOrderColumnName |  | ○ | | ソート順カラムの名前 |
| nameColumnName |  | ○ | | 名称カラムの名前 |
| shortNameColumnName |  | ○ | | 略称カラムの名前 |
| optionNameColumnNames | String[] | | | コードのオプション名称に使用するカラム名。指定しない場合、オプション名称が取得できない |

<details>
<summary>keywords</summary>

NAME, SHORT_NAME, NAME_WITH_VALUE, テーブル定義例, CODE_PATTERN, CODE_NAME, パターン数, CodeNameSchema, tableName, idColumnName, valueColumnName, langColumnName, sortOrderColumnName, nameColumnName, shortNameColumnName, optionNameColumnNames, コード名称テーブル, オプション名称, スキーマ設定

</details>

## コード値とコード名称のデータ

CODE_PATTERNテーブルデータ例（コードID 0001: 性別区分, 0002: バッチ処理状態）:

| ID | VALUE | PATTERN1 | PATTERN2 | PATTERN3 |
|---|---|---|---|---|
| 0001 | 1 | 1 | 0 | 0 |
| 0001 | 2 | 1 | 0 | 0 |
| 0001 | 9 | 0 | 0 | 0 |
| 0002 | 01 | 1 | 0 | 0 |
| 0002 | 02 | 1 | 0 | 0 |
| 0002 | 03 | 0 | 1 | 0 |
| 0002 | 04 | 0 | 1 | 0 |
| 0002 | 05 | 1 | 0 | 0 |

CODE_NAMEテーブルデータ例:

| ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | NAME_WITH_VALUE |
|---|---|---|---|---|---|---|
| 0001 | 1 | 1 | ja | 男性 | 男 | 1:男性 |
| 0001 | 2 | 2 | ja | 女性 | 女 | 2:女性 |
| 0001 | 9 | 3 | ja | 不明 | 不 | 9:不明 |
| 0002 | 01 | 1 | ja | 初期状態 | 初期 | |
| 0002 | 02 | 2 | ja | 処理開始待ち | 待ち | |
| 0002 | 03 | 3 | ja | 処理実行中 | 実行 | |
| 0002 | 04 | 4 | ja | 処理実行完了 | 完了 | |
| 0002 | 05 | 5 | ja | 処理結果確認完了 | 確認 | |
| 0001 | 1 | 2 | en | Male | M | 1:Male |
| 0001 | 2 | 1 | en | Female | F | 2:Female |
| 0001 | 9 | 3 | en | Unknown | U | 9:Unknown |
| 0002 | 01 | 1 | en | Initial State | Initial | |
| 0002 | 02 | 2 | en | Waiting For Batch Start | Waiting | |
| 0002 | 03 | 3 | en | Batch Running | Running | |
| 0002 | 04 | 4 | en | Batch Execute Completed Checked | Completed | |
| 0002 | 05 | 5 | en | Batch Result Checked | Checked | |

**クラス**: `nablarch.common.code.validator.CodeValueValidator`
**アノテーション**: `@CodeValue`

コード値（DBに永続化するもの）は [バリデーションの機能](libraries-validation-core_library.md) を使用してバリデーションを行う。`contains` メソッドの戻り値が `true` かをチェックする。

Entityのプロパティに `@CodeValue` アノテーションを付与して実装する。`pattern` 属性にはパターンのカラム名を指定する。`pattern` 属性を省略するとコード値として有効かのみチェックする（パターン一致チェックなし）。

```java
public class Customer {
    private String gender;

    @PropertyName("性別")
    @CodeValue(codeId="0001", pattern="PATTERN1")
    public String setGender(String gender) {
        this.gender = gender;
    }
}
```

[validation_and_convert](libraries-08_02_validation_usage.md) で記述した方法で `ValidationUtil` クラスの `validateAndConvertRequest` メソッドを呼び出すことで、パターンに含まれない値を設定した際にバリデーションエラーになる。

`CodeValueValidator` は [バリデーションの設定](libraries-08_01_validation_architecture.md) で記述した他のバリデータと同様に `ValidationManager` の `validators` プロパティに追加する。

```xml
<component name="validationManager" class="nablarch.core.validation.ValidationManager">
    <property name="validators">
        <list>
            <component class="nablarch.common.code.validator.CodeValueValidator">
                <property name="messageId" value="MSGXXXXX"/>
            </component>
        </list>
    </property>
</component>
```

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| messageId | String | ○ | | パターンに含まれない文字列入力時のデフォルトエラーメッセージID。置換文字: {0}=プロパティ名、{1}=使用できるコード値一覧。このメッセージはコンボボックス改竄またはテキストボックスでのコード値入力という特殊ケースでのみ使用されるため、使用状況を考慮して設計すること |

**messageIdのメッセージ形式例**:
- テンプレート: `{0}には'{'{1}'}'のいずれかの値を指定してください。`
- フォーマット後: `性別には{"01" , "02"}のいずれかの値を指定してください。`

<details>
<summary>keywords</summary>

CODE_PATTERN, CODE_NAME, データ例, 性別区分, バッチ処理状態, コードデータ, CodeValueValidator, @CodeValue, @PropertyName, messageId, ValidationManager, コード値バリデーション, パターンチェック, contains, ValidationUtil, validateAndConvertRequest

</details>

## コード名称の取得

`CodeUtil`でコード名称を取得する。

```java
// ThreadContextの言語により "男性" または "Male" を取得
String name = CodeUtil.getName("0001", "1");

// 言語を明示して取得（"男性"）
String jaName = CodeUtil.getName("0001", "1", Locale.JAPANESE);

// 略称取得（"男" または "M"）
String shortName = CodeUtil.getShortName("0001", "1");

// オプション名称取得（"1:男性" または "1:Male"）
String optName = CodeUtil.getOptionalName("0001", "1", "NAME_WITH_VALUE");
```

名称取得メソッド一覧:

| メソッド名 | 説明 |
|---|---|
| getName | コード名称を取得 |
| getShortName | コードの略称を取得 |
| getOptionalName | オプション名称を取得（第3引数でカラム名指定） |

<details>
<summary>keywords</summary>

getName, getShortName, getOptionalName, コード名称取得, CodeUtil, 言語指定, Locale

</details>

## コード値の取得

コードID配下の全コード値を取得するメソッド:
- `getValues(String codeId)`
- `getValues(String codeId, Locale locale)`

取得結果はコード名称テーブルのソート順カラムの昇順でソートされる。言語ごとにソート順を変えることができる。

```java
// 性別区分の全コード値（言語により {"1","2","9"} または {"2","1","9"}）
List<String> genderValues = CodeUtil.getValues("0001");

// バッチ処理状態の全コード値（{"01","02","03","04","05"}）
List<String> stateValues = CodeUtil.getValues("0002");
```

<details>
<summary>keywords</summary>

getValues, コード値取得, ソート順, CodeUtil, Locale

</details>

## コード値の有効性チェック

`CodeUtil.contains`メソッドでコード値の有効性をチェックする。

```java
// "1" は有効 → true
CodeUtil.contains("0001", "1");

// "3" は有効でない → false
CodeUtil.contains("0001", "3");
```

<details>
<summary>keywords</summary>

contains, コード値チェック, 有効性チェック, CodeUtil

</details>

## コード値のパターン

パターンに含まれるコード値のみを取得・チェックするメソッド:
- `getValues(String codeId, String pattern)`
- `getValues(String codeId, String pattern, Locale locale)`
- `contains(String codeId, String value, String pattern)`

`pattern`引数にはパターンのカラム名を指定する。

```java
// "PATTERN1" に含まれるコード値を取得（{"1","2"} または {"2","1"}）
List<String> values = CodeUtil.getValues("0001", "PATTERN1");

// "1" は PATTERN1 で有効 → true
CodeUtil.contains("0001", "1", "PATTERN1");

// "3" は PATTERN1 で有効でない → false
CodeUtil.contains("0001", "3", "PATTERN1");
```

<details>
<summary>keywords</summary>

getValues, contains, パターン指定, PATTERN1, コード値のパターン, CodeUtil

</details>

## 未検討の機能（未実装）

> **重要**: 以下の機能はコード管理機能では**実装されていない**。これらの用途にCodeManagerを使用することはできない。

- **外部システム用コード変換**: 自システムのコード値と外部システムのコード値を相互変換する機能（自システムのコード値⇔外部システムのコード値の変換）は未実装。
- **コード値の有効期限管理**: コード値に有効期限を設定して管理する機能は未実装。

<details>
<summary>keywords</summary>

未検討, 未実装, 外部システム, コード変換, 有効期限, コード値の有効期限, 外部システム用コード変換

</details>
