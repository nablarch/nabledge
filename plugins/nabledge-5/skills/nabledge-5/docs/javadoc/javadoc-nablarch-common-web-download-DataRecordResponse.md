# class DataRecordResponse

**パッケージ:** nablarch.common.web.download

**継承階層:**
```
java.lang.Object
  └─ HttpResponse
      └─ nablarch.common.web.download.DataRecordResponse
```

---

```java
public class DataRecordResponse
extends HttpResponse
```

Map型のデータレコードのリストを一定のフォーマットに従って直列化し、
その内容をレスポンスボディとするHTTPレスポンスオブジェクト。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### dest

```java
private final ByteArrayOutputStream dest
```

フォーマットで使用する出力ストリーム

---

### formatter

```java
private final DataRecordFormatter formatter
```

データレコードのフォーマッタ

---

## コンストラクタの詳細

### DataRecordResponse

```java
public DataRecordResponse(String basePathName, String fileName)
```

コンストラクタ。
<p/>
フォーマット定義ファイルを元に、使用する{@link DataRecordFormatter}を設定する。

**パラメータ:**
- `basePathName` - フォーマット定義ファイルのベースパス論理名
- `fileName` - フォーマット定義ファイルのファイル名

---

## メソッドの詳細

### write

```java
public void write(Map<String,?> record)
```

メッセージボディに1レコード分のデータを書き込む。
<p/>
データレイアウト(レコードタイプ）の決定方法については
{@link DataRecordFormatter#writeRecord(Map)}を参照すること。

**パラメータ:**
- `record` - 1レコード分のデータ

**例外:**
- `RuntimeException` - 出力ストリームの書き込みに失敗した場合
- `nablarch.core.dataformat.InvalidDataFormatException` - 書き込むデータの内容がフォーマット定義に違反している場合。

---

### write

```java
public void write(String recordType, Map<String,?> record)
```

データレイアウト(レコードタイプ）を指定して、メッセージボディに1レコード分のデータを書き込む。

**パラメータ:**
- `recordType` - 出力時に使用するデータレイアウト
- `record` - 1レコード分のデータ

**例外:**
- `RuntimeException` - 出力ストリームの書き込みに失敗した場合
- `nablarch.core.dataformat.InvalidDataFormatException` - 書き込むデータの内容がフォーマット定義に違反している場合。

---

### cleanup

```java
public HttpResponse cleanup()
```

---
