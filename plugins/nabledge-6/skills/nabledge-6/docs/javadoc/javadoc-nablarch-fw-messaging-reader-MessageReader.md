# class MessageReader

**パッケージ:** nablarch.fw.messaging.reader

**実装されたインタフェース:**
- DataReader<ReceivedMessage>

---

```java
public class MessageReader
implements DataReader<ReceivedMessage>
```

指定されたメッセージキューを監視し、受信した電文オブジェクトを返すデータリーダ。
<p/>
受信電文読み込み時にエラーが発生した場合は、例外({@link MessageReadError})を送出する。

**作成者:** Iwauo Tajima  
**関連項目:** DataReader  

---

## フィールドの詳細

### receiveQueueName

```java
private String receiveQueueName
```

このリーダが監視するキューの論理名

---

### closed

```java
private boolean closed
```

このリーダが閉じられたかどうか。

---

### timeout

```java
private long timeout
```

キューが空の場合に待機する最大時間。(単位：ミリ秒)

---

### formatFileDirName

```java
private String formatFileDirName
```

フォーマット定義ファイルが配置されているディレクトリの論理名

---

### formatFileName

```java
private String formatFileName
```

フォーマット定義ファイルの名前

---

## メソッドの詳細

### read

```java
public ReceivedMessage read(ExecutionContext ctx)
```

受信電文を読み込む。
<p/>
カレントスレッドに紐づけられた{@link MessagingContext}
オブジェクトを使用して受信キューから電文を取得し返却する。<br/>
受信キュー上に電文が1件も無い場合は、新規電文を受信するか、タイムアウト時間まで待機する。<br/>
(このタイムアウトは各スレッドが開閉局やプロセス停止フラグ等の実行制御系の
ステータスを確認するために必要となる。)<br/>
既にリーダが閉じられていた場合、またはタイムアウトした場合は{@code null}を返却する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
受信電文オブジェクト

**例外:**
- `IllegalStateException` - 受信キューの論理名が{@code null}の場合
- `RuntimeException` - 実行時例外が発生した場合
- `Error` - エラーが発生した場合
- `MessageReadError` - 受信電文オブジェクトの設定中に
                          実行時例外またはエラーが発生した場合

---

### hasNext

```java
public boolean hasNext(ExecutionContext ctx)
```

次に読み込むデータが存在するかどうかを返却する。
<p/>
この実装では、リーダが開いているかどうかで次のデータを読めるかどうか判定する。

**戻り値:**
次に読み込むデータが存在する場合は {@code true}

---

### close

```java
public void close(ExecutionContext ctx)
```

このリーダのクローズフラグを立て新規電文の受信を停止する。
<p/>
受信イベント待ちで待機中のスレッドについてはそのまま放置する。<br/>
それらのスレッドは、新規電文を受信するかタイムアウトした時点で待機が解除される。

---

### getFormatter

```java
private DataRecordFormatter getFormatter()
```

このスレッドで使用中のフォーマッターを取得する。

**戻り値:**
フォーマッター

---

### setReceiveQueueName

```java
public MessageReader setReceiveQueueName(String queueName)
```

このリーダが監視する受信キューの論理名を設定する。

**パラメータ:**
- `queueName` - 受信キューの論理名

**戻り値:**
このオブジェクト自体

---

### setReadTimeout

```java
public MessageReader setReadTimeout(long timeout)
```

受信キューが空の場合に待機する最大時間を設定する。
<p/>
0以下の値を設定した場合はタイムアウトせずに
新規電文を受信するまで待機し続ける。

**パラメータ:**
- `timeout` - 受信タイムアウト(単位：ミリ秒)

**戻り値:**
このオブジェクト自体

---

### setFormatFileName

```java
public MessageReader setFormatFileName(String fileName)
```

受信電文のフォーマット定義ファイル名を設定する。

**パラメータ:**
- `fileName` - フォーマット定義ファイル名

**戻り値:**
このオブジェクト自体

---

### setFormatFileDirName

```java
public MessageReader setFormatFileDirName(String dirName)
```

受信電文のフォーマット定義ファイルが配置されているディレクトリの
論理名を指定する。

**パラメータ:**
- `dirName` - フォーマット定義ファイル配置ディレクトリの論理名

**戻り値:**
このオブジェクト自体

---
