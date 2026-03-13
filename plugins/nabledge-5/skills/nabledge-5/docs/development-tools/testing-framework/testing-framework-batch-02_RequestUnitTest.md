# リクエスト単体テストの実施方法(バッチ)

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/batch.html) [2](https://github.com/nablarch/nablarch-testing/blob/master/src/main/java/nablarch/test/core/file/BasicDataTypeMapping.java)

## テストクラスの書き方

テストクラス作成ルール:
1. テスト対象ActionクラスのパッケージはActionクラスと同一
2. クラス名は `{Actionクラス名}RequestTest`
3. `nablarch.test.core.batch.BatchRequestTestSupport` を継承

<details>
<summary>keywords</summary>

BatchRequestTestSupport, テストクラス作成ルール, バッチリクエストテスト, RequestTest

</details>

## テストメソッド分割

原則: 1テストケース = 1テストメソッド。

バッチは複数レコードを扱うためテストデータが多くなる。1メソッドに複数ケースを記述するとシートのデータが大量になり可読性・保守性が低下するため。

例外として複数ケースを1テストメソッドで記述できる条件:
- テストケース間の関連が強く、シートを分割することで可読性が劣化する場合（例: 入力ファイルのフォーマットチェック）
- テストデータが少量で、1シートに記述しても可読性・保守性に影響しない場合

<details>
<summary>keywords</summary>

テストメソッド分割, 1テストケース1テストメソッド, バッチテスト設計, テストケース分割方針

</details>

## テストデータの書き方

テストデータのExcelファイルはテストソースコードと同じディレクトリに同じ名前（拡張子のみ異なる）で格納する。

テストクラスで共通のデータベース初期値はウェブアプリケーションの場合と同様（:ref:`request_test_setup_db` 参照）。

**テストケース一覧**: LIST_MAPデータタイプ、ID = `testShots`

| カラム名 | 説明 | 必須 |
|---|---|---|
| no | テストケース番号（1からの連番） | ○ |
| description | テストケースの説明 | ○ |
| expectedStatusCode | 期待するステータスコード | ○ |
| setUpTable | テスト実行前にDBに登録するデータの :ref:`グループID<tips_groupId>` | |
| setUpFile | テスト実行前に入力用ファイルを作成するデータの :ref:`グループID<tips_groupId>` | |
| expectedFile | 出力ファイルの内容比較用期待ファイルの :ref:`グループID<tips_groupId>` | |
| expectedTable | DB内容比較用期待テーブルの :ref:`グループID<tips_groupId>` | |
| expectedLog | 期待するログメッセージを記載したLIST_MAPデータのID | |
| diConfig | バッチ実行時のコンポーネント設定ファイルパス | ○ |
| requestPath | バッチ実行時のリクエストパス | ○ |
| userId | バッチ実行ユーザID | ○ |
| expectedMessage | メッセージ同期送信時の期待する要求電文の :ref:`グループID<tips_groupId>` | |
| responseMessage | メッセージ同期送信時の返却する応答電文の :ref:`グループID<tips_groupId>` | |
| expectedMessageByClient | HTTPメッセージ同期送信時の期待する要求電文の :ref:`グループID<tips_groupId>` | |
| responseMessageByClient | HTTPメッセージ同期送信時の返却する応答電文の :ref:`グループID<tips_groupId>` | |

> **補足**: グループIDを使わない（デフォルト）場合は `default` と記載する。デフォルトのグループIDと個別のグループは併用可能で、両方のデータが有効になる。

<details>
<summary>keywords</summary>

testShots, LIST_MAP, setUpTable, setUpFile, expectedFile, expectedTable, expectedLog, diConfig, requestPath, userId, expectedMessage, responseMessage, expectedMessageByClient, responseMessageByClient, テストケース一覧

</details>

## コマンドライン引数

バッチ起動引数は `args[n]`（nは0以上の整数）形式のカラムを追加して指定する。

> **重要**: 添字nは連続した整数でなければならない。

`args[n]` 以外のカラムを追加すると、コマンドラインオプションとみなされる。例えばカラム `paramA`（値 `valueA`）、`paramB`（値 `valueB`）を追加すると `-paramA=valueA -paramB=valueB` のオプションを指定したことになる。

<details>
<summary>keywords</summary>

args[n], コマンドライン引数, バッチ起動引数, コマンドラインオプション

</details>

## データベースの準備

:ref:`オンライン<request_test_testcases>` と同様に、グループIDで対応付けを行う。

<details>
<summary>keywords</summary>

データベース準備, グループID, setUpTable, バッチDBセットアップ

</details>

## 固定長ファイルの準備

テストデータに固定長ファイル情報を記載すると、テスト実行前にフレームワークがファイルを作成する。

**書式**: `SETUP_FIXED[グループID]=ファイルパス`

| 名称 | 説明 |
|---|---|
| グループID | `setUpFile` に記載されたグループIDと紐付け |
| ファイルパス | カレントディレクトリからのファイルパス（ファイル名含む） |
| ディレクティブ行 | ディレクティブ名の右セルに設定値を記載（複数行可） |
| レコード種別 | マルチレイアウトの場合は連続記載 |
| フィールド名称 | フィールドの数だけ記載 |
| データ型 | 日本語名称で記述（例: 半角英字）。型マッピングは [BasicDataTypeMapping](https://github.com/nablarch/nablarch-testing/blob/master/src/main/java/nablarch/test/core/file/BasicDataTypeMapping.java) の `DEFAULT_TABLE` を参照 |
| フィールド長 | フィールドの数だけ記載 |
| データ | フィールドに格納するデータ。複数レコードは次の行に続けて記載 |

> **注意**: `file-type` と `record-length` はディレクティブ行に記述不要。`SETUP_FIXED` 指定で固定長と判定され、フィールド長でパディングされるため。

> **重要**: 同一レコード種別内でフィールド名称の重複は不可（例: 「氏名」フィールドが2つ以上不可）。異なるレコード種別間では同一名称が存在しても問題ない。

> **補足**: 「符号無数値」「符号付数値」使用時は、固定長ファイルから入力する値（パディング文字・符号を含む）をそのまま記載すること（例: 値 -12.34 → テストデータ `-000012.34`）。また、`fixedLengthConvertorSetting` にテスト用データタイプ（`TEST_X9`、`TEST_SX9`）を設定する必要がある。デフォルト設定を省略すると既存設定が上書きされるため必ず含めること。

```xml
<component name="fixedLengthConvertorSetting"
    class="nablarch.core.dataformat.convertor.FixedLengthConvertorSetting">
  <property name="convertorTable">
    <map>
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

<details>
<summary>keywords</summary>

SETUP_FIXED, 固定長ファイル準備, FixedLengthConvertorSetting, BasicDataTypeMapping, StringDataType, TEST_X9, TEST_SX9, 符号無数値, 符号付数値, フィールド名称重複禁止

</details>
