# リクエスト単体テストの実施方法(バッチ)

## テストクラスの書き方

テストクラス作成ルール: (1) テスト対象Actionクラスと同一パッケージ (2) クラス名は`{Action名}RequestTest` (3) `BatchRequestTestSupport`を継承

**クラス**: `nablarch.test.core.batch.BatchRequestTestSupport`

<details>
<summary>keywords</summary>

BatchRequestTestSupport, バッチリクエスト単体テスト, テストクラス命名規則, RequestTest

</details>

## テストメソッド分割

原則: 1テストケース = 1テストメソッド。バッチは複数レコードを扱うためテストデータが多くなりやすく、1メソッドに複数ケースを記述すると1シートが肥大化して可読性・保守性が低下するため。

複数ケースを1メソッドにまとめてよい条件:
- テストケース間の関連が強く、シート分割で可読性が劣化する場合（例：入力ファイルのフォーマットチェック）
- テストデータが少量で1シートに記述しても可読性・保守性に影響しない場合

<details>
<summary>keywords</summary>

テストメソッド分割, 1テストケース1メソッド, バッチテスト設計, テストケース分割方針

</details>

## テストデータの書き方

Excelファイルはテストソースコードと同一ディレクトリに同名で格納（拡張子のみ異なる）。

テストクラスで共通のデータベース初期値は :ref:`request_test_setup_db` を参照。

## テストケース一覧

LIST_MAPのデータタイプで1テストメソッド分のケース表を記載する。IDは`testShots`とする。

| カラム名 | 説明 | 必須 |
|---|---|---|
| no | テストケース番号（1からの連番） | ○ |
| description | テストケースの説明 | ○ |
| expectedStatusCode | 期待するステータスコード | ○ |
| setUpTable | 各テストケース実行前にDBに登録するデータの :ref:`グループID<tips_groupId>` | |
| setUpFile | 各テストケース実行前に入力用ファイルを作成するデータの :ref:`グループID<tips_groupId>` | |
| expectedFile | 出力ファイルの比較に使う期待ファイルの :ref:`グループID<tips_groupId>` | |
| expectedTable | DB比較に使う期待テーブルの :ref:`グループID<tips_groupId>` | |
| expectedLog | 期待するログメッセージを記載したLIST_MAPデータのID。そのログメッセージが実際に出力されたかどうか、自動テストフレームワークにて検証される | |
| diConfig | バッチ実行時のコンポーネント設定ファイルへのパス（:ref:`about_commandline_argument` 参照） | ○ |
| requestPath | バッチ実行時のリクエストパス（:ref:`about_commandline_argument` 参照） | ○ |
| userId | バッチ実行ユーザID（:ref:`about_commandline_argument` 参照） | ○ |
| expectedMessage | メッセージ同期送信の期待要求電文の :ref:`グループID<tips_groupId>` | |
| responseMessage | メッセージ同期送信の返却応答電文の :ref:`グループID<tips_groupId>` | |
| expectedMessageByClient | HTTPメッセージ同期送信の期待要求電文の :ref:`グループID<tips_groupId>` | |
| responseMessageByClient | HTTPメッセージ同期送信の返却応答電文の :ref:`グループID<tips_groupId>` | |

グループIDに`default`と記載するとデフォルトのグループIDを使用できる。デフォルトと個別グループIDの併用も可能で、両方のデータが有効になる。

<details>
<summary>keywords</summary>

testShots, LIST_MAP, テストケース一覧, setUpTable, setUpFile, expectedFile, expectedTable, expectedLog, diConfig, requestPath, userId, expectedMessage, responseMessage, expectedMessageByClient, responseMessageByClient

</details>

## コマンドライン引数

バッチ起動時の引数を指定するには、`args[n]`（nは0以上の整数）形式でテストケース一覧にカラムを追加する。

> **警告**: 添字nは連続した整数でなければならない。

テストケース一覧に`args[n]`以外のカラムを追加すると、そのカラムはコマンドラインオプションとみなされる。例えば、テストケース一覧に`paramA`カラム（値`valueA`）と`paramB`カラム（値`valueB`）があれば、`-paramA=valueA -paramB=valueB`というコマンドラインオプションを指定したことになる。カラム名がオプション名、セルの値がオプション値となる。

<details>
<summary>keywords</summary>

args[n], コマンドライン引数, バッチ起動引数, コマンドラインオプション

</details>

## データベースの準備

:ref:`オンライン<request_test_testcases>` と同様に、グループIDで対応付けを行う。

<details>
<summary>keywords</summary>

データベース準備, グループID, setUpTable, データベース初期値

</details>

## 固定長ファイルの準備

テストデータに固定長ファイルの情報を記載しておくと、自動テストフレームワークがテスト実行前にファイルを作成する。

書式: `SETUP_FIXED[グループID]=ファイルパス`

| 名称 | 説明 |
|---|---|
| グループID | テストケース一覧の`setUpFile`に記載したグループIDと紐付け |
| ファイルパス | カレントディレクトリからのファイルパス（ファイル名含む） |
| ディレクティブ行 | ディレクティブ名のセルの右のセルに設定値を記載する（複数行指定可） |
| レコード種別 | レコード種別を記載（マルチレイアウトは連続記載） |
| フィールド名称 | フィールドの数だけ記載 |
| データ型 | フィールドの数だけ記載 |
| フィールド長 | フィールドの数だけ記載 |
| データ | 複数レコードは次の行に続けて記載 |

> **警告**: 1つのレコード種別内でフィールド名称の重複は不可。異なるレコード種別間では同名フィールドは許容される。

> **注意**: 「符号無数値」「符号付数値」のデータ型を使用する場合、固定長ファイルに存在するパディング文字や符号まで含めてテストデータに記載する。以下に符号付数値（SX9）の変換例を示す（フォーマット定義: フィールド長10桁、パディング文字'0'、小数点必要、符号位置固定、正の符号不要）。

| 表したい数値 | テストデータ上の記載 |
|---|---|
| 12345 | 0000012345 |
| -12.34 | -000012.34 |

また、テスト用データタイプ（TEST_X9、TEST_SX9）の設定が必要。

```xml
<component name="fixedLengthConvertorSetting"
    class="nablarch.core.dataformat.convertor.FixedLengthConvertorSetting">
  <property name="convertorTable">
    <map>
      <!-- デフォルトの設定（省略すると上書きされるため要注意） -->
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
      <!-- テスト用データタイプ -->
      <entry key="TEST_X9" value="nablarch.test.core.file.StringDataType"/>
      <entry key="TEST_SX9" value="nablarch.test.core.file.StringDataType"/>
    </map>
  </property>
</component>
```

## 具体例: SETUP_FIXED=work/members.txt

文字コード`Windows-31J`、レコード区切り文字`CRLF`で構成されるファイルの例。ヘッダ1件、データ2件、トレーラ1件、エンド1件の計5レコード。

| レコード種別 | フィールド名称 | フィールド名称 | フィールド名称 |
|---|---|---|---|
| （ディレクティブ）text-encoding | Windows-31J | | |
| （ディレクティブ）record-separator | CRLF | | |
| ヘッダ | レコード区分 | FILLER | |
| | 9 | X | |
| | 1 | 10 | |
| | 0 | | |
| データ | レコード区分 | 会員番号 | 入会日 |
| | 9 | X | 9 |
| | 1 | 10 | 8 |
| | 1 | 0000000001 | 20100101 |
| | 1 | 0000000002 | 20100102 |
| トレーラ | レコード区分 | レコード件数 | FILLER |
| | 9 | 9 | X |
| | 1 | 5 | 4 |
| | 8 | 2 | |
| エンド | レコード区分 | FILLER | |
| | 9 | X | |
| | 1 | 10 | |
| | 9 | | |

<details>
<summary>keywords</summary>

SETUP_FIXED, 固定長ファイル, StringDataType, TEST_X9, TEST_SX9, fixedLengthConvertorSetting, フィールド名称重複, 符号無数値, 符号付数値

</details>
