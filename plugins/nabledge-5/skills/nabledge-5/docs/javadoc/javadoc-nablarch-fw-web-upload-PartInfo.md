# class PartInfo

**パッケージ:** nablarch.fw.web.upload

---

```java
public final class PartInfo
```

マルチパートの情報を保持するクラス。<br/>

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### NOT_FOUND

```java
private static final int NOT_FOUND
```

文字列が見つからなかったことを表す定数

---

### name

```java
private String name
```

inputタグに付与されたname属性の値

---

### fileName

```java
private String fileName
```

アップロードされたファイル名

---

### contentType

```java
private String contentType
```

content-type

---

### savedFile

```java
private File savedFile
```

一時保存されたファイル

---

### size

```java
private int size
```

ファイルサイズ

---

### status

```java
private Status status
```

一時ファイルの状態

---

### HEX_REPS

```java
private static final char[] HEX_REPS
```

ヘキサ表現文字

---

### RANDOM_GEN

```java
private static final Random RANDOM_GEN
```

乱数

---

### DEFAULT_FILE_SUFFIX

```java
private static final String DEFAULT_FILE_SUFFIX
```

ファイル保存に使用するデフォルト拡張子

---

### seq

```java
private static AtomicInteger seq
```

ファイル名を作る時に使用するシーケンス番号。

---

## コンストラクタの詳細

### PartInfo

```java
private PartInfo()
```

コンストラクタ

---

## メソッドの詳細

### newInstance

```java
static PartInfo newInstance(List<String> headers)
```

新しいインスタンスを取得する。</br>

**パラメータ:**
- `headers` - ヘッダ行

**戻り値:**
新しいインスタンス

---

### newInstance

```java
public static PartInfo newInstance(String name)
```

新しいインスタンスを取得する。<br/>
自動テスト時に使用されることを想定している。

**パラメータ:**
- `name` - inputタグに付与されたname属性の値

**戻り値:**
新しいインスタンス

---

### getInputStream

```java
public InputStream getInputStream()
```

アップロードファイルを開く。<br/>
入力ストリームはクライアント側でcloseする必要がある。

**戻り値:**
入力ストリーム

---

### parseContentDisposition

```java
private void parseContentDisposition(String orig, String lower)
```

Content-Dispositionの解析、設定を行う。

**パラメータ:**
- `orig` - Content-Dispositionの行
- `lower` - 小文字化したContent-Dispositionの行

---

### setContentType

```java
private void setContentType(String line)
```

Content-Typeを解析し、文字列を取得する。<br>

**パラメータ:**
- `line` - 行データ

---

### isFile

```java
boolean isFile()
```

このインスタンスが表すマルチパートがアップロードファイルであるかどうか判定する。

**戻り値:**
アップロードファイルの場合は真

---

### getName

```java
public String getName()
```

名前を取得する。<br/>
例えば、{@literal <input type="file" name="picture"/>}という
HTMLタグでアップロードされた場合、本メソッドの戻り値は"picture"となる。

**戻り値:**
POSTされたときのname属性

---

### getFileName

```java
public String getFileName()
```

ファイル名を取得する。<br/>
例えば、ユーザが"C:\doc\myPicture.jpg"というファイルをアップロードした場合、
本メソッドの戻り値は"myPicture.jpg"となる。

**戻り値:**
アップロード元のファイル名

---

### getContentType

```java
public String getContentType()
```

Content-Typeを取得する。

**戻り値:**
Content-Type

---

### generateFileName

```java
String generateFileName()
```

ファイル名を生成する。

**戻り値:**
ファイル名

---

### getRandomToken

```java
private String getRandomToken()
```

5byteのランダムデータのヘキサ表現(10文字)を返す。

**戻り値:**
ランダム文字列

---

### getOutputStream

```java
OutputStream getOutputStream(File saveDir)
```

出力ストリームを開く。<br/>
出力ストリームはクライアント側でcloseする必要がある。

**パラメータ:**
- `saveDir` - 出力先ディレクトリ

**戻り値:**
出力先ストリーム

---

### createNewFile

```java
private File createNewFile(File saveDir)
```

保存用に新しいファイルを作成する。

**パラメータ:**
- `saveDir` - 保存先ディレクトリ

**戻り値:**
新しいファイル

---

### clean

```java
void clean()
```

保存したファイルを削除する。

---

### extractFileSuffix

```java
String extractFileSuffix(String fileName)
```

拡張子を抽出する。

**パラメータ:**
- `fileName` - ファイル名

**戻り値:**
拡張子（拡張子が無い場合はデフォルト値）

---

### generateSequence

```java
private static synchronized int generateSequence()
```

シーケンス番号を生成する。

**戻り値:**
シーケンス番号

---

### toString

```java
public String toString()
```

{@inheritDoc}

---

### size

```java
public int size()
```

アップロードされたファイルのサイズを取得する（単位はバイト）。

**戻り値:**
サイズ（バイト）

---

### setSize

```java
public void setSize(int size)
```

アップロードされたファイルのサイズを設定する(単位はバイト)。

**パラメータ:**
- `size` - サイズ（バイト）

---

### setSavedFile

```java
public void setSavedFile(File file)
```

保存ファイルを設定する。<br/>
自動テスト時に使用されることを想定している。

**パラメータ:**
- `file` - ファイル

---

### getSavedFile

```java
public File getSavedFile()
```

一時保存ファイルを取得する。<br/>
取得したファイルが存在しなかったり、削除される可能性もあるので
使用する際は、nullチェック、ファイルの存在チェックなどの事前チェックを必ず行うこと。

**戻り値:**
一時保存されたファイル

---

### moveTo

```java
public void moveTo(File dir, String name)
```

ファイルを移動する。<br/>
本メソッドに対するヘルパーメソッドとして
{@link nablarch.fw.web.upload.util.UploadHelper#moveFileTo(String, String)}を利用することもできる。

**パラメータ:**
- `dir` - 移動先ディレクトリ
- `name` - 移動後のファイル名

---
