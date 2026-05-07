# HTTPメッセージングリクエスト変換ハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* HTTPリクエストを要求電文に変換する
* 巨大なサイズのリクエストを防ぐ

HTTPリクエスト(
HttpRequest
)を要求電文(
RequestMessage
)に変換するハンドラ。

本ハンドラでは、以下の処理を行う。

* HTTPリクエストを要求電文に変換する。
  詳細は、 [HTTPリクエストを要求電文に変換する](../../component/handlers/handlers-http-messaging-request-parsing-handler.md#http-messaging-request-parsing-handler-convert) を参照。

処理の流れは以下のとおり。

![flow.png](../../../knowledge/assets/handlers-http-messaging-request-parsing-handler/flow.png)

## ハンドラクラス名

* nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging-http</artifactId>
</dependency>
```

## 制約

[HTTPレスポンスハンドラ](../../component/handlers/handlers-http-response-handler.md#http-response-handler) より後ろに配置すること

変換処理に失敗した場合は、ステータスコードを指定したレスポンスをクライアントに返すため、
本ハンドラは [HTTPレスポンスハンドラ](../../component/handlers/handlers-http-response-handler.md#http-response-handler) より後ろに配置する必要がある。

[スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) より後ろに配置すること

スレッドコンテキスト上に設定されたリクエストIDをもとに、
要求電文と応答電文の変換に使う
DataRecordFormatter を取得するため、
[スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) より後ろに本ハンドラを配置する必要がある。

## HTTPリクエストを要求電文に変換する

変換内容を以下に示す。

| HTTPリクエスト(変換元) | 要求電文(変換先) | 補足 |
|---|---|---|
| リクエストID | 要求電文のリクエストパス |  |
| X-Message-Idリクエストヘッダ | 要求電文のメッセージID | このヘッダが存在しない場合は `400` をクライアントに返す。 |
| X-Correlation-Idリクエストヘッダ | 要求電文の関連メッセージID | このヘッダが存在しない場合は設定されない。 |
| 残りのリクエストヘッダ | 要求電文のプロトコルヘッダ |  |
| リクエストボディ | フレームワーク制御ヘッダとデータレコード | 詳細は、 [リクエストボディの変換](../../component/handlers/handlers-http-messaging-request-parsing-handler.md#http-messaging-request-parsing-handler-convert-body) を参照。 |

リクエストボディの変換

リクエストボディの変換は、 [汎用データフォーマット](../../component/libraries/libraries-data-format.md#data-format) により行う。
以下のルールでフォーマット定義ファイルを準備しておく必要がある。

受信時のフォーマット定義ファイルの論理名

<リクエストID> + "_RECEIVE"

送信時のフォーマット定義ファイルの論理名

<リクエストID> + "_SEND"

デフォルトでは読み込んだデータを構造化データとして取り扱うが、
フレームワーク制御ヘッダに対する各項目の設定は行わない。
そのため、フレームワーク制御ヘッダに対する各項目を設定する場合、
StructuredFwHeaderDefinition
をコンポーネント設定ファイルに追加し、電文からヘッダ情報を取得する際のキー情報を指定する。

設定例を以下に示す。

ポイント

* キー情報は、
  StructuredFwHeaderDefinition#fwHeaderKeys
  プロパティに指定する。
* StructuredFwHeaderDefinition#fwHeaderKeys
  プロパティには、キーにフィールド名、値に電文上の位置を指定する。
  電文上の位置は構造化データをMapに変換した後のキー情報を記述する。
  構造化データからMapに変換される際のキー情報については、 [JSONやXMLの階層構造のデータを読み書きする](../../component/libraries/libraries-data-format.md#data-format-structured-data) を参照。

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

また、固定長データや可変長データを取り扱う場合は標準フレームワーク制御ヘッダ定義を指定する。

```xml
<component name="fwHeaderDefinition"
           class="nablarch.fw.messaging.StandardFwHeaderDefinition" />
```

変換時の例外処理

変換時に捕捉する例外と処理内容を以下に示す。
以下に示していない例外については捕捉しない。

nablarch.fw.results.RequestEntityTooLarge

INFO

413

リクエストボディのサイズ上限を超過したため、証跡ログとして記録する。
そして、サイズ超過を表すため、HTTPステータスコードが *413*  のレスポンスを生成する。

nablarch.fw.messaging.MessagingException

INFO

400

リクエストボディが不正なため、証跡ログとして記録する。
そして、クライアントエラーを表すため、HTTPステータスコードが *400*  のレスポンスを生成する。

nablarch.core.dataformat.InvalidDataFormatException

INFO

400

リクエストボディのフォーマットが不正なため、証跡ログとして記録する。
そして、クライアントエラーを表すため、HTTPステータスコードが *400*  のレスポンスを生成する。

## 巨大なサイズのリクエストを防ぐ

巨大なサイズのリクエストボディがリクエストされると、
ディスクリソースが枯渇するなどが原因でシステムが正常に稼働しなくなる可能性がある。

このため、このハンドラではリクエストボディのサイズ上限を超過した場合には、
証跡としてINFOログを出力し、 `413` をクライアントに返す。

リクエストボディのサイズ上限は、バイト数で設定する。
設定を省略した場合は、 Integer#MAX_VALUE となる。

以下に設定例を示す。

```xml
<component class="nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler">
  <!-- アップロードサイズ(Content-Length)の上限(約10M) -->
  <property name="bodyLengthLimit" value="10000000" />
</component>
```
