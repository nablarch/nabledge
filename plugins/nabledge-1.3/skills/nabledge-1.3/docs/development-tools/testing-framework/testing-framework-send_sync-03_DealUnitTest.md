# 同期応答メッセージ送信処理を伴う取引単体テストの実施方法

## Excelファイルの書き方

同期応答メッセージ送信処理を伴う画面オンライン処理の取引単体テストには、Nablarchのモックアップクラスを使用する。キューを用意する必要がないため、特別なミドルウェアのインストールや環境設定なしにテストできる。

**モックアップクラスの機能**:
1. **応答電文の返却**: 送信キュー・受信キューに接続せずに任意の応答電文を返却する
2. **要求電文のログ出力**: 同期送信された要求電文をMap形式・CSV形式でログに出力する（エビデンス取得可）
3. **障害系テスト**: タイムアウトエラー（`sendSync`戻り値null）や`MessagingException`を発生させる

## Excelファイルの準備

- Excelファイルは**リクエストID**（送信先システムの機能を一意に識別するID）ごとに用意する
- ファイル名はリクエストIDと一致させる（例: リクエストIDが`RM21AA0101` → `RM21AA0101.xls`）
- 配置ディレクトリは設定ファイルに定義する（[send_sync_test_data_path](#)参照）

> **注意**: ここでいうリクエストIDは送信先システムの機能を識別するIDであり、画面オンライン処理やバッチ処理で使用するリクエストIDとは意味が異なる。

## Excelファイルの書き方ルール

- シート名は「message」固定
- 返却する応答電文のFW制御ヘッダ・本文のフォーマットとデータを定義する
- 要求電文のFW制御ヘッダ・本文のフォーマットのみ定義する（データ不要）

### 識別子の書式

| 種別 | 識別子 |
|---|---|
| 要求電文のヘッダ | `EXPECTED_REQUEST_HEADER_MESSAGES=リクエストID` |
| 要求電文の本文 | `EXPECTED_REQUEST_BODY_MESSAGES=リクエストID` |
| 応答電文のヘッダ | `RESPONSE_HEADER_MESSAGES=リクエストID` |
| 応答電文の本文 | `RESPONSE_BODY_MESSAGES=リクエストID` |

識別子はテストケース一覧の`expectedMessage`および`responseMessage`に記載されたグループIDと紐付く。

### フィールド定義の構造

| 項目 | 説明 |
|---|---|
| ディレクティブ行 | ディレクティブ名の右セルに設定値を記載 |
| no | ディレクティブ行の下に必ず`no`を記載 |
| フィールド名称 | フィールドの数だけ記載 |
| データ型 | フィールドの数だけ記載 |
| フィールド長 | フィールドの数だけ記載 |
| データ | 応答電文の場合のみ記載。複数件の場合は次行に続けて記載 |

> **補足**: フィールド名称、データ型、フィールド長は外部インタフェース設計書からコピー＆ペーストで作成できる（「行列を入れ替える」オプションを使用）

## Excelファイルの再読み込み

- 応答電文を返却するたびにnoがインクリメントされ、アプリケーションサーバ起動中は初期化されない
- Excelファイルを編集・上書きしてタイムスタンプを更新することで、サーバ起動中でも再読み込みが可能

## 障害系のテスト

応答電文の本文の最初のフィールドに以下の値を設定することで障害系テストができる：

| 設定値 | 障害内容 | 動作 |
|---|---|---|
| `errorMode:timeout` | タイムアウトエラー | `sendSync`の戻り値として`null`を返却 |
| `errorMode:errorMode:msgException` | メッセージ送受信エラー | `MessagingException`をスロー |

<details>
<summary>keywords</summary>

MockMessagingProvider, MessagingException, EXPECTED_REQUEST_HEADER_MESSAGES, EXPECTED_REQUEST_BODY_MESSAGES, RESPONSE_HEADER_MESSAGES, RESPONSE_BODY_MESSAGES, errorMode:timeout, errorMode:msgException, モックアップクラス, 取引単体テスト, 同期応答メッセージ送信, Excelファイル書き方, 障害系テスト, Excelファイル再読み込み, sendSync

</details>

## Excelファイルの配置場所の設定

Excelファイルの配置場所のパスは`filepath.config`に設定する：

```bash
file.path.send.sync.test.data=file:///C:/nablarch/workspace/Nablarch_sample/test/message
```

配置場所を変更する場合はこのパスを修正する。

> **注意**: クラスパス（`classpath:`）ではなくファイルシステムのパス（`file:`）で指定することを推奨する。ファイルシステムのパスを指定することで、サーバ起動中に直接Excelファイルを編集してテストできる。

<details>
<summary>keywords</summary>

file.path.send.sync.test.data, filepath.config, Excelファイル配置場所, classpath file パス設定, send_sync_test_data_path

</details>

## 要求電文のログ出力

要求電文のログはMap形式とCSV形式で出力される。

- **Map形式**: デバッグ用（標準出力およびアプリケーションログファイルに出力）
- **CSV形式**: エビデンス用（専用ログファイルに出力）

なお、上記の出力先はサンプルの設定であり、ログの設定を修正することで出力先の切り替えが可能である。

### Map形式の出力例

```
MESSAGING_SEND_MAP request id=[RM11AD0101]. following message has been sent: 
  message fw header = {requestId=RM11AD0101, testCount=, resendFlag=0, reserved=}
  message body      = {authors=test3, title=test1, publisher=test2}
```

### CSV形式の出力例

```
MESSAGING_SEND_CSV request id=[RM11AD0102]. following message has been sent: 
header: 
"requestId","testCount","resendFlag","reserved"
"RM11AD0102","","0",""
body: 
"authors","title","publisher"
"test3","test1","test2"
```

### log.propertiesの設定

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

MESSAGING_SEND_MAP, MESSAGING_SEND_CSV, MESSAGING_CSV, MESSAGING_MAP, FileLogWriter, nablarch.core.log.basic.FileLogWriter, nablarch.core.log.basic.BasicLogFormatter, log.properties, 要求電文ログ出力, エビデンス

</details>

## フレームワークで使用するクラスの設定

> **注意**: これらの設定はアーキテクトが行うものであり、アプリケーションプログラマが設定する必要はない。

## モックアップクラスの設定

**クラス**: `nablarch.test.core.messaging.MockMessagingProvider`

コンポーネント設定ファイルに設定する：

```xml
<component name="messagingProvider"
           class="nablarch.test.core.messaging.MockMessagingProvider">
</component>
```

## Excelファイル配置場所のプロパティファイル設定

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

## 必要なjarファイル

以下のjarをアプリケーションサーバのクラスパスに通す：
- `nablarch-tfw.jar`
- Apache POIのjar

単体テスト以外では使用しないため、`WEB-INF/lib`ではなく別の場所への配置を推奨する。

<details>
<summary>keywords</summary>

MockMessagingProvider, nablarch.test.core.messaging.MockMessagingProvider, FilePathSetting, nablarch.core.util.FilePathSetting, messagingProvider, filePathSetting, sendSyncTestData, nablarch-tfw.jar, Apache POI, コンポーネント設定

</details>
