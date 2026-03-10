# HTTPメッセージングリクエスト変換ハンドラ

## ハンドラクラス名

**クラス**: `nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging-http</artifactId>
</dependency>
```

## 制約

- :ref:`http_response_handler` より後ろに配置すること: 変換処理に失敗した場合にステータスコードを指定したレスポンスをクライアントに返すため。
- :ref:`thread_context_handler` より後ろに配置すること: スレッドコンテキスト上のリクエストIDをもとに `DataRecordFormatter` を取得するため。

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

**リクエストボディの変換**: :ref:`data_format` により行う。フォーマット定義ファイルの論理名:
- 受信時: `<リクエストID>_RECEIVE`
- 送信時: `<リクエストID>_SEND`

デフォルトでは構造化データとして扱うが、フレームワーク制御ヘッダへの各項目は設定しない。フレームワーク制御ヘッダを設定する場合は `StructuredFwHeaderDefinition` をコンポーネント設定ファイルに追加する。`fwHeaderKeys` プロパティにはキーにフィールド名、値に電文上の位置（構造化データをMapに変換後のキー、詳細は :ref:`data_format-structured_data` 参照）を指定する。

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
