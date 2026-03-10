# リクエスト単体テストの実施方法(同期応答メッセージ送信処理)

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/send_sync.html) [2](https://github.com/nablarch/nablarch-testing/blob/main/src/main/java/nablarch/test/core/file/BasicDataTypeMapping.java) [3](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/send_sync.html)

## 出力ライブラリ(同期応答メッセージ送信処理)の構造とテスト範囲

同期応答メッセージ送信処理のリクエスト単体テストは、リクエストID単位で行う。

> **補足**: ここで扱うリクエストIDは、メッセージ送信先の外部システム機能を一意に識別するIDであり、ウェブアプリケーションやバッチ処理で使用するリクエストIDとは意味が異なる。このリクエストIDにより、要求電文・応答電文のフォーマット、送信キュー名、受信キュー名が決まる。

用語:
- 要求電文: Actionがキューへ送信するメッセージ
- 応答電文: Actionがキューから受信するメッセージ

テスト実行時の動作:
1. 自動テストフレームワークがNablarch Application Frameworkを起動する
2. Nablarch Application FrameworkがActionの入力パラメータ（画面ならばリクエスト、バッチならばファイルやDB）を読み込み、Actionを起動する
3. ActionはNablarch Application Frameworkのメッセージ同期送信処理を実行する。Nablarch Application FrameworkはActionから受け取ったパラメータを要求電文に変換する
4. 自動テストフレームワークがテストデータをもとに要求電文をアサートする（キューへはPUTしない）
5. 自動テストフレームワークがテストデータをもとに応答電文を生成し、Actionへ返却する（キューからはGETしない）

> **補足**: フレームワークは「送信キュー」「受信キュー」を使用せず、キューの手前で要求電文アサートと応答電文生成を行う。特別なミドルウェアのインストールや環境設定は不要。

特徴:
1. テストデータをExcelに記載でき、外部インターフェース設計書のフォーマット定義に沿って記述できる。同期応答メッセージ送信処理用のテストデータ書式が提供されている。
2. メッセージ同期送信処理のテストコードを記述する必要がない。要求電文の期待値と応答電文をExcelに記載すると、フレームワークが自動的にアサートと応答電文返却を行う。テスト準備・実行・結果確認が可能なスーパークラスが提供されており、コーディングほぼ不要でテスト実行可能。

<details>
<summary>keywords</summary>

同期応答メッセージ送信処理, リクエスト単体テスト, 要求電文, 応答電文, キュー, リクエストID, 自動テストフレームワーク, Nablarch Application Framework, メッセージ同期送信, メッセージ同期送信処理

</details>

## テストの実施方法

同期応答メッセージ送信処理のテストは、ウェブアプリケーションやバッチ処理などのテスト方式を踏襲して行われる。テストクラスの書き方や各種準備データの準備方法については、これらのテストの実施方法を参照すること。

本項では、同期応答メッセージ送信処理固有の実施方法についてのみ解説する。

<details>
<summary>keywords</summary>

テスト実施方法, 同期応答メッセージ, ウェブアプリケーション, バッチ処理

</details>

## テストデータの書き方

テストデータを記載したExcelファイルは、クラス単体テストと同様に、テストソースコードと同じディレクトリに同じ名前（拡張子のみ異なる）で格納する。

テストデータの記述方法詳細は :ref:`how_to_write_excel` を参照。

<details>
<summary>keywords</summary>

テストデータ, Excelファイル, テストソースコード, ディレクトリ

</details>

## 要求電文の期待値および応答電文の準備

同期応答メッセージ送信処理のテストでは、リクエストIDごとに要求電文および応答電文のヘッダ部・ボディ部のフォーマットとデータを定義する。

テストケースとの対応付けはグループIDで行う。テストケースの `expectedMessage` フィールドと `responseMessage` フィールドに記載したグループIDが、対応する識別子を持つ電文表と紐付く。

> **重要**:
> - テストケース一覧に `expectedMessage` および `responseMessage` の欄がない場合、検証は行われない
> - 欄が空欄でメッセージ同期送信処理が実行された場合、テストが失敗する
> - メッセージ同期送信処理を行う場合は必ず `expectedMessage` と `responseMessage` を記載すること

1テストケースで同一グループID・同一リクエストIDの電文が複数件送信される場合は、その件数分のデータ行を記載する。`no` 列の順番（連番）は送信順に対応する。

テストケースの書き方:
- ウェブアプリケーション: :ref:`request_test_testcases`
- バッチ処理: :ref:`batch_test_testcases`

![テストデータ（グループIDの関連）](../../knowledge/development-tools/testing-framework/assets/testing-framework-send_sync/send_sync.png)

> **補足**: Nablarch標準の同期応答メッセージ送信機能では、要求電文と応答電文のヘッダ部は共通フォーマットを使用するため、テストデータのヘッダ部フォーマット定義はリクエスト単位で統一すること。ボディ部は要求電文と応答電文で異なるフォーマットを定義できる。

<details>
<summary>keywords</summary>

expectedMessage, responseMessage, グループID, 要求電文期待値, 応答電文, テストケース, リクエストID

</details>

## 電文表の書式

要求電文・応答電文の電文表の識別子形式:

| 識別子 | 形式 |
|---|---|
| 要求電文ヘッダの期待値 | `EXPECTED_REQUEST_HEADER_MESSAGES[グループID]=リクエストID` |
| 要求電文本文の期待値 | `EXPECTED_REQUEST_BODY_MESSAGES[グループID]=リクエストID` |
| 応答電文ヘッダ | `RESPONSE_HEADER_MESSAGES[グループID]=リクエストID` |
| 応答電文本文 | `RESPONSE_BODY_MESSAGES[グループID]=リクエストID` |

電文表の構造（行の構成）:
1. 識別子行
2. ディレクティブ行（ディレクティブ名と設定値を記載; 複数行可）
3. `no` 行（ディレクティブ行の直下に必ず `no` を記載）
4. フィールド名称行（フィールド数分）
5. データ型行（フィールド数分）: 日本語名称で記述（例: 「半角英字」）。マッピングは [BasicDataTypeMapping](https://github.com/nablarch/nablarch-testing/blob/main/src/main/java/nablarch/test/core/file/BasicDataTypeMapping.java) の `DEFAULT_TABLE` を参照
6. フィールド長行（フィールド数分）
7. データ行（複数レコードは次の行に続けて記載）

ディレクティブの以下は記述不要:

| 項目 | 理由 |
|---|---|
| `file-type` | テスティングフレームワークが固定長のみ対応のため |
| `record-length` | フィールド長に記載したサイズでパディングされるため |

> **重要**: フィールド名称に重複した名称は許容されない（例: 「氏名」フィールドが2つ以上あってはならない）。

> **補足**: フィールド名称・データ型・フィールド長は外部インタフェース設計書からコピー＆ペーストで効率よく作成できる（ペースト時は「行列を入れ替える」オプションを使用すること）。

要求電文本文の記載例:
![要求電文本文の記載例](../../knowledge/development-tools/testing-framework/assets/testing-framework-send_sync/send_sync_example.png)

> **補足**: 要求電文のヘッダの期待値および応答電文の本文・ヘッダについても、識別子を除く部分については要求電文の本文の期待値と同様の記載方法となる。

<details>
<summary>keywords</summary>

電文表, 識別子, EXPECTED_REQUEST_HEADER_MESSAGES, EXPECTED_REQUEST_BODY_MESSAGES, RESPONSE_HEADER_MESSAGES, RESPONSE_BODY_MESSAGES, ディレクティブ, BasicDataTypeMapping, フィールド定義, データ型

</details>

## 複数回送信テスト

要求電文に複数レコードが存在する場合、ヘッダとレコードを交互に記載する必要がある。

> **重要**: ヘッダ1つに複数の業務データを続けて記載してはならない。ヘッダと業務データの数が一致しないためアサーションエラーが発生する。
>
> 誤: ヘッダ → 業務データ(1レコード目) → 業務データ(2レコード目) → 業務データ(3レコード目)
>
> 正: ヘッダ → 業務データ(1レコード目) → ヘッダ → 業務データ(2レコード目) → ヘッダ → 業務データ(3レコード目)

複数回電文を送信するテストの作成時の注意:
- 同一データタイプ（例: `RESPONSE_HEADER_MESSAGES` と `RESPONSE_BODY_MESSAGES`）はそれぞれまとめて記述する。詳細は :ref:`tips_groupId` および :ref:`auto-test-framework_multi-datatype` を参照。
- 同一リクエストIDの電文は、`no` の値を変えてまとめて記述する。

複数回送信テストの記載例:
![複数回送信テストの記載例](../../knowledge/development-tools/testing-framework/assets/testing-framework-send_sync/send_sync_ok_pattern_expected.png)

> **補足**: 送信対象のリクエストIDが複数存在する場合、送信順のテストは不可能。異なるリクエストIDの電文がどの順番で送信されてもテストは成功する。

<details>
<summary>keywords</summary>

複数レコード, ヘッダ重複, 複数回送信, ヘッダとボディ交互, 送信順, tips_groupId, auto-test-framework_multi-datatype

</details>

## 障害系のテスト

応答電文表のヘッダおよび本文の `no` を除く最初のフィールドに以下の値を設定することで障害系テストが可能。

| 設定値 | 障害内容 | フレームワークの動作 |
|---|---|---|
| `errorMode:timeout` | メッセージ送信中にタイムアウトエラーが発生するケースのテスト | **`MessageSendSyncTimeoutException`**（`MessagingException` のサブクラス）を送出する |
| `errorMode:msgException` | メッセージ送受信エラーが発生するケースのテスト | **`MessagingException`** をスローする |

この値は、応答電文表の**ヘッダおよび本文両方**の `no` を除く最初のフィールドに記載する。

![障害系テスト設定例](../../knowledge/development-tools/testing-framework/assets/testing-framework-send_sync/send_sync_error.png)

> **補足**: 業務アクション内で `MessagingException` を明示的に制御していない場合、個別のリクエスト単体テストで障害系テストを行う必要はない。

<details>
<summary>keywords</summary>

障害系テスト, errorMode, タイムアウト, MessageSendSyncTimeoutException, MessagingException, errorMode:timeout, errorMode:msgException, タイムアウトエラー, メッセージ送受信エラー

</details>

## テスト結果検証

要求電文の期待値を定義した場合、フレームワークが以下を自動検証する:
- 要求電文の内容の検証
- 要求電文の送信件数の検証

<details>
<summary>keywords</summary>

テスト結果検証, 要求電文検証, 送信件数検証

</details>

## モックアップクラスを使用した取引単体テストの実施方法

同期応答メッセージ送信処理を伴うウェブアプリケーションで取引単体テストを行う場合は、Nablarchが提供するモックアップクラスを使用する。

モックアップクラスは以下の機能を提供する。

- **任意の応答電文を返却する機能**: 送信キューおよび受信キューに接続することなく、取引単体テストに必要な応答電文を返却できる
- **要求電文をログに出力する機能**: 同期送信された要求電文をログに出力し、正常性の確認やエビデンスとして使用できる
- **障害系のテストを行う機能**: タイムアウトエラーやメッセージ送受信エラーを発生させ、障害系のテストができる

モックアップクラスを使用すればキューを用意する必要がなく、特別なミドルウェアのインストールや環境設定なしに取引単体テストを行える。

応答電文のフォーマット・データ、要求電文のフォーマットをExcelファイルに定義する。ExcelファイルはリクエストIDごとに用意し、ファイル名はリクエストIDと一致させる（例: リクエストID「RM21AA0101」→ファイル名「RM21AA0101.xlsx」）。ファイルの配置ディレクトリは設定ファイルに定義する（`send_sync_test_data_path` 参照）。

> **注意**: ここでのリクエストIDは送信先システムの機能を一意に識別するID。ウェブアプリケーション/バッチのリクエストIDとは意味が異なる。このIDに基づき、電文フォーマットおよびキュー名が決定する。

## Excelファイルの書き方

- シート名は「message」固定
- 返却する応答電文のFW制御ヘッダ・本文のフォーマットを定義する
- 返却する応答電文のFW制御ヘッダ・本文のデータを定義する
- 要求電文のFW制御ヘッダ・本文のフォーマットのみ定義する（データは不要）

Excelファイルに定義した応答電文のフォーマットおよびデータは、モックアップクラスが返却する応答電文を生成するために使用される。また要求電文のフォーマットは、モックアップクラスが要求電文のログを出力するために使用される。

![Excelファイルの記載例](../../knowledge/development-tools/testing-framework/assets/testing-framework-send_sync/send_sync_test_data.jpg)

## 電文のフォーマットおよびデータの記載方法

電文のフォーマットおよびデータは「識別子行・ディレクティブ行（複数可）・no行」の構造で記載し、no行にはフィールド名称・データ型・フィールド長・データを縦に並べる。

| 名称 | 説明 |
|------|------|
| 識別子 | 電文の種類を示すID。書式: 要求電文ヘッダ=`EXPECTED_REQUEST_HEADER_MESSAGES=リクエストID`、要求電文本文=`EXPECTED_REQUEST_BODY_MESSAGES=リクエストID`、応答電文ヘッダ=`RESPONSE_HEADER_MESSAGES=リクエストID`、応答電文本文=`RESPONSE_BODY_MESSAGES=リクエストID` |
| ディレクティブ行 | ディレクティブを記載。`file-type`（固定長のみ対応のため不要）と`record-length`（フィールド長でパディングするため不要）は記述不要 |
| no | ディレクティブ行の下の行に必ず「no」を記載する |
| フィールド名称 | フィールド名称をフィールドの数だけ記載する |
| データ型 | 「半角英字」のように日本語名称で記述する。マッピングは`BasicDataTypeMapping`のメンバ変数`DEFAULT_TABLE`参照 |
| フィールド長 | フィールド長をフィールドの数だけ記載する。「-」を記載した場合はデータの記載内容を元にサイズを自動計算する |
| データ | 応答電文の場合のみ記載する。複数件の応答電文を返却する場合は次の行に続けてデータを記載する |

> **ヒント**: フィールド名称・データ型・フィールド長は外部インタフェース設計書からコピー＆ペーストして効率良く作成できる。ペースト時に「**行列を入れ替える**」オプションにチェックすること。

## Excelファイルの再読み込み

モックアップクラスは、Excelファイルのタイムスタンプが更新された場合にファイルを再読み込みする機能を提供する。

通常、応答電文を返却するたびにnoのインクリメントが行われ、アプリケーションサーバが起動している間はnoの値が初期化されない。Excelファイルの編集や上書きによりタイムスタンプを更新することで、サーバ起動中にExcelファイルの再読み込みができる。これにより手動でファイルを編集してテストをやり直すケースや、同じデータで繰り返しテストを行うケースに対応できる。

## 障害系のテスト

応答電文の本文の表の最初のフィールドに「errorMode:」から始まる特定の値を設定することで、障害系のテストを行える。

| 最初のフィールドに設定する値 | 障害内容 | フレームワークの動作 |
|------------------------------|----------|---------------------|
| `errorMode:timeout` | メッセージ送信中にタイムアウトエラーが発生する場合のテスト | sendSyncメソッドの戻り値としてnullを返却する |
| `errorMode:msgException` | メッセージ送受信エラーが発生する場合のテスト | MessagingExceptionをスローする |

## 要求電文のログ出力

要求電文のログはMap形式とCSV形式で出力される。Map形式はデバッグ用、CSV形式はエビデンス取得用。

Map形式ログ例:
```
2011-10-26 13:16:10.958 MESSAGING_SEND_MAP request id=[RM11AD0101]. following message has been sent: 
  message fw header = {requestId=RM11AD0101, testCount=, resendFlag=0, reserved=}
  message body      = {authors=test3, title=test1, publisher=test2}
```

CSV形式ログ例:
```
2011-10-26 13:16:10.958 MESSAGING_SEND_CSV request id=[RM11AD0102]. following message has been sent: 
header: 
"requestId","testCount","resendFlag","reserved"
"RM11AD0102","","0",""
body: 
"authors","title","publisher"
"test3","test1","test2"
```

log.properties設定例:
```properties
# CSV形式のメッセージログのライタ（./messaging-evidence.logに出力する）
writer.MESSAGING_CSV.className=nablarch.core.log.basic.FileLogWriter
writer.MESSAGING_CSV.filePath=./messaging-evidence.log
writer.MESSAGING_CSV.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.MESSAGING_CSV.formatter.format=$message$

# CSV形式のメッセージログのロガー
loggers.MESSAGING_CSV.nameRegex=MESSAGING_CSV
loggers.MESSAGING_CSV.level=DEBUG
loggers.MESSAGING_CSV.writerNames=MESSAGING_CSV

# Map形式のメッセージログのロガー
loggers.MESSAGING_MAP.nameRegex=MESSAGING_MAP
loggers.MESSAGING_MAP.level=DEBUG
loggers.MESSAGING_MAP.writerNames=stdout,appFile
```

<details>
<summary>keywords</summary>

Excelファイル設定, 応答電文フォーマット, リクエストID, message シート, send_sync_test_data_path, MockMessagingProvider, EXPECTED_REQUEST_HEADER_MESSAGES, EXPECTED_REQUEST_BODY_MESSAGES, RESPONSE_HEADER_MESSAGES, RESPONSE_BODY_MESSAGES, errorMode:timeout, errorMode:msgException, MessagingException, Excelファイル再読み込み, 障害系テスト, 要求電文ログ出力, BasicDataTypeMapping, FileLogWriter, BasicLogFormatter

</details>

## フレームワークで使用するクラスの設定

フレームワークで使用するクラスの設定は取引単体テストでのみ必要であり、テスト用プロファイルに設定する。通常はアーキテクトが設定し、アプリケーションプログラマが設定する必要はない。

## モックアップクラスの設定

コンポーネント設定ファイルに`MockMessagingProvider`を設定する。

```xml
<!-- モックのメッセージングプロバイダ -->
<component name="messagingProvider"
           class="nablarch.test.core.messaging.MockMessagingProvider">
</component>
```

## Excelファイルの配置場所の設定

コンポーネント設定ファイルで`sendSyncTestData`キーを使いExcelファイルの配置場所のパスを設定する（アンカー: `send_sync_test_data_path`）。

```xml
<component name="filePathSetting"
         class="nablarch.core.util.FilePathSetting" autowireType="None">
   <property name="basePathSettings">
     <map>
       <!-- Excelファイルの配置場所のパスを指定する -->
       <entry key="sendSyncTestData" value="file:///C:/nablarch/workspace/Nablarch_sample/test/message" />
       <entry key="format" value="classpath:web/format" /> 
     </map>
   </property>
   <property name="fileExtensions">
     <map>
       <!-- Excelファイルの拡張子（xlsx）を定義する -->
       <entry key="sendSyncTestData" value="xlsx" />
       <entry key="format" value="fmt" />
     </map>
   </property>
</component>
```

> **推奨**: 配置ディレクトリのパスはクラスパス（`classpath:`）ではなくファイルシステムのパス（`file:`）で指定することを推奨する。ファイルシステムのパスを指定することで、サーバ起動中に直接Excelファイルを編集してテストできる。

## テストデータ解析クラスの設定

コンポーネント設定ファイルに`BasicTestDataParser`と`PoiXlsReader`を設定する。`messagingTestInterpreters`リストには`NullInterpreter`、`QuotationTrimmer`、`CompositeInterpreter`（内部に`BasicJapaneseCharacterInterpreter`を含む）を設定する。

```xml
<!-- TestDataParser -->
<component name="messagingTestDataParser" class="nablarch.test.core.reader.BasicTestDataParser">
  <property name="testDataReader">
    <component name="xlsReaderForPoi" class="nablarch.test.core.reader.PoiXlsReader"/>
  </property>
  <property name="interpreters" ref="messagingTestInterpreters" />
</component>
<!-- テストデータ記法の解釈を行うクラス群 -->
<list name="messagingTestInterpreters">
  <component class="nablarch.test.core.util.interpreter.NullInterpreter"/>
  <component class="nablarch.test.core.util.interpreter.QuotationTrimmer"/>
  <component class="nablarch.test.core.util.interpreter.CompositeInterpreter">
    <property name="interpreters">
      <list>
        <component class="nablarch.test.core.util.interpreter.BasicJapaneseCharacterInterpreter"/>
      </list>
    </property>
  </component>
</list>
```

## pom.xmlへの依存追加

以下のdependencyをpom.xmlへ追加する。

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing</artifactId>
  <exclusions>
    <exclusion>
      <groupId>org.mortbay.jetty</groupId>
      <artifactId>*</artifactId>
    </exclusion>
    <exclusion>
      <groupId>com.google.code.findbugs</groupId>
      <artifactId>*</artifactId>
    </exclusion>
  </exclusions>
</dependency>
```

<details>
<summary>keywords</summary>

MockMessagingProvider, BasicTestDataParser, PoiXlsReader, nablarch-testing, sendSyncTestData, filePathSetting, コンポーネント設定, pom.xml, テストプロファイル, NullInterpreter, QuotationTrimmer, CompositeInterpreter, BasicJapaneseCharacterInterpreter, FilePathSetting

</details>
