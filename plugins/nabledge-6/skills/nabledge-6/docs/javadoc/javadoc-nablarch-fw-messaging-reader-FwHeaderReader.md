# class FwHeaderReader

**パッケージ:** nablarch.fw.messaging.reader

**実装されたインタフェース:**
- DataReader<RequestMessage>

---

```java
public class FwHeaderReader
implements DataReader<RequestMessage>
```

受信電文のフレームワーク制御ヘッダの解析を行うデータリーダ。
<p/>
{@link MessageReader}が読み込んだ受信電文のメッセージボディから
フレームワーク制御ヘッダ部分を読み込み、後続のハンドラからそれらの値を参照可能とする。<br/>
このデータリーダの戻り値の型である{@link RequestMessage}は、フレームワーク制御ヘッダに
対するアクセサを保持し、{@link nablarch.fw.Request}インターフェースを実装する。
<p/>
受信電文読み込み時にエラーが発生した場合は、必ず例外({@link MessageReadError})を送出する。
この場合、業務処理へのディスパッチは発生せず、フレームワークが直接エラー応答を行うことになる。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### messageReader

```java
private DataReader<ReceivedMessage> messageReader
```

受信電文のリーダ

---

### fwHeaderDef

```java
private FwHeaderDefinition fwHeaderDef
```

フレームワーク制御ヘッダー定義

---

### formatFileDir

```java
private String formatFileDir
```

業務データフォーマット定義ファイル配置ディレクトリ論理名

---

### messageFormatFileNamePattern

```java
private String messageFormatFileNamePattern
```

業務データフォーマット定義ファイル名パターン

---

### replyMessageFormatFileNamePattern

```java
private String replyMessageFormatFileNamePattern
```

応答電文のフォーマット定義ファイル名のパターン

---

## メソッドの詳細

### read

```java
public RequestMessage read(ExecutionContext ctx)
```

受信電文のフレームワーク制御ヘッダ部分を読み込む。
<p/>
{@link MessageReader}で取得した受信電文オブジェクトの
フレームワーク制御項目を読み込み、下記項目をスレッドコンテキストに設定する。
<ul>
    <li>リクエストID</li>
    <li>内部リクエストID</li>
    <li>ユーザID(フレームワーク制御項目に設定されている場合のみ)</li>
</ul>
また、受信電文の業務データ部の読み込みと応答電文の業務データ部生成に使用する
フォーマッタを決定し、要求電文オブジェクトに設定する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
要求電文オブジェクト（受信電文オブジェクトが{@code null}の場合は{@code null}を返す）

**例外:**
- `MessageReadError` - フレームワーク制御ヘッダのパースに失敗した場合

---

### hasNext

```java
public boolean hasNext(ExecutionContext ctx)
```

次に読み込むデータが存在するかどうかを返却する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
次に読み込むデータが存在する場合は{@code true}

---

### close

```java
public void close(ExecutionContext ctx)
```

このリーダの利用を停止し、内部的に保持している各種リソースを解放する。

**パラメータ:**
- `ctx` - 

---

### prepareMessageFormatter

```java
private void prepareMessageFormatter(RequestMessage req)
```

受信電文の業務データ部を読み込む際に使用するフォーマッターを設定する。

**パラメータ:**
- `req` - 要求電文オブジェクト

---

### prepareMessageFormatterOfReply

```java
private void prepareMessageFormatterOfReply(RequestMessage req)
```

応答電文の業務データ部を作成する際に使用するフォーマッターを設定する。

**パラメータ:**
- `req` - 要求電文オブジェクト

---

### formatterAt

```java
private DataRecordFormatter formatterAt(String dirName, String fileName)
```

指定されたパス上のフォーマット定義ファイルを元に
レコードフォーマッタを構成して返す。
<p/>
指定されたパス上にファイルが存在しなかった場合は{@code null}を返す。

**パラメータ:**
- `dirName` - フォーマット定義ファイルの配置先ディレクトリ(論理名)
- `fileName` - フォーマット定義ファイルのファイル名

**戻り値:**
レコードフォーマッター

---

### setMessageReader

```java
public FwHeaderReader setMessageReader(DataReader<ReceivedMessage> messageReader)
```

受信電文を読み込むリーダを設定する。

**パラメータ:**
- `messageReader` - データリーダ

**戻り値:**
このオブジェクト自体

**例外:**
- `IllegalArgumentException` - データリーダが{@code null}の場合

---

### setFwHeaderDefinition

```java
public FwHeaderReader setFwHeaderDefinition(FwHeaderDefinition def)
```

フレームワーク制御ヘッダ定義を設定する。

**パラメータ:**
- `def` - フレームワーク制御ヘッダ設定

**戻り値:**
このオブジェクト自体

**例外:**
- `IllegalArgumentException` - フレームワーク制御ヘッダ設定が{@code null}の場合

---

### setFormatFileDir

```java
public FwHeaderReader setFormatFileDir(String dirName)
```

業務データ部のフォーマット定義ファイルの配置先ディレクトリ論理名を設定する。
<p/>
デフォルト値は"format"。

**パラメータ:**
- `dirName` - フォーマット定義ファイルの配置先ディレクトリ論理名

**戻り値:**
このオブジェクト自体

**例外:**
- `IllegalArgumentException` - 配置先ディレクトリ論理名が無効な場合

---

### setMessageFormatFileNamePattern

```java
public FwHeaderReader setMessageFormatFileNamePattern(String pattern)
```

受信電文のフォーマット定義ファイル名のパターン文字列を設定する。
<p/>
デフォルトの設定では、以下の名称のフォーマット定義ファイルを取得する。
<pre>
(リクエストID) + "_RECEIVE.fmt"
</pre>

**パラメータ:**
- `pattern` - フォーマット定義ファイル名のパターン文字列

**戻り値:**
このオブジェクト自体

**例外:**
- `IllegalArgumentException` - パターン文字列が無効な場合

---

### setReplyMessageFormatFileNamePattern

```java
public FwHeaderReader setReplyMessageFormatFileNamePattern(String pattern)
```

応答電文のフォーマット定義ファイル名のパターン文字列を設定する。
<p/>
デフォルトの設定では、以下の名称のフォーマット定義ファイルを取得する。
<pre>
(リクエストID) + "_SEND.fmt"
</pre>

**パラメータ:**
- `pattern` - フォーマット定義ファイル名のパターン文字列

**戻り値:**
このオブジェクト自体

**例外:**
- `IllegalArgumentException` - パターン文字列が無効な場合

---
