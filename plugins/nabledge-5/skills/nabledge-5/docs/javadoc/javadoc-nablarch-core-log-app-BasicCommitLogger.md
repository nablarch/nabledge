# class BasicCommitLogger

**パッケージ:** nablarch.core.log.app

**実装されたインタフェース:**
- CommitLogger

---

```java
public class BasicCommitLogger
implements CommitLogger
```

コミットログ出力の基本実装クラス。
<p/>
{@link #setInterval(int)}で指定された間隔でコミットログを出力する。
ログ出力間隔の設定を省略した場合のデフォルト値は、500である。
コミットログは、以下のフォーマットで出力される。
<pre>
{@code

COMMIT COUNT = [コミット件数]
TOTAL COMMIT COUNT = [総コミット件数]    # 本ログは、最後に１度のみ出力される。
}
</pre>

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### commitCount

```java
private long commitCount
```

コミット件数

---

### totalCommitCount

```java
private long totalCommitCount
```

総コミット件数

---

### interval

```java
private int interval
```

コミットログ出力間隔。

---

### initialized

```java
private boolean initialized
```

初期化フラグ

---

### LOGGER

```java
private static final Logger LOGGER
```

コミットログを出力する際に使用するロガー

---

## メソッドの詳細

### initialize

```java
public synchronized void initialize()
```

{@inheritDoc}
コミット件数及び、総コミット件数を初期化(0クリア)する。

---

### increment

```java
public synchronized void increment(long count)
               throws IllegalStateException
```

コミット件数を加算する。

コミット件数を加算した結果、ログ出力間隔を超えた場合にはコミットログの出力を行う。
初期化が行われていない場合は、{@link IllegalStateException}を送出する。

{@inheritDoc}

**例外:**
- `IllegalStateException` - 本オブジェクトが初期化されていない場合

---

### formatForIncrement

```java
protected String formatForIncrement(long count)
```

{@link #increment}メソッドでログに出力する総コミット件数のメッセージをフォーマットする。

**パラメータ:**
- `count` - 総コミット件数

**戻り値:**
フォーマットされたメッセージ

---

### terminate

```java
public synchronized void terminate()
```

{@inheritDoc}
総コミット件数をログ出力する。
初期化が行われていない場合は、何も行わない。

---

### formatForTerminate

```java
protected String formatForTerminate(long count)
```

{@link #terminate}メソッドでログに出力する総コミット件数のメッセージをフォーマットする。

**パラメータ:**
- `count` - 総コミット件数

**戻り値:**
フォーマットされたメッセージ

---

### setInterval

```java
public void setInterval(int interval)
```

間隔を設定する。

**パラメータ:**
- `interval` - 間隔

---
