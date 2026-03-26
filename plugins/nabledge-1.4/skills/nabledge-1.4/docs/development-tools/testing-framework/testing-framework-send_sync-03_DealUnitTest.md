# 同期応答メッセージ送信処理を伴う取引単体テストの実施方法

## 同期応答メッセージ送信処理を伴う取引単体テストの概要

同期応答メッセージ送信処理を伴う画面オンライン処理の取引単体テストには、Nablarchのモックアップクラスを使用する。モックアップクラスを使用することで、キューのミドルウェアインストールや環境設定なしに取引単体テストが実施できる。

モックアップクラスが提供する機能:
1. **任意の応答電文を返却**: 送信キュー・受信キューへの接続なしで、テスト用の応答電文を返却する。
2. **要求電文をログ出力**: 要求電文をMap形式（デバッグ用）・CSV形式（エビデンス用）でログ出力する。
3. **障害系テスト**: タイムアウトエラーやメッセージ送受信エラーを発生させることができる。

<details>
<summary>keywords</summary>

MockMessagingProvider, モックアップクラス, 同期応答メッセージ送信, 取引単体テスト, 応答電文返却, 要求電文ログ出力, 障害系テスト

</details>

## モックアップクラスを使用した取引単体テストの実施方法

応答電文のフォーマットおよびデータをExcelファイルに定義する。要求電文はフォーマットのみ定義する。

- ExcelファイルはリクエストIDごとに用意し、ファイル名をリクエストIDに一致させる（例: リクエストID `RM21AA0101` → ファイル名 `RM21AA0101.xls`）
- ここでのリクエストIDは、メッセージ送信先システムの機能を一意に識別するID。画面オンライン処理やバッチ処理のリクエストIDとは意味が異なる
- シート名は `message` 固定
- Excelファイルの配置ディレクトリは設定ファイルに定義する（[send_sync_test_data_path](#s2) 参照）

**電文フォーマットの識別子**:
- 要求電文ヘッダ: `EXPECTED_REQUEST_HEADER_MESSAGES=リクエストID`
- 要求電文本文: `EXPECTED_REQUEST_BODY_MESSAGES=リクエストID`
- 応答電文ヘッダ: `RESPONSE_HEADER_MESSAGES=リクエストID`
- 応答電文本文: `RESPONSE_BODY_MESSAGES=リクエストID`

| 項目 | 説明 |
|---|---|
| 識別子 | 電文種別ID。テストケース一覧のexpectedMessage/responseMessageのグループIDと紐付く |
| ディレクティブ行 | ディレクティブ名のセル右に設定値を記載（複数行可） |
| no | ディレクティブ行の下に必ず記載 |
| フィールド名称 | フィールドの数だけ記載 |
| データ型 | フィールドの数だけ記載 |
| フィールド長 | フィールドの数だけ記載。`-` を指定した場合はデータから自動計算 |
| データ | 応答電文の場合のみ記載。複数件の場合は次行に続けて記載 |

> **注意**: フィールド名称・データ型・フィールド長は外部インタフェース設計書からコピー&ペースト可能（貼り付け時に「行列を入れ替える」オプションを使用）

**Excelファイルの再読み込み**: タイムスタンプが更新された場合（ファイル編集・上書き）、サーバ起動中でもファイルを再読み込みする。応答電文を返却するたびにnoがインクリメントされ、サーバ起動中はnoの値が初期化されない。

**障害系テスト**: 応答電文の本文の最初のフィールドに以下の値を設定する:

| 設定値 | 障害内容 | 動作 |
|---|---|---|
| `errorMode:timeout` | タイムアウトエラー | `sendSync`メソッドの戻り値として`null`を返却 |
| `errorMode:msgException` | メッセージ送受信エラー | `MessagingException`をスロー |

**Excelファイルの配置場所の設定**: `filepath.config` に `file.path.send.sync.test.data` プロパティでパスを設定する:

```bash
file.path.send.sync.test.data=file:///C:/nablarch/workspace/Nablarch_sample/test/message
```

> **注意**: 配置ディレクトリのパスはクラスパス（`classpath:`）ではなくファイルシステムのパス（`file:`）で指定すること。`file:` を指定することでサーバ起動中に直接Excelファイルを編集してテストできる。

**要求電文のログ出力**: Map形式（デバッグ用、標準出力・アプリログ）とCSV形式（エビデンス用、専用ログファイル）でログ出力される。

ログ出力例（Map形式）:

```
2011-10-26 13:16:10.958 MESSAGING_SEND_MAP request id=[RM11AD0101]. following message has been sent:
  message fw header = {requestId=RM11AD0101, testCount=, resendFlag=0, reserved=}
  message body      = {authors=test3, title=test1, publisher=test2}
```

ログ出力例（CSV形式）:

```
2011-10-26 13:16:10.958 MESSAGING_SEND_CSV request id=[RM11AD0102]. following message has been sent:
header:
"requestId","testCount","resendFlag","reserved"
"RM11AD0102","","0",""
body:
"authors","title","publisher"
"test3","test1","test2"
```

ログの出力設定は `log.properties` で行う:

```bash
writer.MESSAGING_CSV.className=nablarch.core.log.basic.FileLogWriter
writer.MESSAGING_CSV.filePath=./messaging-evidence.log
writer.MESSAGING_CSV.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.MESSAGING_CSV.formatter.format=$message$

loggers.MESSAGING_CSV.nameRegex=MESSAGING_CSV
loggers.MESSAGING_CSV.level=DEBUG
loggers.MESSAGING_CSV.writerNames=MESSAGING_CSV

loggers.MESSAGING_MAP.nameRegex=MESSAGING_MAP
loggers.MESSAGING_MAP.level=DEBUG
loggers.MESSAGING_MAP.writerNames=stdout,appFile
```

<details>
<summary>keywords</summary>

EXPECTED_REQUEST_HEADER_MESSAGES, EXPECTED_REQUEST_BODY_MESSAGES, RESPONSE_HEADER_MESSAGES, RESPONSE_BODY_MESSAGES, file.path.send.sync.test.data, MessagingException, errorMode:timeout, errorMode:msgException, Excelファイル設定, 障害系テスト, 応答電文フォーマット, ログ出力設定, Excelファイル再読み込み, FileLogWriter, BasicLogFormatter, nablarch.core.log.basic.FileLogWriter, nablarch.core.log.basic.BasicLogFormatter, sendSync, log.properties

</details>

## フレームワークで使用するクラスの設定

> **補足**: これらの設定は通常アーキテクトが行うものであり、アプリケーションプログラマが設定する必要はない。

**モックアップクラスの設定** (`nablarch.test.core.messaging.MockMessagingProvider`):

```xml
<component name="messagingProvider"
           class="nablarch.test.core.messaging.MockMessagingProvider">
</component>
```

**Excelファイルの配置場所のプロパティファイルパス設定**:

```xml
<config-file file="web/filepath.config" />

<component name="filePathSetting"
         class="nablarch.core.util.FilePathSetting" autowireType="None">
   <property name="basePathSettings">
     <map>
       <entry key="sendSyncTestData" value="${file.path.send.sync.test.data}" />
       <entry key="format" value="classpath:web/format" />
     </map>
   </property>
   <property name="fileExtensions">
     <map>
       <entry key="sendSyncTestData" value="xls" />
       <entry key="format" value="fmt" />
     </map>
   </property>
</property>
```

**必要なライブラリ**: 以下のjarをアプリケーションサーバのクラスパスに通す（単体テスト以外では使用しないため`WEB-INF/lib`ではなく別の場所に配置すること）:
- `nablarch-tfw.jar`
- Apache POIのjar

<details>
<summary>keywords</summary>

MockMessagingProvider, nablarch.test.core.messaging.MockMessagingProvider, FilePathSetting, nablarch.core.util.FilePathSetting, nablarch-tfw.jar, Apache POI, sendSyncTestData, コンポーネント設定, ライブラリ設定

</details>
