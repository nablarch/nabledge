# class ResponseMessage

**パッケージ:** nablarch.fw.messaging

**継承階層:**
```
java.lang.Object
  └─ SendingMessage
      └─ nablarch.fw.messaging.ResponseMessage
```

**実装されたインタフェース:**
- Result

---

```java
public class ResponseMessage
extends SendingMessage
implements Result
```

本システムに対する要求電文への応答電文を表すクラス。

本クラスでは、RequestMessageと同様、応答電文の内容をフレームワークヘッダ部と
業務データ部に分離して管理しており、業務ロジックからは業務データ部しか操作できない
ようになっている。

メッセージボディを直列化する際には、フレームワークヘッダ部と業務データ部をそれぞれ
直列化して連結したものを返す。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### fwHeader

```java
private final FwHeader fwHeader
```

フレームワーク制御ヘッダ

---

### fwHeaderDefinition

```java
private FwHeaderDefinition fwHeaderDefinition
```

フレームワーク制御ヘッダ定義

---

### result

```java
private Result result
```

業務処理の結果

---

### wroteHeader

```java
private boolean wroteHeader
```

フレームワーク制御ヘッダが電文に反映されたか否か

---

## コンストラクタの詳細

### ResponseMessage

```java
public ResponseMessage(FwHeader fwHeader, ReceivedMessage message)
```

受信電文に対する応答電文を作成する。

**パラメータ:**
- `fwHeader` - 応答電文に付加するフレームワーク制御ヘッダ
- `message` - 受信電文

---

### ResponseMessage

```java
public ResponseMessage(RequestMessage message)
```

要求電文に対する応答電文を作成する。
RequestMessage#reply() から呼ばれることを想定している。

**パラメータ:**
- `message` - 要求電文オブジェクト

---

## メソッドの詳細

### getBodyBytes

```java
public byte[] getBodyBytes()
```

{@inheritDoc}
この実装では、フレームワーク制御ヘッダ部と業務データ部をそれぞれ直列化し、
連結したものを返す。
ただし、フレームワーク制御ヘッダを直列化する際、フレームワーク制御ヘッダ定義
を使用する。これは、通常{@link nablarch.fw.messaging.handler.MessageReplyHandler}によって設定される。

---

### throwAsError

```java
public void throwAsError(Throwable e)
```

実行時例外を送出し、現在の業務トランザクションをロールバックさせ、
この電文の内容をエラー応答として送信する。

**パラメータ:**
- `e` - 起因となる例外

---

### throwAsError

```java
public void throwAsError()
```

実行時例外を送出し、現在の業務トランザクションをロールバックさせ、
この電文の内容をエラー応答として送信する。

---

### getStatusCode

```java
public int getStatusCode()
```

{@inheritDoc}

---

### getMessage

```java
public String getMessage()
```

{@inheritDoc}

---

### isSuccess

```java
public boolean isSuccess()
```

{@inheritDoc}

---

### setResult

```java
public ResponseMessage setResult(Result result)
```

業務処理の結果を設定する。

**パラメータ:**
- `result` - 業務処理結果

**戻り値:**
このオブジェクト自体

---

### getFwHeader

```java
public FwHeader getFwHeader()
```

フレームワーク制御ヘッダを取得する。

**戻り値:**
フレームワーク制御ヘッダ

---

### setFwHeaderDefinition

```java
public ResponseMessage setFwHeaderDefinition(FwHeaderDefinition def)
```

フレームワークヘッダ定義を設定する。

**パラメータ:**
- `def` - フレームワーク制御ヘッダ

**戻り値:**
このオブジェクト自体

---

### setStatusCodeHeader

```java
public ResponseMessage setStatusCodeHeader(String statusCode)
```

フレームワーク制御ヘッダの処理結果コードの値を設定する。

**パラメータ:**
- `statusCode` - 処理結果コード

**戻り値:**
このオブジェクト自体

---

### addRecord

```java
public ResponseMessage addRecord(Map<String,?> record)
```

{@inheritDoc}

---

### addRecord

```java
public ResponseMessage addRecord(String recordType, Map<String,?> record)
```

{@inheritDoc}

---

### addRecord

```java
public ResponseMessage addRecord(Object recordObj)
```

{@inheritDoc}

---

### addRecord

```java
public ResponseMessage addRecord(String recordType, Object recordObj)
```

{@inheritDoc}

---
