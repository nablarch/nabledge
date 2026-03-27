# コード管理

## 概要

コード値とコード名称を管理する機能。性別区分（1:男性、2:女性）などの**静的なコード**（コード値とコード名称の関係が変わらないもの）のみを対象とする。コードIDでコード種別を識別し、コードIDごとに別々に定義する。

- 動的なデータのキー値（商品コード、企業コードなど）は対象外。アプリ側でマスタテーブルを作成して対処する。
- 本機能使用時、コードの名称テーブルとコード値テーブルにRDBMSの参照整合性制約を設定できない。このようなチェックには :ref:`code_manager_validation` を使用すること。
- リポジトリに登録して使用。初期化処理は :ref:`repository` が実行する。
- アプリケーションプログラマは画面表示用コード名称の取得とコード値の取得に使用する。

リポジトリに `"codeManager"` というコンポーネント名で `CodeManager` インタフェースを実装したクラスを登録する必要がある。

**クラス**: `nablarch.common.code.BasicCodeManager`（`CodeManager` インタフェースのデフォルト実装）

```xml
<!-- DbManagerの設定 -->
<component name="codeDbManager" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
    <property name="dbTransactionName" value="code"/>
</component>

<component name="codeLoader" class="nablarch.common.code.BasicCodeLoader">
    <property name="dbManager" ref="codeDbManager"/>
    <property name="codePatternSchema">
        <component class="nablarch.common.code.schema.CodePatternSchema">
            <property name="tableName" value="CODE_PATTERN"/>
            <property name="idColumnName" value="ID"/>
            <property name="valueColumnName" value="VALUE"/>
            <property name="patternColumnNames" value="PATTERN1,PATTERN2,PATTERN3"/>
        </component>
    </property>
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

<component name="codeCache" class="nablarch.core.cache.BasicStaticDataCache">
    <property name="loader" ref="codeLoader"/>
    <property name="loadOnStartup" value="false"/>
</component>

<component name="codeManager" class="nablarch.common.code.BasicCodeManager" autowireType="None">
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

コード管理, コード値, コード名称, CodeManager, 参照整合性制約, 静的コード, コードID, BasicCodeManager, BasicCodeLoader, BasicStaticDataCache, BasicApplicationInitializer, コード管理設定, codeManager コンポーネント登録

</details>

## 特徴

## 国際化

言語ごとに異なるコード名称を取得できる。

## パターン指定によるコード値の取得

一部のコード値のみを取得するパターン指定が可能。コード値の入力チェックや特定コード値のみ表示するコンボボックスの作成に使用できる。

## 高速なコードへのアクセス

:ref:`static_data_cache` でコード値・コード名称をキャッシュ。DBを繰り返しロードしない。キャッシュロードタイミングは設定変更のみで変更可能。

| アプリケーションの種類 | キャッシュにデータをロードするタイミング |
|---|---|
| Webアプリケーション | 一括ロード（アプリ起動中にほぼ全コードが使用されるため） |
| バッチアプリケーション | オンデマンドロード（処理過程で全コードを使用しないため） |

> **注意**: コードの意味変更時はアプリ修正が必要と想定されるため、再起動なしのキャッシュリロードは本機能では想定されていない。ただし、:ref:`static_data_cache` にはリロード機能が実装されており実際にはリロード可能。使用はプロジェクトの責任で行うこと。

**クラス**: `nablarch.common.code.BasicCodeManager`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| codeDefinitionCache | StaticDataCache | ○ | | `Code` インタフェースを実装したクラスを保持する `StaticDataCache` を設定する |

<details>
<summary>keywords</summary>

国際化, パターン指定, キャッシュ, static_data_cache, オンデマンドロード, 一括ロード, コードキャッシュ, BasicCodeManager, codeDefinitionCache, StaticDataCache, コード管理プロパティ設定

</details>

## インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| `nablarch.common.code.CodeManager` | コードの値と名称を取り扱うインタフェース。コード値・コード名称の取得メソッドとコード値の存在チェックメソッドを持つ。 |
| `nablarch.common.code.Code` | 単一のコードデータ（コードIDに紐づくデータ）にアクセスするインタフェース。 |

[../01_Core/05_StaticDataCache](libraries-05_StaticDataCache.md) を参照。

> **警告**: このプロパティに設定する `StaticDataLoader` は、`BasicCodeLoader` クラスのように、`StaticDataLoader<Code>` を実装すること。

<details>
<summary>keywords</summary>

CodeManager, Code, nablarch.common.code.CodeManager, nablarch.common.code.Code, インタフェース定義, BasicStaticDataCache, StaticDataLoader, StaticDataCache, コードキャッシュ設定

</details>

## クラス定義

| クラス名 | 概要 |
|---|---|
| `nablarch.common.code.BasicCodeManager` | コードの値と名称を取り扱うクラス。 |
| `nablarch.common.code.BasicCodeLoader` | データベースからコードをロードするクラス。 |
| `nablarch.common.code.BasicCode` | Codeの基本実装クラス。BasicCodeLoaderの内部クラス。 |
| `nablarch.common.code.CodeUtil` | コードの値と名称の取り扱いに使用するユーティリティクラス。 |

**クラス**: `nablarch.common.code.BasicCodeLoader`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| dbManager | SimpleDbTransactionManager | ○ | | コードのロード時に使用する `SimpleDbTransactionManager` クラスを指定する |
| codePatternSchema | CodePatternSchema | ○ | | コードパターンテーブルのスキーマ情報。`CodePatternSchema` クラスのインスタンス |
| codeNameSchema | CodeNameSchema | ○ | | コード名称テーブルのスキーマ情報。`CodeNameSchema` クラスのインスタンス |

<details>
<summary>keywords</summary>

BasicCodeManager, BasicCodeLoader, BasicCode, CodeUtil, nablarch.common.code.BasicCodeManager, nablarch.common.code.BasicCode, nablarch.common.code.CodeUtil, nablarch.common.code.BasicCodeLoader, dbManager, codePatternSchema, codeNameSchema, SimpleDbTransactionManager, コードローダー設定

</details>

## コードパターンテーブルの定義

コードの値とパターンを持つテーブル。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| コードID | java.lang.String | ユニークキー |
| コード値 | java.lang.String | ユニークキー |
| パターン | java.lang.String | パターンに含める場合 `"1"`、含めない場合 `"0"` を設定する |

- パターンカラム名は任意設定可能。プロジェクトで必要な数だけパターンを定義できる。
- 複数パターンを使用する場合、パターン数分の別カラムとしてテーブルに持たせる。

**クラス**: `nablarch.common.code.schema.CodePatternSchema`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| tableName | String | ○ | | テーブル名 |
| idColumnName | String | ○ | | コードIDカラムの名前 |
| valueColumnName | String | ○ | | コード値カラムの名前 |
| patternColumnNames | String | | | パターンに使用するカラム名（複数）。パターン機能を使用する場合は設定必須 |

<details>
<summary>keywords</summary>

コードパターンテーブル, CODE_PATTERN, パターン, テーブル定義, パターンカラム, CodePatternSchema, tableName, idColumnName, valueColumnName, patternColumnNames, コードパターンスキーマ設定

</details>

## コード名称テーブルの定義

コードの名称を持つテーブル。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| コードID | java.lang.String | ユニークキー |
| コード値 | java.lang.String | ユニークキー |
| 言語 | java.lang.String | ユニークキー |
| ソート順 | java.lang.String | |
| 名称 | java.lang.String | コードの名称 |
| 略称 | java.lang.String | コードの略称 |
| オプション名称 | java.lang.String | コードのオプション名称 |

- テーブル名・カラム名に制約はなく、設定により任意の名称が使用できる。
- オプション名称は1コード値に対して複数持てる。数とカラム名は任意設定可能。

**クラス**: `nablarch.common.code.schema.CodeNameSchema`

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| tableName | String | ○ | | テーブル名 |
| idColumnName | String | ○ | | コードIDカラムの名前 |
| valueColumnName | String | ○ | | コード値カラムの名前 |
| langColumnName | String | ○ | | 言語カラムの名前 |
| sortOrderColumnName | String | ○ | | ソート順カラムの名前 |
| nameColumnName | String | ○ | | 名称カラムの名前 |
| shortNameColumnName | String | ○ | | 略称カラムの名前 |
| optionNameColumnNames | String | | | コードのオプション名称に使用するカラム名（複数）。指定しない場合、オプション名称が取得できない |

<details>
<summary>keywords</summary>

コード名称テーブル, CODE_NAME, オプション名称, ソート順, テーブル定義, 略称, CodeNameSchema, tableName, idColumnName, valueColumnName, langColumnName, sortOrderColumnName, nameColumnName, shortNameColumnName, optionNameColumnNames, コード名称スキーマ設定

</details>

## テーブル定義の例

テーブル構成例（1コードIDごとに3パターン設定）:

**CODE_PATTERNテーブル**: ID, VALUE, PATTERN1, PATTERN2, PATTERN3

**CODE_NAMEテーブル**: ID, VALUE, SORT_ORDER, LANG, NAME（名称）, SHORT_NAME（略称）, NAME_WITH_VALUE（オプション名称: コード値を含む名称）

![テーブル定義例](../../../knowledge/component/libraries/assets/libraries-02_CodeManager/02_CodeManager_DatabaseDiagram.jpg)

コード値（性別区分等）はバリデーションが必要。[バリデーションの機能](libraries-validation-core_library.md) を使用してコード値の有効性（`contains` メソッドの戻り値が `true` か）をチェックする。

**アノテーション**: `@CodeValue`

Entityのプロパティに `@CodeValue` アノテーションを付けてバリデーションを実装する。`codeId` でコードIDを、`pattern` 属性でパターンのカラム名を指定する。

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

上記実装後、[validation_and_convert](libraries-08_02_validation_usage.md) で記述した方法で `ValidationUtil` クラスの `validateAndConvertRequest` メソッドを呼び出すことで、`gender` に `"1"`, `"2"` 以外の文字を設定した際のバリデーション結果はエラーになる。

`pattern` 属性を省略した場合、コード値として有効かのみチェック（パターンに含まれるかはチェックしない）。

**クラス**: `nablarch.common.code.validator.CodeValueValidator`

`ValidationManager` の `validators` プロパティに `CodeValueValidator` を追加する（[バリデーションの設定](libraries-08_01_validation_architecture.md) 参照）。

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
| messageId | String | ○ | | コード値のパターンに含まれない文字列が入力された場合のデフォルトエラーメッセージID。置き換え文字: `{0}`=プロパティ名称、`{1}`=使用できるコード値一覧。メッセージ例: `"{0}には'{'{1}'}'のいずれかの値を指定してください。"` フォーマット後の例: `"性別には{"01" , "02"}のいずれかの値を指定してください。"` |

> **注意**: このメッセージはコンボボックスで入力するコードを改竄した場合と、テキストボックスでコード値を入力するという特殊なケースでのみ使用される。メッセージはこの使用状況を考慮して設計すること。

<details>
<summary>keywords</summary>

テーブル定義例, CODE_PATTERN, CODE_NAME, NAME_WITH_VALUE, SHORT_NAME, データベース設計, CodeValueValidator, @CodeValue, @PropertyName, ValidationUtil, validateAndConvertRequest, codeId, pattern, messageId, ValidationManager, コード値バリデーション, バリデーション設定

</details>

## コード値とコード名称のデータ

性別区分(コードID: `0001`)とバッチ処理状態(コードID: `0002`)のデータ例。

**CODE_PATTERNテーブルのデータ例**:

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

**CODE_NAMEテーブルのデータ例**:

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

以降の実装例では、上記データがテーブルに入っていることを前提にして説明する。

<details>
<summary>keywords</summary>

コードデータ例, 性別区分, 0001, 0002, バッチ処理状態, 多言語データ

</details>

## コード名称の取得

**クラス**: `nablarch.common.code.CodeUtil`

| メソッド名 | 説明 |
|---|---|
| `getName` | コード名称を取得する |
| `getShortName` | コードの略称を取得する |
| `getOptionalName` | コードのオプション名称を取得する。取得するオプション名称のカラムは第3引数で指定する |

```java
// コード名称取得（ThreadContextの言語を使用）
String name = CodeUtil.getName("0001", "1");

// 言語指定して取得
String jaName = CodeUtil.getName("0001", "1", Locale.JAPANESE);

// 略称取得
String shortName = CodeUtil.getShortName("0001", "1");

// オプション名称取得（第3引数にカラム名を指定）
String optName = CodeUtil.getOptionalName("0001", "1", "NAME_WITH_VALUE");
```

<details>
<summary>keywords</summary>

CodeUtil, getName, getShortName, getOptionalName, コード名称取得, 略称取得, オプション名称取得

</details>

## コード値の取得

**クラス**: `nablarch.common.code.CodeUtil`

- `getValues(String codeId)` - コードIDに対応する全コード値をList\<String\>で取得
- `getValues(String codeId, Locale locale)` - 言語指定して取得

取得したコード値はコード名称テーブルのソート順カラムの昇順でソートされる。言語ごとにソート順が異なる（例: 日本語はアイウエオ順、英語はアルファベット順に対応可能）。

```java
// 性別区分の全コード値を取得（ThreadContextの言語によりソート順が異なる）
// ja: {"1", "2", "9"}、en: {"2", "1", "9"}
List<String> genderValues = CodeUtil.getValues("0001");

// バッチ処理状態の全コード値を取得 → {"01", "02", "03", "04", "05"}
List<String> statusValues = CodeUtil.getValues("0002");
```

<details>
<summary>keywords</summary>

CodeUtil, getValues, コード値取得, ソート順, List

</details>

## コード値の有効性チェック

**クラス**: `nablarch.common.code.CodeUtil`

- `contains(String codeId, String value)` - コード値として有効かチェック（booleanを返す）

```java
// 性別区分として "1" は有効 → true
CodeUtil.contains("0001", "1");

// 性別区分として "3" は有効でない → false
CodeUtil.contains("0001", "3");
```

<details>
<summary>keywords</summary>

CodeUtil, contains, コード値チェック, バリデーション, コード値有効性

</details>

## コード値のパターン

**クラス**: `nablarch.common.code.CodeUtil`

パターンに含まれるコード値のみを取得・チェックするメソッド。`pattern`引数にはパターンのカラム名を指定する。

- `getValues(String codeId, String pattern)` - パターンに含まれるコード値のみ取得
- `getValues(String codeId, String pattern, Locale locale)` - 言語指定して取得
- `contains(String codeId, String value, String pattern)` - パターンに対して有効かチェック

```java
// 性別区分(0001)のうちPATTERN1に含まれるコード値を取得
// ja: {"1", "2"}、en: {"2", "1"}
List<String> values = CodeUtil.getValues("0001", "PATTERN1");

// PATTERN1に対して "1" は有効 → true
CodeUtil.contains("0001", "1", "PATTERN1");

// PATTERN1に対して "3" は有効でない → false
CodeUtil.contains("0001", "3", "PATTERN1");
```

<details>
<summary>keywords</summary>

CodeUtil, getValues, contains, パターン指定, コード値フィルタリング, PATTERN1

</details>

## 未検討（非対応機能）

以下の機能は本機能では**非対応**（未検討）である。

- **外部システム用のコード変換**: 自システムのコード値と外部システムのコード値を相互変換する機能（自システムのコード値⇔外部システムのコード値）はサポートされていない。
- **コード値の有効期限管理**: コード値に有効期限を設定・管理する機能はサポートされていない。

<details>
<summary>keywords</summary>

未検討, 非対応, 外部システム, コード変換, 有効期限, 制限事項, サポート外

</details>
