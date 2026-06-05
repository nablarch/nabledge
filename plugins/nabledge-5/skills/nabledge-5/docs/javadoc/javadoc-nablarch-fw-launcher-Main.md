# class Main

**パッケージ:** nablarch.fw.launcher

**継承階層:**
```
java.lang.Object
  └─ HandlerQueueManager<Main>
      └─ nablarch.fw.launcher.Main
```

**実装されたインタフェース:**
- Handler<CommandLine,Integer>

---

```java
public class Main
extends HandlerQueueManager<Main>
implements Handler<CommandLine,Integer>
```

本フレームワークの起動シーケンスの起点となるクラス。
<p/>
本クラスをjavaコマンドから直接起動することで、以下の処理を行う。
<pre>
1. コマンドライン引数のパース。
2. コンポーネント設定ファイル（xml)の読み込みとハンドラー構成の初期化
3. ハンドラーキューに対する後続処理の委譲。
4. 終了/エラー処理。
   (結果コードはハンドラキューの戻り値、または送出された例外をもとに設定する。)
</pre>
<p/>
以下は、本クラスの使用例である。
(起動オプションに設定した値は、{@link CommandLine}オブジェクトから取得できる。)
<p/>
<b>起動コマンドの例</b>
<pre/>
java                                                 \
    -server                                          \
    -Xmx128m                                         \
    -Dsample=100                                     \
nablarch.fw.launcher.Main                            \
    -diConfig    file:./batch-config.xml             \
    -requestPath admin.DataUnloadBatchAction/BC0012  \
    -userId      testUser                            \
    -namedParam  value                               \
    value1
</pre>
<b>起動コマンドの説明</b><br/>
<pre>

<b>アプリケーション引数（JVMへの設定である起動コマンドの説明は行わない）</b>

          -Dsample      コンポーネント設定ファイル中の埋め込みパラメータの値。例では、${sample}に100が設定される。

<b>Mainクラスへの引数</b>

  (必須)  -diConfig     コンポーネント設定ファイルのファイルパス。クラスパス配下のxmlファイルを指定。
  (必須)  -requestPath  実行対象のアクションハンドラクラス名/リクエストIDを指定。
  (必須)  -userId       プロセスの実行権限ユーザID。セッション変数とスレッドコンテキストに保持される。
          -namedParam   名前付きパラメータ。{@link CommandLine}に使用される属性値を指定。
          value1        無名パラメータ。{@link CommandLine}に使用される属性値を指定。
</pre>

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー。

---

### handlerQueue

```java
private List<Handler> handlerQueue
```

ハンドラ({@link Handler})キュー

---

### UNKNOWN_ERROR

```java
private static final int UNKNOWN_ERROR
```

既定のエラーコード

---

## メソッドの詳細

### getHandlerQueue

```java
public List<Handler> getHandlerQueue()
```

---

### main

```java
public static void main(String args)
```

メインメソッド。
<p/>
本メソッドでは、以下の内容をログ出力する。
<ul>
<li>起動時</li>
起動オプションや、起動引数(詳細は、{@link LauncherLogUtil#getStartLogMsg(CommandLine)}を参照)
<li>終了時</li>
終了コードや処理時間(詳細は、{@link LauncherLogUtil#getEndLogMsg(int, long)}を参照})
</ul>
及び処理終了時

**パラメータ:**
- `args` - コマンドライン引数

---

### handle

```java
public Integer handle(CommandLine commandLine, ExecutionContext context)
```

{@inheritDoc}
この実装では、ハンドラキューに後続処理を委譲し、その処理結果から
このプロセスの終了コードを算出して返す。

---

### execute

```java
public static int execute(CommandLine commandLine)
```

バッチを実行する。
<p/>
{@link #handle(CommandLine, ExecutionContext)}に処理を委譲して結果を返す。

**パラメータ:**
- `commandLine` - 起動オプション

**戻り値:**
終了コード

---

### setupExecutionContext

```java
protected Main setupExecutionContext(CommandLine commandLine, ExecutionContext context)
```

バッチコントローラ起動前準備を行う。<br/>
実行コンテキストを生成し、以下の処理を行う。
<ul>
    <li>コンポーネント設定ファイルに定義したハンドラキューの設定</li>
    <li>{@link DataReader}の設定</li>
    <li>{@link DataReaderFactory}の設定</li>
    <li>ディスパッチハンドラの設定</li>
    <li>セッションスコープにプロセスの実行権限ユーザIDと、起動オプションのマップを設定</li>
</ul>

**パラメータ:**
- `commandLine` - 起動オプション
- `context` - 実行コンテキスト

**戻り値:**
初期化されたコントローラ

---

### setUpSystemRepository

```java
protected void setUpSystemRepository(String configFilePath)
```

コンポーネント設定ファイルの設定にしたがって、システムリポジトリの初期化を行う。

**パラメータ:**
- `configFilePath` - コンポーネント設定ファイルのパス

---

### initializeLog

```java
protected void initializeLog()
```

各種ログの初期化を行う。

---

### outputAppSettingsLog

```java
protected void outputAppSettingsLog()
```

アプリケーション設定のログを出力する。

---
