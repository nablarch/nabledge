# class HttpMessagingResponseBuildingHandler

**パッケージ:** nablarch.fw.messaging.handler

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class HttpMessagingResponseBuildingHandler
implements Handler<Object,Object>
```

HTTPメッセージングレスポンス電文構築ハンドラ
<p/>
業務アクションの作成した応答電文(ResponseMessage)をHTTPレスポンスオブジェクトに変換するハンドラ。
<p/>
応答電文構築中にフォーマットエラーが発生した場合は、業務処理の不具合と考えられるため、
システムエラー(ステータスコード500)として送出する。

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

## メソッドの詳細

### handle

```java
public Object handle(Object req, ExecutionContext ctx)
              throws ClassCastException
```

{@inheritDoc}
この実装ではHTTPRequestオブジェクトからRequestMessageオブジェクトへの変換および
ResponseMesssageオブジェクトからHttpResponseオブジェクトへの変換を行う。

**例外:**
- `java.lang.ClassCastException` - 引数 servletContext の実際の型が ServletExecutionContext でない場合。

---

### createResponseMessage

```java
private HttpResponse createResponseMessage(ResponseMessage responseMessage)
```

HttpResponseオブジェクトの生成

**パラメータ:**
- `responseMessage` - 業務応答電文

**戻り値:**
HttpResponseオブジェクト

---

### getStatusCode

```java
private int getStatusCode(ResponseMessage responseMessage)
```

ステータスコードを取得する。

レスポンスメッセージ内のFW制御ヘッダー部にステータスコードが設定されている場合には、その値をステータスコードとする。
設定されていない場合には、レスポンスメッセージが保持しているステータスコードを返却する。

**パラメータ:**
- `responseMessage` - レスポンスメッセージ

**戻り値:**
ステータスコード

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
