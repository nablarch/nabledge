# class StructuredFwHeaderDefinition

**パッケージ:** nablarch.fw.messaging.reader

**実装されたインタフェース:**
- FwHeaderDefinition

---

```java
public class StructuredFwHeaderDefinition
implements FwHeaderDefinition
```

構造化データのフレームワーク制御ヘッダの解析を行うデータリーダ。
<p/>
このデータリーダ実装は、MessageReaderが読み込んだ受信電文のメッセージボディから 
フレームワーク制御ヘッダ部分を読み込み、後続のハンドラからそれらの値を参照可能とする。
このリーダの戻り値の型であるRequestMessageは、フレームワーク制御ヘッダに
対するアクセサを保持し、{@link nablarch.fw.Request}インターフェースを実装する。
<p/>

**作成者:** TIS  

---

## フィールドの詳細

### resendFlagOffValue

```java
private String resendFlagOffValue
```

初回電文を表す再送要求フラグの値

---

### formatFileDir

```java
private String formatFileDir
```

ヘッダフォーマット定義ファイル配置ディレクトリ論理名

---

### headerFormatFileNamePattern

```java
private String headerFormatFileNamePattern
```

ヘッダフォーマット定義ファイル名パターン

---

### fwHeaderKeys

```java
private Map<String,String> fwHeaderKeys
```

フレームワーク制御ヘッダキー名リスト

---

## メソッドの詳細

### readFwHeaderFrom

```java
public RequestMessage readFwHeaderFrom(ReceivedMessage message)
```

{@inheritDoc}

---

### getFormatter

```java
public synchronized DataRecordFormatter getFormatter(String dataType)
```

フレームワーク制御ヘッダーのフォーマット定義を返す。

**パラメータ:**
- `dataType` - データ種別

**戻り値:**
フレームワーク制御ヘッダーのフォーマット定義

---

### getFormatter

```java
public synchronized DataRecordFormatter getFormatter(String dataType, FilePathSetting filePathSetting, FormatterFactory formatterFactory)
```

指定された{@link FilePathSetting}インスタンスを使用して
フレームワーク制御ヘッダーのフォーマット定義を返す。

**パラメータ:**
- `dataType` - データ種別
- `filePathSetting` - フォーマット定義ファイルを取得するための{@link FilePathSetting}
- `formatterFactory` - フォーマット定義を生成するファクトリ

**戻り値:**
フレームワーク制御ヘッダーのフォーマット定義

---

### writeFwHeaderTo

```java
public void writeFwHeaderTo(SendingMessage message, FwHeader header)
```

{@inheritDoc}

---

### setResendFlagOffValue

```java
public StructuredFwHeaderDefinition setResendFlagOffValue(String value)
```

初回電文時に設定される再送要求フラグの値を設定する。

**パラメータ:**
- `value` - 初回電文時に設定される再送要求フラグの値

**戻り値:**
このオブジェクト自体

---

### getResendFlagOffValue

```java
public String getResendFlagOffValue()
```

初回電文時に設定される再送要求フラグの値を返す。

**戻り値:**
初回電文時に設定される再送要求フラグの値

---

### setFwHeaderKeys

```java
public StructuredFwHeaderDefinition setFwHeaderKeys(Map<String,String> fwHeaderKeys)
```

フレームワーク制御ヘッダキー名リストを設定する

**パラメータ:**
- `fwHeaderKeys` - フレームワーク制御ヘッダキー名リスト

**戻り値:**
このオブジェクト自体

---
