# class HttpMessagingClient

**パッケージ:** nablarch.fw.messaging.realtime.http.client

**実装されたインタフェース:**
- MessageSenderClient

---

```java
public class HttpMessagingClient
implements MessageSenderClient
```

HTTPを利用したメッセージング機能の実装。

**作成者:** Masaya Seko  

---

## フィールドの詳細

### MESSAGING_LOGGER

```java
private static final Logger MESSAGING_LOGGER
```

証跡ログを出力するロガー

---

### SYNCMESSAGE_STATUS_CODE

```java
public static final String SYNCMESSAGE_STATUS_CODE
```

SyncMessageのヘッダレコードからステータスコードを取り出すために使用するキー

---

### HTTP_HEADER_MESSAGE_ID

```java
private static final String HTTP_HEADER_MESSAGE_ID
```

HTTPヘッダ名・メッセージID

---

### responseMessageFormatFileNamePattern

```java
private String responseMessageFormatFileNamePattern
```

応答電文のデータフォーマット定義ファイル名パターン

---

### requestMessageFormatFileNamePattern

```java
private String requestMessageFormatFileNamePattern
```

要求電文のフォーマット定義ファイル名のパターン

---

### userIdToFormatKey

```java
private String userIdToFormatKey
```

メッセージ定義から取得したユーザIDを、フォーマット定義ファイルのどのキーと紐付けるか(コンポーネント定義ファイルからの設定を想定した変数)。

---

### EXIST_BODY_HTTP_METHOD

```java
private static final List<String> EXIST_BODY_HTTP_METHOD
```

送信にbody部が存在するHTTPメソッド

---

### queryStringEncoding

```java
private String queryStringEncoding
```

クエリストリングをエンコードする際に使用するエンコーディング

---

### CHARSET_PTN

```java
private static final Pattern CHARSET_PTN
```

Content-Typeヘッダから文字セットを取得するためのパターン

---

## メソッドの詳細

### sendSync

```java
public SyncMessage sendSync(MessageSenderSettings settings, SyncMessage requestMessage)
                     throws MessagingException
```

HTTPを使用したリアルタイム通信通信を行う。

**パラメータ:**
- `settings` - {@link nablarch.fw.messaging.MessageSender}の設定情報
- `requestMessage` - 要求電文

**戻り値:**
応答電文

**例外:**
- `MessagingException` - 通信に失敗した際に送出される。

---

### addCommonValue

```java
protected void addCommonValue(HttpRequestMethodEnum httpMethod, MessageSenderSettings settings, SyncMessage requestMessage)
```

要求電文に、共通プロトコルヘッダ相当部分及びフレームワーク制御ヘッダ部で使用する要素を追加する。

**パラメータ:**
- `httpMethod` - HTTPメソッド
- `settings` - {@link nablarch.fw.messaging.MessageSender}の設定情報
- `requestMessage` - 要求電文

---

### createHttpProtocolClient

```java
protected HttpProtocolClient createHttpProtocolClient()
```

HTTPプロトコルを実装したクラスのインスタンスを生成する。

**戻り値:**
HTTPプロトコルを用いた通信を行うクラスのインスタンス

---

### initHttpProtocolClient

```java
protected void initHttpProtocolClient(HttpProtocolClient argHttpProtocolClient, MessageSenderSettings settings, String mimeType)
```

HTTPプロトコルを実装したクラスのインスタンスの初期化を行う。

**パラメータ:**
- `argHttpProtocolClient` - 初期化対象のHttpProtocolClientのインスタンス
- `settings` - {@link nablarch.fw.messaging.MessageSender}の設定情報
- `mimeType` - 送信するデータの種別

---

### getAccept

```java
protected String getAccept()
```

レスポンスの本文として受信可能なタイプを取得します

**戻り値:**
レスポンスの本文として受信可能なタイプ

---

### mapToUriString

```java
protected String mapToUriString(String preUri, HttpRequestMethodEnum httpMethod, SyncMessage requestMessage)
```

URIを生成する。
<p>
このメソッドはURI生成ルールのカスタマイズのために存在している。本クラスの実装では、引数preUriを返却する。
</p>

**パラメータ:**
- `preUri` - メッセージ送信定義に記述されているURI
- `httpMethod` - HTTPメソッド
- `requestMessage` - 要求電文

**戻り値:**
URI

---

### mapToQueryMap

```java
protected Map<String,String> mapToQueryMap(String preUri, HttpRequestMethodEnum httpMethod, SyncMessage requestMessage)
```

クエリストリングを生成する。
<p>
このメソッドはクエリストリング生成ルールのカスタマイズのために存在している。本クラスの実装では、空のMapを返す。
</p>

**パラメータ:**
- `preUri` - メッセージ送信定義に記述されているURI
- `httpMethod` - HTTPメソッド
- `requestMessage` - 要求電文

**戻り値:**
URI

---

### mapToHeaderMap

```java
protected Map<String,List<String>> mapToHeaderMap(SyncMessage requestMessage)
```

HTTPヘッダに含める内容を生成する。

**パラメータ:**
- `requestMessage` - 要求電文

**戻り値:**
HTTPヘッダに含める内容を格納したMap

---

### mapToBodyString

```java
protected SimpleDataConvertResult mapToBodyString(String uri, HttpRequestMethodEnum httpMethod, SyncMessage requestMessage)
                                        throws HttpMessagingInvalidDataFormatException
```

HTTP通信のボディ部を生成する。

**パラメータ:**
- `uri` - 接続先
- `httpMethod` - HTTPメソッド
- `requestMessage` - 要求電文

**戻り値:**
変換後の文字列

**例外:**
- `HttpMessagingInvalidDataFormatException` - 電文フォーマット変換に失敗した場合に送出される。

---

### getRequestContentsType

```java
protected String getRequestContentsType(HttpRequestMethodEnum httpMethod, SimpleDataConvertResult requestBodyDataConvertResult)
```

送信時に設定するコンテンツタイプを取得する。

**パラメータ:**
- `httpMethod` - HTTPメソッド
- `requestBodyDataConvertResult` - 本文のデータ変換結果

**戻り値:**
コンテンツタイプ

---

### execute

```java
protected HttpResult execute(HttpProtocolClient httpProtocolClient, HttpRequestMethodEnum httpMethod, String uri, Map<String,List<String>> headerInfo, Map<String,String> urlParams, String charset, String bodyText)
```

HTTPリクエストを送出する。

**パラメータ:**
- `httpProtocolClient` - HTTPリクエストを発行するオブジェクト
- `httpMethod` - HTTPメソッド
- `uri` - 送信先
- `headerInfo` - HTTPリクエストのヘッダ情報
- `urlParams` - URLパラメータ
- `charset` - 文字コード
- `bodyText` - HTTPリクエストの本文

**戻り値:**
送信結果

---

### createCharHttpStreamReader

```java
protected HttpInputStreamReader createCharHttpStreamReader()
```

HTTPリクエストを発行後、OutputStreamを読み取り結果を返却させるためのIFを生成する。

**戻り値:**
OutputStreamを読み取り結果を返却させるためのIF

---

### createCharHttpStreamWritter

```java
protected HttpOutputStreamWriter createCharHttpStreamWritter(String charset, String bodyText)
```

HTTPリクエストを発行時の送信内容を保持するオブジェクトを生成する。

**パラメータ:**
- `charset` - 文字コード
- `bodyText` - 送信時の本文

**戻り値:**
送信内容を表すオブジェクト

---

### headerToMap

```java
protected Map<String,Object> headerToMap(SyncMessage requestMessage, HttpResult httpResult)
```

返信のヘッダ部分を解析し、応答電文に設定するデータを生成する。

**パラメータ:**
- `requestMessage` - 要求電文
- `httpResult` - 送信結果

**戻り値:**
解析後のMap

---

### bodyStringToMap

```java
protected SimpleDataConvertResult bodyStringToMap(String uri, HttpRequestMethodEnum httpMethod, SyncMessage requestMessage, HttpResult httpResult)
                                        throws HttpMessagingInvalidDataFormatException
```

返信のボディ部分を解析し、応答電文に設定するデータを生成する。

**パラメータ:**
- `uri` - 接続先
- `httpMethod` - HTTPメソッド
- `requestMessage` - 要求電文
- `httpResult` - 送信結果

**戻り値:**
解析後のMap

**例外:**
- `HttpMessagingInvalidDataFormatException` - 電文フォーマット変換に失敗した場合に送出される。

---

### getResponseMessageFormatFileNamePattern

```java
protected String getResponseMessageFormatFileNamePattern()
```

応答電文のデータフォーマット定義ファイル名パターンを取得する。

**戻り値:**
応答電文のデータフォーマット定義ファイル名パターン

---

### getRequestMessageFormatFileNamePattern

```java
protected String getRequestMessageFormatFileNamePattern()
```

要求電文のフォーマット定義ファイル名のパターンを取得する。

**戻り値:**
要求電文のフォーマット定義ファイル名のパターン

---

### getUserIdToFormatKey

```java
public String getUserIdToFormatKey()
```

ユーザIDとフォーマット定義ファイル上のキーとの対応を取得する。

**戻り値:**
フォーマット定義ファイル上のキー

---

### setUserIdToFormatKey

```java
public void setUserIdToFormatKey(String userIdToFormatKey)
```

ユーザIDとフォーマット定義ファイル上のキーとの対応を設定する。

**パラメータ:**
- `userIdToFormatKey` - フォーマット定義ファイル上のキー

---

### getExistBodyHttpMethod

```java
protected List<String> getExistBodyHttpMethod()
```

送信にbody部が存在するHTTPメソッドのリストを取得する。

**戻り値:**
送信にbody部が存在するHTTPメソッドのリスト

---

### getQueryStringEncoding

```java
public String getQueryStringEncoding()
```

クエリストリングをエンコードする際に使用する文字コードを取得する。

**戻り値:**
文字コード

---

### setQueryStringEncoding

```java
public void setQueryStringEncoding(String queryStringEncoding)
```

クエリストリングをエンコードする際に使用する文字コードを設定する。

**パラメータ:**
- `queryStringEncoding` - 文字コード

---

### emitRequestLog

```java
private void emitRequestLog(Map<String,Object> requestHeader, HttpRequestMethodEnum method, String uri, String bodyText, String charsetName)
```

メッセージングの証跡ログを出力する。

**パラメータ:**
- `requestHeader` - 要求ヘッダ情報
- `method` - HTTPメソッド
- `uri` - 接続先URI
- `bodyText` - 変換済みの要求メッセージ本文
- `charsetName` - 変換に使用した文字セット

---

### emitResponseLog

```java
private void emitResponseLog(Map<String,Object> responseHeader, String bodyText, String charsetName)
```

メッセージングの証跡ログを出力する。

**パラメータ:**
- `responseHeader` - 応答ヘッダ情報
- `bodyText` - 変換前の応答メッセージ本文
- `charsetName` - 変換に使用した文字セット

---

### getResponseBody

```java
private String getResponseBody(HttpResult httpResult)
```

応答データの本文を取得する。

**パラメータ:**
- `httpResult` - 応答データ

**戻り値:**
応答データの本文

---

### getResponseCharset

```java
private String getResponseCharset(Map<String,Object> resHeadderMap)
```

応答データの文字セットを取得する。

**パラメータ:**
- `resHeadderMap` - 応答データのヘッダ

**戻り値:**
Content-Typeヘッダに設定された文字セット、取得できない場合はデフォルト文字セット

---
