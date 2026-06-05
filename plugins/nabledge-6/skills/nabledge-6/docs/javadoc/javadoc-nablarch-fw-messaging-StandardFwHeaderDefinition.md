# class StandardFwHeaderDefinition

**パッケージ:** nablarch.fw.messaging

**実装されたインタフェース:**
- FwHeaderDefinition

---

```java
public class StandardFwHeaderDefinition
implements FwHeaderDefinition
```

Nablarch標準のフレームワーク制御ヘッダ定義。

本実装では、各電文のメッセージボディの先頭レコード上に
全てのフレームワーク制御ヘッダが定義されていることを前提としており、
JMSヘッダー等のメッセージングプロバイダ実装に依存する項目は使用しない。
<p/>
以下は本クラスで使用できるフレームワーク制御ヘッダの定義例である。
このデータレコードが電文の先頭に位置している必要がある。
<pre>
#====================================================================
# フレームワーク制御ヘッダ部 (50byte)
#====================================================================
[NablarchHeader]
1   requestId   X(10)       # リクエストID
11  userId      X(10)       # ユーザID
21  resendFlag  X(1)  "0"   # 再送要求フラグ (0: 初回送信 1: 再送要求)
22  statusCode  X(4)  "200" # ステータスコード
26 ?filler      X(25)       # 予備領域
#====================================================================
</pre>
フォーマット定義にフレームワーク制御ヘッダ以外の項目を含めた場合、
{@link FwHeader}クラスの任意属性としてアクセスすることができる。
これらの属性は、PJ毎にフレームワーク制御ヘッダを簡易的に拡張する場合に
利用することができる。
<p/>
なお、将来的な任意項目の追加およびフレームワークの機能追加に伴うヘッダ追加
に対応するために、予備領域を設けておくことを強く推奨する。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### formatFileDir

```java
private String formatFileDir
```

フォーマット定義ファイル配置ディレクトリ論理名

---

### formatFileName

```java
private String formatFileName
```

フォーマット定義ファイル名

---

### resendFlagOffValue

```java
private Object resendFlagOffValue
```

初回電文を表す再送要求フラグの値

---

## メソッドの詳細

### readFwHeaderFrom

```java
public RequestMessage readFwHeaderFrom(ReceivedMessage message)
```

{@inheritDoc}
この実装ではメッセージボディの先頭レコードを取得し、
フレームワーク制御ヘッダの各項目を読み込む。

---

### writeFwHeaderTo

```java
public void writeFwHeaderTo(SendingMessage message, FwHeader header)
```

{@inheritDoc}
この実装では、メッセージボディ部のバイト列の先頭にフレームワーク制御ヘッダ
のバイト列を連結する。

---

### setFormatFileDir

```java
public StandardFwHeaderDefinition setFormatFileDir(String dirName)
```

フレームワーク制御ヘッダーのフォーマット定義ファイルが配置されている
ディレクトリの論理名を設定する。
設定を省略した場合のデフォルト値は"format"である。

**パラメータ:**
- `dirName` - フォーマット定義ファイル配置ディレクトリの論理名

**戻り値:**
このオブジェクト自体

---

### setFormatFileName

```java
public StandardFwHeaderDefinition setFormatFileName(String fileName)
```

フレームワーク制御ヘッダーのフォーマット定義ファイルのファイル名
を設定する。
設定を省略した場合のデフォルト値は"header.fmt"となる。

**パラメータ:**
- `fileName` - フォーマット定義ファイル名

**戻り値:**
このオブジェクト自体

---

### getFormatter

```java
public synchronized DataRecordFormatter getFormatter()
```

フレームワーク制御ヘッダーのフォーマット定義を返す。

**戻り値:**
フレームワーク制御ヘッダーのフォーマット定義

---

### getFormatter

```java
public synchronized DataRecordFormatter getFormatter(FilePathSetting filePathSetting, FormatterFactory formatterFactory)
```

指定された{@link FilePathSetting}インスタンスを使用して
フレームワーク制御ヘッダーのフォーマット定義を返す。

**パラメータ:**
- `filePathSetting` - フォーマット定義ファイルを取得するための{@link FilePathSetting}
- `formatterFactory` - フォーマット定義を生成するファクトリ

**戻り値:**
フレームワーク制御ヘッダーのフォーマット定義

---

### setResendFlagOffValue

```java
public StandardFwHeaderDefinition setResendFlagOffValue(Object value)
```

初回電文時に設定される再送要求フラグの値を設定する。

**パラメータ:**
- `value` - 初回電文時に設定される再送要求フラグの値

**戻り値:**
このオブジェクト自体

---

### getResendFlagOffValue

```java
public Object getResendFlagOffValue()
```

初回電文時に設定される再送要求フラグの値を返す。

**戻り値:**
初回電文時に設定される再送要求フラグの値

---
