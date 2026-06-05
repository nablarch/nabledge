# class DateRotatePolicy

**パッケージ:** nablarch.core.log.basic

**実装されたインタフェース:**
- RotatePolicy

---

```java
public class DateRotatePolicy
implements RotatePolicy
```

日時でログのローテーションを行うクラス。<br>
ログ書き込み時の現在日時 >= 保持している次回ローテーション日時の場合、ローテーションを行う。<br>
<p>
プロパティファイルの記述ルールを下記に示す。
  <dl>
    <dt>rotateTime</dt>
    <dd>ローテーション時刻。オプション。<br>
      特定の時刻にログファイルをローテーションしたい場合に指定する。<br>
      時刻は、HH, HH:mm, HH:mm:ss のいずれかのフォーマットで指定する。デフォルトは00:00:00。</dd>
  </dl>
</p>
<p>
  次回ローテーション日時は、システム起動時とローテーション時に算出する。
  計算方法は以下の通り。
</p>
<p>
  まず、次回ローテーション日時を決めるための基準日時を決定する。
  基準日時は、システム起動時かつログファイルが既に存在する場合とそれ以外の場合で以下の2通りの日時を採用する。
  <ul>
    <li>システム起動時かつログファイルが存在する場合 → ログファイルの最終更新日時</li>
    <li>それ以外の場合 → システム日時</li>
  </ul>
</p>
<p>
  次に、基準日時の時刻と rotateTime の時刻を比較して、次回ローテーション日時の日付を決定する。
  <ul>
    <li>基準日時の時刻 <= rotateTime → 基準日時の日付</li>
    <li>rotateTime < 基準日時の時刻 → 基準日時の日付 + 1日</li>
  </ul>
</p>
<p>
  この日付に rotateTime の時刻を設定したものを、次回ローテーション日時とする。
</p>
<p>
  例えば、rotateTimeに 12:00:00 が設定されており、基準日時が 2023-03-25 11:59:59 の場合、
  次回ローテーション日時は 2023-03-25 12:00:00 となる。<br>
  rotateTimeに 12:00:00 が設定されており、基準日時が 2023-03-25 12:00:01 の場合、
  次回ローテーション日時は 2023-03-26 12:00:00 となる。
</p>
<p>
  ローテーション後のログファイル名は、 <ログファイルパス>.yyyyMMddHHmmssSSS.old となる。
  yyyyMMddHHmmssSSSにはローテーション実施時刻が出力される。
</p>

**作成者:** Kotaro Taki  

---

## フィールドの詳細

### logFilePath

```java
private String logFilePath
```

書き込み先のファイルパス

---

### nextRotateDateTime

```java
private Date nextRotateDateTime
```

次回ローテーション日時

---

### nextRotateTime

```java
private Date nextRotateTime
```

プロパティファイルに設定された更新時刻から生成したDateオブジェクト

---

## メソッドの詳細

### initialize

```java
public void initialize(ObjectSettings settings)
```

{@inheritDoc}
起動時にログファイルパスにログファイルが既に存在する場合は、ファイルの更新時刻から次回ローテーション日時を算出する。
この初期化処理により、例えば2023年3月6日にログファイルに書き込み後アプリを停止。２日後にアプリを再起動する場合、
起動時に本クラスが保持する次回ローテーション日時は2023年3月7日 となる。

---

### calcNextRotateDateTime

```java
private Date calcNextRotateDateTime(Date currentDate)
```

次回ローテーション日時を計算する。<br>
<br>
引数で渡された現在日時の時刻部分をrotateTimeに設定されている時刻とする。<br>
rotateTimeが設定されていない場合は、00:00:00。<br>
上記で算出された次回ローテーション日時を元に、以下の通り次回ローテーション日時を計算する。<br>
1.次回ローテーション日時 >= 現在日時 の場合は、次回ローテーション日時を返す。<br>
2.次回ローテーション日時 < 現在日時 の場合は、次回ローテーション日時+1日を返す。

**パラメータ:**
- `currentDate` - 現在日時

**戻り値:**
次回ローテーション日時のDateオブジェクト

---

### needsRotate

```java
public boolean needsRotate(String message, Charset charset)
```

{@inheritDoc}<br>
現在時刻 >= 次回ローテーション日時の場合、ローテーションが必要と判定する。<br>
それ以外の場合は、ローテーションが不要と判定する。

---

### decideRotatedFilePath

```java
public String decideRotatedFilePath()
```

{@inheritDoc}
古いログファイル名は、 <ログファイルパス>.yyyyMMddHHmmssSSS.old のフォーマットで出力される。
日時には、ローテーション実施時刻が出力される。

---

### rotate

```java
public void rotate(String rotatedFilePath)
```

{@inheritDoc}
リネーム完了後に、 次回ローテーション日時を更新する。

**例外:**
- `IllegalStateException` - ログファイルのリネームができない場合

---

### getSettings

```java
public String getSettings()
```

{@inheritDoc}
設定情報のフォーマットを下記に示す。<br>
<pre>
{@code
ROTATE TIME         = [<ローテーション時刻>]
NEXT ROTATE DATE    = [<次回ローテーション日時>]
CURRENT DATE        = [<現在時刻>]
}
</pre>

**戻り値:**
設定情報

---

### currentDate

```java
protected Date currentDate()
```

現在日時を返す。

**戻り値:**
現在日時

---

### onWrite

```java
public void onWrite(String message, Charset charset)
```

{@inheritDoc}

---

### onOpenFile

```java
public void onOpenFile(File file)
```

{@inheritDoc}

---
