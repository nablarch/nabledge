# HTTPメッセージングリクエスト変換ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/http_messaging/http_messaging_request_parsing_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpRequest.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/RequestMessage.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/handler/HttpMessagingRequestParsingHandler.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/DataRecordFormatter.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/StructuredFwHeaderDefinition.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/StandardFwHeaderDefinition.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/RequestEntityTooLarge.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/MessagingException.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/InvalidDataFormatException.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler`

<details>
<summary>keywords</summary>

HttpMessagingRequestParsingHandler, nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler, ハンドラクラス名, HTTPメッセージングリクエスト変換

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging-http</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-messaging-http, com.nablarch.framework, モジュール, Maven依存関係

</details>

## 制約

- [http_response_handler](handlers-http_response_handler.md) より後ろに配置すること: 変換処理失敗時にステータスコードを指定したレスポンスをクライアントに返すため。
- [thread_context_handler](handlers-thread_context_handler.md) より後ろに配置すること: スレッドコンテキスト上のリクエストIDをもとに `DataRecordFormatter` を取得するため。

<details>
<summary>keywords</summary>

http_response_handler, thread_context_handler, DataRecordFormatter, 配置順序制約, ハンドラ配置

</details>

## HTTPリクエストを要求電文に変換する

HTTPリクエストから要求電文への変換内容:

| HTTPリクエスト(変換元) | 要求電文(変換先) | 補足 |
|---|---|---|
| リクエストID | 要求電文のリクエストパス | |
| X-Message-Idリクエストヘッダ | 要求電文のメッセージID | ヘッダが存在しない場合は`400`をクライアントに返す |
| X-Correlation-Idリクエストヘッダ | 要求電文の関連メッセージID | ヘッダが存在しない場合は設定されない |
| 残りのリクエストヘッダ | 要求電文のプロトコルヘッダ | |
| リクエストボディ | フレームワーク制御ヘッダとデータレコード | |

**リクエストボディの変換**: [data_format](../libraries/libraries-data_format.md) により変換。フォーマット定義ファイルの論理名は受信時`<リクエストID>_RECEIVE`、送信時`<リクエストID>_SEND`。

デフォルトでは構造化データとして取り扱うが、フレームワーク制御ヘッダへの各項目設定は行わない。フレームワーク制御ヘッダへ項目を設定する場合、`StructuredFwHeaderDefinition` をコンポーネント設定ファイルに追加してキー情報を指定する。キー情報は `FwHeaderKeys` プロパティに指定し、キーにフィールド名、値に電文上の位置（構造化データをMapに変換した後のキー情報）を指定する。

設定例（構造化データ）:
```xml
<component class="nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler">
  <property name="fwHeaderDefinition" ref="fwHeaderDefinition"/>
</component>

<component name="fwHeaderDefinition"
           class="nablarch.fw.messaging.reader.StructuredFwHeaderDefinition">
  <property name="FwHeaderKeys">
    <map>
      <entry key="userId"     value="_nbctlhdr.userId"/>
      <entry key="resendFlag" value="_nbctlhdr.resendFlag"/>
      <entry key="statusCode" value="_nbctlhdr.statusCode"/>
    </map>
  </property>
</component>
```

固定長・可変長データの場合は標準フレームワーク制御ヘッダ定義を使用:
```xml
<component name="fwHeaderDefinition"
           class="nablarch.fw.messaging.StandardFwHeaderDefinition" />
```

**変換時の例外処理**: 以下に示す例外のみ捕捉する。以下に示していない例外については捕捉しない。

| 例外 | ログレベル | レスポンス | 説明 |
|---|---|---|---|
| `RequestEntityTooLarge` | INFO | 413 | リクエストボディのサイズ上限超過 |
| `MessagingException` | INFO | 400 | リクエストボディが不正 |
| `InvalidDataFormatException` | INFO | 400 | リクエストボディのフォーマットが不正 |

<details>
<summary>keywords</summary>

X-Message-Id, X-Correlation-Id, StructuredFwHeaderDefinition, RequestEntityTooLarge, MessagingException, InvalidDataFormatException, StandardFwHeaderDefinition, HTTPリクエスト変換, 要求電文, フレームワーク制御ヘッダ, data_format, リクエストボディ変換, FwHeaderKeys

</details>

## 巨大なサイズのリクエストを防ぐ

巨大なリクエストボディによるディスクリソース枯渇を防ぐため、サイズ上限超過時にINFOログを出力し`413`をクライアントに返す。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| bodyLengthLimit | int | | `Integer.MAX_VALUE` | リクエストボディのサイズ上限（バイト数） |

設定例:
```xml
<component class="nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler">
  <!-- アップロードサイズ(Content-Length)の上限(約10M) -->
  <property name="bodyLengthLimit" value="10000000" />
</component>
```

<details>
<summary>keywords</summary>

bodyLengthLimit, リクエストサイズ制限, 巨大リクエスト防止, 413, Integer.MAX_VALUE, Content-Length上限

</details>
