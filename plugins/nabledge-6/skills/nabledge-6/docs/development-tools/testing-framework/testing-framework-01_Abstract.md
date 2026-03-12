# 自動テストフレームワーク

**公式ドキュメント**: [自動テストフレームワーク](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/01_Abstract.html)

## 特徴

自動テストフレームワークは以下の特徴を持つ。

- **JUnit4ベース**: JUnit4のアノテーション（`@Test`等）、assertメソッド、Matcherクラスを使用可能
- **テストデータの外部化**: DB準備データや期待テスト結果等をExcelファイルに記述し、自動テストフレームワークのAPIを通じて使用可能
- **Nablarch特化API**: トランザクション制御、システム日付設定など、Nablarchアプリケーション向けのテスト補助APIを提供

## Excelシート名に関する規約

- 1テストメソッドにつき1シートを用意する。
- シート名はテストメソッド名と同名にする。

> **補足**: シートに関する規約は「制約」ではない。テストメソッド名とExcelシート名が同名でなくても正しく動作する。今後の機能追加は上記規約をデフォルトとして開発されるので、命名規約への準拠を推奨する。命名規約を変更する場合はプロジェクト内で統一すること。

### テストメソッドの実行順序に依存しないテストを作成する

- テストメソッドの実行順序によってテスト結果が変わらないこと（単体・複数まとめて、どちらでも同じ結果）
- 本フレームワークはテスト中にコミットが行われるため、自テストクラスで必要な事前条件は全て自テストクラス内で準備すること

これにより、以下のような効果が得られる。

- テストの実行順序によって偶然テストが失敗したり偶然成功する、という事態を防ぐ。
- そのテストのデータまたはソースコードだけで、事前条件が分かる。

### マスタデータの共通Excelファイル準備

マスタデータ（基本的に読み取り専用テーブル）の準備は共通Excelファイルで行い、テスト実行前に1回だけ実行するか事前に準備済みを前提とする。

この手法には、以下のようなメリットがある。

- マスタ系のデータを、プロジェクト全体で再利用できる。
- テストデータのメンテナンスが容易になる。
- テスト実行速度が上がる。

> **補足**: マスタデータの投入には [master_data_setup_tool](testing-framework-01_MasterDataSetupTool.md) を使用する。[04_MasterDataRestore](testing-framework-04_MasterDataRestore.md) により、テスト内で発生したマスタデータの変更をテスト終了時に自動的に元の状態に戻すことができる。マスタデータに変更が必要なテストケースでも他のテストケースへの影響なく実行可能。

### テストデータは全てExcelシートに記述する

テストソースコード中にはテストデータを記載せず、全てExcelシートに記載すること。

- Excelシートを見れば、テストケースのバリエーションを把握できる。
- テストデータはExcelシート、テストロジックはテストソースコードと役割分担が明確になる。
- Excelシートを読み込む構造にしておくことで、容易にテストケースを追加できる。
- テストソースコードの重複を大幅に削減できる（テストソースコード中に単純にリテラル値でデータを記載すると、データのバリエーションが増加すると重複したコードが作られてしまう）。

### 複数のデータタイプ使用時はデータタイプごとにまとめてデータを記述する

複数のデータタイプを混在させると、データの読み込みが途中で終了しテストが正しく実行されない。データタイプごとにまとめて記述すること。

**誤り**（`TABLE2`までしか評価されず、`TABLE3`以降に誤りがあってもテストが成功してしまう）:

```text
EXPECTED_TABLE=TABLE1
:
EXPECTED_COMPLETE_TABLE=TABLE2
:
EXPECTED_TABLE=TABLE3
:
EXPECTED_COMPLETE_TABLE=TABLE4
:
```

**正しい記述**（データタイプごとにまとめる）:

```text
EXPECTED_TABLE=TABLE1
:
EXPECTED_TABLE=TABLE3
:
EXPECTED_COMPLETE_TABLE=TABLE2
:
EXPECTED_COMPLETE_TABLE=TABLE4
:
```

<details>
<summary>keywords</summary>

自動テストフレームワーク, JUnit4, テストデータ外部化, Excelファイル, Nablarch特化API, トランザクション制御, システム日付設定, Matcher, assertメソッド, Excelシート命名規約, テストメソッド名とシート名, テスト実行順序独立性, テストデータExcel管理, マスタデータ事前準備, 複数データタイプ混在禁止, EXPECTED_TABLE, EXPECTED_COMPLETE_TABLE, master_data_setup_tool, auto-test-framework_multi-datatype

</details>

## 自動テストフレームワークの構成

自動テストフレームワークの構成要素と作成者:

| 構成物 | 説明 | 作成者 |
|---|---|---|
| テストクラス | テスト処理を記述する | アプリケーションプログラマ |
| テスト対象クラス | テスト対象となるクラス | アプリケーションプログラマ |
| Excelファイル | テストデータを記載する。APIを通じてデータを読み取れる | アプリケーションプログラマ |
| コンポーネント設定ファイル・環境設定ファイル | テスト実行時の各種設定を記載する | アプリケーションプログラマ（個別のテストに固有の設定が必要な場合） |
| 自動テストフレームワーク | テストに必要な機能を提供する | — |
| Nablarch Application Framework | フレームワーク本体（本機能の対象外） | — |

## シート内の構造

「データタイプ」はテストデータの種類を判別するメタ情報。共通書式: データ1行目は「データタイプ=値」の形式、2行目以降の書式はデータタイプにより異なる。1つのシートに複数のデータ（SETUP_TABLE・EXPECTED_TABLE等）を記述できる。

| データタイプ名 | 説明 | 設定する値 |
|---|---|---|
| SETUP_TABLE | テスト実行前にDBに登録するデータ | 登録対象テーブル名 |
| EXPECTED_TABLE | テスト実行後の期待するDBデータ（省略カラムは比較対象外） | 確認対象テーブル名 |
| EXPECTED_COMPLETE_TABLE | テスト実行後の期待するDBデータ（省略カラムにはデフォルト値が設定されているものとして扱う） | 確認対象テーブル名 |
| LIST_MAP | List<Map<String,String>>形式のデータ | シート内で一意になるID / 期待値のID（任意の文字列） |
| SETUP_FIXED | 事前準備用の固定長ファイル | 準備ファイルの配置場所 |
| EXPECTED_FIXED | 期待値を示す固定長ファイル | 比較対象ファイルの配置場所 |
| SETUP_VARIABLE | 事前準備用の可変長ファイル | 準備ファイルの配置場所 |
| EXPECTED_VARIABLE | 期待値を示す可変長ファイル | 比較対象ファイルの配置場所 |
| MESSAGE | メッセージング処理のテストで使用するデータ | 固定値（`setUpMessages`または`expectedMessages`） |
| EXPECTED_REQUEST_HEADER_MESSAGES | 要求電文（ヘッダ）の期待値を示す固定長ファイル | リクエストID |
| EXPECTED_REQUEST_BODY_MESSAGES | 要求電文（本文）の期待値を示す固定長ファイル | リクエストID |
| RESPONSE_HEADER_MESSAGES | 応答電文（ヘッダ）を示す固定長ファイル | リクエストID |
| RESPONSE_BODY_MESSAGES | 応答電文（本文）を示す固定長ファイル | リクエストID |

JUnit VintageはJUnit 5上でJUnit 4のテストを実行できる機能を提供するプロジェクト。この機能を利用して自動テストフレームワークをJUnit 5上で動かすことができる。

> **重要**: JUnit VintageはJUnit 4のテストをJUnit 4として動かすだけであり、JUnit 4のテスト内でJUnit 5の機能は使えない。JUnit 4からJUnit 5への移行を段階的に進める補助として利用できる。移行手順については[公式のガイド(外部サイト、英語)](https://junit.org/junit5/docs/5.11.0/user-guide/#migrating-from-junit4)を参照。

> **補足**: JUnit 5のテストで自動テストフレームワークを使用する方法については [ntf_junit5_extension](testing-framework-JUnit5_Extension.md) を参照。

**前提条件**: `maven-surefire-plugin` 2.22.0以上

`pom.xml`に以下の依存関係を追加:
- `org.junit.jupiter:junit-jupiter`
- `org.junit.vintage:junit-vintage-engine`

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.junit</groupId>
      <artifactId>junit-bom</artifactId>
      <version>5.8.2</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>

<dependencies>
  <dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <scope>test</scope>
  </dependency>
  <dependency>
    <groupId>org.junit.vintage</groupId>
    <artifactId>junit-vintage-engine</artifactId>
    <scope>test</scope>
  </dependency>
</dependencies>
```

<details>
<summary>keywords</summary>

自動テストフレームワーク構成, テストクラス, テスト対象クラス, Excelファイル, コンポーネント設定ファイル, 環境設定ファイル, Nablarch Application Framework, データタイプ, SETUP_TABLE, EXPECTED_TABLE, EXPECTED_COMPLETE_TABLE, LIST_MAP, SETUP_FIXED, EXPECTED_FIXED, SETUP_VARIABLE, EXPECTED_VARIABLE, MESSAGE, EXPECTED_REQUEST_HEADER_MESSAGES, EXPECTED_REQUEST_BODY_MESSAGES, RESPONSE_HEADER_MESSAGES, RESPONSE_BODY_MESSAGES, JUnit Vintage, junit-vintage-engine, junit-jupiter, maven-surefire-plugin, JUnit5移行, JUnit4テスト実行, ntf_junit5_extension, junit-bom

</details>

## JUnit5サポート

> **補足**: JUnit 5の上で自動テストフレームワークを動かしたい場合は、 [run_ntf_on_junit5_with_vintage_engine](#) を参照のこと。

## コメント

セル内に`//`から開始する文字列を記載した場合、そのセルから右のセルは全て読み込み対象外となる。テストデータ自体には含めたくないが、可読性向上のために付加情報を記載したい場合に使用する。

コメントはそのセルから右のセルを読み込み対象外にするため、左端（または中央）のセルには使用できない。

<details>
<summary>keywords</summary>

JUnit5, Vintage Engine, JUnit5対応, run_ntf_on_junit5_with_vintage_engine, コメント記法, //記法

</details>

## テストメソッド記述方法

テストメソッドに`@Test`アノテーションを付与する。

```java
public class SampleTest {

    @Test
    public void testSomething() {
        // テスト処理
    }
}
```

## マーカーカラム

テストデータの見出し行において、**カラム名が半角角括弧で囲まれている場合（例: `[no]`）、そのカラムは「マーカーカラム」とみなされ、テスト実行時には読み込まれない**。

コメントを左端や中央セルに使用できない場合の代替手段として使用する。全データタイプで使用可能。

<details>
<summary>keywords</summary>

@Test, JUnit4, テストメソッド, SampleTest, アノテーション, マーカーカラム, 角括弧カラム名

</details>

## テストライフサイクルアノテーション

> **補足**: `@Before`や`@After`などのアノテーションも使用できる。テストメソッド前後にリソースの取得解放などの共通処理を行いたい場合は [using_junit_annotation](testing-framework-03_Tips.md) を参照。

## セルの書式

セルの書式には文字列のみを使用する。テストデータを作成する前に全てのセルの書式を文字列に設定しておくこと。罫線やセルの色付けは任意に設定可能。

> **重要**: Excelファイルに文字列以外の書式でデータを記述した場合、正しくデータが読み取れなくなる。

<details>
<summary>keywords</summary>

@Before, @After, JUnit4アノテーション, テストライフサイクル, using_junit_annotation, セルの書式, 文字列書式

</details>

## Excelによるテストデータ記述

DBの準備データや検索結果などのデータはJavaソースコードよりスプレッドシートの方が可読性・編集性が高い。Excelファイルを使用することでスプレッドシート形式でデータを扱える。

命名規約に従うことで、テストクラスでファイルパスを明示的に指定せずにExcelファイルを読み込める。任意のパスを明示的に指定することも可能。

## 日付の記述方法

使用可能な日付形式:
- `yyyyMMddHHmmssSSS`
- `yyyy-MM-dd HH:mm:ss.SSS`

省略ルール:
- ミリ秒省略（`yyyyMMddHHmmss` / `yyyy-MM-dd HH:mm:ss`）: ミリ秒は0として扱う
- 時刻全部省略（`yyyyMMdd` / `yyyy-MM-dd`）: 時刻は00:00:00.000として扱う

<details>
<summary>keywords</summary>

Excelテストデータ, 命名規約, スプレッドシート, テストデータ外部化, 可読性, 日付フォーマット, yyyyMMddHHmmssSSS, yyyy-MM-dd HH:mm:ss.SSS

</details>

## パス、ファイル名に関する規約

推奨される命名規約:
- Excelファイル名はテストソースコードと同じ名前にする（拡張子のみ異なる）
- Excelファイルをテストソースコードと同じディレクトリに配置する

| ファイルの種類 | 配置ディレクトリ | ファイル名 |
|---|---|---|
| テストソースファイル | `<PROJECT_ROOT>/test/jp/co/tis/example/db/` | `ExampleDbAcessTest.java` |
| Excelファイル | `<PROJECT_ROOT>/test/jp/co/tis/example/db/` | `ExampleDbAcessTest.xlsx` |

ExcelファイルはExcel2003以前（拡張子`.xls`）およびExcel2007以降（拡張子`.xlsx`）の両形式に対応。

## セルへの特殊な記述方法

| 記述方法 | 自動テスト内での値 | 説明 |
|---|---|---|
| `null` / `Null` | null | null値として扱う（大文字小文字区別なし）。DB登録やnull期待値に使用 |
| `"null"` / `"NULL"` | 文字列のnull | 前後のダブルクォートを除去した文字列として扱う |
| `"値"` | 前後ダブルクォートを除いた値 | スペースを含む値（例: `"1 "` → `1 `、`" "` → 半角スペース）の明示に使用 |
| `"""` | `"` | 3つのダブルクォートでリテラルのダブルクォート文字（`"`）を表す |
| `""` | 空文字列 | 空文字列を表す（空行の記述方法参照） |
| `${systemTime}` | システム日時 | コンポーネント設定ファイルにて設定されたSystemTimeProvider実装クラスから取得したTimestamp（例: `2011-04-11 01:23:45.0`）。システム日時を記載したい場合に使用 |
| `${updateTime}` | システム日時 | `${systemTime}`の別名。DB更新タイムスタンプの期待値として使用 |
| `${setUpTime}` | コンポーネント設定ファイルの固定値 | DBセットアップ時タイムスタンプに固定値を使用する場合に使用 |
| `${文字種,文字数}` | 指定文字種を指定文字数分増幅した値 | 文字種: 半角英字/半角数字/半角記号/半角カナ/全角英字/全角数字/全角ひらがな/全角カタカナ/全角漢字/全角記号その他/外字。単独・組み合わせ使用可能。リテラル文字と自由に混在可能（例: `${半角英字,5}` → `geDSfe`、`${半角数字,2}-${半角数字,4}` → `37-3425`（`-`はそのまま）、`${全角漢字,4}123` → `山川海森123`（末尾`123`はそのまま）） |
| `${binaryFile:ファイルパス}` | BLOB列に格納するバイナリデータ | ファイルパスはExcelファイルからの相対パスで記述。BLOB列にファイルデータを格納する場合に使用 |
| `\r` | CR（0x0D） | 改行コードCRを明示的に記述する場合に使用 |
| `\n` | LF（0x0A） | 改行コードLFを明示的に記述する場合に使用。セル内改行（Alt+Enter）もLFとして扱われる |

> **補足（ダブルクォート記法）**: 文字列の前後をダブルクォートで囲む記法を使用した場合であっても、文字列中のダブルクォートをエスケープする必要はない。例: `"ab"c"` → `ab"c`（前後のダブルクォートが除去される）、`"abc""` → `abc"`（同様）として扱われる。前後がダブルクォートでない場合（`ab"c`、`abc"` 等）はそのまま扱われる。

<details>
<summary>keywords</summary>

Excelファイル命名規約, テストクラス同名, xlsx, xls, ファイルパス規約, ExampleDbAcessTest, 特殊記法, ${systemTime}, ${updateTime}, ${setUpTime}, ${binaryFile}, ${文字種,文字数}, null値記法, 空文字列記法, ダブルクォート記法, """記法, SystemTimeProvider

</details>
