# class HttpMessagingRequestParsingHandler

**パッケージ:** nablarch.fw.messaging.handler

**実装されたインタフェース:**
- Handler<HttpRequest,Object>

---

```java
public class HttpMessagingRequestParsingHandler
implements Handler<HttpRequest,Object>
```

HTTPメッセージングデータ解析ハンドラ
<p/>
HTTPリクエストの内容を解析し、メッセージング機能で使用される電文オブジェクトを作成することで、
画面オンライン実行基盤にて使用されるハンドラ郡とメッセージング制御基盤にて使用されるハンドラ郡の
橋渡し的な機能を提供する。

**作成者:** TIS  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー *

---

### MESSAGING_LOGGER

```java
private static final Logger MESSAGING_LOGGER
```

証跡ログを出力するロガー

---

### CHARSET_PTN

```java
private static final Pattern CHARSET_PTN
```

Content-Typeヘッダから文字セットを取得するためのパターン

---

### HTTP_HEADER_MESSAGE_ID

```java
private static final String HTTP_HEADER_MESSAGE_ID
```

HTTPヘッダ名・メッセージID

---

### HTTP_HEADER_CORRELATION_ID

```java
private static final String HTTP_HEADER_CORRELATION_ID
```

HTTPヘッダ名・関連メッセージID

---

### fwHeaderDefinition

```java
private FwHeaderDefinition fwHeaderDefinition
```

フレームワーク制御ヘッダ定義

---

### FORMAT_FILE_DIR

```java
private static final String FORMAT_FILE_DIR
```

業務データフォーマット定義ファイル配置ディレクトリ論理名

---

### BODY_READ_BUF_SIZE

```java
private static final int BODY_READ_BUF_SIZE
```

データ読み込み時バッファサイズ

---

### bodyLengthLimit

```java
private int bodyLengthLimit
```

リクエストのボディストリームから読み込む最大容量（単位：バイト）

---

## メソッドの詳細

### handle

```java
public Object handle(HttpRequest req, ExecutionContext ctx)
              throws ClassCastException
```

{@inheritDoc}
この実装ではHTTPRequestオブジェクトからRequestMessageオブジェクトへの変換および
ResponseMesssageオブジェクトからHttpResponseオブジェクトへの変換を行う。

**例外:**
- `java.lang.ClassCastException` - 引数 servletContext の実際の型が ServletExecutionContext でない場合。

---

### createRequestMessage

```java
private RequestMessage createRequestMessage(HttpRequest request, ServletExecutionContext context, String messageId)
```

RequestMessageオブジェクトを作成する

**パラメータ:**
- `request` - HTTPリクエスト
- `context` - 実行コンテキスト
- `messageId` - メッセージID

**戻り値:**
RequestMessageオブジェクト

---

### read

```java
private ReceivedMessage read(ServletExecutionContext context, String messageId)
```

HTTPリクエストの入力ストリームから全てのデータを取得し、{@link ReceivedMessage}を返却する。

**パラメータ:**
- `context` - 実行コンテキスト
- `messageId` - メッセージID

**戻り値:**
受信メッセージ

---

### readHttpBody

```java
private byte[] readHttpBody(HttpRequestWrapper request)
```

HTTPリクエストのBODY部を読み込む。

**パラメータ:**
- `request` - リクエスト

**戻り値:**
BODY部の内容

---

### createFormatter

```java
private DataRecordFormatter createFormatter(String formatFileName)
```

フォーマットファイル名からレコードフォーマットを生成する。

**パラメータ:**
- `formatFileName` - フォーマットファイル名

**戻り値:**
レコードフォーマット

---

### setFwHeaderDefinition

```java
public void setFwHeaderDefinition(FwHeaderDefinition fwHeaderDefinition)
```

フレームワーク制御ヘッダ定義を設定する。

**パラメータ:**
- `fwHeaderDefinition` - フレームワーク制御ヘッダ定義

---

### emitLog

```java
private void emitLog(InterSystemMessage<?> message, Charset charset)
```

メッセージングの証跡ログを出力する。

**パラメータ:**
- `message` - メッセージオブジェクト
- `charset` - 出力に使用する文字レット

---

### getCharsetFromContentType

```java
private Charset getCharsetFromContentType(Map<String,String> headerMap)
```

ContentTypeに設定されている文字セットを取得する。

**パラメータ:**
- `headerMap` - ヘッダ

**戻り値:**
Content-Typeヘッダに設定された文字セット、取得できない場合はデフォルト文字セット

---

### getBodyLengthLimit

```java
public int getBodyLengthLimit()
```

リクエストのボディストリームから読み込む最大容量を取得する。

**戻り値:**
bodyLengthLimit リクエストのボディストリームから読み込む最大容量（単位：バイト）

---

### setBodyLengthLimit

```java
public void setBodyLengthLimit(int bodyLengthLimit)
```

リクエストのボディストリームから読み込む最大容量を設定する。

**パラメータ:**
- `bodyLengthLimit` - リクエストのボディストリームから読み込む最大容量（単位：バイト）

---
