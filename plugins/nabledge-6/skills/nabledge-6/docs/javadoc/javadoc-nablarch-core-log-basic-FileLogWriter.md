# class FileLogWriter

**パッケージ:** nablarch.core.log.basic

**継承階層:**
```
java.lang.Object
  └─ LogWriterSupport
      └─ nablarch.core.log.basic.FileLogWriter
```

---

```java
public class FileLogWriter
extends LogWriterSupport
```

ファイルにログを書き込むクラス。<br>
<br>
FileLogWriterクラスの特徴を下記に示す。<br>
<ul>
<li>ログフォーマッタを設定で指定できる。</li>
<li>設定されたクラスに従いログファイルのローテーションを行うことができる。</li>
<li>初期処理と終了処理、ログファイルの切り替え時に、書き込み先のログファイルにINFOレベルでメッセージを出力する。</li>
</ul>
本クラスでは、ファイルへのログ書き込みに{@link java.io.BufferedOutputStream}を使用する。<br>
出力バッファのサイズは設定で変更できる。<br>
書き込み処理では、書き込み後にすぐにフラッシュし、書き込んだ内容をファイルに反映する。<br>
<br>
プロパティファイルの記述ルールを下記に示す。<br>
<dl>
<dt>filePath</dt>
<dd>書き込み先のファイルパス。必須。</dd>

<dt>encoding</dt>
<dd>書き込み時に使用する文字エンコーディング。オプション。<br>
    指定しなければシステムプロパティ(file.encoding)から取得した文字エンコーディング。</dd>

<dt>outputBufferSize</dt>
<dd>出力バッファのサイズ。オプション。<br>
    単位はキロバイト。1000バイトを1キロバイトと換算する。１以上を指定する。指定しなければ8KB。</dd>

<dt>rotatePolicy</dt>
<dd>ファイルローテーション実行クラスのFQCNを指定する。オプション。<br>
    {@link RotatePolicy}が実装されたクラスのFQCNを指定する。<br>
    デフォルトでは{@link FileSizeRotatePolicy}が使用される。<br>
    利用するローテーション実行クラス毎に、追加でプロパティの設定が必要となる。</dd>
</dl>
本クラスでは、初期処理と終了処理、ログファイルの切り替え時に、書き込み先のログファイルにINFOレベルでメッセージを出力する。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### FQCN

```java
private static final String FQCN
```

FQCN

---

### KB

```java
public static final int KB
```

キロバイトを算出するための係数

---

### filePath

```java
private String filePath
```

書き込み先のファイルパス

---

### charset

```java
private Charset charset
```

書き込み時に使用する文字エンコーディング

---

### outputBufferSize

```java
private int outputBufferSize
```

出力バッファのサイズ

---

### out

```java
private OutputStream out
```

ファイルに書き込みを行う出力ストリーム

---

### rotatePolicy

```java
private RotatePolicy rotatePolicy
```

ファイルローテーションを行うためのインターフェース

---

## メソッドの詳細

### onInitialize

```java
protected void onInitialize(ObjectSettings settings)
```

{@inheritDoc}
<p/>
プロパティファイルで指定された設定情報を取得し、ファイルへの書き込みを行う出力ストリームを初期化する。<br>
初期処理完了後、INFOレベルで設定情報を出力する。

---

### getSettings

```java
protected String getSettings()
```

設定情報を取得する。<br>
<br>
設定情報のフォーマットを下記に示す。<br>
<br>
WRITER NAME         = [&lt;{@link LogWriter}の名称&gt;]<br>
WRITER CLASS        = [&lt;{@link LogWriter}のクラス名&gt;]<br>
FORMATTER CLASS     = [&lt;{@link LogFormatter}のクラス名&gt;]<br>
LEVEL               = [&lt;ログの出力制御の基準とする{@link LogLevel}&gt;]
FILE PATH           = [&lt;書き込み先のファイルパス&gt;]<br>
ENCODING            = [&lt;書き込み時に使用する文字エンコーディング&gt;]<br>
OUTPUT BUFFER SIZE  = [&lt;出力バッファのサイズ&gt;]<br>
ROTATE POLICY CLASS = [&lt;ファイルローテーション実行クラス&gt;]<br>
<br>
追加で{@link RotatePolicy#getSettings()}によって得られた設定情報が出力される。<br>

**戻り値:**
設定情報

---

### onTerminate

```java
protected void onTerminate()
```

{@inheritDoc}<br>
<br>
終了処理の前に、INFOレベルで終了メッセージを出力する。<br>
ファイルへの書き込みを行う出力ストリームをクローズする。

---

### onWrite

```java
protected void onWrite(String formattedMessage)
```

{@inheritDoc}<br>
<br>
設定情報に基づきログをファイルに書き込む。<br>
書き込み後にすぐにフラッシュし、書き込んだ内容をファイルに反映する。<br>
<br>
IO例外が発生した場合は、IO例外をラップして{@link IllegalStateException}を送出する。

---

### renameFile

```java
private void renameFile(String formattedMessage)
```

ローテーションの種類毎にファイルをリネームする。<br>
ファイルをリネームする場合は、併せてファイルへの書き込みを行う出力ストリームを初期化する。

**パラメータ:**
- `formattedMessage` - メッセージ

---

### initializeWriter

```java
private void initializeWriter(String message)
```

ファイルへの書き込みを行う出力ストリームと書き込み先ファイルの現在のサイズを初期化する。

**パラメータ:**
- `message` - 初期処理完了後に書き込むメッセージ

---

### terminateWriter

```java
private void terminateWriter(String message)
```

ファイルへの書き込みを行う出力ストリームの終了処理を行う。

**パラメータ:**
- `message` - 終了処理の直前に書き込むメッセージ

---

### write

```java
private void write(String message)
           throws IOException
```

メッセージの書き込みを行いフラッシュする。

**パラメータ:**
- `message` - メッセージ

**例外:**
- `IOException` - IO例外

---
