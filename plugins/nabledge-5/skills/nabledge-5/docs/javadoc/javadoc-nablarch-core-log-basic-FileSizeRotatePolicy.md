# class FileSizeRotatePolicy

**パッケージ:** nablarch.core.log.basic

**実装されたインタフェース:**
- RotatePolicy

---

```java
public class FileSizeRotatePolicy
implements RotatePolicy
```

ファイルサイズによるログのローテーションを行うクラス。<br>
設定したファイルの最大サイズを超える場合にローテーションを行う。
ファイルの最大サイズが指定されていない場合は、ローテーションしない。
<p>
プロパティファイルの記述ルールを下記に示す。<br>
  <dl>
    <dt>maxFileSize</dt>
    <dd>書き込み先ファイルの最大サイズ。オプション。<br>
      単位はキロバイト。1000バイトを1キロバイトと換算する。<br>
      指定値が解析可能な整数値(Long.parseLong)でない場合は自動切替なし。<br>
      指定値が０以下の場合は自動切替なし。</dd>
  </dl>
</p>
<p>
  ローテーション後のログファイル名は、 <ログファイルパス>.yyyyMMddHHmmssSSS.old となる。
  yyyyMMddHHmmssSSSはローテーション実施時刻。
</p>

**作成者:** Kotaro Taki  

---

## フィールドの詳細

### maxFileSize

```java
private long maxFileSize
```

書き込み先ファイルの最大サイズ

---

### logFilePath

```java
private String logFilePath
```

書き込み先のファイルパス

---

### currentFileSize

```java
private long currentFileSize
```

書き込み先ファイルの現在のサイズ

---

## メソッドの詳細

### initialize

```java
public void initialize(ObjectSettings settings)
```

{@inheritDoc}

---

### rotate

```java
public void rotate(String rotatedFilePath)
```

{@inheritDoc}

**例外:**
- `IllegalStateException` - ログファイルのリネームができない場合

---

### needsRotate

```java
public boolean needsRotate(String message, Charset charset)
```

{@inheritDoc}<br>
設定したファイルの最大サイズを超える場合にtrueを返す。
ファイルの最大サイズが指定されていない場合はfalseを返す。

---

### decideRotatedFilePath

```java
public String decideRotatedFilePath()
```

{@inheritDoc}
古いログファイル名は、 <ログファイルパス>.yyyyMMddHHmmssSSS.old のフォーマットで出力される。
日時には、ローテーション実施時刻が出力される。

---

### onOpenFile

```java
public void onOpenFile(File file)
```

{@inheritDoc}<br>
読み込んだファイルサイズを現在のファイルサイズとして、インスタンス変数に保持する。

---

### onWrite

```java
public void onWrite(String message, Charset charset)
```

{@inheritDoc}<br>
ファイルサイズに書き込むメッセージサイズを足すことで、現在のファイルサイズを更新する。

---

### getSettings

```java
public String getSettings()
```

{@inheritDoc}
設定情報のフォーマットを下記に示す。<br>
<pre>
{@code
FILE AUTO CHANGE    = [<ログファイルを自動で切り替えるか否か。>]
MAX FILE SIZE       = [<書き込み先ファイルの最大サイズ>]
CURRENT FILE SIZE   = [<書き込み先ファイルの現在のサイズ>]
}
</pre>

**戻り値:**
設定情報

---
