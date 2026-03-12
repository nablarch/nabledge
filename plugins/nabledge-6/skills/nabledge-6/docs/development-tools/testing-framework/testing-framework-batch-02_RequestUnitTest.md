# リクエスト単体テストの実施方法(バッチ)

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/batch.html) [2](https://github.com/nablarch/nablarch-testing/blob/main/src/main/java/nablarch/test/core/file/BasicDataTypeMapping.java)

## テストクラスの書き方

テストクラス作成ルール: (1) テスト対象Actionクラスと同一パッケージ (2) クラス名は`{Actionクラス名}RequestTest` (3) **クラス**: `nablarch.test.core.batch.BatchRequestTestSupport`を継承する。

<details>
<summary>keywords</summary>

BatchRequestTestSupport, テストクラス命名規則, バッチリクエストテスト, ActionRequestTest, nablarch.test.core.batch.BatchRequestTestSupport

</details>

## テストメソッド分割

原則1テストケース1テストメソッド。以下の場合は複数テストケースを1テストメソッドにまとめることを検討する:
- テストケース間の関連が強く、シート分割により可読性が劣化する場合（例：入力ファイルのフォーマットチェック）
- テストデータが少量で、1シートに記述しても可読性・保守性に影響しない場合

<details>
<summary>keywords</summary>

テストメソッド分割, テストケース分割, バッチテスト設計, テストシート分割

</details>

## テストデータの書き方

テストデータExcelファイルはテストソースコードと同じディレクトリに同名（拡張子のみ異なる）で格納する。書式詳細は :ref:`how_to_write_excel` を参照。

テストクラスで共通のデータベース初期値: :ref:`request_test_setup_db` を参照。

**テストケース一覧**: LIST_MAPデータタイプで記述し、IDは`testShots`とする。

| カラム名 | 説明 | 必須 |
|---|---|---|
| no | テストケース番号（1からの連番） | ○ |
| description | テストケースの説明 | ○ |
| expectedStatusCode | 期待するステータスコード | ○ |
| setUpTable | テスト前にDBへ登録するデータの :ref:`グループID<tips_groupId>` | |
| setUpFile | テスト前に入力ファイルを作成するデータの :ref:`グループID<tips_groupId>` | |
| expectedFile | 出力ファイル比較の期待データの :ref:`グループID<tips_groupId>` | |
| expectedTable | DB比較の期待テーブルの :ref:`グループID<tips_groupId>` | |
| expectedLog | 期待するログメッセージを記載したLIST_MAP ID（ログ出力の自動検証に使用） | |
| diConfig | バッチ実行時のコンポーネント設定ファイルパス（ [main-run_application](../../component/handlers/handlers-main.md) 参照） | ○ |
| requestPath | バッチ実行時のリクエストパス（ [main-run_application](../../component/handlers/handlers-main.md) 参照） | ○ |
| userId | バッチ実行ユーザID（ [main-run_application](../../component/handlers/handlers-main.md) 参照） | ○ |
| expectedMessage | メッセージ同期送信処理の期待要求電文の :ref:`グループID<tips_groupId>` | |
| responseMessage | メッセージ同期送信処理の返却応答電文の :ref:`グループID<tips_groupId>` | |
| expectedMessageByClient | HTTPメッセージ同期送信処理の期待要求電文の :ref:`グループID<tips_groupId>` | |
| responseMessageByClient | HTTPメッセージ同期送信処理の返却応答電文の :ref:`グループID<tips_groupId>` | |

> **補足**: グループIDに`default`と記載するとデフォルトグループIDを使用できる。デフォルトと個別グループは併用可能（両方のデータが有効になる）。

<details>
<summary>keywords</summary>

testShots, LIST_MAP, setUpTable, setUpFile, expectedFile, expectedTable, expectedLog, diConfig, requestPath, userId, テストケース一覧, テストデータ書式, expectedMessage, responseMessage, expectedMessageByClient, responseMessageByClient

</details>

## コマンドライン引数

バッチ起動時の引数は`args[n]`（nは0以上の整数）形式でテストケース一覧にカラムを追加する。

> **重要**: 添字nは連続した整数でなければならない。

テストケース一覧の標準カラム以外のカラムはコマンドラインオプションとみなされる。例: カラム名`paramA`に値`valueA`を設定すると`-paramA=valueA`として扱われる。

<details>
<summary>keywords</summary>

args[n], コマンドライン引数, コマンドラインオプション, バッチ起動引数

</details>

## データベースの準備

:ref:`request_test_testcases`（オンライン）と同様に、グループIDで対応付けを行う。

<details>
<summary>keywords</summary>

データベース準備, グループID, DB初期データ, setUpTable

</details>

## 固定長ファイルの準備

テストデータに固定長ファイルのデータを記載すると、テスト実行前にフレームワークが自動でファイルを作成する。

**書式**: `SETUP_FIXED[グループID]=ファイルパス`

| 名称 | 説明 |
|---|---|
| グループID | テストケース一覧の`setUpFile`に記載したグループIDと対応する |
| ファイルパス | カレントディレクトリからのファイルパス（ファイル名含む） |
| ディレクティブ行 | `text-encoding`・`record-separator`等を指定。`file-type`と`record-length`は不要（SETUP_FIXED指定で固定長を表し、フィールド長からパディングサイズを決定するため） |
| レコード種別 | レコード種別名（マルチレイアウトの場合は連続で記載） |
| フィールド名称 | フィールドごとに記載 |
| データ型 | 日本語名称で記載（例：半角英字）。マッピングは[BasicDataTypeMapping](https://github.com/nablarch/nablarch-testing/blob/main/src/main/java/nablarch/test/core/file/BasicDataTypeMapping.java)のDEFAULT_TABLEを参照 |
| フィールド長 | フィールドごとに記載 |
| データ | フィールドに格納する値。複数レコードは次行に続けて記載 |

> **重要**: 1レコード種別内でフィールド名称の重複は不可（例：「氏名」フィールドが2つ以上存在してはならない）。異なるレコード種別間での同一名称は問題なし。

> **補足**: フィールド名称・データ型・フィールド長は外部インタフェース設計書から「**行列を入れ替える**」オプションでコピー＆ペーストすることで効率良く作成できる。

> **補足**: 「符号無数値」「符号付数値」データ型使用時は、固定長ファイル上の実際の値（パディング文字・符号を含む）をそのまま記載する。これらを使用する場合はテスト用データタイプの設定が必要。デフォルト設定を省略するとデフォルト設定が上書きされるため、既存のデフォルトエントリも必ず含めること。

```xml
<component name="fixedLengthConvertorSetting"
    class="nablarch.core.dataformat.convertor.FixedLengthConvertorSetting">
  <property name="convertorTable">
    <map>
      <!-- デフォルトの設定（省略不可） -->
      <entry key="X" value="nablarch.core.dataformat.convertor.datatype.SingleByteCharacterString"/>
      <entry key="N" value="nablarch.core.dataformat.convertor.datatype.DoubleByteCharacterString"/>
      <entry key="XN" value="nablarch.core.dataformat.convertor.datatype.ByteStreamDataString"/>
      <entry key="Z" value="nablarch.core.dataformat.convertor.datatype.ZonedDecimal"/>
      <entry key="SZ" value="nablarch.core.dataformat.convertor.datatype.SignedZonedDecimal"/>
      <entry key="P" value="nablarch.core.dataformat.convertor.datatype.PackedDecimal"/>
      <entry key="SP" value="nablarch.core.dataformat.convertor.datatype.SignedPackedDecimal"/>
      <entry key="B" value="nablarch.core.dataformat.convertor.datatype.Bytes"/>
      <entry key="X9" value="nablarch.core.dataformat.convertor.datatype.NumberStringDecimal"/>
      <entry key="SX9" value="nablarch.core.dataformat.convertor.datatype.SignedNumberStringDecimal"/>
      <entry key="pad" value="nablarch.core.dataformat.convertor.value.Padding"/>
      <entry key="encoding" value="nablarch.core.dataformat.convertor.value.UseEncoding"/>
      <entry key="_LITERAL_" value="nablarch.core.dataformat.convertor.value.DefaultValue"/>
      <entry key="number" value="nablarch.core.dataformat.convertor.value.NumberString"/>
      <entry key="signed_number" value="nablarch.core.dataformat.convertor.value.SignedNumberString"/>
      <!-- テスト用: 符号無数値(X9)→TEST_X9, 符号有数値(SX9)→TEST_SX9 -->
      <entry key="TEST_X9" value="nablarch.test.core.file.StringDataType"/>
      <entry key="TEST_SX9" value="nablarch.test.core.file.StringDataType"/>
    </map>
  </property>
</component>
```

**具体例**: 以下のレコード構成のファイル（文字コード`Windows-31J`、レコード区切り`CRLF`）の場合
- ヘッダレコード1件
- データレコード2件
- トレーラレコード1件
- エンドレコード1件

`SETUP_FIXED=work/members.txt`

| ディレクティブ | 値 |
|---|---|
| text-encoding | Windows-31J |
| record-separator | CRLF |

| レコード種別 | フィールド名称 | データ型 | フィールド長 | データ |
|---|---|---|---|---|
| ヘッダ | レコード区分 | 半角数字 | 1 | 0 |
| ヘッダ | FILLER | 半角 | 10 | |
| データ | レコード区分 | 半角数字 | 1 | 1 |
| データ | 会員番号 | 半角数字 | 10 | 0000000001 |
| データ | 入会日 | 半角数字 | 8 | 20100101 |
| データ | レコード区分 | | | 1 |
| データ | 会員番号 | | | 0000000002 |
| データ | 入会日 | | | 20100102 |
| トレーラ | レコード区分 | 半角数字 | 1 | 8 |
| トレーラ | レコード件数 | 数値 | 5 | 2 |
| トレーラ | FILLER | 半角 | 4 | |
| エンド | レコード区分 | 半角数字 | 1 | 9 |
| エンド | FILLER | 半角 | 10 | |

> **補足**: 同一レコード種別に複数のデータレコードがある場合、フィールド定義（データ型・フィールド長）は最初の行にのみ記載し、2件目以降の行は値のみを記載する。

<details>
<summary>keywords</summary>

SETUP_FIXED, 固定長ファイル, BasicDataTypeMapping, StringDataType, fixedLengthConvertorSetting, FixedLengthConvertorSetting, 符号無数値, 符号付数値, TEST_X9, TEST_SX9, レコード種別, フィールド長, setUpFile, nablarch.test.core.file.StringDataType, SingleByteCharacterString, DoubleByteCharacterString, ByteStreamDataString, ZonedDecimal, SignedZonedDecimal, PackedDecimal, SignedPackedDecimal, Bytes, NumberStringDecimal, SignedNumberStringDecimal

</details>
