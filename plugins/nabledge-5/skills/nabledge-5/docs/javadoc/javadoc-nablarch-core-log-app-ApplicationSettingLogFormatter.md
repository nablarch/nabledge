# class ApplicationSettingLogFormatter

**パッケージ:** nablarch.core.log.app

---

```java
public class ApplicationSettingLogFormatter
```

アプリケーション設定に関するログフォーマットを行うクラス。
<p/>
主に、{@link nablarch.core.repository.SystemRepository}内の設定値をログ出力する際に使用する。
<p/>
ログ出力対象の設定値は、ログ設定ファイルに設定されたキー値によって決定される。
{@link SystemRepository}に格納されている値が、{@link String}以外のオブジェクトの場合には、文字列への変換({@code toString()})を行った結果の値をログに出力する。
<p/>
以下に例を示す。
<pre>
◆ログ設定ファイル
{@code
# 複数の設定値をログ出力したい場合には、以下のようにカンマ区切りで複数項目を列挙する。
applicationSettingLogFormatter.systemSettingItems = dbUser, dbUrl, threadCount
}
◆ログ出力イメージ
dbUser = [scott]
dbUrl = [jdbc:oracle:thin:@localhost:1521:xe]
threadCount = [3]
</pre>

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### PROPS_PREFIX

```java
public static final String PROPS_PREFIX
```

プロパティ名のプレフィックス

---

### DEFAULT_APP_SETTINGS_FORMAT

```java
private static final String DEFAULT_APP_SETTINGS_FORMAT
```

アプリケーション設定のデフォルトフォーマット定義

---

### DEFAULT_APP_SETTINGS_WITH_DATE_FORMAT

```java
private static final String DEFAULT_APP_SETTINGS_WITH_DATE_FORMAT
```

アプリケーション設定と業務日付のデフォルトフォーマット定義

---

### appLogItem

```java
private Map<String,LogItem<ApplicationSettingLogContext>> appLogItem
```

アプリケーション設定の出力項目

---

### appWithDateLogItem

```java
private Map<String,LogItem<ApplicationSettingLogContext>> appWithDateLogItem
```

アプリケーション設定及び業務日付の出力項目

---

## コンストラクタの詳細

### ApplicationSettingLogFormatter

```java
public ApplicationSettingLogFormatter()
```

コンストラクタ。

---

## メソッドの詳細

### initialize

```java
protected void initialize()
```

初期化処理。

---

### getAppSettingsLogMsg

```java
public String getAppSettingsLogMsg()
```

アプリケーション設定に関するログメッセージを生成する。
<p/>
{@link #getAppSettingsLogFormat}から取得したログフォーマットに従いログメッセージの生成を行う。
ログ出力対象は、アプリケーション設定はプロパティファイル("classpath:app-log.properties")
に記載されている項目となる。<br>
システムプロパティ("nablarch.appLog.filePath")が指定されている場合は、
システムプロパティで指定されたパスを使用する。

**戻り値:**
生成したアプリケーション設定ログ

---

### getAppSettingsWithDateLogMsg

```java
public String getAppSettingsWithDateLogMsg()
```

アプリケーション設定及び業務日付に関するログメッセージを生成する。
<p/>
{@link #getAppSettingsWithDateLogFormat}から取得したログフォーマットに従いログメッセージの生成を行う。
業務日付は{@link BusinessDateUtil#getDate()}を利用して取得する。

**戻り値:**
生成したアプリケーション設定ログ

---

### getAppSettingsLogFormat

```java
protected String getAppSettingsLogFormat()
```

アプリケーション設定ログのフォーマットを取得する。
<p/>
設定ファイル(nablarch.core.log.app.AppLogUtil#getProps())にログフォーマットが指定されている場合は、
そのフォーマットを返却する。
設定されていない場合には、デフォルトのフォーマットを使用する。

**戻り値:**
生成したフォーマット

---

### getAppSettingsLogItems

```java
protected Map<String,LogItem<ApplicationSettingLogContext>> getAppSettingsLogItems()
```

アプリケーション設定用のログ出力項目を生成する。

**戻り値:**
生成したログ出力項目

---

### getAppSettingsWithDateLogFormat

```java
public String getAppSettingsWithDateLogFormat()
```

アプリケーション設定及び業務日付ログ用のログフォーマットを取得する。
<p/>
設定ファイル(nablarch.core.log.app.AppLogUtil#getProps())にログフォーマットが指定されている場合は、
そのフォーマットを返却する。
設定されていない場合には、デフォルトのフォーマットを使用する。

**戻り値:**
生成したフォーマット

---

### getAppSettingsWithDateLogItems

```java
public Map<String,LogItem<ApplicationSettingLogContext>> getAppSettingsWithDateLogItems()
```

アプリケーション設定及び日付出力用のログ出力項目を生成する。

**戻り値:**
ログ出力項目

---
