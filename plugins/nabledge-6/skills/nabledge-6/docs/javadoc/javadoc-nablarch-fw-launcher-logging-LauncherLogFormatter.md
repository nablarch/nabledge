# class LauncherLogFormatter

**パッケージ:** nablarch.fw.launcher.logging

---

```java
public class LauncherLogFormatter
```

{@link nablarch.fw.launcher.Main}で出力するログメッセージをフォーマットするクラス。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### PROPS_PREFIX

```java
public static final String PROPS_PREFIX
```

プロパティ名のプレフィックス

---

### DEFAULT_START_LOG_FORMAT

```java
private static final String DEFAULT_START_LOG_FORMAT
```

開始ログのフォーマット定義

---

### DEFAULT_END_LOG_FORMAT

```java
private static final String DEFAULT_END_LOG_FORMAT
```

終了ログのフォーマット定義

---

### startLogItems

```java
private final Map<String,LogItem<LauncherLogContext>> startLogItems
```

開始ログの出力項目

---

### endLogItems

```java
private final Map<String,LogItem<LauncherLogContext>> endLogItems
```

終了ログの出力項目

---

## メソッドの詳細

### getStartLogMsg

```java
public String getStartLogMsg(CommandLine commandLine)
```

開始ログを生成する。
<p/>
{@link #getStartLogFormat()}から取得したログフォーマットに従いログメッセージ生成を行う。

**パラメータ:**
- `commandLine` - {@link CommandLine コマンドラインオブジェクト}

**戻り値:**
生成した開始ログ

---

### getEndLogMsg

```java
public String getEndLogMsg(int exitCode, long executeTime)
```

終了ログを生成する。
<p/>
{@link #getEndLogFormat()}から取得したログフォーマットに従いログメッセージの生成を行う。

**パラメータ:**
- `exitCode` - 終了コード
- `executeTime` - 処理時間

**戻り値:**
生成した終了ログ

---

### getStartLogFormat

```java
protected String getStartLogFormat()
```

開始ログのフォーマットを取得する。
<p/>
設定ファイル(nablarch.core.log.app.AppLogUtil#getProps())にログフォーマットが指定されている場合は、そのフォーマットを返却する。
設定されていない場合には、デフォルトのフォーマットを使用する。
<p/>
デフォルトのフォーマットは、以下の設定例のようにフォーマット定義を行うことにより変更可能
<pre>
{@code
launcherLogFormatter.startFormat = @@@@ BEGIN @@@@\n\tcommandLineArguments = [$commandLineArguments$]
}
</pre>

**戻り値:**
開始ログのフォーマット

---

### getStartLogItems

```java
protected Map<String,LogItem<LauncherLogContext>> getStartLogItems()
```

開始ログ用のログ出力項目を生成する。

**戻り値:**
生成したログ出力項目

---

### getEndLogItems

```java
protected Map<String,LogItem<LauncherLogContext>> getEndLogItems()
```

終了ログ用のログ出力項目を生成する。

**戻り値:**
生成したログ出力項目

---

### getEndLogFormat

```java
protected String getEndLogFormat()
```

終了ログのフォーマットを取得する。
<p/>
設定ファイル(nablarch.core.log.app.AppLogUtil#getProps())にログフォーマットが指定されている場合は、
そのフォーマットを返却する。
設定されていない場合には、デフォルトのフォーマットを使用する。
<p/>
デフォルトのフォーマットは、以下の設定例のようにフォーマット定義を行うことにより変更可能
<pre>
{@code
launcherLogFormatter.endFormat = @@@@ END @@@@ execute time(ms) = [$executeTime$], exit code = [$exitCode$]
}
</pre>

**戻り値:**
開始ログのフォーマット

---
