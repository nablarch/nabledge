# class SynchronousFileLogWriter

**パッケージ:** nablarch.core.log.basic

**継承階層:**
```
java.lang.Object
  └─ FileLogWriter
      └─ nablarch.core.log.basic.SynchronousFileLogWriter
```

---

```java
public class SynchronousFileLogWriter
extends FileLogWriter
```

ロックファイルを用いて排他制御を行いながらファイルにログを書き込むクラス。
<p>
本クラスを使用するとプロセスをまたがってログ出力処理を直列化できるので、複数プロセスから同一のファイルにログ出力を行う場合でも確実にログを出力できる。<br/>
本クラスは障害通知ログのように出力頻度が低く、かつサーバ単位でログファイルを一元管理するほうが効率的なログの出力にのみ使用することを想定している。
頻繁にログの出力が行われる場面で本クラスを使用するとロック取得待ちによって性能が劣化する可能性があるので、
アプリケーションログやアクセスログのように出力頻度の高いログの出力に本クラスを使用してはいけない。<br/>
</p>
<p>
本クラスはロック取得の待機時間を超えてもロックを取得できない場合、
強制的にロックファイルを削除し、ロックファイルを生成してからログの出力を行う。<br/>
もし強制的にロックファイルを削除できない場合は、ロックを取得していない状態で強制的にログの出力を行い、処理を終了する。<br/>
また、ロックファイルの生成に失敗した場合および、ロック取得待ちの際に割り込みが発生した場合も、ロックを取得していない状態で強制的にログの出力を行い、処理を終了する。
</p>

**作成者:** Masato Inoue  

---

## フィールドの詳細

### MIN_LOCK_RETRY_INTERVAL

```java
private static final int MIN_LOCK_RETRY_INTERVAL
```

ロック取得の再試行間隔（ミリ秒）の最小値（0にするとsleepなしのループになるので、1を最小値とする）

---

### MIN_LOCK_WAIT_TIME

```java
private static final int MIN_LOCK_WAIT_TIME
```

ロック取得の待機時間（ミリ秒）の最小値

---

### DEFAULT_LOCK_RETRY_INTERVAL

```java
private static final int DEFAULT_LOCK_RETRY_INTERVAL
```

ロック取得の再試行間隔（ミリ秒）のデフォルト値

---

### DEFAULT_LOCK_WAIT_TIME

```java
private static final int DEFAULT_LOCK_WAIT_TIME
```

ロック取得の待機時間（ミリ秒）のデフォルト値

---

### lockFile

```java
private File lockFile
```

ロックファイル

---

### lockFilePath

```java
private String lockFilePath
```

ロックファイルのパス

---

### lockRetryInterval

```java
private long lockRetryInterval
```

ロック取得の再試行間隔（ミリ秒）

---

### lockWaitTime

```java
private long lockWaitTime
```

ロック取得の待機時間（ミリ秒）

---

### failureCodeCreateLockFile

```java
private String failureCodeCreateLockFile
```

ロックファイルが生成できない場合の障害通知コード

---

### failureCodeReleaseLockFile

```java
private String failureCodeReleaseLockFile
```

生成したロックファイルを解放（削除）できない場合の障害通知コード

---

### failureCodeForceDeleteLockFile

```java
private String failureCodeForceDeleteLockFile
```

解放されないロックファイルを強制削除できない場合の障害通知コード（待機時間を超えた場合に発生）

---

### failureCodeInterruptLockWait

```java
private String failureCodeInterruptLockWait
```

ロック待ちでスレッドをスリープしている際に、割り込みが発生した場合の障害通知コード

---

## メソッドの詳細

### onInitialize

```java
protected void onInitialize(ObjectSettings settings)
```

{@inheritDoc}

---

### getSettings

```java
protected String getSettings()
```

設定情報を取得する。<br>
<br>
設定情報のフォーマットを下記に示す。<br>
<br>
<pre>
{@literal
WRITER NAME        = [<{@link LogWriter}の名称>]
WRITER CLASS       = [<{@link LogWriter}のクラス名>]
FORMATTER CLASS    = [<{@link LogFormatter}のクラス名>]
LEVEL              = [<ログの出力制御の基準とするLogLevel>]
FILE PATH          = [<書き込み先のファイルパス>]
ENCODING           = [<書き込み時に使用する文字エンコーディング>]
OUTPUT BUFFER SIZE = [<出力バッファのサイズ>]
FILE AUTO CHANGE   = [<ログファイルを自動で切り替えるか否か。>]
MAX FILE SIZE      = [<書き込み先ファイルの最大サイズ>]
CURRENT FILE SIZE  = [<書き込み先ファイルの現在のサイズ>]
LOCK FILE PATH                      = [<ロックファイルのパス>]
LOCK RETRY INTERVAL                 = [<ロック取得の再試行間隔（ミリ秒）>]
LOCK WAIT TIME                      = [<ロック取得の待機時間（ミリ秒）>]
FAILURE CODE CREATE LOCK FILE       = [<生成したロックファイルを削除できない場合の障害コード>]
FAILURE CODE RELEASE LOCK FILE      = [<生成したロックファイルを解放（削除）できない場合の障害コード>]
FAILURE CODE FORCE DELETE LOCK FILE = [<解放されないロックファイルを強制削除できない場合の障害コードド>]
FAILURE CODE INTERRUPT LOCK WAIT    = [<ロック待ちでスレッドをスリープしている際に、割り込みが発生した場合の障害コード>]
}
</pre>

**戻り値:**
設定情報

---

### write

```java
public void write(LogContext context)
```

{@inheritDoc}

---

### onWrite

```java
protected synchronized void onWrite(String formattedMessage, LogContext context)
```

ロックファイルを使用して排他制御を行いながらファイルにログ書き込みを行う。
<p/>
排他制御の仕様を以下に示す。
<ul>
<li>ロックファイルの生成に成功した場合、ログ書き込みを行い、ロックファイルを削除する。</li>
<li>ファイルパス不正などでロックファイルの生成に失敗した場合、引数で渡されたメッセージとロックファイルが作成できなかった旨のメッセージを、強制的にログファイルに出力する。</li>
<li>既にロックファイルが存在するためにロックファイルの生成に失敗した場合、一定時間処理をスリープさせ、再試行する。</li>
<li>ロック取得待機時間を超えてもロックファイルを生成できなかった場合、不要なロックファイルが残存しているとみなしロックファイルを削除し、再度ロックファイルの生成を試みる。
もしロックファイルの削除に失敗した場合、引数で渡されたメッセージとロックファイルの削除に失敗した旨のメッセージを、強制的にログファイルに出力する。</li>
<li>ロック取得待ちの際に割り込みが発生した場合、引数で渡されたメッセージと割り込みが発生した旨のメッセージを、強制的にログファイルに出力する。</li>
</ul>

**パラメータ:**
- `formattedMessage` - フォーマット済みのログ
- `context` - ログエントリオブジェクト

---

### lockFile

```java
protected boolean lockFile(String formattedMessage, LogContext context)
```

ロックファイルを作成し、ログファイルをロックする。

**パラメータ:**
- `formattedMessage` - フォーマット済みのログ
- `context` - ログエントリオブジェクト

**戻り値:**
ロックファイルの作成結果（true:成功 false:失敗）

---

### waitLock

```java
protected boolean waitLock(File lockFile, String formattedMessage, LogContext context)
```

ロック待ち処理を行う。
<p/>
ロック取得の再試行間隔（ミリ秒）で設定された時間、スレッドをスリープさせる。

**パラメータ:**
- `lockFile` - ロックファイル
- `formattedMessage` - フォーマット済みのログ
- `context` - ログエントリオブジェクト

**戻り値:**
もし割り込みが発生した場合にはfalse

---

### deleteLockFileExceedsLockWaitTime

```java
protected boolean deleteLockFileExceedsLockWaitTime(File lockFile, String formattedMessage, LogContext context)
```

待機時間を過ぎても残存しているロックファイルを強制的に削除する。

**パラメータ:**
- `lockFile` - ロックファイル
- `formattedMessage` - フォーマット済みのログ
- `context` - ログエントリオブジェクト

**戻り値:**
ロックファイルの強制削除が正常に終了したかどうか

---

### forceWrite

```java
protected void forceWrite(String formattedMessage, LogContext context, String lockErrorMessage)
```

ロック取得に失敗した場合に、強制的にログ出力を行う。

**パラメータ:**
- `formattedMessage` - フォーマット済みのログ
- `context` - ログエントリオブジェクト
- `lockErrorMessage` - ロック取得に失敗した原因のログ

---

### releaseLock

```java
protected void releaseLock(String formattedMessage, LogContext context)
```

ログ出力後に、ロックを解放する。
<p/>
ロックの解放処理は、ロックファイルを削除することによって行う。

**パラメータ:**
- `formattedMessage` - フォーマット済みのログ(本メソッドでは使用していない)
- `context` - ログエントリオブジェクト

---

### getFormattingFailureMessage

```java
private String getFormattingFailureMessage(LogContext context, String defaultMessage, String failureCode, Object messageOptions)
```

障害メッセージを取得する。

**パラメータ:**
- `context` - ログエントリオブジェクト
- `defaultMessage` - デフォルトメッセージ
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

**戻り値:**
障害メッセージ

---

### getFormattingMessage

```java
private String getFormattingMessage(LogLevel level, LogContext context, String defaultMessage)
```

デフォルトフォーマットのメッセージを取得する。

**パラメータ:**
- `level` - ログレベル
- `context` - ログエントリオブジェクト
- `defaultMessage` - メッセージ

**戻り値:**
デフォルトフォーマットのメッセージ

---
