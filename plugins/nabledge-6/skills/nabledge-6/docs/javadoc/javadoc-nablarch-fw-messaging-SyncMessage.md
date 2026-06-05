# class SyncMessage

**パッケージ:** nablarch.fw.messaging

---

```java
public class SyncMessage
```

電文(同期送信、同期応答)を保持するクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### requestId

```java
private final String requestId
```

要求電文のリクエストID

---

### headerRecord

```java
private final Map<String,Object> headerRecord
```

ヘッダレコード

---

### dataRecords

```java
private final List<Map<String,Object>> dataRecords
```

データレコードリスト

---

## コンストラクタの詳細

### SyncMessage

```java
public SyncMessage(String requestId)
```

{@code SyncMessage}のインスタンスを生成する。

**パラメータ:**
- `requestId` - 要求電文のリクエストID

---

## メソッドの詳細

### getRequestId

```java
public String getRequestId()
```

要求電文のリクエストIDを取得する。

**戻り値:**
要求電文のリクエストID

---

### getHeaderRecord

```java
public Map<String,Object> getHeaderRecord()
```

ヘッダレコードを取得する。

**戻り値:**
ヘッダレコード

---

### setHeaderRecord

```java
public SyncMessage setHeaderRecord(Map<String,Object> headerRecord)
```

ヘッダレコードを設定する。

**パラメータ:**
- `headerRecord` - ヘッダレコード

**戻り値:**
このオブジェクト自体

---

### getDataRecord

```java
public Map<String,Object> getDataRecord()
```

データレコード(1件目)を取得する。

**戻り値:**
データレコード(1件目)。データレコードが追加されていない場合{@code null}を返す

---

### getDataRecords

```java
public List<Map<String,Object>> getDataRecords()
```

データレコードを全件取得する。

**戻り値:**
データレコードリスト。データレコードが追加されていない場合は空のListを返す。

---

### addDataRecord

```java
public SyncMessage addDataRecord(Map<String,Object> dataRecord)
```

データレコードを追加する。

**パラメータ:**
- `dataRecord` - データレコード

**戻り値:**
このオブジェクト自体

---

### addDataRecord

```java
public SyncMessage addDataRecord(Object form)
```

データレコードを追加する。

**パラメータ:**
- `form` - データレコードを表すオブジェクト

**戻り値:**
このオブジェクト自体

---
