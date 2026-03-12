# HTTPメッセージングリクエスト変換ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/http_messaging/http_messaging_request_parsing_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpRequest.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/RequestMessage.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/DataRecordFormatter.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/StructuredFwHeaderDefinition.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/handler/HttpMessagingRequestParsingHandler.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/RequestEntityTooLarge.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/MessagingException.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/dataformat/InvalidDataFormatException.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/Integer.html)

## ハンドラクラス名

**クラス**: `nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler`

<details>
<summary>keywords</summary>

HttpMessagingRequestParsingHandler, nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler, ハンドラクラス

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

nablarch-fw-messaging-http, モジュール, Maven依存関係, com.nablarch.framework

</details>

## 制約

- [http_response_handler](handlers-http_response_handler.md) より後ろに配置すること: 変換処理に失敗した場合にステータスコードを指定したレスポンスをクライアントに返すため。
- [thread_context_handler](handlers-thread_context_handler.md) より後ろに配置すること: スレッドコンテキスト上のリクエストIDをもとに `DataRecordFormatter` を取得するため。

<details>
<summary>keywords</summary>

http_response_handler, thread_context_handler, DataRecordFormatter, ハンドラ配置順序, 制約

</details>

## HTTPリクエストを要求電文に変換する

`HttpRequest` を要求電文 `RequestMessage` に変換する。

**変換マッピング**:

| HTTPリクエスト(変換元) | 要求電文(変換先) | 補足 |
|---|---|---|
| リクエストID | 要求電文のリクエストパス | |
| X-Message-Idリクエストヘッダ | 要求電文のメッセージID | このヘッダが存在しない場合は `400` をクライアントに返す |
| X-Correlation-Idリクエストヘッダ | 要求電文の関連メッセージID | このヘッダが存在しない場合は設定されない |
| 残りのリクエストヘッダ | 要求電文のプロトコルヘッダ | |
| リクエストボディ | フレームワーク制御ヘッダとデータレコード | |

**リクエストボディの変換**: [data_format](../libraries/libraries-data_format.md) により行う。フォーマット定義ファイルの論理名:
- 受信時: `<リクエストID>_RECEIVE`
- 送信時: `<リクエストID>_SEND`

デフォルトでは構造化データとして扱うが、フレームワーク制御ヘッダへの各項目は設定しない。フレームワーク制御ヘッダを設定する場合は `StructuredFwHeaderDefinition` をコンポーネント設定ファイルに追加する。`fwHeaderKeys` プロパティにはキーにフィールド名、値に電文上の位置（構造化データをMapに変換後のキー、詳細は [data_format-structured_data](../libraries/libraries-data_format.md) 参照）を指定する。

固定長・可変長データの場合は `nablarch.fw.messaging.StandardFwHeaderDefinition` を指定する。

**設定例（構造化データ）**:
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

**設定例（固定長・可変長データ）**:
```xml
<component name="fwHeaderDefinition"
           class="nablarch.fw.messaging.StandardFwHeaderDefinition" />
```

**変換時の例外処理**: 以下に示していない例外については捕捉しない。

| 例外クラス | ログレベル | レスポンス | 説明 |
|---|---|---|---|
| `RequestEntityTooLarge` | INFO | 413 | リクエストボディのサイズ上限超過 |
| `MessagingException` | INFO | 400 | リクエストボディが不正 |
| `InvalidDataFormatException` | INFO | 400 | リクエストボディのフォーマットが不正 |

<details>
<summary>keywords</summary>

HttpRequest, RequestMessage, X-Message-Id, X-Correlation-Id, StructuredFwHeaderDefinition, StandardFwHeaderDefinition, RequestEntityTooLarge, MessagingException, InvalidDataFormatException, HTTPリクエスト変換, 要求電文, フレームワーク制御ヘッダ, リクエストボディ変換, フォーマット定義, fwHeaderKeys

</details>

## 巨大なサイズのリクエストを防ぐ

巨大なリクエストボディによるディスクリソース枯渇を防ぐため、サイズ上限超過時はINFOログを出力し `413` を返す。

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| bodyLengthLimit | `Integer#MAX_VALUE` | リクエストボディのサイズ上限（バイト） |

```xml
<component class="nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler">
  <!-- アップロードサイズ(Content-Length)の上限(約10M) -->
  <property name="bodyLengthLimit" value="10000000" />
</component>
```

<details>
<summary>keywords</summary>

bodyLengthLimit, サイズ制限, リクエストボディ上限, 413, ディスクリソース枯渇防止

</details>
