# HTTPメッセージングリクエスト変換ハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler`

往路処理において、HTTPリクエストオブジェクト(HttpRequest)を要求電文オブジェクト(RequestMessage)に変換するハンドラ。HTTPメッセージング実行制御基盤にてHTTPリクエストを処理する場合に使用する。

**ハンドラキュー配置例:**
WebFrontController → HttpAccessLogHandler → HttpMessagingRequestParsingHandler → MessageResendHandler → MessagingAction

**関連するハンドラ配置ルール:**
- [HttpAccessLogHandler](handlers-HttpAccessLogHandler.md) のようなHTTPリクエストオブジェクトに直接依存するハンドラは本ハンドラよりも上位に配置すること。
- [MessageResendHandler](handlers-MessageResendHandler.md) や [MessagingAction](handlers-MessagingAction.md) のような要求電文オブジェクトに直接依存するハンドラは本ハンドラの後続に配置すること。

<details>
<summary>keywords</summary>

HttpMessagingRequestParsingHandler, nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler, RequestMessage, HttpRequest, HTTPメッセージングリクエスト変換, 要求電文オブジェクト, HTTPメッセージング実行制御基盤, HttpAccessLogHandler, MessageResendHandler, MessagingAction

</details>

## ハンドラ処理フロー

**[往路処理]**
1. HTTPリクエストオブジェクトのメッセージボディを読み込み、リクエストデータの解析を行い、`RequestMessage`を作成する。
2. 作成した`RequestMessage`および実行コンテキストを引数として後続のハンドラに処理を委譲し、結果を取得する。

**[復路処理]**
3. 取得した処理結果をリターンし終了する。

**[例外処理]**
- **1a.** 往路処理1でMessagingExceptionまたはInvalidDataFormatExceptionが発生した場合、リクエスト内容の不備が原因とみなし、INFOレベルのログを出力後、HTTPエラーレスポンス(ステータスコード400)を送出して終了する。
- **1b.** 往路処理1で上記以外の例外が発生した場合、本ハンドラではなにもせずそのまま送出して終了する。
- **2a.** 後続ハンドラ呼び出し中に例外が送出された場合、本ハンドラではなにもせずそのまま再送出して終了する。

<details>
<summary>keywords</summary>

RequestMessage, MessagingException, InvalidDataFormatException, 往路処理, 復路処理, 例外処理, ステータスコード400

</details>

## 設定項目・拡張ポイント

**設定項目:**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| bodyLengthLimit | int | | 無制限 | リクエストのボディストリームから読み込む最大容量(バイト) |

**基本設定:**
```xml
<component class="nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler">
  <property name="bodyLengthLimit" value="${bodyLengthLimit}" />
</component>
```

デフォルトでは読み込んだデータを構造化データとして取り扱うが、フレームワーク制御ヘッダに対する各項目の読み取りおよび設定は行わない。

**フレームワーク制御ヘッダを設定する場合:** StructuredFwHeaderDefinitionコンポーネントを登録し、プロパティ`FwHeaderKeys`に電文よりヘッダ情報を取得する際のキー情報を定義する。

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

フレームワーク制御ヘッダのフィールド名:

| フレームワーク制御ヘッダ | フィールド名 |
|---|---|
| ユーザID | userId |
| 再送要求フラグ | resendFlag |
| ステータスコード | statusCode |

電文上の位置は構造化データをMapに変換した後のキー情報を記述する。キー情報については [../core_library/record_format](../libraries/libraries-record_format.md) を参照。

**固定長・可変長データを取り扱う場合:** StandardFwHeaderDefinitionを指定する。

```xml
<component name="fwHeaderDefinition"
  class="nablarch.fw.messaging.StandardFwHeaderDefinition">
</component>
```

<details>
<summary>keywords</summary>

bodyLengthLimit, StructuredFwHeaderDefinition, nablarch.fw.messaging.reader.StructuredFwHeaderDefinition, StandardFwHeaderDefinition, nablarch.fw.messaging.StandardFwHeaderDefinition, フレームワーク制御ヘッダ, userId, resendFlag, statusCode, FwHeaderKeys

</details>
